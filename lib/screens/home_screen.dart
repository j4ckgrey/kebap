import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:window_manager/window_manager.dart';

import 'package:kebap/models/settings/client_settings_model.dart';
import 'package:kebap/providers/baklava_requests_provider.dart';
import 'package:kebap/jellyfin/jellyfin_open_api.enums.swagger.dart';
import 'package:kebap/providers/settings/client_settings_provider.dart';
import 'package:kebap/providers/sync_provider.dart';
import 'package:kebap/providers/user_provider.dart';
import 'package:kebap/providers/views_provider.dart';
import 'package:kebap/routes/auto_router.gr.dart';
import 'package:kebap/screens/shared/kebap_snackbar.dart';
import 'package:kebap/util/input_handler.dart';
import 'package:kebap/util/localization_helper.dart';

import 'package:kebap/widgets/navigation_scaffold/components/destination_model.dart';
import 'package:kebap/widgets/navigation_scaffold/navigation_scaffold.dart';

enum HomeTabs {
  dashboard,
  library,
  favorites,
  requests,
  sync,
  liveTv;

  const HomeTabs();

  IconData get icon => switch (this) {
        HomeTabs.dashboard => IconsaxPlusLinear.home_1,
        HomeTabs.library => IconsaxPlusLinear.book,
        HomeTabs.favorites => IconsaxPlusLinear.heart,
        HomeTabs.requests => IconsaxPlusLinear.task_square,
        HomeTabs.sync => IconsaxPlusLinear.cloud,
        HomeTabs.liveTv => IconsaxPlusLinear.monitor,
      };

  IconData get selectedIcon => switch (this) {
        HomeTabs.dashboard => IconsaxPlusBold.home_1,
        HomeTabs.library => IconsaxPlusBold.book,
        HomeTabs.favorites => IconsaxPlusBold.heart,
        HomeTabs.requests => IconsaxPlusBold.task_square,
        HomeTabs.sync => IconsaxPlusBold.cloud,
        HomeTabs.liveTv => IconsaxPlusBold.monitor,
      };

  Future<void> navigate(BuildContext context) async {
    switch (this) {
      case HomeTabs.dashboard:
        await context.router.navigate(const DashboardRoute());
      case HomeTabs.library:
        await context.router.navigate(const LibraryRoute());
      case HomeTabs.favorites:
        await context.router.navigate(const FavouritesRoute());
      case HomeTabs.requests:
        await context.router.navigate(const RequestsRoute());
      case HomeTabs.sync:
        await context.router.navigate(const SyncedRoute());
      case HomeTabs.liveTv:
        final views = ProviderScope.containerOf(context).read(viewsProvider);
        final liveTvView = views.views.firstWhereOrNull((e) => e.collectionType == CollectionType.livetv);
        if (liveTvView != null) {
          await context.router.navigate(LibrarySearchRoute(viewModelId: liveTvView.id));
        } else {
          kebapSnackbar(context, title: 'Live TV library not found');
        }
    }
  }

  String label(BuildContext context) => switch (this) {
        HomeTabs.dashboard => context.localized.dashboard,
        HomeTabs.library => context.localized.library(0),
        HomeTabs.favorites => context.localized.favorites,
        HomeTabs.requests => 'Requests',
        HomeTabs.sync => context.localized.sync,
        HomeTabs.liveTv => context.localized.liveTv,
      };
}

@RoutePage()
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  Future<void> _handleExit() async {
    if (kIsWeb) return;
    
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.localized.exitApp),
        content: Text(context.localized.exitAppConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(context.localized.cancel),
          ),
          TextButton(
            autofocus: true,
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(context.localized.exit),
          ),
        ],
      ),
    );

    if (shouldExit == true) {
      final manager = WindowManager.instance;
      try {
        if (await manager.isClosable()) {
          await manager.destroy();
        } else {
          SystemNavigator.pop();
        }
      } catch (_) {
        SystemNavigator.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
              );
            case HomeTabs.favorites:
              return DestinationModel(
                label: context.localized.navigationFavorites,
                icon: Icon(e.icon),
                selectedIcon: Icon(e.selectedIcon),
                route: const FavouritesRoute(),
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
              return null;
            case HomeTabs.library:
              return DestinationModel(
                label: context.localized.library(0),
                icon: Icon(e.icon),
                selectedIcon: Icon(e.selectedIcon),
                route: const LibraryRoute(),
                action: () => e.navigate(context),
              );
            case HomeTabs.requests:
              return DestinationModel(
                label: 'Requests',
                icon: Icon(e.icon),
                badge: Consumer(
                  builder: (context, ref, child) {
                    final pendingCount = ref.watch(pendingRequestsCountProvider);
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
            case HomeTabs.liveTv:
              return DestinationModel(
                label: context.localized.liveTv,
                icon: Icon(e.icon),
                selectedIcon: Icon(e.selectedIcon),
                // We don't have a specific route for Live TV in the bottom nav sense, 
                // but we need a route for the DestinationModel. 
                // Since it navigates to LibrarySearchRoute dynamically, we can use a placeholder or the same route.
                // However, DestinationModel expects a route to highlight the tab.
                // For now, let's use LibrarySearchRoute but we might need a specific check.
                // Actually, since it pushes a new screen, it might not stay selected in the sidebar in the same way.
                route: LibrarySearchRoute(), 
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
              _handleExit();
              return true;
          }
        },
        keyMap: ref.watch(clientSettingsProvider.select((value) => value.currentShortcuts)),
        child: HeroControllerScope(
          controller: HeroController(),
          child: AutoRouter(
            builder: (context, child) {
              return NavigationScaffold(
                scaffoldKey: _scaffoldKey,
                destinations: destinations.nonNulls.toList(),
                currentRouteName: context.router.current.name,
                nestedChild: child,
              );
            },
          ),
        ),
      );
  }
}
