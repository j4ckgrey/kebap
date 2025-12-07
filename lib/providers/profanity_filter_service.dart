import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'package:kebap/models/profanity_filter_models.dart';
import 'package:kebap/providers/api_provider.dart';

/// Service for interacting with the Jelly-Guardian profanity filter plugin
class ProfanityFilterService {
  ProfanityFilterService(this.ref);

  final Ref ref;

  static const String _baseRoute = '/ProfanityFilter';

  String get _cleanServerUrl {
    final serverUrl = ref.read(serverUrlProvider);
    if (serverUrl == null || serverUrl.isEmpty) {
      throw Exception('Server URL not available');
    }
    return serverUrl.endsWith('/') 
        ? serverUrl.substring(0, serverUrl.length - 1) 
        : serverUrl;
  }

  /// Check if the profanity filter plugin is available on the server
  Future<bool> checkPluginAvailable() async {
    try {
      final api = ref.read(jellyApiProvider).api;
      final url = '$_cleanServerUrl$_baseRoute/UserPreferences/00000000-0000-0000-0000-000000000000';
      final request = Request('GET', Uri.parse(url), Uri.parse(_cleanServerUrl));

      final response = await api.client.send(request);
      
      // Plugin is available if we get any response (even 404 for the fake user)
      // A 404 on the route itself means plugin not installed
      return response.statusCode != 404 || response.isSuccessful;
    } catch (e) {
      return false;
    }
  }

  /// Get profanity filter metadata for a specific item
  Future<Response<ProfanityMetadata?>> getMetadata(String itemId) async {
    try {
      final api = ref.read(jellyApiProvider).api;
      final url = '$_cleanServerUrl$_baseRoute/Metadata/$itemId';
      final request = Request('GET', Uri.parse(url), Uri.parse(_cleanServerUrl));

      final response = await api.client.send(request);

      if (response.isSuccessful && response.body != null) {
        final dynamic bodyData = response.body is String 
            ? jsonDecode(response.body as String)
            : response.body;
        
        // Parse the mute ranges from the metadata
        final metadata = ProfanityMetadata.fromJson({
          'itemId': itemId,
          'muteRanges': bodyData['muteRanges'] ?? [],
          'scannedAt': bodyData['scannedAt'],
        });
        return Response(response.base, metadata);
      }

      // No metadata found for this item
      if (response.statusCode == 404) {
        return Response(response.base, null);
      }

      throw Exception('Failed to fetch metadata: ${response.statusCode}');
    } catch (e) {
      throw Exception('Failed to fetch profanity metadata: $e');
    }
  }

  /// Get user preferences for profanity filter
  Future<Response<ProfanityUserPreferences>> getUserPreferences(String userId) async {
    try {
      final api = ref.read(jellyApiProvider).api;
      final url = '$_cleanServerUrl$_baseRoute/UserPreferences/$userId';
      final request = Request('GET', Uri.parse(url), Uri.parse(_cleanServerUrl));

      final response = await api.client.send(request);

      if (response.isSuccessful && response.body != null) {
        final dynamic bodyData = response.body is String 
            ? jsonDecode(response.body as String)
            : response.body;
            
        final prefs = ProfanityUserPreferences.fromJson(bodyData as Map<String, dynamic>);
        return Response(response.base, prefs);
      }

      // Return default preferences if not found
      return Response(response.base, ProfanityUserPreferences());
    } catch (e) {
      // Return default preferences on error
      return Response(
        http.Response('{}', 500),
        ProfanityUserPreferences(),
      );
    }
  }

  /// Update user preferences for profanity filter
  Future<Response<ProfanityUserPreferences>> updateUserPreferences(
    String userId,
    ProfanityUserPreferences preferences,
  ) async {
    try {
      final api = ref.read(jellyApiProvider).api;
      final url = '$_cleanServerUrl$_baseRoute/UserPreferences/$userId';
      final request = Request(
        'POST',
        Uri.parse(url),
        Uri.parse(_cleanServerUrl),
        body: jsonEncode(preferences.toJson()),
        headers: {'Content-Type': 'application/json'},
      );

      final response = await api.client.send(request);

      if (response.isSuccessful && response.body != null) {
        final dynamic bodyData = response.body is String 
            ? jsonDecode(response.body as String)
            : response.body;
            
        final prefs = ProfanityUserPreferences.fromJson(bodyData as Map<String, dynamic>);
        return Response(response.base, prefs);
      }

      throw Exception('Failed to update preferences: ${response.statusCode}');
    } catch (e) {
      throw Exception('Failed to update user preferences: $e');
    }
  }

  /// Get plugin configuration (admin only)
  Future<Response<ProfanityPluginConfig>> getPluginConfig() async {
    try {
      final api = ref.read(jellyApiProvider).api;
      // Note: This endpoint may need adjustment based on actual plugin API
      final url = '$_cleanServerUrl$_baseRoute/Configuration';
      final request = Request('GET', Uri.parse(url), Uri.parse(_cleanServerUrl));

      final response = await api.client.send(request);

      if (response.isSuccessful && response.body != null) {
        final dynamic bodyData = response.body is String 
            ? jsonDecode(response.body as String)
            : response.body;
            
        final config = ProfanityPluginConfig.fromJson(bodyData as Map<String, dynamic>);
        return Response(response.base, config);
      }

      // Return default config if not found
      return Response(response.base, ProfanityPluginConfig());
    } catch (e) {
      return Response(
        http.Response('{}', 500),
        ProfanityPluginConfig(),
      );
    }
  }

  /// Update plugin configuration (admin only)
  Future<Response<ProfanityPluginConfig>> updatePluginConfig(
    ProfanityPluginConfig config,
  ) async {
    try {
      final api = ref.read(jellyApiProvider).api;
      final url = '$_cleanServerUrl$_baseRoute/Configuration';
      final request = Request(
        'POST',
        Uri.parse(url),
        Uri.parse(_cleanServerUrl),
        body: jsonEncode(config.toJson()),
        headers: {'Content-Type': 'application/json'},
      );

      final response = await api.client.send(request);

      if (response.isSuccessful && response.body != null) {
        final dynamic bodyData = response.body is String 
            ? jsonDecode(response.body as String)
            : response.body;
            
        final updatedConfig = ProfanityPluginConfig.fromJson(bodyData as Map<String, dynamic>);
        return Response(response.base, updatedConfig);
      }

      throw Exception('Failed to update config: ${response.statusCode}');
    } catch (e) {
      throw Exception('Failed to update plugin config: $e');
    }
  }

  /// Trigger library scan for profanity (admin only)
  Future<Response<void>> triggerLibraryScan() async {
    try {
      final api = ref.read(jellyApiProvider).api;
      // Trigger the scheduled task via Jellyfin's task API
      final url = '$_cleanServerUrl/ScheduledTasks/Running/ScanLibraryForProfanity';
      final request = Request(
        'POST',
        Uri.parse(url),
        Uri.parse(_cleanServerUrl),
      );

      final response = await api.client.send(request);

      if (!response.isSuccessful) {
        throw Exception('Failed to trigger scan: ${response.statusCode}');
      }

      return Response(response.base, null);
    } catch (e) {
      throw Exception('Failed to trigger library scan: $e');
    }
  }
}
