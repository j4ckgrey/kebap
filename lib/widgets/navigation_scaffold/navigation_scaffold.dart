import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide ConnectionState;
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter/services.dart';
import 'package:kebap/util/localization_helper.dart';
import 'package:window_manager/window_manager.dart';

import 'package:kebap/models/media_playback_model.dart';
import 'package:kebap/providers/arguments_provider.dart';
import 'package:kebap/providers/connectivity_provider.dart';
import 'package:kebap/providers/video_player_provider.dart';
import 'package:kebap/providers/views_provider.dart';
import 'package:kebap/routes/auto_router.dart';
import 'package:kebap/screens/shared/animated_fade_size.dart';
import 'package:kebap/util/adaptive_layout/adaptive_layout.dart';
import 'package:kebap/widgets/navigation_scaffold/components/destination_model.dart';
import 'package:kebap/widgets/navigation_scaffold/components/kebap_app_bar.dart';
import 'package:kebap/widgets/navigation_scaffold/components/floating_player_bar.dart';
import 'package:kebap/widgets/navigation_scaffold/components/navigation_body.dart';
import 'package:kebap/widgets/navigation_scaffold/components/navigation_drawer.dart';
import 'package:kebap/widgets/shared/clock_badge.dart';
import 'package:kebap/widgets/shared/offline_banner.dart';

class NavigationScaffold extends ConsumerStatefulWidget {
  final String? currentRouteName;
  final Widget? nestedChild;
  final List<DestinationModel> destinations;
  final GlobalKey<NavigatorState>? nestedNavigatorKey;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  const NavigationScaffold({
    this.currentRouteName,
    this.nestedChild,
    required this.destinations,
    this.nestedNavigatorKey,
    this.scaffoldKey,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NavigationScaffoldState();
}

class _NavigationScaffoldState extends ConsumerState<NavigationScaffold> with WindowListener {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final FocusNode _drawerFirstItemFocusNode = FocusNode();
  GlobalKey<ScaffoldState> get _effectiveKey => widget.scaffoldKey ?? _key;
  bool _isDrawerOpen = false;
  bool _isExiting = false;

  int get currentIndex =>
      widget.destinations.indexWhere((element) => element.route?.routeName == widget.currentRouteName);
  String get currentLocation => widget.currentRouteName ?? "Nothing";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((value) {
      ref.read(viewsProvider.notifier).fetchViews();
    });
    windowManager.addListener(this);
    if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
      windowManager.setPreventClose(true);
    }
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    _drawerFirstItemFocusNode.dispose();
    super.dispose();
  }

  @override
  void onWindowClose() {
    _handleExit();
  }

