import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import 'package:kebap/providers/profanity_filter_provider.dart';
import 'package:kebap/screens/settings/settings_scaffold.dart';
import 'package:kebap/screens/settings/settings_list_tile.dart';
import 'package:kebap/screens/settings/widgets/settings_label_divider.dart';
import 'package:kebap/screens/settings/widgets/settings_list_group.dart';
import 'package:kebap/util/theme_extensions.dart';

/// Content Filter settings page - per-user profanity filter toggle.
/// Visible to ALL users when Jelly-Guardian plugin is installed on server.
@RoutePage()
class ContentFilterSettingsPage extends ConsumerWidget {
  const ContentFilterSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefsAsync = ref.watch(profanityUserPrefsProvider);

    return SettingsScaffold(
      label: 'Content Filter',
      items: [
        prefsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Failed to load preferences: $err',
              style: TextStyle(color: context.colors.error),
            ),
          ),
          data: (prefs) => Column(
            children: [
              // Info card
              Card(
                margin: const EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(
                        IconsaxPlusLinear.shield_tick,
                        size: 40,
                        color: context.colors.primary,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Profanity Filter',
                              style: context.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Automatically mutes detected profanity during playback based on subtitle analysis.',
                              style: context.textTheme.bodySmall?.copyWith(
                                color: context.colors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Filter settings
              ...settingsListGroup(
                context,
                const SettingsLabelDivider(label: 'Filter Settings'),
                [
                  SettingsListTile(
                    label: const Text('Enable Profanity Filter'),
                    subLabel: const Text('Mute audio when profanity is detected'),
                    icon: IconsaxPlusLinear.volume_slash,
                    trailing: Switch(
                      value: prefs.enabled,
                      onChanged: (value) {
                        ref.read(profanityUserPrefsProvider.notifier).updatePreferences(
                          enabled: value,
                        );
                      },
                    ),
                    onTap: () {
                      ref.read(profanityUserPrefsProvider.notifier).toggleEnabled();
                    },
                  ),
                  SettingsListTile(
                    label: const Text('Mute Entire Sentence'),
                    subLabel: const Text('Mute the full sentence instead of just the word'),
                    icon: IconsaxPlusLinear.text_block,
                    trailing: Switch(
                      value: prefs.muteEntireSentence,
                      onChanged: prefs.enabled
                          ? (value) {
                              ref.read(profanityUserPrefsProvider.notifier).updatePreferences(
                                muteEntireSentence: value,
                              );
                            }
                          : null,
                    ),
                    onTap: prefs.enabled
                        ? () {
                            ref.read(profanityUserPrefsProvider.notifier).updatePreferences(
                              muteEntireSentence: !prefs.muteEntireSentence,
                            );
                          }
                        : null,
                  ),
                ],
              ),

              // How it works
              ...settingsListGroup(
                context,
                const SettingsLabelDivider(label: 'How It Works'),
                [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _InfoRow(
                          icon: IconsaxPlusLinear.document_text,
                          text: 'Analyzes subtitle files for profanity',
                        ),
                        const SizedBox(height: 12),
                        _InfoRow(
                          icon: IconsaxPlusLinear.timer_1,
                          text: 'Creates precise mute timestamps',
                        ),
                        const SizedBox(height: 12),
                        _InfoRow(
                          icon: IconsaxPlusLinear.volume_cross,
                          text: 'Mutes audio during playback at those times',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}
