// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tmdb_metadata_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TMDBMetadata {
  int get id;
  String? get title;
  String? get name;
  String? get overview;
  @JsonKey(name: 'poster_path')
  String? get posterPath;
  @JsonKey(name: 'backdrop_path')
  String? get backdropPath;
  @JsonKey(name: 'vote_average')
  double? get voteAverage;
  @JsonKey(name: 'vote_count')
  int? get voteCount;
  @JsonKey(name: 'release_date')
  String? get releaseDate;
  @JsonKey(name: 'first_air_date')
  String? get firstAirDate;
  int? get runtime;
  @JsonKey(name: 'number_of_seasons')
  int? get numberOfSeasons;
  @JsonKey(name: 'number_of_episodes')
  int? get numberOfEpisodes;
  List<TMDBGenre>? get genres;
  @JsonKey(name: 'genre_ids')
  List<int>? get genreIds;
  @JsonKey(name: 'imdb_id')
  String? get imdbId;
  @JsonKey(name: 'original_language')
  String? get originalLanguage;
  double? get popularity;
  String? get status;
  String? get tagline;

  /// Create a copy of TMDBMetadata
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TMDBMetadataCopyWith<TMDBMetadata> get copyWith =>
      _$TMDBMetadataCopyWithImpl<TMDBMetadata>(
          this as TMDBMetadata, _$identity);

  /// Serializes this TMDBMetadata to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TMDBMetadata &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.overview, overview) ||
                other.overview == overview) &&
            (identical(other.posterPath, posterPath) ||
                other.posterPath == posterPath) &&
            (identical(other.backdropPath, backdropPath) ||
                other.backdropPath == backdropPath) &&
            (identical(other.voteAverage, voteAverage) ||
                other.voteAverage == voteAverage) &&
            (identical(other.voteCount, voteCount) ||
                other.voteCount == voteCount) &&
            (identical(other.releaseDate, releaseDate) ||
                other.releaseDate == releaseDate) &&
            (identical(other.firstAirDate, firstAirDate) ||
                other.firstAirDate == firstAirDate) &&
            (identical(other.runtime, runtime) || other.runtime == runtime) &&
            (identical(other.numberOfSeasons, numberOfSeasons) ||
                other.numberOfSeasons == numberOfSeasons) &&
            (identical(other.numberOfEpisodes, numberOfEpisodes) ||
                other.numberOfEpisodes == numberOfEpisodes) &&
            const DeepCollectionEquality().equals(other.genres, genres) &&
            const DeepCollectionEquality().equals(other.genreIds, genreIds) &&
            (identical(other.imdbId, imdbId) || other.imdbId == imdbId) &&
            (identical(other.originalLanguage, originalLanguage) ||
                other.originalLanguage == originalLanguage) &&
            (identical(other.popularity, popularity) ||
                other.popularity == popularity) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.tagline, tagline) || other.tagline == tagline));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        title,
        name,
        overview,
        posterPath,
        backdropPath,
        voteAverage,
        voteCount,
        releaseDate,
        firstAirDate,
        runtime,
        numberOfSeasons,
        numberOfEpisodes,
        const DeepCollectionEquality().hash(genres),
        const DeepCollectionEquality().hash(genreIds),
        imdbId,
        originalLanguage,
        popularity,
        status,
        tagline
      ]);

  @override
  String toString() {
    return 'TMDBMetadata(id: $id, title: $title, name: $name, overview: $overview, posterPath: $posterPath, backdropPath: $backdropPath, voteAverage: $voteAverage, voteCount: $voteCount, releaseDate: $releaseDate, firstAirDate: $firstAirDate, runtime: $runtime, numberOfSeasons: $numberOfSeasons, numberOfEpisodes: $numberOfEpisodes, genres: $genres, genreIds: $genreIds, imdbId: $imdbId, originalLanguage: $originalLanguage, popularity: $popularity, status: $status, tagline: $tagline)';
  }
}

/// @nodoc
abstract mixin class $TMDBMetadataCopyWith<$Res> {
  factory $TMDBMetadataCopyWith(
          TMDBMetadata value, $Res Function(TMDBMetadata) _then) =
      _$TMDBMetadataCopyWithImpl;
  @useResult
  $Res call(
      {int id,
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
      String? tagline});
}

/// @nodoc
class _$TMDBMetadataCopyWithImpl<$Res> implements $TMDBMetadataCopyWith<$Res> {
  _$TMDBMetadataCopyWithImpl(this._self, this._then);

  final TMDBMetadata _self;
  final $Res Function(TMDBMetadata) _then;

