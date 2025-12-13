import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kebap/models/baklava_config_model.dart';
import 'package:kebap/models/settings/media_stream_view_type.dart';
import 'package:kebap/providers/baklava_api_service.dart';
import 'package:kebap/providers/settings/kebap_settings_provider.dart';
import 'package:kebap/providers/settings/media_stream_view_type_provider.dart';

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
    
    // Apply media stream view type settings from config
    if (config.versionUi != null || config.audioUi != null || config.subtitleUi != null) {
      // Use the first non-null value, or default to carousel
      final viewTypeString = config.versionUi ?? config.audioUi ?? config.subtitleUi ?? 'carousel';
      final viewType = viewTypeString.toLowerCase() == 'carousel' 
          ? MediaStreamViewType.carousel 
          : MediaStreamViewType.dropdown;
      
      // Set the media stream view type
      ref.read(mediaStreamViewTypeProvider.notifier).state = viewType;
    }
    
    // Sync local Kebap settings FROM server config
    // This ensures server-side changes are reflected in Kebap on startup
    ref.read(kebapSettingsProvider.notifier).syncFromBaklava(
      enableAutoImport: config.enableAutoImport,
      showReviewsCarousel: config.showReviewsCarousel,
      enableSearchFilter: config.enableSearchFilter,
      forceTVClientLocalSearch: config.forceTVClientLocalSearch,
      tmdbApiKey: config.tmdbApiKey,
    );
    
    return config;
  } catch (e) {
    // Return default config on error
    return const BaklavaConfig();
  }
});
