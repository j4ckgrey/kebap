import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kebap/models/settings/home_settings_model.dart';
import 'package:kebap/providers/settings/client_settings_provider.dart';
import 'package:kebap/providers/settings/home_settings_provider.dart';
import 'package:kebap/screens/settings/settings_list_tile.dart';
import 'package:kebap/screens/settings/widgets/settings_label_divider.dart';
import 'package:kebap/screens/settings/widgets/settings_list_group.dart';
import 'package:kebap/util/localization_helper.dart';
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
        trailing: EnumBox(
          current: ref.watch(
            homeSettingsProvider.select(
              (value) => value.nextUp.label(context),
            ),
          ),
          itemBuilder: (context) => HomeNextUp.values
              .map(
                (entry) => ItemActionButton(
                  label: Text(entry.label(context)),
                  action: () =>
                      ref.read(homeSettingsProvider.notifier).update((context) => context.copyWith(nextUp: entry)),
                ),
              )
              .toList(),
        ),
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
      // Show quality setting only when trailer mode is enabled
      if (homeSettings.bannerMediaType == HomeBannerMediaType.trailer)
        SettingsListTile(
          label: Text(context.localized.bannerTrailerQuality),
          subLabel: Text(context.localized.bannerTrailerQualityDesc),
          trailing: EnumBox(
            current: ref.watch(
              homeSettingsProvider.select(
                (value) => value.bannerTrailerQuality.label(context),
              ),
            ),
            itemBuilder: (context) => TrailerQuality.values
                .map(
                  (entry) => ItemActionButton(
                    label: Text(entry.label(context)),
                    action: () => ref
                        .read(homeSettingsProvider.notifier)
                        .update((context) => context.copyWith(bannerTrailerQuality: entry)),
                  ),
                )
                .toList(),
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
    ],
  );
}


