import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kebap/screens/shared/flat_button.dart';

class ChipButton extends ConsumerWidget {
  final String label;
  final Function()? onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  
  const ChipButton({
    required this.label, 
    this.onPressed, 
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      color: backgroundColor ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.15),
      shadowColor: Colors.transparent,
      shape: borderColor != null 
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: borderColor!, width: 1.5),
            )
          : null,
      child: FlatButton(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: foregroundColor,
            ),
          ),
        ),
      ),
    );
  }
}
