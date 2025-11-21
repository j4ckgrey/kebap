// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tmdb_metadata_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TMDBMetadata _$TMDBMetadataFromJson(Map<String, dynamic> json) =>
    _TMDBMetadata(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String?,
      name: json['name'] as String?,
      overview: json['overview'] as String?,
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      voteAverage: (json['vote_average'] as num?)?.toDouble(),
      voteCount: (json['vote_count'] as num?)?.toInt(),
      releaseDate: json['release_date'] as String?,
      firstAirDate: json['first_air_date'] as String?,
      runtime: (json['runtime'] as num?)?.toInt(),
      numberOfSeasons: (json['number_of_seasons'] as num?)?.toInt(),
      numberOfEpisodes: (json['number_of_episodes'] as num?)?.toInt(),
      genres: (json['genres'] as List<dynamic>?)
          ?.map((e) => TMDBGenre.fromJson(e as Map<String, dynamic>))
          .toList(),
      genreIds: (json['genre_ids'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      imdbId: json['imdb_id'] as String?,
      originalLanguage: json['original_language'] as String?,
      popularity: (json['popularity'] as num?)?.toDouble(),
      status: json['status'] as String?,
      tagline: json['tagline'] as String?,
    );

Map<String, dynamic> _$TMDBMetadataToJson(_TMDBMetadata instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'name': instance.name,
      'overview': instance.overview,
      'poster_path': instance.posterPath,
      'backdrop_path': instance.backdropPath,
      'vote_average': instance.voteAverage,
      'vote_count': instance.voteCount,
      'release_date': instance.releaseDate,
      'first_air_date': instance.firstAirDate,
      'runtime': instance.runtime,
      'number_of_seasons': instance.numberOfSeasons,
      'number_of_episodes': instance.numberOfEpisodes,
      'genres': instance.genres,
      'genre_ids': instance.genreIds,
      'imdb_id': instance.imdbId,
      'original_language': instance.originalLanguage,
      'popularity': instance.popularity,
      'status': instance.status,
      'tagline': instance.tagline,
    };

_TMDBGenre _$TMDBGenreFromJson(Map<String, dynamic> json) => _TMDBGenre(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$TMDBGenreToJson(_TMDBGenre instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

_TMDBCredits _$TMDBCreditsFromJson(Map<String, dynamic> json) => _TMDBCredits(
      cast: (json['cast'] as List<dynamic>?)
          ?.map((e) => TMDBCastMember.fromJson(e as Map<String, dynamic>))
          .toList(),
      crew: (json['crew'] as List<dynamic>?)
          ?.map((e) => TMDBCrewMember.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TMDBCreditsToJson(_TMDBCredits instance) =>
    <String, dynamic>{
      'cast': instance.cast,
      'crew': instance.crew,
    };

_TMDBCastMember _$TMDBCastMemberFromJson(Map<String, dynamic> json) =>
    _TMDBCastMember(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      character: json['character'] as String?,
      profilePath: json['profile_path'] as String?,
      order: (json['order'] as num?)?.toInt(),
    );

Map<String, dynamic> _$TMDBCastMemberToJson(_TMDBCastMember instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'character': instance.character,
      'profile_path': instance.profilePath,
      'order': instance.order,
    };

_TMDBCrewMember _$TMDBCrewMemberFromJson(Map<String, dynamic> json) =>
    _TMDBCrewMember(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      job: json['job'] as String?,
      department: json['department'] as String?,
      profilePath: json['profile_path'] as String?,
    );

Map<String, dynamic> _$TMDBCrewMemberToJson(_TMDBCrewMember instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'job': instance.job,
      'department': instance.department,
      'profile_path': instance.profilePath,
    };

_TMDBExternalIds _$TMDBExternalIdsFromJson(Map<String, dynamic> json) =>
    _TMDBExternalIds(
      imdbId: json['imdb_id'] as String?,
      tvdbId: (json['tvdb_id'] as num?)?.toInt(),
      freebaseMid: json['freebase_mid'] as String?,
      freebaseId: json['freebase_id'] as String?,
    );

Map<String, dynamic> _$TMDBExternalIdsToJson(_TMDBExternalIds instance) =>
    <String, dynamic>{
      'imdb_id': instance.imdbId,
      'tvdb_id': instance.tvdbId,
      'freebase_mid': instance.freebaseMid,
      'freebase_id': instance.freebaseId,
    };

_TMDBReview _$TMDBReviewFromJson(Map<String, dynamic> json) => _TMDBReview(
      id: json['id'] as String,
      author: json['author'] as String,
      content: json['content'] as String,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      url: json['url'] as String?,
      authorDetails: json['author_details'] == null
          ? null
          : TMDBAuthorDetails.fromJson(
              json['author_details'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TMDBReviewToJson(_TMDBReview instance) =>
    <String, dynamic>{
      'id': instance.id,
      'author': instance.author,
      'content': instance.content,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'url': instance.url,
      'author_details': instance.authorDetails,
    };

_TMDBAuthorDetails _$TMDBAuthorDetailsFromJson(Map<String, dynamic> json) =>
    _TMDBAuthorDetails(
      name: json['name'] as String?,
      username: json['username'] as String?,
      avatarPath: json['avatar_path'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$TMDBAuthorDetailsToJson(_TMDBAuthorDetails instance) =>
    <String, dynamic>{
      'name': instance.name,
      'username': instance.username,
      'avatar_path': instance.avatarPath,
      'rating': instance.rating,
    };

_TMDBReviewsResponse _$TMDBReviewsResponseFromJson(Map<String, dynamic> json) =>
    _TMDBReviewsResponse(
      results: (json['results'] as List<dynamic>)
          .map((e) => TMDBReview.fromJson(e as Map<String, dynamic>))
          .toList(),
      page: (json['page'] as num?)?.toInt(),
      totalPages: (json['total_pages'] as num?)?.toInt(),
      totalResults: (json['total_results'] as num?)?.toInt(),
    );

Map<String, dynamic> _$TMDBReviewsResponseToJson(
        _TMDBReviewsResponse instance) =>
    <String, dynamic>{
      'results': instance.results,
      'page': instance.page,
      'total_pages': instance.totalPages,
      'total_results': instance.totalResults,
    };

_TMDBMetadataResponse _$TMDBMetadataResponseFromJson(
        Map<String, dynamic> json) =>
    _TMDBMetadataResponse(
      main: json['main'] == null
          ? null
          : TMDBMetadata.fromJson(json['main'] as Map<String, dynamic>),
      credits: json['credits'] == null
          ? null
          : TMDBCredits.fromJson(json['credits'] as Map<String, dynamic>),
      reviews: json['reviews'] == null
          ? null
          : TMDBReviewsResponse.fromJson(
              json['reviews'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TMDBMetadataResponseToJson(
        _TMDBMetadataResponse instance) =>
    <String, dynamic>{
      'main': instance.main,
      'credits': instance.credits,
      'reviews': instance.reviews,
    };
