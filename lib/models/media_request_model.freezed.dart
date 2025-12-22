// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'media_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MediaRequest {
  @JsonKey(name: 'id')
  String get id;
  @JsonKey(name: 'username')
  String? get username;
  @JsonKey(name: 'userId')
  String? get userId;
  @JsonKey(name: 'timestamp')
  int get timestamp;
  @JsonKey(name: 'title')
  String get title;
  @JsonKey(name: 'year')
  String? get year;
  @JsonKey(name: 'img')
  @ImageUrlConverter()
  String? get img;
  @JsonKey(name: 'imdbId')
  String? get imdbId;
  @JsonKey(name: 'tmdbId')
  String? get tmdbId;
  @JsonKey(name: 'jellyfinId')
  String? get jellyfinId;
  @JsonKey(name: 'itemType')
  String? get itemType;
  @JsonKey(name: 'tmdbMediaType')
  String? get tmdbMediaType;
  @JsonKey(name: 'status')
  String get status;
  @JsonKey(name: 'approvedBy')
  String? get approvedBy;

  /// Create a copy of MediaRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MediaRequestCopyWith<MediaRequest> get copyWith =>
      _$MediaRequestCopyWithImpl<MediaRequest>(
          this as MediaRequest, _$identity);

  /// Serializes this MediaRequest to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MediaRequest &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.year, year) || other.year == year) &&
            (identical(other.img, img) || other.img == img) &&
            (identical(other.imdbId, imdbId) || other.imdbId == imdbId) &&
            (identical(other.tmdbId, tmdbId) || other.tmdbId == tmdbId) &&
            (identical(other.jellyfinId, jellyfinId) ||
                other.jellyfinId == jellyfinId) &&
            (identical(other.itemType, itemType) ||
                other.itemType == itemType) &&
            (identical(other.tmdbMediaType, tmdbMediaType) ||
                other.tmdbMediaType == tmdbMediaType) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.approvedBy, approvedBy) ||
                other.approvedBy == approvedBy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      username,
      userId,
      timestamp,
      title,
      year,
      img,
      imdbId,
      tmdbId,
      jellyfinId,
      itemType,
      tmdbMediaType,
      status,
      approvedBy);

  @override
  String toString() {
    return 'MediaRequest(id: $id, username: $username, userId: $userId, timestamp: $timestamp, title: $title, year: $year, img: $img, imdbId: $imdbId, tmdbId: $tmdbId, jellyfinId: $jellyfinId, itemType: $itemType, tmdbMediaType: $tmdbMediaType, status: $status, approvedBy: $approvedBy)';
  }
}

/// @nodoc
abstract mixin class $MediaRequestCopyWith<$Res> {
  factory $MediaRequestCopyWith(
          MediaRequest value, $Res Function(MediaRequest) _then) =
      _$MediaRequestCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'username') String? username,
      @JsonKey(name: 'userId') String? userId,
      @JsonKey(name: 'timestamp') int timestamp,
      @JsonKey(name: 'title') String title,
      @JsonKey(name: 'year') String? year,
      @JsonKey(name: 'img') @ImageUrlConverter() String? img,
      @JsonKey(name: 'imdbId') String? imdbId,
      @JsonKey(name: 'tmdbId') String? tmdbId,
      @JsonKey(name: 'jellyfinId') String? jellyfinId,
      @JsonKey(name: 'itemType') String? itemType,
      @JsonKey(name: 'tmdbMediaType') String? tmdbMediaType,
      @JsonKey(name: 'status') String status,
      @JsonKey(name: 'approvedBy') String? approvedBy});
}

/// @nodoc
class _$MediaRequestCopyWithImpl<$Res> implements $MediaRequestCopyWith<$Res> {
  _$MediaRequestCopyWithImpl(this._self, this._then);

  final MediaRequest _self;
  final $Res Function(MediaRequest) _then;