  /// Create a copy of TMDBMetadata
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = freezed,
    Object? name = freezed,
    Object? overview = freezed,
    Object? posterPath = freezed,
    Object? backdropPath = freezed,
    Object? voteAverage = freezed,
    Object? voteCount = freezed,
    Object? releaseDate = freezed,
    Object? firstAirDate = freezed,
    Object? runtime = freezed,
    Object? numberOfSeasons = freezed,
    Object? numberOfEpisodes = freezed,
    Object? genres = freezed,
    Object? genreIds = freezed,
    Object? imdbId = freezed,
    Object? originalLanguage = freezed,
    Object? popularity = freezed,
    Object? status = freezed,
    Object? tagline = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: freezed == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      overview: freezed == overview
          ? _self.overview
          : overview // ignore: cast_nullable_to_non_nullable
              as String?,
      posterPath: freezed == posterPath
          ? _self.posterPath
          : posterPath // ignore: cast_nullable_to_non_nullable
              as String?,
      backdropPath: freezed == backdropPath
          ? _self.backdropPath
          : backdropPath // ignore: cast_nullable_to_non_nullable
              as String?,
      voteAverage: freezed == voteAverage
          ? _self.voteAverage
          : voteAverage // ignore: cast_nullable_to_non_nullable
              as double?,
      voteCount: freezed == voteCount
          ? _self.voteCount
          : voteCount // ignore: cast_nullable_to_non_nullable
              as int?,
      releaseDate: freezed == releaseDate
          ? _self.releaseDate
          : releaseDate // ignore: cast_nullable_to_non_nullable
              as String?,
      firstAirDate: freezed == firstAirDate
          ? _self.firstAirDate
          : firstAirDate // ignore: cast_nullable_to_non_nullable
              as String?,
      runtime: freezed == runtime
          ? _self.runtime
          : runtime // ignore: cast_nullable_to_non_nullable
              as int?,
      numberOfSeasons: freezed == numberOfSeasons
          ? _self.numberOfSeasons
          : numberOfSeasons // ignore: cast_nullable_to_non_nullable
              as int?,
      numberOfEpisodes: freezed == numberOfEpisodes
          ? _self.numberOfEpisodes
          : numberOfEpisodes // ignore: cast_nullable_to_non_nullable
              as int?,
      genres: freezed == genres
          ? _self.genres
          : genres // ignore: cast_nullable_to_non_nullable
              as List<TMDBGenre>?,
      genreIds: freezed == genreIds
          ? _self.genreIds
          : genreIds // ignore: cast_nullable_to_non_nullable
              as List<int>?,
      imdbId: freezed == imdbId
          ? _self.imdbId
          : imdbId // ignore: cast_nullable_to_non_nullable
              as String?,
      originalLanguage: freezed == originalLanguage
          ? _self.originalLanguage
          : originalLanguage // ignore: cast_nullable_to_non_nullable
              as String?,
      popularity: freezed == popularity
          ? _self.popularity
          : popularity // ignore: cast_nullable_to_non_nullable
              as double?,
      status: freezed == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      tagline: freezed == tagline
          ? _self.tagline
          : tagline // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [TMDBMetadata].
extension TMDBMetadataPatterns on TMDBMetadata {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_TMDBMetadata value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TMDBMetadata() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_TMDBMetadata value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TMDBMetadata():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_TMDBMetadata value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TMDBMetadata() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            int id,
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
            String? tagline)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TMDBMetadata() when $default != null:
        return $default(
            _that.id,
            _that.title,
            _that.name,
            _that.overview,
            _that.posterPath,
            _that.backdropPath,
            _that.voteAverage,
            _that.voteCount,
            _that.releaseDate,
            _that.firstAirDate,
            _that.runtime,
            _that.numberOfSeasons,
            _that.numberOfEpisodes,
            _that.genres,
            _that.genreIds,
            _that.imdbId,
            _that.originalLanguage,
            _that.popularity,
            _that.status,
            _that.tagline);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            int id,
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
            String? tagline)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TMDBMetadata():
        return $default(
            _that.id,
            _that.title,
            _that.name,
            _that.overview,
            _that.posterPath,
            _that.backdropPath,
            _that.voteAverage,
            _that.voteCount,
            _that.releaseDate,
            _that.firstAirDate,
            _that.runtime,
            _that.numberOfSeasons,
            _that.numberOfEpisodes,
            _that.genres,
            _that.genreIds,
            _that.imdbId,
            _that.originalLanguage,
            _that.popularity,
            _that.status,
            _that.tagline);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            int id,
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
            String? tagline)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TMDBMetadata() when $default != null:
        return $default(
            _that.id,
            _that.title,
            _that.name,
            _that.overview,
            _that.posterPath,
            _that.backdropPath,
            _that.voteAverage,
            _that.voteCount,
            _that.releaseDate,
            _that.firstAirDate,
            _that.runtime,
            _that.numberOfSeasons,
            _that.numberOfEpisodes,
            _that.genres,
            _that.genreIds,
            _that.imdbId,
            _that.originalLanguage,
            _that.popularity,
            _that.status,
            _that.tagline);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _TMDBMetadata implements TMDBMetadata {
  const _TMDBMetadata(
      {required this.id,
      this.title,
      this.name,
      this.overview,
      @JsonKey(name: 'poster_path') this.posterPath,
      @JsonKey(name: 'backdrop_path') this.backdropPath,
      @JsonKey(name: 'vote_average') this.voteAverage,
      @JsonKey(name: 'vote_count') this.voteCount,
      @JsonKey(name: 'release_date') this.releaseDate,
      @JsonKey(name: 'first_air_date') this.firstAirDate,
      this.runtime,
      @JsonKey(name: 'number_of_seasons') this.numberOfSeasons,
      @JsonKey(name: 'number_of_episodes') this.numberOfEpisodes,
      final List<TMDBGenre>? genres,
      @JsonKey(name: 'genre_ids') final List<int>? genreIds,
      @JsonKey(name: 'imdb_id') this.imdbId,
      @JsonKey(name: 'original_language') this.originalLanguage,
      this.popularity,
      this.status,
      this.tagline})
      : _genres = genres,
        _genreIds = genreIds;
  factory _TMDBMetadata.fromJson(Map<String, dynamic> json) =>
      _$TMDBMetadataFromJson(json);

  @override
  final int id;
  @override
  final String? title;
  @override
  final String? name;
  @override
  final String? overview;
  @override
  @JsonKey(name: 'poster_path')
  final String? posterPath;
  @override
  @JsonKey(name: 'backdrop_path')
  final String? backdropPath;
  @override
  @JsonKey(name: 'vote_average')
  final double? voteAverage;
  @override
  @JsonKey(name: 'vote_count')
  final int? voteCount;
  @override
  @JsonKey(name: 'release_date')
  final String? releaseDate;
  @override
  @JsonKey(name: 'first_air_date')
  final String? firstAirDate;
  @override
  final int? runtime;
  @override
  @JsonKey(name: 'number_of_seasons')
  final int? numberOfSeasons;
  @override
  @JsonKey(name: 'number_of_episodes')
  final int? numberOfEpisodes;
  final List<TMDBGenre>? _genres;
  @override
  List<TMDBGenre>? get genres {
    final value = _genres;
    if (value == null) return null;
    if (_genres is EqualUnmodifiableListView) return _genres;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<int>? _genreIds;
  @override
  @JsonKey(name: 'genre_ids')
  List<int>? get genreIds {
    final value = _genreIds;
    if (value == null) return null;
    if (_genreIds is EqualUnmodifiableListView) return _genreIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'imdb_id')
  final String? imdbId;
  @override
  @JsonKey(name: 'original_language')
  final String? originalLanguage;
  @override
  final double? popularity;
  @override
  final String? status;
  @override
  final String? tagline;

  /// Create a copy of TMDBMetadata
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TMDBMetadataCopyWith<_TMDBMetadata> get copyWith =>
      __$TMDBMetadataCopyWithImpl<_TMDBMetadata>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TMDBMetadataToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TMDBMetadata &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.overview, overview) ||
                other.overview == overview) &&
            (identical(other.posterPath, posterPath) ||
                other.posterPath == posterPath) &&
            (identical(other.backdropPath, backdropPath) ||
                other.backdropPath == backdropPath) &&
            (identical(other.voteAverage, voteAverage) ||
                other.voteAverage == voteAverage) &&
            (identical(other.voteCount, voteCount) ||
                other.voteCount == voteCount) &&
            (identical(other.releaseDate, releaseDate) ||
                other.releaseDate == releaseDate) &&
            (identical(other.firstAirDate, firstAirDate) ||
                other.firstAirDate == firstAirDate) &&
            (identical(other.runtime, runtime) || other.runtime == runtime) &&
            (identical(other.numberOfSeasons, numberOfSeasons) ||
                other.numberOfSeasons == numberOfSeasons) &&
            (identical(other.numberOfEpisodes, numberOfEpisodes) ||
                other.numberOfEpisodes == numberOfEpisodes) &&
            const DeepCollectionEquality().equals(other._genres, _genres) &&
            const DeepCollectionEquality().equals(other._genreIds, _genreIds) &&
            (identical(other.imdbId, imdbId) || other.imdbId == imdbId) &&
            (identical(other.originalLanguage, originalLanguage) ||
                other.originalLanguage == originalLanguage) &&
            (identical(other.popularity, popularity) ||
                other.popularity == popularity) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.tagline, tagline) || other.tagline == tagline));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        title,
        name,
        overview,
        posterPath,
        backdropPath,
        voteAverage,
        voteCount,
        releaseDate,
        firstAirDate,
        runtime,
        numberOfSeasons,
        numberOfEpisodes,
        const DeepCollectionEquality().hash(_genres),
        const DeepCollectionEquality().hash(_genreIds),
        imdbId,
        originalLanguage,
        popularity,
        status,
        tagline
      ]);

  @override
  String toString() {
    return 'TMDBMetadata(id: $id, title: $title, name: $name, overview: $overview, posterPath: $posterPath, backdropPath: $backdropPath, voteAverage: $voteAverage, voteCount: $voteCount, releaseDate: $releaseDate, firstAirDate: $firstAirDate, runtime: $runtime, numberOfSeasons: $numberOfSeasons, numberOfEpisodes: $numberOfEpisodes, genres: $genres, genreIds: $genreIds, imdbId: $imdbId, originalLanguage: $originalLanguage, popularity: $popularity, status: $status, tagline: $tagline)';
  }
}

/// @nodoc
abstract mixin class _$TMDBMetadataCopyWith<$Res>
    implements $TMDBMetadataCopyWith<$Res> {
  factory _$TMDBMetadataCopyWith(
          _TMDBMetadata value, $Res Function(_TMDBMetadata) _then) =
      __$TMDBMetadataCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int id,
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
      String? tagline});
}

