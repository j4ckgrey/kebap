import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kebap/providers/arguments_provider.dart';
import 'package:kebap/providers/user_provider.dart';
import 'package:kebap/screens/shared/user_icon.dart';
import 'package:kebap/screens/shared/default_title_bar.dart';
import 'package:kebap/util/adaptive_layout/adaptive_layout.dart';
import 'package:kebap/util/router_extension.dart';

class SettingsScaffold extends ConsumerWidget {
  final String label;
  final ScrollController? scrollController;
  final List<Widget> items;
  final List<Widget> bottomActions;
  final bool showUserIcon;
  final bool showBackButtonNested;
  final Widget? floatingActionButton;
  const SettingsScaffold({
    required this.label,
    this.scrollController,
    required this.items,
    this.bottomActions = const [],
    this.floatingActionButton,
    this.showUserIcon = false,
    this.showBackButtonNested = false,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaQuery = MediaQuery.of(context);
    final padding = mediaQuery.padding;
    final singleLayout = AdaptiveLayout.layoutModeOf(context) == LayoutMode.single;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: floatingActionButton,
      body: Column(
          children: [
          Flexible(
            child: CustomScrollView(
              controller: scrollController,
              slivers: [
                if (singleLayout)
                  SliverAppBar.large(
                    automaticallyImplyLeading: false,
                    flexibleSpace: FlexibleSpaceBar(
                      titlePadding: const EdgeInsets.symmetric(horizontal: 16)
                          .add(EdgeInsets.only(left: padding.left, right: padding.right, bottom: 4)),
                      title: Row(
                        children: [
                          Text(label, style: Theme.of(context).textTheme.headlineLarge),
                          const Spacer(),
                          if (showUserIcon)
                            SizedBox.fromSize(
                              size: const Size.fromRadius(14),
                              child: RepaintBoundary(
                                child: UserIcon(
                                  user: ref.watch(userProvider),
                                  cornerRadius: 200,
                                ),
                              ),
                            )
                        ],
                      ),
                      expandedTitleScale: 1.2,
                    ),
                    expandedHeight: 100,
                    collapsedHeight: 80,
                    pinned: true,
                    floating: false,
                  )
                else
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: MediaQuery.paddingOf(context).copyWith(bottom: 0),
                      child: Row(
                        children: [
                          if (showBackButtonNested && !ref.read(argumentsStateProvider).htpcMode)
                            BackButton(
                              onPressed: () => backAction(context),
                            )
                        ],
                      ),
                    ),
                  ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList.builder(
                    itemBuilder: (context, index) => items[index],
                    itemCount: items.length,
                  ),
                ),
                if (bottomActions.isEmpty)
                  const SliverToBoxAdapter(child: SizedBox(height: kBottomNavigationBarHeight + 40)),
              ],
            ),
          ),
          if (bottomActions.isNotEmpty) ...{
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32)
                  .add(EdgeInsets.only(left: padding.left, right: padding.right)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: bottomActions,
              ),
            ),
            const SizedBox(height: kBottomNavigationBarHeight + 40),
          },
        ],
      ),
    );
  }

  void backAction(BuildContext context) {
    if (kIsWeb) {
      if (AdaptiveLayout.layoutModeOf(context) == LayoutMode.single && context.tabsRouter.activeIndex != 0) {
        context.tabsRouter.setActiveIndex(0);
      } else {
        context.router.pop();
      }
    } else {
      context.router.popBack();
    }
  }
}
