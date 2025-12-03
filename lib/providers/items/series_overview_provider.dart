import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kebap/providers/api_provider.dart';

final seriesOverviewProvider = FutureProvider.family<String?, String>((ref, seriesId) async {
  if (seriesId.isEmpty) return null;
  
  final api = ref.read(jellyApiProvider);
  try {
    final response = await api.usersUserIdItemsItemIdGet(itemId: seriesId);
    return response.body?.overview.summary;
  } catch (e) {
    return null;
  }
});
