import 'dart:async';

import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:intl/intl.dart';

import 'package:kebap/models/admin/admin_dashboard_model.dart';
import 'package:kebap/providers/admin_dashboard_provider.dart';
import 'package:kebap/providers/admin_provider.dart';
import 'package:kebap/routes/auto_router.gr.dart';
import 'package:kebap/screens/admin/widgets/admin_left_pane.dart';
import 'package:kebap/screens/shared/nested_scaffold.dart';
import 'package:kebap/util/adaptive_layout/adaptive_layout.dart';
import 'package:kebap/widgets/shared/pull_to_refresh.dart';

@RoutePage()
class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  ConsumerState<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends ConsumerState<AdminDashboardScreen> {
  bool _hasNavigated = false;

  @override
  Widget build(BuildContext context) {
    final isSingle = AdaptiveLayout.layoutModeOf(context) == LayoutMode.single;
    
    return AutoTabsRouter(
      duration: isSingle ? Duration.zero : const Duration(milliseconds: 300),
      builder: (context, content) {
        // Navigate to activity page by default on desktop (only once)
        if (!_hasNavigated && 
            AdaptiveLayout.layoutModeOf(context) == LayoutMode.dual && 
            context.tabsRouter.activeIndex == 0) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              context.tabsRouter.setActiveIndex(1);
              setState(() {
                _hasNavigated = true;
              });
            }
          });
        }
        
        return PopScope(
          canPop: context.tabsRouter.activeIndex == 0 || AdaptiveLayout.layoutModeOf(context) == LayoutMode.dual,
          onPopInvokedWithResult: (didPop, result) {
            if (!didPop) {
              context.tabsRouter.setActiveIndex(0);
            }
          },
          child: isSingle
              ? content
              : Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Builder(
                              builder: (context) {
                                final routeName = context.tabsRouter.current.name;
                                print('[ADMIN_SELECTION] activeRouteName: $routeName');
                                return AdminLeftPane(activeRouteName: routeName);
                              },
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: content,
                          ),
                        ],
                      ),
        );
      },
    );
  }



  Widget _buildDashboard(
    BuildContext context,
    AdminDashboardModel data,
    AdminStatsModel? stats,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Server Info Card
          if (data.systemInfo != null) ...[
            _buildServerInfoCard(context, data.systemInfo!),
            const SizedBox(height: 12),
            _buildServerControlButtons(context),
            const SizedBox(height: 16),
          ],

          // Statistics Grid
          if (stats != null) ...[
            _buildStatsGrid(context, stats),
            const SizedBox(height: 24),
          ],

          // Active Sessions
          if (data.activeSessions.isNotEmpty) ...[
            _buildSectionHeader(
              context,
              'Active Sessions',
              IconsaxPlusBold.monitor,
              onViewAll: () => context.router.push(const AdminSessionsRoute()),
            ),
            const SizedBox(height: 12),
            _buildActiveSessions(context, data.activeSessions),
            const SizedBox(height: 24),
          ],

          // Running Tasks
          if (data.runningTasks.isNotEmpty) ...[
            _buildSectionHeader(
              context,
              'Running Tasks',
              IconsaxPlusBold.task_square,
              onViewAll: () => context.router.push(const AdminTasksRoute()),
            ),
            const SizedBox(height: 12),
            _buildRunningTasks(context, data.runningTasks),
            const SizedBox(height: 24),
          ],

          // Recent Activity
          if (data.recentActivity.isNotEmpty) ...[
            _buildSectionHeader(
              context,
              'Recent Activity',
              IconsaxPlusBold.activity,
              onViewAll: () => context.router.push(const AdminActivityRoute()),
            ),
            const SizedBox(height: 12),
            _buildRecentActivity(context, data.recentActivity),
          ],
        ],
      ),
    );
  }

  Widget _buildServerInfoCard(BuildContext context, dynamic systemInfo) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(IconsaxPlusBold.monitor_mobbile),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        systemInfo.serverName ?? 'Jellyfin Server',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        'Version ${systemInfo.version ?? 'Unknown'}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            _buildInfoRow('Operating System', systemInfo.operatingSystem ?? 'Unknown'),
            _buildInfoRow('Server ID', systemInfo.id ?? 'Unknown'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildServerControlButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _scanAllLibraries(context),
            icon: const Icon(IconsaxPlusBold.scan_barcode, size: 18),
            label: const Text('Scan Libraries'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _restartServer(context),
            icon: const Icon(IconsaxPlusBold.refresh, size: 18),
            label: const Text('Restart'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _shutdownServer(context),
            icon: const Icon(IconsaxPlusBold.logout, size: 18),
            label: const Text('Shutdown'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid(BuildContext context, AdminStatsModel stats) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 800
            ? 4
            : constraints.maxWidth > 600
                ? 3
                : 2;

        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.5,
          children: [
            _buildStatCard(
              context,
              'Users',
              stats.totalUsers.toString(),
              IconsaxPlusBold.user,
              Colors.blue,
              subtitle: '${stats.activeUsers} active',
            ),
            _buildStatCard(
              context,
              'Sessions',
              stats.activeSessions.toString(),
              IconsaxPlusBold.monitor,
              Colors.green,
            ),
            _buildStatCard(
              context,
              'Devices',
              stats.totalDevices.toString(),
              IconsaxPlusBold.mobile,
              Colors.orange,
            ),
            _buildStatCard(
              context,
              'Movies',
              stats.movieCount.toString(),
              IconsaxPlusBold.video,
              Colors.purple,
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color, {
    String? subtitle,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon, {
    VoidCallback? onViewAll,
  }) {
    return Row(
      children: [
        Icon(icon),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        if (onViewAll != null)
          TextButton(
            onPressed: onViewAll,
            child: const Text('View All'),
          ),
      ],
    );
  }

  Widget _buildActiveSessions(BuildContext context, List<dynamic> sessions) {
    return Card(
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: sessions.take(5).length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final session = sessions[index];
          return ListTile(
            leading: const Icon(IconsaxPlusBold.monitor),
            title: Text(session.userName ?? session.deviceName ?? 'Unknown'),
            subtitle: Text(
              '${session.deviceName} • ${session.client} ${session.applicationVersion}',
            ),
            trailing: session.nowPlayingItem != null
                ? const Icon(IconsaxPlusBold.play_circle, color: Colors.green)
                : null,
          );
        },
      ),
    );
  }

  Widget _buildRunningTasks(BuildContext context, List<dynamic> tasks) {
    return Card(
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: tasks.take(5).length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final task = tasks[index];
          final progress = task.currentProgressPercentage ?? 0.0;

          return ListTile(
            leading: const CircularProgressIndicator(),
            title: Text(task.name ?? 'Unknown Task'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (task.description != null) Text(task.description!),
                const SizedBox(height: 4),
                LinearProgressIndicator(value: progress / 100),
                const SizedBox(height: 4),
                Text('${progress.toStringAsFixed(1)}%'),
              ],
            ),
            isThreeLine: true,
          );
        },
      ),
    );
  }

  Widget _buildRecentActivity(BuildContext context, List<dynamic> activities) {
    return Card(
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: activities.take(10).length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final activity = activities[index];
          final date = activity.date;
          final formattedDate = date != null
              ? DateFormat.yMd().add_jm().format(date.toLocal())
              : 'Unknown';

          return ListTile(
            leading: _getActivityIcon(activity.type),
            title: Text(activity.name ?? 'Unknown Activity'),
            subtitle: Text('$formattedDate • ${activity.shortOverview ?? ''}'),
            dense: true,
          );
        },
      ),
    );
  }

  Icon _getActivityIcon(String? type) {
    switch (type) {
      case 'UserAuthenticated':
        return const Icon(IconsaxPlusBold.login, color: Colors.green);
      case 'UserLoggedOut':
        return const Icon(IconsaxPlusBold.logout, color: Colors.orange);
      case 'UserPasswordChanged':
        return const Icon(IconsaxPlusBold.lock, color: Colors.blue);
      case 'UserCreated':
      case 'UserDeleted':
      case 'UserUpdated':
        return const Icon(IconsaxPlusBold.user_edit, color: Colors.purple);
      case 'LibraryUpdate':
      case 'LibraryScan':
        return const Icon(IconsaxPlusBold.folder, color: Colors.amber);
      case 'VideoPlayback':
      case 'AudioPlayback':
        return const Icon(IconsaxPlusBold.play_circle, color: Colors.teal);
      default:
        return const Icon(IconsaxPlusBold.info_circle);
    }
  }

  Future<void> _scanAllLibraries(BuildContext context) async {
    try {
      // Start scan for all libraries
      await ref.read(adminServiceProvider.notifier).scanLibrary();
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Library scan started'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to scan libraries: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _restartServer(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Restart Server'),
        content: const Text(
          'Are you sure you want to restart the server? '
          'This will disconnect all active sessions.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Restart'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        // Restart server
        await ref.read(adminServiceProvider.notifier).restartServer();
        
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Server restart initiated'),
              duration: Duration(seconds: 3),
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to restart server: $e'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    }
  }

  Future<void> _shutdownServer(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Shutdown Server'),
        content: const Text(
          'Are you sure you want to shutdown the server? '
          'This will disconnect all active sessions and stop the server.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Shutdown'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        // Shutdown server
        await ref.read(adminServiceProvider.notifier).shutdownServer();
        
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Server shutdown initiated'),
              duration: Duration(seconds: 3),
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to shutdown server: $e'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    }
  }

}
