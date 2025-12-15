import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kebap/models/settings/media_stream_view_type.dart';
import 'package:kebap/providers/settings/client_settings_provider.dart';
import 'package:kebap/providers/settings/kebap_settings_provider.dart';
import 'package:kebap/providers/settings/media_stream_view_type_provider.dart';
import 'package:kebap/screens/settings/settings_list_tile.dart';
import 'package:kebap/screens/settings/settings_scaffold.dart';
import 'package:kebap/screens/settings/widgets/settings_label_divider.dart';
import 'package:kebap/screens/settings/widgets/settings_list_group.dart';
import 'package:kebap/screens/shared/adaptive_text_field.dart';
import 'package:kebap/util/option_dialogue.dart';

@RoutePage()
class DetailsSettingsPage extends ConsumerStatefulWidget {
  const DetailsSettingsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DetailsSettingsPageState();
}

class _DetailsSettingsPageState extends ConsumerState<DetailsSettingsPage> {
  late final tmdbApiKeyController = TextEditingController(
      text: ref.read(kebapSettingsProvider.select((value) => value.tmdbApiKey)) ?? "");

  @override
  void dispose() {
    tmdbApiKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SettingsScaffold(
      label: "Details Page",
      items: [
        ...settingsListGroup(
          context,
          const SettingsLabelDivider(label: 'Media Stream Display'),
          [
            SettingsListTile(
              label: const Text('Stream Selection Style'),
              subLabel: const Text('Choose how to display version, audio and subtitle options'),
              onTap: () async {
                final items = MediaStreamViewType.values;
                await openMultiSelectOptions<MediaStreamViewType>(
                  context,
                  label: 'Stream Selection Style',
                  items: items,
                  selected: [ref.read(mediaStreamViewTypeProvider)],
                  itemBuilder: (type, selected, tap) => CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    value: selected,
                    onChanged: (value) => tap(),
                    title: Text(type.label),
                  ),
                  onChanged: (values) => ref.read(clientSettingsProvider.notifier).update(
                        (current) => current.copyWith(mediaStreamViewType: values.first),
                      ),
                );
              },
              trailing: Text(ref.watch(mediaStreamViewTypeProvider).label),
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
              onTap: () => ref.read(kebapSettingsProvider.notifier).setShowReviewsCarousel(
                    !ref.read(kebapSettingsProvider).showReviewsCarousel,
                  ),
              trailing: Switch(
                value: ref.watch(kebapSettingsProvider.select((value) => value.showReviewsCarousel)),
                onChanged: (v) => ref.read(kebapSettingsProvider.notifier).setShowReviewsCarousel(v),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
