// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'tmdb_metadata_model.freezed.dart';
part 'tmdb_metadata_model.g.dart';

@freezed
abstract class TMDBMetadata with _$TMDBMetadata {
  const factory TMDBMetadata({
    required int id,
    String? title,
    String? name,
    String? overview,
    @JsonKey(name: 'poster_path') String? posterPath,
    @JsonKey(name: 'backdrop_path') String? backdropPath,
    @JsonKey(name: 'vote_average') double? voteAverage,
    @JsonKey(name: 'vote_count') int? voteCount,
    @JsonKey(name: 'release_date') String? releaseDate,
    @JsonKey(name: 'first_air_date') String? firstAirDate,
    int? runtime,
    @JsonKey(name: 'number_of_seasons') int? numberOfSeasons,
    @JsonKey(name: 'number_of_episodes') int? numberOfEpisodes,
    List<TMDBGenre>? genres,
    @JsonKey(name: 'genre_ids') List<int>? genreIds,
    @JsonKey(name: 'imdb_id') String? imdbId,
    @JsonKey(name: 'original_language') String? originalLanguage,
    double? popularity,
    String? status,
    String? tagline,
  }) = _TMDBMetadata;

  factory TMDBMetadata.fromJson(Map<String, dynamic> json) =>
      _$TMDBMetadataFromJson(json);
}

@freezed
abstract class TMDBGenre with _$TMDBGenre {
  const factory TMDBGenre({
    required int id,
    required String name,
  }) = _TMDBGenre;

  factory TMDBGenre.fromJson(Map<String, dynamic> json) =>
      _$TMDBGenreFromJson(json);
}

@freezed
abstract class TMDBCredits with _$TMDBCredits {
  const factory TMDBCredits({
    List<TMDBCastMember>? cast,
    List<TMDBCrewMember>? crew,
  }) = _TMDBCredits;

  factory TMDBCredits.fromJson(Map<String, dynamic> json) =>
      _$TMDBCreditsFromJson(json);
}

@freezed
abstract class TMDBCastMember with _$TMDBCastMember {
  const factory TMDBCastMember({
    required int id,
    required String name,
    String? character,
    @JsonKey(name: 'profile_path') String? profilePath,
    int? order,
  }) = _TMDBCastMember;

  factory TMDBCastMember.fromJson(Map<String, dynamic> json) =>
      _$TMDBCastMemberFromJson(json);
}

@freezed
abstract class TMDBCrewMember with _$TMDBCrewMember {
  const factory TMDBCrewMember({
    required int id,
    required String name,
    String? job,
    String? department,
    @JsonKey(name: 'profile_path') String? profilePath,
  }) = _TMDBCrewMember;

  factory TMDBCrewMember.fromJson(Map<String, dynamic> json) =>
      _$TMDBCrewMemberFromJson(json);
}

@freezed
abstract class TMDBExternalIds with _$TMDBExternalIds {
  const factory TMDBExternalIds({
    @JsonKey(name: 'imdb_id') String? imdbId,
    @JsonKey(name: 'tvdb_id') int? tvdbId,
    @JsonKey(name: 'freebase_mid') String? freebaseMid,
    @JsonKey(name: 'freebase_id') String? freebaseId,
  }) = _TMDBExternalIds;

  factory TMDBExternalIds.fromJson(Map<String, dynamic> json) =>
      _$TMDBExternalIdsFromJson(json);
}

@freezed
abstract class TMDBReview with _$TMDBReview {
  const factory TMDBReview({
    required String id,
    required String author,
    required String content,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
    String? url,
    @JsonKey(name: 'author_details') TMDBAuthorDetails? authorDetails,
  }) = _TMDBReview;

  factory TMDBReview.fromJson(Map<String, dynamic> json) =>
      _$TMDBReviewFromJson(json);
}

@freezed
abstract class TMDBAuthorDetails with _$TMDBAuthorDetails {
  const factory TMDBAuthorDetails({
    String? name,
    String? username,
    @JsonKey(name: 'avatar_path') String? avatarPath,
    double? rating,
  }) = _TMDBAuthorDetails;

  factory TMDBAuthorDetails.fromJson(Map<String, dynamic> json) =>
      _$TMDBAuthorDetailsFromJson(json);
}

@freezed
abstract class TMDBReviewsResponse with _$TMDBReviewsResponse {
  const factory TMDBReviewsResponse({
    required List<TMDBReview> results,
    int? page,
    @JsonKey(name: 'total_pages') int? totalPages,
    @JsonKey(name: 'total_results') int? totalResults,
  }) = _TMDBReviewsResponse;

  factory TMDBReviewsResponse.fromJson(Map<String, dynamic> json) =>
      _$TMDBReviewsResponseFromJson(json);
}

@freezed
abstract class TMDBMetadataResponse with _$TMDBMetadataResponse {
  const factory TMDBMetadataResponse({
    TMDBMetadata? main,
    TMDBCredits? credits,
    TMDBReviewsResponse? reviews,
  }) = _TMDBMetadataResponse;

  factory TMDBMetadataResponse.fromJson(Map<String, dynamic> json) =>
      _$TMDBMetadataResponseFromJson(json);
}
