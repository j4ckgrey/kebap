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
import 'package:kebap/providers/settings/kebap_settings_provider.dart';
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
  String? _lastFocusedRowLabel; // Track active row for focus restoration

  @override
  void initState() {
    super.initState();
    _initializeFocus();
  }

  @override
  void didUpdateWidget(SingleRowView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.rows.length != oldWidget.rows.length ||
        (widget.rows.isNotEmpty && oldWidget.rows.isNotEmpty && widget.rows[0].label != oldWidget.rows[0].label)) {
      
      // Handle row insertion/deletion by realigning to the last focused row
      if (_lastFocusedRowLabel != null) {
        final newIndex = widget.rows.indexWhere((r) => r.label == _lastFocusedRowLabel);
        if (newIndex != -1 && newIndex != _currentPage) {
           setState(() {
             _currentPage = newIndex;
           });
           // Use addPostFrameCallback to ensure controller has clients and layout is ready
           WidgetsBinding.instance.addPostFrameCallback((_) {
             if (_pageController.hasClients) {
               _pageController.jumpToPage(newIndex);
             }
           });
        }
      }

      if (widget.rows.isNotEmpty && oldWidget.rows.isNotEmpty && widget.rows[0].label != oldWidget.rows[0].label) {
         // If the first row replaced (e.g. Libraries loaded above Next Up), reset autofocus
         _hasAutoFocused = false;
      }
      _initializeFocus();
    }
  }

  void _initializeFocus() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      
      // Check if we already have system focus in this view
      final hasSystemFocus = FocusScope.of(context).hasFocus;
      final firstRowChanged = widget.rows.isNotEmpty && widget.rows[0].label != _lastFocusedRowLabel;

      if (hasSystemFocus && !firstRowChanged) {
         // If we have system focus, ensure our internal state matches it to avoid "double selection" visual
         final currentFocus = ref.read(focusedItemProvider);
         if (currentFocus != null && _lastFocusedRowLabel == null) {
            for (final row in widget.rows) {
              if (row.posters.any((p) => p.id == currentFocus.id)) {
                 setState(() {
                   _lastFocusedRowLabel = row.label;
                 });
                 break;
              }
            }
         }
         return; 
      }

      final currentFocus = ref.read(focusedItemProvider);
      if (currentFocus == null && widget.rows.isNotEmpty && widget.rows[0].posters.isNotEmpty) {
        // Set initial banner item only if none selected
        ref.read(focusedItemProvider.notifier).state = widget.rows[0].posters.first;
        setState(() {
          _lastFocusedRowLabel = widget.rows[0].label;
          _hasAutoFocused = true;
        });
      } else if (widget.rows.isNotEmpty && widget.rows[0].label != _lastFocusedRowLabel && !_hasAutoFocused) {
         // Force focus to new top row (Libraries) if we haven't locked focus yet
        ref.read(focusedItemProvider.notifier).state = widget.rows[0].posters.first;
        setState(() {
          _lastFocusedRowLabel = widget.rows[0].label;
          _hasAutoFocused = true;
        });
      }
    });
  }

  void _onItemFocused(ItemBaseModel? item, String label) {
    
    // If item is null (e.g. Show More focused), we still want to update state to null
    // so the banner clears or stays empty, instead of showing the last selected item.
    if (item == null) {
       ref.read(focusedItemProvider.notifier).state = null;
       if (_lastFocusedRowLabel != label) {
          setState(() {
            _lastFocusedRowLabel = label;
          });
       }
       return;
    }

    final currentFocused = ref.read(focusedItemProvider);
    // Only update if item actually changed
    if (currentFocused?.id != item.id) {
      ref.read(focusedItemProvider.notifier).state = item;
    }
    if (_lastFocusedRowLabel != label) {
      setState(() {
        _lastFocusedRowLabel = label;
      });
    }
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
    // Auto-select first item of new row so banner updates
    if (page >= 0 && page < widget.rows.length && widget.rows[page].posters.isNotEmpty) {
      _onItemFocused(widget.rows[page].posters.first, widget.rows[page].label);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
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
    // REDUCED PADDING
    final extraBottomPadding = bottomPadding + 4.0; 
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

    // Mobile homepage height ratio from settings (default 0.6, range 0.3-0.7)
    final mobileHeightRatio = ref.watch(kebapSettingsProvider.select((s) => s.mobileHomepageHeightRatio));
    
    // In landscape (width > height), use a smaller banner to leave room for rows
    final isLandscape = size.width > size.height;
    final baseBannerRatio = viewSize <= ViewSize.phone 
        ? (isLandscape ? 0.35 : mobileHeightRatio) // Smaller in landscape
        : 0.58;
    final baseBannerHeight = availableHeight * baseBannerRatio;

    // default scale; reduce size when required heights exceed available height
    double scale = 1.0;
    // FIX: Include extraBottomPadding in rowExtent. REDUCED FIXED PADDING 16->8
    final rowExtent = defaultCardHeight + titleHeight + 8 + extraBottomPadding;
    final requiredHeight = baseBannerHeight + rowExtent + 8; // REDUCED 16->8
    if (requiredHeight > availableHeight) {
      // FIX: Aggressively lower clamp to 0.2 to ensure fit on very small initial windows
      scale = (availableHeight / requiredHeight).clamp(0.2, 1.0);
    }

    final scaledCardHeight = defaultCardHeight * scale;
    // Ensure banner never takes more than available minus row space
    final maxBannerHeight = availableHeight - (scaledCardHeight + titleHeight + 32);
    final scaledBannerHeight = (baseBannerHeight * ((scale + 1) / 2))
        .clamp(availableHeight * 0.2, maxBannerHeight.clamp(availableHeight * 0.2, baseBannerHeight));

    // Fixed banner (non-scrollable) and rows - return the Column
    return Column(
      children: [
        RepaintBoundary(
          child: ClipRect(
            child: SizedBox(
              height: scaledBannerHeight,
              child: Consumer(
                builder: (context, ref, child) {
                  // Only rebuild when focused item ID changes
                  final focusedItem = ref.watch(focusedItemProvider);
                  return CompactItemBanner(
                    key: ValueKey(focusedItem?.id),
                    item: focusedItem,
                    maxHeight: scaledBannerHeight,
                  );
                },
              ),
            ),
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
                      // Ignore if we are already animating
                      if (_pageController.position.isScrollingNotifier.value) return;
                      
                      final double scrollDelta = pointerSignal.scrollDelta.dy;
                      if (scrollDelta.abs() > 30) { // Higher threshold for scroll
                         if (scrollDelta > 0) {
                           // Scroll Down -> Next Page
                           if (_currentPage < widget.rows.length - 1) {
                             _pageController.nextPage(
                               duration: const Duration(milliseconds: 350), // Slower animation
                               curve: Curves.easeOutCubic,
                             );
                           }
                         } else {
                           // Scroll Up -> Previous Page
                           if (_currentPage > 0) {
                             _pageController.previousPage(
                               duration: const Duration(milliseconds: 350), // Slower animation
                               curve: Curves.easeOutCubic,
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
                    onPageChanged: _onPageChanged,
                    allowImplicitScrolling: true,
                    itemCount: widget.rows.length,
                    itemBuilder: (context, index) {
                      final row = widget.rows[index];
                      final isFirstRow = index == 0;
  
                      // compute dominant ratio per row like PosterRow does
                      final dominantRatio = row.aspectRatio ?? AdaptiveLayout.poster(context).ratio;
                      final ratioForHeight = row.useStandardHeight ? AdaptiveLayout.poster(context).ratio : dominantRatio;
                      final cardHeight = (((AdaptiveLayout.poster(context).size * posterSizeMultiplier) /
                                  math.pow(ratioForHeight, 0.55)) *
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
                                // REDUCED TOP/BOTTOM PADDING
                                padding: const EdgeInsets.only(left: 16, top: 4, bottom: 2), 
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
                                child: Consumer(
                                  builder: (context, ref, child) {
                                    final focusedItem = ref.watch(focusedItemProvider);
                                    return PosterRow(
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
                                      onFocused: (item) => _onItemFocused(item, row.label), // Explicitly handle focus for banner
                                      selectedItemId: row.label == _lastFocusedRowLabel ? focusedItem?.id : null, // persistent selection only for active row
                                      onLeftFromFirst: () {
                                        // Open sidebar on LEFT from first item
                                        try {
                                          Scaffold.of(context).openDrawer();
                                        } catch (_) {}
                                      },
                                      onUpFromRow: () {
                                        // Go to previous row on UP, or block if first row
                                        if (index > 0) {
                                          _pageController.previousPage(
                                            duration: const Duration(milliseconds: 300),
                                            curve: Curves.easeInOut,
                                          );
                                        }
                                        // If first row, do nothing (stay on current row)
                                      },
                                      onDownFromRow: () {
                                        // Go to next row on DOWN, or block if last row
                                        if (index < widget.rows.length - 1) {
                                          _pageController.nextPage(
                                            duration: const Duration(milliseconds: 300),
                                            curve: Curves.easeInOut,
                                          );
                                        }
                                        // If last row, do nothing (stay on current row)
                                      },
                                    onCardTap: (item) {
                                      if (row.onItemTap != null) {
                                        row.onItemTap!(item);
                                      } else {
                                        // Default behavior: Focus the item for banner
                                         _onItemFocused(item, row.label);
                                      }
                                    },
                                    onCardAction: row.onItemOpen,
                                    );
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
  final Function()? onLabelClick;
  final Function(ItemBaseModel item)? onItemTap;
  final Function(ItemBaseModel item)? onItemOpen;
  final double? aspectRatio;
  final bool useStandardHeight;

  final String? id;
  final bool requiresLoading;

  const RowData({
    required this.label,
    required this.posters,
    this.id,
    this.requiresLoading = false,
    this.aspectRatio,
    this.onLabelClick,
    this.onItemTap,
    this.onItemOpen,
    this.useStandardHeight = false,
  });
}
