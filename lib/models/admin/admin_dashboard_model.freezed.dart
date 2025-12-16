// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_dashboard_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AdminDashboardModel {
  SystemInfo? get systemInfo;
  List<SessionInfoDto> get activeSessions;
  List<ActivityLogEntry> get recentActivity;
  List<TaskInfo> get runningTasks;
  int get userCount;
  int get deviceCount;
  bool get isLoading;
  String? get error;

  /// Create a copy of AdminDashboardModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AdminDashboardModelCopyWith<AdminDashboardModel> get copyWith =>
      _$AdminDashboardModelCopyWithImpl<AdminDashboardModel>(
          this as AdminDashboardModel, _$identity);

  /// Serializes this AdminDashboardModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AdminDashboardModel &&
            (identical(other.systemInfo, systemInfo) ||
                other.systemInfo == systemInfo) &&
            const DeepCollectionEquality()
                .equals(other.activeSessions, activeSessions) &&
            const DeepCollectionEquality()
                .equals(other.recentActivity, recentActivity) &&
            const DeepCollectionEquality()
                .equals(other.runningTasks, runningTasks) &&
            (identical(other.userCount, userCount) ||
                other.userCount == userCount) &&
            (identical(other.deviceCount, deviceCount) ||
                other.deviceCount == deviceCount) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      systemInfo,
      const DeepCollectionEquality().hash(activeSessions),
      const DeepCollectionEquality().hash(recentActivity),
      const DeepCollectionEquality().hash(runningTasks),
      userCount,
      deviceCount,
      isLoading,
      error);

  @override
  String toString() {
    return 'AdminDashboardModel(systemInfo: $systemInfo, activeSessions: $activeSessions, recentActivity: $recentActivity, runningTasks: $runningTasks, userCount: $userCount, deviceCount: $deviceCount, isLoading: $isLoading, error: $error)';
  }
}

/// @nodoc
abstract mixin class $AdminDashboardModelCopyWith<$Res> {
  factory $AdminDashboardModelCopyWith(
          AdminDashboardModel value, $Res Function(AdminDashboardModel) _then) =
      _$AdminDashboardModelCopyWithImpl;
  @useResult
  $Res call(
      {SystemInfo? systemInfo,
      List<SessionInfoDto> activeSessions,
      List<ActivityLogEntry> recentActivity,
      List<TaskInfo> runningTasks,
      int userCount,
      int deviceCount,
      bool isLoading,
      String? error});
}

