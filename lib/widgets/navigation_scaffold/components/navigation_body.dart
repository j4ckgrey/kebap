import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kebap/providers/settings/client_settings_provider.dart';
import 'package:kebap/providers/views_provider.dart';
import 'package:kebap/routes/auto_router.dart';
import 'package:kebap/util/adaptive_layout/adaptive_layout.dart';
import 'package:kebap/widgets/navigation_scaffold/components/destination_model.dart';
import 'package:kebap/widgets/navigation_scaffold/components/side_navigation_bar.dart';
import 'package:kebap/widgets/navigation_scaffold/components/top_navigation_bar.dart';
import 'package:kebap/widgets/shared/back_intent_dpad.dart';

class NavigationBody extends ConsumerStatefulWidget {
  final BuildContext parentContext;
  final Widget child;
  final int currentIndex;
  final List<DestinationModel> destinations;
  final String currentLocation;
  final GlobalKey<ScaffoldState> drawerKey;
  const NavigationBody({
    required this.parentContext,
    required this.child,
    required this.currentIndex,
    required this.destinations,
    required this.currentLocation,
    required this.drawerKey,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NavigationBodyState();
}

class _NavigationBodyState extends ConsumerState<NavigationBody> {
  double currentSideBarWidth = 80;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((value) {
      ref.read(viewsProvider.notifier).fetchViews();
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasOverlay = AdaptiveLayout.layoutModeOf(context) == LayoutMode.dual ||
        homeRoutes.any((element) => element.name.contains(context.router.current.name));

    ref.listen(
      clientSettingsProvider,
      (previous, next) {
        if (previous != next) {
          SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            statusBarIconBrightness: next.statusBarBrightness(context),
          ));
        }
      },
    );

    // Determine whether we should reserve top padding for an overlay navbar.
    const useTopNavbar = true;
    final effectiveHasOverlay = useTopNavbar || hasOverlay;

    Widget paddedChild() => MediaQuery(
          data: semiNestedPadding(widget.parentContext, effectiveHasOverlay),
          child: widget.child,
        );

    final wrapped = BackIntentDpad(
      child: FocusTraversalGroup(
        policy: GlobalFallbackTraversalPolicy(fallbackNode: navBarNode),
        child: paddedChild(),
      ),
    );

    // Treat detail routes as full content pages that shouldn't get the side navigation
    final isDetailRoute = detailsRoutes.any((element) => element.name.contains(context.router.current.name));
    if (isDetailRoute) return wrapped;

    // Feature: use top navbar instead of side rail. Only enable on desktop
    // layouts — hide the navbar entirely on mobile devices where a different
    // navigation control is used.
    // Navbar is now rendered ABOVE the content (not overlaid) so it scrolls naturally
    final enableTopNavbar = AdaptiveLayout.of(context).isDesktop && useTopNavbar;
    if (enableTopNavbar) {
      return BackIntentDpad(
        child: FocusTraversalGroup(
          policy: GlobalFallbackTraversalPolicy(fallbackNode: navBarNode),
          child: Column(
            children: [
              TopNavigationBar(
                destinations: widget.destinations,
                currentIndex: widget.currentIndex,
                currentLocation: widget.currentLocation,
                scaffoldKey: widget.drawerKey,
              ),
              Expanded(
                child: MediaQuery(
                  data: semiNestedPadding(widget.parentContext, effectiveHasOverlay),
                  child: widget.child,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Fallback to original side navigation behavior
    return SideNavigationBar(
      currentIndex: widget.currentIndex,
      destinations: widget.destinations,
      currentLocation: widget.currentLocation,
      child: wrapped,
      scaffoldKey: widget.drawerKey,
    );
  }

  MediaQueryData semiNestedPadding(BuildContext context, bool hasOverlay) {
    final paddingOf = MediaQuery.paddingOf(context);
    // Add space for top navbar on desktop: system top inset is already in paddingOf.top,
    // so we only need to add the navbar content height (56px)
    const navbarContentHeight = 56.0;
    const useTopNavbar = true;
    final enableTopNavbar = AdaptiveLayout.of(context).isDesktop && useTopNavbar;
    final topPadding = (hasOverlay && enableTopNavbar) ? (paddingOf.top + navbarContentHeight) : paddingOf.top;

    return MediaQuery.of(context).copyWith(
      padding: paddingOf.copyWith(top: topPadding, left: hasOverlay ? 0 : paddingOf.left),
    );
  }
}

FocusNode? lastMainFocus;

class GlobalFallbackTraversalPolicy extends ReadingOrderTraversalPolicy {
  final FocusNode fallbackNode;

  GlobalFallbackTraversalPolicy({required this.fallbackNode}) : super();

  @override
  bool inDirection(FocusNode currentNode, TraversalDirection direction) {
    lastMainFocus = null;
    final handled = super.inDirection(currentNode, direction);
    
    // Only fall back to navbar on LEFT when we're truly stuck at the edge
    // (not in the middle of content navigation)
    if (!handled && direction == TraversalDirection.left) {
      lastMainFocus = currentNode;

      // Try to focus the first navigation button if it's registered.
      try {
        if (firstNavButtonNode != null && firstNavButtonNode!.canRequestFocus) {
          firstNavButtonNode!.requestFocus();
          return true;
        }
      } catch (_) {}

      if (fallbackNode.canRequestFocus && fallbackNode.context?.mounted == true) {
        final cb = FocusTraversalPolicy.defaultTraversalRequestFocusCallback;
        cb(fallbackNode);
        return true;
      }
    }

    // DOWN from navbar should go to first content
    if (direction == TraversalDirection.down) {
      try {
        // Check if we're in the navbar
        final inNavBar = navBarNode.descendants.contains(currentNode) || 
                        currentNode == firstNavButtonNode ||
                        currentNode == navBarNode;
        
        if (inNavBar && firstContentNode != null && firstContentNode!.canRequestFocus) {
          firstContentNode!.requestFocus();
          return true;
        }
      } catch (_) {}
    }

    // UP from content should go to navbar
    if (direction == TraversalDirection.up) {
      // If we are at the top of the content (conceptually), try to go to navbar
      // This is a fallback if the specific widget policy didn't handle it
      try {
        if (firstNavButtonNode != null && firstNavButtonNode!.canRequestFocus) {
          firstNavButtonNode!.requestFocus();
          return true;
        }
        if (navBarNode.canRequestFocus) {
          navBarNode.requestFocus();
          return true;
        }
      } catch (_) {}
    }

    return handled;
  }
}
