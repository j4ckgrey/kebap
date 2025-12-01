// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'baklava_config_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BaklavaConfig {
  String get defaultTmdbId;
  bool get disableNonAdminRequests;
  bool get showReviewsCarousel;
  String? get tmdbApiKey;
  bool? get enableSearchFilter;
  bool? get forceTVClientLocalSearch;
  String? get versionUi;
  String? get audioUi;
  String? get subtitleUi;

  /// Create a copy of BaklavaConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BaklavaConfigCopyWith<BaklavaConfig> get copyWith =>
      _$BaklavaConfigCopyWithImpl<BaklavaConfig>(
          this as BaklavaConfig, _$identity);

  /// Serializes this BaklavaConfig to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BaklavaConfig &&
            (identical(other.defaultTmdbId, defaultTmdbId) ||
                other.defaultTmdbId == defaultTmdbId) &&
            (identical(
                    other.disableNonAdminRequests, disableNonAdminRequests) ||
                other.disableNonAdminRequests == disableNonAdminRequests) &&
            (identical(other.showReviewsCarousel, showReviewsCarousel) ||
                other.showReviewsCarousel == showReviewsCarousel) &&
            (identical(other.tmdbApiKey, tmdbApiKey) ||
                other.tmdbApiKey == tmdbApiKey) &&
            (identical(other.enableSearchFilter, enableSearchFilter) ||
                other.enableSearchFilter == enableSearchFilter) &&
            (identical(
                    other.forceTVClientLocalSearch, forceTVClientLocalSearch) ||
                other.forceTVClientLocalSearch == forceTVClientLocalSearch) &&
            (identical(other.versionUi, versionUi) ||
                other.versionUi == versionUi) &&
            (identical(other.audioUi, audioUi) || other.audioUi == audioUi) &&
            (identical(other.subtitleUi, subtitleUi) ||
                other.subtitleUi == subtitleUi));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      defaultTmdbId,
      disableNonAdminRequests,
      showReviewsCarousel,
      tmdbApiKey,
      enableSearchFilter,
      forceTVClientLocalSearch,
      versionUi,
      audioUi,
      subtitleUi);

  @override
  String toString() {
    return 'BaklavaConfig(defaultTmdbId: $defaultTmdbId, disableNonAdminRequests: $disableNonAdminRequests, showReviewsCarousel: $showReviewsCarousel, tmdbApiKey: $tmdbApiKey, enableSearchFilter: $enableSearchFilter, forceTVClientLocalSearch: $forceTVClientLocalSearch, versionUi: $versionUi, audioUi: $audioUi, subtitleUi: $subtitleUi)';
  }
}

/// @nodoc
abstract mixin class $BaklavaConfigCopyWith<$Res> {
  factory $BaklavaConfigCopyWith(
          BaklavaConfig value, $Res Function(BaklavaConfig) _then) =
      _$BaklavaConfigCopyWithImpl;
  @useResult
  $Res call(
      {String defaultTmdbId,
      bool disableNonAdminRequests,
      bool showReviewsCarousel,
      String? tmdbApiKey,
      bool? enableSearchFilter,
      bool? forceTVClientLocalSearch,
      String? versionUi,
      String? audioUi,
      String? subtitleUi});
}

