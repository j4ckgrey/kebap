import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:kebap/jellyfin/jellyfin_open_api.swagger.dart';
import 'package:kebap/models/admin/admin_dashboard_model.dart';
import 'package:kebap/providers/admin_provider.dart';

part 'admin_dashboard_provider.g.dart';

/// Provider for the main admin dashboard data
@riverpod
class AdminDashboard extends _$AdminDashboard {
  @override
  Future<AdminDashboardModel> build() async {
    return await _loadDashboardData();
  }

  Future<AdminDashboardModel> _loadDashboardData() async {
    try {
      final adminService = ref.read(adminServiceProvider.notifier);

      // Fetch all dashboard data in parallel
      final results = await Future.wait([
        adminService.getSystemInfo(),
        adminService.getSessions(activeWithinSeconds: 600), // Active in last 10 min
        adminService.getActivityLog(limit: 10),
        adminService.getScheduledTasks(),
        adminService.getUsers(),
        adminService.getDevices(),
      ]);

      final systemInfo = results[0].body as SystemInfo?;
      final sessions = (results[1].body as List<SessionInfoDto>?) ?? [];
      final activity = (results[2].body as ActivityLogEntryQueryResult?)?.items ?? [];
      final tasks = (results[3].body as List<TaskInfo>?) ?? [];
      final users = (results[4].body as List<UserDto>?) ?? [];
      final devices = (results[5].body as DeviceInfoDtoQueryResult?)?.items ?? [];

      // Filter running tasks
      final runningTasks = tasks.where((t) => t.state == TaskState.running).toList();

      return AdminDashboardModel(
        systemInfo: systemInfo,
        activeSessions: sessions,
        recentActivity: activity,
        runningTasks: runningTasks,
        userCount: users.length,
        deviceCount: devices.length,
        isLoading: false,
      );
    } catch (e) {
      return AdminDashboardModel(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async => await _loadDashboardData());
  }
}

/// Provider for activity log with filtering
@riverpod
class ActivityLog extends _$ActivityLog {
  ActivityLogFilter _filter = const ActivityLogFilter();

  @override
  Future<ActivityLogEntryQueryResult> build() async {
    return await _loadActivityLog();
  }

  Future<ActivityLogEntryQueryResult> _loadActivityLog() async {
    try {
      final adminService = ref.read(adminServiceProvider.notifier);
      final response = await adminService.getActivityLog(
        startIndex: _filter.startIndex,
        limit: _filter.limit,
        minDate: _filter.minDate,
        hasUserId: _filter.hasUserId,
      );

      return response.body ?? const ActivityLogEntryQueryResult();
    } catch (e) {
      return const ActivityLogEntryQueryResult();
    }
  }

  void updateFilter(ActivityLogFilter filter) {
    _filter = filter;
    refresh();
  }

  Future<void> loadMore() async {
    final currentState = state.valueOrNull;
    if (currentState == null) return;

    _filter = _filter.copyWith(
      startIndex: _filter.startIndex + _filter.limit,
    );

    final newData = await _loadActivityLog();
    final updatedItems = <ActivityLogEntry>[
      ...currentState.items ?? [],
      ...newData.items ?? [],
    ];

    state = AsyncValue.data(
      currentState.copyWith(items: updatedItems),
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async => await _loadActivityLog());
  }
}

/// Provider for users list with filtering
@riverpod
class UsersList extends _$UsersList {
  UserFilter _filter = const UserFilter();

  @override
  Future<List<UserDto>> build() async {
    return await _loadUsers();
  }

  Future<List<UserDto>> _loadUsers() async {
    try {
      final adminService = ref.read(adminServiceProvider.notifier);
      final response = await adminService.getUsers(
        isHidden: _filter.isHidden,
        isDisabled: _filter.isDisabled,
      );

      var users = response.body ?? [];

      // Apply search filter if provided
      if (_filter.searchQuery != null && _filter.searchQuery!.isNotEmpty) {
        final query = _filter.searchQuery!.toLowerCase();
        users = users
            .where((u) => u.name?.toLowerCase().contains(query) ?? false)
            .toList();
      }

      return users;
    } catch (e) {
      return [];
    }
  }

