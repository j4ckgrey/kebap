// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HomeSettingsModel _$HomeSettingsModelFromJson(Map<String, dynamic> json) =>
    _HomeSettingsModel(
      screenLayouts: (json['screenLayouts'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$LayoutModeEnumMap, e))
              .toSet() ??
          const {...LayoutMode.values},
      layoutStates: (json['layoutStates'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$ViewSizeEnumMap, e))
              .toSet() ??
          const {...ViewSize.values},
      nextUp: $enumDecodeNullable(_$HomeNextUpEnumMap, json['nextUp']) ??
          HomeNextUp.separate,
      bannerMediaType: $enumDecodeNullable(
              _$HomeBannerMediaTypeEnumMap, json['bannerMediaType']) ??
          HomeBannerMediaType.image,
      bannerTrailerMuted: json['bannerTrailerMuted'] as bool? ?? false,
    );

Map<String, dynamic> _$HomeSettingsModelToJson(_HomeSettingsModel instance) =>
    <String, dynamic>{
      'screenLayouts':
          instance.screenLayouts.map((e) => _$LayoutModeEnumMap[e]!).toList(),
      'layoutStates':
          instance.layoutStates.map((e) => _$ViewSizeEnumMap[e]!).toList(),
      'nextUp': _$HomeNextUpEnumMap[instance.nextUp]!,
      'bannerMediaType':
          _$HomeBannerMediaTypeEnumMap[instance.bannerMediaType]!,
      'bannerTrailerMuted': instance.bannerTrailerMuted,
    };

const _$LayoutModeEnumMap = {
  LayoutMode.single: 'single',
  LayoutMode.dual: 'dual',
};

const _$ViewSizeEnumMap = {
  ViewSize.phone: 'phone',
  ViewSize.tablet: 'tablet',
  ViewSize.desktop: 'desktop',
  ViewSize.television: 'television',
};

const _$HomeNextUpEnumMap = {
  HomeNextUp.off: 'off',
  HomeNextUp.nextUp: 'nextUp',
  HomeNextUp.cont: 'cont',
  HomeNextUp.combined: 'combined',
  HomeNextUp.separate: 'separate',
};

const _$HomeBannerMediaTypeEnumMap = {
  HomeBannerMediaType.image: 'image',
  HomeBannerMediaType.trailer: 'trailer',
};