  Future<void> _handleExit() async {
    // Web browsers don't support exit(0) and SystemNavigator.pop() often freezes/crashes the tab.
    // Generally, web apps shouldn't try to close themselves.
    if (kIsWeb) return;

    setState(() {
      _isExiting = true;
    });

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

    if (mounted) {
      setState(() {
        _isExiting = false;
      });
    }

    if (shouldExit == true) {
      if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
        exit(0);
      } else {
        SystemNavigator.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTV = ref.watch(argumentsStateProvider.select((args) => args.leanBackMode));
    final playerState = ref.watch(mediaPlaybackProvider.select((value) => value.state));
    final showPlayerBar = playerState == VideoPlayerState.minimized;

    final isDesktop = AdaptiveLayout.of(context).isDesktop || kIsWeb;

    final mediaQuery = MediaQuery.of(context);
    final theme = Theme.of(context);

    final paddingOf = mediaQuery.padding;
    final viewPaddingOf = mediaQuery.viewPadding;

    final bottomPadding = isDesktop ? 12.0 : paddingOf.bottom;
    final bottomViewPadding = isDesktop ? 12.0 : viewPaddingOf.bottom;
    final isHomeScreen = currentIndex != -1;

    final isOffline = ref.watch(connectivityStatusProvider.select((value) => value == ConnectionState.offline));

    final offlineMessageHeight = isOffline && !isDesktop ? 12 : 0;

    final calculatedBottomViewPadding =
        showPlayerBar ? floatingPlayerHeight(context) + bottomViewPadding : bottomViewPadding;

    final fullScreenChildRoute = fullScreenRoutes.contains(context.router.current.name);

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Positioned.fill(
          child: MediaQuery(
              data: mediaQuery.copyWith(
                padding: paddingOf.copyWith(
                  top: mediaQuery.padding.top + offlineMessageHeight,
                  bottom: showPlayerBar ? floatingPlayerHeight(context) + 12 + bottomPadding : bottomPadding,
                ),
                viewPadding: viewPaddingOf.copyWith(
                  top: mediaQuery.viewPadding.top,
                  bottom: calculatedBottomViewPadding,
                ),
              ),
              //Builder to correctly apply new padding
              child: Builder(builder: (context) {
                // Check if we're on a details/nested page (not a main home tab)
                final isDetailsOrNestedPage = currentLocation.toLowerCase().contains('details') ||
                    currentLocation.toLowerCase().contains('settings');
                
                return PopScope(
                  canPop: false,
                  onPopInvoked: (didPop) {
                    if (didPop) return;
                    if (_effectiveKey.currentState?.isDrawerOpen ?? false) {
                      _effectiveKey.currentState?.closeDrawer();
                    } else if (isDetailsOrNestedPage) {
                      // We're on a details/nested page, always try to pop first
                      // This fixes web issue where canPop() returns false after staying on details page
                      context.router.maybePop().then((didPop) {
                        if (!didPop) {
                          // Only show exit dialog if maybePop actually failed
                          _handleExit();
                        }
                      });
                    } else if (context.router.canPop()) {
                      // On home screen, check if we can pop (shouldn't normally happen)
                      context.router.maybePop();
                    } else {
                      // On home screen and can't pop, show exit dialog
                      _handleExit();
                    }
                  },
                  child: Scaffold(
                    key: _effectiveKey,
                  drawerEnableOpenDragGesture: false,
                  appBar: (fullScreenChildRoute || (currentLocation.contains("Settings") && !isDesktop)) ? null : const KebapAppBar(),
                  extendBodyBehindAppBar: false,
                  resizeToAvoidBottomInset: false,
                  extendBody: true,
                  onDrawerChanged: (isOpened) {
                    setState(() {
                      _isDrawerOpen = isOpened;
                    });
                    // When drawer opens, focus its first item
                    if (isOpened) {
                      // Use postFrameCallback to ensure the drawer widget is fully built and attached
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        // Double check if it's still open to avoid race conditions
                        if (_effectiveKey.currentState?.isDrawerOpen ?? false) {
                           if (_drawerFirstItemFocusNode.context != null) {
                            _drawerFirstItemFocusNode.requestFocus();
                          }
                        }
                      });
                    }
                    // When drawer closes, restore focus to the previously focused content item
                    if (!isOpened && lastMainFocus != null && lastMainFocus!.context != null && lastMainFocus!.canRequestFocus) {
                       WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (lastMainFocus != null && lastMainFocus!.context != null && lastMainFocus!.canRequestFocus) {
                          lastMainFocus!.requestFocus();
                        }
                      });
                    }
                  },
                  floatingActionButton: AdaptiveLayout.layoutModeOf(context) == LayoutMode.single && isHomeScreen
                      ? widget.destinations.elementAtOrNull(currentIndex)?.floatingActionButton?.normal
                      : null,
                  drawer: homeRoutes.any((element) => element.name.contains(currentLocation))
                      ? Consumer(
                          builder: (context, ref, child) {
                            final views = ref.watch(viewsProvider.select((value) => value.views));
                            return NestedNavigationDrawer(
                              actionButton: null,
                              toggleExpanded: (value) => _effectiveKey.currentState?.closeDrawer(),
                              views: views,
                              destinations: widget.destinations,
                              currentLocation: currentLocation,
                              firstItemFocusNode: _drawerFirstItemFocusNode,
                            );
                          },
                        )
                      : null,
                  body: widget.nestedChild != null
                      ? FocusScope(
                          canRequestFocus: !_isDrawerOpen && !_isExiting,
                          child: Stack(
                            children: [
                              NavigationBody(
                                child: widget.nestedChild!,
                                parentContext: context,
                                currentIndex: currentIndex,
                                destinations: widget.destinations,
                                currentLocation: currentLocation,
                                drawerKey: _effectiveKey,
                              ),
                              if (!currentLocation.contains("Settings"))
                                IgnorePointer(
                                  child: const Align(
                                    alignment: Alignment.topCenter,
                                    child: SafeArea(
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 8.0),
                                        child: ClockBadge(),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        )
                      : null,
                ),
              );
              }),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: AnimatedFadeSize(
              child: Container(
                width: double.infinity,
                child: showPlayerBar ? const FloatingPlayerBar() : const SizedBox.shrink(),
              ),
            ),
          ),
          if (!AdaptiveLayout.of(context).isDesktop)
            Align(
              alignment: Alignment.topCenter,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 250),
                opacity: isOffline ? 1 : 0,
                child: Container(
                  height: kToolbarHeight + offlineMessageHeight,
                  alignment: Alignment.bottomCenter,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.errorContainer.withValues(alpha: 0.8),
                      theme.colorScheme.errorContainer.withValues(alpha: 0.25),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  )),
                  child: const Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: OfflineBanner(),
                  ),
                ),
              ),
            ),


        ],
      );
  }
}
