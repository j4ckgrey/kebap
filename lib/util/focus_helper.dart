import 'package:flutter/material.dart';

bool isEditableTextFocused() {
  final focus = FocusManager.instance.primaryFocus;
  if (focus == null) return false;
  final ctx = focus.context;
  if (ctx == null || !ctx.mounted) return false;

  if (ctx.widget is EditableText) return true;
  if (ctx.widget is TextField) return true;
  if (ctx.findAncestorWidgetOfExactType<EditableText>() != null) return true;
  if (ctx.findAncestorWidgetOfExactType<TextField>() != null) return true;
  
  return false;
}
