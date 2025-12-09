import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'package:kebap/models/baklava_config_model.dart';
import 'package:kebap/models/media_request_model.dart';
import 'package:kebap/providers/api_provider.dart';

class BaklavaService {
  BaklavaService(this.ref);

  final Ref ref;

  static const String _baseRoute = '/api/baklava/requests';

  /// Fetch Baklava plugin configuration
  Future<Response<BaklavaConfig>> fetchConfig() async {
    try {
      final api = ref.read(jellyApiProvider).api;
      final serverUrl = ref.read(serverUrlProvider);

      if (serverUrl == null || serverUrl.isEmpty) {
        throw Exception('Server URL not available');
      }

      final url = '${serverUrl}api/baklava/config';
      final request = Request('GET', Uri.parse(url), Uri.parse(serverUrl));

      final response = await api.client.send(request);

      if (response.isSuccessful && response.body != null) {
        final dynamic bodyData = response.body is String 
            ? jsonDecode(response.body as String)
            : response.body;
            
        final config = BaklavaConfig.fromJson(bodyData as Map<String, dynamic>);
        return Response(response.base, config);
      }

      // Return default config if request fails
      return Response(response.base, const BaklavaConfig());
    } catch (e) {
      // Return default config on error
      final dummyResponse = Response(
        http.Response('{}', 500),
        const BaklavaConfig(),
      );
      return dummyResponse;
    }
  }

  /// Update Baklava plugin configuration (admin only)
  /// Note: Due to a server-side bug, we must fetch and include the current tmdbApiKey
  /// to prevent it from being overwritten with null
  Future<Response<void>> updateConfig({
    bool? disableNonAdminRequests,
    bool? showReviewsCarousel,
    bool? forceTVClientLocalSearch,
    String? versionUi,
    String? audioUi,
    String? subtitleUi,
  }) async {
    try {
      final api = ref.read(jellyApiProvider).api;
      final serverUrl = ref.read(serverUrlProvider);

      if (serverUrl == null || serverUrl.isEmpty) {
        throw Exception('Server URL not available');
      }

      // WORKAROUND: Fetch current config to preserve tmdbApiKey from being overwritten
      // The server unconditionally overwrites tmdbApiKey even when not provided
      String? currentTmdbApiKey;
      try {
        final currentConfig = await fetchConfig();
        if (currentConfig.isSuccessful && currentConfig.body != null) {
          currentTmdbApiKey = currentConfig.body!.tmdbApiKey;
        }
      } catch (_) {
        // Ignore errors, proceed without tmdbApiKey
      }

      final body = <String, dynamic>{};
      // Include current tmdbApiKey to prevent server from overwriting it
      if (currentTmdbApiKey != null && currentTmdbApiKey.isNotEmpty) {
        body['tmdbApiKey'] = currentTmdbApiKey;
      }
      if (disableNonAdminRequests != null) {
        body['disableNonAdminRequests'] = disableNonAdminRequests;
      }
      if (showReviewsCarousel != null) {
        body['showReviewsCarousel'] = showReviewsCarousel;
      }
      if (forceTVClientLocalSearch != null) {
        body['forceTVClientLocalSearch'] = forceTVClientLocalSearch;
      }
      if (versionUi != null) body['versionUi'] = versionUi;
      if (audioUi != null) body['audioUi'] = audioUi;
      if (subtitleUi != null) body['subtitleUi'] = subtitleUi;

      final cleanServerUrl = serverUrl.endsWith('/') 
          ? serverUrl.substring(0, serverUrl.length - 1) 
          : serverUrl;
      final url = '$cleanServerUrl/api/baklava/config';
      
      final request = Request(
        'PUT',
        Uri.parse(url),
        Uri.parse(serverUrl),
        body: body,
        headers: {'Content-Type': 'application/json'},
      );

      final response = await api.client.send(request);

      if (!response.isSuccessful) {
        throw Exception('Failed to update config: ${response.statusCode}');
      }

      return Response(response.base, null);
    } catch (e) {
      throw Exception('Failed to update config: $e');
    }
  }

