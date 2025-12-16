import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';

import 'package:kebap/screens/admin/widgets/admin_left_pane.dart';

// Screen that renders the admin selection list on mobile
@RoutePage()
class AdminSelectionScreen extends StatelessWidget {
  const AdminSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminLeftPane(activeRouteName: "");
  }
}
