import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import 'package:kebap/models/item_base_model.dart';
import 'package:kebap/screens/shared/animated_fade_size.dart';
import 'package:kebap/util/adaptive_layout/adaptive_layout.dart';
import 'package:kebap/util/focus_provider.dart';
import 'package:kebap/util/localization_helper.dart';
import 'package:kebap/widgets/shared/ensure_visible.dart';

class MediaPlayButton extends ConsumerWidget {
  final ItemBaseModel? item;
  final Function(bool restart)? onPressed;
  final Function(bool restart)? onLongPressed;

  const MediaPlayButton({
    required this.item,
    this.onPressed,
    this.onLongPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = (item?.progress ?? 0) / 100.0;
    final theme = Theme.of(context);

    if (progress > 0) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          // Resume Button (Primary)
          FilledButton(
            onPressed: onPressed == null ? null : () => onPressed?.call(false),
            onLongPress: onLongPressed == null ? null : () => onLongPressed?.call(false),
            child: Text(context.localized.resumeLabel),
          ),
          // Play from Start Button (Secondary)
          FilledButton(
            onPressed: onPressed == null ? null : () => onPressed?.call(true),
            onLongPress: onLongPressed == null ? null : () => onLongPressed?.call(true),
            child: Text(context.localized.playFromStartLabel),
          ),
        ],
      );
    }

    // Default Play Button (No progress)
    return FilledButton.icon(
      onPressed: onPressed == null ? null : () => onPressed?.call(false),
      onLongPress: onLongPressed == null ? null : () => onLongPressed?.call(false),
      icon: const Icon(IconsaxPlusBold.play),
      label: Text(item?.playButtonLabel(context) ?? context.localized.playLabel),
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
