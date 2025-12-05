import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:kebap/util/adaptive_layout/adaptive_layout.dart';

class InputDetector extends StatefulWidget {
  final bool isDesktop;
  final bool htpcMode;
  final Widget Function(InputDevice input) child;

  const InputDetector({
    super.key,
    required this.isDesktop,
    required this.htpcMode,
    required this.child,
  });

  @override
  State<InputDetector> createState() => _InputDetectorState();
}

class _InputDetectorState extends State<InputDetector> {
  late InputDevice _currentInput = widget.htpcMode
      ? InputDevice.dPad
      : (widget.isDesktop || kIsWeb)
          ? InputDevice.pointer
          : InputDevice.touch;

  DateTime? _lastKeyTime;

  @override
  void initState() {
    super.initState();
    _startListeningToKeyboard();
  }

  void _startListeningToKeyboard() {
    ServicesBinding.instance.keyboard.addHandler(_handleKeyPress);
  }

  @override
  void dispose() {
    ServicesBinding.instance.keyboard.removeHandler(_handleKeyPress);
    super.dispose();
  }

  bool _handleKeyPress(KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowUp ||
          event.logicalKey == LogicalKeyboardKey.arrowDown ||
          event.logicalKey == LogicalKeyboardKey.arrowLeft ||
          event.logicalKey == LogicalKeyboardKey.arrowRight ||
          event.logicalKey == LogicalKeyboardKey.select ||
          event.logicalKey == LogicalKeyboardKey.enter ||
          event.logicalKey == LogicalKeyboardKey.numpadEnter ||
          event.logicalKey == LogicalKeyboardKey.open ||
          event.logicalKey == LogicalKeyboardKey.gameButtonA) {
        _lastKeyTime = DateTime.now();
        _updateInputDevice(InputDevice.dPad);
      } else {
      }
    }
    return false;
  }

  void _handlePointerEvent(PointerEvent event) {
    if (widget.htpcMode) {
      // debugPrint('[LAG_DEBUG] InputDetector ignoring pointer in HTPC mode');
      return;
    }
    if (event is PointerDownEvent) {
      print('[LAG_DEBUG] ${DateTime.now()} InputDetector PointerDownEvent kind: ${event.kind}');
      if (_lastKeyTime != null &&
          DateTime.now().difference(_lastKeyTime!) <
              const Duration(milliseconds: 300)) {
        return;
      }
      if (event.kind == PointerDeviceKind.touch) {
        _updateInputDevice(InputDevice.touch);
      } else if (event.kind == PointerDeviceKind.mouse) {
        _updateInputDevice(InputDevice.pointer);
      }
    }
  }

  void _updateInputDevice(InputDevice device) {
    if (_currentInput != device) {
      print('[LAG_DEBUG] ${DateTime.now()} InputDetector switching to $device');
      setState(() {
        _currentInput = device;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print('[LAG_DEBUG] ${DateTime.now()} InputDetector build');
    return Listener(
      onPointerDown: _handlePointerEvent,
      behavior: HitTestBehavior.translucent,
      child: Builder(
        builder: (context) => widget.child(_currentInput),
      ),
    );
  }
}
