import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kebap/models/settings/kebap_settings_model.dart';
import 'package:kebap/providers/shared_provider.dart';

const _kebapSettingsKey = 'kebapSettings';

final kebapSettingsProvider = StateNotifierProvider<KebapSettingsNotifier, KebapSettingsModel>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  final raw = prefs.getString(_kebapSettingsKey);
  final model = KebapSettingsModel.fromString(raw);
  return KebapSettingsNotifier(ref, model);
});

class KebapSettingsNotifier extends StateNotifier<KebapSettingsModel> {
  KebapSettingsNotifier(this.ref, super.state);

  final Ref ref;

  void _persist() {
    try {
      ref.read(sharedPreferencesProvider).setString(_kebapSettingsKey, state.toStringJson());
    } catch (_) {
      // ignore
    }
  }

  void setUseBaklava(bool value) {
    state = state.copyWith(useBaklava: value);
    _persist();
  }

  void setTmdbApiKey(String? key) {
    state = state.copyWith(tmdbApiKey: key);
    _persist();
  }

  void setEnableSearchFilter(bool? value) {
    state = state.copyWith(enableSearchFilter: value);
    _persist();
  }

  void setForceTVClientLocalSearch(bool? value) {
    state = state.copyWith(forceTVClientLocalSearch: value);
    _persist();
  }

  void setEnableAutoImport(bool value) {
    state = state.copyWith(enableAutoImport: value);
    _persist();
  }

  void setShowReviewsCarousel(bool value) {
    state = state.copyWith(showReviewsCarousel: value);
    _persist();
  }

  void setMobileHomepageHeightRatio(double value) {
    state = state.copyWith(mobileHomepageHeightRatio: value.clamp(0.3, 0.7));
    _persist();
  }

  /// Syncs local settings FROM the Baklava server config.
  /// Called on app startup when useBaklava is enabled.
  void syncFromBaklava({
    required bool enableAutoImport,
    required bool showReviewsCarousel,
    bool? enableSearchFilter,
    bool? forceTVClientLocalSearch,
    String? tmdbApiKey,
  }) {
    state = state.copyWith(
      enableAutoImport: enableAutoImport,
      showReviewsCarousel: showReviewsCarousel,
      enableSearchFilter: enableSearchFilter ?? state.enableSearchFilter,
      forceTVClientLocalSearch: forceTVClientLocalSearch ?? state.forceTVClientLocalSearch,
      tmdbApiKey: tmdbApiKey ?? state.tmdbApiKey,
    );
    _persist();
  }
}
