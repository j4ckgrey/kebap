import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import 'package:kebap/providers/settings/client_settings_provider.dart';
import 'package:kebap/screens/shared/media/poster_widget.dart';
import 'package:kebap/util/adaptive_layout/adaptive_layout.dart';
import 'package:kebap/util/focus_provider.dart';
import 'package:kebap/util/list_padding.dart';
import 'package:kebap/util/sticky_header_text.dart';
import 'package:kebap/widgets/navigation_scaffold/components/navigation_body.dart';
import 'package:kebap/widgets/navigation_scaffold/components/navigation_constants.dart';
import 'package:kebap/widgets/shared/ensure_visible.dart';

class HorizontalList<T> extends ConsumerStatefulWidget {
  final bool autoFocus;
  final String? label;
  final bool hideLabel; // Hide label when showing in banner
  final List<Widget> titleActions;
  final Function()? onLabelClick;
  final String? subtext;
  final List<T> items;
  final int? startIndex;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final Function(int index)? onFocused;
  final bool scrollToEnd;
  final EdgeInsets contentPadding;
  final double? dominantRatio;
  final double? height;
  final bool shrinkWrap;
  const HorizontalList({
    this.autoFocus = false,
    required this.items,
    required this.itemBuilder,
    this.onFocused,
    this.startIndex,
    this.height,
    this.label,
    this.hideLabel = false,
    this.titleActions = const [],
    this.onLabelClick,
    this.scrollToEnd = false,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 16),
    this.subtext,
    this.shrinkWrap = false,
    this.dominantRatio,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HorizontalListState();
}

class _HorizontalListState extends ConsumerState<HorizontalList> with TickerProviderStateMixin {
  final FocusNode parentNode = FocusNode();
  FocusNode? lastFocused;
  final GlobalKey _firstItemKey = GlobalKey();
  final GlobalKey _listViewKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();
  final contentPadding = 8.0;
  double? contentWidth;
  double? _firstItemWidth;
  bool hasFocus = false;

  AnimationController? _scrollAnimation;