  /// Create a copy of MediaRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? username = freezed,
    Object? userId = freezed,
    Object? timestamp = null,
    Object? title = null,
    Object? year = freezed,
    Object? img = freezed,
    Object? imdbId = freezed,
    Object? tmdbId = freezed,
    Object? jellyfinId = freezed,
    Object? itemType = freezed,
    Object? tmdbMediaType = freezed,
    Object? status = null,
    Object? approvedBy = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      username: freezed == username
          ? _self.username
          : username // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: freezed == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      timestamp: null == timestamp
          ? _self.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      year: freezed == year
          ? _self.year
          : year // ignore: cast_nullable_to_non_nullable
              as String?,
      img: freezed == img
          ? _self.img
          : img // ignore: cast_nullable_to_non_nullable
              as String?,
      imdbId: freezed == imdbId
          ? _self.imdbId
          : imdbId // ignore: cast_nullable_to_non_nullable
              as String?,
      tmdbId: freezed == tmdbId
          ? _self.tmdbId
          : tmdbId // ignore: cast_nullable_to_non_nullable
              as String?,
      jellyfinId: freezed == jellyfinId
          ? _self.jellyfinId
          : jellyfinId // ignore: cast_nullable_to_non_nullable
              as String?,
      itemType: freezed == itemType
          ? _self.itemType
          : itemType // ignore: cast_nullable_to_non_nullable
              as String?,
      tmdbMediaType: freezed == tmdbMediaType
          ? _self.tmdbMediaType
          : tmdbMediaType // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      approvedBy: freezed == approvedBy
          ? _self.approvedBy
          : approvedBy // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [MediaRequest].
extension MediaRequestPatterns on MediaRequest {
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
    TResult Function(_MediaRequest value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MediaRequest() when $default != null:
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
    TResult Function(_MediaRequest value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MediaRequest():
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
    TResult? Function(_MediaRequest value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MediaRequest() when $default != null:
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
            @JsonKey(name: 'id') String id,
            @JsonKey(name: 'username') String? username,
            @JsonKey(name: 'userId') String? userId,
            @JsonKey(name: 'timestamp') int timestamp,
            @JsonKey(name: 'title') String title,
            @JsonKey(name: 'year') String? year,
            @JsonKey(name: 'img') @ImageUrlConverter() String? img,
            @JsonKey(name: 'imdbId') String? imdbId,
            @JsonKey(name: 'tmdbId') String? tmdbId,
            @JsonKey(name: 'jellyfinId') String? jellyfinId,
            @JsonKey(name: 'itemType') String? itemType,
            @JsonKey(name: 'tmdbMediaType') String? tmdbMediaType,
            @JsonKey(name: 'status') String status,
            @JsonKey(name: 'approvedBy') String? approvedBy)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MediaRequest() when $default != null:
        return $default(
            _that.id,
            _that.username,
            _that.userId,
            _that.timestamp,
            _that.title,
            _that.year,
            _that.img,
            _that.imdbId,
            _that.tmdbId,
            _that.jellyfinId,
            _that.itemType,
            _that.tmdbMediaType,
            _that.status,
            _that.approvedBy);
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
            @JsonKey(name: 'id') String id,
            @JsonKey(name: 'username') String? username,
            @JsonKey(name: 'userId') String? userId,
            @JsonKey(name: 'timestamp') int timestamp,
            @JsonKey(name: 'title') String title,
            @JsonKey(name: 'year') String? year,
            @JsonKey(name: 'img') @ImageUrlConverter() String? img,
            @JsonKey(name: 'imdbId') String? imdbId,
            @JsonKey(name: 'tmdbId') String? tmdbId,
            @JsonKey(name: 'jellyfinId') String? jellyfinId,
            @JsonKey(name: 'itemType') String? itemType,
            @JsonKey(name: 'tmdbMediaType') String? tmdbMediaType,
            @JsonKey(name: 'status') String status,
            @JsonKey(name: 'approvedBy') String? approvedBy)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MediaRequest():
        return $default(
            _that.id,
            _that.username,
            _that.userId,
            _that.timestamp,
            _that.title,
            _that.year,
            _that.img,
            _that.imdbId,
            _that.tmdbId,
            _that.jellyfinId,
            _that.itemType,
            _that.tmdbMediaType,
            _that.status,
            _that.approvedBy);
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
            @JsonKey(name: 'id') String id,
            @JsonKey(name: 'username') String? username,
            @JsonKey(name: 'userId') String? userId,
            @JsonKey(name: 'timestamp') int timestamp,
            @JsonKey(name: 'title') String title,
            @JsonKey(name: 'year') String? year,
            @JsonKey(name: 'img') @ImageUrlConverter() String? img,
            @JsonKey(name: 'imdbId') String? imdbId,
            @JsonKey(name: 'tmdbId') String? tmdbId,
            @JsonKey(name: 'jellyfinId') String? jellyfinId,
            @JsonKey(name: 'itemType') String? itemType,
            @JsonKey(name: 'tmdbMediaType') String? tmdbMediaType,
            @JsonKey(name: 'status') String status,
            @JsonKey(name: 'approvedBy') String? approvedBy)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MediaRequest() when $default != null:
        return $default(
            _that.id,
            _that.username,
            _that.userId,
            _that.timestamp,
            _that.title,
            _that.year,
            _that.img,
            _that.imdbId,
            _that.tmdbId,
            _that.jellyfinId,
            _that.itemType,
            _that.tmdbMediaType,
            _that.status,
            _that.approvedBy);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _MediaRequest implements MediaRequest {
  const _MediaRequest(
      {@JsonKey(name: 'id') required this.id,
      @JsonKey(name: 'username') this.username,
      @JsonKey(name: 'userId') this.userId,
      @JsonKey(name: 'timestamp') this.timestamp = 0,
      @JsonKey(name: 'title') required this.title,
      @JsonKey(name: 'year') this.year,
      @JsonKey(name: 'img') @ImageUrlConverter() this.img,
      @JsonKey(name: 'imdbId') this.imdbId,
      @JsonKey(name: 'tmdbId') this.tmdbId,
      @JsonKey(name: 'jellyfinId') this.jellyfinId,
      @JsonKey(name: 'itemType') this.itemType,
      @JsonKey(name: 'tmdbMediaType') this.tmdbMediaType,
      @JsonKey(name: 'status') this.status = 'pending',
      @JsonKey(name: 'approvedBy') this.approvedBy});
  factory _MediaRequest.fromJson(Map<String, dynamic> json) =>
      _$MediaRequestFromJson(json);

  @override
  @JsonKey(name: 'id')
  final String id;
  @override
  @JsonKey(name: 'username')
  final String? username;
  @override
  @JsonKey(name: 'userId')
  final String? userId;
  @override
  @JsonKey(name: 'timestamp')
  final int timestamp;
  @override
  @JsonKey(name: 'title')
  final String title;
  @override
  @JsonKey(name: 'year')
  final String? year;
  @override
  @JsonKey(name: 'img')
  @ImageUrlConverter()
  final String? img;
  @override
  @JsonKey(name: 'imdbId')
  final String? imdbId;
  @override
  @JsonKey(name: 'tmdbId')
  final String? tmdbId;
  @override
  @JsonKey(name: 'jellyfinId')
  final String? jellyfinId;
  @override
  @JsonKey(name: 'itemType')
  final String? itemType;
  @override
  @JsonKey(name: 'tmdbMediaType')
  final String? tmdbMediaType;
  @override
  @JsonKey(name: 'status')
  final String status;
  @override
  @JsonKey(name: 'approvedBy')
  final String? approvedBy;

  /// Create a copy of MediaRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MediaRequestCopyWith<_MediaRequest> get copyWith =>
      __$MediaRequestCopyWithImpl<_MediaRequest>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MediaRequestToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MediaRequest &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.year, year) || other.year == year) &&
            (identical(other.img, img) || other.img == img) &&
            (identical(other.imdbId, imdbId) || other.imdbId == imdbId) &&
            (identical(other.tmdbId, tmdbId) || other.tmdbId == tmdbId) &&
            (identical(other.jellyfinId, jellyfinId) ||
                other.jellyfinId == jellyfinId) &&
            (identical(other.itemType, itemType) ||
                other.itemType == itemType) &&
            (identical(other.tmdbMediaType, tmdbMediaType) ||
                other.tmdbMediaType == tmdbMediaType) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.approvedBy, approvedBy) ||
                other.approvedBy == approvedBy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      username,
      userId,
      timestamp,
      title,
      year,
      img,
      imdbId,
      tmdbId,
      jellyfinId,
      itemType,
      tmdbMediaType,
      status,
      approvedBy);

  @override
  String toString() {
    return 'MediaRequest(id: $id, username: $username, userId: $userId, timestamp: $timestamp, title: $title, year: $year, img: $img, imdbId: $imdbId, tmdbId: $tmdbId, jellyfinId: $jellyfinId, itemType: $itemType, tmdbMediaType: $tmdbMediaType, status: $status, approvedBy: $approvedBy)';
  }
}

