import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';

import 'package:kebap/screens/settings/widgets/settings_left_pane.dart';

// Screen that renders the settings selection list on mobile
@RoutePage()
class SettingsSelectionScreen extends StatelessWidget {
  const SettingsSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsLeftPane(activeRouteName: "");
  }
}
