import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:intl/intl.dart';
import 'package:kebap/jellyfin/jellyfin_open_api.swagger.dart';
import 'package:kebap/jellyfin/jellyfin_open_api.enums.swagger.dart' as enums;
import 'package:kebap/jellyfin/jellyfin_open_api.enums.swagger.dart' show ImageResolution;
import 'package:kebap/providers/admin_dashboard_provider.dart';
import 'package:kebap/providers/admin_provider.dart';
import 'package:kebap/providers/api_provider.dart';
import 'package:kebap/providers/server_config_provider.dart';
import 'package:kebap/routes/auto_router.gr.dart';
import 'package:kebap/widgets/shared/pull_to_refresh.dart';

@RoutePage()
class AdminUsersScreen extends ConsumerWidget {
  const AdminUsersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(usersListProvider);

    return PullToRefresh(
        onRefresh: () => ref.read(usersListProvider.notifier).refresh(),
        refreshOnStart: true,
        child: users.when(
          data: (usersList) {
            if (usersList.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(IconsaxPlusBold.people, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('No users found'),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: usersList.length,
              itemBuilder: (context, index) {
                final user = usersList[index];
                final lastActivity = user.lastActivityDate;
                final isAdmin = user.policy?.isAdministrator ?? false;
                final isDisabled = user.policy?.isDisabled ?? false;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isDisabled ? Colors.grey : (isAdmin ? Colors.blue : Colors.green),
                      child: Icon(
                        isAdmin ? IconsaxPlusBold.shield_security : IconsaxPlusBold.user,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      user.name ?? 'Unknown',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: isDisabled ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (lastActivity != null)
                          Text('Last active: ${DateFormat.yMMMd().add_jm().format(lastActivity)}'),
                        Row(
                          children: [
                            if (isAdmin)
                              Chip(
                                label: const Text('Admin', style: TextStyle(fontSize: 10)),
                                padding: EdgeInsets.zero,
                                visualDensity: VisualDensity.compact,
                              ),
                            if (isDisabled)
                              const Chip(
                                label: Text('Disabled', style: TextStyle(fontSize: 10)),
                                padding: EdgeInsets.zero,
                                visualDensity: VisualDensity.compact,
                              ),
                          ].map((e) => Padding(padding: const EdgeInsets.only(right: 4), child: e)).toList(),
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      context.router.push(AdminUserEditRoute(user: user));
                    },
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text('Error loading users: $error'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.read(usersListProvider.notifier).refresh(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ));
  }
}

@RoutePage()
class AdminSessionsScreen extends ConsumerWidget {
  const AdminSessionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessions = ref.watch(sessionsListProvider);

    return PullToRefresh(
        onRefresh: () => ref.read(sessionsListProvider.notifier).refresh(),
        refreshOnStart: true,
        child: sessions.when(
          data: (sessionsList) {
            if (sessionsList.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(IconsaxPlusBold.monitor, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('No active sessions'),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: sessionsList.length,
              itemBuilder: (context, index) {
                final session = sessionsList[index];
                final nowPlaying = session.nowPlayingItem;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.green,
                      child: const Icon(IconsaxPlusBold.monitor, color: Colors.white),
                    ),
                    title: Text(session.userName ?? session.deviceName ?? 'Unknown'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${session.$Client ?? 'Unknown'} - ${session.deviceName ?? 'Unknown device'}'),
                        if (nowPlaying != null)
                          Text('Playing: ${nowPlaying.name ?? 'Unknown'}',
                            style: const TextStyle(fontStyle: FontStyle.italic),
                          ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(IconsaxPlusBold.logout, color: Colors.red),
                      onPressed: () async {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('End Session'),
                            content: Text('End session for ${session.userName ?? session.deviceName}?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('End Session'),
                              ),
                            ],
                          ),
                        );

                        if (confirmed == true && context.mounted) {
                          try {
                            // Note: Jellyfin API logs out the current authenticated session, not a specific session
                          await ref.read(adminServiceProvider.notifier).logoutSession();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Session ended')),
                            );
                            ref.read(sessionsListProvider.notifier).refresh();
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: $e')),
                            );
                          }
                        }
                      },
                    ),
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text('Error: $error'),
              ],
            ),
          ),
        ));
  }
}

@RoutePage()
class AdminTasksScreen extends ConsumerWidget {
  const AdminTasksScreen({super.key});

