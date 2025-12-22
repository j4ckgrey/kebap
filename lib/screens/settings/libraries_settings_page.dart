import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kebap/models/settings/client_settings_model.dart';
import 'package:kebap/providers/settings/client_settings_provider.dart';
import 'package:kebap/screens/settings/settings_list_tile.dart';
import 'package:kebap/screens/settings/settings_scaffold.dart';
import 'package:kebap/screens/settings/widgets/settings_label_divider.dart';
import 'package:kebap/screens/settings/widgets/settings_list_group.dart';
import 'package:kebap/screens/shared/input_fields.dart';
import 'package:kebap/util/localization_helper.dart';
import 'package:kebap/widgets/shared/enum_selection.dart';
import 'package:kebap/widgets/shared/item_actions.dart';

@RoutePage()
class LibrariesSettingsPage extends ConsumerStatefulWidget {
  const LibrariesSettingsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LibrariesSettingsPageState();
}

class _LibrariesSettingsPageState extends ConsumerState<LibrariesSettingsPage> {
  late final libraryPageSizeController = TextEditingController(
      text: ref.read(clientSettingsProvider.select((value) => value.libraryPageSize))?.toString() ?? "");

  @override
  void dispose() {
    libraryPageSizeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final clientSettings = ref.watch(clientSettingsProvider);
    
    return SettingsScaffold(
      label: "Libraries",
      items: [
        ...settingsListGroup(
          context,
          const SettingsLabelDivider(label: 'Library Display'),
          [
            SettingsListTile(
              label: Text(context.localized.libraryLocation),
              subLabel: Text(context.localized.libraryLocationDesc),
              trailing: EnumBox(
                current: ref.watch(
                  clientSettingsProvider.select(
                    (value) => value.libraryLocation.label(context),
                  ),
                ),
                itemBuilder: (context) => LibraryLocation.values
                    .map(
                      (entry) => ItemActionButton(
                        label: Text(entry.label(context)),
                        action: () => ref
                            .read(clientSettingsProvider.notifier)
                            .update((context) => context.copyWith(libraryLocation: entry)),
                      ),
                    )
                    .toList(),
              ),
            ),
            SettingsListTile(
              label: Text(context.localized.libraryPageSizeTitle),
              subLabel: Text(context.localized.libraryPageSizeDesc),
              trailing: SizedBox(
                  width: 100,
                  child: IntInputField(
                    controller: libraryPageSizeController,
                    placeHolder: "500",
                    onSubmitted: (value) => ref.read(clientSettingsProvider.notifier).update(
                          (current) => current.copyWith(libraryPageSize: value),
                        ),
                  )),
            ),
            SettingsListTile(
              label: Text(context.localized.usePostersForLibraryIconsTitle),
              subLabel: Text(context.localized.usePostersForLibraryIconsDesc),
              onTap: () => ref
                  .read(clientSettingsProvider.notifier)
                  .update((cb) => cb.copyWith(usePosterForLibrary: !clientSettings.usePosterForLibrary)),
              trailing: Switch(
                value: clientSettings.usePosterForLibrary,
                onChanged: (value) =>
                    ref.read(clientSettingsProvider.notifier).update((cb) => cb.copyWith(usePosterForLibrary: value)),
              ),
            ),
            SettingsListTile(
              label: Text(context.localized.showSimilarToRecommendations),
              subLabel: Text(context.localized.showSimilarToRecommendationsDesc),
              trailing: Switch(
                value: clientSettings.showSimilarTo,
                onChanged: (value) =>
                    ref.read(clientSettingsProvider.notifier).update((t) => t.copyWith(showSimilarTo: value)),
              ),
            ),
            SettingsListTile(
              label: const Text("Enable Catalogs as Libraries"),
              subLabel: const Text("Show folders from Collections as separate libraries"),
              onTap: () => ref.read(clientSettingsProvider.notifier).setEnableCatalogs(!clientSettings.enableCatalogs),
              trailing: Switch(
                value: clientSettings.enableCatalogs,
                onChanged: (value) => ref.read(clientSettingsProvider.notifier).setEnableCatalogs(value),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
