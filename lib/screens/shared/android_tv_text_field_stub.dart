import 'package:flutter/material.dart';

/// Stub implementation for non-Android platforms
/// This file is used when dart.library.io is not available
Widget buildAndroidTvTextField({
  TextEditingController? controller,
  FocusNode? focusNode,
  bool autofocus = false,
  Function(String)? onChanged,
  Function(String)? onSubmitted,
  TextInputType? keyboardType,
  TextInputAction? textInputAction,
  InputDecoration? decoration,
}) {
  // This should never be called on non-Android platforms
  // but we provide a fallback just in case
  throw UnsupportedError('AndroidTvTextField is only supported on Android');
}