/// @nodoc
class __$TMDBMetadataCopyWithImpl<$Res>
    implements _$TMDBMetadataCopyWith<$Res> {
  __$TMDBMetadataCopyWithImpl(this._self, this._then);

  final _TMDBMetadata _self;
  final $Res Function(_TMDBMetadata) _then;

  /// Create a copy of TMDBMetadata
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? title = freezed,
    Object? name = freezed,
    Object? overview = freezed,
    Object? posterPath = freezed,
    Object? backdropPath = freezed,
    Object? voteAverage = freezed,
    Object? voteCount = freezed,
    Object? releaseDate = freezed,
    Object? firstAirDate = freezed,
    Object? runtime = freezed,
    Object? numberOfSeasons = freezed,
    Object? numberOfEpisodes = freezed,
    Object? genres = freezed,
    Object? genreIds = freezed,
    Object? imdbId = freezed,
    Object? originalLanguage = freezed,
    Object? popularity = freezed,
    Object? status = freezed,
    Object? tagline = freezed,
  }) {
    return _then(_TMDBMetadata(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: freezed == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      overview: freezed == overview
          ? _self.overview
          : overview // ignore: cast_nullable_to_non_nullable
              as String?,
      posterPath: freezed == posterPath
          ? _self.posterPath
          : posterPath // ignore: cast_nullable_to_non_nullable
              as String?,
      backdropPath: freezed == backdropPath
          ? _self.backdropPath
          : backdropPath // ignore: cast_nullable_to_non_nullable
              as String?,
      voteAverage: freezed == voteAverage
          ? _self.voteAverage
          : voteAverage // ignore: cast_nullable_to_non_nullable
              as double?,
      voteCount: freezed == voteCount
          ? _self.voteCount
          : voteCount // ignore: cast_nullable_to_non_nullable
              as int?,
      releaseDate: freezed == releaseDate
          ? _self.releaseDate
          : releaseDate // ignore: cast_nullable_to_non_nullable
              as String?,
      firstAirDate: freezed == firstAirDate
          ? _self.firstAirDate
          : firstAirDate // ignore: cast_nullable_to_non_nullable
              as String?,
      runtime: freezed == runtime
          ? _self.runtime
          : runtime // ignore: cast_nullable_to_non_nullable
              as int?,
      numberOfSeasons: freezed == numberOfSeasons
          ? _self.numberOfSeasons
          : numberOfSeasons // ignore: cast_nullable_to_non_nullable
              as int?,
      numberOfEpisodes: freezed == numberOfEpisodes
          ? _self.numberOfEpisodes
          : numberOfEpisodes // ignore: cast_nullable_to_non_nullable
              as int?,
      genres: freezed == genres
          ? _self._genres
          : genres // ignore: cast_nullable_to_non_nullable
              as List<TMDBGenre>?,
      genreIds: freezed == genreIds
          ? _self._genreIds
          : genreIds // ignore: cast_nullable_to_non_nullable
              as List<int>?,
      imdbId: freezed == imdbId
          ? _self.imdbId
          : imdbId // ignore: cast_nullable_to_non_nullable
              as String?,
      originalLanguage: freezed == originalLanguage
          ? _self.originalLanguage
          : originalLanguage // ignore: cast_nullable_to_non_nullable
              as String?,
      popularity: freezed == popularity
          ? _self.popularity
          : popularity // ignore: cast_nullable_to_non_nullable
              as double?,
      status: freezed == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      tagline: freezed == tagline
          ? _self.tagline
          : tagline // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$TMDBGenre {
  int get id;
  String get name;

  /// Create a copy of TMDBGenre
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TMDBGenreCopyWith<TMDBGenre> get copyWith =>
      _$TMDBGenreCopyWithImpl<TMDBGenre>(this as TMDBGenre, _$identity);

  /// Serializes this TMDBGenre to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TMDBGenre &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name);

  @override
  String toString() {
    return 'TMDBGenre(id: $id, name: $name)';
  }
}

/// @nodoc
abstract mixin class $TMDBGenreCopyWith<$Res> {
  factory $TMDBGenreCopyWith(TMDBGenre value, $Res Function(TMDBGenre) _then) =
      _$TMDBGenreCopyWithImpl;
  @useResult
  $Res call({int id, String name});
}

/// @nodoc
class _$TMDBGenreCopyWithImpl<$Res> implements $TMDBGenreCopyWith<$Res> {
  _$TMDBGenreCopyWithImpl(this._self, this._then);

  final TMDBGenre _self;
  final $Res Function(TMDBGenre) _then;

  /// Create a copy of TMDBGenre
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [TMDBGenre].
extension TMDBGenrePatterns on TMDBGenre {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_TMDBGenre value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TMDBGenre() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_TMDBGenre value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TMDBGenre():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_TMDBGenre value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TMDBGenre() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(int id, String name)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TMDBGenre() when $default != null:
        return $default(_that.id, _that.name);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(int id, String name) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TMDBGenre():
        return $default(_that.id, _that.name);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(int id, String name)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TMDBGenre() when $default != null:
        return $default(_that.id, _that.name);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _TMDBGenre implements TMDBGenre {
  const _TMDBGenre({required this.id, required this.name});
  factory _TMDBGenre.fromJson(Map<String, dynamic> json) =>
      _$TMDBGenreFromJson(json);

  @override
  final int id;
  @override
  final String name;

  /// Create a copy of TMDBGenre
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TMDBGenreCopyWith<_TMDBGenre> get copyWith =>
      __$TMDBGenreCopyWithImpl<_TMDBGenre>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TMDBGenreToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TMDBGenre &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name);

  @override
  String toString() {
    return 'TMDBGenre(id: $id, name: $name)';
  }
}

/// @nodoc
abstract mixin class _$TMDBGenreCopyWith<$Res>
    implements $TMDBGenreCopyWith<$Res> {
  factory _$TMDBGenreCopyWith(
          _TMDBGenre value, $Res Function(_TMDBGenre) _then) =
      __$TMDBGenreCopyWithImpl;
  @override
  @useResult
  $Res call({int id, String name});
}

/// @nodoc
class __$TMDBGenreCopyWithImpl<$Res> implements _$TMDBGenreCopyWith<$Res> {
  __$TMDBGenreCopyWithImpl(this._self, this._then);

  final _TMDBGenre _self;
  final $Res Function(_TMDBGenre) _then;

  /// Create a copy of TMDBGenre
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
  }) {
    return _then(_TMDBGenre(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$TMDBCredits {
  List<TMDBCastMember>? get cast;
  List<TMDBCrewMember>? get crew;

  /// Create a copy of TMDBCredits
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TMDBCreditsCopyWith<TMDBCredits> get copyWith =>
      _$TMDBCreditsCopyWithImpl<TMDBCredits>(this as TMDBCredits, _$identity);

  /// Serializes this TMDBCredits to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TMDBCredits &&
            const DeepCollectionEquality().equals(other.cast, cast) &&
            const DeepCollectionEquality().equals(other.crew, crew));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(cast),
      const DeepCollectionEquality().hash(crew));

  @override
  String toString() {
    return 'TMDBCredits(cast: $cast, crew: $crew)';
  }
}

/// @nodoc
abstract mixin class $TMDBCreditsCopyWith<$Res> {
  factory $TMDBCreditsCopyWith(
          TMDBCredits value, $Res Function(TMDBCredits) _then) =
      _$TMDBCreditsCopyWithImpl;
  @useResult
  $Res call({List<TMDBCastMember>? cast, List<TMDBCrewMember>? crew});
}

/// @nodoc
class _$TMDBCreditsCopyWithImpl<$Res> implements $TMDBCreditsCopyWith<$Res> {
  _$TMDBCreditsCopyWithImpl(this._self, this._then);

  final TMDBCredits _self;
  final $Res Function(TMDBCredits) _then;

  /// Create a copy of TMDBCredits
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cast = freezed,
    Object? crew = freezed,
  }) {
    return _then(_self.copyWith(
      cast: freezed == cast
          ? _self.cast
          : cast // ignore: cast_nullable_to_non_nullable
              as List<TMDBCastMember>?,
      crew: freezed == crew
          ? _self.crew
          : crew // ignore: cast_nullable_to_non_nullable
              as List<TMDBCrewMember>?,
    ));
  }
}

/// Adds pattern-matching-related methods to [TMDBCredits].
extension TMDBCreditsPatterns on TMDBCredits {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_TMDBCredits value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TMDBCredits() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_TMDBCredits value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TMDBCredits():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_TMDBCredits value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TMDBCredits() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(List<TMDBCastMember>? cast, List<TMDBCrewMember>? crew)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TMDBCredits() when $default != null:
        return $default(_that.cast, _that.crew);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(List<TMDBCastMember>? cast, List<TMDBCrewMember>? crew)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TMDBCredits():
        return $default(_that.cast, _that.crew);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(List<TMDBCastMember>? cast, List<TMDBCrewMember>? crew)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TMDBCredits() when $default != null:
        return $default(_that.cast, _that.crew);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _TMDBCredits implements TMDBCredits {
  const _TMDBCredits(
      {final List<TMDBCastMember>? cast, final List<TMDBCrewMember>? crew})
      : _cast = cast,
        _crew = crew;
  factory _TMDBCredits.fromJson(Map<String, dynamic> json) =>
      _$TMDBCreditsFromJson(json);

  final List<TMDBCastMember>? _cast;
  @override
  List<TMDBCastMember>? get cast {
    final value = _cast;
    if (value == null) return null;
    if (_cast is EqualUnmodifiableListView) return _cast;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<TMDBCrewMember>? _crew;
  @override
  List<TMDBCrewMember>? get crew {
    final value = _crew;
    if (value == null) return null;
    if (_crew is EqualUnmodifiableListView) return _crew;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// Create a copy of TMDBCredits
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TMDBCreditsCopyWith<_TMDBCredits> get copyWith =>
      __$TMDBCreditsCopyWithImpl<_TMDBCredits>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TMDBCreditsToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TMDBCredits &&
            const DeepCollectionEquality().equals(other._cast, _cast) &&
            const DeepCollectionEquality().equals(other._crew, _crew));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_cast),
      const DeepCollectionEquality().hash(_crew));

  @override
  String toString() {
    return 'TMDBCredits(cast: $cast, crew: $crew)';
  }
}

/// @nodoc
abstract mixin class _$TMDBCreditsCopyWith<$Res>
    implements $TMDBCreditsCopyWith<$Res> {
  factory _$TMDBCreditsCopyWith(
          _TMDBCredits value, $Res Function(_TMDBCredits) _then) =
      __$TMDBCreditsCopyWithImpl;
  @override
  @useResult
  $Res call({List<TMDBCastMember>? cast, List<TMDBCrewMember>? crew});
}

/// @nodoc
class __$TMDBCreditsCopyWithImpl<$Res> implements _$TMDBCreditsCopyWith<$Res> {
  __$TMDBCreditsCopyWithImpl(this._self, this._then);

  final _TMDBCredits _self;
  final $Res Function(_TMDBCredits) _then;

  /// Create a copy of TMDBCredits
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? cast = freezed,
    Object? crew = freezed,
  }) {
    return _then(_TMDBCredits(
      cast: freezed == cast
          ? _self._cast
          : cast // ignore: cast_nullable_to_non_nullable
              as List<TMDBCastMember>?,
      crew: freezed == crew
          ? _self._crew
          : crew // ignore: cast_nullable_to_non_nullable
              as List<TMDBCrewMember>?,
    ));
  }
}

/// @nodoc
mixin _$TMDBCastMember {
  int get id;
  String get name;
  String? get character;
  @JsonKey(name: 'profile_path')
  String? get profilePath;
  int? get order;

  /// Create a copy of TMDBCastMember
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TMDBCastMemberCopyWith<TMDBCastMember> get copyWith =>
      _$TMDBCastMemberCopyWithImpl<TMDBCastMember>(
          this as TMDBCastMember, _$identity);

  /// Serializes this TMDBCastMember to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TMDBCastMember &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.character, character) ||
                other.character == character) &&
            (identical(other.profilePath, profilePath) ||
                other.profilePath == profilePath) &&
            (identical(other.order, order) || other.order == order));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, character, profilePath, order);

  @override
  String toString() {
    return 'TMDBCastMember(id: $id, name: $name, character: $character, profilePath: $profilePath, order: $order)';
  }
}

