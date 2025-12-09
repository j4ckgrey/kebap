import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kebap/jellyfin/jellyfin_open_api.swagger.dart';
import 'package:kebap/models/tmdb_metadata_model.dart';
import 'package:kebap/providers/api_provider.dart';
import 'package:kebap/providers/effective_baklava_config_provider.dart';
import 'package:kebap/providers/baklava_requests_provider.dart';
import 'package:kebap/providers/tmdb_direct_service.dart';

final baklavaMetadataProvider =
    StateNotifierProvider<BaklavaMetadataNotifier, BaklavaMetadataState>((ref) {
  return BaklavaMetadataNotifier(ref);
});

class BaklavaMetadataState {
  final TMDBMetadata? metadata;
  final TMDBCredits? credits;
  final List<TMDBReview>? reviews;
  final bool loading;
  final String? error;
  final bool inLibrary;
  final String? existingRequestId;
  final String? jellyfinItemId;
  final String? requestStatus;
  final String? requestUsername;

  BaklavaMetadataState({
    this.metadata,
    this.credits,
    this.reviews,
    this.loading = false,
    this.error,
    this.inLibrary = false,
    this.existingRequestId,
    this.jellyfinItemId,
    this.requestStatus,
    this.requestUsername,
  });

  BaklavaMetadataState copyWith({
    TMDBMetadata? metadata,
    TMDBCredits? credits,
    List<TMDBReview>? reviews,
    bool? loading,
    String? error,
    bool? inLibrary,
    Object? existingRequestId = _sentinel, // Use sentinel to detect explicit null
    Object? jellyfinItemId = _sentinel,
    Object? requestStatus = _sentinel,
    Object? requestUsername = _sentinel,
  }) {
    return BaklavaMetadataState(
      metadata: metadata ?? this.metadata,
      credits: credits ?? this.credits,
      reviews: reviews ?? this.reviews,
      loading: loading ?? this.loading,
      error: error ?? this.error,
      inLibrary: inLibrary ?? this.inLibrary,
      existingRequestId: existingRequestId == _sentinel 
          ? this.existingRequestId 
          : existingRequestId as String?,
      jellyfinItemId: jellyfinItemId == _sentinel 
          ? this.jellyfinItemId 
          : jellyfinItemId as String?,
      requestStatus: requestStatus == _sentinel 
          ? this.requestStatus 
          : requestStatus as String?,
      requestUsername: requestUsername == _sentinel 
          ? this.requestUsername 
          : requestUsername as String?,
    );
  }
}

// Sentinel value to differentiate between "not passed" and "explicitly null"
const _sentinel = Object();

class BaklavaMetadataNotifier extends StateNotifier<BaklavaMetadataState> {
  final Ref ref;

  BaklavaMetadataNotifier(this.ref) : super(BaklavaMetadataState());

  /// Fetch TMDB metadata for an item
  Future<TMDBMetadata?> fetchTMDBMetadata({
    String? tmdbId,
    String? imdbId,
    String? itemType,
    String? title,
    int? year,
    bool includeCredits = true,
    bool includeReviews = true,
  }) async {
    state = state.copyWith(
      loading: true, 
      error: null,
      inLibrary: false, // Reset library status
      existingRequestId: null, // Reset request status
      requestStatus: null,
      requestUsername: null,
    );

    try {
      Map<String, dynamic> data;

      // Try Baklava first
      try {
        final service = ref.read(baklavaServiceProvider);
        final response = await service.fetchTMDBMetadata(
          tmdbId: tmdbId,
          imdbId: imdbId,
          itemType: itemType,
          title: title,
          year: year,
          includeCredits: includeCredits,
          includeReviews: includeReviews,
        );

        if (response.isSuccessful && response.body != null) {
          data = response.body!;
        } else {
          throw Exception('Baklava returned ${response.statusCode}');
        }
      } catch (baklavaError) {
        // Baklava failed, try direct TMDB API with local key
        final effectiveConfig = await ref.read(effectiveBaklavaConfigProvider.future);
        final tmdbApiKey = effectiveConfig.tmdbApiKey;
        
        if (tmdbApiKey == null || tmdbApiKey.isEmpty) {
          state = state.copyWith(
            loading: false,
            error: 'Baklava unavailable and no TMDB API key configured',
          );
          return null;
        }

        data = await TMDBDirectService.fetchMetadata(
          apiKey: tmdbApiKey,
          tmdbId: tmdbId,
          imdbId: imdbId,
          itemType: itemType,
          title: title,
          year: year,
          includeCredits: includeCredits,
          includeReviews: includeReviews,
        );
      }

      // Parse the response data
      final metadata = TMDBMetadata.fromJson(data['main'] ?? data);
      final credits = data['credits'] != null
          ? TMDBCredits.fromJson(data['credits'] as Map<String, dynamic>)
          : null;
      final reviews = data['reviews'] != null && data['reviews']['results'] != null
          ? (data['reviews']['results'] as List)
              .map((r) => TMDBReview.fromJson(r as Map<String, dynamic>))
              .toList()
          : null;

      state = state.copyWith(
        metadata: metadata,
        credits: credits,
        reviews: reviews,
        loading: false,
      );

      return metadata;
    } catch (e) {
      state = state.copyWith(
        loading: false,
        error: 'Error fetching metadata: $e',
      );
      return null;
    }
  }

