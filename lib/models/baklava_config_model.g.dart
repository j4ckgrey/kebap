// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'baklava_config_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BaklavaConfig _$BaklavaConfigFromJson(Map<String, dynamic> json) =>
    _BaklavaConfig(
      defaultTmdbId: json['defaultTmdbId'] as String? ?? '',
      enableAutoImport: json['enableAutoImport'] as bool? ?? false,
      disableModal: json['disableModal'] as bool? ?? false,
      showReviewsCarousel: json['showReviewsCarousel'] as bool? ?? true,
      tmdbApiKey: json['tmdbApiKey'] as String?,
      enableSearchFilter: json['enableSearchFilter'] as bool?,
      forceTVClientLocalSearch: json['forceTVClientLocalSearch'] as bool?,
      versionUi: json['versionUi'] as String? ?? '',
      audioUi: json['audioUi'] as String? ?? '',
      subtitleUi: json['subtitleUi'] as String? ?? '',
      gelatoBaseUrl: json['gelatoBaseUrl'] as String? ?? '',
      gelatoAuthHeader: json['gelatoAuthHeader'] as String? ?? '',
      debridService: json['debridService'] as String? ?? 'realdebrid',
      debridApiKey: json['debridApiKey'] as String? ?? '',
      realDebridApiKey: json['realDebridApiKey'] as String? ?? '',
      torboxApiKey: json['torboxApiKey'] as String? ?? '',
      alldebridApiKey: json['alldebridApiKey'] as String? ?? '',
      premiumizeApiKey: json['premiumizeApiKey'] as String? ?? '',
      enableDebridMetadata: json['enableDebridMetadata'] as bool? ?? true,
      enableFallbackProbe: json['enableFallbackProbe'] as bool? ?? false,
      fetchCachedMetadataPerVersion:
          json['fetchCachedMetadataPerVersion'] as bool? ?? false,
      fetchAllNonCachedMetadata:
          json['fetchAllNonCachedMetadata'] as bool? ?? false,
      enableExternalSubtitles:
          json['enableExternalSubtitles'] as bool? ?? false,
    );

Map<String, dynamic> _$BaklavaConfigToJson(_BaklavaConfig instance) =>
    <String, dynamic>{
      'defaultTmdbId': instance.defaultTmdbId,
      'enableAutoImport': instance.enableAutoImport,
      'disableModal': instance.disableModal,
      'showReviewsCarousel': instance.showReviewsCarousel,
      'tmdbApiKey': instance.tmdbApiKey,
      'enableSearchFilter': instance.enableSearchFilter,
      'forceTVClientLocalSearch': instance.forceTVClientLocalSearch,
      'versionUi': instance.versionUi,
      'audioUi': instance.audioUi,
      'subtitleUi': instance.subtitleUi,
      'gelatoBaseUrl': instance.gelatoBaseUrl,
      'gelatoAuthHeader': instance.gelatoAuthHeader,
      'debridService': instance.debridService,
      'debridApiKey': instance.debridApiKey,
      'realDebridApiKey': instance.realDebridApiKey,
      'torboxApiKey': instance.torboxApiKey,
      'alldebridApiKey': instance.alldebridApiKey,
      'premiumizeApiKey': instance.premiumizeApiKey,
      'enableDebridMetadata': instance.enableDebridMetadata,
      'enableFallbackProbe': instance.enableFallbackProbe,
      'fetchCachedMetadataPerVersion': instance.fetchCachedMetadataPerVersion,
      'fetchAllNonCachedMetadata': instance.fetchAllNonCachedMetadata,
      'enableExternalSubtitles': instance.enableExternalSubtitles,
    };