/// @nodoc
abstract mixin class $TMDBCastMemberCopyWith<$Res> {
  factory $TMDBCastMemberCopyWith(
          TMDBCastMember value, $Res Function(TMDBCastMember) _then) =
      _$TMDBCastMemberCopyWithImpl;
  @useResult
  $Res call(
      {int id,
      String name,
      String? character,
      @JsonKey(name: 'profile_path') String? profilePath,
      int? order});
}

/// @nodoc
class _$TMDBCastMemberCopyWithImpl<$Res>
    implements $TMDBCastMemberCopyWith<$Res> {
  _$TMDBCastMemberCopyWithImpl(this._self, this._then);

  final TMDBCastMember _self;
  final $Res Function(TMDBCastMember) _then;

  /// Create a copy of TMDBCastMember
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? character = freezed,
    Object? profilePath = freezed,
    Object? order = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      character: freezed == character
          ? _self.character
          : character // ignore: cast_nullable_to_non_nullable
              as String?,
      profilePath: freezed == profilePath
          ? _self.profilePath
          : profilePath // ignore: cast_nullable_to_non_nullable
              as String?,
      order: freezed == order
          ? _self.order
          : order // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// Adds pattern-matching-related methods to [TMDBCastMember].
extension TMDBCastMemberPatterns on TMDBCastMember {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_TMDBCastMember value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TMDBCastMember() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_TMDBCastMember value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TMDBCastMember():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_TMDBCastMember value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TMDBCastMember() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(int id, String name, String? character,
            @JsonKey(name: 'profile_path') String? profilePath, int? order)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TMDBCastMember() when $default != null:
        return $default(_that.id, _that.name, _that.character,
            _that.profilePath, _that.order);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(int id, String name, String? character,
            @JsonKey(name: 'profile_path') String? profilePath, int? order)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TMDBCastMember():
        return $default(_that.id, _that.name, _that.character,
            _that.profilePath, _that.order);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(int id, String name, String? character,
            @JsonKey(name: 'profile_path') String? profilePath, int? order)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TMDBCastMember() when $default != null:
        return $default(_that.id, _that.name, _that.character,
            _that.profilePath, _that.order);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _TMDBCastMember implements TMDBCastMember {
  const _TMDBCastMember(
      {required this.id,
      required this.name,
      this.character,
      @JsonKey(name: 'profile_path') this.profilePath,
      this.order});
  factory _TMDBCastMember.fromJson(Map<String, dynamic> json) =>
      _$TMDBCastMemberFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String? character;
  @override
  @JsonKey(name: 'profile_path')
  final String? profilePath;
  @override
  final int? order;

  /// Create a copy of TMDBCastMember
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TMDBCastMemberCopyWith<_TMDBCastMember> get copyWith =>
      __$TMDBCastMemberCopyWithImpl<_TMDBCastMember>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TMDBCastMemberToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TMDBCastMember &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.character, character) ||
                other.character == character) &&
            (identical(other.profilePath, profilePath) ||
                other.profilePath == profilePath) &&
            (identical(other.order, order) || other.order == order));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, character, profilePath, order);

  @override
  String toString() {
    return 'TMDBCastMember(id: $id, name: $name, character: $character, profilePath: $profilePath, order: $order)';
  }
}

/// @nodoc
abstract mixin class _$TMDBCastMemberCopyWith<$Res>
    implements $TMDBCastMemberCopyWith<$Res> {
  factory _$TMDBCastMemberCopyWith(
          _TMDBCastMember value, $Res Function(_TMDBCastMember) _then) =
      __$TMDBCastMemberCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int id,
      String name,
      String? character,
      @JsonKey(name: 'profile_path') String? profilePath,
      int? order});
}

/// @nodoc
class __$TMDBCastMemberCopyWithImpl<$Res>
    implements _$TMDBCastMemberCopyWith<$Res> {
  __$TMDBCastMemberCopyWithImpl(this._self, this._then);

  final _TMDBCastMember _self;
  final $Res Function(_TMDBCastMember) _then;

  /// Create a copy of TMDBCastMember
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? character = freezed,
    Object? profilePath = freezed,
    Object? order = freezed,
  }) {
    return _then(_TMDBCastMember(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      character: freezed == character
          ? _self.character
          : character // ignore: cast_nullable_to_non_nullable
              as String?,
      profilePath: freezed == profilePath
          ? _self.profilePath
          : profilePath // ignore: cast_nullable_to_non_nullable
              as String?,
      order: freezed == order
          ? _self.order
          : order // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
mixin _$TMDBCrewMember {
  int get id;
  String get name;
  String? get job;
  String? get department;
  @JsonKey(name: 'profile_path')
  String? get profilePath;

  /// Create a copy of TMDBCrewMember
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TMDBCrewMemberCopyWith<TMDBCrewMember> get copyWith =>
      _$TMDBCrewMemberCopyWithImpl<TMDBCrewMember>(
          this as TMDBCrewMember, _$identity);

  /// Serializes this TMDBCrewMember to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TMDBCrewMember &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.job, job) || other.job == job) &&
            (identical(other.department, department) ||
                other.department == department) &&
            (identical(other.profilePath, profilePath) ||
                other.profilePath == profilePath));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, job, department, profilePath);

  @override
  String toString() {
    return 'TMDBCrewMember(id: $id, name: $name, job: $job, department: $department, profilePath: $profilePath)';
  }
}

/// @nodoc
abstract mixin class $TMDBCrewMemberCopyWith<$Res> {
  factory $TMDBCrewMemberCopyWith(
          TMDBCrewMember value, $Res Function(TMDBCrewMember) _then) =
      _$TMDBCrewMemberCopyWithImpl;
  @useResult
  $Res call(
      {int id,
      String name,
      String? job,
      String? department,
      @JsonKey(name: 'profile_path') String? profilePath});
}

/// @nodoc
class _$TMDBCrewMemberCopyWithImpl<$Res>
    implements $TMDBCrewMemberCopyWith<$Res> {
  _$TMDBCrewMemberCopyWithImpl(this._self, this._then);

  final TMDBCrewMember _self;
  final $Res Function(TMDBCrewMember) _then;

  /// Create a copy of TMDBCrewMember
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? job = freezed,
    Object? department = freezed,
    Object? profilePath = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      job: freezed == job
          ? _self.job
          : job // ignore: cast_nullable_to_non_nullable
              as String?,
      department: freezed == department
          ? _self.department
          : department // ignore: cast_nullable_to_non_nullable
              as String?,
      profilePath: freezed == profilePath
          ? _self.profilePath
          : profilePath // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [TMDBCrewMember].
extension TMDBCrewMemberPatterns on TMDBCrewMember {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_TMDBCrewMember value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TMDBCrewMember() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_TMDBCrewMember value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TMDBCrewMember():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_TMDBCrewMember value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TMDBCrewMember() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(int id, String name, String? job, String? department,
            @JsonKey(name: 'profile_path') String? profilePath)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TMDBCrewMember() when $default != null:
        return $default(_that.id, _that.name, _that.job, _that.department,
            _that.profilePath);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(int id, String name, String? job, String? department,
            @JsonKey(name: 'profile_path') String? profilePath)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TMDBCrewMember():
        return $default(_that.id, _that.name, _that.job, _that.department,
            _that.profilePath);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(int id, String name, String? job, String? department,
            @JsonKey(name: 'profile_path') String? profilePath)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TMDBCrewMember() when $default != null:
        return $default(_that.id, _that.name, _that.job, _that.department,
            _that.profilePath);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _TMDBCrewMember implements TMDBCrewMember {
  const _TMDBCrewMember(
      {required this.id,
      required this.name,
      this.job,
      this.department,
      @JsonKey(name: 'profile_path') this.profilePath});
  factory _TMDBCrewMember.fromJson(Map<String, dynamic> json) =>
      _$TMDBCrewMemberFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String? job;
  @override
  final String? department;
  @override
  @JsonKey(name: 'profile_path')
  final String? profilePath;

  /// Create a copy of TMDBCrewMember
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TMDBCrewMemberCopyWith<_TMDBCrewMember> get copyWith =>
      __$TMDBCrewMemberCopyWithImpl<_TMDBCrewMember>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TMDBCrewMemberToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TMDBCrewMember &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.job, job) || other.job == job) &&
            (identical(other.department, department) ||
                other.department == department) &&
            (identical(other.profilePath, profilePath) ||
                other.profilePath == profilePath));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, job, department, profilePath);

  @override
  String toString() {
    return 'TMDBCrewMember(id: $id, name: $name, job: $job, department: $department, profilePath: $profilePath)';
  }
}

/// @nodoc
abstract mixin class _$TMDBCrewMemberCopyWith<$Res>
    implements $TMDBCrewMemberCopyWith<$Res> {
  factory _$TMDBCrewMemberCopyWith(
          _TMDBCrewMember value, $Res Function(_TMDBCrewMember) _then) =
      __$TMDBCrewMemberCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int id,
      String name,
      String? job,
      String? department,
      @JsonKey(name: 'profile_path') String? profilePath});
}

