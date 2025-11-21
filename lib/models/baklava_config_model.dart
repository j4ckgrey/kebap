import 'package:freezed_annotation/freezed_annotation.dart';

part 'baklava_config_model.freezed.dart';
part 'baklava_config_model.g.dart';

@Freezed(copyWith: true)
abstract class BaklavaConfig with _$BaklavaConfig {
  const factory BaklavaConfig({
    @Default('') String defaultTmdbId,
    @Default(false) bool disableNonAdminRequests,
    @Default(true) bool showReviewsCarousel,
    String? tmdbApiKey,
    bool? enableSearchFilter,
    bool? forceTVClientLocalSearch,
    String? versionUi,
    String? audioUi,
    String? subtitleUi,
  }) = _BaklavaConfig;

  factory BaklavaConfig.fromJson(Map<String, dynamic> json) => _$BaklavaConfigFromJson(json);
}
