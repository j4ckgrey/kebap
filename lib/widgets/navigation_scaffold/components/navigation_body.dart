import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kebap/providers/settings/client_settings_provider.dart';
import 'package:kebap/providers/views_provider.dart';
import 'package:kebap/widgets/navigation_scaffold/components/destination_model.dart';

import 'package:kebap/widgets/navigation_scaffold/components/navigation_constants.dart';
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
              child: widget.child,
            ),
          ],
        ),
      ),
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

    // UP navigation: HorizontalList handles UP from first row to navbar
    // This fallback handles other cases like BackButton widgets
    // UP navigation: Fallback to navbar when at the top of content
    if (direction == TraversalDirection.up) {
      try {
        // If we're here, it means the default traversal didn't find a target UP.
        // This usually means we are at the top of the content.
        // We blindly try to go to the navbar.
        
        if (firstNavButtonNode != null && firstNavButtonNode!.canRequestFocus) {
          firstNavButtonNode!.requestFocus();
          return true;
        }
        if (navBarNode.canRequestFocus) {
          final cb = FocusTraversalPolicy.defaultTraversalRequestFocusCallback;
          cb(navBarNode);
          return true;
        }
      } catch (e) {
        debugPrint('[GlobalFallback] UP handler error: $e');
      }
    }

    return handled;
  }
}
