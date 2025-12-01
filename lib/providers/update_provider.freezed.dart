// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpdatesModel implements DiagnosticableTreeMixin {
  List<ReleaseInfo> get lastRelease;

  /// Create a copy of UpdatesModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UpdatesModelCopyWith<UpdatesModel> get copyWith =>
      _$UpdatesModelCopyWithImpl<UpdatesModel>(
          this as UpdatesModel, _$identity);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'UpdatesModel'))
      ..add(DiagnosticsProperty('lastRelease', lastRelease));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UpdatesModel &&
            const DeepCollectionEquality()
                .equals(other.lastRelease, lastRelease));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(lastRelease));

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'UpdatesModel(lastRelease: $lastRelease)';
  }
}

/// @nodoc
abstract mixin class $UpdatesModelCopyWith<$Res> {
  factory $UpdatesModelCopyWith(
          UpdatesModel value, $Res Function(UpdatesModel) _then) =
      _$UpdatesModelCopyWithImpl;
  @useResult
  $Res call({List<ReleaseInfo> lastRelease});
}

/// @nodoc
class _$UpdatesModelCopyWithImpl<$Res> implements $UpdatesModelCopyWith<$Res> {
  _$UpdatesModelCopyWithImpl(this._self, this._then);

  final UpdatesModel _self;
  final $Res Function(UpdatesModel) _then;

  /// Create a copy of UpdatesModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lastRelease = null,
  }) {
    return _then(_self.copyWith(
      lastRelease: null == lastRelease
          ? _self.lastRelease
          : lastRelease // ignore: cast_nullable_to_non_nullable
              as List<ReleaseInfo>,
    ));
  }
}

/// Adds pattern-matching-related methods to [UpdatesModel].
extension UpdatesModelPatterns on UpdatesModel {
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
    TResult Function(_UpdatesModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UpdatesModel() when $default != null:
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
    TResult Function(_UpdatesModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UpdatesModel():
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
    TResult? Function(_UpdatesModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UpdatesModel() when $default != null:
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
    TResult Function(List<ReleaseInfo> lastRelease)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UpdatesModel() when $default != null:
        return $default(_that.lastRelease);
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
    TResult Function(List<ReleaseInfo> lastRelease) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UpdatesModel():
        return $default(_that.lastRelease);
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
    TResult? Function(List<ReleaseInfo> lastRelease)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UpdatesModel() when $default != null:
        return $default(_that.lastRelease);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _UpdatesModel extends UpdatesModel with DiagnosticableTreeMixin {
  _UpdatesModel({final List<ReleaseInfo> lastRelease = const []})
      : _lastRelease = lastRelease,
        super._();

  final List<ReleaseInfo> _lastRelease;
  @override
  @JsonKey()
  List<ReleaseInfo> get lastRelease {
    if (_lastRelease is EqualUnmodifiableListView) return _lastRelease;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_lastRelease);
  }

  /// Create a copy of UpdatesModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$UpdatesModelCopyWith<_UpdatesModel> get copyWith =>
      __$UpdatesModelCopyWithImpl<_UpdatesModel>(this, _$identity);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'UpdatesModel'))
      ..add(DiagnosticsProperty('lastRelease', lastRelease));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UpdatesModel &&
            const DeepCollectionEquality()
                .equals(other._lastRelease, _lastRelease));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_lastRelease));

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'UpdatesModel(lastRelease: $lastRelease)';
  }
}

/// @nodoc
abstract mixin class _$UpdatesModelCopyWith<$Res>
    implements $UpdatesModelCopyWith<$Res> {
  factory _$UpdatesModelCopyWith(
          _UpdatesModel value, $Res Function(_UpdatesModel) _then) =
      __$UpdatesModelCopyWithImpl;
  @override
  @useResult
  $Res call({List<ReleaseInfo> lastRelease});
}

/// @nodoc
class __$UpdatesModelCopyWithImpl<$Res>
    implements _$UpdatesModelCopyWith<$Res> {
  __$UpdatesModelCopyWithImpl(this._self, this._then);

  final _UpdatesModel _self;
  final $Res Function(_UpdatesModel) _then;

  /// Create a copy of UpdatesModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? lastRelease = null,
  }) {
    return _then(_UpdatesModel(
      lastRelease: null == lastRelease
          ? _self._lastRelease
          : lastRelease // ignore: cast_nullable_to_non_nullable
              as List<ReleaseInfo>,
    ));
  }
}

// dart format on
