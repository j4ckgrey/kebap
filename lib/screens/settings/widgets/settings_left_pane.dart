import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:kebap/providers/arguments_provider.dart';
import 'package:kebap/providers/auth_provider.dart';
import 'package:kebap/providers/profanity_filter_provider.dart';
import 'package:kebap/providers/update_provider.dart';
import 'package:kebap/providers/user_provider.dart';
import 'package:kebap/routes/auto_router.gr.dart';
import 'package:kebap/screens/settings/quick_connect_window.dart';
import 'package:kebap/screens/settings/settings_list_tile.dart';
import 'package:kebap/screens/settings/settings_scaffold.dart';
import 'package:kebap/screens/shared/default_alert_dialog.dart';
import 'package:kebap/screens/shared/kebap_icon.dart';
import 'package:kebap/screens/shared/kebap_snackbar.dart';
import 'package:kebap/util/adaptive_layout/adaptive_layout.dart';
import 'package:kebap/util/localization_helper.dart';
import 'package:kebap/util/theme_extensions.dart';
import 'package:window_manager/window_manager.dart';

class SettingsLeftPane extends ConsumerWidget {
  final String activeRouteName;
  const SettingsLeftPane({required this.activeRouteName, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void navigateTo(PageRouteInfo route) => context.tabsRouter.navigate(route);

    bool containsRoute(PageRouteInfo route) =>
        AdaptiveLayout.layoutModeOf(context) == LayoutMode.dual && activeRouteName == route.routeName;

    final quickConnectAvailable =
        ref.watch(userProvider.select((value) => value?.serverConfiguration?.quickConnectAvailable ?? false));

    final newRelease = ref.watch(updateProvider.select((value) => value.latestRelease));

    final hasNewUpdate = ref.watch(hasNewUpdateProvider);
    final htpcMode = ref.watch(argumentsStateProvider.select((value) => value.htpcMode));

    // Check if profanity filter plugin is available on server
    final profanityPluginAvailable = ref.watch(profanityPluginAvailableProvider).valueOrNull ?? false;

    IconData deviceIcon;
    if (AdaptiveLayout.of(context).isDesktop) {
      deviceIcon = IconsaxPlusLinear.monitor;
    } else {
      switch (AdaptiveLayout.viewSizeOf(context)) {
        case ViewSize.phone:
          deviceIcon = IconsaxPlusLinear.mobile;
          break;
        case ViewSize.tablet:
          deviceIcon = IconsaxPlusLinear.monitor;
          break;
        case ViewSize.desktop:
          deviceIcon = IconsaxPlusLinear.monitor;
          break;
        case ViewSize.television:
          deviceIcon = IconsaxPlusLinear.mirroring_screen;
          break;
      }
    }

    return RepaintBoundary(
      child: Padding(
        padding: EdgeInsets.only(left: AdaptiveLayout.of(context).sideBarWidth),
        child: SettingsScaffold(
          label: context.localized.settings,
          showBackButtonNested: true,
          showUserIcon: true,
          items: [
            if (hasNewUpdate && newRelease != null) ...[
              Card(
                color: context.colors.secondaryContainer,
                child: SettingsListTile(
                  label: Text(context.localized.newReleaseFoundTitle(newRelease.version)),
                  subLabel: Text(context.localized.newUpdateFoundOnGithub),
                  icon: IconsaxPlusLinear.information,
                  onTap: () => navigateTo(const AboutSettingsRoute()),
                ),
              ),
              const SizedBox(height: 8),
            ],
            // Original Client Settings - commented out, replaced by categorized pages below
            // SettingsListTile(
            //   key: const ValueKey('client_settings'),
            //   autoFocus: htpcMode,
            //   label: Text(context.localized.settingsClientTitle),
            //   subLabel: Text(context.localized.settingsClientDesc),
            //   selected: containsRoute(const ClientSettingsRoute()),
            //   icon: deviceIcon,
            //   onTap: () => navigateTo(const ClientSettingsRoute()),
            // ),
            // New categorized settings pages
            SettingsListTile(
              key: const ValueKey('dashboard_settings'),
              label: const Text('Dashboard'),
              subLabel: const Text('Home screen & banner settings'),
              selected: containsRoute(const DashboardSettingsRoute()),
              icon: IconsaxPlusLinear.home_2,
              onTap: () => navigateTo(const DashboardSettingsRoute()),
            ),
            SettingsListTile(
              key: const ValueKey('details_settings'),
              label: const Text('Details Page'),
              subLabel: const Text('Media streams & content display'),
              selected: containsRoute(const DetailsSettingsRoute()),
              icon: IconsaxPlusLinear.document_text_1,
              onTap: () => navigateTo(const DetailsSettingsRoute()),
            ),
            SettingsListTile(
              key: const ValueKey('downloads_settings'),
              label: const Text('Downloads'),
              subLabel: const Text('Download path & sync settings'),
              selected: containsRoute(const DownloadsSettingsRoute()),
              icon: IconsaxPlusLinear.arrow_down_2,
              onTap: () => navigateTo(const DownloadsSettingsRoute()),
            ),
            SettingsListTile(
              key: const ValueKey('libraries_settings'),
              label: const Text('Libraries'),
              subLabel: const Text('Library display & visual settings'),
              selected: containsRoute(const LibrariesSettingsRoute()),
              icon: IconsaxPlusLinear.book_1,
              onTap: () => navigateTo(const LibrariesSettingsRoute()),
            ),
            SettingsListTile(
              key: const ValueKey('general_ui_settings'),
              label: const Text('General UI'),
              subLabel: const Text('Theme, colors & controls'),
              selected: containsRoute(const GeneralUiSettingsRoute()),
              icon: IconsaxPlusLinear.brush_2,
              onTap: () => navigateTo(const GeneralUiSettingsRoute()),
            ),
            SettingsListTile(
              key: const ValueKey('advanced_settings'),
              label: const Text('Advanced'),
              subLabel: const Text('Shortcuts & layout options'),
              selected: containsRoute(const AdvancedSettingsRoute()),
              icon: IconsaxPlusLinear.setting_4,
              onTap: () => navigateTo(const AdvancedSettingsRoute()),
            ),
            SettingsListTile(
              key: const ValueKey('profile_settings'),
              label: Text(context.localized.settingsProfileTitle),
              subLabel: Text(context.localized.settingsProfileDesc),
              selected: containsRoute(const ProfileSettingsRoute()),
              icon: IconsaxPlusLinear.security_user,
              onTap: () => navigateTo(const ProfileSettingsRoute()),
            ),
            SettingsListTile(
              key: const ValueKey('player_settings'),
              label: Text(context.localized.settingsPlayerTitle),
              subLabel: Text(context.localized.settingsPlayerDesc),
              selected: containsRoute(const PlayerSettingsRoute()),
              icon: IconsaxPlusLinear.video_play,
              onTap: () => navigateTo(const PlayerSettingsRoute()),
            ),
            // Content Filter - visible to ALL users when Jelly-Guardian plugin is installed
            if (profanityPluginAvailable)
              SettingsListTile(
                key: const ValueKey('content_filter'),
                label: const Text('Content Filter'),
                subLabel: const Text('Profanity filter settings'),
                selected: containsRoute(const ContentFilterSettingsRoute()),
                icon: IconsaxPlusLinear.shield_tick,
                onTap: () => navigateTo(const ContentFilterSettingsRoute()),
              ),
            SettingsListTile(
              key: const ValueKey('about_settings'),
              label: Text(context.localized.about),
              subLabel: Text("Kebap, ${context.localized.latestReleases}"),
              selected: containsRoute(const AboutSettingsRoute()),
              leading: Opacity(
                opacity: 1,
                child: KebapIconOutlined(
                  size: 24,
                  color: context.colors.onSurfaceVariant,
                ),
              ),
              onTap: () => navigateTo(const AboutSettingsRoute()),
            ),
            if (htpcMode) ...[
              SettingsListTile(
                key: const ValueKey('exit_kebap'),
                label: Text(context.localized.exitKebapTitle),
                icon: IconsaxPlusLinear.close_square,
                onTap: () async {
                  showDefaultAlertDialog(
                    context,
                    context.localized.exitKebapTitle,
                    context.localized.exitKebapDesc,
                    (context) async {
                      if (AdaptiveLayout.of(context).isDesktop) {
                        final manager = WindowManager.instance;
                        if (await manager.isClosable()) {
                          manager.close();
                        } else {
                          kebapSnackbar(context, title: context.localized.somethingWentWrong);
                        }
                      } else {
                        SystemNavigator.pop();
                      }
                    },
                    context.localized.close,
                    (context) => context.pop(),
                    context.localized.cancel,
                  );
                },
              ),
            ],
            const FractionallySizedBox(
              widthFactor: 0.25,
              child: Divider(),
            ),
            if (quickConnectAvailable)
              SettingsListTile(
                key: const ValueKey('quick_connect'),
                label: Text(context.localized.settingsQuickConnectTitle),
                icon: IconsaxPlusLinear.password_check,
                onTap: () => openQuickConnectDialog(context),
              ),
            SettingsListTile(
              key: const ValueKey('switch_user'),
              label: Text(context.localized.switchUser),
              icon: IconsaxPlusLinear.arrow_swap_horizontal,
              contentColor: Colors.greenAccent,
              onTap: () async {
                await ref.read(userProvider.notifier).logoutUser();
                context.router.replaceAll([const LoginRoute()]);
              },
            ),
            SettingsListTile(
              key: const ValueKey('logout'),
              label: Text(context.localized.logout),
              icon: IconsaxPlusLinear.logout,
              contentColor: Theme.of(context).colorScheme.error,
              onTap: () {
                final user = ref.read(userProvider);
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(context.localized.logoutUserPopupTitle(user?.name ?? "")),
                    scrollable: true,
                    content: Text(
                      context.localized.logoutUserPopupContent(user?.name ?? "", user?.credentials.url ?? ""),
                    ),
                    actions: [
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(context.localized.cancel),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom().copyWith(
                          iconColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.onErrorContainer),
                          foregroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.onErrorContainer),
                          backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.errorContainer),
                        ),
                        onPressed: () async {
                          await ref.read(authProvider.notifier).logOutUser();
                          if (context.mounted) {
                            context.router.replaceAll([const LoginRoute()]);
                          }
                        },
                        child: Text(context.localized.logout),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
