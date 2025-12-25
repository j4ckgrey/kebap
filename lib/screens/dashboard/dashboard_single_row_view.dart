import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kebap/models/items/images_models.dart';
import 'package:kebap/providers/focused_item_provider.dart';
import 'package:kebap/screens/shared/media/poster_row.dart';
import 'package:kebap/screens/shared/media/single_row_view.dart';
import 'package:kebap/util/adaptive_layout/adaptive_layout.dart';
import 'package:kebap/util/focus_provider.dart';
import 'package:kebap/util/kebap_image.dart';
import 'package:kebap/screens/shared/media/compact_item_banner.dart';
import 'package:kebap/providers/settings/kebap_settings_provider.dart';
import 'package:kebap/providers/views_provider.dart';
import 'package:kebap/util/item_base_model/item_base_model_extensions.dart';
import 'package:kebap/util/item_base_model/play_item_helpers.dart';
import 'package:kebap/models/item_base_model.dart';

class DashboardSingleRowView extends ConsumerStatefulWidget {
  final List<RowData> rows;
  final EdgeInsets contentPadding;
  final Future<void> Function()? onRefresh;
  final bool isVisible;

  const DashboardSingleRowView({
    required this.rows,
    required this.contentPadding,
    this.onRefresh,
    this.isVisible = true,
    super.key,
  });

  @override
  ConsumerState<DashboardSingleRowView> createState() => _DashboardSingleRowViewState();
}

