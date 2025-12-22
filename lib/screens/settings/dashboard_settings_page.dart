import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kebap/models/settings/client_settings_model.dart';
import 'package:kebap/models/settings/home_settings_model.dart';
import 'package:kebap/providers/settings/client_settings_provider.dart';
import 'package:kebap/providers/settings/home_settings_provider.dart';
import 'package:kebap/screens/settings/settings_list_tile.dart';
import 'package:kebap/screens/settings/settings_scaffold.dart';
import 'package:kebap/screens/settings/widgets/settings_label_divider.dart';
import 'package:kebap/screens/settings/widgets/settings_list_group.dart';
import 'package:kebap/util/localization_helper.dart';
import 'package:kebap/util/option_dialogue.dart';
import 'package:kebap/widgets/shared/enum_selection.dart';
import 'package:kebap/widgets/shared/item_actions.dart';

@RoutePage()
class DashboardSettingsPage extends ConsumerWidget {
  const DashboardSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clientSettings = ref.watch(clientSettingsProvider);
    final homeSettings = ref.watch(homeSettingsProvider);
    
    return SettingsScaffold(
      label: "Dashboard",
      items: [
        ...settingsListGroup(
          context,
          SettingsLabelDivider(label: context.localized.dashboard),
          [
            SettingsListTile(
              label: Text(context.localized.settingsHomeNextUpTitle),
              subLabel: Text(context.localized.settingsHomeNextUpDesc),
              onTap: () async {
                final items = HomeNextUp.values;
                await openMultiSelectOptions<HomeNextUp>(
                  context,
                  label: context.localized.settingsHomeNextUpTitle,
                  items: items,
                  selected: [ref.read(homeSettingsProvider).nextUp],
                  itemBuilder: (type, selected, tap) => CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    value: selected,
                    onChanged: (value) => tap(),
                    title: Text(type.label(context)),
                  ),
                  onChanged: (values) => ref
                      .read(homeSettingsProvider.notifier)
                      .update((context) => context.copyWith(nextUp: values.first)),
                );
              },
              trailing: Text(ref.watch(
                homeSettingsProvider.select(
                  (value) => value.nextUp.label(context),
                ),
              )),
            ),
            SettingsListTile(
              label: Text(context.localized.bannerMediaType),
              subLabel: Text(context.localized.bannerMediaTypeDesc),
              onTap: () async {
                final items = HomeBannerMediaType.values;
                await openMultiSelectOptions<HomeBannerMediaType>(
                  context,
                  label: context.localized.bannerMediaType,
                  items: items,
                  selected: [ref.read(homeSettingsProvider).bannerMediaType],
                  itemBuilder: (type, selected, tap) => CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    value: selected,
                    onChanged: (value) => tap(),
                    title: Text(type.label(context)),
                  ),
                  onChanged: (values) => ref
                      .read(homeSettingsProvider.notifier)
                      .update((context) => context.copyWith(bannerMediaType: values.first)),
                );
              },
              trailing: Text(ref.watch(
                homeSettingsProvider.select(
                  (value) => value.bannerMediaType.label(context),
                ),
              )),
            ),
            // Show mute toggle only when trailer mode is enabled
            if (homeSettings.bannerMediaType == HomeBannerMediaType.trailer)
              SettingsListTile(
                label: Text(context.localized.bannerTrailerMuted),
                subLabel: Text(context.localized.bannerTrailerMutedDesc),
                onTap: () => ref
                    .read(homeSettingsProvider.notifier)
                    .update((current) => current.copyWith(bannerTrailerMuted: !current.bannerTrailerMuted)),
                trailing: Switch(
                  value: homeSettings.bannerTrailerMuted,
                  onChanged: (value) => ref
                      .read(homeSettingsProvider.notifier)
                      .update((current) => current.copyWith(bannerTrailerMuted: value)),
                ),
              ),
            SettingsListTile(
              label: Text(context.localized.clientSettingsShowAllCollectionsTitle),
              subLabel: Text(context.localized.clientSettingsShowAllCollectionsDesc),
              onTap: () => ref
                  .read(clientSettingsProvider.notifier)
                  .update((current) => current.copyWith(showAllCollectionTypes: !current.showAllCollectionTypes)),
              trailing: Switch(
                value: clientSettings.showAllCollectionTypes,
                onChanged: (value) => ref
                    .read(clientSettingsProvider.notifier)
                    .update((current) => current.copyWith(showAllCollectionTypes: value)),
              ),
            ),
            SettingsListTile(
              label: const Text("Show Library Contents"),
              subLabel: const Text("Toggle between 'Recently Added' and full library contents on dashboard"),
              onTap: () => ref
                  .read(clientSettingsProvider.notifier)
                  .setDashboardShowLibraryContents(!clientSettings.dashboardShowLibraryContents),
              trailing: Switch(
                value: clientSettings.dashboardShowLibraryContents,
                onChanged: (value) =>
                    ref.read(clientSettingsProvider.notifier).setDashboardShowLibraryContents(value),
              ),
            ),
            if (clientSettings.dashboardShowLibraryContents)
              SettingsListTile(
                label: const Text("Dashboard Layout"),
                subLabel: const Text("Choose between Multi-Row or Single-Row layout"),
                trailing: EnumBox(
                  current: clientSettings.dashboardLayoutMode.label(context),
                  itemBuilder: (context) => DashboardLayoutMode.values
                      .map(
                        (entry) => ItemActionButton(
                          label: Text(entry.label(context)),
                          action: () => ref.read(clientSettingsProvider.notifier).setDashboardLayoutMode(entry),
                        ),
                      )
                      .toList(),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
