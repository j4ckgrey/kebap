// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_dashboard_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$adminDashboardHash() => r'3526e0aaac68e3fa45936b4eba0ffca917acb1da';

/// Provider for the main admin dashboard data
///
/// Copied from [AdminDashboard].
@ProviderFor(AdminDashboard)
final adminDashboardProvider = AutoDisposeAsyncNotifierProvider<AdminDashboard,
    AdminDashboardModel>.internal(
  AdminDashboard.new,
  name: r'adminDashboardProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$adminDashboardHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AdminDashboard = AutoDisposeAsyncNotifier<AdminDashboardModel>;
String _$activityLogHash() => r'576213d5fe6ec92b2b26346740b4f7859b93a684';

/// Provider for activity log with filtering
///
/// Copied from [ActivityLog].
@ProviderFor(ActivityLog)
final activityLogProvider = AutoDisposeAsyncNotifierProvider<ActivityLog,
    ActivityLogEntryQueryResult>.internal(
  ActivityLog.new,
  name: r'activityLogProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$activityLogHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ActivityLog = AutoDisposeAsyncNotifier<ActivityLogEntryQueryResult>;
String _$usersListHash() => r'484c8566e39922fd06679867c1314891f3268cfc';

/// Provider for users list with filtering
///
/// Copied from [UsersList].
@ProviderFor(UsersList)
final usersListProvider =
    AutoDisposeAsyncNotifierProvider<UsersList, List<UserDto>>.internal(
  UsersList.new,
  name: r'usersListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$usersListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$UsersList = AutoDisposeAsyncNotifier<List<UserDto>>;
String _$sessionsListHash() => r'21d0a988ed49bbbc0279fbf6676977b8bcd61197';

/// Provider for active sessions with filtering
///
/// Copied from [SessionsList].
@ProviderFor(SessionsList)
final sessionsListProvider = AutoDisposeAsyncNotifierProvider<SessionsList,
    List<SessionInfoDto>>.internal(
  SessionsList.new,
  name: r'sessionsListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$sessionsListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SessionsList = AutoDisposeAsyncNotifier<List<SessionInfoDto>>;
String _$tasksListHash() => r'9065bfcd6690c50e2f24f887db1089d7995ae781';

/// Provider for scheduled tasks with filtering
///
/// Copied from [TasksList].
@ProviderFor(TasksList)
final tasksListProvider =
    AutoDisposeAsyncNotifierProvider<TasksList, List<TaskInfo>>.internal(
  TasksList.new,
  name: r'tasksListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$tasksListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TasksList = AutoDisposeAsyncNotifier<List<TaskInfo>>;
String _$systemStatsHash() => r'79f73d0afb8dd924b96a654090cfe371aa4a26fa';

/// Provider for system statistics
///
/// Copied from [SystemStats].
@ProviderFor(SystemStats)
final systemStatsProvider =
    AutoDisposeAsyncNotifierProvider<SystemStats, AdminStatsModel>.internal(
  SystemStats.new,
  name: r'systemStatsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$systemStatsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SystemStats = AutoDisposeAsyncNotifier<AdminStatsModel>;
String _$devicesListHash() => r'4153c7aadc08ec93d451bc2bdf176f4e19cc2432';

/// Provider for device list
///
/// Copied from [DevicesList].
@ProviderFor(DevicesList)
final devicesListProvider =
    AutoDisposeAsyncNotifierProvider<DevicesList, List<DeviceInfoDto>>.internal(
  DevicesList.new,
  name: r'devicesListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$devicesListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DevicesList = AutoDisposeAsyncNotifier<List<DeviceInfoDto>>;
String _$virtualFoldersListHash() =>
    r'27ced4e665a87f8ec8ad2103188c52155eeadb72';

/// Provider for virtual folders (libraries)
///
/// Copied from [VirtualFoldersList].
@ProviderFor(VirtualFoldersList)
final virtualFoldersListProvider = AutoDisposeAsyncNotifierProvider<
    VirtualFoldersList, List<VirtualFolderInfo>>.internal(
  VirtualFoldersList.new,
  name: r'virtualFoldersListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$virtualFoldersListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$VirtualFoldersList
    = AutoDisposeAsyncNotifier<List<VirtualFolderInfo>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