  @override
  void didUpdateWidget(HorizontalList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.startIndex != oldWidget.startIndex) {
      if (widget.startIndex != null) {
        _scrollToPosition(widget.startIndex!);
        
        // Restore focus to the new start index if this list is auto-focusing
        if (widget.autoFocus) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              final nodes = _nodesInRow(parentNode);
              if (nodes.isNotEmpty && widget.startIndex! < nodes.length) {
                nodes[widget.startIndex!].requestFocus();
              }
            }
          });
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _measureFirstItem();
  }

  @override
  void dispose() {
    _scrollAnimation?.dispose();
    // Clear firstContentNode if this row registered it
    if (widget.autoFocus && firstContentNode != null) {
      final nodesOnSameRow = _nodesInRow(parentNode);
      if (nodesOnSameRow.isNotEmpty && firstContentNode == nodesOnSameRow.first) {
        firstContentNode = null;
      }
    }
    super.dispose();
  }

  void _measureFirstItem() {
    if (_firstItemWidth != null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final itemContext = _firstItemKey.currentContext;
      if (itemContext != null) {
        final box = itemContext.findRenderObject() as RenderBox;
        _firstItemWidth = box.size.width;
        _scrollToPosition(widget.startIndex ?? 0);
      }

      if (AdaptiveLayout.inputDeviceOf(context) == InputDevice.dPad) {
        final nodesOnSameRow = _nodesInRow(parentNode);
        if (nodesOnSameRow.isNotEmpty && (FocusProvider.autoFocusOf(context) || widget.autoFocus)) {
          // CRITICAL: Only register as first content if this row has autoFocus.
          // This ensures only the truly first visible row is registered,
          // not every row that happens to have focus capability.
          if (widget.autoFocus) {
            try {
              registerFirstContentNode(nodesOnSameRow.first);
            } catch (_) {}
          }

          nodesOnSameRow[widget.startIndex ?? 0].requestFocus();
        }
      }
    });
  }

  Future<void> _scrollToPosition(int index) async {
    if (_firstItemWidth == null || !_scrollController.hasClients) return;

    final target = (index * (_firstItemWidth! + contentPadding)).clamp(0, _scrollController.position.maxScrollExtent);

    _scrollAnimation?.stop();

    final controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 275),
    );

    _scrollAnimation = controller;

    final tween = Tween<double>(
      begin: _scrollController.offset,
      end: target.toDouble(),
    );

    final animation = CurvedAnimation(
      parent: controller,
      curve: Curves.fastOutSlowIn,
    );

    controller.addListener(() {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(tween.evaluate(animation));
      }
    });

    await controller.forward();

    if (_scrollAnimation == controller) _scrollAnimation = null;
    controller.dispose();
  }

  void _scrollToStart() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 250),
      curve: Curves.fastOutSlowIn,
    );
  }

  Future<void> _scrollToEnd() async {
    final offset = (_firstItemWidth ?? 200) * widget.items.length + 200;
    _scrollController.animateTo(
      math.min(offset, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 250),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasPointer = AdaptiveLayout.inputDeviceOf(context) == InputDevice.pointer;
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!widget.hideLabel)
          Padding(
            padding: widget.contentPadding,
            child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (widget.label != null)
                      Flexible(
                        child: ExcludeFocus(
                          child: StickyHeaderText(
                            label: widget.label ?? "",
                            onClick:
                                AdaptiveLayout.inputDeviceOf(context) == InputDevice.dPad ? null : widget.onLabelClick,
                          ),
                        ),
                      ),
                    if (widget.subtext != null)
                      Flexible(
                        child: ExcludeFocus(
                          child: Text(
                            widget.subtext!,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                                ),
                          ),
                        ),
                      ),
                    ...widget.titleActions
                  ],
                ),
              ),
              if (widget.items.length > 1)
                ExcludeFocus(
                  child: Card(
                    elevation: 5,
                    color: Theme.of(context).colorScheme.surface,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (hasPointer)
                          GestureDetector(
                            onLongPress: () => _scrollToStart(),
                            child: IconButton(
                                onPressed: () {
                                  _scrollController.animateTo(
                                      _scrollController.offset + -(MediaQuery.of(context).size.width / 1.75),
                                      duration: const Duration(milliseconds: 250),
                                      curve: Curves.easeInOut);
                                },
                                icon: const Icon(
                                  IconsaxPlusLinear.arrow_left_1,
                                  size: 20,
                                )),
                          ),
                        if (widget.startIndex != null)
                          IconButton(
                              tooltip: "Scroll to current",
                              onPressed: () => _scrollToPosition(widget.startIndex!),
                              icon: const Icon(
                                Icons.circle,
                                size: 16,
                              )),
                        if (hasPointer)
                          GestureDetector(
                            onLongPress: () => _scrollToEnd(),
                            child: IconButton(
                                onPressed: () {
                                  _scrollController.animateTo(
                                      _scrollController.offset + (MediaQuery.of(context).size.width / 1.75),
                                      duration: const Duration(milliseconds: 250),
                                      curve: Curves.easeInOut);
                                },
                                icon: const Icon(
                                  IconsaxPlusLinear.arrow_right_3,
                                  size: 20,
                                )),
                          ),
                      ],
                    ),
                  ),
                ),
            ].addPadding(const EdgeInsets.symmetric(horizontal: 6)),
          ),
        ),
        if (!widget.hideLabel) const SizedBox(height: 8),
        Focus(
          focusNode: parentNode,
          onFocusChange: (value) {
            if (value && hasFocus != value) {
              hasFocus = value;
              final nodesOnSameRow = _nodesInRow(parentNode);
              final currentNode =
                  nodesOnSameRow.contains(lastFocused) ? lastFocused : _firstFullyVisibleNode(context, nodesOnSameRow);

              if (currentNode != null) {
                lastFocused = currentNode;
                final correctIndex = _getCorrectIndexForNode(currentNode);

                if (widget.onFocused != null) {
                  if (correctIndex != -1) {
                    widget.onFocused!(correctIndex);
                  }
                } else {
                  context.ensureVisible();
                }
                currentNode.requestFocus();
              }
            } else {
              hasFocus = false;
            }
          },
          child: SizedBox(
            height: widget.height ??
                ((AdaptiveLayout.poster(context).size *
                            ref.watch(clientSettingsProvider.select((value) => value.posterSize))) /
                        math.pow((widget.dominantRatio ?? 1.0), 0.55)) *
                    0.72,
            child: FocusTraversalGroup(
              policy: HorizontalRailFocus(
                parentNode: parentNode,
                scrollController: _scrollController,
                firstItemWidth: _firstItemWidth ?? 250,
                isFirstRow: widget.autoFocus,
                onFocused: (node) {
                  lastFocused = node;
                  final correctIndex = _getCorrectIndexForNode(node);
                  if (correctIndex != -1) {
                    widget.onFocused?.call(correctIndex);
                    _scrollToPosition(correctIndex);
                  }
                },
              ),
              child: ListView.separated(
                key: _listViewKey,
                controller: _scrollController,
                clipBehavior: Clip.none,
                scrollDirection: Axis.horizontal,
                padding: widget.contentPadding,
                cacheExtent: _firstItemWidth ?? 250 * 3,
                itemBuilder: (context, index) => index == widget.items.length
                    ? PosterPlaceHolder(
                        onTap: widget.onLabelClick ?? () {},
                        aspectRatio: widget.dominantRatio ?? AdaptiveLayout.poster(context).ratio,
                      )
                    : Container(
                        key: index == 0 ? _firstItemKey : null,
                        child: widget.itemBuilder(context, index),
                      ),
                separatorBuilder: (context, index) => SizedBox(width: contentPadding),
                itemCount: widget.onLabelClick != null && AdaptiveLayout.inputDeviceOf(context) == InputDevice.dPad
                    ? widget.items.length + 1
                    : widget.items.length,
              ),
            ),
          ),
        ),
      ],
    );
  }

  int _getCorrectIndexForNode(FocusNode node) {
    if (!mounted || _firstItemWidth == null || !_scrollController.hasClients || node.context == null) return -1;

    final scrollableContext = _listViewKey.currentContext;
    if (scrollableContext == null || !scrollableContext.mounted) return -1;

    final scrollableBox = scrollableContext.findRenderObject() as RenderBox?;
    final itemBox = node.context!.findRenderObject() as RenderBox?;
    if (scrollableBox == null || itemBox == null) return -1;

    final dx = itemBox.localToGlobal(Offset.zero, ancestor: scrollableBox).dx;

    final totalItemWidth = _firstItemWidth! + contentPadding;
    final offset = dx + _scrollController.offset - widget.contentPadding.left;

    final index = ((offset + totalItemWidth / 2) ~/ totalItemWidth).clamp(0, widget.items.length - 1);

    return index;
  }
}

