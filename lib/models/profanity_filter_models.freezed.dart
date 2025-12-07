// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profanity_filter_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MuteRange {
  /// Start time in milliseconds
  int get startMs;

  /// End time in milliseconds
  int get endMs;

  /// The detected word (optional)
  String? get word;

  /// Create a copy of MuteRange
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MuteRangeCopyWith<MuteRange> get copyWith =>
      _$MuteRangeCopyWithImpl<MuteRange>(this as MuteRange, _$identity);

  /// Serializes this MuteRange to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MuteRange &&
            (identical(other.startMs, startMs) || other.startMs == startMs) &&
            (identical(other.endMs, endMs) || other.endMs == endMs) &&
            (identical(other.word, word) || other.word == word));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, startMs, endMs, word);

  @override
  String toString() {
    return 'MuteRange(startMs: $startMs, endMs: $endMs, word: $word)';
  }
}

/// @nodoc
abstract mixin class $MuteRangeCopyWith<$Res> {
  factory $MuteRangeCopyWith(MuteRange value, $Res Function(MuteRange) _then) =
      _$MuteRangeCopyWithImpl;
  @useResult
  $Res call({int startMs, int endMs, String? word});
}

/// @nodoc
class _$MuteRangeCopyWithImpl<$Res> implements $MuteRangeCopyWith<$Res> {
  _$MuteRangeCopyWithImpl(this._self, this._then);

  final MuteRange _self;
  final $Res Function(MuteRange) _then;

