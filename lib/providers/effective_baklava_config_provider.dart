import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kebap/models/baklava_config_model.dart';
import 'package:kebap/providers/baklava_config_provider.dart';
import 'package:kebap/providers/settings/kebap_settings_provider.dart';

/// Provides the effective Baklava configuration.
/// Always attempts to fetch from Baklava plugin first.
/// Falls back to local Kebap settings if Baklava is unavailable.
final effectiveBaklavaConfigProvider = FutureProvider<BaklavaConfig>((ref) async {
  // Always try to fetch from Baklava plugin first
  try {
    final baklavaConfig = await ref.watch(baklavaConfigProvider.future);
    return baklavaConfig;
  } catch (e) {
    // Baklava unavailable, use local Kebap settings as fallback
    final kebap = ref.watch(kebapSettingsProvider);
    return BaklavaConfig(
      tmdbApiKey: kebap.tmdbApiKey,
      enableSearchFilter: kebap.enableSearchFilter,
      forceTVClientLocalSearch: kebap.forceTVClientLocalSearch,
      disableNonAdminRequests: kebap.disableNonAdminRequests,
      showReviewsCarousel: kebap.showReviewsCarousel,
    );
  }
});
