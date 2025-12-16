import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:intl/intl.dart';

import 'package:kebap/models/admin/admin_dashboard_model.dart';
import 'package:kebap/providers/admin_dashboard_provider.dart';
import 'package:kebap/providers/admin_provider.dart';
import 'package:kebap/screens/shared/nested_scaffold.dart';
import 'package:kebap/widgets/shared/pull_to_refresh.dart';

@RoutePage()
class AdminActivityScreen extends ConsumerStatefulWidget {
  const AdminActivityScreen({super.key});

  @override
  ConsumerState<AdminActivityScreen> createState() => _AdminActivityScreenState();
}

class _AdminActivityScreenState extends ConsumerState<AdminActivityScreen> {
  final ScrollController _scrollController = ScrollController();
  ActivityLogFilter _filter = const ActivityLogFilter();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      ref.read(activityLogProvider.notifier).loadMore();
    }
  }

  Future<void> _refresh() async {
    await ref.read(activityLogProvider.notifier).refresh();
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Activity'),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SwitchListTile(
                  title: const Text('Only user activities'),
                  value: _filter.hasUserId ?? false,
                  onChanged: (value) {
                    setState(() {
                      _filter = _filter.copyWith(hasUserId: value);
                    });
                  },
                ),
                ListTile(
                  title: const Text('Items per page'),
                  trailing: DropdownButton<int>(
                    value: _filter.limit,
                    items: [25, 50, 100, 200]
                        .map((e) => DropdownMenuItem(value: e, child: Text('$e')))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _filter = _filter.copyWith(limit: value);
                        });
                      }
                    },
                  ),
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(activityLogProvider.notifier).updateFilter(_filter);
              Navigator.pop(context);
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activityLog = ref.watch(activityLogProvider);
    final adminDashboard = ref.watch(adminDashboardProvider);

    return Scaffold(
      body: PullToRefresh(
        onRefresh: _refresh,
        refreshOnStart: true,
        child: activityLog.when(
          data: (data) {
            final items = data.items ?? [];
            if (items.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(IconsaxPlusBold.activity, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('No activity logs found'),
                  ],
                ),
              );
            }

            return CustomScrollView(
              controller: _scrollController,
              slivers: [
                // Server Info Header
                SliverToBoxAdapter(
                  child: adminDashboard.when(
                    data: (dashData) => Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (dashData.systemInfo != null) ...[
                            _buildServerInfoCard(context, dashData.systemInfo!),
                            const SizedBox(height: 12),
                            _buildServerControlButtons(context),
                            const SizedBox(height: 24),
                          ],
                          Text(
                            'Activity Log',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                  ),
                ),
                // Activity List
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                if (index == items.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final activity = items[index];
                final date = activity.date;
                final formattedDate = date != null
                    ? DateFormat.yMd().add_jm().format(date.toLocal())
                    : 'Unknown';

                return Card(
                  child: ExpansionTile(
                    leading: _getActivityIcon(activity.type),
                    title: Text(activity.name ?? 'Unknown Activity'),
                    subtitle: Text(formattedDate),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (activity.overview != null) ...[
                              Text(
                                'Details',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              const SizedBox(height: 8),
                              Text(activity.overview!),
                              const SizedBox(height: 16),
                            ],
                            _buildInfoRow('Type', activity.type ?? 'Unknown'),
                            if (activity.userId != null)
                              _buildInfoRow('User ID', activity.userId!),
                            if (activity.itemId != null)
                              _buildInfoRow('Item ID', activity.itemId!),
                            _buildInfoRow(
                              'Severity',
                              activity.severity?.name ?? 'Unknown',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
                    },
                    childCount: items.length + 1,
                  ),
                ),
              ],
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
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _refresh,
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
        ],
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
            _buildServerInfoRow('Operating System', systemInfo.operatingSystemDisplayName ?? 'Unknown'),
            _buildServerInfoRow('Server ID', systemInfo.id ?? 'Unknown', copyable: true),
          ],
        ),
      ),
    );
  }

  Widget _buildServerInfoRow(String label, String value, {bool copyable = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Flexible(
            child: copyable
                ? InkWell(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: value));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Copied: $value'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(4),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              value,
                              style: const TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.copy, size: 14, color: Colors.blue),
                        ],
                      ),
                    ),
                  )
                : Text(
                    value,
                    style: const TextStyle(color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                  ),
          ),
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

  Future<void> _scanAllLibraries(BuildContext context) async {
    try {
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
