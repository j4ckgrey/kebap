import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import 'package:kebap/providers/settings/client_settings_provider.dart';
import 'package:kebap/providers/views_provider.dart';
import 'package:kebap/widgets/navigation_scaffold/components/destination_model.dart';
import 'package:kebap/widgets/shared/back_intent_dpad.dart';

final navBarNode = FocusNode();

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

    // Navigation visibility logic
    final isSettingsPage = widget.currentLocation.toLowerCase().contains('settings');
    final isDetailsPage = widget.currentLocation.toLowerCase().contains('details');
    final isSearchPage = widget.currentLocation.toLowerCase().contains('search');
    
    // Settings & Search: No navigation
    // Details: Back button on left, no hamburger
    // Others: Hamburger on left, Back on right
    
    final showNavigation = !isSettingsPage && !isSearchPage;
    final showHamburger = !isDetailsPage && showNavigation;
    final showBackButton = showNavigation; // Back button always shown if navigation is shown (except settings)
    
    // On details page, back button is on the left (replaces hamburger position)
    // On other pages, back button is on the right

    final topInset = MediaQuery.paddingOf(context).top;

    return BackIntentDpad(
      child: FocusTraversalGroup(
        policy: GlobalFallbackTraversalPolicy(fallbackNode: navBarNode),
        child: Stack(
          children: [
            // Main content - full screen
            Positioned.fill(
              child: widget.child,
            ),
            // Floating navigation buttons
            if (showNavigation)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: topInset + 8,
                    left: 8,
                    right: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Left Button Slot (Hamburger or Back)
                      if (isDetailsPage)
                        // Details Page: Back Button on Left
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            icon: const Icon(IconsaxPlusLinear.arrow_left),
                            onPressed: () {
                              context.router.maybePop();
                            },
                          ),
                        )
                      else if (showHamburger)
                        // Standard Page: Hamburger on Left
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            focusNode: navBarNode,
                            icon: const Icon(IconsaxPlusLinear.menu),
                            onPressed: () {
                              widget.drawerKey.currentState?.openDrawer();
                            },
                          ),
                        )
                      else
                        const SizedBox(width: 48), // Spacer if nothing on left

                      // Right Button Slot (Back button for non-details pages)
                      if (!isDetailsPage && showBackButton)
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            icon: const Icon(IconsaxPlusLinear.arrow_left),
                            onPressed: () {
                              context.router.maybePop();
                            },
                          ),
                        )
                      else
                        const SizedBox(width: 48), // Spacer if nothing on right
                    ],
                  ),
                ),
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
    if (currentNode == navBarNode && direction == TraversalDirection.right) {
      if (lastMainFocus != null && lastMainFocus!.context != null && lastMainFocus!.canRequestFocus) {
        lastMainFocus!.requestFocus();
        return true;
      }
    }

    final handled = super.inDirection(currentNode, direction);
    if (!handled && direction == TraversalDirection.left) {
      lastMainFocus = currentNode;

      if (fallbackNode.canRequestFocus && fallbackNode.context?.mounted == true) {
        final cb = FocusTraversalPolicy.defaultTraversalRequestFocusCallback;
        cb(fallbackNode);
        return true;
      }
    }

    return handled;
  }
}
