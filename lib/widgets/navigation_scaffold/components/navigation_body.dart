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
    // Keep as a non-constant variable so analyzer won't treat branches as dead.
    // ignore: dead_code
    var useTopNavbar = true;
    final effectiveHasOverlay = useTopNavbar || hasOverlay;

    // Use Top Navbar for both Desktop and Mobile if enabled
    // This replaces the side rail on mobile with the top navbar
    final enableTopNavbar = useTopNavbar;

    if (enableTopNavbar) {
      return BackIntentDpad(
        child: FocusTraversalGroup(
          policy: GlobalFallbackTraversalPolicy(fallbackNode: navBarNode),
          child: NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  forceElevated: innerBoxIsScrolled,
                  primary: false,
                  floating: false,
                  snap: false,
                  pinned: true,
                  automaticallyImplyLeading: false,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  elevation: 0,
                  scrolledUnderElevation: 0,
                  // Height includes status bar + content
                  toolbarHeight: MediaQuery.paddingOf(context).top + 56.0,
                  expandedHeight: MediaQuery.paddingOf(context).top + 56.0,
                  flexibleSpace: TopNavigationBar(
                    destinations: widget.destinations,
                    currentIndex: widget.currentIndex,
                    currentLocation: widget.currentLocation,
                    scaffoldKey: widget.drawerKey,
                  ),
                ),
              ];
            },
            body: MediaQuery(
              // Remove top padding from body as it's handled by the sliver app bar's displacement
              // or the content's own padding if needed.
              // But we might need to ensure content doesn't overlap if it's not scrolled?
              // NestedScrollView body starts *below* the sliver if pinned, or at top if floating?
              // With floating, it scrolls under.
              // We want consistent padding.
              data: MediaQuery.of(context).copyWith(
                  padding: MediaQuery.paddingOf(context).copyWith(top: 0)
              ),
              child: widget.child,
            ),
          ),
        ),
      );
    }

    // Fallback to original side navigation behavior (only if useTopNavbar is false)
    return SideNavigationBar(
      currentIndex: widget.currentIndex,
      destinations: widget.destinations,
      currentLocation: widget.currentLocation,
      child: widget.child, // Removed wrapped/padding logic as it was specific to the old layout
      scaffoldKey: widget.drawerKey,
    );
  }

  MediaQueryData semiNestedPadding(BuildContext context, bool hasOverlay, bool useTopNavbar) {
    // This method might be obsolete with NestedScrollView but keeping it for now if needed by other widgets
    // or if we revert.
    final paddingOf = MediaQuery.paddingOf(context);
    const navbarContentHeight = 56.0;
    // For NestedScrollView with floating navbar, the content should probably start with top padding
    // equal to the navbar height so it's initially visible?
    // Or NestedScrollView handles it?
    // Usually NestedScrollView body is placed below the header.
    return MediaQuery.of(context);
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
    try {
      debugPrint('[GlobalFallback] inDirection: direction=$direction handled=$handled currentNode=${currentNode.runtimeType} ${currentNode.toString()}');
      debugPrint('[GlobalFallback] nodes: firstContentNode=${firstContentNode?.toString()} firstNavButtonNode=${firstNavButtonNode?.toString()} navBarNode=${navBarNode.toString()} fallbackNode=${fallbackNode.toString()}');
    } catch (_) {}
    
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

    // UP navigation: when at the first content node, move focus to the navbar
    if (direction == TraversalDirection.up) {
      try {
        final primary = FocusManager.instance.primaryFocus;
        final atFirstContent = firstContentNode != null && (
          currentNode == firstContentNode ||
          currentNode.descendants.contains(firstContentNode) ||
          primary == firstContentNode
        );
        debugPrint('[GlobalFallback] UP navigation check: atFirstContent=$atFirstContent primary=$primary');
        if (atFirstContent) {
          // Prefer focusing the first navigation button if available
          if (firstNavButtonNode != null && firstNavButtonNode!.canRequestFocus) {
            firstNavButtonNode!.requestFocus();
            return true;
          }
          if (navBarNode.canRequestFocus) {
            final cb = FocusTraversalPolicy.defaultTraversalRequestFocusCallback;
            cb(navBarNode);
            return true;
          }
        }

        // If the focused widget is a nested BackButton (like in Settings where
        // the back control is placed inline rather than in an AppBar), allow
        // UP to focus the navbar. We check for a BackButton ancestor which is
        // a reliable indicator of a 'back' control in content.
        if (!atFirstContent) {
          try {
            final ctx = currentNode.context;
            final hasBackButtonAncestor = ctx != null && ctx.findAncestorWidgetOfExactType<BackButton>() != null;
            debugPrint('[GlobalFallback] UP BackButton check: hasBack=$hasBackButtonAncestor ctx=$ctx');
            if (hasBackButtonAncestor) {
              if (firstNavButtonNode != null && firstNavButtonNode!.canRequestFocus) {
                firstNavButtonNode!.requestFocus();
                return true;
              }
              if (navBarNode.canRequestFocus) {
                final cb = FocusTraversalPolicy.defaultTraversalRequestFocusCallback;
                cb(navBarNode);
                return true;
              }
            }
          } catch (e) {
            debugPrint('[GlobalFallback] BackButton check error: $e');
          }
        }
      } catch (e) {
        debugPrint('[GlobalFallback] UP handler error: $e');
      }
    }

    return handled;
  }
}
