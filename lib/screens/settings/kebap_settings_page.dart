import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kebap/screens/settings/settings_scaffold.dart';

/// DEPRECATED: This page is being replaced by separate categorized settings pages:
/// - DashboardSettingsPage
/// - DetailsSettingsPage
/// - DownloadsSettingsPage
/// - LibrariesSettingsPage
/// - GeneralUiSettingsPage
/// - AdvancedSettingsPage

@RoutePage()
class KebapSettingsPage extends ConsumerWidget {
  const KebapSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SettingsScaffold(
      label: "Kebap Settings (Deprecated)",
      items: [
        Padding(
          padding: const EdgeInsets.all(32.0),
          child: Center(
            child: Text(
              'This page has been reorganized.\nPlease use the separate settings pages in the sidebar.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ),
      ],
    );
  }
}