/// @nodoc
class _$BaklavaConfigCopyWithImpl<$Res>
    implements $BaklavaConfigCopyWith<$Res> {
  _$BaklavaConfigCopyWithImpl(this._self, this._then);

  final BaklavaConfig _self;
  final $Res Function(BaklavaConfig) _then;

  /// Create a copy of BaklavaConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? defaultTmdbId = null,
    Object? disableNonAdminRequests = null,
    Object? showReviewsCarousel = null,
    Object? tmdbApiKey = freezed,
    Object? enableSearchFilter = freezed,
    Object? forceTVClientLocalSearch = freezed,
    Object? versionUi = freezed,
    Object? audioUi = freezed,
    Object? subtitleUi = freezed,
  }) {
    return _then(_self.copyWith(
      defaultTmdbId: null == defaultTmdbId
          ? _self.defaultTmdbId
          : defaultTmdbId // ignore: cast_nullable_to_non_nullable
              as String,
      disableNonAdminRequests: null == disableNonAdminRequests
          ? _self.disableNonAdminRequests
          : disableNonAdminRequests // ignore: cast_nullable_to_non_nullable
              as bool,
      showReviewsCarousel: null == showReviewsCarousel
          ? _self.showReviewsCarousel
          : showReviewsCarousel // ignore: cast_nullable_to_non_nullable
              as bool,
      tmdbApiKey: freezed == tmdbApiKey
          ? _self.tmdbApiKey
          : tmdbApiKey // ignore: cast_nullable_to_non_nullable
              as String?,
      enableSearchFilter: freezed == enableSearchFilter
          ? _self.enableSearchFilter
          : enableSearchFilter // ignore: cast_nullable_to_non_nullable
              as bool?,
      forceTVClientLocalSearch: freezed == forceTVClientLocalSearch
          ? _self.forceTVClientLocalSearch
          : forceTVClientLocalSearch // ignore: cast_nullable_to_non_nullable
              as bool?,
      versionUi: freezed == versionUi
          ? _self.versionUi
          : versionUi // ignore: cast_nullable_to_non_nullable
              as String?,
      audioUi: freezed == audioUi
          ? _self.audioUi
          : audioUi // ignore: cast_nullable_to_non_nullable
              as String?,
      subtitleUi: freezed == subtitleUi
          ? _self.subtitleUi
          : subtitleUi // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [BaklavaConfig].
extension BaklavaConfigPatterns on BaklavaConfig {
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
    TResult Function(_BaklavaConfig value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BaklavaConfig() when $default != null:
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
    TResult Function(_BaklavaConfig value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BaklavaConfig():
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
    TResult? Function(_BaklavaConfig value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BaklavaConfig() when $default != null:
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
            String defaultTmdbId,
            bool disableNonAdminRequests,
            bool showReviewsCarousel,
            String? tmdbApiKey,
            bool? enableSearchFilter,
            bool? forceTVClientLocalSearch,
            String? versionUi,
            String? audioUi,
            String? subtitleUi)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BaklavaConfig() when $default != null:
        return $default(
            _that.defaultTmdbId,
            _that.disableNonAdminRequests,
            _that.showReviewsCarousel,
            _that.tmdbApiKey,
            _that.enableSearchFilter,
            _that.forceTVClientLocalSearch,
            _that.versionUi,
            _that.audioUi,
            _that.subtitleUi);
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
            String defaultTmdbId,
            bool disableNonAdminRequests,
            bool showReviewsCarousel,
            String? tmdbApiKey,
            bool? enableSearchFilter,
            bool? forceTVClientLocalSearch,
            String? versionUi,
            String? audioUi,
            String? subtitleUi)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BaklavaConfig():
        return $default(
            _that.defaultTmdbId,
            _that.disableNonAdminRequests,
            _that.showReviewsCarousel,
            _that.tmdbApiKey,
            _that.enableSearchFilter,
            _that.forceTVClientLocalSearch,
            _that.versionUi,
            _that.audioUi,
            _that.subtitleUi);
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
            String defaultTmdbId,
            bool disableNonAdminRequests,
            bool showReviewsCarousel,
            String? tmdbApiKey,
            bool? enableSearchFilter,
            bool? forceTVClientLocalSearch,
            String? versionUi,
            String? audioUi,
            String? subtitleUi)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BaklavaConfig() when $default != null:
        return $default(
            _that.defaultTmdbId,
            _that.disableNonAdminRequests,
            _that.showReviewsCarousel,
            _that.tmdbApiKey,
            _that.enableSearchFilter,
            _that.forceTVClientLocalSearch,
            _that.versionUi,
            _that.audioUi,
            _that.subtitleUi);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _BaklavaConfig implements BaklavaConfig {
  const _BaklavaConfig(
      {this.defaultTmdbId = '',
      this.disableNonAdminRequests = false,
      this.showReviewsCarousel = true,
      this.tmdbApiKey,
      this.enableSearchFilter,
      this.forceTVClientLocalSearch,
      this.versionUi,
      this.audioUi,
      this.subtitleUi});
  factory _BaklavaConfig.fromJson(Map<String, dynamic> json) =>
      _$BaklavaConfigFromJson(json);

  @override
  @JsonKey()
  final String defaultTmdbId;
  @override
  @JsonKey()
  final bool disableNonAdminRequests;
  @override
  @JsonKey()
  final bool showReviewsCarousel;
  @override
  final String? tmdbApiKey;
  @override
  final bool? enableSearchFilter;
  @override
  final bool? forceTVClientLocalSearch;
  @override
  final String? versionUi;
  @override
  final String? audioUi;
  @override
  final String? subtitleUi;

  /// Create a copy of BaklavaConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BaklavaConfigCopyWith<_BaklavaConfig> get copyWith =>
      __$BaklavaConfigCopyWithImpl<_BaklavaConfig>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$BaklavaConfigToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _BaklavaConfig &&
            (identical(other.defaultTmdbId, defaultTmdbId) ||
                other.defaultTmdbId == defaultTmdbId) &&
            (identical(
                    other.disableNonAdminRequests, disableNonAdminRequests) ||
                other.disableNonAdminRequests == disableNonAdminRequests) &&
            (identical(other.showReviewsCarousel, showReviewsCarousel) ||
                other.showReviewsCarousel == showReviewsCarousel) &&
            (identical(other.tmdbApiKey, tmdbApiKey) ||
                other.tmdbApiKey == tmdbApiKey) &&
            (identical(other.enableSearchFilter, enableSearchFilter) ||
                other.enableSearchFilter == enableSearchFilter) &&
            (identical(
                    other.forceTVClientLocalSearch, forceTVClientLocalSearch) ||
                other.forceTVClientLocalSearch == forceTVClientLocalSearch) &&
            (identical(other.versionUi, versionUi) ||
                other.versionUi == versionUi) &&
            (identical(other.audioUi, audioUi) || other.audioUi == audioUi) &&
            (identical(other.subtitleUi, subtitleUi) ||
                other.subtitleUi == subtitleUi));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      defaultTmdbId,
      disableNonAdminRequests,
      showReviewsCarousel,
      tmdbApiKey,
      enableSearchFilter,
      forceTVClientLocalSearch,
      versionUi,
      audioUi,
      subtitleUi);

  @override
  String toString() {
    return 'BaklavaConfig(defaultTmdbId: $defaultTmdbId, disableNonAdminRequests: $disableNonAdminRequests, showReviewsCarousel: $showReviewsCarousel, tmdbApiKey: $tmdbApiKey, enableSearchFilter: $enableSearchFilter, forceTVClientLocalSearch: $forceTVClientLocalSearch, versionUi: $versionUi, audioUi: $audioUi, subtitleUi: $subtitleUi)';
  }
}

/// @nodoc
abstract mixin class _$BaklavaConfigCopyWith<$Res>
    implements $BaklavaConfigCopyWith<$Res> {
  factory _$BaklavaConfigCopyWith(
          _BaklavaConfig value, $Res Function(_BaklavaConfig) _then) =
      __$BaklavaConfigCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String defaultTmdbId,
      bool disableNonAdminRequests,
      bool showReviewsCarousel,
      String? tmdbApiKey,
      bool? enableSearchFilter,
      bool? forceTVClientLocalSearch,
      String? versionUi,
      String? audioUi,
      String? subtitleUi});
}

