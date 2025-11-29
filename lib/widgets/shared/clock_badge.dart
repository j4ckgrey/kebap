import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kebap/providers/settings/client_settings_provider.dart';

class ClockBadge extends ConsumerStatefulWidget {
  const ClockBadge({super.key});

  @override
  ConsumerState<ClockBadge> createState() => _ClockBadgeState();
}

class _ClockBadgeState extends ConsumerState<ClockBadge> {
  late final Timer _timer;
  late DateTime _currentTime;

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (mounted) {
        setState(() {
          _currentTime = DateTime.now();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    final showClock = ref.watch(clientSettingsProvider.select((s) => s.showClock));
    if (!showClock) return const SizedBox.shrink();

    final use12HourClock = ref.watch(clientSettingsProvider.select((s) => s.use12HourClock));
    final theme = Theme.of(context);
    final timeString = use12HourClock
        ? DateFormat('hh:mm a').format(_currentTime)
        : DateFormat.Hm().format(_currentTime);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Text(
        timeString,
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}