/// @nodoc
class __$TMDBCrewMemberCopyWithImpl<$Res>
    implements _$TMDBCrewMemberCopyWith<$Res> {
  __$TMDBCrewMemberCopyWithImpl(this._self, this._then);

  final _TMDBCrewMember _self;
  final $Res Function(_TMDBCrewMember) _then;

  /// Create a copy of TMDBCrewMember
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? job = freezed,
    Object? department = freezed,
    Object? profilePath = freezed,
  }) {
    return _then(_TMDBCrewMember(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      job: freezed == job
          ? _self.job
          : job // ignore: cast_nullable_to_non_nullable
              as String?,
      department: freezed == department
          ? _self.department
          : department // ignore: cast_nullable_to_non_nullable
              as String?,
      profilePath: freezed == profilePath
          ? _self.profilePath
          : profilePath // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$TMDBExternalIds {
  @JsonKey(name: 'imdb_id')
  String? get imdbId;
  @JsonKey(name: 'tvdb_id')
  int? get tvdbId;
  @JsonKey(name: 'freebase_mid')
  String? get freebaseMid;
  @JsonKey(name: 'freebase_id')
  String? get freebaseId;

  /// Create a copy of TMDBExternalIds
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TMDBExternalIdsCopyWith<TMDBExternalIds> get copyWith =>
      _$TMDBExternalIdsCopyWithImpl<TMDBExternalIds>(
          this as TMDBExternalIds, _$identity);

  /// Serializes this TMDBExternalIds to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TMDBExternalIds &&
            (identical(other.imdbId, imdbId) || other.imdbId == imdbId) &&
            (identical(other.tvdbId, tvdbId) || other.tvdbId == tvdbId) &&
            (identical(other.freebaseMid, freebaseMid) ||
                other.freebaseMid == freebaseMid) &&
            (identical(other.freebaseId, freebaseId) ||
                other.freebaseId == freebaseId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, imdbId, tvdbId, freebaseMid, freebaseId);

  @override
  String toString() {
    return 'TMDBExternalIds(imdbId: $imdbId, tvdbId: $tvdbId, freebaseMid: $freebaseMid, freebaseId: $freebaseId)';
  }
}

/// @nodoc
abstract mixin class $TMDBExternalIdsCopyWith<$Res> {
  factory $TMDBExternalIdsCopyWith(
          TMDBExternalIds value, $Res Function(TMDBExternalIds) _then) =
      _$TMDBExternalIdsCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'imdb_id') String? imdbId,
      @JsonKey(name: 'tvdb_id') int? tvdbId,
      @JsonKey(name: 'freebase_mid') String? freebaseMid,
      @JsonKey(name: 'freebase_id') String? freebaseId});
}

/// @nodoc
class _$TMDBExternalIdsCopyWithImpl<$Res>
    implements $TMDBExternalIdsCopyWith<$Res> {
  _$TMDBExternalIdsCopyWithImpl(this._self, this._then);

  final TMDBExternalIds _self;
  final $Res Function(TMDBExternalIds) _then;

  /// Create a copy of TMDBExternalIds
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? imdbId = freezed,
    Object? tvdbId = freezed,
    Object? freebaseMid = freezed,
    Object? freebaseId = freezed,
  }) {
    return _then(_self.copyWith(
      imdbId: freezed == imdbId
          ? _self.imdbId
          : imdbId // ignore: cast_nullable_to_non_nullable
              as String?,
      tvdbId: freezed == tvdbId
          ? _self.tvdbId
          : tvdbId // ignore: cast_nullable_to_non_nullable
              as int?,
      freebaseMid: freezed == freebaseMid
          ? _self.freebaseMid
          : freebaseMid // ignore: cast_nullable_to_non_nullable
              as String?,
      freebaseId: freezed == freebaseId
          ? _self.freebaseId
          : freebaseId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [TMDBExternalIds].
extension TMDBExternalIdsPatterns on TMDBExternalIds {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_TMDBExternalIds value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TMDBExternalIds() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_TMDBExternalIds value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TMDBExternalIds():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_TMDBExternalIds value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TMDBExternalIds() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            @JsonKey(name: 'imdb_id') String? imdbId,
            @JsonKey(name: 'tvdb_id') int? tvdbId,
            @JsonKey(name: 'freebase_mid') String? freebaseMid,
            @JsonKey(name: 'freebase_id') String? freebaseId)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TMDBExternalIds() when $default != null:
        return $default(
            _that.imdbId, _that.tvdbId, _that.freebaseMid, _that.freebaseId);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            @JsonKey(name: 'imdb_id') String? imdbId,
            @JsonKey(name: 'tvdb_id') int? tvdbId,
            @JsonKey(name: 'freebase_mid') String? freebaseMid,
            @JsonKey(name: 'freebase_id') String? freebaseId)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TMDBExternalIds():
        return $default(
            _that.imdbId, _that.tvdbId, _that.freebaseMid, _that.freebaseId);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            @JsonKey(name: 'imdb_id') String? imdbId,
            @JsonKey(name: 'tvdb_id') int? tvdbId,
            @JsonKey(name: 'freebase_mid') String? freebaseMid,
            @JsonKey(name: 'freebase_id') String? freebaseId)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TMDBExternalIds() when $default != null:
        return $default(
            _that.imdbId, _that.tvdbId, _that.freebaseMid, _that.freebaseId);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _TMDBExternalIds implements TMDBExternalIds {
  const _TMDBExternalIds(
      {@JsonKey(name: 'imdb_id') this.imdbId,
      @JsonKey(name: 'tvdb_id') this.tvdbId,
      @JsonKey(name: 'freebase_mid') this.freebaseMid,
      @JsonKey(name: 'freebase_id') this.freebaseId});
  factory _TMDBExternalIds.fromJson(Map<String, dynamic> json) =>
      _$TMDBExternalIdsFromJson(json);

  @override
  @JsonKey(name: 'imdb_id')
  final String? imdbId;
  @override
  @JsonKey(name: 'tvdb_id')
  final int? tvdbId;
  @override
  @JsonKey(name: 'freebase_mid')
  final String? freebaseMid;
  @override
  @JsonKey(name: 'freebase_id')
  final String? freebaseId;

  /// Create a copy of TMDBExternalIds
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TMDBExternalIdsCopyWith<_TMDBExternalIds> get copyWith =>
      __$TMDBExternalIdsCopyWithImpl<_TMDBExternalIds>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TMDBExternalIdsToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TMDBExternalIds &&
            (identical(other.imdbId, imdbId) || other.imdbId == imdbId) &&
            (identical(other.tvdbId, tvdbId) || other.tvdbId == tvdbId) &&
            (identical(other.freebaseMid, freebaseMid) ||
                other.freebaseMid == freebaseMid) &&
            (identical(other.freebaseId, freebaseId) ||
                other.freebaseId == freebaseId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, imdbId, tvdbId, freebaseMid, freebaseId);

  @override
  String toString() {
    return 'TMDBExternalIds(imdbId: $imdbId, tvdbId: $tvdbId, freebaseMid: $freebaseMid, freebaseId: $freebaseId)';
  }
}

/// @nodoc
abstract mixin class _$TMDBExternalIdsCopyWith<$Res>
    implements $TMDBExternalIdsCopyWith<$Res> {
  factory _$TMDBExternalIdsCopyWith(
          _TMDBExternalIds value, $Res Function(_TMDBExternalIds) _then) =
      __$TMDBExternalIdsCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'imdb_id') String? imdbId,
      @JsonKey(name: 'tvdb_id') int? tvdbId,
      @JsonKey(name: 'freebase_mid') String? freebaseMid,
      @JsonKey(name: 'freebase_id') String? freebaseId});
}

/// @nodoc
class __$TMDBExternalIdsCopyWithImpl<$Res>
    implements _$TMDBExternalIdsCopyWith<$Res> {
  __$TMDBExternalIdsCopyWithImpl(this._self, this._then);

  final _TMDBExternalIds _self;
  final $Res Function(_TMDBExternalIds) _then;

  /// Create a copy of TMDBExternalIds
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? imdbId = freezed,
    Object? tvdbId = freezed,
    Object? freebaseMid = freezed,
    Object? freebaseId = freezed,
  }) {
    return _then(_TMDBExternalIds(
      imdbId: freezed == imdbId
          ? _self.imdbId
          : imdbId // ignore: cast_nullable_to_non_nullable
              as String?,
      tvdbId: freezed == tvdbId
          ? _self.tvdbId
          : tvdbId // ignore: cast_nullable_to_non_nullable
              as int?,
      freebaseMid: freezed == freebaseMid
          ? _self.freebaseMid
          : freebaseMid // ignore: cast_nullable_to_non_nullable
              as String?,
      freebaseId: freezed == freebaseId
          ? _self.freebaseId
          : freebaseId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$TMDBReview {
  String get id;
  String get author;
  String get content;
  @JsonKey(name: 'created_at')
  String? get createdAt;
  @JsonKey(name: 'updated_at')
  String? get updatedAt;
  String? get url;
  @JsonKey(name: 'author_details')
  TMDBAuthorDetails? get authorDetails;

  /// Create a copy of TMDBReview
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TMDBReviewCopyWith<TMDBReview> get copyWith =>
      _$TMDBReviewCopyWithImpl<TMDBReview>(this as TMDBReview, _$identity);

  /// Serializes this TMDBReview to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TMDBReview &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.author, author) || other.author == author) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.authorDetails, authorDetails) ||
                other.authorDetails == authorDetails));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, author, content, createdAt,
      updatedAt, url, authorDetails);

  @override
  String toString() {
    return 'TMDBReview(id: $id, author: $author, content: $content, createdAt: $createdAt, updatedAt: $updatedAt, url: $url, authorDetails: $authorDetails)';
  }
}