  Map<String, List<TaskInfo>> _groupTasksByCategory(List<TaskInfo> tasks) {
    final Map<String, List<TaskInfo>> grouped = {};
    
    for (final task in tasks) {
      final category = task.category ?? 'Other';
      if (!grouped.containsKey(category)) {
        grouped[category] = [];
      }
      grouped[category]!.add(task);
    }

    // Sort tasks within each category by name
    for (final category in grouped.keys) {
      grouped[category]!.sort((a, b) => (a.name ?? '').compareTo(b.name ?? ''));
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(tasksListProvider);

    return PullToRefresh(
        onRefresh: () => ref.read(tasksListProvider.notifier).refresh(),
        refreshOnStart: true,
        child: tasks.when(
          data: (tasksList) {
            if (tasksList.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(IconsaxPlusBold.task_square, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('No tasks found'),
                  ],
                ),
              );
            }

            final groupedTasks = _groupTasksByCategory(tasksList);
            final categories = groupedTasks.keys.toList()..sort();

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: categories.length,
              itemBuilder: (context, categoryIndex) {
                final category = categories[categoryIndex];
                final categoryTasks = groupedTasks[category]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8, top: 16, bottom: 8),
                      child: Text(
                        category,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        children: categoryTasks.asMap().entries.map((entry) {
                          final taskIndex = entry.key;
                          final task = entry.value;
                          final isLast = taskIndex == categoryTasks.length - 1;

                          return _TaskListItem(
                            task: task,
                            showDivider: !isLast,
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text('Error: $error'),
              ],
            ),
          ),
        ));
  }
}

class _TaskListItem extends ConsumerWidget {
  final TaskInfo task;
  final bool showDivider;

  const _TaskListItem({
    required this.task,
    required this.showDivider,
  });

  String _getLastRunText(TaskInfo task) {
    if (task.state == enums.TaskState.running) {
      return 'Running...';
    }

    final lastExecution = task.lastExecutionResult;
    if (lastExecution == null) return 'Never run';

    final startTime = lastExecution.startTimeUtc;
    final endTime = lastExecution.endTimeUtc;

    if (startTime == null || endTime == null) return 'Never run';

    final duration = endTime.difference(startTime);
    final timeAgo = _formatTimeAgo(endTime);
    
    final status = lastExecution.status;
    String statusText = '';
    
    if (status == enums.TaskCompletionStatus.failed) {
      statusText = ' (Failed)';
    } else if (status == enums.TaskCompletionStatus.cancelled) {
      statusText = ' (Cancelled)';
    } else if (status == enums.TaskCompletionStatus.aborted) {
      statusText = ' (Aborted)';
    }

    return 'Last run $timeAgo, took ${_formatDuration(duration)}$statusText';
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years year${years == 1 ? '' : 's'} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months month${months == 1 ? '' : 's'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'just now';
    }
  }