/// @nodoc
abstract mixin class _$MediaRequestCopyWith<$Res>
    implements $MediaRequestCopyWith<$Res> {
  factory _$MediaRequestCopyWith(
          _MediaRequest value, $Res Function(_MediaRequest) _then) =
      __$MediaRequestCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'username') String? username,
      @JsonKey(name: 'userId') String? userId,
      @JsonKey(name: 'timestamp') int timestamp,
      @JsonKey(name: 'title') String title,
      @JsonKey(name: 'year') String? year,
      @JsonKey(name: 'img') @ImageUrlConverter() String? img,
      @JsonKey(name: 'imdbId') String? imdbId,
      @JsonKey(name: 'tmdbId') String? tmdbId,
      @JsonKey(name: 'jellyfinId') String? jellyfinId,
      @JsonKey(name: 'itemType') String? itemType,
      @JsonKey(name: 'tmdbMediaType') String? tmdbMediaType,
      @JsonKey(name: 'status') String status,
      @JsonKey(name: 'approvedBy') String? approvedBy});
}

/// @nodoc
class __$MediaRequestCopyWithImpl<$Res>
    implements _$MediaRequestCopyWith<$Res> {
  __$MediaRequestCopyWithImpl(this._self, this._then);

  final _MediaRequest _self;
  final $Res Function(_MediaRequest) _then;

  /// Create a copy of MediaRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? username = freezed,
    Object? userId = freezed,
    Object? timestamp = null,
    Object? title = null,
    Object? year = freezed,
    Object? img = freezed,
    Object? imdbId = freezed,
    Object? tmdbId = freezed,
    Object? jellyfinId = freezed,
    Object? itemType = freezed,
    Object? tmdbMediaType = freezed,
    Object? status = null,
    Object? approvedBy = freezed,
  }) {
    return _then(_MediaRequest(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      username: freezed == username
          ? _self.username
          : username // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: freezed == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      timestamp: null == timestamp
          ? _self.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      year: freezed == year
          ? _self.year
          : year // ignore: cast_nullable_to_non_nullable
              as String?,
      img: freezed == img
          ? _self.img
          : img // ignore: cast_nullable_to_non_nullable
              as String?,
      imdbId: freezed == imdbId
          ? _self.imdbId
          : imdbId // ignore: cast_nullable_to_non_nullable
              as String?,
      tmdbId: freezed == tmdbId
          ? _self.tmdbId
          : tmdbId // ignore: cast_nullable_to_non_nullable
              as String?,
      jellyfinId: freezed == jellyfinId
          ? _self.jellyfinId
          : jellyfinId // ignore: cast_nullable_to_non_nullable
              as String?,
      itemType: freezed == itemType
          ? _self.itemType
          : itemType // ignore: cast_nullable_to_non_nullable
              as String?,
      tmdbMediaType: freezed == tmdbMediaType
          ? _self.tmdbMediaType
          : tmdbMediaType // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      approvedBy: freezed == approvedBy
          ? _self.approvedBy
          : approvedBy // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$RequestsState {
  List<MediaRequest> get requests;
  bool get loading;
  String? get error;

  /// Create a copy of RequestsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RequestsStateCopyWith<RequestsState> get copyWith =>
      _$RequestsStateCopyWithImpl<RequestsState>(
          this as RequestsState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RequestsState &&
            const DeepCollectionEquality().equals(other.requests, requests) &&
            (identical(other.loading, loading) || other.loading == loading) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(requests), loading, error);

  @override
  String toString() {
    return 'RequestsState(requests: $requests, loading: $loading, error: $error)';
  }
}

/// @nodoc
abstract mixin class $RequestsStateCopyWith<$Res> {
  factory $RequestsStateCopyWith(
          RequestsState value, $Res Function(RequestsState) _then) =
      _$RequestsStateCopyWithImpl;
  @useResult
  $Res call({List<MediaRequest> requests, bool loading, String? error});
}

/// @nodoc
class _$RequestsStateCopyWithImpl<$Res>
    implements $RequestsStateCopyWith<$Res> {
  _$RequestsStateCopyWithImpl(this._self, this._then);

  final RequestsState _self;
  final $Res Function(RequestsState) _then;

  /// Create a copy of RequestsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? requests = null,
    Object? loading = null,
    Object? error = freezed,
  }) {
    return _then(_self.copyWith(
      requests: null == requests
          ? _self.requests
          : requests // ignore: cast_nullable_to_non_nullable
              as List<MediaRequest>,
      loading: null == loading
          ? _self.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [RequestsState].
extension RequestsStatePatterns on RequestsState {
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
    TResult Function(_RequestsState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RequestsState() when $default != null:
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
    TResult Function(_RequestsState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RequestsState():
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
    TResult? Function(_RequestsState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RequestsState() when $default != null:
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
    TResult Function(List<MediaRequest> requests, bool loading, String? error)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RequestsState() when $default != null:
        return $default(_that.requests, _that.loading, _that.error);
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
    TResult Function(List<MediaRequest> requests, bool loading, String? error)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RequestsState():
        return $default(_that.requests, _that.loading, _that.error);
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
    TResult? Function(List<MediaRequest> requests, bool loading, String? error)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RequestsState() when $default != null:
        return $default(_that.requests, _that.loading, _that.error);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _RequestsState extends RequestsState {
  const _RequestsState(
      {final List<MediaRequest> requests = const [],
      this.loading = false,
      this.error})
      : _requests = requests,
        super._();

  final List<MediaRequest> _requests;
  @override
  @JsonKey()
  List<MediaRequest> get requests {
    if (_requests is EqualUnmodifiableListView) return _requests;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_requests);
  }

  @override
  @JsonKey()
  final bool loading;
  @override
  final String? error;

  /// Create a copy of RequestsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RequestsStateCopyWith<_RequestsState> get copyWith =>
      __$RequestsStateCopyWithImpl<_RequestsState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RequestsState &&
            const DeepCollectionEquality().equals(other._requests, _requests) &&
            (identical(other.loading, loading) || other.loading == loading) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_requests), loading, error);

  @override
  String toString() {
    return 'RequestsState(requests: $requests, loading: $loading, error: $error)';
  }
}

/// @nodoc
abstract mixin class _$RequestsStateCopyWith<$Res>
    implements $RequestsStateCopyWith<$Res> {
  factory _$RequestsStateCopyWith(
          _RequestsState value, $Res Function(_RequestsState) _then) =
      __$RequestsStateCopyWithImpl;
  @override
  @useResult
  $Res call({List<MediaRequest> requests, bool loading, String? error});
}

/// @nodoc
class __$RequestsStateCopyWithImpl<$Res>
    implements _$RequestsStateCopyWith<$Res> {
  __$RequestsStateCopyWithImpl(this._self, this._then);

  final _RequestsState _self;
  final $Res Function(_RequestsState) _then;

  /// Create a copy of RequestsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? requests = null,
    Object? loading = null,
    Object? error = freezed,
  }) {
    return _then(_RequestsState(
      requests: null == requests
          ? _self._requests
          : requests // ignore: cast_nullable_to_non_nullable
              as List<MediaRequest>,
      loading: null == loading
          ? _self.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