/// @nodoc
abstract mixin class $TMDBReviewCopyWith<$Res> {
  factory $TMDBReviewCopyWith(
          TMDBReview value, $Res Function(TMDBReview) _then) =
      _$TMDBReviewCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String author,
      String content,
      @JsonKey(name: 'created_at') String? createdAt,
      @JsonKey(name: 'updated_at') String? updatedAt,
      String? url,
      @JsonKey(name: 'author_details') TMDBAuthorDetails? authorDetails});

  $TMDBAuthorDetailsCopyWith<$Res>? get authorDetails;
}

/// @nodoc
class _$TMDBReviewCopyWithImpl<$Res> implements $TMDBReviewCopyWith<$Res> {
  _$TMDBReviewCopyWithImpl(this._self, this._then);

  final TMDBReview _self;
  final $Res Function(TMDBReview) _then;

  /// Create a copy of TMDBReview
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? author = null,
    Object? content = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? url = freezed,
    Object? authorDetails = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      author: null == author
          ? _self.author
          : author // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      url: freezed == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      authorDetails: freezed == authorDetails
          ? _self.authorDetails
          : authorDetails // ignore: cast_nullable_to_non_nullable
              as TMDBAuthorDetails?,
    ));
  }

  /// Create a copy of TMDBReview
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TMDBAuthorDetailsCopyWith<$Res>? get authorDetails {
    if (_self.authorDetails == null) {
      return null;
    }

    return $TMDBAuthorDetailsCopyWith<$Res>(_self.authorDetails!, (value) {
      return _then(_self.copyWith(authorDetails: value));
    });
  }
}

/// Adds pattern-matching-related methods to [TMDBReview].
extension TMDBReviewPatterns on TMDBReview {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_TMDBReview value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TMDBReview() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_TMDBReview value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TMDBReview():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_TMDBReview value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TMDBReview() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String id,
            String author,
            String content,
            @JsonKey(name: 'created_at') String? createdAt,
            @JsonKey(name: 'updated_at') String? updatedAt,
            String? url,
            @JsonKey(name: 'author_details') TMDBAuthorDetails? authorDetails)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TMDBReview() when $default != null:
        return $default(_that.id, _that.author, _that.content, _that.createdAt,
            _that.updatedAt, _that.url, _that.authorDetails);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String id,
            String author,
            String content,
            @JsonKey(name: 'created_at') String? createdAt,
            @JsonKey(name: 'updated_at') String? updatedAt,
            String? url,
            @JsonKey(name: 'author_details') TMDBAuthorDetails? authorDetails)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TMDBReview():
        return $default(_that.id, _that.author, _that.content, _that.createdAt,
            _that.updatedAt, _that.url, _that.authorDetails);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String id,
            String author,
            String content,
            @JsonKey(name: 'created_at') String? createdAt,
            @JsonKey(name: 'updated_at') String? updatedAt,
            String? url,
            @JsonKey(name: 'author_details') TMDBAuthorDetails? authorDetails)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TMDBReview() when $default != null:
        return $default(_that.id, _that.author, _that.content, _that.createdAt,
            _that.updatedAt, _that.url, _that.authorDetails);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _TMDBReview implements TMDBReview {
  const _TMDBReview(
      {required this.id,
      required this.author,
      required this.content,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt,
      this.url,
      @JsonKey(name: 'author_details') this.authorDetails});
  factory _TMDBReview.fromJson(Map<String, dynamic> json) =>
      _$TMDBReviewFromJson(json);

  @override
  final String id;
  @override
  final String author;
  @override
  final String content;
  @override
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final String? updatedAt;
  @override
  final String? url;
  @override
  @JsonKey(name: 'author_details')
  final TMDBAuthorDetails? authorDetails;

  /// Create a copy of TMDBReview
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TMDBReviewCopyWith<_TMDBReview> get copyWith =>
      __$TMDBReviewCopyWithImpl<_TMDBReview>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TMDBReviewToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TMDBReview &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.author, author) || other.author == author) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.authorDetails, authorDetails) ||
                other.authorDetails == authorDetails));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, author, content, createdAt,
      updatedAt, url, authorDetails);

  @override
  String toString() {
    return 'TMDBReview(id: $id, author: $author, content: $content, createdAt: $createdAt, updatedAt: $updatedAt, url: $url, authorDetails: $authorDetails)';
  }
}

/// @nodoc
abstract mixin class _$TMDBReviewCopyWith<$Res>
    implements $TMDBReviewCopyWith<$Res> {
  factory _$TMDBReviewCopyWith(
          _TMDBReview value, $Res Function(_TMDBReview) _then) =
      __$TMDBReviewCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String author,
      String content,
      @JsonKey(name: 'created_at') String? createdAt,
      @JsonKey(name: 'updated_at') String? updatedAt,
      String? url,
      @JsonKey(name: 'author_details') TMDBAuthorDetails? authorDetails});

  @override
  $TMDBAuthorDetailsCopyWith<$Res>? get authorDetails;
}

/// @nodoc
class __$TMDBReviewCopyWithImpl<$Res> implements _$TMDBReviewCopyWith<$Res> {
  __$TMDBReviewCopyWithImpl(this._self, this._then);

  final _TMDBReview _self;
  final $Res Function(_TMDBReview) _then;

  /// Create a copy of TMDBReview
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? author = null,
    Object? content = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? url = freezed,
    Object? authorDetails = freezed,
  }) {
    return _then(_TMDBReview(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      author: null == author
          ? _self.author
          : author // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      url: freezed == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      authorDetails: freezed == authorDetails
          ? _self.authorDetails
          : authorDetails // ignore: cast_nullable_to_non_nullable
              as TMDBAuthorDetails?,
    ));
  }

  /// Create a copy of TMDBReview
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TMDBAuthorDetailsCopyWith<$Res>? get authorDetails {
    if (_self.authorDetails == null) {
      return null;
    }

    return $TMDBAuthorDetailsCopyWith<$Res>(_self.authorDetails!, (value) {
      return _then(_self.copyWith(authorDetails: value));
    });
  }
}

/// @nodoc
mixin _$TMDBAuthorDetails {
  String? get name;
  String? get username;
  @JsonKey(name: 'avatar_path')
  String? get avatarPath;
  double? get rating;

  /// Create a copy of TMDBAuthorDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TMDBAuthorDetailsCopyWith<TMDBAuthorDetails> get copyWith =>
      _$TMDBAuthorDetailsCopyWithImpl<TMDBAuthorDetails>(
          this as TMDBAuthorDetails, _$identity);

  /// Serializes this TMDBAuthorDetails to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TMDBAuthorDetails &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.avatarPath, avatarPath) ||
                other.avatarPath == avatarPath) &&
            (identical(other.rating, rating) || other.rating == rating));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, name, username, avatarPath, rating);

  @override
  String toString() {
    return 'TMDBAuthorDetails(name: $name, username: $username, avatarPath: $avatarPath, rating: $rating)';
  }
}

/// @nodoc
abstract mixin class $TMDBAuthorDetailsCopyWith<$Res> {
  factory $TMDBAuthorDetailsCopyWith(
          TMDBAuthorDetails value, $Res Function(TMDBAuthorDetails) _then) =
      _$TMDBAuthorDetailsCopyWithImpl;
  @useResult
  $Res call(
      {String? name,
      String? username,
      @JsonKey(name: 'avatar_path') String? avatarPath,
      double? rating});
}