  /// Fetch all media requests from Baklava plugin
  Future<Response<List<MediaRequest>>> fetchRequests() async {
    try {
      final api = ref.read(jellyApiProvider).api;
      final serverUrl = ref.read(serverUrlProvider);

      if (serverUrl == null || serverUrl.isEmpty) {
        throw Exception('Server URL not available');
      }

      final cleanServerUrl = serverUrl.endsWith('/') 
          ? serverUrl.substring(0, serverUrl.length - 1) 
          : serverUrl;
      final url = '$cleanServerUrl$_baseRoute';
      final request = Request('GET', Uri.parse(url), Uri.parse(serverUrl));

      final response = await api.client.send(request);

      if (response.isSuccessful && response.body != null) {
        // Parse JSON response
        final dynamic bodyData = response.body is String 
            ? jsonDecode(response.body as String)
            : response.body;
            
        final List<dynamic> jsonList = bodyData as List<dynamic>;
        
        final requests = jsonList
            .map((json) => MediaRequest.fromJson(json as Map<String, dynamic>))
            .toList();
        return Response(response.base, requests);
      }

      return Response(response.base, []);
    } catch (e) {
      // Log error for debugging if needed
      throw Exception('Failed to fetch requests: $e');
    }
  }

  /// Create a new media request
  Future<Response<MediaRequest>> createRequest(MediaRequest request) async {
    try {
      final api = ref.read(jellyApiProvider).api;
      final serverUrl = ref.read(serverUrlProvider);

      if (serverUrl == null || serverUrl.isEmpty) {
        throw Exception('Server URL not available');
      }

      final cleanServerUrl = serverUrl.endsWith('/') 
          ? serverUrl.substring(0, serverUrl.length - 1) 
          : serverUrl;
      final url = '$cleanServerUrl$_baseRoute';
      final chopperRequest = Request(
        'POST',
        Uri.parse(url),
        Uri.parse(serverUrl),
        body: request.toJson(),
        headers: {'Content-Type': 'application/json'},
      );

      final response = await api.client.send(chopperRequest);

      if (response.isSuccessful && response.body != null) {
        final dynamic bodyData = response.body is String 
            ? jsonDecode(response.body as String)
            : response.body;
            
        final createdRequest =
            MediaRequest.fromJson(bodyData as Map<String, dynamic>);
        return Response(response.base, createdRequest);
      }

      throw Exception('Failed to create request: ${response.statusCode}');
    } catch (e) {
      throw Exception('Failed to create request: $e');
    }
  }

  /// Update request status (approve/reject)
  Future<Response<void>> updateRequestStatus({
    required String requestId,
    required String status,
    String? approvedBy,
  }) async {
    try {
      final api = ref.read(jellyApiProvider).api;
      final serverUrl = ref.read(serverUrlProvider);

      if (serverUrl == null || serverUrl.isEmpty) {
        throw Exception('Server URL not available');
      }

      final cleanServerUrl = serverUrl.endsWith('/') 
          ? serverUrl.substring(0, serverUrl.length - 1) 
          : serverUrl;
      final url = '$cleanServerUrl$_baseRoute/$requestId';
      final body = {
        'status': status,
        if (approvedBy != null) 'approvedBy': approvedBy,
      };

      final request = Request(
        'PUT',
        Uri.parse(url),
        Uri.parse(serverUrl),
        body: body,
        headers: {'Content-Type': 'application/json'},
      );

      final response = await api.client.send(request);

      if (!response.isSuccessful) {
        throw Exception('Failed to update request: ${response.statusCode}');
      }

      return Response(response.base, null);
    } catch (e) {
      throw Exception('Failed to update request: $e');
    }
  }

  /// Delete a media request
  Future<Response<void>> deleteRequest(String requestId) async {
    try {
      final api = ref.read(jellyApiProvider).api;
      final serverUrl = ref.read(serverUrlProvider);

      if (serverUrl == null || serverUrl.isEmpty) {
        throw Exception('Server URL not available');
      }

      final cleanServerUrl = serverUrl.endsWith('/') 
          ? serverUrl.substring(0, serverUrl.length - 1) 
          : serverUrl;
      final url = '$cleanServerUrl$_baseRoute/$requestId';
      final request = Request('DELETE', Uri.parse(url), Uri.parse(serverUrl));

      final response = await api.client.send(request);

      if (!response.isSuccessful) {
        throw Exception('Failed to delete request: ${response.statusCode}');
      }

      return Response(response.base, null);
    } catch (e) {
      throw Exception('Failed to delete request: $e');
    }
  }

