import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:kebap/providers/api_provider.dart';

part 'trailer_provider.g.dart';

/// Provider that fetches and caches trailer URLs for items.
/// Uses the item's ID to fetch full details which include remoteTrailers.
@riverpod
Future<String?> trailerUrl(Ref ref, String itemId) async {
  final api = ref.read(jellyApiProvider);
  
  try {
    // Use GetBaseItem to get the raw BaseItemDto which includes remoteTrailers
    final response = await api.usersUserIdItemsItemIdGetBaseItem(itemId: itemId);
    
    if (response.isSuccessful && response.body != null) {
      final trailers = response.body!.remoteTrailers;
      if (trailers != null && trailers.isNotEmpty) {
        final trailerUrl = trailers.first.url;
        debugPrint('[TrailerProvider] Found trailer for $itemId: $trailerUrl');
        return trailerUrl;
      }
    }
  } catch (e) {
    debugPrint('[TrailerProvider] Error fetching trailer for $itemId: $e');
  }
  
  return null;
}

