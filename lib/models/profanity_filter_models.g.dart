// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profanity_filter_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MuteRange _$MuteRangeFromJson(Map<String, dynamic> json) => _MuteRange(
      startMs: (json['startMs'] as num).toInt(),
      endMs: (json['endMs'] as num).toInt(),
      word: json['word'] as String?,
    );

Map<String, dynamic> _$MuteRangeToJson(_MuteRange instance) =>
    <String, dynamic>{
      'startMs': instance.startMs,
      'endMs': instance.endMs,
      'word': instance.word,
    };

_ProfanityMetadata _$ProfanityMetadataFromJson(Map<String, dynamic> json) =>
    _ProfanityMetadata(
      itemId: json['itemId'] as String,
      muteRanges: (json['muteRanges'] as List<dynamic>)
          .map((e) => MuteRange.fromJson(e as Map<String, dynamic>))
          .toList(),
      scannedAt: json['scannedAt'] == null
          ? null
          : DateTime.parse(json['scannedAt'] as String),
    );

Map<String, dynamic> _$ProfanityMetadataToJson(_ProfanityMetadata instance) =>
    <String, dynamic>{
      'itemId': instance.itemId,
      'muteRanges': instance.muteRanges,
      'scannedAt': instance.scannedAt?.toIso8601String(),
    };

_ProfanityUserPreferences _$ProfanityUserPreferencesFromJson(
        Map<String, dynamic> json) =>
    _ProfanityUserPreferences(
      enabled: json['enabled'] as bool? ?? false,
      muteEntireSentence: json['muteEntireSentence'] as bool? ?? false,
    );

Map<String, dynamic> _$ProfanityUserPreferencesToJson(
        _ProfanityUserPreferences instance) =>
    <String, dynamic>{
      'enabled': instance.enabled,
      'muteEntireSentence': instance.muteEntireSentence,
    };

_ProfanityPluginConfig _$ProfanityPluginConfigFromJson(
        Map<String, dynamic> json) =>
    _ProfanityPluginConfig(
      enabledByDefault: json['enabledByDefault'] as bool? ?? false,
      profanityWords: json['profanityWords'] as String? ?? '',
      enableWordReplacement: json['enableWordReplacement'] as bool? ?? false,
      useGrammaticalReplacement:
          json['useGrammaticalReplacement'] as bool? ?? false,
      mutePaddingMs: (json['mutePaddingMs'] as num?)?.toInt() ?? 100,
      muteEntireSentence: json['muteEntireSentence'] as bool? ?? false,
    );

Map<String, dynamic> _$ProfanityPluginConfigToJson(
        _ProfanityPluginConfig instance) =>
    <String, dynamic>{
      'enabledByDefault': instance.enabledByDefault,
      'profanityWords': instance.profanityWords,
      'enableWordReplacement': instance.enableWordReplacement,
      'useGrammaticalReplacement': instance.useGrammaticalReplacement,
      'mutePaddingMs': instance.mutePaddingMs,
      'muteEntireSentence': instance.muteEntireSentence,
    };
