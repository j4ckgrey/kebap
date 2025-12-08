import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide ConnectionState;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';

import 'package:kebap/providers/arguments_provider.dart';
import 'package:kebap/providers/connectivity_provider.dart';
import 'package:kebap/util/adaptive_layout/adaptive_layout.dart';
import 'package:kebap/widgets/full_screen_helpers/full_screen_wrapper.dart';
import 'package:kebap/widgets/shared/offline_banner.dart';

class DefaultTitleBar extends ConsumerStatefulWidget {
  final String? label;
  final double? height;
  final Brightness? brightness;
  const DefaultTitleBar({this.height = defaultTitleBarHeight, this.label, this.brightness, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DefaultTitleBarState();
}

class _DefaultTitleBarState extends ConsumerState<DefaultTitleBar> with WindowListener {
  bool hovering = false;
  bool isMinimized = false;
  bool isMaximized = false;

  @override
  void initState() {
    if (!kIsWeb) windowManager.addListener(this);
    super.initState();
    _updateWindowState();
  }

  @override
  void dispose() {
    if (!kIsWeb) windowManager.removeListener(this);
    super.dispose();
  }

  Future<void> _updateWindowState() async {
    if (kIsWeb) return;
    final minimized = await windowManager.isMinimized();
    final maximized = await windowManager.isMaximized();
    if (mounted) {
      setState(() {
        isMinimized = minimized;
        isMaximized = maximized;
      });
    }
  }

  @override
  void onWindowMinimize() {
    setState(() {
      isMinimized = true;
    });
  }

  @override
  void onWindowRestore() {
    setState(() {
      isMinimized = false;
    });
  }

  @override
  void onWindowMaximize() {
    setState(() {
      isMaximized = true;
    });
  }

  @override
  void onWindowUnmaximize() {
    setState(() {
      isMaximized = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (ref.watch(argumentsStateProvider.select((value) => value.htpcMode))) return const SizedBox.shrink();
    final theme = Theme.of(context);
    final brightness = widget.brightness ?? theme.brightness;
    final iconColor = theme.colorScheme.onSurface.withValues(alpha: 0.65);
    final isOffline = ref.watch(connectivityStatusProvider.select((value) => value == ConnectionState.offline));
    final surfaceColor = theme.colorScheme.surface;

    return ExcludeFocus(
      child: MouseRegion(
        onEnter: (event) => setState(() => hovering = true),
        onExit: (event) => setState(() => hovering = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: isOffline
                ? [
                    theme.colorScheme.errorContainer.withValues(alpha: 0.8),
                    theme.colorScheme.errorContainer.withValues(alpha: 0.25),
                  ]
                : [
                    surfaceColor.withValues(alpha: hovering ? 0.7 : 0),
                    surfaceColor.withValues(alpha: 0),
                  ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )),
          height: widget.height,
          child: kIsWeb
              ? const SizedBox.shrink()
              : Stack(
                  fit: StackFit.expand,
                  children: [
                    switch (AdaptiveLayout.of(context).platform) {
                      TargetPlatform.android ||
                      TargetPlatform.iOS =>
                        SizedBox(height: MediaQuery.paddingOf(context).top),
                      TargetPlatform.windows || TargetPlatform.linux => Container(
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  color: Colors.black.withValues(alpha: 0),
                                  child: DragToMoveArea(
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.only(left: 16),
                                          child: DefaultTextStyle(
                                            style: TextStyle(
                                              color: iconColor,
                                              fontSize: 14,
                                            ),
                                            child: Text(widget.label ?? ""),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(boxShadow: [
                                  BoxShadow(
                                    color: surfaceColor.withValues(alpha: isOffline ? 0 : 0.5),
                                    blurRadius: 32,
                                    spreadRadius: 10,
                                    offset: const Offset(8, -6),
                                  ),
                                ]),
                                child: Row(
                                  children: [
                                    IconButton(
                                      style: IconButton.styleFrom(
                                          hoverColor: brightness == Brightness.light
                                              ? Colors.black.withValues(alpha: 0.1)
                                              : Colors.white.withValues(alpha: 0.2),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2))),
                                      onPressed: () async {
                                        fullScreenHelper.closeFullScreen(ref);
                                        if (isMinimized) {
                                          windowManager.restore();
                                        } else {
                                          windowManager.minimize();
                                        }
                                      },
                                      icon: Transform.translate(
                                        offset: const Offset(0, -2),
                                        child: Icon(
                                          Icons.minimize_rounded,
                                          color: iconColor,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      style: IconButton.styleFrom(
                                        hoverColor: brightness == Brightness.light
                                            ? Colors.black.withValues(alpha: 0.1)
                                            : Colors.white.withValues(alpha: 0.2),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                                      ),
                                      onPressed: () async {
                                        fullScreenHelper.closeFullScreen(ref);
                                        if (isMaximized) {
                                          await windowManager.unmaximize();
                                          return;
                                        }
                                        if (!isMaximized) {
                                          await windowManager.maximize();
                                        } else {
                                          await windowManager.unmaximize();
                                        }
                                      },
                                      icon: Transform.translate(
                                        offset: const Offset(0, 0),
                                        child: Icon(
                                          isMaximized ? Icons.maximize_rounded : Icons.crop_square_rounded,
                                          color: iconColor,
                                          size: 19,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      style: IconButton.styleFrom(
                                        hoverColor: Colors.red,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(2),
                                        ),
                                      ),
                                      onPressed: () async {
                                        windowManager.close();
                                      },
                                      icon: Transform.translate(
                                        offset: const Offset(0, -2),
                                        child: Icon(
                                          Icons.close_rounded,
                                          color: iconColor,
                                          size: 23,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      TargetPlatform.macOS => const SizedBox.expand(),
                      _ => Text(widget.label ?? "Kebap"),
                    },
                    const OfflineBanner()
                  ],
                ),
        ),
      ),
    );
  }
}