  /// Create a copy of MuteRange
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startMs = null,
    Object? endMs = null,
    Object? word = freezed,
  }) {
    return _then(_self.copyWith(
      startMs: null == startMs
          ? _self.startMs
          : startMs // ignore: cast_nullable_to_non_nullable
              as int,
      endMs: null == endMs
          ? _self.endMs
          : endMs // ignore: cast_nullable_to_non_nullable
              as int,
      word: freezed == word
          ? _self.word
          : word // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [MuteRange].
extension MuteRangePatterns on MuteRange {
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
    TResult Function(_MuteRange value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MuteRange() when $default != null:
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
    TResult Function(_MuteRange value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MuteRange():
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
    TResult? Function(_MuteRange value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MuteRange() when $default != null:
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
    TResult Function(int startMs, int endMs, String? word)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MuteRange() when $default != null:
        return $default(_that.startMs, _that.endMs, _that.word);
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
    TResult Function(int startMs, int endMs, String? word) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MuteRange():
        return $default(_that.startMs, _that.endMs, _that.word);
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
    TResult? Function(int startMs, int endMs, String? word)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MuteRange() when $default != null:
        return $default(_that.startMs, _that.endMs, _that.word);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _MuteRange extends MuteRange {
  _MuteRange({required this.startMs, required this.endMs, this.word})
      : super._();
  factory _MuteRange.fromJson(Map<String, dynamic> json) =>
      _$MuteRangeFromJson(json);

  /// Start time in milliseconds
  @override
  final int startMs;

  /// End time in milliseconds
  @override
  final int endMs;

  /// The detected word (optional)
  @override
  final String? word;

  /// Create a copy of MuteRange
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MuteRangeCopyWith<_MuteRange> get copyWith =>
      __$MuteRangeCopyWithImpl<_MuteRange>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MuteRangeToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MuteRange &&
            (identical(other.startMs, startMs) || other.startMs == startMs) &&
            (identical(other.endMs, endMs) || other.endMs == endMs) &&
            (identical(other.word, word) || other.word == word));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, startMs, endMs, word);

  @override
  String toString() {
    return 'MuteRange(startMs: $startMs, endMs: $endMs, word: $word)';
  }
}

/// @nodoc
abstract mixin class _$MuteRangeCopyWith<$Res>
    implements $MuteRangeCopyWith<$Res> {
  factory _$MuteRangeCopyWith(
          _MuteRange value, $Res Function(_MuteRange) _then) =
      __$MuteRangeCopyWithImpl;
  @override
  @useResult
  $Res call({int startMs, int endMs, String? word});
}

/// @nodoc
class __$MuteRangeCopyWithImpl<$Res> implements _$MuteRangeCopyWith<$Res> {
  __$MuteRangeCopyWithImpl(this._self, this._then);

  final _MuteRange _self;
  final $Res Function(_MuteRange) _then;

  /// Create a copy of MuteRange
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? startMs = null,
    Object? endMs = null,
    Object? word = freezed,
  }) {
    return _then(_MuteRange(
      startMs: null == startMs
          ? _self.startMs
          : startMs // ignore: cast_nullable_to_non_nullable
              as int,
      endMs: null == endMs
          ? _self.endMs
          : endMs // ignore: cast_nullable_to_non_nullable
              as int,
      word: freezed == word
          ? _self.word
          : word // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$ProfanityMetadata {
  String get itemId;
  List<MuteRange> get muteRanges;
  DateTime? get scannedAt;

  /// Create a copy of ProfanityMetadata
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ProfanityMetadataCopyWith<ProfanityMetadata> get copyWith =>
      _$ProfanityMetadataCopyWithImpl<ProfanityMetadata>(
          this as ProfanityMetadata, _$identity);

  /// Serializes this ProfanityMetadata to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ProfanityMetadata &&
            (identical(other.itemId, itemId) || other.itemId == itemId) &&
            const DeepCollectionEquality()
                .equals(other.muteRanges, muteRanges) &&
            (identical(other.scannedAt, scannedAt) ||
                other.scannedAt == scannedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, itemId,
      const DeepCollectionEquality().hash(muteRanges), scannedAt);

  @override
  String toString() {
    return 'ProfanityMetadata(itemId: $itemId, muteRanges: $muteRanges, scannedAt: $scannedAt)';
  }
}

/// @nodoc
abstract mixin class $ProfanityMetadataCopyWith<$Res> {
  factory $ProfanityMetadataCopyWith(
          ProfanityMetadata value, $Res Function(ProfanityMetadata) _then) =
      _$ProfanityMetadataCopyWithImpl;
  @useResult
  $Res call({String itemId, List<MuteRange> muteRanges, DateTime? scannedAt});
}

/// @nodoc
class _$ProfanityMetadataCopyWithImpl<$Res>
    implements $ProfanityMetadataCopyWith<$Res> {
  _$ProfanityMetadataCopyWithImpl(this._self, this._then);

  final ProfanityMetadata _self;
  final $Res Function(ProfanityMetadata) _then;

  /// Create a copy of ProfanityMetadata
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? itemId = null,
    Object? muteRanges = null,
    Object? scannedAt = freezed,
  }) {
    return _then(_self.copyWith(
      itemId: null == itemId
          ? _self.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as String,
      muteRanges: null == muteRanges
          ? _self.muteRanges
          : muteRanges // ignore: cast_nullable_to_non_nullable
              as List<MuteRange>,
      scannedAt: freezed == scannedAt
          ? _self.scannedAt
          : scannedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// Adds pattern-matching-related methods to [ProfanityMetadata].
extension ProfanityMetadataPatterns on ProfanityMetadata {
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
    TResult Function(_ProfanityMetadata value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ProfanityMetadata() when $default != null:
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
    TResult Function(_ProfanityMetadata value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProfanityMetadata():
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
    TResult? Function(_ProfanityMetadata value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProfanityMetadata() when $default != null:
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
            String itemId, List<MuteRange> muteRanges, DateTime? scannedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ProfanityMetadata() when $default != null:
        return $default(_that.itemId, _that.muteRanges, _that.scannedAt);
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
            String itemId, List<MuteRange> muteRanges, DateTime? scannedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProfanityMetadata():
        return $default(_that.itemId, _that.muteRanges, _that.scannedAt);
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
            String itemId, List<MuteRange> muteRanges, DateTime? scannedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProfanityMetadata() when $default != null:
        return $default(_that.itemId, _that.muteRanges, _that.scannedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ProfanityMetadata extends ProfanityMetadata {
  _ProfanityMetadata(
      {required this.itemId,
      required final List<MuteRange> muteRanges,
      this.scannedAt})
      : _muteRanges = muteRanges,
        super._();
  factory _ProfanityMetadata.fromJson(Map<String, dynamic> json) =>
      _$ProfanityMetadataFromJson(json);

  @override
  final String itemId;
  final List<MuteRange> _muteRanges;
  @override
  List<MuteRange> get muteRanges {
    if (_muteRanges is EqualUnmodifiableListView) return _muteRanges;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_muteRanges);
  }

  @override
  final DateTime? scannedAt;

  /// Create a copy of ProfanityMetadata
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ProfanityMetadataCopyWith<_ProfanityMetadata> get copyWith =>
      __$ProfanityMetadataCopyWithImpl<_ProfanityMetadata>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ProfanityMetadataToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ProfanityMetadata &&
            (identical(other.itemId, itemId) || other.itemId == itemId) &&
            const DeepCollectionEquality()
                .equals(other._muteRanges, _muteRanges) &&
            (identical(other.scannedAt, scannedAt) ||
                other.scannedAt == scannedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, itemId,
      const DeepCollectionEquality().hash(_muteRanges), scannedAt);

  @override
  String toString() {
    return 'ProfanityMetadata(itemId: $itemId, muteRanges: $muteRanges, scannedAt: $scannedAt)';
  }
}

/// @nodoc
abstract mixin class _$ProfanityMetadataCopyWith<$Res>
    implements $ProfanityMetadataCopyWith<$Res> {
  factory _$ProfanityMetadataCopyWith(
          _ProfanityMetadata value, $Res Function(_ProfanityMetadata) _then) =
      __$ProfanityMetadataCopyWithImpl;
  @override
  @useResult
  $Res call({String itemId, List<MuteRange> muteRanges, DateTime? scannedAt});
}

/// @nodoc
class __$ProfanityMetadataCopyWithImpl<$Res>
    implements _$ProfanityMetadataCopyWith<$Res> {
  __$ProfanityMetadataCopyWithImpl(this._self, this._then);

  final _ProfanityMetadata _self;
  final $Res Function(_ProfanityMetadata) _then;

  /// Create a copy of ProfanityMetadata
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? itemId = null,
    Object? muteRanges = null,
    Object? scannedAt = freezed,
  }) {
    return _then(_ProfanityMetadata(
      itemId: null == itemId
          ? _self.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as String,
      muteRanges: null == muteRanges
          ? _self._muteRanges
          : muteRanges // ignore: cast_nullable_to_non_nullable
              as List<MuteRange>,
      scannedAt: freezed == scannedAt
          ? _self.scannedAt
          : scannedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
mixin _$ProfanityUserPreferences {
  bool get enabled;
  bool get muteEntireSentence;

  /// Create a copy of ProfanityUserPreferences
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ProfanityUserPreferencesCopyWith<ProfanityUserPreferences> get copyWith =>
      _$ProfanityUserPreferencesCopyWithImpl<ProfanityUserPreferences>(
          this as ProfanityUserPreferences, _$identity);

  /// Serializes this ProfanityUserPreferences to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ProfanityUserPreferences &&
            (identical(other.enabled, enabled) || other.enabled == enabled) &&
            (identical(other.muteEntireSentence, muteEntireSentence) ||
                other.muteEntireSentence == muteEntireSentence));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, enabled, muteEntireSentence);

  @override
  String toString() {
    return 'ProfanityUserPreferences(enabled: $enabled, muteEntireSentence: $muteEntireSentence)';
  }
}

/// @nodoc
abstract mixin class $ProfanityUserPreferencesCopyWith<$Res> {
  factory $ProfanityUserPreferencesCopyWith(ProfanityUserPreferences value,
          $Res Function(ProfanityUserPreferences) _then) =
      _$ProfanityUserPreferencesCopyWithImpl;
  @useResult
  $Res call({bool enabled, bool muteEntireSentence});
}

/// @nodoc
class _$ProfanityUserPreferencesCopyWithImpl<$Res>
    implements $ProfanityUserPreferencesCopyWith<$Res> {
  _$ProfanityUserPreferencesCopyWithImpl(this._self, this._then);

  final ProfanityUserPreferences _self;
  final $Res Function(ProfanityUserPreferences) _then;

  /// Create a copy of ProfanityUserPreferences
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enabled = null,
    Object? muteEntireSentence = null,
  }) {
    return _then(_self.copyWith(
      enabled: null == enabled
          ? _self.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      muteEntireSentence: null == muteEntireSentence
          ? _self.muteEntireSentence
          : muteEntireSentence // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [ProfanityUserPreferences].
extension ProfanityUserPreferencesPatterns on ProfanityUserPreferences {
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
    TResult Function(_ProfanityUserPreferences value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ProfanityUserPreferences() when $default != null:
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
    TResult Function(_ProfanityUserPreferences value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProfanityUserPreferences():
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
    TResult? Function(_ProfanityUserPreferences value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProfanityUserPreferences() when $default != null:
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
    TResult Function(bool enabled, bool muteEntireSentence)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ProfanityUserPreferences() when $default != null:
        return $default(_that.enabled, _that.muteEntireSentence);
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
    TResult Function(bool enabled, bool muteEntireSentence) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProfanityUserPreferences():
        return $default(_that.enabled, _that.muteEntireSentence);
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
    TResult? Function(bool enabled, bool muteEntireSentence)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProfanityUserPreferences() when $default != null:
        return $default(_that.enabled, _that.muteEntireSentence);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ProfanityUserPreferences extends ProfanityUserPreferences {
  _ProfanityUserPreferences(
      {this.enabled = false, this.muteEntireSentence = false})
      : super._();
  factory _ProfanityUserPreferences.fromJson(Map<String, dynamic> json) =>
      _$ProfanityUserPreferencesFromJson(json);

  @override
  @JsonKey()
  final bool enabled;
  @override
  @JsonKey()
  final bool muteEntireSentence;

  /// Create a copy of ProfanityUserPreferences
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ProfanityUserPreferencesCopyWith<_ProfanityUserPreferences> get copyWith =>
      __$ProfanityUserPreferencesCopyWithImpl<_ProfanityUserPreferences>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ProfanityUserPreferencesToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ProfanityUserPreferences &&
            (identical(other.enabled, enabled) || other.enabled == enabled) &&
            (identical(other.muteEntireSentence, muteEntireSentence) ||
                other.muteEntireSentence == muteEntireSentence));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, enabled, muteEntireSentence);

  @override
  String toString() {
    return 'ProfanityUserPreferences(enabled: $enabled, muteEntireSentence: $muteEntireSentence)';
  }
}

/// @nodoc
abstract mixin class _$ProfanityUserPreferencesCopyWith<$Res>
    implements $ProfanityUserPreferencesCopyWith<$Res> {
  factory _$ProfanityUserPreferencesCopyWith(_ProfanityUserPreferences value,
          $Res Function(_ProfanityUserPreferences) _then) =
      __$ProfanityUserPreferencesCopyWithImpl;
  @override
  @useResult
  $Res call({bool enabled, bool muteEntireSentence});
}

/// @nodoc
class __$ProfanityUserPreferencesCopyWithImpl<$Res>
    implements _$ProfanityUserPreferencesCopyWith<$Res> {
  __$ProfanityUserPreferencesCopyWithImpl(this._self, this._then);

  final _ProfanityUserPreferences _self;
  final $Res Function(_ProfanityUserPreferences) _then;

  /// Create a copy of ProfanityUserPreferences
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? enabled = null,
    Object? muteEntireSentence = null,
  }) {
    return _then(_ProfanityUserPreferences(
      enabled: null == enabled
          ? _self.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      muteEntireSentence: null == muteEntireSentence
          ? _self.muteEntireSentence
          : muteEntireSentence // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
mixin _$ProfanityPluginConfig {
  bool get enabledByDefault;
  String get profanityWords;
  bool get enableWordReplacement;
  bool get useGrammaticalReplacement;
  int get mutePaddingMs;
  bool get muteEntireSentence;

  /// Create a copy of ProfanityPluginConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ProfanityPluginConfigCopyWith<ProfanityPluginConfig> get copyWith =>
      _$ProfanityPluginConfigCopyWithImpl<ProfanityPluginConfig>(
          this as ProfanityPluginConfig, _$identity);

  /// Serializes this ProfanityPluginConfig to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ProfanityPluginConfig &&
            (identical(other.enabledByDefault, enabledByDefault) ||
                other.enabledByDefault == enabledByDefault) &&
            (identical(other.profanityWords, profanityWords) ||
                other.profanityWords == profanityWords) &&
            (identical(other.enableWordReplacement, enableWordReplacement) ||
                other.enableWordReplacement == enableWordReplacement) &&
            (identical(other.useGrammaticalReplacement,
                    useGrammaticalReplacement) ||
                other.useGrammaticalReplacement == useGrammaticalReplacement) &&
            (identical(other.mutePaddingMs, mutePaddingMs) ||
                other.mutePaddingMs == mutePaddingMs) &&
            (identical(other.muteEntireSentence, muteEntireSentence) ||
                other.muteEntireSentence == muteEntireSentence));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      enabledByDefault,
      profanityWords,
      enableWordReplacement,
      useGrammaticalReplacement,
      mutePaddingMs,
      muteEntireSentence);

  @override
  String toString() {
    return 'ProfanityPluginConfig(enabledByDefault: $enabledByDefault, profanityWords: $profanityWords, enableWordReplacement: $enableWordReplacement, useGrammaticalReplacement: $useGrammaticalReplacement, mutePaddingMs: $mutePaddingMs, muteEntireSentence: $muteEntireSentence)';
  }
}

/// @nodoc
abstract mixin class $ProfanityPluginConfigCopyWith<$Res> {
  factory $ProfanityPluginConfigCopyWith(ProfanityPluginConfig value,
          $Res Function(ProfanityPluginConfig) _then) =
      _$ProfanityPluginConfigCopyWithImpl;
  @useResult
  $Res call(
      {bool enabledByDefault,
      String profanityWords,
      bool enableWordReplacement,
      bool useGrammaticalReplacement,
      int mutePaddingMs,
      bool muteEntireSentence});
}

/// @nodoc
class _$ProfanityPluginConfigCopyWithImpl<$Res>
    implements $ProfanityPluginConfigCopyWith<$Res> {
  _$ProfanityPluginConfigCopyWithImpl(this._self, this._then);

  final ProfanityPluginConfig _self;
  final $Res Function(ProfanityPluginConfig) _then;

  /// Create a copy of ProfanityPluginConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enabledByDefault = null,
    Object? profanityWords = null,
    Object? enableWordReplacement = null,
    Object? useGrammaticalReplacement = null,
    Object? mutePaddingMs = null,
    Object? muteEntireSentence = null,
  }) {
    return _then(_self.copyWith(
      enabledByDefault: null == enabledByDefault
          ? _self.enabledByDefault
          : enabledByDefault // ignore: cast_nullable_to_non_nullable
              as bool,
      profanityWords: null == profanityWords
          ? _self.profanityWords
          : profanityWords // ignore: cast_nullable_to_non_nullable
              as String,
      enableWordReplacement: null == enableWordReplacement
          ? _self.enableWordReplacement
          : enableWordReplacement // ignore: cast_nullable_to_non_nullable
              as bool,
      useGrammaticalReplacement: null == useGrammaticalReplacement
          ? _self.useGrammaticalReplacement
          : useGrammaticalReplacement // ignore: cast_nullable_to_non_nullable
              as bool,
      mutePaddingMs: null == mutePaddingMs
          ? _self.mutePaddingMs
          : mutePaddingMs // ignore: cast_nullable_to_non_nullable
              as int,
      muteEntireSentence: null == muteEntireSentence
          ? _self.muteEntireSentence
          : muteEntireSentence // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [ProfanityPluginConfig].
extension ProfanityPluginConfigPatterns on ProfanityPluginConfig {
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
    TResult Function(_ProfanityPluginConfig value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ProfanityPluginConfig() when $default != null:
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
    TResult Function(_ProfanityPluginConfig value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProfanityPluginConfig():
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
    TResult? Function(_ProfanityPluginConfig value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProfanityPluginConfig() when $default != null:
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
            bool enabledByDefault,
            String profanityWords,
            bool enableWordReplacement,
            bool useGrammaticalReplacement,
            int mutePaddingMs,
            bool muteEntireSentence)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ProfanityPluginConfig() when $default != null:
        return $default(
            _that.enabledByDefault,
            _that.profanityWords,
            _that.enableWordReplacement,
            _that.useGrammaticalReplacement,
            _that.mutePaddingMs,
            _that.muteEntireSentence);
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
            bool enabledByDefault,
            String profanityWords,
            bool enableWordReplacement,
            bool useGrammaticalReplacement,
            int mutePaddingMs,
            bool muteEntireSentence)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProfanityPluginConfig():
        return $default(
            _that.enabledByDefault,
            _that.profanityWords,
            _that.enableWordReplacement,
            _that.useGrammaticalReplacement,
            _that.mutePaddingMs,
            _that.muteEntireSentence);
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
            bool enabledByDefault,
            String profanityWords,
            bool enableWordReplacement,
            bool useGrammaticalReplacement,
            int mutePaddingMs,
            bool muteEntireSentence)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProfanityPluginConfig() when $default != null:
        return $default(
            _that.enabledByDefault,
            _that.profanityWords,
            _that.enableWordReplacement,
            _that.useGrammaticalReplacement,
            _that.mutePaddingMs,
            _that.muteEntireSentence);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ProfanityPluginConfig extends ProfanityPluginConfig {
  _ProfanityPluginConfig(
      {this.enabledByDefault = false,
      this.profanityWords = '',
      this.enableWordReplacement = false,
      this.useGrammaticalReplacement = false,
      this.mutePaddingMs = 100,
      this.muteEntireSentence = false})
      : super._();
  factory _ProfanityPluginConfig.fromJson(Map<String, dynamic> json) =>
      _$ProfanityPluginConfigFromJson(json);

  @override
  @JsonKey()
  final bool enabledByDefault;
  @override
  @JsonKey()
  final String profanityWords;
  @override
  @JsonKey()
  final bool enableWordReplacement;
  @override
  @JsonKey()
  final bool useGrammaticalReplacement;
  @override
  @JsonKey()
  final int mutePaddingMs;
  @override
  @JsonKey()
  final bool muteEntireSentence;

  /// Create a copy of ProfanityPluginConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ProfanityPluginConfigCopyWith<_ProfanityPluginConfig> get copyWith =>
      __$ProfanityPluginConfigCopyWithImpl<_ProfanityPluginConfig>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ProfanityPluginConfigToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ProfanityPluginConfig &&
            (identical(other.enabledByDefault, enabledByDefault) ||
                other.enabledByDefault == enabledByDefault) &&
            (identical(other.profanityWords, profanityWords) ||
                other.profanityWords == profanityWords) &&
            (identical(other.enableWordReplacement, enableWordReplacement) ||
                other.enableWordReplacement == enableWordReplacement) &&
            (identical(other.useGrammaticalReplacement,
                    useGrammaticalReplacement) ||
                other.useGrammaticalReplacement == useGrammaticalReplacement) &&
            (identical(other.mutePaddingMs, mutePaddingMs) ||
                other.mutePaddingMs == mutePaddingMs) &&
            (identical(other.muteEntireSentence, muteEntireSentence) ||
                other.muteEntireSentence == muteEntireSentence));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      enabledByDefault,
      profanityWords,
      enableWordReplacement,
      useGrammaticalReplacement,
      mutePaddingMs,
      muteEntireSentence);

  @override
  String toString() {
    return 'ProfanityPluginConfig(enabledByDefault: $enabledByDefault, profanityWords: $profanityWords, enableWordReplacement: $enableWordReplacement, useGrammaticalReplacement: $useGrammaticalReplacement, mutePaddingMs: $mutePaddingMs, muteEntireSentence: $muteEntireSentence)';
  }
}

/// @nodoc
abstract mixin class _$ProfanityPluginConfigCopyWith<$Res>
    implements $ProfanityPluginConfigCopyWith<$Res> {
  factory _$ProfanityPluginConfigCopyWith(_ProfanityPluginConfig value,
          $Res Function(_ProfanityPluginConfig) _then) =
      __$ProfanityPluginConfigCopyWithImpl;
  @override
  @useResult
  $Res call(
      {bool enabledByDefault,
      String profanityWords,
      bool enableWordReplacement,
      bool useGrammaticalReplacement,
      int mutePaddingMs,
      bool muteEntireSentence});
}

/// @nodoc
class __$ProfanityPluginConfigCopyWithImpl<$Res>
    implements _$ProfanityPluginConfigCopyWith<$Res> {
  __$ProfanityPluginConfigCopyWithImpl(this._self, this._then);

  final _ProfanityPluginConfig _self;
  final $Res Function(_ProfanityPluginConfig) _then;

  /// Create a copy of ProfanityPluginConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? enabledByDefault = null,
    Object? profanityWords = null,
    Object? enableWordReplacement = null,
    Object? useGrammaticalReplacement = null,
    Object? mutePaddingMs = null,
    Object? muteEntireSentence = null,
  }) {
    return _then(_ProfanityPluginConfig(
      enabledByDefault: null == enabledByDefault
          ? _self.enabledByDefault
          : enabledByDefault // ignore: cast_nullable_to_non_nullable
              as bool,
      profanityWords: null == profanityWords
          ? _self.profanityWords
          : profanityWords // ignore: cast_nullable_to_non_nullable
              as String,
      enableWordReplacement: null == enableWordReplacement
          ? _self.enableWordReplacement
          : enableWordReplacement // ignore: cast_nullable_to_non_nullable
              as bool,
      useGrammaticalReplacement: null == useGrammaticalReplacement
          ? _self.useGrammaticalReplacement
          : useGrammaticalReplacement // ignore: cast_nullable_to_non_nullable
              as bool,
      mutePaddingMs: null == mutePaddingMs
          ? _self.mutePaddingMs
          : mutePaddingMs // ignore: cast_nullable_to_non_nullable
              as int,
      muteEntireSentence: null == muteEntireSentence
          ? _self.muteEntireSentence
          : muteEntireSentence // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