  /// Clean up invalid requests (admin only)
  Future<Response<Map<String, dynamic>>> cleanupRequests() async {
    try {
      final api = ref.read(jellyApiProvider).api;
      final serverUrl = ref.read(serverUrlProvider);

      if (serverUrl == null || serverUrl.isEmpty) {
        throw Exception('Server URL not available');
      }

      final cleanServerUrl = serverUrl.endsWith('/') 
          ? serverUrl.substring(0, serverUrl.length - 1) 
          : serverUrl;
      final url = '$cleanServerUrl$_baseRoute/cleanup';
      final request = Request('POST', Uri.parse(url), Uri.parse(serverUrl));

      final response = await api.client.send(request);

      if (response.isSuccessful && response.body != null) {
        return Response(
            response.base, response.body as Map<String, dynamic>);
      }

      throw Exception('Failed to cleanup requests: ${response.statusCode}');
    } catch (e) {
      throw Exception('Failed to cleanup requests: $e');
    }
  }

  /// Fetch TMDB metadata for an item
  Future<Response<Map<String, dynamic>>> fetchTMDBMetadata({
    String? tmdbId,
    String? imdbId,
    String? itemType,
    String? title,
    int? year,
    bool includeCredits = true,
    bool includeReviews = false,
  }) async {
    try {
      final api = ref.read(jellyApiProvider).api;
      final serverUrl = ref.read(serverUrlProvider);

      if (serverUrl == null || serverUrl.isEmpty) {
        throw Exception('Server URL not available');
      }

      final params = <String, String>{};
      if (tmdbId != null) params['tmdbId'] = tmdbId;
      if (imdbId != null) params['imdbId'] = imdbId;
      if (itemType != null) params['itemType'] = itemType;
      if (title != null) params['title'] = title;
      if (year != null) params['year'] = year.toString();
      params['includeCredits'] = includeCredits.toString();
      params['includeReviews'] = includeReviews.toString();

      final queryString = params.entries.map((e) => '${e.key}=${Uri.encodeComponent(e.value)}').join('&');
      final cleanServerUrl = serverUrl.endsWith('/') 
          ? serverUrl.substring(0, serverUrl.length - 1) 
          : serverUrl;
      final url = '$cleanServerUrl/api/baklava/metadata/tmdb?$queryString';

      final request = Request('GET', Uri.parse(url), Uri.parse(serverUrl));
      final response = await api.client.send(request);

      if (response.isSuccessful && response.body != null) {
        return Response(response.base, response.body as Map<String, dynamic>);
      }

      throw Exception('Failed to fetch TMDB metadata: ${response.statusCode}');
    } catch (e) {
      throw Exception('Failed to fetch TMDB metadata: $e');
    }
  }

  /// Fetch external IDs (IMDB ID from TMDB ID)
  Future<Response<Map<String, dynamic>>> fetchExternalIds(
    String tmdbId,
    String mediaType,
  ) async {
    try {
      final api = ref.read(jellyApiProvider).api;
      final serverUrl = ref.read(serverUrlProvider);

      if (serverUrl == null || serverUrl.isEmpty) {
        throw Exception('Server URL not available');
      }

      final url = '$serverUrl/api/baklava/metadata/external-ids?tmdbId=$tmdbId&mediaType=$mediaType';
      final request = Request('GET', Uri.parse(url), Uri.parse(serverUrl));
      final response = await api.client.send(request);

      if (response.isSuccessful && response.body != null) {
        return Response(response.base, response.body as Map<String, dynamic>);
      }

      throw Exception('Failed to fetch external IDs: ${response.statusCode}');
    } catch (e) {
      throw Exception('Failed to fetch external IDs: $e');
    }
  }


