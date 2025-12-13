import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kebap/providers/settings/client_settings_provider.dart';
import 'package:kebap/providers/settings/media_stream_view_type_provider.dart';
import 'package:kebap/providers/settings/kebap_settings_provider.dart';
import 'package:kebap/models/settings/media_stream_view_type.dart';
import 'package:kebap/providers/shared_provider.dart';
import 'package:kebap/widgets/shared/enum_selection.dart';
import 'package:kebap/widgets/shared/item_actions.dart';
import 'package:kebap/routes/auto_router.gr.dart';
import 'package:kebap/screens/settings/client_sections/client_settings_advanced.dart';
import 'package:kebap/screens/settings/client_sections/client_settings_dashboard.dart';
import 'package:kebap/screens/settings/client_sections/client_settings_download.dart';
import 'package:kebap/screens/settings/client_sections/client_settings_shortcuts.dart';
import 'package:kebap/screens/settings/client_sections/client_settings_theme.dart';
import 'package:kebap/screens/settings/client_sections/client_settings_visual.dart';
import 'package:kebap/screens/settings/settings_list_tile.dart';
import 'package:kebap/screens/settings/settings_scaffold.dart';
import 'package:kebap/screens/settings/widgets/settings_label_divider.dart';
import 'package:kebap/screens/settings/widgets/settings_list_group.dart';
import 'package:kebap/screens/shared/adaptive_text_field.dart';
import 'package:kebap/util/adaptive_layout/adaptive_layout.dart';
import 'package:kebap/util/localization_helper.dart';
import 'package:kebap/util/simple_duration_picker.dart';

@RoutePage()
class ClientSettingsPage extends ConsumerStatefulWidget {
  const ClientSettingsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ClientSettingsPageState();
}

class _ClientSettingsPageState extends ConsumerState<ClientSettingsPage> {
  late final nextUpDaysEditor = TextEditingController(
      text: ref.read(clientSettingsProvider.select((value) => value.nextUpDateCutoff?.inDays ?? 14)).toString());

  late final libraryPageSizeController = TextEditingController(
      text: ref.read(clientSettingsProvider.select((value) => value.libraryPageSize))?.toString() ?? "");

  late final tmdbApiKeyController = TextEditingController(
      text: ref.read(kebapSettingsProvider.select((value) => value.tmdbApiKey)) ?? "");

  @override
  Widget build(BuildContext context) {
    final clientSettings = ref.watch(clientSettingsProvider);

    return SettingsScaffold(
      label: "Kebap",
      items: [
        ...buildClientSettingsDownload(context, ref, setState),
        ...settingsListGroup(context, SettingsLabelDivider(label: context.localized.lockscreen), [
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
        if (AdaptiveLayout.inputDeviceOf(context) != InputDevice.touch) ...[
          const SizedBox(height: 12),
          ...buildClientSettingsShortCuts(context, ref),
        ],
        const SizedBox(height: 12),
        ...buildClientSettingsDashboard(context, ref),
        const SizedBox(height: 12),
        ...buildClientSettingsVisual(context, ref, nextUpDaysEditor, libraryPageSizeController),
        const SizedBox(height: 12),
        ...settingsListGroup(
          context,
          const SettingsLabelDivider(label: 'Media Stream Display'),
          [
            SettingsListTile(
              label: const Text('Stream Selection Style'),
              subLabel: const Text('Choose how to display version, audio and subtitle options'),
              trailing: EnumBox(
                current: ref.watch(mediaStreamViewTypeProvider).label,
                itemBuilder: (context) => MediaStreamViewType.values
                    .map(
                      (entry) => ItemActionButton(
                        label: Text(entry.label),
                        action: () => ref.read(clientSettingsProvider.notifier).update(
                          (current) => current.copyWith(mediaStreamViewType: entry),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...settingsListGroup(
          context,
          const SettingsLabelDivider(label: 'Content Display'),
          [
            SettingsListTile(
              label: const Text('TMDB API Key (Fallback)'),
              subLabel: AdaptiveTextField(
                controller: tmdbApiKeyController,
                useFocusWrapper: true,
                placeHolder: 'Used for metadata when Baklava plugin is unavailable',
                decoration: const InputDecoration(
                  hintText: 'Used for metadata when Baklava plugin is unavailable',
                  border: InputBorder.none,
                ),
                onChanged: (v) => ref.read(kebapSettingsProvider.notifier).setTmdbApiKey(v),
              ),
            ),
            SettingsListTile(
              label: const Text('Show Reviews Carousel'),
              subLabel: const Text('Display TMDB reviews on item detail pages'),
              trailing: Switch(
                value: ref.watch(kebapSettingsProvider.select((value) => value.showReviewsCarousel)),
                onChanged: (v) => ref.read(kebapSettingsProvider.notifier).setShowReviewsCarousel(v),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...buildClientSettingsTheme(context, ref),
        const SizedBox(height: 12),
        if (AdaptiveLayout.inputDeviceOf(context) == InputDevice.pointer) ...[
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
          const SizedBox(height: 12),
        ],
        ...buildClientSettingsAdvanced(context, ref),
        if (kDebugMode) ...[
          const SizedBox(height: 64),
          SettingsListTile(
            label: const Text(
              "Clear cache",
            ),
            contentColor: Theme.of(context).colorScheme.error,
            onTap: () {
              PaintingBinding.instance.imageCache.clear();
            },
          ),
          SettingsListTile(
            label: Text(
              context.localized.clearAllSettings,
            ),
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
                        Text(
                          context.localized.unableToReverseAction,
                        ),
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
