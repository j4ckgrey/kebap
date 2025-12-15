import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kebap/providers/shared_provider.dart';
import 'package:kebap/routes/auto_router.gr.dart';
import 'package:kebap/screens/settings/client_sections/client_settings_advanced.dart';
import 'package:kebap/screens/settings/client_sections/client_settings_shortcuts.dart';
import 'package:kebap/screens/settings/settings_list_tile.dart';
import 'package:kebap/screens/settings/settings_scaffold.dart';
import 'package:kebap/util/adaptive_layout/adaptive_layout.dart';
import 'package:kebap/util/localization_helper.dart';

@RoutePage()
class AdvancedSettingsPage extends ConsumerWidget {
  const AdvancedSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDesktop = AdaptiveLayout.inputDeviceOf(context) != InputDevice.touch;

    return SettingsScaffold(
      label: "Advanced",
      items: [
        if (isDesktop) ...[
          ...buildClientSettingsShortCuts(context, ref),
          const SizedBox(height: 12),
        ],
        ...buildClientSettingsAdvanced(context, ref),
        if (kDebugMode) ...[
          const SizedBox(height: 64),
          SettingsListTile(
            label: const Text("Clear cache"),
            contentColor: Theme.of(context).colorScheme.error,
            onTap: () {
              PaintingBinding.instance.imageCache.clear();
            },
          ),
          SettingsListTile(
            label: Text(context.localized.clearAllSettings),
            contentColor: Theme.of(context).colorScheme.error,
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => Dialog(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          context.localized.clearAllSettingsQuestion,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        Text(context.localized.unableToReverseAction),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FilledButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text(context.localized.cancel),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () async {
                                await ref.read(sharedPreferencesProvider).clear();
                                context.router.push(const LoginRoute());
                              },
                              child: Text(context.localized.clear),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ],
    );
  }
}
