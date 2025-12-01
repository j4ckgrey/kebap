// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'application_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ApplicationInfo {
  String get name;
  String get version;
  String get buildNumber;
  String get os;

  /// Create a copy of ApplicationInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ApplicationInfoCopyWith<ApplicationInfo> get copyWith =>
      _$ApplicationInfoCopyWithImpl<ApplicationInfo>(
          this as ApplicationInfo, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ApplicationInfo &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.buildNumber, buildNumber) ||
                other.buildNumber == buildNumber) &&
            (identical(other.os, os) || other.os == os));
  }

  @override
  int get hashCode => Object.hash(runtimeType, name, version, buildNumber, os);
}

/// @nodoc
abstract mixin class $ApplicationInfoCopyWith<$Res> {
  factory $ApplicationInfoCopyWith(
          ApplicationInfo value, $Res Function(ApplicationInfo) _then) =
      _$ApplicationInfoCopyWithImpl;
  @useResult
  $Res call({String name, String version, String buildNumber, String os});
}

/// @nodoc
class _$ApplicationInfoCopyWithImpl<$Res>
    implements $ApplicationInfoCopyWith<$Res> {
  _$ApplicationInfoCopyWithImpl(this._self, this._then);

  final ApplicationInfo _self;
  final $Res Function(ApplicationInfo) _then;

  /// Create a copy of ApplicationInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? version = null,
    Object? buildNumber = null,
    Object? os = null,
  }) {
    return _then(_self.copyWith(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      version: null == version
          ? _self.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      buildNumber: null == buildNumber
          ? _self.buildNumber
          : buildNumber // ignore: cast_nullable_to_non_nullable
              as String,
      os: null == os
          ? _self.os
          : os // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [ApplicationInfo].
extension ApplicationInfoPatterns on ApplicationInfo {
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
    TResult Function(_ApplicationInfo value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ApplicationInfo() when $default != null:
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
    TResult Function(_ApplicationInfo value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ApplicationInfo():
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
    TResult? Function(_ApplicationInfo value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ApplicationInfo() when $default != null:
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
            String name, String version, String buildNumber, String os)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ApplicationInfo() when $default != null:
        return $default(_that.name, _that.version, _that.buildNumber, _that.os);
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
    TResult Function(String name, String version, String buildNumber, String os)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ApplicationInfo():
        return $default(_that.name, _that.version, _that.buildNumber, _that.os);
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
            String name, String version, String buildNumber, String os)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ApplicationInfo() when $default != null:
        return $default(_that.name, _that.version, _that.buildNumber, _that.os);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _ApplicationInfo extends ApplicationInfo {
  _ApplicationInfo(
      {required this.name,
      required this.version,
      required this.buildNumber,
      required this.os})
      : super._();

  @override
  final String name;
  @override
  final String version;
  @override
  final String buildNumber;
  @override
  final String os;

  /// Create a copy of ApplicationInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ApplicationInfoCopyWith<_ApplicationInfo> get copyWith =>
      __$ApplicationInfoCopyWithImpl<_ApplicationInfo>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ApplicationInfo &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.buildNumber, buildNumber) ||
                other.buildNumber == buildNumber) &&
            (identical(other.os, os) || other.os == os));
  }

  @override
  int get hashCode => Object.hash(runtimeType, name, version, buildNumber, os);
}

/// @nodoc
abstract mixin class _$ApplicationInfoCopyWith<$Res>
    implements $ApplicationInfoCopyWith<$Res> {
  factory _$ApplicationInfoCopyWith(
          _ApplicationInfo value, $Res Function(_ApplicationInfo) _then) =
      __$ApplicationInfoCopyWithImpl;
  @override
  @useResult
  $Res call({String name, String version, String buildNumber, String os});
}

/// @nodoc
class __$ApplicationInfoCopyWithImpl<$Res>
    implements _$ApplicationInfoCopyWith<$Res> {
  __$ApplicationInfoCopyWithImpl(this._self, this._then);

  final _ApplicationInfo _self;
  final $Res Function(_ApplicationInfo) _then;

  /// Create a copy of ApplicationInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? name = null,
    Object? version = null,
    Object? buildNumber = null,
    Object? os = null,
  }) {
    return _then(_ApplicationInfo(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      version: null == version
          ? _self.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      buildNumber: null == buildNumber
          ? _self.buildNumber
          : buildNumber // ignore: cast_nullable_to_non_nullable
              as String,
      os: null == os
          ? _self.os
          : os // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