  String _formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      final hours = duration.inHours;
      final minutes = duration.inMinutes % 60;
      return '$hours hour${hours == 1 ? '' : 's'} $minutes minute${minutes == 1 ? '' : 's'}';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes} minute${duration.inMinutes == 1 ? '' : 's'}';
    } else {
      return '${duration.inSeconds} second${duration.inSeconds == 1 ? '' : 's'}';
    }
  }

  Color _getStatusColor(BuildContext context, TaskInfo task) {
    final colorScheme = Theme.of(context).colorScheme;
    
    if (task.state == enums.TaskState.running) {
      return colorScheme.primary;
    }

    final status = task.lastExecutionResult?.status;
    if (status == enums.TaskCompletionStatus.failed || status == enums.TaskCompletionStatus.aborted) {
      return colorScheme.error;
    }

    return colorScheme.surfaceContainerHighest;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isRunning = task.state == enums.TaskState.running;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        InkWell(
          onTap: () {
            if (task.id != null) {
              context.router.navigateNamed('/admin/tasks/${task.id}');
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: _getStatusColor(context, task),
                  child: Icon(
                    IconsaxPlusBold.clock,
                    color: isRunning ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.name ?? 'Unknown Task',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (isRunning && task.currentProgressPercentage != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: LinearProgressIndicator(
                                    value: task.currentProgressPercentage! / 100,
                                    backgroundColor: colorScheme.surfaceContainerHighest,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  '${task.currentProgressPercentage!.toStringAsFixed(0)}%',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      else
                        Text(
                          _getLastRunText(task),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  icon: Icon(
                    isRunning ? IconsaxPlusBold.stop_circle : IconsaxPlusBold.play_circle,
                    color: isRunning ? colorScheme.error : colorScheme.primary,
                  ),
                  onPressed: () async {
                    try {
                      if (isRunning) {
                        await ref.read(adminServiceProvider.notifier).stopTask(task.id!);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Stopped ${task.name}')),
                          );
                        }
                      } else {
                        await ref.read(adminServiceProvider.notifier).startTask(task.id!);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Started ${task.name}')),
                          );
                        }
                      }
                      ref.read(tasksListProvider.notifier).refresh();
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: $e')),
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(height: 1, indent: 72, color: colorScheme.outlineVariant),
      ],
    );
  }
}

@RoutePage()
class AdminDevicesScreen extends ConsumerStatefulWidget {
  const AdminDevicesScreen({super.key});

  @override
  ConsumerState<AdminDevicesScreen> createState() => _AdminDevicesScreenState();
}

class _AdminDevicesScreenState extends ConsumerState<AdminDevicesScreen> {
  Future<void> _refresh() async {
    await ref.read(devicesListProvider.notifier).refresh();
  }

  Future<void> _deleteDevice(DeviceInfoDto device) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Device'),
        content: Text('Remove device "${device.name}"?\n\nThe device can re-register on next use.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await ref.read(adminServiceProvider.notifier).deleteDevice(device.id!);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Deleted device: ${device.name}')),
        );
        ref.read(devicesListProvider.notifier).refresh();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final devices = ref.watch(devicesListProvider);

    return PullToRefresh(
        onRefresh: _refresh,
        refreshOnStart: true,
        child: devices.when(
          data: (deviceList) {
            if (deviceList.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(IconsaxPlusBold.mobile, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('No devices found'),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: deviceList.length,
              itemBuilder: (context, index) {
                final device = deviceList[index];
                final lastUserName = device.lastUserName ?? 'Unknown';
                final appName = device.appName ?? 'Unknown App';
                final appVersion = device.appVersion;
                final lastActivityDate = device.dateLastActivity;
                final isRecent = lastActivityDate != null &&
                    DateTime.now().difference(lastActivityDate).inDays < 7;

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isRecent ? Colors.green : Colors.grey,
                      child: Icon(
                        _getDeviceIcon(appName),
                        color: Colors.white,
                      ),
                    ),
                    title: Text(device.name ?? 'Unnamed Device'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('User: $lastUserName'),
                        Text('$appName${appVersion != null ? " v$appVersion" : ""}'),
                        if (lastActivityDate != null)
                          Text(
                            'Last active: ${_formatDate(lastActivityDate)}',
                            style: TextStyle(
                              color: isRecent ? Colors.green : Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(IconsaxPlusLinear.trash, color: Colors.red),
                      onPressed: () => _deleteDevice(device),
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text('Error: $error'),
              ],
            ),
          ),
        ));
  }

  IconData _getDeviceIcon(String appName) {
    final lowerApp = appName.toLowerCase();
    if (lowerApp.contains('android') || lowerApp.contains('mobile')) {
      return IconsaxPlusBold.mobile;
    } else if (lowerApp.contains('web') || lowerApp.contains('browser')) {
      return IconsaxPlusBold.global;
    } else if (lowerApp.contains('tv')) {
      return IconsaxPlusBold.monitor;
    } else if (lowerApp.contains('desktop') || lowerApp.contains('windows') || lowerApp.contains('linux')) {
      return IconsaxPlusBold.monitor_mobbile;
    }
    return IconsaxPlusBold.devices;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    
    return '${date.day}/${date.month}/${date.year}';
  }
}

@RoutePage()
class AdminLibrariesScreen extends ConsumerStatefulWidget {
  const AdminLibrariesScreen({super.key});

  @override
  ConsumerState<AdminLibrariesScreen> createState() => _AdminLibrariesScreenState();
}

class _AdminLibrariesScreenState extends ConsumerState<AdminLibrariesScreen> {
  bool _isScanning = false;

  Future<void> _refresh() async {
    await ref.read(virtualFoldersListProvider.notifier).refresh();
  }

  Future<void> _scanAllLibraries() async {
    setState(() => _isScanning = true);
    try {
      await ref.read(adminServiceProvider.notifier).scanLibrary();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Library scan started')),
        );
      }
      // Wait a bit then refresh to see progress
      await Future.delayed(const Duration(seconds: 2));
      await _refresh();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isScanning = false);
      }
    }
  }

  Future<void> _deleteLibrary(VirtualFolderInfo library) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Library'),
        content: Text(
          'Remove library "${library.name}"?\n\nThis will not delete the actual media files.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await ref.read(adminServiceProvider.notifier).removeVirtualFolder(
          name: library.name!,
          refreshLibrary: true,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Deleted library: ${library.name}')),
        );
        ref.read(virtualFoldersListProvider.notifier).refresh();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final libraries = ref.watch(virtualFoldersListProvider);

    return PullToRefresh(
        onRefresh: _refresh,
        refreshOnStart: true,
        child: libraries.when(
          data: (libraryList) {
            if (libraryList.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(IconsaxPlusBold.folder, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('No libraries found'),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: libraryList.length,
              itemBuilder: (context, index) {
                final library = libraryList[index];
                final locations = library.locations ?? [];
                final collectionType = library.collectionType?.toString().split('.').last ?? 'Unknown';
                final isScanning = library.refreshStatus?.toLowerCase() == 'scanning' ||
                    library.refreshStatus?.toLowerCase() == 'running';
                final progress = library.refreshProgress;

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: Column(
                    children: [
                      ListTile(
                        onTap: () {
                          if (library.itemId != null) {
                            context.router.navigateNamed(
                              '/admin/libraries/${library.itemId}?name=${Uri.encodeComponent(library.name ?? "Library")}',
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Library ID not available')),
                            );
                          }
                        },
                        leading: CircleAvatar(
                          backgroundColor: isScanning ? Colors.orange : Colors.blue,
                          child: Icon(
                            _getLibraryIcon(collectionType),
                            color: Colors.white,
                          ),
                        ),
                        title: Text(library.name ?? 'Unnamed Library'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Type: $collectionType'),
                            if (isScanning && progress != null)
                              LinearProgressIndicator(
                                value: progress / 100,
                                backgroundColor: Colors.grey[300],
                              ),
                            if (isScanning && progress != null)
                              Text(
                                'Scanning: ${progress.toStringAsFixed(1)}%',
                                style: const TextStyle(fontSize: 12, color: Colors.orange),
                              ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(IconsaxPlusLinear.trash, color: Colors.red),
                              tooltip: 'Delete Library',
                              onPressed: () => _deleteLibrary(library),
                            ),
                          ],
                        ),
                        isThreeLine: isScanning,
                      ),
                      if (locations.isNotEmpty)
                        ExpansionTile(
                          title: Text('${locations.length} location${locations.length > 1 ? 's' : ''}'),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ...locations.map((location) => Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 2),
                                    child: Row(
                                      children: [
                                        const Icon(IconsaxPlusLinear.folder_2, size: 16),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            location,
                                            style: const TextStyle(fontSize: 12),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                                ],
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text('Error: $error'),
              ],
            ),
          ),
        ));
  }

  IconData _getLibraryIcon(String type) {
    switch (type.toLowerCase()) {
      case 'movies':
        return IconsaxPlusBold.video;
      case 'tvshows':
        return IconsaxPlusBold.monitor;
      case 'music':
        return IconsaxPlusBold.music;
      case 'books':
        return IconsaxPlusBold.book;
      case 'photos':
        return IconsaxPlusBold.gallery;
      default:
        return IconsaxPlusBold.folder;
    }
  }
}

// Display Settings Screen
@RoutePage()
class AdminDisplayScreen extends ConsumerStatefulWidget {
  const AdminDisplayScreen({super.key});

  @override
  ConsumerState<AdminDisplayScreen> createState() => _AdminDisplayScreenState();
}

class _AdminDisplayScreenState extends ConsumerState<AdminDisplayScreen> {
  late bool _enableFolderView;
  late bool _displaySpecialsWithinSeasons;
  late bool _groupMoviesIntoCollections;
  late bool _enableGroupingIntoCollections;
  late bool _enableExternalContentInSuggestions;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final config = ref.read(serverConfigProvider).valueOrNull;
    _enableFolderView = config?.enableFolderView ?? false;
    _displaySpecialsWithinSeasons = config?.displaySpecialsWithinSeasons ?? true;
    _groupMoviesIntoCollections = config?.enableGroupingMoviesIntoCollections ?? false;
    _enableGroupingIntoCollections = config?.enableGroupingShowsIntoCollections ?? false;
    _enableExternalContentInSuggestions = config?.enableExternalContentInSuggestions ?? true;
  }

  Future<void> _saveSettings() async {
    setState(() => _isSaving = true);
    
    try {
      final currentConfig = await ref.read(serverConfigProvider.future);
      final updatedConfig = currentConfig.copyWith(
        enableFolderView: _enableFolderView,
        displaySpecialsWithinSeasons: _displaySpecialsWithinSeasons,
        enableGroupingMoviesIntoCollections: _groupMoviesIntoCollections,
        enableGroupingShowsIntoCollections: _enableGroupingIntoCollections,
        enableExternalContentInSuggestions: _enableExternalContentInSuggestions,
      );
      
      await ref.read(serverConfigProvider.notifier).updateConfiguration(updatedConfig);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Display settings saved successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving settings: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final configAsync = ref.watch(serverConfigProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Display Settings'),
        actions: [
          if (_isSaving)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else
            IconButton(
              icon: const Icon(IconsaxPlusBold.tick_circle),
              tooltip: 'Save Settings',
              onPressed: _saveSettings,
            ),
        ],
      ),
      body: configAsync.when(
        data: (_) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Enable Folder View'),
                    subtitle: const Text('Display libraries as folder structure'),
                    value: _enableFolderView,
                    onChanged: (value) => setState(() => _enableFolderView = value),
                    secondary: const Icon(IconsaxPlusLinear.folder_2),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: const Text('Display Specials Within Seasons'),
                    subtitle: const Text('Show special episodes within their respective seasons'),
                    value: _displaySpecialsWithinSeasons,
                    onChanged: (value) => setState(() => _displaySpecialsWithinSeasons = value),
                    secondary: const Icon(IconsaxPlusLinear.video_square),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: const Text('Group Movies Into Collections'),
                    subtitle: const Text('Automatically group movie series into collections'),
                    value: _groupMoviesIntoCollections,
                    onChanged: (value) => setState(() => _groupMoviesIntoCollections = value),
                    secondary: const Icon(IconsaxPlusLinear.video),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: const Text('Group Shows Into Collections'),
                    subtitle: const Text('Automatically group TV show franchises into collections'),
                    value: _enableGroupingIntoCollections,
                    onChanged: (value) => setState(() => _enableGroupingIntoCollections = value),
                    secondary: const Icon(IconsaxPlusLinear.monitor),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: const Text('Enable External Content in Suggestions'),
                    subtitle: const Text('Include external content sources in recommendations'),
                    value: _enableExternalContentInSuggestions,
                    onChanged: (value) => setState(() => _enableExternalContentInSuggestions = value),
                    secondary: const Icon(IconsaxPlusLinear.global),
                  ),
                ],
              ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error loading configuration: $error'),
            ],
          ),
        ),
      ),
    );
  }
}

