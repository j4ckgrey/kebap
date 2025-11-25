import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kebap/models/item_base_model.dart';
import 'package:kebap/providers/focused_item_provider.dart';
import 'package:kebap/screens/shared/media/compact_item_banner.dart';
import 'package:kebap/screens/shared/media/poster_row.dart';
import 'package:kebap/util/adaptive_layout/adaptive_layout.dart';
import 'package:kebap/util/focus_provider.dart';


/// Single row view with fixed banner
/// Shows scrollable rows with banner that updates based on card selection
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
  final ScrollController _scrollController = ScrollController();

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
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final viewSize = AdaptiveLayout.viewSizeOf(context);
    final navbarHeight = MediaQuery.paddingOf(context).top + 56.0;
    final availableHeight = size.height - navbarHeight;
    
    // Universal sizing for all devices
    final titleHeight = 30.0;
    
    // Adjust based on screen size - reduced card height to prevent overflow
    final cardHeight = viewSize <= ViewSize.phone 
        ? 250.0 - titleHeight  // Reduced from 280 to prevent overflow
        : 220.0 - titleHeight; // Reduced from 240 to prevent overflow
        
    final bannerHeight = viewSize <= ViewSize.phone
        ? availableHeight * 0.60  // 60% for phones
        : availableHeight * 0.58;  // 58% for larger screens

    // Universal scrollable layout for all devices
    return Column(
      children: [
        // Fixed banner (non-scrollable)
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
            controller: _scrollController,
            primary: false,
            physics: const ClampingScrollPhysics(), // Proper scroll physics
            padding: EdgeInsets.zero,
            itemCount: widget.rows.length,
            itemExtent: cardHeight + titleHeight + 16, // Fixed height for performance and scrollbar stability
            itemBuilder: (context, index) {
              final row = widget.rows[index];
              final isFirstRow = index == 0;
              
              return FocusProvider(
                autoFocus: isFirstRow,
                child: SizedBox(
                  height: cardHeight + titleHeight + 16, // Added 16px padding to prevent overflow
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
                            // Update banner content for all devices
                            ref.read(focusedItemProvider.notifier).state = item;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
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
