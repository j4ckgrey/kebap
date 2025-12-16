import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kebap/providers/user_provider.dart';
import 'package:kebap/providers/connectivity_provider.dart';
import 'package:kebap/routes/auto_router.gr.dart';
import 'package:kebap/screens/login/lock_screen.dart';
import 'package:kebap/widgets/navigation_scaffold/components/navigation_body.dart';

const settingsPageRoute = "settings";

const fullScreenRoutes = {
  PhotoViewerRoute.name,
};

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AutoRouter extends RootStackRouter {
  AutoRouter({
    required this.ref,
  });

  final WidgetRef ref;

  @override
  List<AutoRouteGuard> get guards => [...super.guards, AuthGuard(ref: ref)];

  @override
  RouteType get defaultRouteType => const RouteType.adaptive();

  @override
  List<AutoRoute> get routes => [
        ..._defaultRoutes,
        ...otherRoutes,
      ];

  final List<AutoRoute> otherRoutes = [
    _homeRoute.copyWith(
      children: [
        ...homeRoutes,
        ...detailsRoutes,
        CustomRoute(
          page: AdminDashboardRoute.page,
          path: 'admin',
          children: _adminChildren,
          transitionsBuilder: TransitionsBuilders.fadeIn,
          durationInMilliseconds: 200,
          reverseDurationInMilliseconds: 200,
        ),
        AutoRoute(page: AdminUserEditRoute.page, path: 'admin/users/edit'),
        AutoRoute(page: AdminTaskDetailRoute.page, path: 'admin/tasks/:taskId'),
        AutoRoute(page: AdminLibraryDetailRoute.page, path: 'admin/libraries/:libraryId'),
        CustomRoute(
          page: SettingsRoute.page,
          path: settingsPageRoute,
          children: _settingsChildren,
          transitionsBuilder: TransitionsBuilders.fadeIn,
          durationInMilliseconds: 200,
          reverseDurationInMilliseconds: 200,
        ),
      ],
    ),
    AutoRoute(page: LockRoute.page, path: '/locked'),
  ];
}

final AutoRoute _homeRoute = AutoRoute(page: HomeRoute.page, path: '/');
final List<AutoRoute> homeRoutes = [
  AutoRoute(
    page: DashboardRoute.page,
    initial: true,
    path: 'dashboard',
  ),
  AutoRoute(
    page: FavouritesRoute.page,
    path: 'favourites',
  ),
  AutoRoute(
    page: RequestsRoute.page,
    path: 'requests',
  ),
  AutoRoute(
    page: SyncedRoute.page,
    path: 'synced',
  ),
  AutoRoute(
    page: LibraryRoute.page,
    path: 'libraries',
  ),
];

final List<AutoRoute> detailsRoutes = [
  AutoRoute(page: DetailsRoute.page, path: 'details'),
  AutoRoute(page: PhotoViewerRoute.page, path: "album"),
  AutoRoute(page: LibrarySearchRoute.page, path: 'library'),
];

// Admin routes - nested tabs
final List<AutoRoute> _adminChildren = [
  AutoRoute(page: AdminSelectionRoute.page, path: 'list'),
  AutoRoute(page: AdminActivityRoute.page, path: 'activity'),
  AutoRoute(page: AdminGeneralRoute.page, path: 'general'),
  AutoRoute(page: AdminBrandingRoute.page, path: 'branding'),
  AutoRoute(page: AdminUsersRoute.page, path: 'users'),
  AutoRoute(page: AdminSessionsRoute.page, path: 'sessions'),
  AutoRoute(page: AdminTasksRoute.page, path: 'tasks'),
  AutoRoute(page: AdminDevicesRoute.page, path: 'devices'),
  AutoRoute(page: AdminLibrariesRoute.page, path: 'libraries'),
  AutoRoute(page: AdminTranscodingRoute.page, path: 'transcoding'),
  AutoRoute(page: AdminResumeRoute.page, path: 'resume'),
  AutoRoute(page: AdminStreamingRoute.page, path: 'streaming'),
  AutoRoute(page: AdminTrickplayRoute.page, path: 'trickplay'),
  AutoRoute(page: AdminDisplayRoute.page, path: 'display'),
  AutoRoute(page: AdminMetadataRoute.page, path: 'metadata'),
  AutoRoute(page: AdminNfoRoute.page, path: 'nfo'),
];

final List<AutoRoute> _defaultRoutes = [
  AutoRoute(page: SplashRoute.page, path: '/splash'),
  AutoRoute(page: LoginRoute.page, path: '/login', maintainState: false),
];

final List<AutoRoute> _settingsChildren = [
  AutoRoute(page: SettingsSelectionRoute.page, path: 'list'),
  // New categorized settings pages - Dashboard is first (default)
  AutoRoute(page: DashboardSettingsRoute.page, path: 'dashboard'),
  AutoRoute(page: DetailsSettingsRoute.page, path: 'details'),
  AutoRoute(page: DownloadsSettingsRoute.page, path: 'downloads'),
  AutoRoute(page: LibrariesSettingsRoute.page, path: 'libraries'),
  AutoRoute(page: GeneralUiSettingsRoute.page, path: 'general-ui'),
  AutoRoute(page: AdvancedSettingsRoute.page, path: 'advanced'),
  // Original settings pages (Profile, Player, About kept. Client/Kebap deprecated)
  AutoRoute(page: ProfileSettingsRoute.page, path: 'security'),
  AutoRoute(page: PlayerSettingsRoute.page, path: 'player'),
  AutoRoute(page: AboutSettingsRoute.page, path: 'about'),
  AutoRoute(page: ContentFilterSettingsRoute.page, path: 'content-filter'),
  // Deprecated - settings moved to categorized pages above
  // AutoRoute(page: ClientSettingsRoute.page, path: 'client'),
  // AutoRoute(page: KebapSettingsRoute.page, path: 'kebap'),
];

class LockScreenGuard extends AutoRouteGuard {
  final WidgetRef ref;

  const LockScreenGuard({required this.ref});

  @override
  Future<void> onNavigation(NavigationResolver resolver, StackRouter router) async {
    if (ref.read(lockScreenActiveProvider) && resolver.routeName != const LockRoute().routeName) {
      router.replace(const LockRoute());
      return;
    } else {
      return resolver.next(true);
    }
  }
}

class AuthGuard extends AutoRouteGuard {
  final WidgetRef ref;

  const AuthGuard({required this.ref});

  @override
  Future<void> onNavigation(NavigationResolver resolver, StackRouter router) async {
    // Check connectivity on navigation
    ref.read(connectivityStatusProvider.notifier).checkConnectivity();

    if (resolver.route == router.current.route) {
      return;
    }

    if (ref.read(userProvider) != null ||
        resolver.routeName == const LoginRoute().routeName ||
        resolver.routeName == SplashRoute().routeName) {
      // We assume the last main focus is no longer active after navigating
      lastMainFocus = null;
      return resolver.next(true);
    }

    resolver.redirectUntil<bool>(SplashRoute(loggedIn: (value) {
      if (value) {
        resolver.next(true);
      } else {
        router.replace(const LoginRoute());
      }
    }));

    // We assume the last main focus is no longer active after navigating
    lastMainFocus = null;
    return;
  }
}
