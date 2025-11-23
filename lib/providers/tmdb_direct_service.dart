import 'dart:convert';
import 'package:http/http.dart' as http;

/// Direct TMDB API service for when Baklava plugin is disabled
class TMDBDirectService {
  static const String _baseUrl = 'https://api.themoviedb.org/3';

  /// Fetch TMDB metadata directly from TMDB API
  static Future<Map<String, dynamic>> fetchMetadata({
    required String apiKey,
    String? tmdbId,
    String? imdbId,
    String? itemType,
    String? title,
    int? year,
    bool includeCredits = true,
    bool includeReviews = false,
  }) async {
    if (apiKey.isEmpty) {
      throw Exception('TMDB API key is required');
    }

    final mediaType = _getMediaType(itemType);
    Map<String, dynamic>? mainData;
    
    // Get main metadata
    if (tmdbId != null) {
      mainData = await _fetchById(apiKey, tmdbId, mediaType);
    } else if (imdbId != null) {
      mainData = await _fetchByExternalId(apiKey, imdbId, mediaType);
    } else if (title != null) {
      mainData = await _searchByTitle(apiKey, title, year, mediaType);
    } else {
      throw Exception('Either tmdbId, imdbId, or title must be provided');
    }

    if (mainData == null) {
      throw Exception('No metadata found');
    }

    final result = <String, dynamic>{'main': mainData};

    // Get the TMDB ID from the main data
    final id = mainData['id']?.toString();
    if (id != null) {
      // Fetch credits if requested
      if (includeCredits) {
        try {
          final credits = await _fetchCredits(apiKey, id, mediaType);
          if (credits != null) {
            result['credits'] = credits;
          }
        } catch (e) {
          // Continue even if credits fail
        }
      }

      // Fetch reviews if requested
      if (includeReviews) {
        try {
          final reviews = await _fetchReviews(apiKey, id, mediaType);
          if (reviews != null) {
            result['reviews'] = reviews;
          }
        } catch (e) {
          // Continue even if reviews fail
        }
      }
    }

    return result;
  }

  /// Fetch external IDs (IMDB from TMDB)
  static Future<Map<String, dynamic>> fetchExternalIds({
    required String apiKey,
    required String tmdbId,
    required String mediaType,
  }) async {
    final type = mediaType.toLowerCase() == 'tv' ? 'tv' : 'movie';
    final url = '$_baseUrl/$type/$tmdbId/external_ids?api_key=$apiKey';
    
    final response = await http.get(Uri.parse(url));
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    
    throw Exception('Failed to fetch external IDs: ${response.statusCode}');
  }

  // Private helper methods

  static String _getMediaType(String? itemType) {
    if (itemType == null) return 'movie';
    final lower = itemType.toLowerCase();
    if (lower.contains('series') || lower == 'tv') return 'tv';
    return 'movie';
  }

  static Future<Map<String, dynamic>?> _fetchById(
    String apiKey,
    String tmdbId,
    String mediaType,
  ) async {
    final url = '$_baseUrl/$mediaType/$tmdbId?api_key=$apiKey';
    final response = await http.get(Uri.parse(url));
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    
    return null;
  }

  static Future<Map<String, dynamic>?> _fetchByExternalId(
    String apiKey,
    String imdbId,
    String mediaType,
  ) async {
    final url = '$_baseUrl/find/$imdbId?api_key=$apiKey&external_source=imdb_id';
    final response = await http.get(Uri.parse(url));
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final results = mediaType == 'tv' 
          ? data['tv_results'] as List?
          : data['movie_results'] as List?;
      
      if (results != null && results.isNotEmpty) {
        final firstResult = results.first as Map<String, dynamic>;
        final id = firstResult['id']?.toString();
        if (id != null) {
          return _fetchById(apiKey, id, mediaType);
        }
      }
    }
    
    return null;
  }

  static Future<Map<String, dynamic>?> _searchByTitle(
    String apiKey,
    String title,
    int? year,
    String mediaType,
  ) async {
    final endpoint = mediaType == 'tv' ? 'search/tv' : 'search/movie';
    var url = '$_baseUrl/$endpoint?api_key=$apiKey&query=${Uri.encodeComponent(title)}';
    
    if (year != null) {
      final yearParam = mediaType == 'tv' ? 'first_air_date_year' : 'year';
      url += '&$yearParam=$year';
    }
    
    final response = await http.get(Uri.parse(url));
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final results = data['results'] as List?;
      
      if (results != null && results.isNotEmpty) {
        final firstResult = results.first as Map<String, dynamic>;
        final id = firstResult['id']?.toString();
        if (id != null) {
          return _fetchById(apiKey, id, mediaType);
        }
      }
    }
    
    return null;
  }

  static Future<Map<String, dynamic>?> _fetchCredits(
    String apiKey,
    String tmdbId,
    String mediaType,
  ) async {
    final url = '$_baseUrl/$mediaType/$tmdbId/credits?api_key=$apiKey';
    final response = await http.get(Uri.parse(url));
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    
    return null;
  }

  static Future<Map<String, dynamic>?> _fetchReviews(
    String apiKey,
    String tmdbId,
    String mediaType,
  ) async {
    final url = '$_baseUrl/$mediaType/$tmdbId/reviews?api_key=$apiKey';
    final response = await http.get(Uri.parse(url));
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    
    return null;
  }
}
