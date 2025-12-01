import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kebap/providers/baklava_config_provider.dart';
import 'package:kebap/providers/settings/kebap_settings_provider.dart';
import 'package:kebap/screens/settings/settings_list_tile.dart';
import 'package:kebap/screens/settings/settings_scaffold.dart';
import 'package:kebap/screens/settings/widgets/settings_label_divider.dart';
import 'package:kebap/screens/shared/adaptive_text_field.dart';

@RoutePage()
class KebapSettingsPage extends ConsumerStatefulWidget {
  const KebapSettingsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _KebapSettingsPageState();
}

class _KebapSettingsPageState extends ConsumerState<KebapSettingsPage> {
  final tmdbController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final local = ref.read(kebapSettingsProvider);
    tmdbController.text = local.tmdbApiKey ?? '';
  }

  @override
  void dispose() {
    tmdbController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final local = ref.watch(kebapSettingsProvider);
    final baklavaAsync = ref.watch(baklavaConfigProvider);
    final useBaklava = local.useBaklava;

    return SettingsScaffold(
      label: "Kebap Settings",
      items: [
        SettingsListTile(
          label: const Text('Use Baklava plugin config'),
          subLabel: const Text('When enabled, Kebap will prefer the Baklava plugin settings'),
          trailing: Switch(
            value: useBaklava,
            onChanged: (v) => ref.read(kebapSettingsProvider.notifier).setUseBaklava(v),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 20,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Baklava Plugin Features',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Without Baklava plugin installed:',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '• TMDB metadata (reviews, cast) - Works with local TMDB API key\n'
                    '• UI preferences (carousels, search filters) - Works locally',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Requires Baklava plugin on server:',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '• Media requests (request movies/shows)\n'
                    '• Auto-import via Gelato integration\n'
                    '• Server-wide configuration sharing',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SettingsLabelDivider(label: 'Configuration'),
        if (useBaklava)
          baklavaAsync.when(
            data: (cfg) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SettingsListTile(
                  label: const Text('TMDB API Key'),
                  subLabel: Text(cfg.tmdbApiKey ?? 'Not configured'),
                ),
                SettingsListTile(
                  label: const Text('Force TV client local search'),
                  subLabel: Text(cfg.forceTVClientLocalSearch == true ? 'Enabled' : 'Disabled'),
                ),
                SettingsListTile(
                  label: const Text('Disable non-admin requests'),
                  subLabel: Text(cfg.disableNonAdminRequests ? 'Disabled' : 'Enabled'),
                ),
                SettingsListTile(
                  label: const Text('Show reviews carousel'),
                  subLabel: Text(cfg.showReviewsCarousel ? 'Enabled' : 'Disabled'),
                ),
              ],
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => const SettingsListTile(
              label: Text('Error'),
              subLabel: Text('Unable to fetch plugin config'),
            ),
          )
        else
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SettingsListTile(
                label: const Text('TMDB API Key (Fallback)'),
                subLabel: AdaptiveTextField(
                  controller: tmdbController,
                  useFocusWrapper: true,
                  placeHolder: 'Enter your TMDB API key for metadata when Baklava is disabled',
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                  onChanged: (v) => ref.read(kebapSettingsProvider.notifier).setTmdbApiKey(v),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
