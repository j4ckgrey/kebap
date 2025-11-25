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
    
    // Handle LEFT navigation for navbar fallback (original Fladder behavior)
    // This is for when content is at the left edge
    if (!handled && direction == TraversalDirection.left) {
      lastMainFocus = currentNode;

      if (fallbackNode.canRequestFocus && fallbackNode.context?.mounted == true) {
        final cb = FocusTraversalPolicy.defaultTraversalRequestFocusCallback;
        cb(fallbackNode);
        return true;
      }
    }
    
    // Handle UP navigation to navbar (adapted for top navbar instead of left sidebar)
    // Only go to navbar if we're truly at the top with nowhere else to go
    if (!handled && direction == TraversalDirection.up) {
      lastMainFocus = currentNode;
      
      // Try to focus the first nav button
      if (firstNavButtonNode != null && firstNavButtonNode!.canRequestFocus) {
        firstNavButtonNode!.requestFocus();
        return true;
      }
      
      // Fallback to navbar node
      if (navBarNode.canRequestFocus && navBarNode.context?.mounted == true) {
        final cb = FocusTraversalPolicy.defaultTraversalRequestFocusCallback;
        cb(navBarNode);
        return true;
      }
    }

    return handled;
  }
}
