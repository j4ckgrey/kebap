import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kebap/providers/settings/client_settings_provider.dart';
import 'package:kebap/screens/shared/outlined_text_field.dart';
import 'package:kebap/util/adaptive_layout/adaptive_layout.dart';

/// Adaptive TextField that uses custom keyboard on TV (like original Fladder)
/// The flutter_android_tv_text_field package didn't work, so we're using
/// the proven custom keyboard approach.
class AdaptiveTextField extends ConsumerStatefulWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? label;
  final String? placeHolder;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final FutureOr<List<String>> Function(String query)? searchQuery;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool autoFocus;
  final InputDecoration? decoration;
  final bool useFocusWrapper;

  const AdaptiveTextField({
    this.controller,
    this.focusNode,
    this.label,
    this.placeHolder,
    this.onChanged,
    this.onSubmitted,
    this.searchQuery,
    this.keyboardType,
    this.textInputAction,
    this.autoFocus = false,
    this.decoration,
    this.useFocusWrapper = false,
    super.key,
  });

  @override
  ConsumerState<AdaptiveTextField> createState() => _AdaptiveTextFieldState();
}

class _AdaptiveTextFieldState extends ConsumerState<AdaptiveTextField> {
  late final TextEditingController controller = widget.controller ?? TextEditingController();
  late final FocusNode focusNode = widget.focusNode ?? FocusNode();

  @override
  Widget build(BuildContext context) {
    // Check if we should use custom keyboard (TV with d-pad)
    final useCustomKeyboard = !kIsWeb &&
        !kIsWeb && Platform.isAndroid &&
        AdaptiveLayout.inputDeviceOf(context) == InputDevice.dPad &&
        !ref.watch(clientSettingsProvider.select((value) => value.useSystemIME));

    // Use OutlinedTextField which has the custom keyboard logic built-in
    return OutlinedTextField(
      controller: controller,
      focusNode: focusNode,
      label: widget.label,
      placeHolder: widget.placeHolder,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      searchQuery: widget.searchQuery,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      autoFocus: widget.autoFocus,
      decoration: widget.decoration,
      useFocusWrapper: widget.useFocusWrapper || useCustomKeyboard,
    );
  }
}
