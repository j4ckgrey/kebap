import 'package:freezed_annotation/freezed_annotation.dart';

part 'baklava_config_model.freezed.dart';
part 'baklava_config_model.g.dart';

@Freezed(copyWith: true)
abstract class BaklavaConfig with _$BaklavaConfig {
  const factory BaklavaConfig({
    @Default('') String defaultTmdbId,
    @Default(false) bool enableAutoImport,
    @Default(false) bool disableModal,
    @Default(true) bool showReviewsCarousel,
    String? tmdbApiKey,
    bool? enableSearchFilter,
    bool? forceTVClientLocalSearch,
    @Default('') String? versionUi,
    @Default('') String? audioUi,
    @Default('') String? subtitleUi,
    @Default('') String? gelatoBaseUrl,
    @Default('') String? gelatoAuthHeader,
    @Default('realdebrid') String? debridService,
    @Default('') String? debridApiKey,
    @Default('') String? realDebridApiKey,
    @Default('') String? torboxApiKey,
    @Default('') String? alldebridApiKey,
    @Default('') String? premiumizeApiKey,
    @Default(true) bool? enableDebridMetadata,
    @Default(false) bool? enableFallbackProbe,
    @Default(false) bool? fetchCachedMetadataPerVersion,
    @Default(false) bool? fetchAllNonCachedMetadata,
    @Default(false) bool? enableExternalSubtitles,
  }) = _BaklavaConfig;

  factory BaklavaConfig.fromJson(Map<String, dynamic> json) => _$BaklavaConfigFromJson(json);
}
