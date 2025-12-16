import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:kebap/jellyfin/jellyfin_open_api.swagger.dart';
import 'package:kebap/jellyfin/jellyfin_open_api.enums.swagger.dart' as enums;
import 'package:kebap/providers/api_provider.dart';

part 'admin_provider.g.dart';

/// Provider for admin-related API calls
@riverpod
class AdminService extends _$AdminService {
  late final JellyfinOpenApi _api;

  @override
  void build() {
    _api = ref.read(jellyApiProvider).api;
  }

  /// Get activity log entries
  /// Shows all server activities like user logins, item playback, library scans, etc.
  Future<Response<ActivityLogEntryQueryResult>> getActivityLog({
    int? startIndex,
    int? limit,
    DateTime? minDate,
    bool? hasUserId,
  }) async {
    return await _api.systemActivityLogEntriesGet(
      startIndex: startIndex,
      limit: limit,
      minDate: minDate,
      hasUserId: hasUserId,
    );
  }

  /// Get all users
  Future<Response<List<UserDto>>> getUsers({
    bool? isHidden,
    bool? isDisabled,
  }) async {
    return await _api.usersGet(
      isHidden: isHidden,
      isDisabled: isDisabled,
    );
  }

  /// Get user by ID
  Future<Response<UserDto>> getUserById(String userId) async {
    return await _api.usersUserIdGet(userId: userId);
  }

  /// Create new user
  Future<Response<UserDto>> createUser({
    required String name,
    String? password,
  }) async {
    final newUser = CreateUserByName(name: name, password: password);
    return await _api.usersNewPost(body: newUser);
  }

  /// Update user
  Future<Response<dynamic>> updateUser({
    required String userId,
    required UserDto user,
  }) async {
    return await _api.usersPost(userId: userId, body: user);
  }

  /// Delete user
  Future<Response<dynamic>> deleteUser(String userId) async {
    return await _api.usersUserIdDelete(userId: userId);
  }

  /// Update user password
  Future<Response<dynamic>> updateUserPassword({
    required String userId,
    String? currentPassword,
    required String newPassword,
    bool resetPassword = false,
  }) async {
    final updatePassword = UpdateUserPassword(
      currentPassword: currentPassword,
      currentPw: currentPassword,
      newPw: newPassword,
      resetPassword: resetPassword,
    );
    return await _api.usersPasswordPost(userId: userId, body: updatePassword);
  }

  /// Update user policy (permissions)
  Future<Response<dynamic>> updateUserPolicy({
    required String userId,
    required UserPolicy policy,
  }) async {
    return await _api.usersUserIdPolicyPost(
      userId: userId,
      body: policy,
    );
  }

  /// Get all active sessions
  Future<Response<List<SessionInfoDto>>> getSessions({
    String? controllableByUserId,
    String? deviceId,
    int? activeWithinSeconds,
  }) async {
    return await _api.sessionsGet(
      controllableByUserId: controllableByUserId,
      deviceId: deviceId,
      activeWithinSeconds: activeWithinSeconds,
    );
  }

  /// Send message to session
  Future<Response<dynamic>> sendMessageToSession({
    required String sessionId,
    required String header,
    required String text,
    int? timeoutMs,
  }) async {
    return await _api.sessionsSessionIdMessagePost(
      sessionId: sessionId,
      body: MessageCommand(
        header: header,
        text: text,
        timeoutMs: timeoutMs?.toInt(),
      ),
    );
  }

  /// Logout current session (note: Jellyfin API logs out the current authenticated session)
  Future<Response<dynamic>> logoutSession() async {
    return await _api.sessionsLogoutPost();
  }

  /// Get all scheduled tasks
  Future<Response<List<TaskInfo>>> getScheduledTasks({
    bool? isHidden,
    bool? isEnabled,
  }) async {
    return await _api.scheduledTasksGet(
      isHidden: isHidden,
      isEnabled: isEnabled,
    );
  }

  /// Get task by ID
  Future<Response<TaskInfo>> getTaskById(String taskId) async {
    return await _api.scheduledTasksTaskIdGet(taskId: taskId);
  }

  /// Start task
  Future<Response<dynamic>> startTask(String taskId) async {
    return await _api.scheduledTasksRunningTaskIdPost(taskId: taskId);
  }

  /// Stop task
  Future<Response<dynamic>> stopTask(String taskId) async {
    return await _api.scheduledTasksRunningTaskIdDelete(taskId: taskId);
  }

