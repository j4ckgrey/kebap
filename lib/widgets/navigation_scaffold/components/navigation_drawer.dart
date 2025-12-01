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
import 'package:kebap/widgets/navigation_scaffold/components/navigation_body.dart';
import 'package:kebap/widgets/navigation_scaffold/components/settings_user_icon.dart';
import 'package:kebap/widgets/requests/requests_sheet.dart';
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
      super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final useLibraryPosters = ref.watch(clientSettingsProvider.select((value) => value.usePosterForLibrary));
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.backspace): () => Scaffold.of(context).closeDrawer(),
        const SingleActivator(LogicalKeyboardKey.escape): () => Scaffold.of(context).closeDrawer(),
        const SingleActivator(LogicalKeyboardKey.arrowRight): () => Scaffold.of(context).closeDrawer(),
      },
      child: FocusTraversalGroup(
        policy: CyclicTraversalPolicy(),
        child: NavigationDrawer(
          key: const Key('navigation_drawer'),
          backgroundColor: isExpanded ? Colors.transparent : null,
          surfaceTintColor: isExpanded ? Colors.transparent : null,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(28, AdaptiveLayout.of(context).isDesktop || kIsWeb ? 0 : 16, 16, 0),
              child: Row(
                children: [
                  Expanded(
                    child: FocusButton(
                      onTap: () {
                        context.router.push(LibrarySearchRoute());
                        Scaffold.of(context).closeDrawer();
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              IconsaxPlusLinear.search_normal,
                              size: 20,
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              context.localized.search,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (AdaptiveLayout.viewSizeOf(context) != ViewSize.television)
                    IconButton(
                      onPressed: () => toggleExpanded(false),
                      icon: const Icon(IconsaxPlusLinear.sidebar_left),
                    ),
                ],
              ),
            ),
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
              (destination) => DrawerListButton(
                label: destination.label,
                selected: context.router.current.name == destination.route?.routeName,
                autofocus: context.router.current.name == destination.route?.routeName,
                selectedIcon: destination.selectedIcon!,
                icon: destination.icon!,
                onPressed: () {
                  destination.action!();
                  Scaffold.of(context).closeDrawer();
                },
              ),
            ),
            if (views.isNotEmpty) ...{
              const Divider(indent: 28, endIndent: 28),
              Padding(
                padding: const EdgeInsets.fromLTRB(28, 16, 16, 10),
                child: Text(
                  context.localized.library(2),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              ...views.map((library) {
                var selected = context.router.currentUrl.contains(library.id);
                final Widget? posterIcon = useLibraryPosters
                    ? ClipRRect(
                        borderRadius: KebapTheme.smallShape.borderRadius,
                        child: AspectRatio(
                          aspectRatio: 1.0,
                          child: KebapImage(
                            image: library.imageData?.primary,
                            placeHolder: Card(
                              child: Icon(
                                selected ? library.collectionType.icon : library.collectionType.iconOutlined,
                              ),
                            ),
                          ),
                        ),
                      )
                    : null;
                return DrawerListButton(
                    label: library.name,
                    selected: selected,
                    autofocus: selected,
                    actions: [
                      ItemActionButton(
                        label: Text(context.localized.scanLibrary),
                        icon: const Icon(IconsaxPlusLinear.refresh),
                        action: () => showRefreshPopup(context, library.id, library.name),
                      ),
                    ],
                    onPressed: () {
                      context.router.push(LibrarySearchRoute(viewModelId: library.id));
                      Scaffold.of(context).closeDrawer();
                    },
                    selectedIcon: posterIcon ?? Icon(library.collectionType.icon),
                    icon: posterIcon ?? Icon(library.collectionType.iconOutlined));
              }),
            },

            const Divider(indent: 28, endIndent: 28),

            if (isExpanded)
              Transform.translate(
                offset: const Offset(-8, 0),
                child: DrawerListButton(
                  label: context.localized.settings,
                  selectedIcon: const Icon(IconsaxPlusBold.setting_3),
                  selected: currentLocation.contains(const SettingsRoute().routeName),
                  autofocus: currentLocation.contains(const SettingsRoute().routeName),
                  icon: const SizedBox(width: 35, height: 35, child: SettingsUserIcon()),
                  onPressed: () {
                    switch (AdaptiveLayout.layoutModeOf(context)) {
                      case LayoutMode.single:
                        const SettingsRoute().push(context);
                        break;
                      case LayoutMode.dual:
                        context.router.push(const ClientSettingsRoute());
                        break;
                    }
                    Scaffold.of(context).closeDrawer();
                  },
                ),
              )
            else
              DrawerListButton(
                label: context.localized.settings,
                selectedIcon: const Icon(IconsaxPlusBold.setting_2),
                icon: const Icon(IconsaxPlusLinear.setting_2),
                selected: currentLocation.contains(const SettingsRoute().routeName),
                autofocus: currentLocation.contains(const SettingsRoute().routeName),
                onPressed: () {
                  switch (AdaptiveLayout.layoutModeOf(context)) {
                    case LayoutMode.single:
                      const SettingsRoute().push(context);
                      break;
                    case LayoutMode.dual:
                      context.router.push(const ClientSettingsRoute());
                      break;
                  }
                  Scaffold.of(context).closeDrawer();
                },
              ),
            if (AdaptiveLayout.of(context).isDesktop || kIsWeb) const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
