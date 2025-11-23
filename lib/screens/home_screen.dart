import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:window_manager/window_manager.dart';

import 'package:kebap/models/settings/client_settings_model.dart';
import 'package:kebap/providers/baklava_requests_provider.dart';
import 'package:kebap/providers/settings/client_settings_provider.dart';
import 'package:kebap/providers/sync_provider.dart';
import 'package:kebap/providers/user_provider.dart';
import 'package:kebap/routes/auto_router.gr.dart';
import 'package:kebap/screens/shared/kebap_snackbar.dart';
import 'package:kebap/util/input_handler.dart';
import 'package:kebap/util/localization_helper.dart';
import 'package:kebap/util/string_extensions.dart';
import 'package:kebap/widgets/keyboard/slide_in_keyboard.dart';
import 'package:kebap/widgets/navigation_scaffold/components/adaptive_fab.dart';
import 'package:kebap/widgets/navigation_scaffold/components/destination_model.dart';
import 'package:kebap/widgets/navigation_scaffold/navigation_scaffold.dart';

enum HomeTabs {
  dashboard,
  library,
  favorites,
  requests,
  sync;

  const HomeTabs();

  IconData get icon => switch (this) {
        HomeTabs.dashboard => IconsaxPlusLinear.home_1,
        HomeTabs.library => IconsaxPlusLinear.book,
        HomeTabs.favorites => IconsaxPlusLinear.heart,
        HomeTabs.requests => IconsaxPlusLinear.task_square,
        HomeTabs.sync => IconsaxPlusLinear.cloud,
      };

  IconData get selectedIcon => switch (this) {
        HomeTabs.dashboard => IconsaxPlusBold.home_1,
        HomeTabs.library => IconsaxPlusBold.book,
        HomeTabs.favorites => IconsaxPlusBold.heart,
        HomeTabs.requests => IconsaxPlusBold.task_square,
        HomeTabs.sync => IconsaxPlusBold.cloud,
      };

  Future navigate(BuildContext context) => switch (this) {
        HomeTabs.dashboard => context.router.navigate(const DashboardRoute()),
        HomeTabs.library => context.router.navigate(const LibraryRoute()),
        HomeTabs.favorites => context.router.navigate(const FavouritesRoute()),
        HomeTabs.requests => context.router.navigate(const RequestsRoute()),
        HomeTabs.sync => context.router.navigate(const SyncedRoute()),
      };

  String label(BuildContext context) => switch (this) {
        HomeTabs.dashboard => context.localized.dashboard,
        HomeTabs.library => context.localized.library(0),
        HomeTabs.favorites => context.localized.favorites,
        HomeTabs.requests => 'Requests',
        HomeTabs.sync => context.localized.sync,
      };
}

@RoutePage()
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canDownload = ref.watch(showSyncButtonProviderProvider);
    final destinations = HomeTabs.values
        .map((e) {
          switch (e) {
            case HomeTabs.dashboard:
              return DestinationModel(
                label: context.localized.navigationDashboard,
                icon: Icon(e.icon),
                selectedIcon: Icon(e.selectedIcon),
                route: const DashboardRoute(),
                action: () => e.navigate(context),
                floatingActionButton: AdaptiveFab(
                  context: context,
                  title: context.localized.search,
                  key: Key(e.name.capitalize()),
                  onPressed: () => context.router.navigate(LibrarySearchRoute()),
                  child: const Icon(IconsaxPlusLinear.search_normal_1),
                ),
              );
            case HomeTabs.favorites:
              return DestinationModel(
                label: context.localized.navigationFavorites,
                icon: Icon(e.icon),
                selectedIcon: Icon(e.selectedIcon),
                route: const FavouritesRoute(),
                floatingActionButton: AdaptiveFab(
                  context: context,
                  title: context.localized.filter(0),
                  key: Key(e.name.capitalize()),
                  onPressed: () => context.router.navigate(LibrarySearchRoute(favourites: true)),
                  child: const Icon(IconsaxPlusLinear.heart_search),
                ),
                action: () => e.navigate(context),
              );
            case HomeTabs.sync:
              if (canDownload && !kIsWeb) {
                return DestinationModel(
                  label: context.localized.navigationSync,
                  icon: Icon(e.icon),
                  badge: Consumer(
                    builder: (context, ref, child) {
                      final length = ref.watch(activeDownloadTasksProvider.select((value) => value.length));
                      return length != 0
                          ? CircleAvatar(
                              radius: 10,
                              child: FittedBox(
                                child: Text(length.toString()),
                              ),
                            )
                          : const SizedBox.shrink();
                    },
                  ),
                  selectedIcon: Icon(e.selectedIcon),
                  route: const SyncedRoute(),
                  action: () => e.navigate(context),
                );
              }
            case HomeTabs.library:
              return DestinationModel(
                label: context.localized.library(0),
                icon: Icon(e.icon),
                selectedIcon: Icon(e.selectedIcon),
                route: const LibraryRoute(),
                action: () => e.navigate(context),
                floatingActionButton: AdaptiveFab(
                  context: context,
                  title: context.localized.search,
                  key: Key(e.name.capitalize()),
                  onPressed: () => context.router.navigate(LibrarySearchRoute()),
                  child: const Icon(IconsaxPlusLinear.search_status),
                ),
              );
            case HomeTabs.requests:
              return DestinationModel(
                label: 'Requests',
                icon: Icon(e.icon),
                badge: Consumer(
                  builder: (context, ref, child) {
                    final pendingCount = ref.watch(
                      baklavaRequestsProvider.select((state) {
                        final user = ref.watch(userProvider);
                        if (user == null) return 0;

                        final isAdmin = user.policy?.isAdministrator ?? false;
                        final filtered = state.filterByUser(user.name, isAdmin: isAdmin);

                        return filtered.where((r) => r.status == 'pending').length;
                      }),
                    );
                    return pendingCount != 0
                        ? CircleAvatar(
                            radius: 10,
                            child: FittedBox(
                              child: Text(pendingCount.toString()),
                            ),
                          )
                        : const SizedBox.shrink();
                  },
                ),
                selectedIcon: Icon(e.selectedIcon),
                route: const RequestsRoute(),
                action: () => e.navigate(context),
              );
          }
        })
        .nonNulls
        .toList();
    return InputHandler<GlobalHotKeys>(
      autoFocus: false,
      keyMapResult: (result) {
        switch (result) {
          case GlobalHotKeys.search:
            context.navigateTo(LibrarySearchRoute());
            return true;
          case GlobalHotKeys.exit:
            Future.microtask(() async {
              final manager = WindowManager.instance;
              if (await manager.isClosable()) {
                manager.close();
              } else {
                kebapSnackbar(context, title: context.localized.somethingWentWrong);
              }
            });
            return true;
        }
      },
      keyMap: ref.watch(clientSettingsProvider.select((value) => value.currentShortcuts)),
      child: HeroControllerScope(
        controller: HeroController(),
        child: AutoRouter(
          builder: (context, child) {
            return CustomKeyboardWrapper(
              child: NavigationScaffold(
                destinations: destinations.nonNulls.toList(),
                currentRouteName: context.router.current.name,
                nestedChild: child,
              ),
            );
          },
        ),
      ),
    );
  }
}
