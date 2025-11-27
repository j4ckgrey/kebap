import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kebap/providers/search_mode_provider.dart';

class SearchModeToggle extends ConsumerWidget {
  const SearchModeToggle({
    super.key,
    this.onModeChanged,
    this.focusNode,
    this.searchBarFocusNode,
    this.filterChipsKey,
  });

  final VoidCallback? onModeChanged;
  final FocusNode? focusNode;
  final FocusNode? searchBarFocusNode;
  final GlobalKey? filterChipsKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchMode = ref.watch(searchModeNotifierProvider);
    final isLocalMode = searchMode == SearchMode.local;

    return SizedBox.square(
      dimension: 55.0, // Match toolbarHeight
      child: Card(
        elevation: 0,
        child: Focus(
          focusNode: focusNode,
          onKeyEvent: (node, event) {
            if (event is KeyDownEvent) {
              if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
                searchBarFocusNode?.requestFocus();
                return KeyEventResult.handled;
              }
              if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
                // Navigate to first filter chip
                final filterChipsContext = filterChipsKey?.currentContext;
                if (filterChipsContext != null) {
                  final scope = FocusScope.of(filterChipsContext);
                  final firstChild = scope.children.firstOrNull;
                  firstChild?.requestFocus();
                }
                return KeyEventResult.handled;
              }
            }
            return KeyEventResult.ignored;
          },
          child: Tooltip(
            message: searchMode.displayName,
            child: IconButton(
              onPressed: () {
                ref.read(searchModeNotifierProvider.notifier).toggleMode();
                onModeChanged?.call();
              },
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(
                      scale: animation,
                      child: child,
                    ),
                  );
                },
                child: Stack(
                  key: ValueKey(isLocalMode),
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      Icons.public,
                      size: 24,
                      color: isLocalMode
                          ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.85)
                          : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                    if (isLocalMode)
                      Positioned.fill(
                        child: CustomPaint(
                          painter: _SlashPainter(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SlashPainter extends CustomPainter {
  _SlashPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    // Draw diagonal slash from top-left to bottom-right
    final start = Offset(size.width * 0.15, size.height * 0.15);
    final end = Offset(size.width * 0.85, size.height * 0.85);

    canvas.drawLine(start, end, paint);
  }

  @override
  bool shouldRepaint(_SlashPainter oldDelegate) => color != oldDelegate.color;
}