  /// Check if item exists in Jellyfin library and return its ID
  Future<String?> checkLibraryStatus(
      String? imdbId, String? tmdbId, String itemType) async {
    try {
      final service = ref.read(baklavaServiceProvider);
      
      final response = await service.checkLibraryStatus(
        imdbId: imdbId,
        tmdbId: tmdbId,
        itemType: itemType,
      );

      if (response.isSuccessful && response.body != null) {
        final data = response.body!;
        final inLibrary = data['inLibrary'] as bool? ?? false;
        
        // Handle existing request
        String? requestId;
        String? requestStatus;
        String? requestUsername;

        if (data['existingRequest'] != null) {
          final req = data['existingRequest'] as Map<String, dynamic>;
          requestId = req['id'] as String?;
          requestStatus = req['status'] as String?;
          requestUsername = req['username'] as String?;
        }

        // If in library, try to find the Jellyfin ID so we can navigate to it
        String? foundItemId;
        if (inLibrary) {
          try {
            final api = ref.read(jellyApiProvider);
            // Search for item by IMDB ID or TMDB ID to get the Jellyfin ID
            String? searchTerm;
            if (imdbId != null && imdbId.isNotEmpty) {
              searchTerm = imdbId;
            } else if (tmdbId != null && tmdbId.isNotEmpty) {
              searchTerm = 'tmdb_$tmdbId';
            }

            if (searchTerm != null) {
              final searchResponse = await api.itemsGet(
                searchTerm: searchTerm,
                recursive: true,
                limit: 1,
                includeItemTypes: itemType.toLowerCase().contains('series') ? [BaseItemKind.series] : [BaseItemKind.movie],
              );
              if (searchResponse.body?.items.isNotEmpty ?? false) {
                foundItemId = searchResponse.body!.items.first.id;
              }
            }
          } catch (e) {
            print('DEBUG: Failed to fetch Jellyfin ID after confirmed in library: $e');
          }
        }
        
        state = state.copyWith(
          inLibrary: inLibrary,
          existingRequestId: requestId,
          jellyfinItemId: foundItemId,
          requestStatus: requestStatus,
          requestUsername: requestUsername,
        );
        
        print('DEBUG: checkLibraryStatus result: inLibrary=$inLibrary, requestId=$requestId, jellyfinId=$foundItemId, status=$requestStatus');
        return foundItemId;
      }
      return null;
    } catch (e) {
      print('DEBUG: checkLibraryStatus error: $e');
      return null;
    }
  }

  /// Manually set library status (e.g. after successful import)
  void setLibraryStatus(String itemId) {
    print('DEBUG: setLibraryStatus called with $itemId');
    state = state.copyWith(
      inLibrary: true,
      jellyfinItemId: itemId,
    );
  }

  /// Fetch external IDs (IMDB ID from TMDB ID)
  Future<TMDBExternalIds?> fetchExternalIds(
      String tmdbId, String mediaType) async {
    try {
      // Try Baklava first
      try {
        final service = ref.read(baklavaServiceProvider);
        final response = await service.fetchExternalIds(tmdbId, mediaType);

        if (response.isSuccessful && response.body != null) {
          return TMDBExternalIds.fromJson(response.body!);
        }
        throw Exception('Baklava failed');
      } catch (baklavaError) {
        // Fallback to direct TMDB API
        final effectiveConfig = await ref.read(effectiveBaklavaConfigProvider.future);
        final tmdbApiKey = effectiveConfig.tmdbApiKey;
        
        if (tmdbApiKey != null && tmdbApiKey.isNotEmpty) {
          final data = await TMDBDirectService.fetchExternalIds(
            apiKey: tmdbApiKey,
            tmdbId: tmdbId,
            mediaType: mediaType,
          );
          return TMDBExternalIds.fromJson(data);
        }
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Import item to library via Gelato
  Future<String?> importToLibrary(String imdbId, String itemType) async {
    try {
      final service = ref.read(baklavaServiceProvider);
      final response = await service.importToLibrary(imdbId, itemType);
      
      if (response.isSuccessful) {
        return response.body;
      }
      return null;
    } catch (e) {
      print('DEBUG: importToLibrary error: $e');
      return null;
    }
  }

  void reset() {
    state = BaklavaMetadataState();
  }
}
