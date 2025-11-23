import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kebap/widgets/navigation_scaffold/components/destination_model.dart';
import 'package:kebap/widgets/navigation_scaffold/components/navigation_button.dart';
import 'package:kebap/widgets/navigation_scaffold/components/side_navigation_bar.dart';
// removed unused import
import 'package:kebap/widgets/navigation_scaffold/components/adaptive_fab.dart';
import 'package:kebap/widgets/navigation_scaffold/components/settings_user_icon.dart';
import 'package:auto_route/auto_route.dart';
import 'package:kebap/routes/auto_router.gr.dart';
import 'package:kebap/util/adaptive_layout/adaptive_layout.dart';
import 'package:kebap/util/localization_helper.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

// Custom focus policy for navbar that allows continuous left/right navigation in a loop
class NavBarLoopTraversalPolicy extends WidgetOrderTraversalPolicy {
  @override
  bool inDirection(FocusNode currentNode, TraversalDirection direction) {
    // Block up navigation - navbar is at the top
    if (direction == TraversalDirection.up) {
      return true;
    }

    if (direction != TraversalDirection.left && direction != TraversalDirection.right) {
      return super.inDirection(currentNode, direction);
    }

    final parent = currentNode.parent;
    if (parent == null) return super.inDirection(currentNode, direction);

    final nodes = parent.descendants
        .where((n) => n.canRequestFocus && n.context != null)
        .toList()
      ..sort((a, b) => a.rect.left.compareTo(b.rect.left));

    if (nodes.isEmpty) return false;

    final currentIndex = nodes.indexOf(currentNode);
    if (currentIndex == -1) return super.inDirection(currentNode, direction);

    int nextIndex;
    if (direction == TraversalDirection.right) {
      // Loop back to first item when at the end
      nextIndex = (currentIndex + 1) % nodes.length;
    } else {
      // Loop to last item when at the beginning
      nextIndex = (currentIndex - 1 + nodes.length) % nodes.length;
    }

    nodes[nextIndex].requestFocus();
    return true;
  }
}

class TopNavigationBar extends ConsumerWidget {
  final List<DestinationModel> destinations;
  final int currentIndex;
  final String currentLocation;
  final GlobalKey<ScaffoldState> scaffoldKey;
  const TopNavigationBar({
    required this.destinations,
    required this.currentIndex,
    required this.currentLocation,
    required this.scaffoldKey,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Removed LayoutMode.single check to enable on mobile

    final topInset = MediaQuery.paddingOf(context).top;
    final barHeight = 56.0; // content height (excluding system inset)

    return IgnorePointer(
      ignoring: false,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 250),
        opacity: 1,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.45),
          ),
          child: SizedBox(
            height: topInset + barHeight,
            child: Padding(
              padding: EdgeInsets.only(top: topInset),
              child: Focus(
                focusNode: navBarNode,
                child: FocusTraversalGroup(
                  policy: NavBarLoopTraversalPolicy(),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: AdaptiveFab(
                          context: context,
                          title: "",
                          key: const Key('TopNavAction'),
                          onPressed: () => context.router.navigate(LibrarySearchRoute()),
                          child: const Icon(Icons.search),
                        ).normal,
                      ),
                      // Destinations as horizontal buttons in a scrollable view
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: destinations.asMap().entries.map((entry) {
                              final index = entry.key;
                              final destination = entry.value;
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: destination.toNavigationButton(currentIndex == index, true, false,
                                    navFocusNode: index == 0, customIcon: null),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      NavigationButton(
                        label: context.localized.settings,
                        selected: currentLocation.contains(SettingsRoute().routeName),
                        selectedIcon: const Icon(IconsaxPlusBold.setting_3),
                        horizontal: true,
                        expanded: false,
                        icon: const ExcludeFocus(child: SettingsUserIcon()),
                        onPressed: () {
                          if (AdaptiveLayout.layoutModeOf(context) == LayoutMode.single) {
                            context.router.push(SettingsRoute());
                          } else {
                            context.router.push(ClientSettingsRoute());
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