class _DashboardSingleRowViewState extends ConsumerState<DashboardSingleRowView> {
  int _selectedIndex = 0;
  int _lastAutoFocusedIndex = -1;
  List<FocusNode> _libraryFocusNodes = [];
  final FocusScopeNode _librariesScopeNode = FocusScopeNode(debugLabel: 'LibrariesScope');
  final FocusScopeNode _posterRowScopeNode = FocusScopeNode(debugLabel: 'PosterRowScope');
  final ScrollController _libraryScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initializeLibraryFocusNodes();
    _ensureContent();
    _setInitialFocus();
  }

  @override
  void didUpdateWidget(covariant DashboardSingleRowView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.rows.length != oldWidget.rows.length) {
      _disposeLibraryFocusNodes();
      _initializeLibraryFocusNodes();
      if (_selectedIndex >= widget.rows.length) {
        _selectedIndex = 0;
        _lastAutoFocusedIndex = -1;
      }
      _ensureContent();
    }
  }

  @override
  void dispose() {
    _disposeLibraryFocusNodes();
    _librariesScopeNode.dispose();
    _posterRowScopeNode.dispose();
    _libraryScrollController.dispose();
    super.dispose();
  }

  void _initializeLibraryFocusNodes() {
    _libraryFocusNodes = List.generate(
      widget.rows.length,
      (index) => FocusNode(debugLabel: 'Library_$index'),
    );
  }

  void _disposeLibraryFocusNodes() {
    for (final node in _libraryFocusNodes) {
      node.dispose();
    }
    _libraryFocusNodes = [];
  }

  void _setInitialFocus() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Don't steal focus if we aren't the active screen
      if (!widget.isVisible) return;
      if (!mounted || _lastAutoFocusedIndex >= 0 || widget.rows.isEmpty) return;
      
      final selectedRow = widget.rows[_selectedIndex];
      if (selectedRow.posters.isNotEmpty) {
        ref.read(focusedItemProvider.notifier).state = selectedRow.posters.first;
        _lastAutoFocusedIndex = _selectedIndex;
      }
    });
  }

  void _switchToLibrary(int index) {
    if (_selectedIndex == index) return;
    
    setState(() {
      _selectedIndex = index;
    });
    
    _lastAutoFocusedIndex = -1;
    _ensureContent();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final selectedRow = widget.rows[_selectedIndex];
      if (selectedRow.posters.isNotEmpty) {
        ref.read(focusedItemProvider.notifier).state = selectedRow.posters.first;
        _lastAutoFocusedIndex = _selectedIndex;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.rows.isEmpty) return const SizedBox.shrink();

    if (_selectedIndex >= widget.rows.length) _selectedIndex = 0;

    final selectedRow = widget.rows[_selectedIndex];
    final size = MediaQuery.sizeOf(context);
    final viewSize = AdaptiveLayout.viewSizeOf(context);
    final topPadding = MediaQuery.paddingOf(context).top;
    final bottomPadding = MediaQuery.paddingOf(context).bottom;
    final navbarHeight = topPadding + 56.0;
    final extraBottomPadding = bottomPadding + 4.0;
    final availableHeight = size.height - navbarHeight - extraBottomPadding;

    final mobileHeightRatio = ref.watch(kebapSettingsProvider.select((s) => s.mobileHomepageHeightRatio));
    final isLandscape = size.width > size.height;
    final baseBannerRatio = viewSize <= ViewSize.phone 
        ? (isLandscape ? 0.35 : mobileHeightRatio) 
        : 0.58;
    final baseBannerHeight = availableHeight * baseBannerRatio;

    const topRowHeight = 60.0;
    final bannerVerticalMargin = 8.0;
    final topRowVerticalMargin = 16.0;
    
    final fixedVerticalSpace = topRowHeight + bannerVerticalMargin + topRowVerticalMargin;
    final remainingForContent = availableHeight - fixedVerticalSpace;
    
    double bannerHeight = baseBannerHeight;
    double posterRowHeight = remainingForContent - bannerHeight;
    
    final minPosterRowHeight = size.height * 0.25;
    
    if (posterRowHeight < minPosterRowHeight) {
      final deficit = minPosterRowHeight - posterRowHeight;
      bannerHeight -= deficit;
      if (bannerHeight < size.height * 0.2) {
        bannerHeight = size.height * 0.2;
      }
      posterRowHeight = remainingForContent - bannerHeight;
    }
    
    bannerHeight = bannerHeight.clamp(0.0, availableHeight);
    posterRowHeight = posterRowHeight.clamp(0.0, availableHeight);

    return Column(
      children: [
        // Banner - isolated Consumer to prevent parent rebuilds
        RepaintBoundary(
          child: ClipRect(
            child: SizedBox(
              height: bannerHeight,
              child: Consumer(
                builder: (context, ref, child) {
                  final focusedItem = ref.watch(focusedItemProvider);
                  return CompactItemBanner(
                    key: ValueKey(focusedItem?.id),
                    item: focusedItem,
                    maxHeight: bannerHeight,
                  );
                },
              ),
            ),
          ),
        ),

        SizedBox(height: bannerVerticalMargin),

        // Library Chips Row - no extra padding, full width
        SizedBox(
          height: 70,
          child: FocusScope(
            node: _librariesScopeNode,
            onKeyEvent: (node, event) {
              if (event is KeyDownEvent) {
                // Block UP - no escape to hamburger from library row
                if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
                  return KeyEventResult.handled;
                }
                
                // LEFT on first chip opens sidebar
                if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
                  if (_libraryFocusNodes.isNotEmpty && _libraryFocusNodes[0].hasFocus) {
                    try {
                      Scaffold.of(context).openDrawer();
                    } catch (_) {}
                    return KeyEventResult.handled;
                  }
                }
                
                // DOWN goes to poster row
                if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
                  _posterRowScopeNode.requestFocus();
                  return KeyEventResult.handled;
                }
                
                // ENTER/SELECT activates library
                if (event.logicalKey == LogicalKeyboardKey.enter ||
                    event.logicalKey == LogicalKeyboardKey.select) {
                  for (int i = 0; i < _libraryFocusNodes.length; i++) {
                    if (_libraryFocusNodes[i].hasFocus) {
                      _switchToLibrary(i);
                      return KeyEventResult.handled;
                    }
                  }
                }
              }
              return KeyEventResult.ignored;
            },
            child: FocusTraversalGroup(
              policy: ReadingOrderTraversalPolicy(),
              child: ListView.separated(
                controller: _libraryScrollController,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: widget.rows.length,
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final row = widget.rows[index];
                  final isSelected = index == _selectedIndex;
                  
                  return _LibraryChipWithHover(
                    key: ValueKey('chip_$index'),
                    focusNode: _libraryFocusNodes[index],
                    isSelected: isSelected,
                    label: row.label,
                    image: row.image,
                    onSelected: (selected) {
                      if (selected) {
                        _switchToLibrary(index);
                      }
                    },
                  );
                },
              ),
            ),
          ),
        ),
        
        SizedBox(height: topRowVerticalMargin),
        
        // Poster Row - navigation handled by HorizontalRailFocus callbacks
        SizedBox(
          height: posterRowHeight,
          child: FocusScope(
            node: _posterRowScopeNode,
            child: selectedRow.requiresLoading 
              ? const Center(child: CircularProgressIndicator.adaptive())
              : FocusProvider(
                  key: ValueKey('focus_${selectedRow.id ?? selectedRow.label}'),
                  autoFocus: _lastAutoFocusedIndex != _selectedIndex,
                  // Consumer isolates PosterRow rebuilds from parent
                  child: Consumer(
                    builder: (context, ref, child) {
                      final focusedItem = ref.watch(focusedItemProvider);
                      return PosterRow(
                        key: ValueKey(selectedRow.id ?? selectedRow.label),
                        contentPadding: widget.contentPadding,
                        label: selectedRow.label,
                        hideLabel: true,
                        posters: selectedRow.posters,
                        collectionAspectRatio: selectedRow.aspectRatio,
                        explicitHeight: posterRowHeight,
                        selectedItemId: focusedItem?.id,
                        onLabelClick: selectedRow.onLabelClick,
                        onLeftFromFirst: () {
                          try {
                            Scaffold.of(context).openDrawer();
                          } catch (_) {}
                        },
                        onUpFromRow: () {
                          // Request focus on selected library chip directly
                          if (_selectedIndex < _libraryFocusNodes.length) {
                            final node = _libraryFocusNodes[_selectedIndex];
                            if (node.context != null) {
                              node.requestFocus();
                            } else {
                              // Fallback: If specific chip is off-screen/unbuilt, 
                              // focus the row scope to capture focus within the library bar
                              _librariesScopeNode.requestFocus();
                            }
                          }
                        },
                        onFocused: (item) {
                          ref.read(focusedItemProvider.notifier).state = item;
                        },
                        onCardTap: (item) {
                          ref.read(focusedItemProvider.notifier).state = item;
                          if (selectedRow.onItemTap != null) {
                            selectedRow.onItemTap!(item);
                          } else {
                            item.navigateTo(context, ref: ref);
                          }
                        },
                        onCardAction: (item) {
                           if (selectedRow.onItemOpen != null) {
                             selectedRow.onItemOpen!(item);
                           } else {
                             item.navigateTo(context, ref: ref);
                           }
                        },
                      );
                    },
                  ),
              ),
          ),
        ),
      ],
    );
  }
  
  void _ensureContent() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      // Don't trigger load actions that might affect focus if we aren't active
      if (!widget.isVisible) return;
      if (widget.rows.isEmpty) return;
      final selectedRow = widget.rows[_selectedIndex];
      if (selectedRow.requiresLoading && selectedRow.id != null) {
        ref.read(viewsProvider.notifier).loadCatalogContent(selectedRow.id!);
      }
    });
  }
}

