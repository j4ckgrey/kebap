import 'package:freezed_annotation/freezed_annotation.dart';

part 'profanity_filter_models.freezed.dart';
part 'profanity_filter_models.g.dart';

/// Mute range for a detected profanity word
@freezed
abstract class MuteRange with _$MuteRange {
  const MuteRange._();

  factory MuteRange({
    /// Start time in milliseconds
    required int startMs,
    /// End time in milliseconds
    required int endMs,
    /// The detected word (optional)
    String? word,
  }) = _MuteRange;

  factory MuteRange.fromJson(Map<String, dynamic> json) =>
      _$MuteRangeFromJson(json);
}

/// Profanity filter metadata for an item
@freezed
abstract class ProfanityMetadata with _$ProfanityMetadata {
  const ProfanityMetadata._();

  factory ProfanityMetadata({
    required String itemId,
    required List<MuteRange> muteRanges,
    DateTime? scannedAt,
  }) = _ProfanityMetadata;

  factory ProfanityMetadata.fromJson(Map<String, dynamic> json) =>
      _$ProfanityMetadataFromJson(json);
}

/// User preferences for profanity filter
@freezed
abstract class ProfanityUserPreferences with _$ProfanityUserPreferences {
  const ProfanityUserPreferences._();

  factory ProfanityUserPreferences({
    @Default(false) bool enabled,
    @Default(false) bool muteEntireSentence,
  }) = _ProfanityUserPreferences;

  factory ProfanityUserPreferences.fromJson(Map<String, dynamic> json) =>
      _$ProfanityUserPreferencesFromJson(json);
}

/// Plugin configuration (admin only)
@freezed
abstract class ProfanityPluginConfig with _$ProfanityPluginConfig {
  const ProfanityPluginConfig._();

  factory ProfanityPluginConfig({
    @Default(false) bool enabledByDefault,
    @Default('') String profanityWords,
    @Default(false) bool enableWordReplacement,
    @Default(false) bool useGrammaticalReplacement,
    @Default(100) int mutePaddingMs,
    @Default(false) bool muteEntireSentence,
  }) = _ProfanityPluginConfig;

  factory ProfanityPluginConfig.fromJson(Map<String, dynamic> json) =>
      _$ProfanityPluginConfigFromJson(json);
}