/// @nodoc
class _$AdminDashboardModelCopyWithImpl<$Res>
    implements $AdminDashboardModelCopyWith<$Res> {
  _$AdminDashboardModelCopyWithImpl(this._self, this._then);

  final AdminDashboardModel _self;
  final $Res Function(AdminDashboardModel) _then;

  /// Create a copy of AdminDashboardModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? systemInfo = freezed,
    Object? activeSessions = null,
    Object? recentActivity = null,
    Object? runningTasks = null,
    Object? userCount = null,
    Object? deviceCount = null,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(_self.copyWith(
      systemInfo: freezed == systemInfo
          ? _self.systemInfo
          : systemInfo // ignore: cast_nullable_to_non_nullable
              as SystemInfo?,
      activeSessions: null == activeSessions
          ? _self.activeSessions
          : activeSessions // ignore: cast_nullable_to_non_nullable
              as List<SessionInfoDto>,
      recentActivity: null == recentActivity
          ? _self.recentActivity
          : recentActivity // ignore: cast_nullable_to_non_nullable
              as List<ActivityLogEntry>,
      runningTasks: null == runningTasks
          ? _self.runningTasks
          : runningTasks // ignore: cast_nullable_to_non_nullable
              as List<TaskInfo>,
      userCount: null == userCount
          ? _self.userCount
          : userCount // ignore: cast_nullable_to_non_nullable
              as int,
      deviceCount: null == deviceCount
          ? _self.deviceCount
          : deviceCount // ignore: cast_nullable_to_non_nullable
              as int,
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [AdminDashboardModel].
extension AdminDashboardModelPatterns on AdminDashboardModel {
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
    TResult Function(_AdminDashboardModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AdminDashboardModel() when $default != null:
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
    TResult Function(_AdminDashboardModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AdminDashboardModel():
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
    TResult? Function(_AdminDashboardModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AdminDashboardModel() when $default != null:
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
            SystemInfo? systemInfo,
            List<SessionInfoDto> activeSessions,
            List<ActivityLogEntry> recentActivity,
            List<TaskInfo> runningTasks,
            int userCount,
            int deviceCount,
            bool isLoading,
            String? error)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AdminDashboardModel() when $default != null:
        return $default(
            _that.systemInfo,
            _that.activeSessions,
            _that.recentActivity,
            _that.runningTasks,
            _that.userCount,
            _that.deviceCount,
            _that.isLoading,
            _that.error);
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
            SystemInfo? systemInfo,
            List<SessionInfoDto> activeSessions,
            List<ActivityLogEntry> recentActivity,
            List<TaskInfo> runningTasks,
            int userCount,
            int deviceCount,
            bool isLoading,
            String? error)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AdminDashboardModel():
        return $default(
            _that.systemInfo,
            _that.activeSessions,
            _that.recentActivity,
            _that.runningTasks,
            _that.userCount,
            _that.deviceCount,
            _that.isLoading,
            _that.error);
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
            SystemInfo? systemInfo,
            List<SessionInfoDto> activeSessions,
            List<ActivityLogEntry> recentActivity,
            List<TaskInfo> runningTasks,
            int userCount,
            int deviceCount,
            bool isLoading,
            String? error)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AdminDashboardModel() when $default != null:
        return $default(
            _that.systemInfo,
            _that.activeSessions,
            _that.recentActivity,
            _that.runningTasks,
            _that.userCount,
            _that.deviceCount,
            _that.isLoading,
            _that.error);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _AdminDashboardModel implements AdminDashboardModel {
  const _AdminDashboardModel(
      {this.systemInfo,
      final List<SessionInfoDto> activeSessions = const [],
      final List<ActivityLogEntry> recentActivity = const [],
      final List<TaskInfo> runningTasks = const [],
      this.userCount = 0,
      this.deviceCount = 0,
      this.isLoading = false,
      this.error})
      : _activeSessions = activeSessions,
        _recentActivity = recentActivity,
        _runningTasks = runningTasks;
  factory _AdminDashboardModel.fromJson(Map<String, dynamic> json) =>
      _$AdminDashboardModelFromJson(json);

  @override
  final SystemInfo? systemInfo;
  final List<SessionInfoDto> _activeSessions;
  @override
  @JsonKey()
  List<SessionInfoDto> get activeSessions {
    if (_activeSessions is EqualUnmodifiableListView) return _activeSessions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_activeSessions);
  }

  final List<ActivityLogEntry> _recentActivity;
  @override
  @JsonKey()
  List<ActivityLogEntry> get recentActivity {
    if (_recentActivity is EqualUnmodifiableListView) return _recentActivity;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recentActivity);
  }

  final List<TaskInfo> _runningTasks;
  @override
  @JsonKey()
  List<TaskInfo> get runningTasks {
    if (_runningTasks is EqualUnmodifiableListView) return _runningTasks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_runningTasks);
  }

  @override
  @JsonKey()
  final int userCount;
  @override
  @JsonKey()
  final int deviceCount;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? error;

  /// Create a copy of AdminDashboardModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AdminDashboardModelCopyWith<_AdminDashboardModel> get copyWith =>
      __$AdminDashboardModelCopyWithImpl<_AdminDashboardModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AdminDashboardModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AdminDashboardModel &&
            (identical(other.systemInfo, systemInfo) ||
                other.systemInfo == systemInfo) &&
            const DeepCollectionEquality()
                .equals(other._activeSessions, _activeSessions) &&
            const DeepCollectionEquality()
                .equals(other._recentActivity, _recentActivity) &&
            const DeepCollectionEquality()
                .equals(other._runningTasks, _runningTasks) &&
            (identical(other.userCount, userCount) ||
                other.userCount == userCount) &&
            (identical(other.deviceCount, deviceCount) ||
                other.deviceCount == deviceCount) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      systemInfo,
      const DeepCollectionEquality().hash(_activeSessions),
      const DeepCollectionEquality().hash(_recentActivity),
      const DeepCollectionEquality().hash(_runningTasks),
      userCount,
      deviceCount,
      isLoading,
      error);

  @override
  String toString() {
    return 'AdminDashboardModel(systemInfo: $systemInfo, activeSessions: $activeSessions, recentActivity: $recentActivity, runningTasks: $runningTasks, userCount: $userCount, deviceCount: $deviceCount, isLoading: $isLoading, error: $error)';
  }
}

/// @nodoc
abstract mixin class _$AdminDashboardModelCopyWith<$Res>
    implements $AdminDashboardModelCopyWith<$Res> {
  factory _$AdminDashboardModelCopyWith(_AdminDashboardModel value,
          $Res Function(_AdminDashboardModel) _then) =
      __$AdminDashboardModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {SystemInfo? systemInfo,
      List<SessionInfoDto> activeSessions,
      List<ActivityLogEntry> recentActivity,
      List<TaskInfo> runningTasks,
      int userCount,
      int deviceCount,
      bool isLoading,
      String? error});
}

