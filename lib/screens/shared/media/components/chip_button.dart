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
      color: backgroundColor ?? Theme.of(context).colorScheme.onSurface,
      shadowColor: Colors.transparent,
      child: FlatButton(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: foregroundColor ?? Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
