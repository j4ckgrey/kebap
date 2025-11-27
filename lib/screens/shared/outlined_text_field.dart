import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kebap/providers/settings/client_settings_provider.dart';
import 'package:kebap/screens/shared/animated_fade_size.dart';
import 'package:kebap/theme.dart';
import 'package:kebap/util/adaptive_layout/adaptive_layout.dart';
import 'package:kebap/util/focus_provider.dart';
import 'package:kebap/widgets/shared/ensure_visible.dart';

class OutlinedTextField extends ConsumerStatefulWidget {
  final String? label;
  final FocusNode? focusNode;
  final bool autoFocus;
  final TextEditingController? controller;
  final int maxLines;
  final Function()? onTap;
  final Function(String value)? onChanged;
  final Function(String value)? onSubmitted;
  final FutureOr<List<String>> Function(String query)? searchQuery;
  final List<String>? autoFillHints;
  final List<TextInputFormatter>? inputFormatters;
  final bool autocorrect;
  final TextStyle? style;
  final double borderWidth;
  final Color? fillColor;
  final TextAlign textAlign;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final InputDecoration? decoration;
  final String? placeHolder;
  final String? suffix;
  final String? errorText;
  final bool? enabled;
  final bool useFocusWrapper;

  const OutlinedTextField({
    this.label,
    this.focusNode,
    this.autoFocus = false,
    this.controller,
    this.maxLines = 1,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.searchQuery,
    this.fillColor,
    this.style,
    this.borderWidth = 1,
    this.textAlign = TextAlign.start,
    this.autoFillHints,
    this.inputFormatters,
    this.autocorrect = true,
    this.keyboardType,
    this.textInputAction,
    this.errorText,
    this.placeHolder,
    this.decoration,
    this.suffix,
    this.enabled,
    this.useFocusWrapper = false,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OutlinedTextFieldState();
}

class _OutlinedTextFieldState extends ConsumerState<OutlinedTextField> {
  late final controller = widget.controller ?? TextEditingController();
  late final FocusNode _textFocus = widget.focusNode ?? FocusNode();
  late final FocusNode _wrapperFocus = FocusNode()
    ..addListener(() {
      setState(() {
        hasFocus = _wrapperFocus.hasFocus;
        if (hasFocus) {
          context.ensureVisible();
        }
      });
    });

  bool hasFocus = false;
  bool keyboardFocus = false;

  @override
  void dispose() {
    if (widget.focusNode == null) _textFocus.dispose();
    _wrapperFocus.dispose();
    super.dispose();
  }

  bool _obscureText = true;
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Color getColor() {
    if (widget.errorText != null) return Theme.of(context).colorScheme.errorContainer;
    return Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.35);
  }

  @override
  void initState() {
    super.initState();
    if (widget.useFocusWrapper) {
      _textFocus.skipTraversal = true;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (widget.autoFocus) {
        if (widget.useFocusWrapper) {
          _wrapperFocus.requestFocus();
        } else {
          _textFocus.requestFocus();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isPasswordField = widget.keyboardType == TextInputType.visiblePassword;


    final textField = TextField(
      controller: controller,
      onChanged: widget.onChanged,
      focusNode: _textFocus,
      onTap: widget.onTap,
      autofillHints: widget.autoFillHints,
      keyboardType: widget.keyboardType,
      autocorrect: widget.autocorrect,
      onSubmitted: widget.onSubmitted != null
          ? (value) {
              widget.onSubmitted?.call(value);
            }
          : null,
      textInputAction: widget.textInputAction,
      obscureText: isPasswordField ? _obscureText : false,
      style: widget.style,
      maxLines: widget.maxLines,
      inputFormatters: widget.inputFormatters,
      textAlign: widget.textAlign,
      canRequestFocus: true,
      decoration: widget.decoration ??
          InputDecoration(
            border: InputBorder.none,
            filled: widget.fillColor != null,
            fillColor: widget.fillColor,
            labelText: widget.label,
            suffix: widget.suffix != null
                ? Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Text(widget.suffix!),
                  )
                : null,
            hintText: widget.placeHolder,
            // errorText: widget.errorText,
            suffixIcon: isPasswordField
                ? InkWell(
                    onTap: _toggle,
                    borderRadius: BorderRadius.circular(5),
                    child: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                      size: 16.0,
                    ),
                  )
                : null,
          ),
    );

    final container = AnimatedContainer(
      duration: const Duration(milliseconds: 175),
      decoration: BoxDecoration(
        color: widget.decoration == null ? widget.fillColor ?? getColor() : null,
        borderRadius: KebapTheme.smallShape.borderRadius,
        border: BoxBorder.all(
          width: 2,
          color: hasFocus || keyboardFocus ? Theme.of(context).colorScheme.primaryFixed : Colors.transparent,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: IgnorePointer(
          ignoring: widget.enabled == false,
          child: textField,
        ),
      ),
    );

    return Column(
      children: [
        if (widget.useFocusWrapper)
          Focus(
            focusNode: _wrapperFocus,
            onKeyEvent: (node, event) {
              if (event is KeyDownEvent &&
                  (event.logicalKey == LogicalKeyboardKey.select ||
                      event.logicalKey == LogicalKeyboardKey.enter)) {
                _textFocus.requestFocus();
                return KeyEventResult.handled;
              }
              return KeyEventResult.ignored;
            },
            child: container,
          )
        else
          container,
        AnimatedFadeSize(
          child: widget.errorText != null
              ? Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.errorText ?? "",
                    style:
                        Theme.of(context).textTheme.labelMedium?.copyWith(color: Theme.of(context).colorScheme.error),
                  ),
                )
              : Container(),
        ),
      ],
    );
  }
}
