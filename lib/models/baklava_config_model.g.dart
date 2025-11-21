// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'baklava_config_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BaklavaConfig _$BaklavaConfigFromJson(Map<String, dynamic> json) =>
    _BaklavaConfig(
      defaultTmdbId: json['defaultTmdbId'] as String? ?? '',
      disableNonAdminRequests:
          json['disableNonAdminRequests'] as bool? ?? false,
      showReviewsCarousel: json['showReviewsCarousel'] as bool? ?? true,
      tmdbApiKey: json['tmdbApiKey'] as String?,
      enableSearchFilter: json['enableSearchFilter'] as bool?,
      forceTVClientLocalSearch: json['forceTVClientLocalSearch'] as bool?,
      versionUi: json['versionUi'] as String?,
      audioUi: json['audioUi'] as String?,
      subtitleUi: json['subtitleUi'] as String?,
    );

Map<String, dynamic> _$BaklavaConfigToJson(_BaklavaConfig instance) =>
    <String, dynamic>{
      'defaultTmdbId': instance.defaultTmdbId,
      'disableNonAdminRequests': instance.disableNonAdminRequests,
      'showReviewsCarousel': instance.showReviewsCarousel,
      'tmdbApiKey': instance.tmdbApiKey,
      'enableSearchFilter': instance.enableSearchFilter,
      'forceTVClientLocalSearch': instance.forceTVClientLocalSearch,
      'versionUi': instance.versionUi,
      'audioUi': instance.audioUi,
      'subtitleUi': instance.subtitleUi,
    };
