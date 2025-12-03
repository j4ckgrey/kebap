import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kebap/providers/settings/client_settings_provider.dart';
import 'package:kebap/screens/shared/animated_fade_size.dart';
import 'package:kebap/theme.dart';
import 'package:kebap/util/adaptive_layout/adaptive_layout.dart';
import 'package:kebap/util/focus_provider.dart';
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
  final Function()? onDown;

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
    this.onDown,
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
  late final FocusNode _textFocus = (widget.focusNode ?? FocusNode())..addListener(_onFocusChange);
  late final FocusNode _wrapperFocus = FocusNode()..addListener(_onFocusChange);

  void _onFocusChange() {
    if (!mounted) return;
    final newHasFocus = _wrapperFocus.hasFocus || _textFocus.hasFocus;
    if (hasFocus != newHasFocus) {
      setState(() {
        hasFocus = newHasFocus;
      });
      if (hasFocus) {
        context.ensureVisible();
      }
    }
  }

  bool hasFocus = false;
  bool _isEditing = false;
  bool keyboardFocus = false;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    controller.addListener(_onTextChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (widget.autoFocus) {
        final isDpad = AdaptiveLayout.inputDeviceOf(context) == InputDevice.dPad;
        final isWrapperMode = isDpad || widget.useFocusWrapper;
        if (isWrapperMode) {
          _wrapperFocus.requestFocus();
        } else {
          _textFocus.requestFocus();
        }
      }
    });
  }

  void _onTextChanged() {
    if (!mounted) return;
    setState(() {
      _isEditing = controller.text.isNotEmpty;
    });
  }

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
  void dispose() {
    controller.removeListener(_onTextChanged);
    if (widget.focusNode == null) _textFocus.dispose();
    _wrapperFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPasswordField = widget.keyboardType == TextInputType.visiblePassword;
    final isDpad = AdaptiveLayout.inputDeviceOf(context) == InputDevice.dPad;
    final useSystemIME = ref.watch(clientSettingsProvider.select((value) => value.useSystemIME));
    
    // Custom Keyboard is only used if we are on D-pad AND System IME is disabled.
    final useCustomKeyboard = isDpad && !useSystemIME;

    // Wrapper Mode is active if:
    // 1. We are on D-pad (TV behavior).
    // 2. OR it is explicitly requested (Settings fields).
    final isWrapperMode = isDpad || widget.useFocusWrapper;

    // We show the actual TextField ONLY if:
    // 1. We are NOT in wrapper mode (Standard Desktop behavior).
    // 2. OR we are in wrapper mode AND we are currently editing.
    // 3. AND we are NOT using a custom keyboard (Custom keyboard uses dialog, never inline TextField).
    final showTextField = (!isWrapperMode || _isEditing) && !useCustomKeyboard;

    final inputDecoration = widget.decoration ??
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
          );

    final childWidget = showTextField
        ? CallbackShortcuts(
            bindings: {
              const SingleActivator(LogicalKeyboardKey.arrowDown): () {
                widget.onDown?.call();
              },
            },
            child: TextField(
              controller: controller,
              onChanged: widget.onChanged,
              focusNode: _textFocus,
              onTap: widget.onTap,
              // If we are showing the TextField, it should be editable.
              readOnly: false,
              autofillHints: widget.autoFillHints,
              keyboardType: widget.keyboardType,
              autocorrect: widget.autocorrect,
              onSubmitted: widget.onSubmitted != null
                  ? (value) {
                      widget.onSubmitted?.call(value);
                      Future.microtask(() async {
                        await Future.delayed(const Duration(milliseconds: 125));
                        _wrapperFocus.requestFocus();
                      });
                    }
                  : null,
              textInputAction: widget.textInputAction,
              obscureText: isPasswordField ? _obscureText : false,
              style: widget.style,
              maxLines: widget.maxLines,
              inputFormatters: widget.inputFormatters,
              textAlign: widget.textAlign,
              canRequestFocus: true,
              enableInteractiveSelection: !isDpad,
              decoration: inputDecoration,
              autofocus: _isEditing,
            ),
          )
        : InkWell(
            borderRadius: KebapTheme.smallShape.borderRadius as BorderRadius?,
            onTap: () {
              // Handle Tap on Static Text
              if (widget.enabled == false) return;
              
              if (useCustomKeyboard) {
                // Open Custom Keyboard
                _handleCustomKeyboard();
              } else {
                // Enter Edit Mode
                setState(() {
                  _isEditing = true;
                });
                Future.delayed(const Duration(milliseconds: 50), () {
                  _textFocus.requestFocus();
                });
              }
            },
            child: InputDecorator(
              decoration: inputDecoration,
              child: Text(
                isPasswordField && _obscureText ? '•' * controller.text.length : controller.text,
                style: widget.style,
                maxLines: widget.maxLines,
                textAlign: widget.textAlign,
              ),
            ),
          );

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            if (!_textFocus.hasFocus) {
              _textFocus.requestFocus();
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 175),
            decoration: BoxDecoration(
              color: widget.decoration == null ? widget.fillColor ?? getColor() : null,
              borderRadius: KebapTheme.smallShape.borderRadius,
              border: Border.all(
                width: 2,
                color: hasFocus || keyboardFocus ? Theme.of(context).colorScheme.primaryFixed : Colors.transparent,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: IgnorePointer(
                ignoring: widget.enabled == false,
                  child: Focus(
                    focusNode: _wrapperFocus,
                    onKeyEvent: (node, event) {
                      // If we are NOT in wrapper mode, we don't handle keys here (let TextField handle them).
                      // BUT if showTextField is false (e.g. false positive dPad), we MUST handle keys/focus.
                      if (!isWrapperMode && showTextField) {
                        return KeyEventResult.ignored;
                      }
  
                      if (event is KeyDownEvent) {
                        // Enter Edit Mode / Open Keyboard on Select
                        if (acceptKeys.contains(event.logicalKey)) {
                           if (useCustomKeyboard) {
                             _handleCustomKeyboard();
                             return KeyEventResult.handled;
                           } else if (!_isEditing) {
                             setState(() {
                               _isEditing = true;
                             });
                             // Force focus to the text field with a delay
                             Future.delayed(const Duration(milliseconds: 50), () {
                               _textFocus.requestFocus();
                             });
                             return KeyEventResult.handled;
                           }
                        }
                        
                        // Exit Edit Mode on Back or Escape
                        if ((event.logicalKey == LogicalKeyboardKey.escape ||
                                event.logicalKey == LogicalKeyboardKey.goBack) &&
                            _isEditing) {
                          setState(() {
                            _isEditing = false;
                          });
                          _wrapperFocus.requestFocus();
                          return KeyEventResult.handled;
                        }
                      }
                      return KeyEventResult.ignored;
                    },
                    child: ExcludeFocusTraversal(
                      // Exclude child from traversal if we are in "View Mode" (showTextField is false)
                      // OR if we are using custom keyboard.
                      excluding: isWrapperMode, 
                      child: childWidget,
                    ),
                  ),
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

  void _handleCustomKeyboard() {
    openKeyboard(
      context,
      controller,
      inputType: widget.keyboardType,
      inputAction: widget.textInputAction,
      searchQuery: widget.searchQuery,
      onChanged: () {
        widget.onChanged?.call(controller.text);
      },
    ).then((result) {
      if (result == true) {
        widget.onSubmitted?.call(controller.text);
      }
      setState(() {
        keyboardFocus = false;
      });
      _wrapperFocus.requestFocus();
    });
  }
}

