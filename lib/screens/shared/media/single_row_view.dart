import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kebap/models/item_base_model.dart';
import 'package:kebap/providers/focused_item_provider.dart';
import 'package:kebap/screens/shared/media/compact_item_banner.dart';
import 'package:kebap/screens/shared/media/poster_row.dart';
import 'package:kebap/util/adaptive_layout/adaptive_layout.dart';
import 'package:kebap/widgets/navigation_scaffold/components/side_navigation_bar.dart';

/// Single row view with fixed banner
/// Shows one row at a time, banner updates based on focused item
class SingleRowView extends ConsumerStatefulWidget {
  final List<RowData> rows;
  final EdgeInsets contentPadding;

  const SingleRowView({
    required this.rows,
    required this.contentPadding,
    super.key,
  });

  @override
  ConsumerState<SingleRowView> createState() => _SingleRowViewState();
}

class _SingleRowViewState extends ConsumerState<SingleRowView> {
  int _currentRowIndex = 0;
  final PageController _pageController = PageController();
  final FocusNode _focusNode = FocusNode();
  final Map<int, FocusNode> _firstItemFocusNodes = {}; // Nodes for the first item of each row

  @override
  void initState() {
    super.initState();
    _initializeFocus();
  }

  @override
  void didUpdateWidget(SingleRowView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.rows.length != oldWidget.rows.length) {
      _initializeFocus();
    }
  }

  void _initializeFocus() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.rows.isNotEmpty && widget.rows[0].posters.isNotEmpty) {
        // Set initial banner item
        ref.read(focusedItemProvider.notifier).state = widget.rows[0].posters.first;
        
        // Request focus on the first item of the first row (only for non-touch devices)
        final isTouchDevice = AdaptiveLayout.inputDeviceOf(context) == InputDevice.touch;
        if (!isTouchDevice) {
          _requestFocusOnRow(0);
        }
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _focusNode.dispose();
    // Clear firstContentNode if we registered it
    try {
      final firstNode = _firstItemFocusNodes[0];
      if (firstContentNode == firstNode) firstContentNode = null;
    } catch (_) {}

    for (var node in _firstItemFocusNodes.values) {
      node.dispose();
    }
    super.dispose();
  }

  FocusNode _getFirstItemFocusNode(int index) {
    return _firstItemFocusNodes.putIfAbsent(index, () {
      final node = FocusNode();
      if (index == 0) {
        try {
          registerFirstContentNode(node);
          debugPrint('[SingleRowView] registered firstContentNode -> ${node.toString()}');
        } catch (_) {}
      }
      return node;
    });
  }

  void _requestFocusOnRow(int index) {
    if (!mounted) return;
    final node = _getFirstItemFocusNode(index);
    if (node.canRequestFocus) {
      node.requestFocus();
      if (index == 0) {
        try {
          registerFirstContentNode(node);
        } catch (_) {}
      }
    }
  }

  void _handleRowChange(int newIndex) {
    if (newIndex < 0 || newIndex >= widget.rows.length) return;
    
    setState(() {
      _currentRowIndex = newIndex;
    });
    _pageController.animateToPage(
      newIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    
    // Update focused item to first item of new row
    if (widget.rows[newIndex].posters.isNotEmpty) {
      ref.read(focusedItemProvider.notifier).state = widget.rows[newIndex].posters.first;
    }

    // Request focus on the new row's first item
    // We might need a small delay if the widget is being built for the first time
    // But since we pass the node to the widget, requestFocus should work as soon as it's attached
    WidgetsBinding.instance.addPostFrameCallback((_) {
       _requestFocusOnRow(newIndex);
    });
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    
    debugPrint('[SingleRowView] Key event: ${event.logicalKey.keyLabel}, Current Row: $_currentRowIndex, Total Rows: ${widget.rows.length}');

    // Handle up/down navigation
    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      debugPrint('[SingleRowView] Handling Down Arrow');
      _handleRowChange(_currentRowIndex + 1);
      return KeyEventResult.handled;
    } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      debugPrint('[SingleRowView] Handling Up Arrow');
      if (_currentRowIndex > 0) {
        _handleRowChange(_currentRowIndex - 1);
        return KeyEventResult.handled;
      }
      // At first row, try to move focus up explicitly
      debugPrint('[SingleRowView] Moving focus Up from first row');
      try {
        final primary = FocusManager.instance.primaryFocus;
        debugPrint('[SingleRowView] primaryFocus=${primary?.toString()} firstContentNode=${firstContentNode?.toString()} primary==firstContentNode=${primary == firstContentNode}');
      } catch (_) {}
      FocusScope.of(context).focusInDirection(TraversalDirection.up);
      return KeyEventResult.handled;
    }
    
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final viewSize = AdaptiveLayout.viewSizeOf(context);
    final isTouchDevice = AdaptiveLayout.inputDeviceOf(context) == InputDevice.touch;
    final navbarHeight = MediaQuery.paddingOf(context).top + 56.0;
    final availableHeight = size.height - navbarHeight;
    
    // For touch devices on mobile: larger cards, smaller banner
    // For non-touch devices: keep existing layout
    final titleHeight = 30.0; // Reduced height for row title (smaller padding + font)
    final cardHeight = isTouchDevice && viewSize <= ViewSize.phone 
        ? 280.0 - titleHeight  // Larger cards for touch devices
        : 200.0 - titleHeight; // Original size for non-touch
    final bannerHeight = isTouchDevice && viewSize <= ViewSize.phone
        ? availableHeight * 0.42  // ~42% for banner on touch devices
        : availableHeight - 200.0; // Rest goes to banner on non-touch

    // For touch devices, use scrollable ListView
    if (isTouchDevice && viewSize <= ViewSize.phone) {
      return Column(
        children: [
          // Fixed banner
          SizedBox(
            height: bannerHeight,
            child: CompactItemBanner(
              item: ref.watch(focusedItemProvider),
              maxHeight: bannerHeight,
            ),
          ),
          // Scrollable rows
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: widget.rows.length,
              itemBuilder: (context, index) {
                final row = widget.rows[index];
                return SizedBox(
                  height: cardHeight + titleHeight,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Row title
                      Padding(
                        padding: const EdgeInsets.only(left: 16, top: 8, bottom: 4),
                        child: Text(
                          row.label,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // Poster cards
                      Expanded(
                        child: PosterRow(
                          contentPadding: EdgeInsets.only(
                            left: widget.contentPadding.left, 
                            right: widget.contentPadding.right,
                          ),
                          label: row.label,
                          hideLabel: true, // Hide label, shown above instead
                          posters: row.posters,
                          collectionAspectRatio: row.aspectRatio,
                          onLabelClick: row.onLabelClick,
                          explicitHeight: cardHeight,
                          onCardTap: (item) {
                            // Update banner content instead of navigating
                            ref.read(focusedItemProvider.notifier).state = item;
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      );
    }

    // For non-touch devices, use existing PageView with keyboard navigation
    return Focus(
      focusNode: _focusNode,
      canRequestFocus: false, // Don't steal focus, just listen to bubbling events
      onKeyEvent: _handleKeyEvent,
      child: Column(
        children: [
          // Fixed banner
          SizedBox(
            height: bannerHeight,
            child: CompactItemBanner(
              item: ref.watch(focusedItemProvider),
              maxHeight: bannerHeight,
            ),
          ),
          // Single row view (PageView)
          SizedBox(
            height: cardHeight + titleHeight,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row title above cards
              if (_currentRowIndex >= 0 && _currentRowIndex < widget.rows.length)
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 4, bottom: 4),
                  child: Text(
                    widget.rows[_currentRowIndex].label,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Poster cards
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    scrollDirection: Axis.vertical,
                    physics: const NeverScrollableScrollPhysics(), // Disable scroll, use keyboard only
                    onPageChanged: (index) {
                      setState(() {
                        _currentRowIndex = index;
                      });
                    },
                    itemCount: widget.rows.length,
                    itemBuilder: (context, index) {
                      final row = widget.rows[index];
                      return PosterRow(
                        contentPadding: EdgeInsets.only(left: widget.contentPadding.left, right: widget.contentPadding.right), // Remove vertical padding
                        label: row.label,
                        hideLabel: true, // Hide label, shown above instead
                        posters: row.posters,
                        collectionAspectRatio: row.aspectRatio,
                        onLabelClick: row.onLabelClick,
                        explicitHeight: cardHeight,
                        onFocused: (item) {
                          ref.read(focusedItemProvider.notifier).state = item;
                        },
                        firstItemFocusNode: _getFirstItemFocusNode(index),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Data model for a single row
class RowData {
  final String label;
  final List<ItemBaseModel> posters;
  final double? aspectRatio;
  final Function()? onLabelClick;

  const RowData({
    required this.label,
    required this.posters,
    this.aspectRatio,
    this.onLabelClick,
  });
}
