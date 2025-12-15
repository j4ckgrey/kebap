import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kebap/models/settings/home_settings_model.dart';
import 'package:kebap/models/settings/client_settings_model.dart';
import 'package:kebap/providers/settings/client_settings_provider.dart';
import 'package:kebap/providers/settings/home_settings_provider.dart';
import 'package:kebap/screens/settings/settings_list_tile.dart';
import 'package:kebap/screens/settings/widgets/settings_label_divider.dart';
import 'package:kebap/screens/settings/widgets/settings_list_group.dart';
import 'package:kebap/util/localization_helper.dart';
import 'package:kebap/util/option_dialogue.dart';
import 'package:kebap/widgets/shared/enum_selection.dart';
import 'package:kebap/widgets/shared/item_actions.dart';

List<Widget> buildClientSettingsDashboard(BuildContext context, WidgetRef ref) {
  final clientSettings = ref.watch(clientSettingsProvider);
  final homeSettings = ref.watch(homeSettingsProvider);
  return settingsListGroup(
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
        trailing: EnumBox(
          current: ref.watch(
            homeSettingsProvider.select(
              (value) => value.bannerMediaType.label(context),
            ),
          ),
          itemBuilder: (context) => HomeBannerMediaType.values
              .map(
                (entry) => ItemActionButton(
                  label: Text(entry.label(context)),
                  action: () => ref
                      .read(homeSettingsProvider.notifier)
                      .update((context) => context.copyWith(bannerMediaType: entry)),
                ),
              )
              .toList(),
        ),
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
        label: Text(context.localized.libraryLocation),
        subLabel: Text(context.localized.libraryLocationDesc),
        onTap: () async {
          final items = LibraryLocation.values;
          await openMultiSelectOptions<LibraryLocation>(
            context,
            label: context.localized.libraryLocation,
            items: items,
            selected: [ref.read(clientSettingsProvider).libraryLocation],
            itemBuilder: (type, selected, tap) => CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: selected,
              onChanged: (value) => tap(),
              title: Text(type.label(context)),
            ),
            onChanged: (values) => ref
                .read(clientSettingsProvider.notifier)
                .update((context) => context.copyWith(libraryLocation: values.first)),
          );
        },
        trailing: Text(ref.watch(
          clientSettingsProvider.select(
            (value) => value.libraryLocation.label(context),
          ),
        )),
      ),
      SettingsListTile(
        label: Text(context.localized.showSimilarToRecommendations),
        subLabel: Text(context.localized.showSimilarToRecommendationsDesc),
        onTap: () => ref
            .read(clientSettingsProvider.notifier)
            .update((t) => t.copyWith(showSimilarTo: !t.showSimilarTo)),
        trailing: Switch(
          value: clientSettings.showSimilarTo,
          onChanged: (value) =>
              ref.read(clientSettingsProvider.notifier).update((t) => t.copyWith(showSimilarTo: value)),
        ),
      ),
    ],
  );
}


