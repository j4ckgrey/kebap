import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kebap/providers/settings/client_settings_provider.dart';
import 'package:kebap/screens/settings/client_sections/client_settings_theme.dart';
import 'package:kebap/screens/settings/settings_list_tile.dart';
import 'package:kebap/screens/settings/settings_scaffold.dart';
import 'package:kebap/screens/settings/widgets/settings_label_divider.dart';
import 'package:kebap/screens/settings/widgets/settings_list_group.dart';
import 'package:kebap/util/adaptive_layout/adaptive_layout.dart';
import 'package:kebap/util/localization_helper.dart';
import 'package:kebap/util/simple_duration_picker.dart';

@RoutePage()
class GeneralUiSettingsPage extends ConsumerWidget {
  const GeneralUiSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clientSettings = ref.watch(clientSettingsProvider);
    final isPointer = AdaptiveLayout.inputDeviceOf(context) == InputDevice.pointer;

    return SettingsScaffold(
      label: "General UI",
      items: [
        ...buildClientSettingsTheme(context, ref),
        const SizedBox(height: 12),
        ...settingsListGroup(context, SettingsLabelDivider(label: context.localized.lockscreen), [
          SettingsListTile(
            label: const Text("Show Clock"),
            subLabel: const Text("Show the current time in the top right corner"),
            onTap: () => ref.read(clientSettingsProvider.notifier).setShowClock(!clientSettings.showClock),
            trailing: Switch(
              value: clientSettings.showClock,
              onChanged: (value) => ref.read(clientSettingsProvider.notifier).setShowClock(value),
            ),
          ),
          if (clientSettings.showClock)
            SettingsListTile(
              label: const Text("Use 12-Hour Format"),
              subLabel: const Text("Display time in 12-hour format (AM/PM)"),
              onTap: () => ref.read(clientSettingsProvider.notifier).setUse12HourClock(!clientSettings.use12HourClock),
              trailing: Switch(
                value: clientSettings.use12HourClock,
                onChanged: (value) => ref.read(clientSettingsProvider.notifier).setUse12HourClock(value),
              ),
            ),
          SettingsListTile(
            label: Text(context.localized.timeOut),
            subLabel: Text(timePickerString(context, clientSettings.timeOut)),
            onTap: () async {
              final timePicker = await showSimpleDurationPicker(
                context: context,
                initialValue: clientSettings.timeOut ?? const Duration(),
              );

              if (timePicker == null) return;

              ref.read(clientSettingsProvider.notifier).setTimeOut(timePicker != Duration.zero
                  ? Duration(minutes: timePicker.inMinutes, seconds: timePicker.inSeconds % 60)
                  : null);
            },
          ),
        ]),
        if (isPointer) ...[
          const SizedBox(height: 12),
          ...settingsListGroup(context, SettingsLabelDivider(label: context.localized.controls), [
            SettingsListTile(
              label: Text(context.localized.mouseDragSupport),
              subLabel: Text(clientSettings.mouseDragSupport ? context.localized.enabled : context.localized.disabled),
              onTap: () => ref
                  .read(clientSettingsProvider.notifier)
                  .update((current) => current.copyWith(mouseDragSupport: !clientSettings.mouseDragSupport)),
              trailing: Switch(
                value: clientSettings.mouseDragSupport,
                onChanged: (value) => ref
                    .read(clientSettingsProvider.notifier)
                    .update((current) => current.copyWith(mouseDragSupport: !clientSettings.mouseDragSupport)),
              ),
            ),
          ]),
        ],
      ],
    );
  }
}
