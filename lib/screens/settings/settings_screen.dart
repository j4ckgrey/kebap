import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:window_manager/window_manager.dart';

import 'package:kebap/providers/arguments_provider.dart';
import 'package:kebap/providers/auth_provider.dart';
import 'package:kebap/providers/update_provider.dart';
import 'package:kebap/providers/user_provider.dart';
import 'package:kebap/routes/auto_router.gr.dart';
import 'package:kebap/screens/settings/quick_connect_window.dart';
import 'package:kebap/screens/settings/settings_list_tile.dart';
import 'package:kebap/screens/settings/settings_scaffold.dart';
import 'package:kebap/screens/settings/widgets/settings_left_pane.dart';
import 'package:kebap/util/adaptive_layout/adaptive_layout.dart';
import 'package:kebap/util/localization_helper.dart';
import 'package:kebap/util/theme_extensions.dart';

@RoutePage()
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final scrollController = ScrollController();
  final minVerticalPadding = 20.0;
  late LayoutMode lastAdaptiveLayout = AdaptiveLayout.layoutModeOf(context);

  @override
  Widget build(BuildContext context) {
    final isSingle = AdaptiveLayout.layoutModeOf(context) == LayoutMode.single;
    return AutoTabsRouter(
      // Disable transition animation on mobile to prevent showing both screens at once
      duration: isSingle ? Duration.zero : const Duration(milliseconds: 300),
      builder: (context, content) {
        checkForNullIndex(context);
        return PopScope(
          canPop: context.tabsRouter.activeIndex == 0 || AdaptiveLayout.layoutModeOf(context) == LayoutMode.dual,
          onPopInvokedWithResult: (didPop, result) {
            if (!didPop) {
              context.tabsRouter.setActiveIndex(0);
            }
          },
          child: isSingle
              // On mobile, just render the content from AutoTabsRouter
              // SettingsSelectionScreen (index 0) now renders SettingsLeftPane
              ? content
              : Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 2,
                      child: SettingsLeftPane(activeRouteName: context.tabsRouter.current.name),
                    ),
                    Expanded(
                      flex: 3,
                      child: Focus(
                        skipTraversal: true,
                        canRequestFocus: false,
                        onKeyEvent: (node, event) {
                          // Check if we should block the key
                          if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
                            return KeyEventResult.ignored;
                          }
                          
                          final key = event.logicalKey;
                          if (key != LogicalKeyboardKey.arrowUp && key != LogicalKeyboardKey.arrowDown) {
                            return KeyEventResult.ignored;
                          }
                          
                          // Find the primary focus
                          final primaryFocus = FocusManager.instance.primaryFocus;
                          if (primaryFocus == null) return KeyEventResult.ignored;
                          
                          // Check if the focused widget is a descendant of this node
                          if (!node.descendants.contains(primaryFocus)) {
                            return KeyEventResult.ignored;
                          }
                          
                          // Get all focusable descendants in tree order
                          final descendants = node.descendants.where((n) => n.canRequestFocus).toList();
                          
                          if (descendants.isEmpty) return KeyEventResult.ignored;
                          
                          final currentIndex = descendants.indexOf(primaryFocus);
                          if (currentIndex == -1) return KeyEventResult.ignored;
                          
                          // Block up at first item, down at last item
                          if (key == LogicalKeyboardKey.arrowUp && currentIndex == 0) {
                            return KeyEventResult.handled;
                          }
                          if (key == LogicalKeyboardKey.arrowDown && currentIndex == descendants.length - 1) {
                            return KeyEventResult.handled;
                          }
                          
                          return KeyEventResult.ignored;
                        },
                        child: content,
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  //We have to navigate to the first screen after switching layouts && index == 0 otherwise the dual-layout is empty
  void checkForNullIndex(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentIndex = context.tabsRouter.activeIndex;
      if (AdaptiveLayout.layoutModeOf(context) == LayoutMode.dual && currentIndex == 0) {
        context.tabsRouter.setActiveIndex(1);
      }
    });
  }
}

