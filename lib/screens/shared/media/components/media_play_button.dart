import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kebap/models/item_base_model.dart';
import 'package:kebap/util/localization_helper.dart';

class MediaPlayButton extends ConsumerWidget {
  final ItemBaseModel? item;
  final Function(bool restart)? onPressed;
  final Function(bool restart)? onLongPressed;
  final FocusNode? focusNode;
  final bool autofocus;

  const MediaPlayButton({
    required this.item,
    this.onPressed,
    this.onLongPressed,
    this.focusNode,
    this.autofocus = false,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = (item?.progress ?? 0) / 100.0;
    final theme = Theme.of(context).colorScheme;

    // Use consistent padding logic matching SelectableIconButton
    // SelectableIconButton uses EdgeInsets.symmetric(vertical: 10) on content, zero on button
    // And implicit minimumSize form theme (usually 64x40)

    final buttonStyle = (Color bgColor, Color fgColor) => ButtonStyle(
      elevation: const WidgetStatePropertyAll(0),
      backgroundColor: WidgetStatePropertyAll(bgColor),
      iconColor: WidgetStatePropertyAll(fgColor),
      foregroundColor: WidgetStatePropertyAll(fgColor),
      padding: const WidgetStatePropertyAll(EdgeInsets.zero), // Use zero button padding
      // Remove fixed minimumSize to allow theme default (wider)
    );

    const contentPadding = EdgeInsets.symmetric(vertical: 10);
    const iconSize = 24.0;

    if (progress > 0) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          // Resume Button (Primary)
          Tooltip(
            message: context.localized.resumeLabel,
            child: Shortcuts(
              shortcuts: {
                const SingleActivator(LogicalKeyboardKey.arrowLeft): const DoNothingIntent(),
              },
              child: ElevatedButton(
                focusNode: focusNode,
                autofocus: autofocus,
                style: buttonStyle(theme.primaryContainer, theme.onPrimaryContainer),
                onPressed: onPressed == null ? null : () => onPressed?.call(false),
                onLongPress: onLongPressed == null ? null : () => onLongPressed?.call(false),
                child: const Padding(
                  padding: contentPadding,
                  child: Icon(Icons.replay, size: iconSize),
                ),
              ),
            ),
          ),
          // Play from Start Button (Secondary)
          Tooltip(
            message: context.localized.playFromStartLabel,
            child: ElevatedButton(
              style: buttonStyle(theme.surfaceContainerLow, theme.onSurface),
              onPressed: onPressed == null ? null : () => onPressed?.call(true),
              onLongPress: onLongPressed == null ? null : () => onLongPressed?.call(true),
              child: Padding(
                padding: contentPadding,
                child: Opacity(
                  opacity: 0.65,
                  child: const Icon(Icons.play_arrow, size: iconSize),
                ),
              ),
            ),
          ),
        ],
      );
    }

    // Default Play Button (No progress)
    return Tooltip(
      message: item?.playButtonLabel(context) ?? context.localized.playLabel,
      child: Shortcuts(
        shortcuts: {
          const SingleActivator(LogicalKeyboardKey.arrowLeft): const DoNothingIntent(),
        },
        child: ElevatedButton(
          focusNode: focusNode,
          autofocus: autofocus,
          style: buttonStyle(theme.primaryContainer, theme.onPrimaryContainer),
          onPressed: onPressed == null ? null : () => onPressed?.call(false),
          onLongPress: onLongPressed == null ? null : () => onLongPressed?.call(false),
          child: const Padding(
            padding: contentPadding,
            child: Icon(Icons.play_arrow, size: iconSize),
          ),
        ),
      ),
    );
  }
}

class _ProgressClipper extends CustomClipper<Rect> {
  final double progress;
  _ProgressClipper(this.progress);

  @override
  Rect getClip(Size size) {
    final w = (progress.clamp(0.0, 1.0) * size.width);
    return Rect.fromLTWH(0, 0, w, size.height);
  }

  @override
  bool shouldReclip(covariant _ProgressClipper old) => old.progress != progress;
}
