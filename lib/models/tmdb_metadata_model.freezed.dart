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

  /// Serializes this TMDBMetadata to a JSON map.
  Map<String, dynamic> toJson();

  @override
  String toString() {
    return 'TMDBMetadata(id: $id, title: $title, name: $name, overview: $overview, posterPath: $posterPath, backdropPath: $backdropPath, voteAverage: $voteAverage, voteCount: $voteCount, releaseDate: $releaseDate, firstAirDate: $firstAirDate, runtime: $runtime, numberOfSeasons: $numberOfSeasons, numberOfEpisodes: $numberOfEpisodes, genres: $genres, genreIds: $genreIds, imdbId: $imdbId, originalLanguage: $originalLanguage, popularity: $popularity, status: $status, tagline: $tagline)';
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

  @override
  Map<String, dynamic> toJson() {
    return _$TMDBMetadataToJson(
      this,
    );
  }

  @override
  String toString() {
    return 'TMDBMetadata(id: $id, title: $title, name: $name, overview: $overview, posterPath: $posterPath, backdropPath: $backdropPath, voteAverage: $voteAverage, voteCount: $voteCount, releaseDate: $releaseDate, firstAirDate: $firstAirDate, runtime: $runtime, numberOfSeasons: $numberOfSeasons, numberOfEpisodes: $numberOfEpisodes, genres: $genres, genreIds: $genreIds, imdbId: $imdbId, originalLanguage: $originalLanguage, popularity: $popularity, status: $status, tagline: $tagline)';
  }
}

/// @nodoc
mixin _$TMDBGenre {
  int get id;
  String get name;

  /// Serializes this TMDBGenre to a JSON map.
  Map<String, dynamic> toJson();

  @override
  String toString() {
    return 'TMDBGenre(id: $id, name: $name)';
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

  @override
  Map<String, dynamic> toJson() {
    return _$TMDBGenreToJson(
      this,
    );
  }

  @override
  String toString() {
    return 'TMDBGenre(id: $id, name: $name)';
  }
}

/// @nodoc
mixin _$TMDBCredits {
  List<TMDBCastMember>? get cast;
  List<TMDBCrewMember>? get crew;

  /// Serializes this TMDBCredits to a JSON map.
  Map<String, dynamic> toJson();

  @override
  String toString() {
    return 'TMDBCredits(cast: $cast, crew: $crew)';
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

  @override
  Map<String, dynamic> toJson() {
    return _$TMDBCreditsToJson(
      this,
    );
  }

  @override
  String toString() {
    return 'TMDBCredits(cast: $cast, crew: $crew)';
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

  /// Serializes this TMDBCastMember to a JSON map.
  Map<String, dynamic> toJson();

  @override
  String toString() {
    return 'TMDBCastMember(id: $id, name: $name, character: $character, profilePath: $profilePath, order: $order)';
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

  @override
  Map<String, dynamic> toJson() {
    return _$TMDBCastMemberToJson(
      this,
    );
  }

  @override
  String toString() {
    return 'TMDBCastMember(id: $id, name: $name, character: $character, profilePath: $profilePath, order: $order)';
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

  /// Serializes this TMDBCrewMember to a JSON map.
  Map<String, dynamic> toJson();

  @override
  String toString() {
    return 'TMDBCrewMember(id: $id, name: $name, job: $job, department: $department, profilePath: $profilePath)';
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

  @override
  Map<String, dynamic> toJson() {
    return _$TMDBCrewMemberToJson(
      this,
    );
  }

  @override
  String toString() {
    return 'TMDBCrewMember(id: $id, name: $name, job: $job, department: $department, profilePath: $profilePath)';
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

  /// Serializes this TMDBExternalIds to a JSON map.
  Map<String, dynamic> toJson();

  @override
  String toString() {
    return 'TMDBExternalIds(imdbId: $imdbId, tvdbId: $tvdbId, freebaseMid: $freebaseMid, freebaseId: $freebaseId)';
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

  @override
  Map<String, dynamic> toJson() {
    return _$TMDBExternalIdsToJson(
      this,
    );
  }

  @override
  String toString() {
    return 'TMDBExternalIds(imdbId: $imdbId, tvdbId: $tvdbId, freebaseMid: $freebaseMid, freebaseId: $freebaseId)';
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

  /// Serializes this TMDBReview to a JSON map.
  Map<String, dynamic> toJson();

  @override
  String toString() {
    return 'TMDBReview(id: $id, author: $author, content: $content, createdAt: $createdAt, updatedAt: $updatedAt, url: $url, authorDetails: $authorDetails)';
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

  @override
  Map<String, dynamic> toJson() {
    return _$TMDBReviewToJson(
      this,
    );
  }

  @override
  String toString() {
    return 'TMDBReview(id: $id, author: $author, content: $content, createdAt: $createdAt, updatedAt: $updatedAt, url: $url, authorDetails: $authorDetails)';
  }
}

/// @nodoc
mixin _$TMDBAuthorDetails {
  String? get name;
  String? get username;
  @JsonKey(name: 'avatar_path')
  String? get avatarPath;
  double? get rating;

  /// Serializes this TMDBAuthorDetails to a JSON map.
  Map<String, dynamic> toJson();

  @override
  String toString() {
    return 'TMDBAuthorDetails(name: $name, username: $username, avatarPath: $avatarPath, rating: $rating)';
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

  @override
  Map<String, dynamic> toJson() {
    return _$TMDBAuthorDetailsToJson(
      this,
    );
  }

  @override
  String toString() {
    return 'TMDBAuthorDetails(name: $name, username: $username, avatarPath: $avatarPath, rating: $rating)';
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

  /// Serializes this TMDBReviewsResponse to a JSON map.
  Map<String, dynamic> toJson();

  @override
  String toString() {
    return 'TMDBReviewsResponse(results: $results, page: $page, totalPages: $totalPages, totalResults: $totalResults)';
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

  @override
  Map<String, dynamic> toJson() {
    return _$TMDBReviewsResponseToJson(
      this,
    );
  }

  @override
  String toString() {
    return 'TMDBReviewsResponse(results: $results, page: $page, totalPages: $totalPages, totalResults: $totalResults)';
  }
}

/// @nodoc
mixin _$TMDBMetadataResponse {
  TMDBMetadata? get main;
  TMDBCredits? get credits;
  TMDBReviewsResponse? get reviews;

  /// Serializes this TMDBMetadataResponse to a JSON map.
  Map<String, dynamic> toJson();

  @override
  String toString() {
    return 'TMDBMetadataResponse(main: $main, credits: $credits, reviews: $reviews)';
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

  @override
  Map<String, dynamic> toJson() {
    return _$TMDBMetadataResponseToJson(
      this,
    );
  }

  @override
  String toString() {
    return 'TMDBMetadataResponse(main: $main, credits: $credits, reviews: $reviews)';
  }
}

// dart format on
