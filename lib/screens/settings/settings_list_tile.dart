import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:kebap/screens/shared/flat_button.dart';
import 'package:kebap/widgets/shared/ensure_visible.dart';

class SettingsListTile extends StatefulWidget {
  final Widget label;
  final Widget? subLabel;
  final Widget? trailing;
  final bool selected;
  final bool autoFocus;
  final IconData? icon;
  final Widget? leading;
  final Color? contentColor;
  final Function()? onTap;
  const SettingsListTile({
    required this.label,
    this.subLabel,
    this.trailing,
    this.selected = false,
    this.autoFocus = false,
    this.leading,
    this.icon,
    this.contentColor,
    this.onTap,
    super.key,
  });

  @override
  State<SettingsListTile> createState() => _SettingsListTileState();
}

class _SettingsListTileState extends State<SettingsListTile> with AutomaticKeepAliveClientMixin {
  bool _focused = false;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final iconWidget = widget.icon != null ? Icon(widget.icon) : null;

    final leadingWidget = (widget.leading ?? iconWidget) != null
        ? Padding(
            padding: const EdgeInsets.only(left: 8, right: 16.0),
            child: (widget.leading ?? iconWidget),
          )
        : widget.leading ?? const SizedBox();
    
    // Define the shortcuts wrapper
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.enter): () => widget.onTap?.call(),
        const SingleActivator(LogicalKeyboardKey.numpadEnter): () => widget.onTap?.call(),
        const SingleActivator(LogicalKeyboardKey.space): () => widget.onTap?.call(),
        const SingleActivator(LogicalKeyboardKey.select): () => widget.onTap?.call(),
        const SingleActivator(LogicalKeyboardKey.gameButtonA): () => widget.onTap?.call(),
      },
      child: Card(
        elevation: 0,
        color: _focused
            ? Theme.of(context).colorScheme.surfaceContainerHighest
            : (widget.selected ? Theme.of(context).colorScheme.surfaceContainerLow : Colors.transparent),
        shadowColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8))),
        margin: EdgeInsets.zero,
        child: Stack(
          alignment: Alignment.centerRight,
          children: [
            FlatButton(
              onTap: widget.onTap,
              autoFocus: widget.autoFocus,
              onFocusChange: (value) {
                if (mounted) setState(() => _focused = value);
                // Ensure focused item is visible on TV clients (dPad navigation)
                if (value) {
                  Scrollable.ensureVisible(context, alignment: 0.5, duration: const Duration(milliseconds: 200));
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ).copyWith(
                  left: (widget.leading ?? iconWidget) != null ? 0 : null,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minHeight: 50,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      DefaultTextStyle.merge(
                        style: TextStyle(
                          color: widget.contentColor ?? Theme.of(context).colorScheme.onSurface,
                        ),
                        child: IconTheme(
                          data: IconThemeData(
                            color: widget.contentColor ?? Theme.of(context).colorScheme.onSurface,
                          ),
                          child: leadingWidget,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Material(
                              color: Colors.transparent,
                              textStyle: Theme.of(context).textTheme.titleLarge?.copyWith(color: widget.contentColor),
                              child: widget.label,
                            ),
                            if (widget.subLabel != null)
                              Material(
                                color: Colors.transparent,
                                textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                                      color: (widget.contentColor ?? Theme.of(context).colorScheme.onSurface)
                                          .withValues(alpha: 0.65),
                                    ),
                                child: widget.subLabel,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (widget.trailing != null)
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: widget.onTap != null
                    ? ExcludeFocus(child: widget.trailing!)
                    : Focus(
                        onFocusChange: (value) {
                          if (mounted) setState(() => _focused = value);
                        },
                        child: widget.trailing!,
                      ),
              ),
          ],
        ),
      ),
    );
  }
}
