import 'package:flutter/material.dart';

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

    if (progress > 0) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          // Resume Button (Primary)
          Tooltip(
            message: context.localized.resumeLabel,
            child: ElevatedButton(
              focusNode: focusNode,
              autofocus: autofocus,
              style: ButtonStyle(
                elevation: const WidgetStatePropertyAll(0),
                backgroundColor: WidgetStatePropertyAll(theme.primaryContainer),
                iconColor: WidgetStatePropertyAll(theme.onPrimaryContainer),
                foregroundColor: WidgetStatePropertyAll(theme.onPrimaryContainer),
                padding: const WidgetStatePropertyAll(EdgeInsets.all(12)),
                minimumSize: const WidgetStatePropertyAll(Size(48, 48)),
              ),
              onPressed: onPressed == null ? null : () => onPressed?.call(false),
              onLongPress: onLongPressed == null ? null : () => onLongPressed?.call(false),
              child: const Icon(Icons.replay, size: 24),
            ),
          ),
          // Play from Start Button (Secondary)
          Tooltip(
            message: context.localized.playFromStartLabel,
            child: ElevatedButton(
              style: ButtonStyle(
                elevation: const WidgetStatePropertyAll(0),
                backgroundColor: WidgetStatePropertyAll(theme.surfaceContainerLow),
                padding: const WidgetStatePropertyAll(EdgeInsets.all(12)),
                minimumSize: const WidgetStatePropertyAll(Size(48, 48)),
              ),
              onPressed: onPressed == null ? null : () => onPressed?.call(true),
              onLongPress: onLongPressed == null ? null : () => onLongPressed?.call(true),
              child: Opacity(
                opacity: 0.65,
                child: const Icon(Icons.play_arrow, size: 24),
              ),
            ),
          ),
        ],
      );
    }

    // Default Play Button (No progress)
    return Tooltip(
      message: item?.playButtonLabel(context) ?? context.localized.playLabel,
      child: ElevatedButton(
        focusNode: focusNode,
        autofocus: autofocus,
        style: ButtonStyle(
          elevation: const WidgetStatePropertyAll(0),
          backgroundColor: WidgetStatePropertyAll(theme.primaryContainer),
          iconColor: WidgetStatePropertyAll(theme.onPrimaryContainer),
          foregroundColor: WidgetStatePropertyAll(theme.onPrimaryContainer),
          padding: const WidgetStatePropertyAll(EdgeInsets.all(12)),
          minimumSize: const WidgetStatePropertyAll(Size(48, 48)),
        ),
        onPressed: onPressed == null ? null : () => onPressed?.call(false),
        onLongPress: onLongPressed == null ? null : () => onLongPressed?.call(false),
        child: const Icon(Icons.play_arrow, size: 24),
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