/// Library chip with hover border feedback and background image support
class _LibraryChipWithHover extends StatelessWidget {
  final FocusNode focusNode;
  final bool isSelected;
  final String label;
  final ImagesData? image;
  final Function(bool) onSelected;

  const _LibraryChipWithHover({
    super.key,
    required this.focusNode,
    required this.isSelected,
    required this.label,
    required this.image,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(12);
    
    return AspectRatio(
      aspectRatio: 2.5,
      child: FocusButton(
        focusNode: focusNode,
        onTap: () => onSelected(true),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: radius,
            boxShadow: isSelected 
               ? [BoxShadow(color: Theme.of(context).colorScheme.primary.withOpacity(0.4), blurRadius: 8, spreadRadius: 1)]
               : [],
            border: isSelected
               ? Border.all(color: Theme.of(context).colorScheme.primary, width: 2)
               : Border.all(color: Colors.transparent, width: 2),
          ),
          child: ClipRRect(
            borderRadius: radius,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Background Image
                KebapImage(
                   image: image?.primary, 
                   fit: BoxFit.cover,
                ),
                // Dark Overlay - Only show if no image
                if (image?.primary == null)
                  Container(
                    color: Colors.black.withOpacity(0.6),
                  ),
                // Centered Label - Only show if no image
                if (image?.primary == null)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Text(
                         label,
                         textAlign: TextAlign.center,
                         maxLines: 2,
                         overflow: TextOverflow.ellipsis,
                         style: Theme.of(context).textTheme.titleSmall?.copyWith(
                           color: Colors.white,
                           fontWeight: FontWeight.bold,
                           shadows: [
                             Shadow(
                               offset: const Offset(0, 1),
                               blurRadius: 2.0,
                               color: Colors.black.withOpacity(0.8),
                             ),
                           ],
                         ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