  void updateFilter(UserFilter filter) {
    _filter = filter;
    refresh();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async => await _loadUsers());
  }
}

/// Provider for active sessions with filtering
@riverpod
class SessionsList extends _$SessionsList {
  SessionFilter _filter = const SessionFilter();

  @override
  Future<List<SessionInfoDto>> build() async {
    return await _loadSessions();
  }

  Future<List<SessionInfoDto>> _loadSessions() async {
    try {
      final adminService = ref.read(adminServiceProvider.notifier);
      final response = await adminService.getSessions(
        deviceId: _filter.deviceId,
        activeWithinSeconds: _filter.activeWithinSeconds ?? 600,
      );

      return response.body ?? [];
    } catch (e) {
      return [];
    }
  }

  void updateFilter(SessionFilter filter) {
    _filter = filter;
    refresh();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async => await _loadSessions());
  }
}

/// Provider for scheduled tasks with filtering
@riverpod
class TasksList extends _$TasksList {
  TaskFilter _filter = const TaskFilter();

  @override
  Future<List<TaskInfo>> build() async {
    return await _loadTasks();
  }

  Future<List<TaskInfo>> _loadTasks() async {
    try {
      final adminService = ref.read(adminServiceProvider.notifier);
      final response = await adminService.getScheduledTasks(
        isHidden: _filter.isHidden,
        isEnabled: _filter.isEnabled,
      );

      var tasks = response.body ?? [];

      // Apply search filter if provided
      if (_filter.searchQuery != null && _filter.searchQuery!.isNotEmpty) {
        final query = _filter.searchQuery!.toLowerCase();
        tasks = tasks
            .where((t) => t.name?.toLowerCase().contains(query) ?? false)
            .toList();
      }

      return tasks;
    } catch (e) {
      return [];
    }
  }

  void updateFilter(TaskFilter filter) {
    _filter = filter;
    refresh();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async => await _loadTasks());
  }
}

/// Provider for system statistics
@riverpod
class SystemStats extends _$SystemStats {
  @override
  Future<AdminStatsModel> build() async {
    return await _loadStats();
  }

  Future<AdminStatsModel> _loadStats() async {
    try {
      final adminService = ref.read(adminServiceProvider.notifier);

      final results = await Future.wait([
        adminService.getUsers(),
        adminService.getDevices(),
        adminService.getSessions(activeWithinSeconds: 600),
      ]);

      final users = (results[0].body as List<UserDto>?) ?? [];
      final devices = (results[1].body as DeviceInfoDtoQueryResult?)?.items ?? [];
      final sessions = (results[2].body as List<SessionInfoDto>?) ?? [];

      // Count active users (users with sessions)
      final activeUserIds = sessions
          .map((s) => s.userId)
          .where((id) => id != null)
          .toSet();

      return AdminStatsModel(
        totalUsers: users.length,
        activeUsers: activeUserIds.length,
        totalDevices: devices.length,
        activeSessions: sessions.length,
      );
    } catch (e) {
      return const AdminStatsModel();
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async => await _loadStats());
  }
}

/// Provider for device list
@riverpod
class DevicesList extends _$DevicesList {
  @override
  Future<List<DeviceInfoDto>> build() async {
    return await _loadDevices();
  }

  Future<List<DeviceInfoDto>> _loadDevices() async {
    try {
      final adminService = ref.read(adminServiceProvider.notifier);
      final response = await adminService.getDevices();
      return response.body?.items ?? [];
    } catch (e) {
      return [];
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async => await _loadDevices());
  }
}

/// Provider for virtual folders (libraries)
@riverpod
class VirtualFoldersList extends _$VirtualFoldersList {
  @override
  Future<List<VirtualFolderInfo>> build() async {
    return await _loadVirtualFolders();
  }

  Future<List<VirtualFolderInfo>> _loadVirtualFolders() async {
    try {
      final adminService = ref.read(adminServiceProvider.notifier);
      final response = await adminService.getVirtualFolders();
      return response.body ?? [];
    } catch (e) {
      return [];
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async => await _loadVirtualFolders());
  }
}