  /// Update task triggers
  Future<Response<dynamic>> updateTaskTriggers({
    required String taskId,
    required List<TaskTriggerInfo> triggers,
  }) async {
    return await _api.scheduledTasksTaskIdTriggersPost(
      taskId: taskId,
      body: triggers,
    );
  }

  /// Get system information
  Future<Response<SystemInfo>> getSystemInfo() async {
    return await _api.systemInfoGet();
  }

  /// Get server configuration
  Future<Response<ServerConfiguration>> getServerConfiguration() async {
    return await _api.systemConfigurationGet();
  }

  /// Update server configuration
  Future<Response<dynamic>> updateServerConfiguration(
    ServerConfiguration config,
  ) async {
    return await _api.systemConfigurationPost(body: config);
  }

  /// Get all devices
  Future<Response<DeviceInfoDtoQueryResult>> getDevices({
    String? userId,
  }) async {
    return await _api.devicesGet(userId: userId);
  }

  /// Delete device
  Future<Response<dynamic>> deleteDevice(String deviceId) async {
    return await _api.devicesDelete(id: deviceId);
  }

  // Note: DeviceOptions type doesn't exist in API
  // Removed getDeviceOptions and updateDeviceOptions methods

  /// Get server logs
  Future<Response<List<LogFile>>> getServerLogs() async {
    return await _api.systemLogsGet();
  }

  /// Get log file contents
  Future<Response<String>> getLogFile(String name) async {
    return await _api.systemLogsLogGet(name: name);
  }

  /// Restart server
  Future<Response<dynamic>> restartServer() async {
    return await _api.systemRestartPost();
  }

  /// Shutdown server
  Future<Response<dynamic>> shutdownServer() async {
    return await _api.systemShutdownPost();
  }

  /// Get installed plugins
  Future<Response<List<PluginInfo>>> getPlugins() async {
    return await _api.pluginsGet();
  }

  /// Uninstall plugin
  Future<Response<dynamic>> uninstallPlugin(String pluginId) async {
    return await _api.pluginsPluginIdDelete(pluginId: pluginId);
  }

  /// Get plugin configuration
  Future<Response<BasePluginConfiguration>> getPluginConfiguration(
    String pluginId,
  ) async {
    return await _api.pluginsPluginIdConfigurationGet(pluginId: pluginId);
  }

  /// Get library options
  Future<Response<LibraryOptionsResultDto>> getLibraryOptions({
    enums.LibrariesAvailableOptionsGetLibraryContentType? libraryContentType,
    bool? isNewLibrary,
  }) async {
    return await _api.librariesAvailableOptionsGet(
      libraryContentType: libraryContentType,
      isNewLibrary: isNewLibrary,
    );
  }

  /// Add virtual folder (library)
  Future<Response<dynamic>> addVirtualFolder({
    required String name,
    required enums.LibraryVirtualFoldersPostCollectionType collectionType,
    required List<String> paths,
    bool? refreshLibrary,
  }) async {
    return await _api.libraryVirtualFoldersPost(
      body: AddVirtualFolderDto(
        libraryOptions: LibraryOptions(
          pathInfos: paths.map((p) => MediaPathInfo(path: p)).toList(),
        ),
      ),
      name: name,
      collectionType: collectionType,
      refreshLibrary: refreshLibrary,
    );
  }

  /// Remove virtual folder (library)
  Future<Response<dynamic>> removeVirtualFolder({
    required String name,
    bool? refreshLibrary,
  }) async {
    return await _api.libraryVirtualFoldersDelete(
      name: name,
      refreshLibrary: refreshLibrary,
    );
  }

  /// Get virtual folders (libraries)
  Future<Response<List<VirtualFolderInfo>>> getVirtualFolders() async {
    return await _api.libraryVirtualFoldersGet();
  }

  /// Scan library
  Future<Response<dynamic>> scanLibrary() async {
    return await _api.libraryRefreshPost();
  }

  /// Get API keys
  Future<Response<AuthenticationInfoQueryResult>> getApiKeys() async {
    return await _api.authKeysGet();
  }

  /// Create API key
  Future<Response<dynamic>> createApiKey(String appName) async {
    return await _api.authKeysPost(app: appName);
  }

  /// Delete API key
  Future<Response<dynamic>> deleteApiKey(String key) async {
    return await _api.authKeysKeyDelete(key: key);
  }
}
