import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kebap/widgets/navigation_scaffold/components/settings_user_icon.dart';

class NestedSliverAppBar extends ConsumerWidget {
  final BuildContext parent;
  final PageRouteInfo? route;
  const NestedSliverAppBar({required this.parent, this.route, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final surfaceColor = Theme.of(context).colorScheme.surface;
    final buttonStyle = Theme.of(context).filledButtonTheme.style?.copyWith(
          backgroundColor: WidgetStatePropertyAll(
            surfaceColor.withValues(alpha: 0.8),
          ),
        );
    return SliverAppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      forceElevated: false,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [
            surfaceColor.withValues(alpha: 0.7),
            surfaceColor.withValues(alpha: 0),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        )),
        child: Padding(
          padding: const EdgeInsets.only(top: 8, left: 14, right: 14),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: SizedBox(
              height: 50,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 12,
                children: [],
              ),
            ),
          ),
        ),
      ),
      toolbarHeight: 80,
      floating: true,
    );
  }
}