/// @nodoc
class __$AdminDashboardModelCopyWithImpl<$Res>
    implements _$AdminDashboardModelCopyWith<$Res> {
  __$AdminDashboardModelCopyWithImpl(this._self, this._then);

  final _AdminDashboardModel _self;
  final $Res Function(_AdminDashboardModel) _then;

  /// Create a copy of AdminDashboardModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? systemInfo = freezed,
    Object? activeSessions = null,
    Object? recentActivity = null,
    Object? runningTasks = null,
    Object? userCount = null,
    Object? deviceCount = null,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(_AdminDashboardModel(
      systemInfo: freezed == systemInfo
          ? _self.systemInfo
          : systemInfo // ignore: cast_nullable_to_non_nullable
              as SystemInfo?,
      activeSessions: null == activeSessions
          ? _self._activeSessions
          : activeSessions // ignore: cast_nullable_to_non_nullable
              as List<SessionInfoDto>,
      recentActivity: null == recentActivity
          ? _self._recentActivity
          : recentActivity // ignore: cast_nullable_to_non_nullable
              as List<ActivityLogEntry>,
      runningTasks: null == runningTasks
          ? _self._runningTasks
          : runningTasks // ignore: cast_nullable_to_non_nullable
              as List<TaskInfo>,
      userCount: null == userCount
          ? _self.userCount
          : userCount // ignore: cast_nullable_to_non_nullable
              as int,
      deviceCount: null == deviceCount
          ? _self.deviceCount
          : deviceCount // ignore: cast_nullable_to_non_nullable
              as int,
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$AdminStatsModel {
  int get totalUsers;
  int get activeUsers;
  int get totalDevices;
  int get activeSessions;
  int get movieCount;
  int get seriesCount;
  int get episodeCount;
  int get songCount;
  int get bookCount;

  /// Create a copy of AdminStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AdminStatsModelCopyWith<AdminStatsModel> get copyWith =>
      _$AdminStatsModelCopyWithImpl<AdminStatsModel>(
          this as AdminStatsModel, _$identity);

  /// Serializes this AdminStatsModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AdminStatsModel &&
            (identical(other.totalUsers, totalUsers) ||
                other.totalUsers == totalUsers) &&
            (identical(other.activeUsers, activeUsers) ||
                other.activeUsers == activeUsers) &&
            (identical(other.totalDevices, totalDevices) ||
                other.totalDevices == totalDevices) &&
            (identical(other.activeSessions, activeSessions) ||
                other.activeSessions == activeSessions) &&
            (identical(other.movieCount, movieCount) ||
                other.movieCount == movieCount) &&
            (identical(other.seriesCount, seriesCount) ||
                other.seriesCount == seriesCount) &&
            (identical(other.episodeCount, episodeCount) ||
                other.episodeCount == episodeCount) &&
            (identical(other.songCount, songCount) ||
                other.songCount == songCount) &&
            (identical(other.bookCount, bookCount) ||
                other.bookCount == bookCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      totalUsers,
      activeUsers,
      totalDevices,
      activeSessions,
      movieCount,
      seriesCount,
      episodeCount,
      songCount,
      bookCount);

  @override
  String toString() {
    return 'AdminStatsModel(totalUsers: $totalUsers, activeUsers: $activeUsers, totalDevices: $totalDevices, activeSessions: $activeSessions, movieCount: $movieCount, seriesCount: $seriesCount, episodeCount: $episodeCount, songCount: $songCount, bookCount: $bookCount)';
  }
}

/// @nodoc
abstract mixin class $AdminStatsModelCopyWith<$Res> {
  factory $AdminStatsModelCopyWith(
          AdminStatsModel value, $Res Function(AdminStatsModel) _then) =
      _$AdminStatsModelCopyWithImpl;
  @useResult
  $Res call(
      {int totalUsers,
      int activeUsers,
      int totalDevices,
      int activeSessions,
      int movieCount,
      int seriesCount,
      int episodeCount,
      int songCount,
      int bookCount});
}

/// @nodoc
class _$AdminStatsModelCopyWithImpl<$Res>
    implements $AdminStatsModelCopyWith<$Res> {
  _$AdminStatsModelCopyWithImpl(this._self, this._then);

  final AdminStatsModel _self;
  final $Res Function(AdminStatsModel) _then;

  /// Create a copy of AdminStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalUsers = null,
    Object? activeUsers = null,
    Object? totalDevices = null,
    Object? activeSessions = null,
    Object? movieCount = null,
    Object? seriesCount = null,
    Object? episodeCount = null,
    Object? songCount = null,
    Object? bookCount = null,
  }) {
    return _then(_self.copyWith(
      totalUsers: null == totalUsers
          ? _self.totalUsers
          : totalUsers // ignore: cast_nullable_to_non_nullable
              as int,
      activeUsers: null == activeUsers
          ? _self.activeUsers
          : activeUsers // ignore: cast_nullable_to_non_nullable
              as int,
      totalDevices: null == totalDevices
          ? _self.totalDevices
          : totalDevices // ignore: cast_nullable_to_non_nullable
              as int,
      activeSessions: null == activeSessions
          ? _self.activeSessions
          : activeSessions // ignore: cast_nullable_to_non_nullable
              as int,
      movieCount: null == movieCount
          ? _self.movieCount
          : movieCount // ignore: cast_nullable_to_non_nullable
              as int,
      seriesCount: null == seriesCount
          ? _self.seriesCount
          : seriesCount // ignore: cast_nullable_to_non_nullable
              as int,
      episodeCount: null == episodeCount
          ? _self.episodeCount
          : episodeCount // ignore: cast_nullable_to_non_nullable
              as int,
      songCount: null == songCount
          ? _self.songCount
          : songCount // ignore: cast_nullable_to_non_nullable
              as int,
      bookCount: null == bookCount
          ? _self.bookCount
          : bookCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [AdminStatsModel].
extension AdminStatsModelPatterns on AdminStatsModel {
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
    TResult Function(_AdminStatsModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AdminStatsModel() when $default != null:
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
    TResult Function(_AdminStatsModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AdminStatsModel():
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
    TResult? Function(_AdminStatsModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AdminStatsModel() when $default != null:
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
            int totalUsers,
            int activeUsers,
            int totalDevices,
            int activeSessions,
            int movieCount,
            int seriesCount,
            int episodeCount,
            int songCount,
            int bookCount)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AdminStatsModel() when $default != null:
        return $default(
            _that.totalUsers,
            _that.activeUsers,
            _that.totalDevices,
            _that.activeSessions,
            _that.movieCount,
            _that.seriesCount,
            _that.episodeCount,
            _that.songCount,
            _that.bookCount);
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
            int totalUsers,
            int activeUsers,
            int totalDevices,
            int activeSessions,
            int movieCount,
            int seriesCount,
            int episodeCount,
            int songCount,
            int bookCount)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AdminStatsModel():
        return $default(
            _that.totalUsers,
            _that.activeUsers,
            _that.totalDevices,
            _that.activeSessions,
            _that.movieCount,
            _that.seriesCount,
            _that.episodeCount,
            _that.songCount,
            _that.bookCount);
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
            int totalUsers,
            int activeUsers,
            int totalDevices,
            int activeSessions,
            int movieCount,
            int seriesCount,
            int episodeCount,
            int songCount,
            int bookCount)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AdminStatsModel() when $default != null:
        return $default(
            _that.totalUsers,
            _that.activeUsers,
            _that.totalDevices,
            _that.activeSessions,
            _that.movieCount,
            _that.seriesCount,
            _that.episodeCount,
            _that.songCount,
            _that.bookCount);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _AdminStatsModel implements AdminStatsModel {
  const _AdminStatsModel(
      {this.totalUsers = 0,
      this.activeUsers = 0,
      this.totalDevices = 0,
      this.activeSessions = 0,
      this.movieCount = 0,
      this.seriesCount = 0,
      this.episodeCount = 0,
      this.songCount = 0,
      this.bookCount = 0});
  factory _AdminStatsModel.fromJson(Map<String, dynamic> json) =>
      _$AdminStatsModelFromJson(json);

  @override
  @JsonKey()
  final int totalUsers;
  @override
  @JsonKey()
  final int activeUsers;
  @override
  @JsonKey()
  final int totalDevices;
  @override
  @JsonKey()
  final int activeSessions;
  @override
  @JsonKey()
  final int movieCount;
  @override
  @JsonKey()
  final int seriesCount;
  @override
  @JsonKey()
  final int episodeCount;
  @override
  @JsonKey()
  final int songCount;
  @override
  @JsonKey()
  final int bookCount;

  /// Create a copy of AdminStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AdminStatsModelCopyWith<_AdminStatsModel> get copyWith =>
      __$AdminStatsModelCopyWithImpl<_AdminStatsModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AdminStatsModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AdminStatsModel &&
            (identical(other.totalUsers, totalUsers) ||
                other.totalUsers == totalUsers) &&
            (identical(other.activeUsers, activeUsers) ||
                other.activeUsers == activeUsers) &&
            (identical(other.totalDevices, totalDevices) ||
                other.totalDevices == totalDevices) &&
            (identical(other.activeSessions, activeSessions) ||
                other.activeSessions == activeSessions) &&
            (identical(other.movieCount, movieCount) ||
                other.movieCount == movieCount) &&
            (identical(other.seriesCount, seriesCount) ||
                other.seriesCount == seriesCount) &&
            (identical(other.episodeCount, episodeCount) ||
                other.episodeCount == episodeCount) &&
            (identical(other.songCount, songCount) ||
                other.songCount == songCount) &&
            (identical(other.bookCount, bookCount) ||
                other.bookCount == bookCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      totalUsers,
      activeUsers,
      totalDevices,
      activeSessions,
      movieCount,
      seriesCount,
      episodeCount,
      songCount,
      bookCount);

  @override
  String toString() {
    return 'AdminStatsModel(totalUsers: $totalUsers, activeUsers: $activeUsers, totalDevices: $totalDevices, activeSessions: $activeSessions, movieCount: $movieCount, seriesCount: $seriesCount, episodeCount: $episodeCount, songCount: $songCount, bookCount: $bookCount)';
  }
}

/// @nodoc
abstract mixin class _$AdminStatsModelCopyWith<$Res>
    implements $AdminStatsModelCopyWith<$Res> {
  factory _$AdminStatsModelCopyWith(
          _AdminStatsModel value, $Res Function(_AdminStatsModel) _then) =
      __$AdminStatsModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int totalUsers,
      int activeUsers,
      int totalDevices,
      int activeSessions,
      int movieCount,
      int seriesCount,
      int episodeCount,
      int songCount,
      int bookCount});
}

/// @nodoc
class __$AdminStatsModelCopyWithImpl<$Res>
    implements _$AdminStatsModelCopyWith<$Res> {
  __$AdminStatsModelCopyWithImpl(this._self, this._then);

  final _AdminStatsModel _self;
  final $Res Function(_AdminStatsModel) _then;

  /// Create a copy of AdminStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? totalUsers = null,
    Object? activeUsers = null,
    Object? totalDevices = null,
    Object? activeSessions = null,
    Object? movieCount = null,
    Object? seriesCount = null,
    Object? episodeCount = null,
    Object? songCount = null,
    Object? bookCount = null,
  }) {
    return _then(_AdminStatsModel(
      totalUsers: null == totalUsers
          ? _self.totalUsers
          : totalUsers // ignore: cast_nullable_to_non_nullable
              as int,
      activeUsers: null == activeUsers
          ? _self.activeUsers
          : activeUsers // ignore: cast_nullable_to_non_nullable
              as int,
      totalDevices: null == totalDevices
          ? _self.totalDevices
          : totalDevices // ignore: cast_nullable_to_non_nullable
              as int,
      activeSessions: null == activeSessions
          ? _self.activeSessions
          : activeSessions // ignore: cast_nullable_to_non_nullable
              as int,
      movieCount: null == movieCount
          ? _self.movieCount
          : movieCount // ignore: cast_nullable_to_non_nullable
              as int,
      seriesCount: null == seriesCount
          ? _self.seriesCount
          : seriesCount // ignore: cast_nullable_to_non_nullable
              as int,
      episodeCount: null == episodeCount
          ? _self.episodeCount
          : episodeCount // ignore: cast_nullable_to_non_nullable
              as int,
      songCount: null == songCount
          ? _self.songCount
          : songCount // ignore: cast_nullable_to_non_nullable
              as int,
      bookCount: null == bookCount
          ? _self.bookCount
          : bookCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
mixin _$ActivityLogFilter {
  DateTime? get minDate;
  bool? get hasUserId;
  String? get name;
  String? get type;
  String? get username;
  int get startIndex;
  int get limit;

  /// Create a copy of ActivityLogFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ActivityLogFilterCopyWith<ActivityLogFilter> get copyWith =>
      _$ActivityLogFilterCopyWithImpl<ActivityLogFilter>(
          this as ActivityLogFilter, _$identity);

  /// Serializes this ActivityLogFilter to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ActivityLogFilter &&
            (identical(other.minDate, minDate) || other.minDate == minDate) &&
            (identical(other.hasUserId, hasUserId) ||
                other.hasUserId == hasUserId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.startIndex, startIndex) ||
                other.startIndex == startIndex) &&
            (identical(other.limit, limit) || other.limit == limit));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, minDate, hasUserId, name, type, username, startIndex, limit);

  @override
  String toString() {
    return 'ActivityLogFilter(minDate: $minDate, hasUserId: $hasUserId, name: $name, type: $type, username: $username, startIndex: $startIndex, limit: $limit)';
  }
}

/// @nodoc
abstract mixin class $ActivityLogFilterCopyWith<$Res> {
  factory $ActivityLogFilterCopyWith(
          ActivityLogFilter value, $Res Function(ActivityLogFilter) _then) =
      _$ActivityLogFilterCopyWithImpl;
  @useResult
  $Res call(
      {DateTime? minDate,
      bool? hasUserId,
      String? name,
      String? type,
      String? username,
      int startIndex,
      int limit});
}

/// @nodoc
class _$ActivityLogFilterCopyWithImpl<$Res>
    implements $ActivityLogFilterCopyWith<$Res> {
  _$ActivityLogFilterCopyWithImpl(this._self, this._then);

  final ActivityLogFilter _self;
  final $Res Function(ActivityLogFilter) _then;

  /// Create a copy of ActivityLogFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? minDate = freezed,
    Object? hasUserId = freezed,
    Object? name = freezed,
    Object? type = freezed,
    Object? username = freezed,
    Object? startIndex = null,
    Object? limit = null,
  }) {
    return _then(_self.copyWith(
      minDate: freezed == minDate
          ? _self.minDate
          : minDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      hasUserId: freezed == hasUserId
          ? _self.hasUserId
          : hasUserId // ignore: cast_nullable_to_non_nullable
              as bool?,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      username: freezed == username
          ? _self.username
          : username // ignore: cast_nullable_to_non_nullable
              as String?,
      startIndex: null == startIndex
          ? _self.startIndex
          : startIndex // ignore: cast_nullable_to_non_nullable
              as int,
      limit: null == limit
          ? _self.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [ActivityLogFilter].
extension ActivityLogFilterPatterns on ActivityLogFilter {
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
    TResult Function(_ActivityLogFilter value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ActivityLogFilter() when $default != null:
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
    TResult Function(_ActivityLogFilter value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ActivityLogFilter():
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
    TResult? Function(_ActivityLogFilter value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ActivityLogFilter() when $default != null:
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
    TResult Function(DateTime? minDate, bool? hasUserId, String? name,
            String? type, String? username, int startIndex, int limit)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ActivityLogFilter() when $default != null:
        return $default(_that.minDate, _that.hasUserId, _that.name, _that.type,
            _that.username, _that.startIndex, _that.limit);
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
    TResult Function(DateTime? minDate, bool? hasUserId, String? name,
            String? type, String? username, int startIndex, int limit)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ActivityLogFilter():
        return $default(_that.minDate, _that.hasUserId, _that.name, _that.type,
            _that.username, _that.startIndex, _that.limit);
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
    TResult? Function(DateTime? minDate, bool? hasUserId, String? name,
            String? type, String? username, int startIndex, int limit)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ActivityLogFilter() when $default != null:
        return $default(_that.minDate, _that.hasUserId, _that.name, _that.type,
            _that.username, _that.startIndex, _that.limit);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ActivityLogFilter implements ActivityLogFilter {
  const _ActivityLogFilter(
      {this.minDate,
      this.hasUserId,
      this.name,
      this.type,
      this.username,
      this.startIndex = 0,
      this.limit = 50});
  factory _ActivityLogFilter.fromJson(Map<String, dynamic> json) =>
      _$ActivityLogFilterFromJson(json);

  @override
  final DateTime? minDate;
  @override
  final bool? hasUserId;
  @override
  final String? name;
  @override
  final String? type;
  @override
  final String? username;
  @override
  @JsonKey()
  final int startIndex;
  @override
  @JsonKey()
  final int limit;

  /// Create a copy of ActivityLogFilter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ActivityLogFilterCopyWith<_ActivityLogFilter> get copyWith =>
      __$ActivityLogFilterCopyWithImpl<_ActivityLogFilter>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ActivityLogFilterToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ActivityLogFilter &&
            (identical(other.minDate, minDate) || other.minDate == minDate) &&
            (identical(other.hasUserId, hasUserId) ||
                other.hasUserId == hasUserId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.startIndex, startIndex) ||
                other.startIndex == startIndex) &&
            (identical(other.limit, limit) || other.limit == limit));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, minDate, hasUserId, name, type, username, startIndex, limit);

  @override
  String toString() {
    return 'ActivityLogFilter(minDate: $minDate, hasUserId: $hasUserId, name: $name, type: $type, username: $username, startIndex: $startIndex, limit: $limit)';
  }
}

/// @nodoc
abstract mixin class _$ActivityLogFilterCopyWith<$Res>
    implements $ActivityLogFilterCopyWith<$Res> {
  factory _$ActivityLogFilterCopyWith(
          _ActivityLogFilter value, $Res Function(_ActivityLogFilter) _then) =
      __$ActivityLogFilterCopyWithImpl;
  @override
  @useResult
  $Res call(
      {DateTime? minDate,
      bool? hasUserId,
      String? name,
      String? type,
      String? username,
      int startIndex,
      int limit});
}

/// @nodoc
class __$ActivityLogFilterCopyWithImpl<$Res>
    implements _$ActivityLogFilterCopyWith<$Res> {
  __$ActivityLogFilterCopyWithImpl(this._self, this._then);

  final _ActivityLogFilter _self;
  final $Res Function(_ActivityLogFilter) _then;

  /// Create a copy of ActivityLogFilter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? minDate = freezed,
    Object? hasUserId = freezed,
    Object? name = freezed,
    Object? type = freezed,
    Object? username = freezed,
    Object? startIndex = null,
    Object? limit = null,
  }) {
    return _then(_ActivityLogFilter(
      minDate: freezed == minDate
          ? _self.minDate
          : minDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      hasUserId: freezed == hasUserId
          ? _self.hasUserId
          : hasUserId // ignore: cast_nullable_to_non_nullable
              as bool?,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      username: freezed == username
          ? _self.username
          : username // ignore: cast_nullable_to_non_nullable
              as String?,
      startIndex: null == startIndex
          ? _self.startIndex
          : startIndex // ignore: cast_nullable_to_non_nullable
              as int,
      limit: null == limit
          ? _self.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
mixin _$UserFilter {
  bool? get isHidden;
  bool? get isDisabled;
  String? get searchQuery;

  /// Create a copy of UserFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserFilterCopyWith<UserFilter> get copyWith =>
      _$UserFilterCopyWithImpl<UserFilter>(this as UserFilter, _$identity);

  /// Serializes this UserFilter to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserFilter &&
            (identical(other.isHidden, isHidden) ||
                other.isHidden == isHidden) &&
            (identical(other.isDisabled, isDisabled) ||
                other.isDisabled == isDisabled) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, isHidden, isDisabled, searchQuery);

  @override
  String toString() {
    return 'UserFilter(isHidden: $isHidden, isDisabled: $isDisabled, searchQuery: $searchQuery)';
  }
}

/// @nodoc
abstract mixin class $UserFilterCopyWith<$Res> {
  factory $UserFilterCopyWith(
          UserFilter value, $Res Function(UserFilter) _then) =
      _$UserFilterCopyWithImpl;
  @useResult
  $Res call({bool? isHidden, bool? isDisabled, String? searchQuery});
}

/// @nodoc
class _$UserFilterCopyWithImpl<$Res> implements $UserFilterCopyWith<$Res> {
  _$UserFilterCopyWithImpl(this._self, this._then);

  final UserFilter _self;
  final $Res Function(UserFilter) _then;

  /// Create a copy of UserFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isHidden = freezed,
    Object? isDisabled = freezed,
    Object? searchQuery = freezed,
  }) {
    return _then(_self.copyWith(
      isHidden: freezed == isHidden
          ? _self.isHidden
          : isHidden // ignore: cast_nullable_to_non_nullable
              as bool?,
      isDisabled: freezed == isDisabled
          ? _self.isDisabled
          : isDisabled // ignore: cast_nullable_to_non_nullable
              as bool?,
      searchQuery: freezed == searchQuery
          ? _self.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [UserFilter].
extension UserFilterPatterns on UserFilter {
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
    TResult Function(_UserFilter value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UserFilter() when $default != null:
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
    TResult Function(_UserFilter value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserFilter():
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
    TResult? Function(_UserFilter value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserFilter() when $default != null:
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
    TResult Function(bool? isHidden, bool? isDisabled, String? searchQuery)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UserFilter() when $default != null:
        return $default(_that.isHidden, _that.isDisabled, _that.searchQuery);
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
    TResult Function(bool? isHidden, bool? isDisabled, String? searchQuery)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserFilter():
        return $default(_that.isHidden, _that.isDisabled, _that.searchQuery);
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
    TResult? Function(bool? isHidden, bool? isDisabled, String? searchQuery)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserFilter() when $default != null:
        return $default(_that.isHidden, _that.isDisabled, _that.searchQuery);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _UserFilter implements UserFilter {
  const _UserFilter({this.isHidden, this.isDisabled, this.searchQuery});
  factory _UserFilter.fromJson(Map<String, dynamic> json) =>
      _$UserFilterFromJson(json);

  @override
  final bool? isHidden;
  @override
  final bool? isDisabled;
  @override
  final String? searchQuery;

  /// Create a copy of UserFilter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$UserFilterCopyWith<_UserFilter> get copyWith =>
      __$UserFilterCopyWithImpl<_UserFilter>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$UserFilterToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UserFilter &&
            (identical(other.isHidden, isHidden) ||
                other.isHidden == isHidden) &&
            (identical(other.isDisabled, isDisabled) ||
                other.isDisabled == isDisabled) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, isHidden, isDisabled, searchQuery);

  @override
  String toString() {
    return 'UserFilter(isHidden: $isHidden, isDisabled: $isDisabled, searchQuery: $searchQuery)';
  }
}

/// @nodoc
abstract mixin class _$UserFilterCopyWith<$Res>
    implements $UserFilterCopyWith<$Res> {
  factory _$UserFilterCopyWith(
          _UserFilter value, $Res Function(_UserFilter) _then) =
      __$UserFilterCopyWithImpl;
  @override
  @useResult
  $Res call({bool? isHidden, bool? isDisabled, String? searchQuery});
}

/// @nodoc
class __$UserFilterCopyWithImpl<$Res> implements _$UserFilterCopyWith<$Res> {
  __$UserFilterCopyWithImpl(this._self, this._then);

  final _UserFilter _self;
  final $Res Function(_UserFilter) _then;

  /// Create a copy of UserFilter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? isHidden = freezed,
    Object? isDisabled = freezed,
    Object? searchQuery = freezed,
  }) {
    return _then(_UserFilter(
      isHidden: freezed == isHidden
          ? _self.isHidden
          : isHidden // ignore: cast_nullable_to_non_nullable
              as bool?,
      isDisabled: freezed == isDisabled
          ? _self.isDisabled
          : isDisabled // ignore: cast_nullable_to_non_nullable
              as bool?,
      searchQuery: freezed == searchQuery
          ? _self.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$SessionFilter {
  String? get deviceId;
  int? get activeWithinSeconds;

  /// Create a copy of SessionFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SessionFilterCopyWith<SessionFilter> get copyWith =>
      _$SessionFilterCopyWithImpl<SessionFilter>(
          this as SessionFilter, _$identity);

  /// Serializes this SessionFilter to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SessionFilter &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId) &&
            (identical(other.activeWithinSeconds, activeWithinSeconds) ||
                other.activeWithinSeconds == activeWithinSeconds));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, deviceId, activeWithinSeconds);

  @override
  String toString() {
    return 'SessionFilter(deviceId: $deviceId, activeWithinSeconds: $activeWithinSeconds)';
  }
}

/// @nodoc
abstract mixin class $SessionFilterCopyWith<$Res> {
  factory $SessionFilterCopyWith(
          SessionFilter value, $Res Function(SessionFilter) _then) =
      _$SessionFilterCopyWithImpl;
  @useResult
  $Res call({String? deviceId, int? activeWithinSeconds});
}

/// @nodoc
class _$SessionFilterCopyWithImpl<$Res>
    implements $SessionFilterCopyWith<$Res> {
  _$SessionFilterCopyWithImpl(this._self, this._then);

  final SessionFilter _self;
  final $Res Function(SessionFilter) _then;

  /// Create a copy of SessionFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? deviceId = freezed,
    Object? activeWithinSeconds = freezed,
  }) {
    return _then(_self.copyWith(
      deviceId: freezed == deviceId
          ? _self.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String?,
      activeWithinSeconds: freezed == activeWithinSeconds
          ? _self.activeWithinSeconds
          : activeWithinSeconds // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// Adds pattern-matching-related methods to [SessionFilter].
extension SessionFilterPatterns on SessionFilter {
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
    TResult Function(_SessionFilter value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SessionFilter() when $default != null:
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
    TResult Function(_SessionFilter value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SessionFilter():
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
    TResult? Function(_SessionFilter value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SessionFilter() when $default != null:
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
    TResult Function(String? deviceId, int? activeWithinSeconds)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SessionFilter() when $default != null:
        return $default(_that.deviceId, _that.activeWithinSeconds);
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
    TResult Function(String? deviceId, int? activeWithinSeconds) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SessionFilter():
        return $default(_that.deviceId, _that.activeWithinSeconds);
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
    TResult? Function(String? deviceId, int? activeWithinSeconds)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SessionFilter() when $default != null:
        return $default(_that.deviceId, _that.activeWithinSeconds);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _SessionFilter implements SessionFilter {
  const _SessionFilter({this.deviceId, this.activeWithinSeconds});
  factory _SessionFilter.fromJson(Map<String, dynamic> json) =>
      _$SessionFilterFromJson(json);

  @override
  final String? deviceId;
  @override
  final int? activeWithinSeconds;

  /// Create a copy of SessionFilter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SessionFilterCopyWith<_SessionFilter> get copyWith =>
      __$SessionFilterCopyWithImpl<_SessionFilter>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SessionFilterToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SessionFilter &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId) &&
            (identical(other.activeWithinSeconds, activeWithinSeconds) ||
                other.activeWithinSeconds == activeWithinSeconds));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, deviceId, activeWithinSeconds);

  @override
  String toString() {
    return 'SessionFilter(deviceId: $deviceId, activeWithinSeconds: $activeWithinSeconds)';
  }
}

/// @nodoc
abstract mixin class _$SessionFilterCopyWith<$Res>
    implements $SessionFilterCopyWith<$Res> {
  factory _$SessionFilterCopyWith(
          _SessionFilter value, $Res Function(_SessionFilter) _then) =
      __$SessionFilterCopyWithImpl;
  @override
  @useResult
  $Res call({String? deviceId, int? activeWithinSeconds});
}

/// @nodoc
class __$SessionFilterCopyWithImpl<$Res>
    implements _$SessionFilterCopyWith<$Res> {
  __$SessionFilterCopyWithImpl(this._self, this._then);

  final _SessionFilter _self;
  final $Res Function(_SessionFilter) _then;

  /// Create a copy of SessionFilter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? deviceId = freezed,
    Object? activeWithinSeconds = freezed,
  }) {
    return _then(_SessionFilter(
      deviceId: freezed == deviceId
          ? _self.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String?,
      activeWithinSeconds: freezed == activeWithinSeconds
          ? _self.activeWithinSeconds
          : activeWithinSeconds // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
mixin _$TaskFilter {
  bool? get isHidden;
  bool? get isEnabled;
  String? get searchQuery;

  /// Create a copy of TaskFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TaskFilterCopyWith<TaskFilter> get copyWith =>
      _$TaskFilterCopyWithImpl<TaskFilter>(this as TaskFilter, _$identity);

  /// Serializes this TaskFilter to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TaskFilter &&
            (identical(other.isHidden, isHidden) ||
                other.isHidden == isHidden) &&
            (identical(other.isEnabled, isEnabled) ||
                other.isEnabled == isEnabled) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, isHidden, isEnabled, searchQuery);

  @override
  String toString() {
    return 'TaskFilter(isHidden: $isHidden, isEnabled: $isEnabled, searchQuery: $searchQuery)';
  }
}

/// @nodoc
abstract mixin class $TaskFilterCopyWith<$Res> {
  factory $TaskFilterCopyWith(
          TaskFilter value, $Res Function(TaskFilter) _then) =
      _$TaskFilterCopyWithImpl;
  @useResult
  $Res call({bool? isHidden, bool? isEnabled, String? searchQuery});
}

/// @nodoc
class _$TaskFilterCopyWithImpl<$Res> implements $TaskFilterCopyWith<$Res> {
  _$TaskFilterCopyWithImpl(this._self, this._then);

  final TaskFilter _self;
  final $Res Function(TaskFilter) _then;

  /// Create a copy of TaskFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isHidden = freezed,
    Object? isEnabled = freezed,
    Object? searchQuery = freezed,
  }) {
    return _then(_self.copyWith(
      isHidden: freezed == isHidden
          ? _self.isHidden
          : isHidden // ignore: cast_nullable_to_non_nullable
              as bool?,
      isEnabled: freezed == isEnabled
          ? _self.isEnabled
          : isEnabled // ignore: cast_nullable_to_non_nullable
              as bool?,
      searchQuery: freezed == searchQuery
          ? _self.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [TaskFilter].
extension TaskFilterPatterns on TaskFilter {
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
    TResult Function(_TaskFilter value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TaskFilter() when $default != null:
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
    TResult Function(_TaskFilter value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TaskFilter():
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
    TResult? Function(_TaskFilter value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TaskFilter() when $default != null:
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
    TResult Function(bool? isHidden, bool? isEnabled, String? searchQuery)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TaskFilter() when $default != null:
        return $default(_that.isHidden, _that.isEnabled, _that.searchQuery);
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
    TResult Function(bool? isHidden, bool? isEnabled, String? searchQuery)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TaskFilter():
        return $default(_that.isHidden, _that.isEnabled, _that.searchQuery);
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
    TResult? Function(bool? isHidden, bool? isEnabled, String? searchQuery)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TaskFilter() when $default != null:
        return $default(_that.isHidden, _that.isEnabled, _that.searchQuery);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _TaskFilter implements TaskFilter {
  const _TaskFilter({this.isHidden, this.isEnabled, this.searchQuery});
  factory _TaskFilter.fromJson(Map<String, dynamic> json) =>
      _$TaskFilterFromJson(json);

  @override
  final bool? isHidden;
  @override
  final bool? isEnabled;
  @override
  final String? searchQuery;

  /// Create a copy of TaskFilter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TaskFilterCopyWith<_TaskFilter> get copyWith =>
      __$TaskFilterCopyWithImpl<_TaskFilter>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TaskFilterToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TaskFilter &&
            (identical(other.isHidden, isHidden) ||
                other.isHidden == isHidden) &&
            (identical(other.isEnabled, isEnabled) ||
                other.isEnabled == isEnabled) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, isHidden, isEnabled, searchQuery);

  @override
  String toString() {
    return 'TaskFilter(isHidden: $isHidden, isEnabled: $isEnabled, searchQuery: $searchQuery)';
  }
}

/// @nodoc
abstract mixin class _$TaskFilterCopyWith<$Res>
    implements $TaskFilterCopyWith<$Res> {
  factory _$TaskFilterCopyWith(
          _TaskFilter value, $Res Function(_TaskFilter) _then) =
      __$TaskFilterCopyWithImpl;
  @override
  @useResult
  $Res call({bool? isHidden, bool? isEnabled, String? searchQuery});
}

/// @nodoc
class __$TaskFilterCopyWithImpl<$Res> implements _$TaskFilterCopyWith<$Res> {
  __$TaskFilterCopyWithImpl(this._self, this._then);

  final _TaskFilter _self;
  final $Res Function(_TaskFilter) _then;

  /// Create a copy of TaskFilter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? isHidden = freezed,
    Object? isEnabled = freezed,
    Object? searchQuery = freezed,
  }) {
    return _then(_TaskFilter(
      isHidden: freezed == isHidden
          ? _self.isHidden
          : isHidden // ignore: cast_nullable_to_non_nullable
              as bool?,
      isEnabled: freezed == isEnabled
          ? _self.isEnabled
          : isEnabled // ignore: cast_nullable_to_non_nullable
              as bool?,
      searchQuery: freezed == searchQuery
          ? _self.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
