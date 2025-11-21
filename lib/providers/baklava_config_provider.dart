import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fladder/models/baklava_config_model.dart';
import 'package:fladder/providers/baklava_api_service.dart';

// Provider for Baklava API service
final baklavaServiceProvider = Provider<BaklavaService>((ref) {
  return BaklavaService(ref);
});

// Provider for Baklava configuration
final baklavaConfigProvider = FutureProvider<BaklavaConfig>((ref) async {
  final service = ref.watch(baklavaServiceProvider);
  try {
    final response = await service.fetchConfig();
    return response.body ?? const BaklavaConfig();
  } catch (e) {
    // Return default config on error
    return const BaklavaConfig();
  }
});
