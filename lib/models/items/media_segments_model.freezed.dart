// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'media_segments_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MediaSegmentsModel {
  List<MediaSegment> get segments;

  /// Create a copy of MediaSegmentsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MediaSegmentsModelCopyWith<MediaSegmentsModel> get copyWith =>
      _$MediaSegmentsModelCopyWithImpl<MediaSegmentsModel>(
          this as MediaSegmentsModel, _$identity);

  /// Serializes this MediaSegmentsModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MediaSegmentsModel &&
            const DeepCollectionEquality().equals(other.segments, segments));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(segments));

  @override
  String toString() {
    return 'MediaSegmentsModel(segments: $segments)';
  }
}

/// @nodoc
abstract mixin class $MediaSegmentsModelCopyWith<$Res> {
  factory $MediaSegmentsModelCopyWith(
          MediaSegmentsModel value, $Res Function(MediaSegmentsModel) _then) =
      _$MediaSegmentsModelCopyWithImpl;
  @useResult
  $Res call({List<MediaSegment> segments});
}

/// @nodoc
class _$MediaSegmentsModelCopyWithImpl<$Res>
    implements $MediaSegmentsModelCopyWith<$Res> {
  _$MediaSegmentsModelCopyWithImpl(this._self, this._then);

  final MediaSegmentsModel _self;
  final $Res Function(MediaSegmentsModel) _then;

  /// Create a copy of MediaSegmentsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? segments = null,
  }) {
    return _then(_self.copyWith(
      segments: null == segments
          ? _self.segments
          : segments // ignore: cast_nullable_to_non_nullable
              as List<MediaSegment>,
    ));
  }
}

/// Adds pattern-matching-related methods to [MediaSegmentsModel].
extension MediaSegmentsModelPatterns on MediaSegmentsModel {
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
    TResult Function(_MediaSegmentsModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MediaSegmentsModel() when $default != null:
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
    TResult Function(_MediaSegmentsModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MediaSegmentsModel():
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
    TResult? Function(_MediaSegmentsModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MediaSegmentsModel() when $default != null:
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
    TResult Function(List<MediaSegment> segments)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MediaSegmentsModel() when $default != null:
        return $default(_that.segments);
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
    TResult Function(List<MediaSegment> segments) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MediaSegmentsModel():
        return $default(_that.segments);
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
    TResult? Function(List<MediaSegment> segments)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MediaSegmentsModel() when $default != null:
        return $default(_that.segments);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _MediaSegmentsModel extends MediaSegmentsModel {
  _MediaSegmentsModel({final List<MediaSegment> segments = const []})
      : _segments = segments,
        super._();
  factory _MediaSegmentsModel.fromJson(Map<String, dynamic> json) =>
      _$MediaSegmentsModelFromJson(json);

  final List<MediaSegment> _segments;
  @override
  @JsonKey()
  List<MediaSegment> get segments {
    if (_segments is EqualUnmodifiableListView) return _segments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_segments);
  }

  /// Create a copy of MediaSegmentsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MediaSegmentsModelCopyWith<_MediaSegmentsModel> get copyWith =>
      __$MediaSegmentsModelCopyWithImpl<_MediaSegmentsModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MediaSegmentsModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MediaSegmentsModel &&
            const DeepCollectionEquality().equals(other._segments, _segments));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_segments));

  @override
  String toString() {
    return 'MediaSegmentsModel(segments: $segments)';
  }
}

/// @nodoc
abstract mixin class _$MediaSegmentsModelCopyWith<$Res>
    implements $MediaSegmentsModelCopyWith<$Res> {
  factory _$MediaSegmentsModelCopyWith(
          _MediaSegmentsModel value, $Res Function(_MediaSegmentsModel) _then) =
      __$MediaSegmentsModelCopyWithImpl;
  @override
  @useResult
  $Res call({List<MediaSegment> segments});
}

/// @nodoc
class __$MediaSegmentsModelCopyWithImpl<$Res>
    implements _$MediaSegmentsModelCopyWith<$Res> {
  __$MediaSegmentsModelCopyWithImpl(this._self, this._then);

  final _MediaSegmentsModel _self;
  final $Res Function(_MediaSegmentsModel) _then;

  /// Create a copy of MediaSegmentsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? segments = null,
  }) {
    return _then(_MediaSegmentsModel(
      segments: null == segments
          ? _self._segments
          : segments // ignore: cast_nullable_to_non_nullable
              as List<MediaSegment>,
    ));
  }
}

