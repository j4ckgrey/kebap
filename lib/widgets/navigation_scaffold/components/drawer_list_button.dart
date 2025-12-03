import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kebap/screens/shared/animated_fade_size.dart';
import 'package:kebap/util/adaptive_layout/adaptive_layout.dart';
import 'package:kebap/widgets/shared/item_actions.dart';
import 'package:kebap/widgets/shared/modal_bottom_sheet.dart';

class DrawerListButton extends ConsumerStatefulWidget {
  final String label;
  final Widget selectedIcon;
  final Widget icon;
  final Function()? onPressed;
  final List<ItemAction> actions;
  final bool selected;
  final Duration duration;
  const DrawerListButton({
    required this.label,
    required this.selectedIcon,
    required this.icon,
    this.onPressed,
    this.actions = const [],
    this.selected = false,
    this.duration = const Duration(milliseconds: 125),
    this.focusNode,
    this.autofocus = false,
    this.badge,
    super.key,
  });

  final FocusNode? focusNode;
  final bool autofocus;
  final Widget? badge;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DrawerListButtonState();
}

class _DrawerListButtonState extends ConsumerState<DrawerListButton> {
  bool showPopupButton = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) => setState(() => showPopupButton = true),
      onExit: (event) => setState(() => showPopupButton = false),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: ListTile(
          focusNode: widget.focusNode,
          autofocus: widget.autofocus,
          onTap: widget.onPressed,
          horizontalTitleGap: 15,
          selected: widget.selected,
          selectedTileColor: Theme.of(context).colorScheme.primary,
          selectedColor: Theme.of(context).colorScheme.onPrimary,
          onLongPress: widget.actions.isNotEmpty && AdaptiveLayout.inputDeviceOf(context) == InputDevice.touch
              ? () => showBottomSheetPill(
                    context: context,
                    content: (context, scrollController) => ListView(
                      shrinkWrap: true,
                      controller: scrollController,
                      children: widget.actions.listTileItems(context, useIcons: true),
                    ),
                  )
              : null,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
          leading: Padding(
            padding: const EdgeInsets.all(3),
            child:
                AnimatedFadeSize(duration: widget.duration, child: widget.selected ? widget.selectedIcon : widget.icon),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.badge != null) widget.badge!,
              if (widget.actions.isNotEmpty && AdaptiveLayout.inputDeviceOf(context) == InputDevice.pointer) ...[
                if (widget.badge != null) const SizedBox(width: 8),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 125),
                  opacity: showPopupButton ? 1 : 0,
                  child: PopupMenuButton(
                    tooltip: "Options",
                    itemBuilder: (context) => widget.actions.popupMenuItems(useIcons: true),
                  ),
                ),
              ],
            ],
          ),
          title: Text(widget.label),
        ),
      ),
    );
  }
}