FocusNode? _firstFullyVisibleNode(
  BuildContext context,
  List<FocusNode> nodes,
) {
  if (nodes.isEmpty) return null;

  final scrollable = Scrollable.of(context);

  final viewportBox = scrollable.context.findRenderObject() as RenderBox;
  final viewportSize = viewportBox.size;

  for (final node in nodes) {
    final renderObj = node.context?.findRenderObject();
    if (renderObj is RenderBox) {
      final topLeft = renderObj.localToGlobal(Offset.zero, ancestor: viewportBox);
      final bottomRight = renderObj.localToGlobal(renderObj.size.bottomRight(Offset.zero), ancestor: viewportBox);

      final nodeRect = Rect.fromPoints(topLeft, bottomRight);

      final fullyVisible = nodeRect.left >= 0 &&
          nodeRect.right <= viewportSize.width &&
          nodeRect.top >= 0 &&
          nodeRect.bottom <= viewportSize.height;

      if (fullyVisible) {
        return node;
      }
    }
  }

  return nodes.firstOrNull;
}

List<FocusNode> _nodesInRow(FocusNode parentNode) {
  return parentNode.descendants.where((n) => n.canRequestFocus && n.context != null).toList()
    ..sort((a, b) => a.rect.left.compareTo(b.rect.left));
}