  /// Check library status via Baklava
  Future<Response<Map<String, dynamic>>> checkLibraryStatus({
    String? imdbId,
    String? tmdbId,
    required String itemType,
    String? jellyfinId,
  }) async {
    try {
      final api = ref.read(jellyApiProvider).api;
      final serverUrl = ref.read(serverUrlProvider);

      if (serverUrl == null || serverUrl.isEmpty) {
        throw Exception('Server URL not available');
      }

      final params = <String, String>{};
      if (imdbId != null) params['imdbId'] = imdbId;
      if (tmdbId != null) params['tmdbId'] = tmdbId;
      params['itemType'] = itemType;
      if (jellyfinId != null) params['jellyfinId'] = jellyfinId;

      final queryString = params.entries.map((e) => '${e.key}=${Uri.encodeComponent(e.value)}').join('&');
      final cleanServerUrl = serverUrl.endsWith('/') 
          ? serverUrl.substring(0, serverUrl.length - 1) 
          : serverUrl;
      final url = '$cleanServerUrl/api/baklava/metadata/library-status?$queryString';

      final request = Request('GET', Uri.parse(url), Uri.parse(serverUrl));
      final response = await api.client.send(request);

      if (response.isSuccessful && response.body != null) {
        return Response(response.base, response.body as Map<String, dynamic>);
      }

      throw Exception('Failed to check library status: ${response.statusCode}');
    } catch (e) {
      throw Exception('Failed to check library status: $e');
    }
  }

  /// Get media streams via Baklava (includes ffprobe fallback)
  Future<Response<Map<String, dynamic>>> getMediaStreams({
    required String itemId,
    String? mediaSourceId,
  }) async {
    try {
      final api = ref.read(jellyApiProvider).api;
      final serverUrl = ref.read(serverUrlProvider);

      if (serverUrl == null || serverUrl.isEmpty) {
        throw Exception('Server URL not available');
      }

      final params = <String, String>{'itemId': itemId};
      if (mediaSourceId != null) params['mediaSourceId'] = mediaSourceId;

      final queryString = params.entries.map((e) => '${e.key}=${Uri.encodeComponent(e.value)}').join('&');
      final cleanServerUrl = serverUrl.endsWith('/') 
          ? serverUrl.substring(0, serverUrl.length - 1) 
          : serverUrl;
      final url = '$cleanServerUrl/api/baklava/metadata/streams?$queryString';

      final request = Request('GET', Uri.parse(url), Uri.parse(serverUrl));
      final response = await api.client.send(request);

      if (response.isSuccessful && response.body != null) {
        final dynamic bodyData = response.body is String 
            ? jsonDecode(response.body as String)
            : response.body;
        return Response(response.base, bodyData as Map<String, dynamic>);
      }

      throw Exception('Failed to get media streams: ${response.statusCode}');
    } catch (e) {
      throw Exception('Failed to get media streams: $e');
    }
  }

  /// Import item to library via Gelato
  Future<Response<String>> importToLibrary(String imdbId, String itemType) async {
    try {
      final api = ref.read(jellyApiProvider).api;
      final serverUrl = ref.read(serverUrlProvider);

      if (serverUrl == null || serverUrl.isEmpty) {
        throw Exception('Server URL not available');
      }

      final isSeries = itemType.toLowerCase().contains('series') || itemType.toLowerCase() == 'tv';
      // Use the direct Gelato endpoint as seen in RequestsController.cs and GelatoApiController.cs
      // Note: GelatoApiController defines [HttpGet("meta/{stremioMetaType}/{Id}")]
      // and RequestsController uses /gelato/meta/{type}/{id}
      final endpoint = isSeries ? '/gelato/meta/tv/$imdbId' : '/gelato/meta/movie/$imdbId';
      
      final cleanServerUrl = serverUrl.endsWith('/') 
          ? serverUrl.substring(0, serverUrl.length - 1) 
          : serverUrl;
      final url = '$cleanServerUrl$endpoint';

      // Use GET as per GelatoApiController definition
      final request = Request('GET', Uri.parse(url), Uri.parse(serverUrl));
      final response = await api.client.send(request);

      if (!response.isSuccessful) {
        throw Exception('Failed to import: ${response.statusCode}');
      }

      return Response(response.base, response.bodyString);
    } catch (e) {
      throw Exception('Failed to import: $e');
    }
  }
}
