import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kebap/models/item_base_model.dart';
import 'package:kebap/providers/focused_item_provider.dart';
import 'package:kebap/screens/shared/media/compact_item_banner.dart';
import 'package:kebap/screens/shared/media/poster_row.dart';
import 'dart:math' as math;

import 'package:kebap/util/adaptive_layout/adaptive_layout.dart';
import 'package:kebap/providers/settings/client_settings_provider.dart';
import 'package:kebap/util/focus_provider.dart';


/// Single row view with fixed banner
/// Shows scrollable rows with banner that updates based on card selection
class SingleRowView extends ConsumerStatefulWidget {
  final List<RowData> rows;
  final EdgeInsets contentPadding;

  final Future<void> Function()? onRefresh;

  const SingleRowView({
    required this.rows,
    required this.contentPadding,
    this.onRefresh,
    super.key,
  });

  @override
  ConsumerState<SingleRowView> createState() => _SingleRowViewState();
}

class _SingleRowViewState extends ConsumerState<SingleRowView> {
  final ScrollController _scrollController = ScrollController();
  bool _hasAutoFocused = false;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _initializeFocus();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _hasAutoFocused = true;
    });
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

  void _onItemFocused(ItemBaseModel item) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 200), () {
      if (mounted) {
        ref.read(focusedItemProvider.notifier).state = item;
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final viewSize = AdaptiveLayout.viewSizeOf(context);
    final topPadding = MediaQuery.paddingOf(context).top;
    final bottomPadding = MediaQuery.paddingOf(context).bottom;
    final navbarHeight = topPadding + 56.0;
    // Add a little extra bottom padding to avoid content clipping under system bars
    final extraBottomPadding = bottomPadding + 12.0;
    // Subtract bottom safe area as well to avoid clipping on devices with navigation bars
    final availableHeight = size.height - navbarHeight - extraBottomPadding;

    // Universal sizing for all devices - compute title height dynamically
    final titleStyle = Theme.of(context).textTheme.titleMedium;
    final titleHeight = (titleStyle?.fontSize ?? 18) + 12; // font size + top/bottom padding (8 + 4)
    // poster size multiplier from settings
    final posterSizeMultiplier = ref.watch(clientSettingsProvider.select((value) => value.posterSize));

    final defaultCardHeight = ((AdaptiveLayout.poster(context).size * posterSizeMultiplier) /
            math.pow(AdaptiveLayout.poster(context).ratio, 0.55)) *
        0.72;

    final bannerHeight = viewSize <= ViewSize.phone ? availableHeight * 0.60 : availableHeight * 0.58;

    // default scale; reduce size when required heights exceed available height
    double scale = 1.0;
    final rowExtent = defaultCardHeight + titleHeight + 16;
    final requiredHeight = bannerHeight + rowExtent + 16;
    if (requiredHeight > availableHeight) {
      scale = (availableHeight / requiredHeight).clamp(0.6, 1.0);
    }

    final scaledCardHeight = defaultCardHeight * scale;
    final scaledBannerHeight = (bannerHeight * ((scale + 1) / 2)).clamp(availableHeight * 0.28, bannerHeight);

    // Fixed banner (non-scrollable) and rows - return the Column
    return Column(
      children: [
        SizedBox(
          height: scaledBannerHeight,
          child: Consumer(
            builder: (context, ref, child) {
              return CompactItemBanner(
                item: ref.watch(focusedItemProvider),
                maxHeight: scaledBannerHeight,
              );
            },
          ),
        ),
        // Scrollable rows
        Expanded(
          child: widget.onRefresh != null
              ? RefreshIndicator(
                  onRefresh: widget.onRefresh!,
                  child: ListView.builder(
                    controller: _scrollController,
                    primary: false,
                    physics: const AlwaysScrollableScrollPhysics(), // Ensure scrollable for refresh
                    padding: EdgeInsets.only(bottom: extraBottomPadding),
                    itemCount: widget.rows.length,
                    itemBuilder: (context, index) {
                      final row = widget.rows[index];
                      final isFirstRow = index == 0;

                      // compute dominant ratio per row like PosterRow does
                      final dominantRatio = row.aspectRatio ?? AdaptiveLayout.poster(context).ratio;
                      final cardHeight = (((AdaptiveLayout.poster(context).size * posterSizeMultiplier) /
                                  math.pow(dominantRatio, 0.55)) *
                              0.72) *
                          scale;

                      return FocusProvider(
                        autoFocus: isFirstRow && !_hasAutoFocused,
                        child: SizedBox(
                          height: cardHeight + titleHeight + 16, // Height matches PosterRow defaults + title
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
                                  onCardTap: _onItemFocused,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
              : ListView.builder(
                  controller: _scrollController,
                  primary: false,
                  physics: const ClampingScrollPhysics(), // Proper scroll physics
                  padding: EdgeInsets.only(bottom: extraBottomPadding),
                  itemCount: widget.rows.length,
                  itemBuilder: (context, index) {
                    final row = widget.rows[index];
                    final isFirstRow = index == 0;

                    // compute dominant ratio per row like PosterRow does
                    final dominantRatio = row.aspectRatio ?? AdaptiveLayout.poster(context).ratio;
                    final cardHeight = (((AdaptiveLayout.poster(context).size * posterSizeMultiplier) /
                                math.pow(dominantRatio, 0.55)) *
                            0.72) *
                        scale;

                    return FocusProvider(
                      autoFocus: isFirstRow && !_hasAutoFocused,
                      child: SizedBox(
                        height: cardHeight + titleHeight + 16, // Height matches PosterRow defaults + title
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
                                onCardTap: _onItemFocused,
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
