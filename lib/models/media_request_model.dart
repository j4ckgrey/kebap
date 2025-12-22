import 'package:freezed_annotation/freezed_annotation.dart';

// Freezed generates field annotations that the analyzer sometimes flags
// as invalid_annotation_target in certain SDK versions. Suppress that
// specific warning here so the file stays clean in analysis runs.
// ignore_for_file: invalid_annotation_target

part 'media_request_model.freezed.dart';
part 'media_request_model.g.dart';

/// Converter to strip url("...") wrapper from image URLs
class ImageUrlConverter implements JsonConverter<String?, String?> {
  const ImageUrlConverter();

  @override
  String? fromJson(String? json) {
    if (json == null) return null;
    // Strip url("...") wrapper if present
    if (json.startsWith('url("') && json.endsWith('")')) {
      return json.substring(5, json.length - 2);
    }
    return json;
  }

  @override
  String? toJson(String? object) => object;
}

@Freezed(copyWith: true)
abstract class MediaRequest with _$MediaRequest {
  const factory MediaRequest({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'username') String? username,
    @JsonKey(name: 'userId') String? userId,
    @JsonKey(name: 'timestamp') @Default(0) int timestamp,
    @JsonKey(name: 'title') required String title,
    @JsonKey(name: 'year') String? year,
    @JsonKey(name: 'img') @ImageUrlConverter() String? img,
    @JsonKey(name: 'imdbId') String? imdbId,
    @JsonKey(name: 'tmdbId') String? tmdbId,
    @JsonKey(name: 'jellyfinId') String? jellyfinId,
    @JsonKey(name: 'itemType') String? itemType,
    @JsonKey(name: 'tmdbMediaType') String? tmdbMediaType,
    @JsonKey(name: 'status') @Default('pending') String status,
    @JsonKey(name: 'approvedBy') String? approvedBy,
  }) = _MediaRequest;

  factory MediaRequest.fromJson(Map<String, dynamic> json) =>
      _$MediaRequestFromJson(json);
}

@Freezed(copyWith: true)
abstract class RequestsState with _$RequestsState {
  const RequestsState._();

  const factory RequestsState({
    @Default([]) List<MediaRequest> requests,
    @Default(false) bool loading,
    String? error,
  }) = _RequestsState;

  int get pendingCount => requests.where((r) => r.status == 'pending').length;

  List<MediaRequest> filterByUser(String username, {bool isAdmin = false}) {
    if (isAdmin) {
      return requests;
    }
    return requests.where((r) => r.username == username).toList();
  }

  List<MediaRequest> get movies =>
      requests.where((r) => r.itemType?.toLowerCase() == 'movie').toList();

  List<MediaRequest> get series =>
      requests.where((r) => r.itemType?.toLowerCase() == 'series' || r.itemType?.toLowerCase() == 'tv').toList();

  List<MediaRequest> get pending =>
      requests.where((r) => r.status == 'pending').toList();

  List<MediaRequest> get approved =>
      requests.where((r) => r.status == 'approved').toList();

  List<MediaRequest> get rejected =>
      requests.where((r) => r.status == 'rejected').toList();
}
