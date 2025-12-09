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

  void setDisableNonAdminRequests(bool value) {
    state = state.copyWith(disableNonAdminRequests: value);
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
}
