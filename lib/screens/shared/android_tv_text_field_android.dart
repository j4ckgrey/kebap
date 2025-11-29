import 'package:flutter/material.dart';
import 'package:flutter_android_tv_text_field/flutter_android_tv_text_field.dart';

/// Android-specific implementation that uses the native Android TV TextField
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
  return AndroidTvTextField(
    controller: controller,
    focusNode: focusNode,
    autofocus: autofocus,
    onChanged: onChanged,
    onSubmitted: onSubmitted,
    keyboardType: keyboardType,
    textInputAction: textInputAction,
    decoration: decoration,
  );
}
