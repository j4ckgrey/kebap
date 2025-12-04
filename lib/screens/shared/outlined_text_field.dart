import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kebap/providers/settings/client_settings_provider.dart';
import 'package:kebap/screens/shared/animated_fade_size.dart';
import 'package:kebap/theme.dart';
import 'package:kebap/util/adaptive_layout/adaptive_layout.dart';
import 'package:kebap/widgets/keyboard/slide_in_keyboard.dart';
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

const acceptKeys = [
  LogicalKeyboardKey.select,
  LogicalKeyboardKey.enter,
  LogicalKeyboardKey.space,
  LogicalKeyboardKey.numpadEnter,
  LogicalKeyboardKey.gameButtonA,
];

class _OutlinedTextFieldState extends ConsumerState<OutlinedTextField> {
  late final controller = widget.controller ?? TextEditingController();
  late final FocusNode _textFocus = widget.focusNode ?? FocusNode();
  late final FocusNode _wrapperFocus = FocusNode();

  bool hasFocus = false;
  bool keyboardFocus = false;

  @override
  void dispose() {
    // Only dispose if we created it, but we can't easily know that here if we assigned it to a late final.
    // Actually, if widget.focusNode is null, we created it.
    if (widget.focusNode == null) {
      _textFocus.dispose();
    }
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

  KeyEventResult _onTextFocusKey(FocusNode node, KeyEvent event) {
    // On TV/D-pad devices, we MUST let the System (IME) handle navigation keys.
    // Flutter consumes them by default, breaking the System Keyboard navigation.
    // We check for D-pad input type.
    final isDPad = AdaptiveLayout.inputDeviceOf(context) == InputDevice.dPad;
    
    if (event is KeyDownEvent) {
    }

    if (isDPad && event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowUp ||
          event.logicalKey == LogicalKeyboardKey.arrowDown ||
          event.logicalKey == LogicalKeyboardKey.arrowLeft ||
          event.logicalKey == LogicalKeyboardKey.arrowRight ||
          event.logicalKey == LogicalKeyboardKey.select ||
          event.logicalKey == LogicalKeyboardKey.enter ||
          event.logicalKey == LogicalKeyboardKey.numpadEnter ||
          event.logicalKey == LogicalKeyboardKey.gameButtonA) {
            return KeyEventResult.skipRemainingHandlers;
      }
    }
    return KeyEventResult.ignored;
  }


  @override
  void initState() {
    super.initState();
    // Attach our key event handler to the focus node (whether passed or created)
    _textFocus.onKeyEvent = _onTextFocusKey;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final useCustomKeyboard = (AdaptiveLayout.inputDeviceOf(context) == InputDevice.dPad || widget.useFocusWrapper) &&
          ref.read(clientSettingsProvider.select((value) => !value.useSystemIME));
      if (widget.autoFocus) {
        _wrapperFocus.requestFocus();
      }
      _textFocus.addListener(() {
        if (mounted) setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final isPasswordField = widget.keyboardType == TextInputType.visiblePassword;
    final useCustomKeyboard = (AdaptiveLayout.inputDeviceOf(context) == InputDevice.dPad || widget.useFocusWrapper) &&
        ref.watch(clientSettingsProvider.select((value) => !value.useSystemIME));

    final textField = TextField(
      controller: controller,
      onChanged: widget.onChanged,
      focusNode: _textFocus,
      onTap: widget.onTap,
      readOnly: useCustomKeyboard,
      autofillHints: widget.autoFillHints,
      keyboardType: widget.keyboardType,
      autocorrect: widget.autocorrect,
      onSubmitted: (value) {
        widget.onSubmitted?.call(value);
        Future.microtask(() async {
          await Future.delayed(const Duration(milliseconds: 125));
          if (mounted) _wrapperFocus.requestFocus();
        });
      },
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

    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 175),
          decoration: BoxDecoration(
            color: widget.decoration == null ? widget.fillColor ?? getColor() : null,
            borderRadius: KebapTheme.smallShape.borderRadius,
            border: BoxBorder.all(
              width: 2,
              color: hasFocus || keyboardFocus || _textFocus.hasFocus
                  ? Theme.of(context).colorScheme.primaryFixed
                  : Colors.transparent,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: IgnorePointer(
              ignoring: widget.enabled == false,
              child: Focus(
                focusNode: _wrapperFocus,
                canRequestFocus: true,
                skipTraversal: false,
                onFocusChange: (value) {
                  setState(() {
                    hasFocus = value;
                  });
                },
                onKeyEvent: (node, event) {
                  if (keyboardFocus || AdaptiveLayout.inputDeviceOf(context) != InputDevice.dPad) return KeyEventResult.ignored;
                  if (event is KeyDownEvent && acceptKeys.contains(event.logicalKey)) {
                    if (_textFocus.hasFocus) {
                      // If using System IME, we must NOT consume Select/Enter here.
                      // We must let it bubble to the System so the user can click keys on the soft keyboard.
                      if (!useCustomKeyboard) {
                         print('[LAG_DEBUG] _wrapperFocus skipping ${event.logicalKey.keyLabel} for System IME');
                         return KeyEventResult.skipRemainingHandlers;
                      }
                      _wrapperFocus.requestFocus();
                      return KeyEventResult.handled;
                    } else if (_wrapperFocus.hasFocus) {
                      if (useCustomKeyboard) {
                        // We need to handle the async operation but return a result synchronously
                        // Using a future here to trigger the keyboard opening
                        Future(() async {
                          await openKeyboard(
                            context,
                            controller,
                            inputType: widget.keyboardType,
                            inputAction: widget.textInputAction,
                            searchQuery: widget.searchQuery,
                            onChanged: () {
                              widget.onChanged?.call(controller.text);
                            },
                          );
                          widget.onSubmitted?.call(controller.text);
                          if (context.mounted) {
                             setState(() {
                               keyboardFocus = false;
                             });
                             _wrapperFocus.requestFocus();
                          }
                        });
                        return KeyEventResult.handled;
                      } else {
                        _textFocus.requestFocus();
                        return KeyEventResult.handled;
                      }
                    }
                  }
                  return KeyEventResult.ignored;
                },
                child: ExcludeFocusTraversal(child: textField),
              ),
            ),
          ),
          ),
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

