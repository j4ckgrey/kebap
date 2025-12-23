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
  final VoidCallback? onLeftFromFirst; // Callback when LEFT pressed on first item
  final VoidCallback? onUpFromRow; // Callback when UP pressed
  final VoidCallback? onDownFromRow; // Callback when DOWN pressed

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
    this.onLeftFromFirst,
    this.onUpFromRow,
    this.onDownFromRow,
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
  bool _focusLocked = false; // Lock after focus is stable
  bool hasFocus = false;

  AnimationController? _scrollAnimation;

  @override
  void didUpdateWidget(HorizontalList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.startIndex != oldWidget.startIndex) {
      if (widget.startIndex != null) {
        // Only scroll, don't request focus - let user navigation control focus
        _scrollToPosition(widget.startIndex!);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    debugPrint('[HL] initState - label: ${widget.label}, autoFocus: ${widget.autoFocus}');
    _measureFirstItem();
  }

  @override
  void dispose() {
    _scrollAnimation?.dispose();
    super.dispose();
  }

  void _measureFirstItem() {
    if (_firstItemWidth != null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final itemContext = _firstItemKey.currentContext;
      if (itemContext != null) {
        final box = itemContext.findRenderObject() as RenderBox;
        _firstItemWidth = box.size.width;
        _scrollToPosition(widget.startIndex ?? 0);
      }

      // Request focus if autoFocus is enabled and not locked yet
      _requestInitialFocus();
    });
  }
  
  void _requestInitialFocus() {
    if (_focusLocked) return;
    if (!(FocusProvider.autoFocusOf(context) || widget.autoFocus)) return;
    
    final nodesOnSameRow = _nodesInRow(parentNode);
    if (nodesOnSameRow.isEmpty) return;
    
    final targetIndex = widget.startIndex ?? 0;
    if (targetIndex >= nodesOnSameRow.length) return;
    
    final targetNode = nodesOnSameRow[targetIndex];
    
    // Request focus with a small delay to ensure widgets are ready
    Future.delayed(const Duration(milliseconds: 50), () {
      if (!mounted || _focusLocked) return;
      
      // Check if we already have focus in this row
      final currentPrimary = FocusManager.instance.primaryFocus;
      final alreadyFocused = nodesOnSameRow.any((n) => n == currentPrimary);
      
      if (alreadyFocused) {
        debugPrint('[HL] _requestInitialFocus - already focused in this row, locking. label: ${widget.label}');
        _focusLocked = true;
        // Still notify parent of the focused index so banner updates
        // Use geometric calculation for accurate index
        final focusedIndex = _getCorrectIndexForNode(currentPrimary!);
        if (focusedIndex != -1 && focusedIndex < widget.items.length) {
          widget.onFocused?.call(focusedIndex);
        }
        return;
      }
      
      debugPrint('[HL] _requestInitialFocus - REQUESTING FOCUS on index $targetIndex, label: ${widget.label}');
      targetNode.requestFocus();
      lastFocused = targetNode;
      
      // Notify parent of focus and scroll to position
      if (targetIndex < widget.items.length) {
        widget.onFocused?.call(targetIndex);
        _scrollToPosition(targetIndex);
      }
      
      // Schedule lock check - if focus is maintained for 300ms, lock it
      Future.delayed(const Duration(milliseconds: 300), () {
        if (!mounted) return;
        final stillFocused = nodesOnSameRow.any((n) => n == FocusManager.instance.primaryFocus);
        if (stillFocused) {
          _focusLocked = true;
          debugPrint('[HL] _requestInitialFocus - Focus locked after 300ms, label: ${widget.label}');
        }
      });
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
    // Retry focus after each build until locked (handles async data loading rebuilds)
    if (!_focusLocked && (FocusProvider.autoFocusOf(context) || widget.autoFocus)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _requestInitialFocus();
      });
    }
    
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
          canRequestFocus: false, // Not a focusable target - only children are focusable
          onFocusChange: (value) {
            debugPrint('[HL] onFocusChange - value: $value, hasFocus: $hasFocus, label: ${widget.label}');
            if (value && hasFocus != value) {
              hasFocus = value;
              final nodesOnSameRow = _nodesInRow(parentNode);
              final primaryFocus = FocusManager.instance.primaryFocus;
              
              // CRITICAL: If focus is on the parent node itself (not a child), it means
              // focus is transitioning THROUGH this row (e.g., UP/DOWN navigation).
              // Do NOT intercept - let it continue to its destination.
              if (primaryFocus == parentNode) {
                debugPrint('[HL] onFocusChange - focus is on parentNode, transitioning through. label: ${widget.label}');
                return;
              }
              
              // Check if any child already has focus
              final alreadyFocused = nodesOnSameRow.any((n) => n.hasFocus || n == primaryFocus);
              debugPrint('[HL] onFocusChange - alreadyFocused: $alreadyFocused, nodes: ${nodesOnSameRow.length}, primaryFocus: $primaryFocus, startIndex: ${widget.startIndex}');
              
              if (alreadyFocused) {
                final focusedNode = nodesOnSameRow.firstWhere(
                  (n) => n.hasFocus || n == primaryFocus, 
                  orElse: () => nodesOnSameRow.first,
                );
                
                // Sync lastFocused and notify parent of the current focus
                lastFocused = focusedNode;
                // Use geometric calculation for correct item index, not node list position
                final focusedIndex = _getCorrectIndexForNode(focusedNode);
                if (focusedIndex != -1 && focusedIndex < widget.items.length) {
                  widget.onFocused?.call(focusedIndex);
                }
                return; // Let the focused child keep focus
              }
              
              // Check if focus is passing THROUGH the row (on its way somewhere else)
              // If primaryFocus is already set to a node OUTSIDE this row, don't intercept
              if (primaryFocus != null && !nodesOnSameRow.contains(primaryFocus)) {
                debugPrint('[HL] onFocusChange - focus passing through, not intercepting. label: ${widget.label}');
                return; // Focus is going elsewhere, don't intercept
              }

              // Only restore focus if NO child is focused (initial focus case)
              FocusNode? targetNode;
              if (lastFocused != null && nodesOnSameRow.contains(lastFocused)) {
                targetNode = lastFocused;
              }
              
              // Fallback to startIndex if available and valid
              if (targetNode == null && widget.startIndex != null && widget.startIndex! < nodesOnSameRow.length) {
                 targetNode = nodesOnSameRow[widget.startIndex!];
              }

              // Final fallback: first fully visible or just first
              final currentNode = targetNode ?? _firstFullyVisibleNode(context, nodesOnSameRow);

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
              // Reset focus lock when we lose focus, so we can re-request it 
              // if we become visible again (e.g. returning to dashboard)
              _focusLocked = false;
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
                onLeftFromFirst: widget.onLeftFromFirst,
                onUpFromRow: widget.onUpFromRow,
                onDownFromRow: widget.onDownFromRow,
                onFocused: (node) {
                  // Primary focus tracking - calculate index and notify parent
                  if (node.context != null) {
                    lastFocused = node;
                    final correctIndex = _getCorrectIndexForNode(node);
                    if (correctIndex != -1 && correctIndex < widget.items.length) {
                      widget.onFocused?.call(correctIndex);
                      _scrollToPosition(correctIndex);
                    }
                  }
                },
              ),
              child: ListView.separated(
                key: _listViewKey,
                controller: _scrollController,
                clipBehavior: Clip.none,
                scrollDirection: Axis.horizontal,
                padding: widget.contentPadding,
                cacheExtent: (_firstItemWidth ?? 250) * 5,
                // RepaintBoundary around each item to isolate card repaints from scroll
                // Focus tracking is handled by HorizontalRailFocus.onFocused - no wrapper needed
                itemBuilder: (context, index) {
                  final Widget child = index == widget.items.length
                      ? PosterPlaceHolder(
                          onTap: widget.onLabelClick ?? () {},
                          aspectRatio: widget.dominantRatio ?? AdaptiveLayout.poster(context).ratio,
                        )
                      : Container(
                          key: index == 0 ? _firstItemKey : null,
                          child: widget.itemBuilder(context, index),
                        );
                  
                  return RepaintBoundary(child: child);
                },
                separatorBuilder: (context, index) => SizedBox(width: contentPadding),
                itemCount: widget.onLabelClick != null
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

  final scrollable = Scrollable.maybeOf(context);
  if (scrollable == null) return nodes.firstOrNull;

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
  // Simple implementation - get all focusable descendants of this parent
  // Each HorizontalList has its own parentNode, so this should only return
  // items from THIS list's focus scope
  return parentNode.descendants
      .where((n) => n.canRequestFocus && n.context != null)
      .toList()
    ..sort((a, b) => a.rect.left.compareTo(b.rect.left));
}




class HorizontalRailFocus extends WidgetOrderTraversalPolicy {
  final FocusNode parentNode;
  final void Function(FocusNode node) onFocused;
  final ScrollController scrollController;
  final double firstItemWidth;
  final bool isFirstRow;
  final VoidCallback? onLeftFromFirst;
  final VoidCallback? onUpFromRow;
  final VoidCallback? onDownFromRow;

  HorizontalRailFocus({
    required this.parentNode,
    required this.onFocused,
    required this.scrollController,
    required this.firstItemWidth,
    this.isFirstRow = false,
    this.onLeftFromFirst,
    this.onUpFromRow,
    this.onDownFromRow,
  });

  @override
  bool inDirection(FocusNode currentNode, TraversalDirection direction) {
    final rowNodes = _nodesInRow(parentNode);
    var index = rowNodes.indexOf(currentNode);
    
    // Safety fallback: If current node not found (e.g. tree desync), find closest node visually
    if (index == -1 && currentNode.context != null) {
      final currentRender = currentNode.context!.findRenderObject() as RenderBox?;
      if (currentRender != null) {
        final currentCenter = currentRender.localToGlobal(currentRender.size.center(Offset.zero));
        FocusNode? closest;
        double minKDist = double.infinity;
        
        for (final node in rowNodes) {
           final box = node.context!.findRenderObject() as RenderBox;
           final center = box.localToGlobal(box.size.center(Offset.zero));
           final dist = (center - currentCenter).distanceSquared;
           if (dist < minKDist) {
             minKDist = dist;
             closest = node;
           }
        }
        
        if (closest != null) {
          index = rowNodes.indexOf(closest);
          debugPrint('[HRF] Recovered index $index via geometric fallback');
        }
      }
    }
    
    debugPrint('[HRF] inDirection: $direction. Nodes: ${rowNodes.length}, CurrentIndex: $index');

    if (index == -1) {
       return false;
    }

    if (direction == TraversalDirection.left) {
      if (index == 0) {
        // Open drawer on LEFT from first item
        final scaffold = parentNode.context != null 
            ? Scaffold.maybeOf(parentNode.context!) 
            : null;
        if (scaffold != null && scaffold.hasDrawer) {
          scaffold.openDrawer();
          return true;
        }
        // If no scaffold/drawer, let global policy handle
        return false;
      }

      if (index > 0) {
        final target = rowNodes[index - 1];
        target.requestFocus();
        onFocused(target);
        return true;
      }
      return false; // Allow escape to sidebar
    }

    if (direction == TraversalDirection.right) {
      if (index < rowNodes.length - 1) {
        final target = rowNodes[index + 1];
        target.requestFocus();
        onFocused(target);
        return true;
      }
      return false; // Allow escape to right
    }

    // Handle UP - use callback if provided, otherwise try to escape to parent scope
    if (direction == TraversalDirection.up) {
      debugPrint('[HRF] UP direction - onUpFromRow: ${onUpFromRow != null}, currentNode: $currentNode');
      if (onUpFromRow != null) {
        onUpFromRow!();
        return true;
      }
      // No callback - try to navigate out using parent scope
      if (parentNode.context != null) {
        final outerScope = FocusScope.of(parentNode.context!);
        return outerScope.focusInDirection(direction);
      }
      return false;
    }

    // Handle DOWN - use callback if provided, otherwise try to escape to parent scope
    if (direction == TraversalDirection.down) {
      debugPrint('[HRF] DOWN direction - onDownFromRow: ${onDownFromRow != null}');
      if (onDownFromRow != null) {
        onDownFromRow!();
        return true;
      }
      // No callback - try to navigate out using parent scope
      if (parentNode.context != null) {
        final outerScope = FocusScope.of(parentNode.context!);
        return outerScope.focusInDirection(direction);
      }
      return false;
    }

    debugPrint('[HRF] Falling through to super.inDirection for $direction');
    return super.inDirection(currentNode, direction);
  }
}
