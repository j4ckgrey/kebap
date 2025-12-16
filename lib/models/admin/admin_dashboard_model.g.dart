// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_dashboard_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AdminDashboardModel _$AdminDashboardModelFromJson(Map<String, dynamic> json) =>
    _AdminDashboardModel(
      systemInfo: json['systemInfo'] == null
          ? null
          : SystemInfo.fromJson(json['systemInfo'] as Map<String, dynamic>),
      activeSessions: (json['activeSessions'] as List<dynamic>?)
              ?.map((e) => SessionInfoDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      recentActivity: (json['recentActivity'] as List<dynamic>?)
              ?.map((e) => ActivityLogEntry.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      runningTasks: (json['runningTasks'] as List<dynamic>?)
              ?.map((e) => TaskInfo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      userCount: (json['userCount'] as num?)?.toInt() ?? 0,
      deviceCount: (json['deviceCount'] as num?)?.toInt() ?? 0,
      isLoading: json['isLoading'] as bool? ?? false,
      error: json['error'] as String?,
    );

Map<String, dynamic> _$AdminDashboardModelToJson(
        _AdminDashboardModel instance) =>
    <String, dynamic>{
      'systemInfo': instance.systemInfo,
      'activeSessions': instance.activeSessions,
      'recentActivity': instance.recentActivity,
      'runningTasks': instance.runningTasks,
      'userCount': instance.userCount,
      'deviceCount': instance.deviceCount,
      'isLoading': instance.isLoading,
      'error': instance.error,
    };

_AdminStatsModel _$AdminStatsModelFromJson(Map<String, dynamic> json) =>
    _AdminStatsModel(
      totalUsers: (json['totalUsers'] as num?)?.toInt() ?? 0,
      activeUsers: (json['activeUsers'] as num?)?.toInt() ?? 0,
      totalDevices: (json['totalDevices'] as num?)?.toInt() ?? 0,
      activeSessions: (json['activeSessions'] as num?)?.toInt() ?? 0,
      movieCount: (json['movieCount'] as num?)?.toInt() ?? 0,
      seriesCount: (json['seriesCount'] as num?)?.toInt() ?? 0,
      episodeCount: (json['episodeCount'] as num?)?.toInt() ?? 0,
      songCount: (json['songCount'] as num?)?.toInt() ?? 0,
      bookCount: (json['bookCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$AdminStatsModelToJson(_AdminStatsModel instance) =>
    <String, dynamic>{
      'totalUsers': instance.totalUsers,
      'activeUsers': instance.activeUsers,
      'totalDevices': instance.totalDevices,
      'activeSessions': instance.activeSessions,
      'movieCount': instance.movieCount,
      'seriesCount': instance.seriesCount,
      'episodeCount': instance.episodeCount,
      'songCount': instance.songCount,
      'bookCount': instance.bookCount,
    };

_ActivityLogFilter _$ActivityLogFilterFromJson(Map<String, dynamic> json) =>
    _ActivityLogFilter(
      minDate: json['minDate'] == null
          ? null
          : DateTime.parse(json['minDate'] as String),
      hasUserId: json['hasUserId'] as bool?,
      name: json['name'] as String?,
      type: json['type'] as String?,
      username: json['username'] as String?,
      startIndex: (json['startIndex'] as num?)?.toInt() ?? 0,
      limit: (json['limit'] as num?)?.toInt() ?? 50,
    );

Map<String, dynamic> _$ActivityLogFilterToJson(_ActivityLogFilter instance) =>
    <String, dynamic>{
      'minDate': instance.minDate?.toIso8601String(),
      'hasUserId': instance.hasUserId,
      'name': instance.name,
      'type': instance.type,
      'username': instance.username,
      'startIndex': instance.startIndex,
      'limit': instance.limit,
    };

_UserFilter _$UserFilterFromJson(Map<String, dynamic> json) => _UserFilter(
      isHidden: json['isHidden'] as bool?,
      isDisabled: json['isDisabled'] as bool?,
      searchQuery: json['searchQuery'] as String?,
    );

Map<String, dynamic> _$UserFilterToJson(_UserFilter instance) =>
    <String, dynamic>{
      'isHidden': instance.isHidden,
      'isDisabled': instance.isDisabled,
      'searchQuery': instance.searchQuery,
    };

_SessionFilter _$SessionFilterFromJson(Map<String, dynamic> json) =>
    _SessionFilter(
      deviceId: json['deviceId'] as String?,
      activeWithinSeconds: (json['activeWithinSeconds'] as num?)?.toInt(),
    );

Map<String, dynamic> _$SessionFilterToJson(_SessionFilter instance) =>
    <String, dynamic>{
      'deviceId': instance.deviceId,
      'activeWithinSeconds': instance.activeWithinSeconds,
    };

_TaskFilter _$TaskFilterFromJson(Map<String, dynamic> json) => _TaskFilter(
      isHidden: json['isHidden'] as bool?,
      isEnabled: json['isEnabled'] as bool?,
      searchQuery: json['searchQuery'] as String?,
    );

Map<String, dynamic> _$TaskFilterToJson(_TaskFilter instance) =>
    <String, dynamic>{
      'isHidden': instance.isHidden,
      'isEnabled': instance.isEnabled,
      'searchQuery': instance.searchQuery,
    };
