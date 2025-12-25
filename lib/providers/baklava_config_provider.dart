import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kebap/models/baklava_config_model.dart';
import 'package:kebap/providers/baklava_api_service.dart';
import 'package:kebap/providers/settings/kebap_settings_provider.dart';

// Provider for Baklava API service
final baklavaServiceProvider = Provider<BaklavaService>((ref) {
  return BaklavaService(ref);
});

// Provider for Baklava configuration
final baklavaConfigProvider = FutureProvider<BaklavaConfig>((ref) async {
  final service = ref.watch(baklavaServiceProvider);
  try {
    final response = await service.fetchConfig();
    final config = response.body ?? const BaklavaConfig();
    
    // ONLY sync enableAutoImport from server config
    // All other settings are LOCAL to the client and not synced from server
    ref.read(kebapSettingsProvider.notifier).syncFromBaklava(
      enableAutoImport: config.enableAutoImport,
      disableModal: config.disableModal,
    );
    
    return config;
  } catch (e) {
    // Return default config on error
    return const BaklavaConfig();
  }
});
