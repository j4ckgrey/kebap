import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kebap/jellyfin/jellyfin_open_api.swagger.dart';

part 'admin_dashboard_model.freezed.dart';
part 'admin_dashboard_model.g.dart';

/// Main admin dashboard model
@freezed
abstract class AdminDashboardModel with _$AdminDashboardModel {
  const factory AdminDashboardModel({
    SystemInfo? systemInfo,
    @Default([]) List<SessionInfoDto> activeSessions,
    @Default([]) List<ActivityLogEntry> recentActivity,
    @Default([]) List<TaskInfo> runningTasks,
    @Default(0) int userCount,
    @Default(0) int deviceCount,
    @Default(false) bool isLoading,
    String? error,
  }) = _AdminDashboardModel;

  factory AdminDashboardModel.fromJson(Map<String, dynamic> json) =>
      _$AdminDashboardModelFromJson(json);
}

/// Admin dashboard statistics
@freezed
abstract class AdminStatsModel with _$AdminStatsModel {
  const factory AdminStatsModel({
    @Default(0) int totalUsers,
    @Default(0) int activeUsers,
    @Default(0) int totalDevices,
    @Default(0) int activeSessions,
    @Default(0) int movieCount,
    @Default(0) int seriesCount,
    @Default(0) int episodeCount,
    @Default(0) int songCount,
    @Default(0) int bookCount,
  }) = _AdminStatsModel;

  factory AdminStatsModel.fromJson(Map<String, dynamic> json) =>
      _$AdminStatsModelFromJson(json);
}

/// Activity log filter options
@freezed
abstract class ActivityLogFilter with _$ActivityLogFilter {
  const factory ActivityLogFilter({
    DateTime? minDate,
    bool? hasUserId,
    String? name,
    String? type,
    String? username,
    @Default(0) int startIndex,
    @Default(50) int limit,
  }) = _ActivityLogFilter;

  factory ActivityLogFilter.fromJson(Map<String, dynamic> json) =>
      _$ActivityLogFilterFromJson(json);
}

/// User management filter
@freezed
abstract class UserFilter with _$UserFilter {
  const factory UserFilter({
    bool? isHidden,
    bool? isDisabled,
    String? searchQuery,
  }) = _UserFilter;

  factory UserFilter.fromJson(Map<String, dynamic> json) =>
      _$UserFilterFromJson(json);
}

/// Session management filter
@freezed
abstract class SessionFilter with _$SessionFilter {
  const factory SessionFilter({
    String? deviceId,
    int? activeWithinSeconds,
  }) = _SessionFilter;

  factory SessionFilter.fromJson(Map<String, dynamic> json) =>
      _$SessionFilterFromJson(json);
}

/// Task management filter
@freezed
abstract class TaskFilter with _$TaskFilter {
  const factory TaskFilter({
    bool? isHidden,
    bool? isEnabled,
    String? searchQuery,
  }) = _TaskFilter;

  factory TaskFilter.fromJson(Map<String, dynamic> json) =>
      _$TaskFilterFromJson(json);
}