/// @nodoc
class _$TMDBAuthorDetailsCopyWithImpl<$Res>
    implements $TMDBAuthorDetailsCopyWith<$Res> {
  _$TMDBAuthorDetailsCopyWithImpl(this._self, this._then);

  final TMDBAuthorDetails _self;
  final $Res Function(TMDBAuthorDetails) _then;

  /// Create a copy of TMDBAuthorDetails
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? username = freezed,
    Object? avatarPath = freezed,
    Object? rating = freezed,
  }) {
    return _then(_self.copyWith(
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      username: freezed == username
          ? _self.username
          : username // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarPath: freezed == avatarPath
          ? _self.avatarPath
          : avatarPath // ignore: cast_nullable_to_non_nullable
              as String?,
      rating: freezed == rating
          ? _self.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// Adds pattern-matching-related methods to [TMDBAuthorDetails].
extension TMDBAuthorDetailsPatterns on TMDBAuthorDetails {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_TMDBAuthorDetails value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TMDBAuthorDetails() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_TMDBAuthorDetails value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TMDBAuthorDetails():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_TMDBAuthorDetails value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TMDBAuthorDetails() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String? name, String? username,
            @JsonKey(name: 'avatar_path') String? avatarPath, double? rating)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TMDBAuthorDetails() when $default != null:
        return $default(
            _that.name, _that.username, _that.avatarPath, _that.rating);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String? name, String? username,
            @JsonKey(name: 'avatar_path') String? avatarPath, double? rating)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TMDBAuthorDetails():
        return $default(
            _that.name, _that.username, _that.avatarPath, _that.rating);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String? name, String? username,
            @JsonKey(name: 'avatar_path') String? avatarPath, double? rating)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TMDBAuthorDetails() when $default != null:
        return $default(
            _that.name, _that.username, _that.avatarPath, _that.rating);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _TMDBAuthorDetails implements TMDBAuthorDetails {
  const _TMDBAuthorDetails(
      {this.name,
      this.username,
      @JsonKey(name: 'avatar_path') this.avatarPath,
      this.rating});
  factory _TMDBAuthorDetails.fromJson(Map<String, dynamic> json) =>
      _$TMDBAuthorDetailsFromJson(json);

  @override
  final String? name;
  @override
  final String? username;
  @override
  @JsonKey(name: 'avatar_path')
  final String? avatarPath;
  @override
  final double? rating;

  /// Create a copy of TMDBAuthorDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TMDBAuthorDetailsCopyWith<_TMDBAuthorDetails> get copyWith =>
      __$TMDBAuthorDetailsCopyWithImpl<_TMDBAuthorDetails>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TMDBAuthorDetailsToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TMDBAuthorDetails &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.avatarPath, avatarPath) ||
                other.avatarPath == avatarPath) &&
            (identical(other.rating, rating) || other.rating == rating));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, name, username, avatarPath, rating);

  @override
  String toString() {
    return 'TMDBAuthorDetails(name: $name, username: $username, avatarPath: $avatarPath, rating: $rating)';
  }
}

/// @nodoc
abstract mixin class _$TMDBAuthorDetailsCopyWith<$Res>
    implements $TMDBAuthorDetailsCopyWith<$Res> {
  factory _$TMDBAuthorDetailsCopyWith(
          _TMDBAuthorDetails value, $Res Function(_TMDBAuthorDetails) _then) =
      __$TMDBAuthorDetailsCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String? name,
      String? username,
      @JsonKey(name: 'avatar_path') String? avatarPath,
      double? rating});
}

/// @nodoc
class __$TMDBAuthorDetailsCopyWithImpl<$Res>
    implements _$TMDBAuthorDetailsCopyWith<$Res> {
  __$TMDBAuthorDetailsCopyWithImpl(this._self, this._then);

  final _TMDBAuthorDetails _self;
  final $Res Function(_TMDBAuthorDetails) _then;

  /// Create a copy of TMDBAuthorDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? name = freezed,
    Object? username = freezed,
    Object? avatarPath = freezed,
    Object? rating = freezed,
  }) {
    return _then(_TMDBAuthorDetails(
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      username: freezed == username
          ? _self.username
          : username // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarPath: freezed == avatarPath
          ? _self.avatarPath
          : avatarPath // ignore: cast_nullable_to_non_nullable
              as String?,
      rating: freezed == rating
          ? _self.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
mixin _$TMDBReviewsResponse {
  List<TMDBReview> get results;
  int? get page;
  @JsonKey(name: 'total_pages')
  int? get totalPages;
  @JsonKey(name: 'total_results')
  int? get totalResults;

  /// Create a copy of TMDBReviewsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TMDBReviewsResponseCopyWith<TMDBReviewsResponse> get copyWith =>
      _$TMDBReviewsResponseCopyWithImpl<TMDBReviewsResponse>(
          this as TMDBReviewsResponse, _$identity);

  /// Serializes this TMDBReviewsResponse to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TMDBReviewsResponse &&
            const DeepCollectionEquality().equals(other.results, results) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.totalPages, totalPages) ||
                other.totalPages == totalPages) &&
            (identical(other.totalResults, totalResults) ||
                other.totalResults == totalResults));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(results),
      page,
      totalPages,
      totalResults);

  @override
  String toString() {
    return 'TMDBReviewsResponse(results: $results, page: $page, totalPages: $totalPages, totalResults: $totalResults)';
  }
}

/// @nodoc
abstract mixin class $TMDBReviewsResponseCopyWith<$Res> {
  factory $TMDBReviewsResponseCopyWith(
          TMDBReviewsResponse value, $Res Function(TMDBReviewsResponse) _then) =
      _$TMDBReviewsResponseCopyWithImpl;
  @useResult
  $Res call(
      {List<TMDBReview> results,
      int? page,
      @JsonKey(name: 'total_pages') int? totalPages,
      @JsonKey(name: 'total_results') int? totalResults});
}

/// @nodoc
class _$TMDBReviewsResponseCopyWithImpl<$Res>
    implements $TMDBReviewsResponseCopyWith<$Res> {
  _$TMDBReviewsResponseCopyWithImpl(this._self, this._then);

  final TMDBReviewsResponse _self;
  final $Res Function(TMDBReviewsResponse) _then;

  /// Create a copy of TMDBReviewsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? results = null,
    Object? page = freezed,
    Object? totalPages = freezed,
    Object? totalResults = freezed,
  }) {
    return _then(_self.copyWith(
      results: null == results
          ? _self.results
          : results // ignore: cast_nullable_to_non_nullable
              as List<TMDBReview>,
      page: freezed == page
          ? _self.page
          : page // ignore: cast_nullable_to_non_nullable
              as int?,
      totalPages: freezed == totalPages
          ? _self.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int?,
      totalResults: freezed == totalResults
          ? _self.totalResults
          : totalResults // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// Adds pattern-matching-related methods to [TMDBReviewsResponse].
extension TMDBReviewsResponsePatterns on TMDBReviewsResponse {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_TMDBReviewsResponse value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TMDBReviewsResponse() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_TMDBReviewsResponse value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TMDBReviewsResponse():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_TMDBReviewsResponse value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TMDBReviewsResponse() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            List<TMDBReview> results,
            int? page,
            @JsonKey(name: 'total_pages') int? totalPages,
            @JsonKey(name: 'total_results') int? totalResults)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TMDBReviewsResponse() when $default != null:
        return $default(
            _that.results, _that.page, _that.totalPages, _that.totalResults);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            List<TMDBReview> results,
            int? page,
            @JsonKey(name: 'total_pages') int? totalPages,
            @JsonKey(name: 'total_results') int? totalResults)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TMDBReviewsResponse():
        return $default(
            _that.results, _that.page, _that.totalPages, _that.totalResults);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            List<TMDBReview> results,
            int? page,
            @JsonKey(name: 'total_pages') int? totalPages,
            @JsonKey(name: 'total_results') int? totalResults)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TMDBReviewsResponse() when $default != null:
        return $default(
            _that.results, _that.page, _that.totalPages, _that.totalResults);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _TMDBReviewsResponse implements TMDBReviewsResponse {
  const _TMDBReviewsResponse(
      {required final List<TMDBReview> results,
      this.page,
      @JsonKey(name: 'total_pages') this.totalPages,
      @JsonKey(name: 'total_results') this.totalResults})
      : _results = results;
  factory _TMDBReviewsResponse.fromJson(Map<String, dynamic> json) =>
      _$TMDBReviewsResponseFromJson(json);

  final List<TMDBReview> _results;
  @override
  List<TMDBReview> get results {
    if (_results is EqualUnmodifiableListView) return _results;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_results);
  }

  @override
  final int? page;
  @override
  @JsonKey(name: 'total_pages')
  final int? totalPages;
  @override
  @JsonKey(name: 'total_results')
  final int? totalResults;

  /// Create a copy of TMDBReviewsResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TMDBReviewsResponseCopyWith<_TMDBReviewsResponse> get copyWith =>
      __$TMDBReviewsResponseCopyWithImpl<_TMDBReviewsResponse>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TMDBReviewsResponseToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TMDBReviewsResponse &&
            const DeepCollectionEquality().equals(other._results, _results) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.totalPages, totalPages) ||
                other.totalPages == totalPages) &&
            (identical(other.totalResults, totalResults) ||
                other.totalResults == totalResults));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_results),
      page,
      totalPages,
      totalResults);

  @override
  String toString() {
    return 'TMDBReviewsResponse(results: $results, page: $page, totalPages: $totalPages, totalResults: $totalResults)';
  }
}

/// @nodoc
abstract mixin class _$TMDBReviewsResponseCopyWith<$Res>
    implements $TMDBReviewsResponseCopyWith<$Res> {
  factory _$TMDBReviewsResponseCopyWith(_TMDBReviewsResponse value,
          $Res Function(_TMDBReviewsResponse) _then) =
      __$TMDBReviewsResponseCopyWithImpl;
  @override
  @useResult
  $Res call(
      {List<TMDBReview> results,
      int? page,
      @JsonKey(name: 'total_pages') int? totalPages,
      @JsonKey(name: 'total_results') int? totalResults});
}

