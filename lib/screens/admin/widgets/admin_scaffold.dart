import 'package:flutter/material.dart';

/// Simple scaffold wrapper for admin content pages (right side)
/// Does NOT include AppBar - just provides consistent padding and structure
class AdminScaffold extends StatelessWidget {
  final Widget child;
  
  const AdminScaffold({
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
