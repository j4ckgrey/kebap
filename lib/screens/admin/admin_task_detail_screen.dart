import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kebap/jellyfin/jellyfin_open_api.swagger.dart';
import 'package:kebap/jellyfin/jellyfin_open_api.enums.swagger.dart' as enums;
import 'package:kebap/providers/admin_provider.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

@RoutePage()
class AdminTaskDetailScreen extends ConsumerStatefulWidget {
  final String taskId;

  const AdminTaskDetailScreen({
    super.key,
    @PathParam('taskId') required this.taskId,
  });

  @override
  ConsumerState<AdminTaskDetailScreen> createState() => _AdminTaskDetailScreenState();
}

class _AdminTaskDetailScreenState extends ConsumerState<AdminTaskDetailScreen> {
  TaskInfo? _task;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadTask();
  }

  Future<void> _loadTask() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await ref.read(adminServiceProvider.notifier).getTaskById(widget.taskId);
      if (mounted) {
        setState(() {
          _task = response.body;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  String _formatTrigger(TaskTriggerInfo trigger) {
    switch (trigger.type) {
      case enums.TaskTriggerInfoType.dailytrigger:
        final ticks = trigger.timeOfDayTicks ?? 0;
        final time = _ticksToTimeOfDay(ticks);
        return 'Daily at $time';
      case enums.TaskTriggerInfoType.weeklytrigger:
        final ticks = trigger.timeOfDayTicks ?? 0;
        final time = _ticksToTimeOfDay(ticks);
        final day = trigger.dayOfWeek?.value ?? 'Unknown';
        return 'Weekly on $day at $time';
      case enums.TaskTriggerInfoType.intervaltrigger:
        final ticks = trigger.intervalTicks ?? 0;
        final duration = _ticksToDuration(ticks);
        return 'Every $duration';
      case enums.TaskTriggerInfoType.startuptrigger:
        return 'On application startup';
      default:
        return trigger.type?.value ?? 'Unknown trigger type';
    }
  }

  String _ticksToTimeOfDay(int ticks) {
    final milliseconds = ticks ~/ 10000;
    final hours = milliseconds ~/ 3600000;
    final minutes = (milliseconds % 3600000) ~/ 60000;
    final time = DateTime(2000, 1, 1, hours, minutes);
    return DateFormat.jm().format(time);
  }

  String _ticksToDuration(int ticks) {
    final milliseconds = ticks ~/ 10000;
    final hours = milliseconds ~/ 3600000;
    final minutes = (milliseconds % 3600000) ~/ 60000;

    if (hours > 0) {
      return '$hours hour${hours == 1 ? '' : 's'}';
    } else if (minutes > 0) {
      return '$minutes minute${minutes == 1 ? '' : 's'}';
    } else {
      return 'Less than a minute';
    }
  }

  String _getLastRunText() {
    if (_task?.state == enums.TaskState.running) {
      return 'Currently running';
    }

    final lastExecution = _task?.lastExecutionResult;
    if (lastExecution == null) return 'Never run';

    final startTime = lastExecution.startTimeUtc;
    final endTime = lastExecution.endTimeUtc;

    if (startTime == null || endTime == null) return 'Never run';

    final duration = endTime.difference(startTime);
    final formattedDate = DateFormat.yMMMd().add_jm().format(endTime);
    
    final status = lastExecution.status;
    String statusText = '';
    
    if (status == enums.TaskCompletionStatus.failed) {
      statusText = ' - Failed';
    } else if (status == enums.TaskCompletionStatus.cancelled) {
      statusText = ' - Cancelled';
    } else if (status == enums.TaskCompletionStatus.aborted) {
      statusText = ' - Aborted';
    } else if (status == enums.TaskCompletionStatus.completed) {
      statusText = ' - Completed';
    }

    return '$formattedDate (took ${_formatDurationShort(duration)})$statusText';
  }

  String _formatDurationShort(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes % 60}m';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m';
    } else {
      return '${duration.inSeconds}s';
    }
  }

  Future<void> _startTask() async {
    try {
      await ref.read(adminServiceProvider.notifier).startTask(widget.taskId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Started ${_task?.name}')),
        );
        _loadTask();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _stopTask() async {
    try {
      await ref.read(adminServiceProvider.notifier).stopTask(widget.taskId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Stopped ${_task?.name}')),
        );
        _loadTask();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isRunning = _task?.state == enums.TaskState.running;

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Task Details'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Task Details'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $_error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadTask,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_task == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Task Details'),
        ),
        body: const Center(child: Text('Task not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_task!.name ?? 'Task Details'),
      ),
      body: RefreshIndicator(
        onRefresh: _loadTask,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Task Info Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _task!.name ?? 'Unknown Task',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (isRunning)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: colorScheme.primary,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              'RUNNING',
                              style: TextStyle(
                                color: colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (_task!.description != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        _task!.description!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    if (_task!.category != null)
                      _InfoRow(
                        icon: IconsaxPlusBold.category,
                        label: 'Category',
                        value: _task!.category!,
                      ),
                    _InfoRow(
                      icon: IconsaxPlusBold.status,
                      label: 'Status',
                      value: _task!.state?.value ?? 'Unknown',
                    ),
                    _InfoRow(
                      icon: IconsaxPlusBold.clock,
                      label: 'Last Execution',
                      value: _getLastRunText(),
                    ),
                    if (isRunning && _task!.currentProgressPercentage != null) ...[
                      const SizedBox(height: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Progress',
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: LinearProgressIndicator(
                                  value: _task!.currentProgressPercentage! / 100,
                                  backgroundColor: colorScheme.surfaceContainerHighest,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                '${_task!.currentProgressPercentage!.toStringAsFixed(0)}%',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: isRunning ? _stopTask : _startTask,
                    icon: Icon(isRunning ? IconsaxPlusBold.stop_circle : IconsaxPlusBold.play_circle),
                    label: Text(isRunning ? 'Stop Task' : 'Run Now'),
                    style: FilledButton.styleFrom(
                      backgroundColor: isRunning ? colorScheme.error : colorScheme.primary,
                      foregroundColor: isRunning ? colorScheme.onError : colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Triggers Section
            Text(
              'Triggers',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            if (_task!.triggers == null || _task!.triggers!.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: Text(
                      'No triggers configured',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              )
            else
              Card(
                child: Column(
                  children: _task!.triggers!.asMap().entries.map((entry) {
                    final index = entry.key;
                    final trigger = entry.value;
                    final isLast = index == _task!.triggers!.length - 1;

                    return Column(
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor: colorScheme.primaryContainer,
                            child: Icon(
                              IconsaxPlusBold.timer_1,
                              color: colorScheme.onPrimaryContainer,
                              size: 20,
                            ),
                          ),
                          title: Text(_formatTrigger(trigger)),
                          subtitle: trigger.maxRuntimeTicks != null
                              ? Text('Max runtime: ${_ticksToDuration(trigger.maxRuntimeTicks!)}')
                              : null,
                        ),
                        if (!isLast)
                          Divider(height: 1, indent: 72, color: colorScheme.outlineVariant),
                      ],
                    );
                  }).toList(),
                ),
              ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