/// @nodoc
class __$TMDBReviewsResponseCopyWithImpl<$Res>
    implements _$TMDBReviewsResponseCopyWith<$Res> {
  __$TMDBReviewsResponseCopyWithImpl(this._self, this._then);

  final _TMDBReviewsResponse _self;
  final $Res Function(_TMDBReviewsResponse) _then;

  /// Create a copy of TMDBReviewsResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? results = null,
    Object? page = freezed,
    Object? totalPages = freezed,
    Object? totalResults = freezed,
  }) {
    return _then(_TMDBReviewsResponse(
      results: null == results
          ? _self._results
          : results // ignore: cast_nullable_to_non_nullable
              as List<TMDBReview>,
      page: freezed == page
          ? _self.page
          : page // ignore: cast_nullable_to_non_nullable
              as int?,
      totalPages: freezed == totalPages
          ? _self.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int?,
      totalResults: freezed == totalResults
          ? _self.totalResults
          : totalResults // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
mixin _$TMDBMetadataResponse {
  TMDBMetadata? get main;
  TMDBCredits? get credits;
  TMDBReviewsResponse? get reviews;

  /// Create a copy of TMDBMetadataResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TMDBMetadataResponseCopyWith<TMDBMetadataResponse> get copyWith =>
      _$TMDBMetadataResponseCopyWithImpl<TMDBMetadataResponse>(
          this as TMDBMetadataResponse, _$identity);

  /// Serializes this TMDBMetadataResponse to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TMDBMetadataResponse &&
            (identical(other.main, main) || other.main == main) &&
            (identical(other.credits, credits) || other.credits == credits) &&
            (identical(other.reviews, reviews) || other.reviews == reviews));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, main, credits, reviews);

  @override
  String toString() {
    return 'TMDBMetadataResponse(main: $main, credits: $credits, reviews: $reviews)';
  }
}

/// @nodoc
abstract mixin class $TMDBMetadataResponseCopyWith<$Res> {
  factory $TMDBMetadataResponseCopyWith(TMDBMetadataResponse value,
          $Res Function(TMDBMetadataResponse) _then) =
      _$TMDBMetadataResponseCopyWithImpl;
  @useResult
  $Res call(
      {TMDBMetadata? main, TMDBCredits? credits, TMDBReviewsResponse? reviews});

  $TMDBMetadataCopyWith<$Res>? get main;
  $TMDBCreditsCopyWith<$Res>? get credits;
  $TMDBReviewsResponseCopyWith<$Res>? get reviews;
}

/// @nodoc
class _$TMDBMetadataResponseCopyWithImpl<$Res>
    implements $TMDBMetadataResponseCopyWith<$Res> {
  _$TMDBMetadataResponseCopyWithImpl(this._self, this._then);

  final TMDBMetadataResponse _self;
  final $Res Function(TMDBMetadataResponse) _then;

  /// Create a copy of TMDBMetadataResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? main = freezed,
    Object? credits = freezed,
    Object? reviews = freezed,
  }) {
    return _then(_self.copyWith(
      main: freezed == main
          ? _self.main
          : main // ignore: cast_nullable_to_non_nullable
              as TMDBMetadata?,
      credits: freezed == credits
          ? _self.credits
          : credits // ignore: cast_nullable_to_non_nullable
              as TMDBCredits?,
      reviews: freezed == reviews
          ? _self.reviews
          : reviews // ignore: cast_nullable_to_non_nullable
              as TMDBReviewsResponse?,
    ));
  }

  /// Create a copy of TMDBMetadataResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TMDBMetadataCopyWith<$Res>? get main {
    if (_self.main == null) {
      return null;
    }

    return $TMDBMetadataCopyWith<$Res>(_self.main!, (value) {
      return _then(_self.copyWith(main: value));
    });
  }

  /// Create a copy of TMDBMetadataResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TMDBCreditsCopyWith<$Res>? get credits {
    if (_self.credits == null) {
      return null;
    }

    return $TMDBCreditsCopyWith<$Res>(_self.credits!, (value) {
      return _then(_self.copyWith(credits: value));
    });
  }

  /// Create a copy of TMDBMetadataResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TMDBReviewsResponseCopyWith<$Res>? get reviews {
    if (_self.reviews == null) {
      return null;
    }

    return $TMDBReviewsResponseCopyWith<$Res>(_self.reviews!, (value) {
      return _then(_self.copyWith(reviews: value));
    });
  }
}

/// Adds pattern-matching-related methods to [TMDBMetadataResponse].
extension TMDBMetadataResponsePatterns on TMDBMetadataResponse {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_TMDBMetadataResponse value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TMDBMetadataResponse() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_TMDBMetadataResponse value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TMDBMetadataResponse():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_TMDBMetadataResponse value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TMDBMetadataResponse() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(TMDBMetadata? main, TMDBCredits? credits,
            TMDBReviewsResponse? reviews)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TMDBMetadataResponse() when $default != null:
        return $default(_that.main, _that.credits, _that.reviews);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(TMDBMetadata? main, TMDBCredits? credits,
            TMDBReviewsResponse? reviews)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TMDBMetadataResponse():
        return $default(_that.main, _that.credits, _that.reviews);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(TMDBMetadata? main, TMDBCredits? credits,
            TMDBReviewsResponse? reviews)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TMDBMetadataResponse() when $default != null:
        return $default(_that.main, _that.credits, _that.reviews);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _TMDBMetadataResponse implements TMDBMetadataResponse {
  const _TMDBMetadataResponse({this.main, this.credits, this.reviews});
  factory _TMDBMetadataResponse.fromJson(Map<String, dynamic> json) =>
      _$TMDBMetadataResponseFromJson(json);

  @override
  final TMDBMetadata? main;
  @override
  final TMDBCredits? credits;
  @override
  final TMDBReviewsResponse? reviews;

  /// Create a copy of TMDBMetadataResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TMDBMetadataResponseCopyWith<_TMDBMetadataResponse> get copyWith =>
      __$TMDBMetadataResponseCopyWithImpl<_TMDBMetadataResponse>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TMDBMetadataResponseToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TMDBMetadataResponse &&
            (identical(other.main, main) || other.main == main) &&
            (identical(other.credits, credits) || other.credits == credits) &&
            (identical(other.reviews, reviews) || other.reviews == reviews));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, main, credits, reviews);

  @override
  String toString() {
    return 'TMDBMetadataResponse(main: $main, credits: $credits, reviews: $reviews)';
  }
}

/// @nodoc
abstract mixin class _$TMDBMetadataResponseCopyWith<$Res>
    implements $TMDBMetadataResponseCopyWith<$Res> {
  factory _$TMDBMetadataResponseCopyWith(_TMDBMetadataResponse value,
          $Res Function(_TMDBMetadataResponse) _then) =
      __$TMDBMetadataResponseCopyWithImpl;
  @override
  @useResult
  $Res call(
      {TMDBMetadata? main, TMDBCredits? credits, TMDBReviewsResponse? reviews});

  @override
  $TMDBMetadataCopyWith<$Res>? get main;
  @override
  $TMDBCreditsCopyWith<$Res>? get credits;
  @override
  $TMDBReviewsResponseCopyWith<$Res>? get reviews;
}

/// @nodoc
class __$TMDBMetadataResponseCopyWithImpl<$Res>
    implements _$TMDBMetadataResponseCopyWith<$Res> {
  __$TMDBMetadataResponseCopyWithImpl(this._self, this._then);

  final _TMDBMetadataResponse _self;
  final $Res Function(_TMDBMetadataResponse) _then;

  /// Create a copy of TMDBMetadataResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? main = freezed,
    Object? credits = freezed,
    Object? reviews = freezed,
  }) {
    return _then(_TMDBMetadataResponse(
      main: freezed == main
          ? _self.main
          : main // ignore: cast_nullable_to_non_nullable
              as TMDBMetadata?,
      credits: freezed == credits
          ? _self.credits
          : credits // ignore: cast_nullable_to_non_nullable
              as TMDBCredits?,
      reviews: freezed == reviews
          ? _self.reviews
          : reviews // ignore: cast_nullable_to_non_nullable
              as TMDBReviewsResponse?,
    ));
  }

  /// Create a copy of TMDBMetadataResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TMDBMetadataCopyWith<$Res>? get main {
    if (_self.main == null) {
      return null;
    }

    return $TMDBMetadataCopyWith<$Res>(_self.main!, (value) {
      return _then(_self.copyWith(main: value));
    });
  }

  /// Create a copy of TMDBMetadataResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TMDBCreditsCopyWith<$Res>? get credits {
    if (_self.credits == null) {
      return null;
    }

    return $TMDBCreditsCopyWith<$Res>(_self.credits!, (value) {
      return _then(_self.copyWith(credits: value));
    });
  }

  /// Create a copy of TMDBMetadataResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TMDBReviewsResponseCopyWith<$Res>? get reviews {
    if (_self.reviews == null) {
      return null;
    }

    return $TMDBReviewsResponseCopyWith<$Res>(_self.reviews!, (value) {
      return _then(_self.copyWith(reviews: value));
    });
  }
}

// dart format on
