import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import 'package:kebap/providers/arguments_provider.dart';
import 'package:kebap/providers/settings/client_settings_provider.dart';
import 'package:kebap/providers/views_provider.dart';
import 'package:kebap/util/adaptive_layout/adaptive_layout.dart';
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

    // Check if running on TV
    final isTV = ref.watch(argumentsStateProvider.select((args) => args.leanBackMode));
    final currentInputDevice = AdaptiveLayout.inputDeviceOf(context);

    // Navigation visibility logic
    final isSettingsPage = widget.currentLocation.toLowerCase().contains('settings');
    final isDetailsPage = widget.currentLocation.toLowerCase().contains('details');
    final isSearchPage = widget.currentLocation.toLowerCase().contains('search');
    final isAdminPage = widget.currentLocation.toLowerCase().contains('admin');
    
    // Settings, Search & Admin: No navigation
    // Details: Back button on left, no hamburger
    // Others: Hamburger on left, Back on right
    // TV: No buttons shown (remote has back button), left navigation opens drawer
    
    final showNavigation = !isSettingsPage && !isSearchPage && !isAdminPage;
    final showHamburger = !isDetailsPage && showNavigation;
    final showBackButton = showNavigation; // Back button always shown if navigation is shown (except settings/admin)
    
    // On details page, back button is on the left (replaces hamburger position)
    // On other pages, back button is on the right

    final topInset = MediaQuery.paddingOf(context).top;

    return BackIntentDpad(
      child: FocusTraversalGroup(
        policy: GlobalFallbackTraversalPolicy(
          fallbackNode: navBarNode,
          drawerKey: widget.drawerKey,
          inputDevice: currentInputDevice,
          showHamburger: !isDetailsPage && !isSettingsPage && !isSearchPage && !isAdminPage,
        ),
        child: Stack(
          children: [
            // Main content - full screen
            Positioned.fill(
              child: widget.child,
            ),
            // Floating navigation buttons (hidden on TV since remotes have back buttons)
            // Use AnimatedOpacity to smoothly fade buttons during route transitions
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: IgnorePointer(
                ignoring: !showNavigation || isTV,
                child: AnimatedOpacity(
                  opacity: (showNavigation && !isTV) ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: topInset + (kIsWeb ? 24 : 8),
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
                        if (!isDetailsPage && showBackButton && widget.currentIndex != 0)
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
  final GlobalKey<ScaffoldState>? drawerKey;
  final InputDevice inputDevice;
  final bool showHamburger;

  GlobalFallbackTraversalPolicy({
    required this.fallbackNode,
    this.drawerKey,
    this.inputDevice = InputDevice.pointer,
    this.showHamburger = false,
  }) : super();

  @override
  bool inDirection(FocusNode currentNode, TraversalDirection direction) {
    lastMainFocus = null;
    final handled = super.inDirection(currentNode, direction);
    
    // Handle edge navigation (Left or Up) to open drawer
    if (!handled && (direction == TraversalDirection.left || direction == TraversalDirection.up)) {
      lastMainFocus = currentNode;

      // 1. Try to focus the hamburger button if it exists and is focusable
      if (fallbackNode.canRequestFocus && fallbackNode.context?.mounted == true) {
        final cb = FocusTraversalPolicy.defaultTraversalRequestFocusCallback;
        cb(fallbackNode);
        return true;
      }
      
      // 2. If hamburger is hidden (e.g. TV), open the drawer directly
      if (drawerKey?.currentState != null) {
        drawerKey!.currentState!.openDrawer();
        return true;
      }
    }
    return handled;
  }
}
