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
import 'package:kebap/screens/shared/default_alert_dialog.dart';
import 'package:kebap/screens/shared/kebap_icon.dart';
import 'package:kebap/screens/shared/kebap_snackbar.dart';
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
              // On mobile, show either the settings list (index 0) or the sub-page content,
              // NOT both in a Stack, to avoid visual doubling/stutter during navigation.
              ? context.tabsRouter.activeIndex == 0
                  ? const Card(elevation: 0, child: SettingsLeftPane())
                  : content
              : Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Expanded(flex: 2, child: SettingsLeftPane()),
                    Expanded(
                      flex: 3,
                      child: content,
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

