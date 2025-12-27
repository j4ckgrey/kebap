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
  bool get enableAutoImport;
  bool get disableModal;
  bool get showReviewsCarousel;
  String? get tmdbApiKey;
  bool? get enableSearchFilter;
  bool? get forceTVClientLocalSearch;
  String? get versionUi;
  String? get audioUi;
  String? get subtitleUi;
  String? get gelatoBaseUrl;
  String? get gelatoAuthHeader;
  String? get debridService;
  String? get debridApiKey;
  String? get realDebridApiKey;
  String? get torboxApiKey;
  String? get alldebridApiKey;
  String? get premiumizeApiKey;
  bool? get enableDebridMetadata;
  bool? get enableFallbackProbe;
  bool? get fetchCachedMetadataPerVersion;
  bool? get fetchAllNonCachedMetadata;
  bool? get enableExternalSubtitles;

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
            (identical(other.enableAutoImport, enableAutoImport) ||
                other.enableAutoImport == enableAutoImport) &&
            (identical(other.disableModal, disableModal) ||
                other.disableModal == disableModal) &&
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
                other.subtitleUi == subtitleUi) &&
            (identical(other.gelatoBaseUrl, gelatoBaseUrl) ||
                other.gelatoBaseUrl == gelatoBaseUrl) &&
            (identical(other.gelatoAuthHeader, gelatoAuthHeader) ||
                other.gelatoAuthHeader == gelatoAuthHeader) &&
            (identical(other.debridService, debridService) ||
                other.debridService == debridService) &&
            (identical(other.debridApiKey, debridApiKey) ||
                other.debridApiKey == debridApiKey) &&
            (identical(other.realDebridApiKey, realDebridApiKey) ||
                other.realDebridApiKey == realDebridApiKey) &&
            (identical(other.torboxApiKey, torboxApiKey) ||
                other.torboxApiKey == torboxApiKey) &&
            (identical(other.alldebridApiKey, alldebridApiKey) ||
                other.alldebridApiKey == alldebridApiKey) &&
            (identical(other.premiumizeApiKey, premiumizeApiKey) ||
                other.premiumizeApiKey == premiumizeApiKey) &&
            (identical(other.enableDebridMetadata, enableDebridMetadata) ||
                other.enableDebridMetadata == enableDebridMetadata) &&
            (identical(other.enableFallbackProbe, enableFallbackProbe) ||
                other.enableFallbackProbe == enableFallbackProbe) &&
            (identical(other.fetchCachedMetadataPerVersion,
                    fetchCachedMetadataPerVersion) ||
                other.fetchCachedMetadataPerVersion ==
                    fetchCachedMetadataPerVersion) &&
            (identical(other.fetchAllNonCachedMetadata,
                    fetchAllNonCachedMetadata) ||
                other.fetchAllNonCachedMetadata == fetchAllNonCachedMetadata) &&
            (identical(
                    other.enableExternalSubtitles, enableExternalSubtitles) ||
                other.enableExternalSubtitles == enableExternalSubtitles));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        defaultTmdbId,
        enableAutoImport,
        disableModal,
        showReviewsCarousel,
        tmdbApiKey,
        enableSearchFilter,
        forceTVClientLocalSearch,
        versionUi,
        audioUi,
        subtitleUi,
        gelatoBaseUrl,
        gelatoAuthHeader,
        debridService,
        debridApiKey,
        realDebridApiKey,
        torboxApiKey,
        alldebridApiKey,
        premiumizeApiKey,
        enableDebridMetadata,
        enableFallbackProbe,
        fetchCachedMetadataPerVersion,
        fetchAllNonCachedMetadata,
        enableExternalSubtitles
      ]);

  @override
  String toString() {
    return 'BaklavaConfig(defaultTmdbId: $defaultTmdbId, enableAutoImport: $enableAutoImport, disableModal: $disableModal, showReviewsCarousel: $showReviewsCarousel, tmdbApiKey: $tmdbApiKey, enableSearchFilter: $enableSearchFilter, forceTVClientLocalSearch: $forceTVClientLocalSearch, versionUi: $versionUi, audioUi: $audioUi, subtitleUi: $subtitleUi, gelatoBaseUrl: $gelatoBaseUrl, gelatoAuthHeader: $gelatoAuthHeader, debridService: $debridService, debridApiKey: $debridApiKey, realDebridApiKey: $realDebridApiKey, torboxApiKey: $torboxApiKey, alldebridApiKey: $alldebridApiKey, premiumizeApiKey: $premiumizeApiKey, enableDebridMetadata: $enableDebridMetadata, enableFallbackProbe: $enableFallbackProbe, fetchCachedMetadataPerVersion: $fetchCachedMetadataPerVersion, fetchAllNonCachedMetadata: $fetchAllNonCachedMetadata, enableExternalSubtitles: $enableExternalSubtitles)';
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
      bool enableAutoImport,
      bool disableModal,
      bool showReviewsCarousel,
      String? tmdbApiKey,
      bool? enableSearchFilter,
      bool? forceTVClientLocalSearch,
      String? versionUi,
      String? audioUi,
      String? subtitleUi,
      String? gelatoBaseUrl,
      String? gelatoAuthHeader,
      String? debridService,
      String? debridApiKey,
      String? realDebridApiKey,
      String? torboxApiKey,
      String? alldebridApiKey,
      String? premiumizeApiKey,
      bool? enableDebridMetadata,
      bool? enableFallbackProbe,
      bool? fetchCachedMetadataPerVersion,
      bool? fetchAllNonCachedMetadata,
      bool? enableExternalSubtitles});
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
    Object? enableAutoImport = null,
    Object? disableModal = null,
    Object? showReviewsCarousel = null,
    Object? tmdbApiKey = freezed,
    Object? enableSearchFilter = freezed,
    Object? forceTVClientLocalSearch = freezed,
    Object? versionUi = freezed,
    Object? audioUi = freezed,
    Object? subtitleUi = freezed,
    Object? gelatoBaseUrl = freezed,
    Object? gelatoAuthHeader = freezed,
    Object? debridService = freezed,
    Object? debridApiKey = freezed,
    Object? realDebridApiKey = freezed,
    Object? torboxApiKey = freezed,
    Object? alldebridApiKey = freezed,
    Object? premiumizeApiKey = freezed,
    Object? enableDebridMetadata = freezed,
    Object? enableFallbackProbe = freezed,
    Object? fetchCachedMetadataPerVersion = freezed,
    Object? fetchAllNonCachedMetadata = freezed,
    Object? enableExternalSubtitles = freezed,
  }) {
    return _then(_self.copyWith(
      defaultTmdbId: null == defaultTmdbId
          ? _self.defaultTmdbId
          : defaultTmdbId // ignore: cast_nullable_to_non_nullable
              as String,
      enableAutoImport: null == enableAutoImport
          ? _self.enableAutoImport
          : enableAutoImport // ignore: cast_nullable_to_non_nullable
              as bool,
      disableModal: null == disableModal
          ? _self.disableModal
          : disableModal // ignore: cast_nullable_to_non_nullable
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
      gelatoBaseUrl: freezed == gelatoBaseUrl
          ? _self.gelatoBaseUrl
          : gelatoBaseUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      gelatoAuthHeader: freezed == gelatoAuthHeader
          ? _self.gelatoAuthHeader
          : gelatoAuthHeader // ignore: cast_nullable_to_non_nullable
              as String?,
      debridService: freezed == debridService
          ? _self.debridService
          : debridService // ignore: cast_nullable_to_non_nullable
              as String?,
      debridApiKey: freezed == debridApiKey
          ? _self.debridApiKey
          : debridApiKey // ignore: cast_nullable_to_non_nullable
              as String?,
      realDebridApiKey: freezed == realDebridApiKey
          ? _self.realDebridApiKey
          : realDebridApiKey // ignore: cast_nullable_to_non_nullable
              as String?,
      torboxApiKey: freezed == torboxApiKey
          ? _self.torboxApiKey
          : torboxApiKey // ignore: cast_nullable_to_non_nullable
              as String?,
      alldebridApiKey: freezed == alldebridApiKey
          ? _self.alldebridApiKey
          : alldebridApiKey // ignore: cast_nullable_to_non_nullable
              as String?,
      premiumizeApiKey: freezed == premiumizeApiKey
          ? _self.premiumizeApiKey
          : premiumizeApiKey // ignore: cast_nullable_to_non_nullable
              as String?,
      enableDebridMetadata: freezed == enableDebridMetadata
          ? _self.enableDebridMetadata
          : enableDebridMetadata // ignore: cast_nullable_to_non_nullable
              as bool?,
      enableFallbackProbe: freezed == enableFallbackProbe
          ? _self.enableFallbackProbe
          : enableFallbackProbe // ignore: cast_nullable_to_non_nullable
              as bool?,
      fetchCachedMetadataPerVersion: freezed == fetchCachedMetadataPerVersion
          ? _self.fetchCachedMetadataPerVersion
          : fetchCachedMetadataPerVersion // ignore: cast_nullable_to_non_nullable
              as bool?,
      fetchAllNonCachedMetadata: freezed == fetchAllNonCachedMetadata
          ? _self.fetchAllNonCachedMetadata
          : fetchAllNonCachedMetadata // ignore: cast_nullable_to_non_nullable
              as bool?,
      enableExternalSubtitles: freezed == enableExternalSubtitles
          ? _self.enableExternalSubtitles
          : enableExternalSubtitles // ignore: cast_nullable_to_non_nullable
              as bool?,
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
            bool enableAutoImport,
            bool disableModal,
            bool showReviewsCarousel,
            String? tmdbApiKey,
            bool? enableSearchFilter,
            bool? forceTVClientLocalSearch,
            String? versionUi,
            String? audioUi,
            String? subtitleUi,
            String? gelatoBaseUrl,
            String? gelatoAuthHeader,
            String? debridService,
            String? debridApiKey,
            String? realDebridApiKey,
            String? torboxApiKey,
            String? alldebridApiKey,
            String? premiumizeApiKey,
            bool? enableDebridMetadata,
            bool? enableFallbackProbe,
            bool? fetchCachedMetadataPerVersion,
            bool? fetchAllNonCachedMetadata,
            bool? enableExternalSubtitles)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BaklavaConfig() when $default != null:
        return $default(
            _that.defaultTmdbId,
            _that.enableAutoImport,
            _that.disableModal,
            _that.showReviewsCarousel,
            _that.tmdbApiKey,
            _that.enableSearchFilter,
            _that.forceTVClientLocalSearch,
            _that.versionUi,
            _that.audioUi,
            _that.subtitleUi,
            _that.gelatoBaseUrl,
            _that.gelatoAuthHeader,
            _that.debridService,
            _that.debridApiKey,
            _that.realDebridApiKey,
            _that.torboxApiKey,
            _that.alldebridApiKey,
            _that.premiumizeApiKey,
            _that.enableDebridMetadata,
            _that.enableFallbackProbe,
            _that.fetchCachedMetadataPerVersion,
            _that.fetchAllNonCachedMetadata,
            _that.enableExternalSubtitles);
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
            bool enableAutoImport,
            bool disableModal,
            bool showReviewsCarousel,
            String? tmdbApiKey,
            bool? enableSearchFilter,
            bool? forceTVClientLocalSearch,
            String? versionUi,
            String? audioUi,
            String? subtitleUi,
            String? gelatoBaseUrl,
            String? gelatoAuthHeader,
            String? debridService,
            String? debridApiKey,
            String? realDebridApiKey,
            String? torboxApiKey,
            String? alldebridApiKey,
            String? premiumizeApiKey,
            bool? enableDebridMetadata,
            bool? enableFallbackProbe,
            bool? fetchCachedMetadataPerVersion,
            bool? fetchAllNonCachedMetadata,
            bool? enableExternalSubtitles)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BaklavaConfig():
        return $default(
            _that.defaultTmdbId,
            _that.enableAutoImport,
            _that.disableModal,
            _that.showReviewsCarousel,
            _that.tmdbApiKey,
            _that.enableSearchFilter,
            _that.forceTVClientLocalSearch,
            _that.versionUi,
            _that.audioUi,
            _that.subtitleUi,
            _that.gelatoBaseUrl,
            _that.gelatoAuthHeader,
            _that.debridService,
            _that.debridApiKey,
            _that.realDebridApiKey,
            _that.torboxApiKey,
            _that.alldebridApiKey,
            _that.premiumizeApiKey,
            _that.enableDebridMetadata,
            _that.enableFallbackProbe,
            _that.fetchCachedMetadataPerVersion,
            _that.fetchAllNonCachedMetadata,
            _that.enableExternalSubtitles);
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
            bool enableAutoImport,
            bool disableModal,
            bool showReviewsCarousel,
            String? tmdbApiKey,
            bool? enableSearchFilter,
            bool? forceTVClientLocalSearch,
            String? versionUi,
            String? audioUi,
            String? subtitleUi,
            String? gelatoBaseUrl,
            String? gelatoAuthHeader,
            String? debridService,
            String? debridApiKey,
            String? realDebridApiKey,
            String? torboxApiKey,
            String? alldebridApiKey,
            String? premiumizeApiKey,
            bool? enableDebridMetadata,
            bool? enableFallbackProbe,
            bool? fetchCachedMetadataPerVersion,
            bool? fetchAllNonCachedMetadata,
            bool? enableExternalSubtitles)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BaklavaConfig() when $default != null:
        return $default(
            _that.defaultTmdbId,
            _that.enableAutoImport,
            _that.disableModal,
            _that.showReviewsCarousel,
            _that.tmdbApiKey,
            _that.enableSearchFilter,
            _that.forceTVClientLocalSearch,
            _that.versionUi,
            _that.audioUi,
            _that.subtitleUi,
            _that.gelatoBaseUrl,
            _that.gelatoAuthHeader,
            _that.debridService,
            _that.debridApiKey,
            _that.realDebridApiKey,
            _that.torboxApiKey,
            _that.alldebridApiKey,
            _that.premiumizeApiKey,
            _that.enableDebridMetadata,
            _that.enableFallbackProbe,
            _that.fetchCachedMetadataPerVersion,
            _that.fetchAllNonCachedMetadata,
            _that.enableExternalSubtitles);
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
      this.enableAutoImport = false,
      this.disableModal = false,
      this.showReviewsCarousel = true,
      this.tmdbApiKey,
      this.enableSearchFilter,
      this.forceTVClientLocalSearch,
      this.versionUi = '',
      this.audioUi = '',
      this.subtitleUi = '',
      this.gelatoBaseUrl = '',
      this.gelatoAuthHeader = '',
      this.debridService = 'realdebrid',
      this.debridApiKey = '',
      this.realDebridApiKey = '',
      this.torboxApiKey = '',
      this.alldebridApiKey = '',
      this.premiumizeApiKey = '',
      this.enableDebridMetadata = true,
      this.enableFallbackProbe = false,
      this.fetchCachedMetadataPerVersion = false,
      this.fetchAllNonCachedMetadata = false,
      this.enableExternalSubtitles = false});
  factory _BaklavaConfig.fromJson(Map<String, dynamic> json) =>
      _$BaklavaConfigFromJson(json);

  @override
  @JsonKey()
  final String defaultTmdbId;
  @override
  @JsonKey()
  final bool enableAutoImport;
  @override
  @JsonKey()
  final bool disableModal;
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
  @JsonKey()
  final String? versionUi;
  @override
  @JsonKey()
  final String? audioUi;
  @override
  @JsonKey()
  final String? subtitleUi;
  @override
  @JsonKey()
  final String? gelatoBaseUrl;
  @override
  @JsonKey()
  final String? gelatoAuthHeader;
  @override
  @JsonKey()
  final String? debridService;
  @override
  @JsonKey()
  final String? debridApiKey;
  @override
  @JsonKey()
  final String? realDebridApiKey;
  @override
  @JsonKey()
  final String? torboxApiKey;
  @override
  @JsonKey()
  final String? alldebridApiKey;
  @override
  @JsonKey()
  final String? premiumizeApiKey;
  @override
  @JsonKey()
  final bool? enableDebridMetadata;
  @override
  @JsonKey()
  final bool? enableFallbackProbe;
  @override
  @JsonKey()
  final bool? fetchCachedMetadataPerVersion;
  @override
  @JsonKey()
  final bool? fetchAllNonCachedMetadata;
  @override
  @JsonKey()
  final bool? enableExternalSubtitles;

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
            (identical(other.enableAutoImport, enableAutoImport) ||
                other.enableAutoImport == enableAutoImport) &&
            (identical(other.disableModal, disableModal) ||
                other.disableModal == disableModal) &&
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
                other.subtitleUi == subtitleUi) &&
            (identical(other.gelatoBaseUrl, gelatoBaseUrl) ||
                other.gelatoBaseUrl == gelatoBaseUrl) &&
            (identical(other.gelatoAuthHeader, gelatoAuthHeader) ||
                other.gelatoAuthHeader == gelatoAuthHeader) &&
            (identical(other.debridService, debridService) ||
                other.debridService == debridService) &&
            (identical(other.debridApiKey, debridApiKey) ||
                other.debridApiKey == debridApiKey) &&
            (identical(other.realDebridApiKey, realDebridApiKey) ||
                other.realDebridApiKey == realDebridApiKey) &&
            (identical(other.torboxApiKey, torboxApiKey) ||
                other.torboxApiKey == torboxApiKey) &&
            (identical(other.alldebridApiKey, alldebridApiKey) ||
                other.alldebridApiKey == alldebridApiKey) &&
            (identical(other.premiumizeApiKey, premiumizeApiKey) ||
                other.premiumizeApiKey == premiumizeApiKey) &&
            (identical(other.enableDebridMetadata, enableDebridMetadata) ||
                other.enableDebridMetadata == enableDebridMetadata) &&
            (identical(other.enableFallbackProbe, enableFallbackProbe) ||
                other.enableFallbackProbe == enableFallbackProbe) &&
            (identical(other.fetchCachedMetadataPerVersion,
                    fetchCachedMetadataPerVersion) ||
                other.fetchCachedMetadataPerVersion ==
                    fetchCachedMetadataPerVersion) &&
            (identical(other.fetchAllNonCachedMetadata,
                    fetchAllNonCachedMetadata) ||
                other.fetchAllNonCachedMetadata == fetchAllNonCachedMetadata) &&
            (identical(
                    other.enableExternalSubtitles, enableExternalSubtitles) ||
                other.enableExternalSubtitles == enableExternalSubtitles));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        defaultTmdbId,
        enableAutoImport,
        disableModal,
        showReviewsCarousel,
        tmdbApiKey,
        enableSearchFilter,
        forceTVClientLocalSearch,
        versionUi,
        audioUi,
        subtitleUi,
        gelatoBaseUrl,
        gelatoAuthHeader,
        debridService,
        debridApiKey,
        realDebridApiKey,
        torboxApiKey,
        alldebridApiKey,
        premiumizeApiKey,
        enableDebridMetadata,
        enableFallbackProbe,
        fetchCachedMetadataPerVersion,
        fetchAllNonCachedMetadata,
        enableExternalSubtitles
      ]);

  @override
  String toString() {
    return 'BaklavaConfig(defaultTmdbId: $defaultTmdbId, enableAutoImport: $enableAutoImport, disableModal: $disableModal, showReviewsCarousel: $showReviewsCarousel, tmdbApiKey: $tmdbApiKey, enableSearchFilter: $enableSearchFilter, forceTVClientLocalSearch: $forceTVClientLocalSearch, versionUi: $versionUi, audioUi: $audioUi, subtitleUi: $subtitleUi, gelatoBaseUrl: $gelatoBaseUrl, gelatoAuthHeader: $gelatoAuthHeader, debridService: $debridService, debridApiKey: $debridApiKey, realDebridApiKey: $realDebridApiKey, torboxApiKey: $torboxApiKey, alldebridApiKey: $alldebridApiKey, premiumizeApiKey: $premiumizeApiKey, enableDebridMetadata: $enableDebridMetadata, enableFallbackProbe: $enableFallbackProbe, fetchCachedMetadataPerVersion: $fetchCachedMetadataPerVersion, fetchAllNonCachedMetadata: $fetchAllNonCachedMetadata, enableExternalSubtitles: $enableExternalSubtitles)';
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
      bool enableAutoImport,
      bool disableModal,
      bool showReviewsCarousel,
      String? tmdbApiKey,
      bool? enableSearchFilter,
      bool? forceTVClientLocalSearch,
      String? versionUi,
      String? audioUi,
      String? subtitleUi,
      String? gelatoBaseUrl,
      String? gelatoAuthHeader,
      String? debridService,
      String? debridApiKey,
      String? realDebridApiKey,
      String? torboxApiKey,
      String? alldebridApiKey,
      String? premiumizeApiKey,
      bool? enableDebridMetadata,
      bool? enableFallbackProbe,
      bool? fetchCachedMetadataPerVersion,
      bool? fetchAllNonCachedMetadata,
      bool? enableExternalSubtitles});
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
    Object? enableAutoImport = null,
    Object? disableModal = null,
    Object? showReviewsCarousel = null,
    Object? tmdbApiKey = freezed,
    Object? enableSearchFilter = freezed,
    Object? forceTVClientLocalSearch = freezed,
    Object? versionUi = freezed,
    Object? audioUi = freezed,
    Object? subtitleUi = freezed,
    Object? gelatoBaseUrl = freezed,
    Object? gelatoAuthHeader = freezed,
    Object? debridService = freezed,
    Object? debridApiKey = freezed,
    Object? realDebridApiKey = freezed,
    Object? torboxApiKey = freezed,
    Object? alldebridApiKey = freezed,
    Object? premiumizeApiKey = freezed,
    Object? enableDebridMetadata = freezed,
    Object? enableFallbackProbe = freezed,
    Object? fetchCachedMetadataPerVersion = freezed,
    Object? fetchAllNonCachedMetadata = freezed,
    Object? enableExternalSubtitles = freezed,
  }) {
    return _then(_BaklavaConfig(
      defaultTmdbId: null == defaultTmdbId
          ? _self.defaultTmdbId
          : defaultTmdbId // ignore: cast_nullable_to_non_nullable
              as String,
      enableAutoImport: null == enableAutoImport
          ? _self.enableAutoImport
          : enableAutoImport // ignore: cast_nullable_to_non_nullable
              as bool,
      disableModal: null == disableModal
          ? _self.disableModal
          : disableModal // ignore: cast_nullable_to_non_nullable
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
      gelatoBaseUrl: freezed == gelatoBaseUrl
          ? _self.gelatoBaseUrl
          : gelatoBaseUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      gelatoAuthHeader: freezed == gelatoAuthHeader
          ? _self.gelatoAuthHeader
          : gelatoAuthHeader // ignore: cast_nullable_to_non_nullable
              as String?,
      debridService: freezed == debridService
          ? _self.debridService
          : debridService // ignore: cast_nullable_to_non_nullable
              as String?,
      debridApiKey: freezed == debridApiKey
          ? _self.debridApiKey
          : debridApiKey // ignore: cast_nullable_to_non_nullable
              as String?,
      realDebridApiKey: freezed == realDebridApiKey
          ? _self.realDebridApiKey
          : realDebridApiKey // ignore: cast_nullable_to_non_nullable
              as String?,
      torboxApiKey: freezed == torboxApiKey
          ? _self.torboxApiKey
          : torboxApiKey // ignore: cast_nullable_to_non_nullable
              as String?,
      alldebridApiKey: freezed == alldebridApiKey
          ? _self.alldebridApiKey
          : alldebridApiKey // ignore: cast_nullable_to_non_nullable
              as String?,
      premiumizeApiKey: freezed == premiumizeApiKey
          ? _self.premiumizeApiKey
          : premiumizeApiKey // ignore: cast_nullable_to_non_nullable
              as String?,
      enableDebridMetadata: freezed == enableDebridMetadata
          ? _self.enableDebridMetadata
          : enableDebridMetadata // ignore: cast_nullable_to_non_nullable
              as bool?,
      enableFallbackProbe: freezed == enableFallbackProbe
          ? _self.enableFallbackProbe
          : enableFallbackProbe // ignore: cast_nullable_to_non_nullable
              as bool?,
      fetchCachedMetadataPerVersion: freezed == fetchCachedMetadataPerVersion
          ? _self.fetchCachedMetadataPerVersion
          : fetchCachedMetadataPerVersion // ignore: cast_nullable_to_non_nullable
              as bool?,
      fetchAllNonCachedMetadata: freezed == fetchAllNonCachedMetadata
          ? _self.fetchAllNonCachedMetadata
          : fetchAllNonCachedMetadata // ignore: cast_nullable_to_non_nullable
              as bool?,
      enableExternalSubtitles: freezed == enableExternalSubtitles
          ? _self.enableExternalSubtitles
          : enableExternalSubtitles // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

// dart format on
