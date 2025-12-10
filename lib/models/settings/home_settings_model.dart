import 'package:flutter/material.dart';

import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:kebap/util/adaptive_layout/adaptive_layout.dart';
import 'package:kebap/util/localization_helper.dart';

part 'home_settings_model.freezed.dart';
part 'home_settings_model.g.dart';

@Freezed(copyWith: true)
abstract class HomeSettingsModel with _$HomeSettingsModel {
  const HomeSettingsModel._();

  factory HomeSettingsModel({
    @Default({...LayoutMode.values}) Set<LayoutMode> screenLayouts,
    @Default({...ViewSize.values}) Set<ViewSize> layoutStates,
    @Default(HomeNextUp.separate) HomeNextUp nextUp,
    @Default(HomeBannerMediaType.image) HomeBannerMediaType bannerMediaType,
    @Default(false) bool bannerTrailerMuted,
    @Default(TrailerQuality.high) TrailerQuality bannerTrailerQuality,
  }) = _HomeSettingsModel;

  static HomeSettingsModel defaultModel() {
    return HomeSettingsModel();
  }

  factory HomeSettingsModel.fromJson(Map<String, dynamic> json) => _$HomeSettingsModelFromJson(json);
}

T selectAvailableOrSmaller<T>(T value, Set<T> availableOptions, List<T> allOptions) {
  if (availableOptions.contains(value)) {
    return value;
  }

  int index = allOptions.indexOf(value);

  for (int i = index - 1; i >= 0; i--) {
    if (availableOptions.contains(allOptions[i])) {
      return allOptions[i];
    }
  }

  return availableOptions.first;
}

enum HomeNextUp {
  off,
  nextUp,
  cont,
  combined,
  separate,
  ;

  const HomeNextUp();

  String label(BuildContext context) => switch (this) {
        HomeNextUp.off => context.localized.hide,
        HomeNextUp.nextUp => context.localized.nextUp,
        HomeNextUp.cont => context.localized.settingsContinue,
        HomeNextUp.combined => context.localized.combined,
        HomeNextUp.separate => context.localized.separate,
      };
}

/// Banner media type for homepage banner
enum HomeBannerMediaType {
  image,
  trailer,
  ;

  const HomeBannerMediaType();

  String label(BuildContext context) => switch (this) {
        HomeBannerMediaType.image => context.localized.image,
        HomeBannerMediaType.trailer => context.localized.trailer,
      };
}

/// Trailer quality setting for homepage banner
enum TrailerQuality {
  low,
  medium,
  high,
  ;

  const TrailerQuality();

  String label(BuildContext context) => switch (this) {
        TrailerQuality.low => context.localized.qualityLow,
        TrailerQuality.medium => context.localized.qualityMedium,
        TrailerQuality.high => context.localized.qualityHigh,
      };
}
