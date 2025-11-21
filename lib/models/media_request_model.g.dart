// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MediaRequest _$MediaRequestFromJson(Map<String, dynamic> json) =>
    _MediaRequest(
      id: json['Id'] as String,
      username: json['Username'] as String?,
      userId: json['UserId'] as String?,
      timestamp: (json['Timestamp'] as num?)?.toInt() ?? 0,
      title: json['Title'] as String,
      year: json['Year'] as String?,
      img: const ImageUrlConverter().fromJson(json['Img'] as String?),
      imdbId: json['ImdbId'] as String?,
      tmdbId: json['TmdbId'] as String?,
      jellyfinId: json['JellyfinId'] as String?,
      itemType: json['ItemType'] as String?,
      tmdbMediaType: json['TmdbMediaType'] as String?,
      status: json['Status'] as String? ?? 'pending',
      approvedBy: json['ApprovedBy'] as String?,
    );

Map<String, dynamic> _$MediaRequestToJson(_MediaRequest instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'Username': instance.username,
      'UserId': instance.userId,
      'Timestamp': instance.timestamp,
      'Title': instance.title,
      'Year': instance.year,
      'Img': const ImageUrlConverter().toJson(instance.img),
      'ImdbId': instance.imdbId,
      'TmdbId': instance.tmdbId,
      'JellyfinId': instance.jellyfinId,
      'ItemType': instance.itemType,
      'TmdbMediaType': instance.tmdbMediaType,
      'Status': instance.status,
      'ApprovedBy': instance.approvedBy,
    };