/// @nodoc
mixin _$MediaSegment {
  MediaSegmentType get type;
  Duration get start;
  Duration get end;

  /// Create a copy of MediaSegment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MediaSegmentCopyWith<MediaSegment> get copyWith =>
      _$MediaSegmentCopyWithImpl<MediaSegment>(
          this as MediaSegment, _$identity);

  /// Serializes this MediaSegment to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MediaSegment &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.start, start) || other.start == start) &&
            (identical(other.end, end) || other.end == end));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, type, start, end);

  @override
  String toString() {
    return 'MediaSegment(type: $type, start: $start, end: $end)';
  }
}

/// @nodoc
abstract mixin class $MediaSegmentCopyWith<$Res> {
  factory $MediaSegmentCopyWith(
          MediaSegment value, $Res Function(MediaSegment) _then) =
      _$MediaSegmentCopyWithImpl;
  @useResult
  $Res call({MediaSegmentType type, Duration start, Duration end});
}

/// @nodoc
class _$MediaSegmentCopyWithImpl<$Res> implements $MediaSegmentCopyWith<$Res> {
  _$MediaSegmentCopyWithImpl(this._self, this._then);

  final MediaSegment _self;
  final $Res Function(MediaSegment) _then;

  /// Create a copy of MediaSegment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? start = null,
    Object? end = null,
  }) {
    return _then(_self.copyWith(
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as MediaSegmentType,
      start: null == start
          ? _self.start
          : start // ignore: cast_nullable_to_non_nullable
              as Duration,
      end: null == end
          ? _self.end
          : end // ignore: cast_nullable_to_non_nullable
              as Duration,
    ));
  }
}

/// Adds pattern-matching-related methods to [MediaSegment].
extension MediaSegmentPatterns on MediaSegment {
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
    TResult Function(_MediaSegment value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MediaSegment() when $default != null:
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
    TResult Function(_MediaSegment value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MediaSegment():
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
    TResult? Function(_MediaSegment value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MediaSegment() when $default != null:
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
    TResult Function(MediaSegmentType type, Duration start, Duration end)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MediaSegment() when $default != null:
        return $default(_that.type, _that.start, _that.end);
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
    TResult Function(MediaSegmentType type, Duration start, Duration end)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MediaSegment():
        return $default(_that.type, _that.start, _that.end);
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
    TResult? Function(MediaSegmentType type, Duration start, Duration end)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MediaSegment() when $default != null:
        return $default(_that.type, _that.start, _that.end);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _MediaSegment extends MediaSegment {
  _MediaSegment({required this.type, required this.start, required this.end})
      : super._();
  factory _MediaSegment.fromJson(Map<String, dynamic> json) =>
      _$MediaSegmentFromJson(json);

  @override
  final MediaSegmentType type;
  @override
  final Duration start;
  @override
  final Duration end;

  /// Create a copy of MediaSegment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MediaSegmentCopyWith<_MediaSegment> get copyWith =>
      __$MediaSegmentCopyWithImpl<_MediaSegment>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MediaSegmentToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MediaSegment &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.start, start) || other.start == start) &&
            (identical(other.end, end) || other.end == end));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, type, start, end);

  @override
  String toString() {
    return 'MediaSegment(type: $type, start: $start, end: $end)';
  }
}

/// @nodoc
abstract mixin class _$MediaSegmentCopyWith<$Res>
    implements $MediaSegmentCopyWith<$Res> {
  factory _$MediaSegmentCopyWith(
          _MediaSegment value, $Res Function(_MediaSegment) _then) =
      __$MediaSegmentCopyWithImpl;
  @override
  @useResult
  $Res call({MediaSegmentType type, Duration start, Duration end});
}

/// @nodoc
class __$MediaSegmentCopyWithImpl<$Res>
    implements _$MediaSegmentCopyWith<$Res> {
  __$MediaSegmentCopyWithImpl(this._self, this._then);

  final _MediaSegment _self;
  final $Res Function(_MediaSegment) _then;

  /// Create a copy of MediaSegment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? type = null,
    Object? start = null,
    Object? end = null,
  }) {
    return _then(_MediaSegment(
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as MediaSegmentType,
      start: null == start
          ? _self.start
          : start // ignore: cast_nullable_to_non_nullable
              as Duration,
      end: null == end
          ? _self.end
          : end // ignore: cast_nullable_to_non_nullable
              as Duration,
    ));
  }
}

// dart format on
