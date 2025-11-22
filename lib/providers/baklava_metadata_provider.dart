import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kebap/models/tmdb_metadata_model.dart';
import 'package:kebap/providers/api_provider.dart';
import 'package:kebap/providers/baklava_requests_provider.dart';

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

  BaklavaMetadataState({
    this.metadata,
    this.credits,
    this.reviews,
    this.loading = false,
    this.error,
    this.inLibrary = false,
    this.existingRequestId,
  });

  BaklavaMetadataState copyWith({
    TMDBMetadata? metadata,
    TMDBCredits? credits,
    List<TMDBReview>? reviews,
    bool? loading,
    String? error,
    bool? inLibrary,
    String? existingRequestId,
  }) {
    return BaklavaMetadataState(
      metadata: metadata ?? this.metadata,
      credits: credits ?? this.credits,
      reviews: reviews ?? this.reviews,
      loading: loading ?? this.loading,
      error: error ?? this.error,
      inLibrary: inLibrary ?? this.inLibrary,
      existingRequestId: existingRequestId ?? this.existingRequestId,
    );
  }
}

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
    state = state.copyWith(loading: true, error: null);

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
        final data = response.body!;
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
      } else {
        state = state.copyWith(
          loading: false,
          error: 'Failed to fetch metadata: ${response.statusCode}',
        );
        return null;
      }
    } catch (e) {
      state = state.copyWith(
        loading: false,
        error: 'Error fetching metadata: $e',
      );
      return null;
    }
  }

  /// Check if item exists in Jellyfin library
  Future<bool> checkLibraryStatus(
      String? imdbId, String? tmdbId, String itemType) async {
    try {
      final api = ref.read(jellyApiProvider);

      // Search for item by IMDB ID or TMDB ID
      String? searchTerm;
      if (imdbId != null && imdbId.isNotEmpty) {
        searchTerm = imdbId;
      } else if (tmdbId != null && tmdbId.isNotEmpty) {
        searchTerm = 'tmdb_$tmdbId';
      }

      if (searchTerm == null) return false;

      final response = await api.itemsGet(
        searchTerm: searchTerm,
        recursive: true,
        limit: 1,
      );

      final inLibrary = (response.body?.items.isNotEmpty ?? false);
      state = state.copyWith(inLibrary: inLibrary);

      return inLibrary;
    } catch (e) {
      return false;
    }
  }

  /// Fetch external IDs (IMDB ID from TMDB ID)
  Future<TMDBExternalIds?> fetchExternalIds(
      String tmdbId, String mediaType) async {
    try {
      final service = ref.read(baklavaServiceProvider);
      final response =
          await service.fetchExternalIds(tmdbId, mediaType);

      if (response.isSuccessful && response.body != null) {
        return TMDBExternalIds.fromJson(response.body!);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Import item to library via Gelato
  Future<bool> importToLibrary(String imdbId, String itemType) async {
    try {
      final service = ref.read(baklavaServiceProvider);
      final response = await service.importToLibrary(imdbId, itemType);

      return response.isSuccessful;
    } catch (e) {
      return false;
    }
  }

  void reset() {
    state = BaklavaMetadataState();
  }
}