/// @nodoc
class __$BaklavaConfigCopyWithImpl<$Res>
    implements _$BaklavaConfigCopyWith<$Res> {
  __$BaklavaConfigCopyWithImpl(this._self, this._then);

  final _BaklavaConfig _self;
  final $Res Function(_BaklavaConfig) _then;

  /// Create a copy of BaklavaConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? defaultTmdbId = null,
    Object? disableNonAdminRequests = null,
    Object? showReviewsCarousel = null,
    Object? tmdbApiKey = freezed,
    Object? enableSearchFilter = freezed,
    Object? forceTVClientLocalSearch = freezed,
    Object? versionUi = freezed,
    Object? audioUi = freezed,
    Object? subtitleUi = freezed,
  }) {
    return _then(_BaklavaConfig(
      defaultTmdbId: null == defaultTmdbId
          ? _self.defaultTmdbId
          : defaultTmdbId // ignore: cast_nullable_to_non_nullable
              as String,
      disableNonAdminRequests: null == disableNonAdminRequests
          ? _self.disableNonAdminRequests
          : disableNonAdminRequests // ignore: cast_nullable_to_non_nullable
              as bool,
      showReviewsCarousel: null == showReviewsCarousel
          ? _self.showReviewsCarousel
          : showReviewsCarousel // ignore: cast_nullable_to_non_nullable
              as bool,
      tmdbApiKey: freezed == tmdbApiKey
          ? _self.tmdbApiKey
          : tmdbApiKey // ignore: cast_nullable_to_non_nullable
              as String?,
      enableSearchFilter: freezed == enableSearchFilter
          ? _self.enableSearchFilter
          : enableSearchFilter // ignore: cast_nullable_to_non_nullable
              as bool?,
      forceTVClientLocalSearch: freezed == forceTVClientLocalSearch
          ? _self.forceTVClientLocalSearch
          : forceTVClientLocalSearch // ignore: cast_nullable_to_non_nullable
              as bool?,
      versionUi: freezed == versionUi
          ? _self.versionUi
          : versionUi // ignore: cast_nullable_to_non_nullable
              as String?,
      audioUi: freezed == audioUi
          ? _self.audioUi
          : audioUi // ignore: cast_nullable_to_non_nullable
              as String?,
      subtitleUi: freezed == subtitleUi
          ? _self.subtitleUi
          : subtitleUi // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
