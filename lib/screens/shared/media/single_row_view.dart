import 'dart:async';
import 'package:flutter/gestures.dart';
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
import 'package:kebap/screens/shared/media/vertical_page_indicator.dart';


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
  final PageController _pageController = PageController();
  int _currentPage = 0;
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

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
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
        // Scrollable rows via PageView
        Expanded(
          child: Stack(
            children: [

              GestureDetector(
                onVerticalDragEnd: (details) {
                  final velocity = details.primaryVelocity;
                  if (velocity == null || velocity == 0) return;
                  
                  if (velocity < 0) {
                    // Swipe Up -> Next Page
                     if (_currentPage < widget.rows.length - 1) {
                       _pageController.nextPage(
                         duration: const Duration(milliseconds: 300),
                         curve: Curves.easeInOut,
                       );
                     }
                  } else {
                    // Swipe Down -> Previous Page
                     if (_currentPage > 0) {
                       _pageController.previousPage(
                         duration: const Duration(milliseconds: 300),
                         curve: Curves.easeInOut,
                       );
                     }
                  }
                },
                child: Listener(
                  onPointerSignal: (pointerSignal) {
                    if (pointerSignal is PointerScrollEvent) {
                      // Ignore if we are already animating or strictly debouncing
                      if (_pageController.position.isScrollingNotifier.value) return;
                      
                      final double scrollDelta = pointerSignal.scrollDelta.dy;
                      if (scrollDelta.abs() > 20) { // Threshold for scroll
                         if (scrollDelta > 0) {
                           // Scroll Down -> Next Page
                           if (_currentPage < widget.rows.length - 1) {
                             _pageController.nextPage(
                               duration: const Duration(milliseconds: 300),
                               curve: Curves.easeInOut,
                             );
                           }
                         } else {
                           // Scroll Up -> Previous Page
                           if (_currentPage > 0) {
                             _pageController.previousPage(
                               duration: const Duration(milliseconds: 300),
                               curve: Curves.easeInOut,
                             );
                           }
                         }
                      }
                    }
                  },
                  child: PageView.builder(
                    controller: _pageController,
                    scrollDirection: Axis.vertical,
                    physics: const NeverScrollableScrollPhysics(),
                    // actually keeping Clamping or default is better for touch, but for mouse we want to override.
                    // Let's stick to default physics for touch, but the Listener will intercept mouse wheel.
                    // However, default PageView scroll with mouse wheel is 'slow'. 
                    // If we want ONLY custom logic for mouse wheel, we might need to be careful not to break touch.
                    // The Listener sees the event first. If we handle it, good.
                    
                    // NOTE: Flutter's PageView consumes scroll events. If we want to override mouse wheel specifically:
                    // 1. We can use `physics: const PageScrollPhysics()` which is standard.
                    // 2. The Listener above allows "flicking" pages with the wheel.
                    // To avoid conflict, we can leave physics as is. The issue is usually that the wheel adds small offsets that don't trigger the page snap easily.
                    
                    onPageChanged: _onPageChanged,
                    allowImplicitScrolling: true,
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
                        key: ValueKey(row.label),
                        autoFocus: isFirstRow && !_hasAutoFocused,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: extraBottomPadding),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center, // Center row in the page
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
                              SizedBox(
                                height: cardHeight,
                                child: PosterRow(
                                  contentPadding: EdgeInsets.only(
                                    left: widget.contentPadding.left,
                                    right: widget.contentPadding.right + 24, // Extra right padding for indicator
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
              ),
              Positioned(
                right: 8,
                top: 0,
                bottom: 0,
                child: VerticalPageIndicator(
                  itemCount: widget.rows.length,
                  currentPage: _currentPage,
                  controller: _pageController,
                  onDotTap: (index) {
                    _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
              ),
            ],
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
