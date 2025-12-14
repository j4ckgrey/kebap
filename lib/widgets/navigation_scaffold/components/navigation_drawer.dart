import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import 'package:kebap/models/collection_types.dart';
import 'package:kebap/models/view_model.dart';
import 'package:kebap/providers/settings/client_settings_provider.dart';
import 'package:kebap/routes/auto_router.gr.dart';
import 'package:kebap/screens/metadata/refresh_metadata.dart';
import 'package:kebap/screens/shared/animated_fade_size.dart';
import 'package:kebap/theme.dart';
import 'package:kebap/util/adaptive_layout/adaptive_layout.dart';
import 'package:kebap/util/focus_provider.dart';
import 'package:kebap/util/kebap_image.dart';
import 'package:kebap/util/localization_helper.dart';
import 'package:kebap/widgets/navigation_scaffold/components/adaptive_fab.dart';
import 'package:kebap/widgets/navigation_scaffold/components/destination_model.dart';
import 'package:kebap/widgets/navigation_scaffold/components/drawer_list_button.dart';
import 'package:kebap/widgets/navigation_scaffold/components/settings_user_icon.dart';
import 'package:kebap/widgets/shared/item_actions.dart';

class NestedNavigationDrawer extends ConsumerWidget {
  final bool isExpanded;
  final Function(bool expanded) toggleExpanded;
  final List<DestinationModel> destinations;
  final AdaptiveFab? actionButton;
  final List<ViewModel> views;
  final String currentLocation;
  const NestedNavigationDrawer(
      {this.isExpanded = false,
      required this.toggleExpanded,
      required this.actionButton,
      required this.destinations,
      required this.views,
      required this.currentLocation,
      this.firstItemFocusNode,
      super.key});

  final FocusNode? firstItemFocusNode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final useLibraryPosters = ref.watch(clientSettingsProvider.select((value) => value.usePosterForLibrary));
    return FocusTraversalGroup(
      policy: WidgetOrderTraversalPolicy(),
      child: CallbackShortcuts(
        bindings: {
          const SingleActivator(LogicalKeyboardKey.backspace): () => Scaffold.of(context).closeDrawer(),
          const SingleActivator(LogicalKeyboardKey.escape): () => Scaffold.of(context).closeDrawer(),
        },
        child: NavigationDrawer(
          key: const Key('navigation_drawer'),
          backgroundColor: isExpanded ? Colors.transparent : null,
          surfaceTintColor: isExpanded ? Colors.transparent : null,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(28, AdaptiveLayout.of(context).isDesktop || kIsWeb ? 0 : 16, 16, 0),
              child: Shortcuts(
                shortcuts: {
                  const SingleActivator(LogicalKeyboardKey.arrowLeft): const DoNothingIntent(),
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Focus(
                        focusNode: firstItemFocusNode,
                        autofocus: true,
                        onKey: (node, event) {
                          if (event is RawKeyDownEvent) {
                            if (event.logicalKey == LogicalKeyboardKey.enter ||
                                event.logicalKey == LogicalKeyboardKey.select ||
                                event.logicalKey == LogicalKeyboardKey.numpadEnter) {
                              context.router.push(LibrarySearchRoute());
                              Scaffold.of(context).closeDrawer();
                              return KeyEventResult.handled;
                            }
                          }
                          return KeyEventResult.ignored;
                        },
                        onFocusChange: (hasFocus) {
                          if (hasFocus && isExpanded == false) {
                            // Ensure drawer is open if somehow focused while closed? Unlikely but safe.
                          }
                        },
                        child: Builder(builder: (context) {
                          final hasFocus = Focus.of(context).hasFocus;
                          return InkWell(
                            onTap: () {
                              context.router.push(LibrarySearchRoute());
                              Scaffold.of(context).closeDrawer();
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: hasFocus
                                    ? Theme.of(context).colorScheme.primaryContainer
                                    : Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: hasFocus ? Theme.of(context).colorScheme.primary : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    IconsaxPlusLinear.search_normal,
                                    size: 20,
                                    color: hasFocus
                                        ? Theme.of(context).colorScheme.onPrimaryContainer
                                        : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    context.localized.search,
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: hasFocus
                                          ? Theme.of(context).colorScheme.onPrimaryContainer
                                          : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    if (AdaptiveLayout.viewSizeOf(context) != ViewSize.television) ...[
                      const SizedBox(width: 8),
                      Focus(
                        onKey: (node, event) {
                          if (event is RawKeyDownEvent) {
                            if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
                              Scaffold.of(context).closeDrawer();
                              return KeyEventResult.handled;
                            } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
                               firstItemFocusNode?.requestFocus();
                               return KeyEventResult.handled;
                            }
                          }
                          return KeyEventResult.ignored;
                        },
                        child: const SizedBox(
                          width: 40,
                          height: 40,
                          child: SettingsUserIcon(),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: actionButton != null ? 8 : 0),
              child: AnimatedFadeSize(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child: actionButton?.extended,
                ),
              ),
            ),
            ...destinations.map(
              (destination) => Focus(
                onKey: (node, event) {
                  if (event is RawKeyDownEvent && event.logicalKey == LogicalKeyboardKey.arrowRight) {
                    Scaffold.of(context).closeDrawer();
                    return KeyEventResult.handled;
                  }
                  return KeyEventResult.ignored;
                },
                child: DrawerListButton(
                  key: ValueKey(destination.label),
                  label: destination.label,
                  selected: context.router.current.name == destination.route?.routeName,
                  autofocus: context.router.current.name == destination.route?.routeName,
                  selectedIcon: destination.selectedIcon!,
                  icon: destination.icon!,
                  badge: destination.badge,
                  onPressed: () {
                    destination.action!();
                    Scaffold.of(context).closeDrawer();
                  },
                ),
              ),
            ),
            if (AdaptiveLayout.of(context).isDesktop || kIsWeb) const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