class HorizontalRailFocus extends WidgetOrderTraversalPolicy {
  final FocusNode parentNode;
  final void Function(FocusNode node) onFocused;
  final ScrollController scrollController;
  final double firstItemWidth;
  final bool isFirstRow;

  HorizontalRailFocus({
    required this.parentNode,
    required this.onFocused,
    required this.scrollController,
    required this.firstItemWidth,
    this.isFirstRow = false,
  });

  @override
  bool inDirection(FocusNode currentNode, TraversalDirection direction) {
    final rowNodes = _nodesInRow(parentNode);
    final index = rowNodes.indexOf(currentNode);
    if (index == -1) return false;
    
    // Handle LEFT navigation within the row
    if (direction == TraversalDirection.left) {
      // Check if we're at the first item and scroll is near start
      bool isFullyVisible(FocusNode node) {
        try {
          if (node.context == null) return false;
          final scrollable = Scrollable.of(node.context!);
          // ignore: unnecessary_null_comparison
          if (scrollable == null) return false;
          final viewportBox = scrollable.context.findRenderObject() as RenderBox;
          final itemBox = node.context!.findRenderObject() as RenderBox;
          final left = itemBox.localToGlobal(Offset.zero, ancestor: viewportBox).dx;
          final right = left + itemBox.size.width;
          final viewportWidth = viewportBox.size.width;
          return left >= 0 && right <= viewportWidth;
        } catch (_) {
          return false;
        }
      }

      // At first item with scroll at start - don't navigate anywhere
      // Let the GlobalFallbackTraversalPolicy handle it if truly stuck
      final shouldBlockNavigation = scrollController.hasClients &&
          (scrollController.offset <= firstItemWidth * 0.5) &&
          (index == 0) &&
          isFullyVisible(currentNode);

      if (shouldBlockNavigation) {
        // Store this as the last main focus for potential navbar return
        lastMainFocus = currentNode;
        // Return false to let parent policy handle (will go to navbar via GlobalFallback)
        return false;
      }

      // Navigate to previous item in row
      if (index > 0) {
        final target = rowNodes[index - 1];
        target.requestFocus();
        onFocused(target);
      }
      return true;
    }

    // Handle RIGHT navigation within the row
    if (direction == TraversalDirection.right) {
      if (index < rowNodes.length - 1) {
        final target = rowNodes[index + 1];
        target.requestFocus();
        onFocused(target);
      }
      return true;
    }

    // Handle UP navigation
    if (direction == TraversalDirection.up) {
      // Only go to navbar if this is the FIRST ROW (allow from any item in the row)
      if (isFirstRow) {
        lastMainFocus = currentNode;
        try {
          if (firstNavButtonNode != null && firstNavButtonNode!.canRequestFocus) {
            firstNavButtonNode!.requestFocus();
            return true;
          }
        } catch (_) {}
        
        try {
          final cb = FocusTraversalPolicy.defaultTraversalRequestFocusCallback;
          cb(navBarNode);
          return true;
        } catch (_) {}
      }

      // For non-first rows, allow standard traversal to find the row above
      return super.inDirection(currentNode, direction);
    }

    // Handle DOWN navigation - use default to go to next row
    if (direction == TraversalDirection.down) {
      return super.inDirection(currentNode, direction);
    }

    // For any other direction, use default behavior
    return super.inDirection(currentNode, direction);
  }
}
