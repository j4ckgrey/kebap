// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MediaRequest _$MediaRequestFromJson(Map<String, dynamic> json) =>
    _MediaRequest(
      id: json['id'] as String,
      username: json['username'] as String?,
      userId: json['userId'] as String?,
      timestamp: (json['timestamp'] as num?)?.toInt() ?? 0,
      title: json['title'] as String,
      year: json['year'] as String?,
      img: const ImageUrlConverter().fromJson(json['img'] as String?),
      imdbId: json['imdbId'] as String?,
      tmdbId: json['tmdbId'] as String?,
      jellyfinId: json['jellyfinId'] as String?,
      itemType: json['itemType'] as String?,
      tmdbMediaType: json['tmdbMediaType'] as String?,
      status: json['status'] as String? ?? 'pending',
      approvedBy: json['approvedBy'] as String?,
    );

Map<String, dynamic> _$MediaRequestToJson(_MediaRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'userId': instance.userId,
      'timestamp': instance.timestamp,
      'title': instance.title,
      'year': instance.year,
      'img': const ImageUrlConverter().toJson(instance.img),
      'imdbId': instance.imdbId,
      'tmdbId': instance.tmdbId,
      'jellyfinId': instance.jellyfinId,
      'itemType': instance.itemType,
      'tmdbMediaType': instance.tmdbMediaType,
      'status': instance.status,
      'approvedBy': instance.approvedBy,
    };
