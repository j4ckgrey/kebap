import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class FpsMonitor extends StatefulWidget {
  final Widget child;
  final Alignment alignment;

  const FpsMonitor({
    required this.child,
    this.alignment = Alignment.topLeft,
    super.key,
  });

  @override
  State<FpsMonitor> createState() => _FpsMonitorState();
}

class _FpsMonitorState extends State<FpsMonitor> with SingleTickerProviderStateMixin {
  double? _fps;
  int _frames = 0;
  // Use DateTime for interval tracking instead of FrameTiming properties
  DateTime _prev = DateTime.now();
  bool _stressMode = false;
  late final Ticker _ticker;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      SchedulerBinding.instance.addTimingsCallback(_onTimings);
    });
    _prev = DateTime.now();
    _ticker = createTicker((_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _ticker.dispose();
    SchedulerBinding.instance.removeTimingsCallback(_onTimings);
    super.dispose();
  }

  void _onTimings(List<FrameTiming> timings) {
    if (!mounted) return;

    for (final _ in timings) {
      _frames++;
    }

    final now = DateTime.now();
    final duration = now.difference(_prev);

    if (duration.inMilliseconds >= 500) {
      final fps = _frames / (duration.inMilliseconds / 1000.0);
      
      setState(() {
        _fps = fps;
      });

      _frames = 0;
      _prev = now;
    }
  }

  void _toggleStress() {
    setState(() {
      _stressMode = !_stressMode;
      if (_stressMode) {
        _prev = DateTime.now();
        _ticker.start();
      } else {
        _ticker.stop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      textDirection: TextDirection.ltr,
      children: [
        widget.child,
        Positioned(
          left: widget.alignment == Alignment.topLeft || widget.alignment == Alignment.bottomLeft ? 8 : null,
          right: widget.alignment == Alignment.topRight || widget.alignment == Alignment.bottomRight ? 8 : null,
          top: widget.alignment == Alignment.topLeft || widget.alignment == Alignment.topRight ? 8 : null,
          bottom: widget.alignment == Alignment.bottomLeft || widget.alignment == Alignment.bottomRight ? 8 : null,
          child: GestureDetector(
            onTap: _toggleStress,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: _stressMode ? Colors.red.withOpacity(0.8) : Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _fps != null ? '${_fps!.toStringAsFixed(0)} FPS' : 'Calculating...',
                    style: const TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  if (_stressMode)
                    const Padding(
                      padding: EdgeInsets.only(left: 4),
                      child: Text(
                        '(STRESS)',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