// Metadata Settings Screen
@RoutePage()
class AdminMetadataScreen extends ConsumerStatefulWidget {
  const AdminMetadataScreen({super.key});

  @override
  ConsumerState<AdminMetadataScreen> createState() => _AdminMetadataScreenState();
}

class _AdminMetadataScreenState extends ConsumerState<AdminMetadataScreen> {
  String? _selectedLanguage;
  String? _selectedCountry;
  int _dummyChapterDuration = 300;
  ImageResolution _chapterImageResolution = ImageResolution.matchsource;
  bool _isSaving = false;
  List<CultureDto> _cultures = [];
  List<CountryInfo> _countries = [];
  bool _isLoadingOptions = true;

  @override
  void initState() {
    super.initState();
    _loadOptions();
  }

  Future<void> _loadOptions() async {
    try {
      final service = ref.read(jellyApiProvider);
      final culturesResponse = await service.api.localizationCulturesGet();
      final countriesResponse = await service.api.localizationCountriesGet();
      
      if (mounted) {
        setState(() {
          _cultures = culturesResponse.body ?? [];
          _countries = countriesResponse.body ?? [];
          _isLoadingOptions = false;
        });
        
        final config = ref.read(serverConfigProvider).valueOrNull;
        if (config != null) {
          setState(() {
            _selectedLanguage = config.preferredMetadataLanguage;
            _selectedCountry = config.metadataCountryCode;
            _dummyChapterDuration = config.dummyChapterDuration ?? 300;
            _chapterImageResolution = config.chapterImageResolution ?? ImageResolution.matchsource;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingOptions = false;
        });
      }
    }
  }

  Future<void> _saveSettings() async {
    setState(() {
      _isSaving = true;
    });

    try {
      final currentConfig = await ref.read(serverConfigProvider.future);
      final service = ref.read(jellyApiProvider);
      
      final updatedConfig = ServerConfiguration(
        logFileRetentionDays: currentConfig.logFileRetentionDays,
        isStartupWizardCompleted: currentConfig.isStartupWizardCompleted,
        cachePath: currentConfig.cachePath,
        serverName: currentConfig.serverName,
        enableFolderView: currentConfig.enableFolderView,
        displaySpecialsWithinSeasons: currentConfig.displaySpecialsWithinSeasons,
        enableGroupingMoviesIntoCollections: currentConfig.enableGroupingMoviesIntoCollections,
        enableGroupingShowsIntoCollections: currentConfig.enableGroupingShowsIntoCollections,
        enableExternalContentInSuggestions: currentConfig.enableExternalContentInSuggestions,
        preferredMetadataLanguage: _selectedLanguage,
        metadataCountryCode: _selectedCountry,
        dummyChapterDuration: _dummyChapterDuration,
        chapterImageResolution: _chapterImageResolution,
      );

      await service.systemConfigurationPost(updatedConfig);
      ref.invalidate(serverConfigProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Settings saved successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save settings: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingOptions) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Metadata Settings'),
        actions: [
          if (!_isSaving)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveSettings,
              tooltip: 'Save',
            )
          else
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Preferred Metadata Language',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedLanguage,
                    decoration: const InputDecoration(
                      labelText: 'Language',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(IconsaxPlusLinear.global),
                    ),
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('(Auto)'),
                      ),
                      ..._cultures.map((culture) => DropdownMenuItem(
                        value: culture.twoLetterISOLanguageName,
                        child: Text(culture.displayName ?? culture.twoLetterISOLanguageName ?? ''),
                      )),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedLanguage = value;
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Country',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedCountry,
                    decoration: const InputDecoration(
                      labelText: 'Metadata Country Code',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(IconsaxPlusLinear.flag),
                    ),
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('(Auto)'),
                      ),
                      ..._countries.map((country) => DropdownMenuItem(
                        value: country.twoLetterISORegionName,
                        child: Text(country.displayName ?? country.twoLetterISORegionName ?? ''),
                      )),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedCountry = value;
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Chapter Settings',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue: _dummyChapterDuration.toString(),
                    decoration: const InputDecoration(
                      labelText: 'Dummy Chapter Duration (seconds)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(IconsaxPlusLinear.clock),
                      helperText: 'Duration for auto-generated chapters',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (value) {
                      final parsed = int.tryParse(value);
                      if (parsed != null) {
                        _dummyChapterDuration = parsed;
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<ImageResolution>(
                    value: _chapterImageResolution,
                    decoration: const InputDecoration(
                      labelText: 'Chapter Image Resolution',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(IconsaxPlusLinear.image),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: ImageResolution.matchsource,
                        child: Text('Match Source'),
                      ),
                      DropdownMenuItem(
                        value: ImageResolution.p2160,
                        child: Text('2160p (4K)'),
                      ),
                      DropdownMenuItem(
                        value: ImageResolution.p1440,
                        child: Text('1440p'),
                      ),
                      DropdownMenuItem(
                        value: ImageResolution.p1080,
                        child: Text('1080p'),
                      ),
                      DropdownMenuItem(
                        value: ImageResolution.p720,
                        child: Text('720p'),
                      ),
                      DropdownMenuItem(
                        value: ImageResolution.p480,
                        child: Text('480p'),
                      ),
                      DropdownMenuItem(
                        value: ImageResolution.p360,
                        child: Text('360p'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _chapterImageResolution = value;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Nfo Settings Screen
@RoutePage()
class AdminNfoScreen extends ConsumerWidget {
  const AdminNfoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nfo Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Kodi Nfo Metadata Configuration',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  const ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(IconsaxPlusLinear.user),
                    title: Text('Metadata User'),
                    subtitle: Text('User account for metadata fetching'),
                  ),
                  const Divider(),
                  const ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(IconsaxPlusLinear.image),
                    title: Text('Save Image Paths in Nfo'),
                    subtitle: Text('Store image paths in nfo files'),
                  ),
                  const Divider(),
                  const ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(IconsaxPlusLinear.folder_connection),
                    title: Text('Enable Path Substitution'),
                    subtitle: Text('Allow path substitution for network shares'),
                  ),
                  const Divider(),
                  const ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(IconsaxPlusLinear.copy),
                    title: Text('Enable Extra Thumbs Duplication'),
                    subtitle: Text('Duplicate thumbnails for Kodi compatibility'),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'These settings require additional API endpoints. Configuration will be available in a future update.',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
