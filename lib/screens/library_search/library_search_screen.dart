import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import 'package:kebap/models/boxset_model.dart';
import 'package:kebap/models/item_base_model.dart';
import 'package:kebap/models/library_filter_model.dart';
import 'package:kebap/models/library_search/library_search_model.dart';
import 'package:kebap/models/library_search/library_search_options.dart';
import 'package:kebap/models/playlist_model.dart';
import 'package:kebap/providers/arguments_provider.dart';
import 'package:kebap/providers/library_search_provider.dart';
import 'package:kebap/providers/settings/client_settings_provider.dart';
import 'package:kebap/screens/collections/add_to_collection.dart';
import 'package:kebap/screens/library_search/widgets/library_filter_chips.dart';
import 'package:kebap/screens/library_search/widgets/library_play_options_.dart';
import 'package:kebap/screens/library_search/widgets/library_saved_filters.dart';
import 'package:kebap/screens/library_search/widgets/library_sort_dialogue.dart';
import 'package:kebap/screens/library_search/widgets/library_views.dart';
import 'package:kebap/screens/library_search/widgets/suggestion_search_bar.dart';
import 'package:kebap/screens/playlists/add_to_playlists.dart';
import 'package:kebap/screens/shared/animated_fade_size.dart';
import 'package:kebap/screens/shared/nested_bottom_appbar.dart';
import 'package:kebap/screens/shared/nested_scaffold.dart';
import 'package:kebap/util/adaptive_layout/adaptive_layout.dart';
import 'package:kebap/util/debouncer.dart';
import 'package:kebap/util/item_base_model/item_base_model_extensions.dart';
import 'package:kebap/util/list_padding.dart';
import 'package:kebap/util/localization_helper.dart';
import 'package:kebap/util/map_bool_helper.dart';
import 'package:kebap/util/refresh_state.dart';
import 'package:kebap/util/router_extension.dart';
import 'package:kebap/widgets/navigation_scaffold/components/background_image.dart';
import 'package:kebap/widgets/search/search_mode_toggle.dart';
import 'package:kebap/widgets/shared/kebap_scrollbar.dart';
import 'package:kebap/widgets/shared/item_actions.dart';
import 'package:kebap/widgets/shared/modal_bottom_sheet.dart';
import 'package:kebap/widgets/shared/pinch_poster_zoom.dart';
import 'package:kebap/widgets/shared/poster_size_slider.dart';
import 'package:kebap/widgets/shared/pull_to_refresh.dart';
import 'package:kebap/widgets/shared/scroll_position.dart';

@RoutePage()
class LibrarySearchScreen extends ConsumerStatefulWidget {
  final String? viewModelId;
  final bool? favourites;
  final List<String>? folderId;
  final SortingOrder? sortOrder;
  final SortingOptions? sortingOptions;
  final Map<KebapItemType, bool>? types;
  final Map<String, bool>? genres;
  final bool? recursive;
  const LibrarySearchScreen({
    @QueryParam("parentId") this.viewModelId,
    @QueryParam("folderId") this.folderId,
    @QueryParam("favourites") this.favourites,
    @QueryParam("sortOrder") this.sortOrder,
    @QueryParam("sortOptions") this.sortingOptions,
    @QueryParam("itemTypes") this.types,
    @QueryParam("genres") this.genres,
    @QueryParam("recursive") this.recursive,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LibrarySearchScreenState();
}

class _LibrarySearchScreenState extends ConsumerState<LibrarySearchScreen> {
  final Debouncer debouncer = Debouncer(const Duration(milliseconds: 500));
  final GlobalKey<RefreshIndicatorState> refreshKey = GlobalKey<RefreshIndicatorState>();
  final ScrollController scrollController = ScrollController();
  final FocusNode resultsFocusNode = FocusNode();
  late double lastScale = 0;

  bool loadOnStart = false;

  Key get uniqueKey => Key(widget.folderId?.join(',').toString() ?? widget.viewModelId ?? "EmptySearch");
  AutoDisposeStateNotifierProvider<LibrarySearchNotifier, LibrarySearchModel> get providerKey =>
      librarySearchProvider(uniqueKey);
  LibrarySearchNotifier get libraryProvider => ref.read(librarySearchProvider(uniqueKey).notifier);

  @override
  void didUpdateWidget(covariant LibrarySearchScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (kIsWeb && ref.read(librarySearchProvider(uniqueKey)).posters.isEmpty) {
      initLibrary();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((value) {
      initLibrary();
    });
  }

  Future<void> initLibrary() async {
    await refreshKey.currentState?.show();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
      overlays: [],
    );
    scrollController.addListener(() {
      scrollPosition();
    });
  }

  void scrollPosition() {
    if (scrollController.position.pixels > scrollController.position.maxScrollExtent * 0.65) {
      libraryProvider.loadMore();
    }
  }

  Future<void> refreshSearch() async {
    await refreshKey.currentState?.show();
    scrollController.jumpTo(0);
  }

  @override
  Widget build(BuildContext context) {
    final surfaceColor = Theme.of(context).colorScheme.surface;

    final isEmptySearchScreen = widget.viewModelId == null && widget.favourites == null && widget.folderId == null;
    final librarySearchResults = ref.watch(providerKey);
    final postersList = librarySearchResults.posters.hideEmptyChildren(librarySearchResults.filters.hideEmptyShows);
    final libraryViewType = ref.watch(libraryViewTypeProvider);

    final floatingAppBar = AdaptiveLayout.layoutModeOf(context) != LayoutMode.single;

    final toolbarHeight = 55.0;

    ref.listen(
      providerKey,
      (previous, next) {
        if (previous?.filters != next.filters) {
          refreshSearch();
        }
      },
    );

    return PopScope(
      key: uniqueKey,
      canPop: !librarySearchResults.selecteMode,
      onPopInvokedWithResult: (didPop, result) {
        if (librarySearchResults.selecteMode) {
          libraryProvider.toggleSelectMode();
        }
      },
      child: NestedScaffold(
        background: BackgroundImage(images: postersList.map((e) => e.images).nonNulls.toList()),
        body: Padding(
          padding: EdgeInsets.only(left: 16),
          child: Scaffold(
            extendBody: true,
            backgroundColor: Colors.transparent,
            extendBodyBehindAppBar: true,
            // Floating action button removed for mobile view per design decision.
            floatingActionButton: null,
            bottomNavigationBar: null,
            body: PinchPosterZoom(
              scaleDifference: (difference) => ref.read(clientSettingsProvider.notifier).addPosterSize(difference),
              child: KebapScrollbar(
                visible: AdaptiveLayout.inputDeviceOf(context) != InputDevice.pointer,
                controller: scrollController,
                child: PullToRefresh(
                  refreshKey: refreshKey,
                  autoFocus: false,
                  contextRefresh: false,
                  onRefresh: () async {
                    final defaultFilter = const LibraryFilterModel();
                    if (libraryProvider.mounted) {
                      return libraryProvider.initRefresh(
                        widget.folderId,
                        widget.viewModelId,
                        defaultFilter.copyWith(
                          favourites: widget.favourites,
                          sortOrder: widget.sortOrder ?? defaultFilter.sortOrder,
                          sortingOption: widget.sortingOptions ?? defaultFilter.sortingOption,
                          types: widget.types ?? {},
                          genres: widget.genres ?? {},
                          recursive: widget.recursive,
                        ),
                      );
                    }
                  },
                  refreshOnStart: false,
                  child: CustomScrollView(
                    controller: scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverAppBar(
                        floating: !floatingAppBar,
                        collapsedHeight: 80,
                        automaticallyImplyLeading: false,
                        primary: true,
                        pinned: floatingAppBar,
                        elevation: 5,
                        surfaceTintColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        backgroundColor: Colors.transparent,
                        titleSpacing: 4,
                        flexibleSpace: AdaptiveLayout.layoutModeOf(context) != LayoutMode.dual
                            ? Container(
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                  colors: [
                                    surfaceColor.withValues(alpha: 0.8),
                                    surfaceColor.withValues(alpha: 0.75),
                                    surfaceColor.withValues(alpha: 0.5),
                                    surfaceColor.withValues(alpha: 0),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                )),
                              )
                            : null,
                        actions: [
                          Builder(builder: (context) {
                            final isFavorite = librarySearchResults.nestedCurrentItem?.userData.isFavourite == true;
                            final itemActions = librarySearchResults.nestedCurrentItem?.generateActions(
                                  context,
                                  ref,
                                  exclude: {
                                    ItemActions.details,
                                    ItemActions.markPlayed,
                                    ItemActions.markUnplayed,
                                  },
                                  onItemUpdated: (item) {
                                    libraryProvider.updateParentItem(item);
                                  },
                                  onUserDataChanged: (userData) {
                                    libraryProvider.updateUserDataMain(userData);
                                  },
                                ) ??
                                [];
                            final itemCountWidget = ItemActionButton(
                              label: Text(context.localized.itemCount(librarySearchResults.totalItemCount)),
                              icon: const Icon(IconsaxPlusBold.document_1),
                            );
                            final refreshAction = ItemActionButton(
                              label: Text(context.localized.forceRefresh),
                              action: () => refreshKey.currentState?.show(),
                              icon: const Icon(IconsaxPlusLinear.refresh),
                            );
                            final showSavedFiltersDialogue = ItemActionButton(
                              label: Text(context.localized.filter(2)),
                              action: () => showSavedFilters(context, uniqueKey),
                              icon: const Icon(IconsaxPlusLinear.refresh),
                            );
                            final itemViewAction = ItemActionButton(
                                label: Text(context.localized.selectViewType),
                                icon: Icon(libraryViewType.icon),
                                action: () {
                                  showAdaptiveDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (context) => AlertDialog(
                                      content: Consumer(
                                        builder: (context, ref, child) {
                                          final currentType = ref.watch(libraryViewTypeProvider);
                                          return Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.stretch,
                                            children: [
                                              Text(context.localized.selectViewType,
                                                  style: Theme.of(context).textTheme.titleMedium),
                                              const SizedBox(height: 12),
                                              ...LibraryViewTypes.values
                                                  .map(
                                                    (e) => FilledButton.tonal(
                                                      style: FilledButtonTheme.of(context).style?.copyWith(
                                                            padding: const WidgetStatePropertyAll(
                                                                EdgeInsets.symmetric(horizontal: 12, vertical: 24)),
                                                            backgroundColor: WidgetStateProperty.resolveWith(
                                                              (states) {
                                                                if (e != currentType) {
                                                                  return Colors.transparent;
                                                                }
                                                                return null;
                                                              },
                                                            ),
                                                          ),
                                                      onPressed: () {
                                                        ref.read(libraryViewTypeProvider.notifier).state = e;
                                                      },
                                                      child: Row(
                                                        children: [
                                                          Icon(e.icon),
                                                          const SizedBox(width: 12),
                                                          Text(
                                                            e.label(context),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                  .toList()
                                                  .addInBetween(const SizedBox(height: 12)),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                });
                            return SizedBox.square(
                              dimension: toolbarHeight,
                              child: Card(
                                elevation: 0,
                                child: Tooltip(
                                  message: librarySearchResults.nestedCurrentItem?.type.label(context) ??
                                      context.localized.library(1),
                                  child: IconButton(
                                    onPressed: () async {
                                      await showBottomSheetPill(
                                        context: context,
                                        content: (context, scrollController) => ListView(
                                          shrinkWrap: true,
                                          controller: scrollController,
                                          children: [
                                            itemCountWidget.toListItem(context, useIcons: true),
                                            refreshAction.toListItem(context, useIcons: true),
                                            itemViewAction.toListItem(context, useIcons: true),
                                            if (librarySearchResults.views.hasEnabled == true)
                                              showSavedFiltersDialogue.toListItem(context, useIcons: true),
                                            if (itemActions.isNotEmpty) ItemActionDivider().toListItem(context),
                                            ...itemActions.listTileItems(context, useIcons: true),
                                          ],
                                        ),
                                      );
                                    },
                                    icon: Padding(
                                      padding: const EdgeInsets.all(6),
                                      child: Icon(
                                        isFavorite
                                            ? librarySearchResults.nestedCurrentItem?.type.selectedicon
                                            : librarySearchResults.nestedCurrentItem?.type.icon ??
                                                IconsaxPlusLinear.document,
                                        color: isFavorite ? Theme.of(context).colorScheme.primary : null,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                          SearchModeToggle(
                            onModeChanged: () {
                              // Trigger search refresh when mode changes
                              refreshKey.currentState?.show();
                            },
                          ),
                          if (AdaptiveLayout.layoutModeOf(context) == LayoutMode.single) ...[
                            const SizedBox(width: 6),
                            // User icon removed as per user request
                          ],
                          const SizedBox(width: 12)
                        ],
                        title: SizedBox(
                          height: toolbarHeight,
                          child: Row(
                            spacing: 2,
                            children: [
                              const SizedBox(width: 2),
                              const SizedBox(width: 2),
                              if (!ref.watch(argumentsStateProvider.select((value) => value.htpcMode)))
                                Center(
                                  child: SizedBox.square(
                                    dimension: toolbarHeight,
                                    child: Card(
                                      elevation: 0,
                                      child: context.router.backButton(),
                                    ),
                                  ),
                                ),
                              Flexible(
                                child: Hero(
                                  tag: "PrimarySearch",
                                  child: SuggestionSearchBar(
                                    autoFocus: isEmptySearchScreen,
                                    key: uniqueKey,
                                    title: librarySearchResults.searchBarTitle(context),
                                    debounceDuration: const Duration(milliseconds: 500),
                                    onChanged: (value) {
                                      if (librarySearchResults.searchQuery != value) {
                                        debouncer.run(() {
                                          libraryProvider.setSearch(value);
                                          refreshKey.currentState?.show();
                                        });
                                      }
                                    },
                                    onSubmited: (value) async {
                                      if (librarySearchResults.searchQuery != value) {
                                        libraryProvider.setSearch(value);
                                        refreshKey.currentState?.show();
                                      }
                                      resultsFocusNode.requestFocus();
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        bottom: PreferredSize(
                          preferredSize: Size(0, AdaptiveLayout.inputDeviceOf(context) == InputDevice.dPad ? 105 : 50),
                          child: IgnorePointer(
                            ignoring: librarySearchResults.loading,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Opacity(
                                  opacity: librarySearchResults.loading ? 0.5 : 1,
                                  child: SingleChildScrollView(
                                    padding: const EdgeInsets.all(8),
                                    scrollDirection: Axis.horizontal,
                                    child: LibraryFilterChips(
                                      key: uniqueKey,
                                    ),
                                  ),
                                ),
                                if (AdaptiveLayout.inputDeviceOf(context) == InputDevice.dPad)
                                  _LibrarySearchBottomBar(
                                    uniqueKey: uniqueKey,
                                    refreshKey: refreshKey,
                                    scrollController: scrollController,
                                    libraryProvider: libraryProvider,
                                    postersList: postersList,
                                    isDPadBar: true,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (AdaptiveLayout.of(context).isDesktop)
                        const SliverToBoxAdapter(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              PosterSizeWidget(),
                            ],
                          ),
                        ),
                      if (postersList.isNotEmpty)
                        SliverPadding(
                          padding: EdgeInsets.only(
                              top: 10,
                              left: MediaQuery.of(context).padding.left,
                              right: MediaQuery.of(context).padding.right),
                          sliver: LibraryViews(
                            key: uniqueKey,
                            items: postersList,
                            firstItemFocusNode: resultsFocusNode,
                            groupByType: librarySearchResults.filters.groupBy,
                            onPressed: (item) {
                              showBottomSheetPill(
                                context: context,
                                item: item,
                                content: (context, scrollController) {
                                  final actions = item.generateActions(context, ref);
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ItemActionButton(
                                        label: Text("View Details"),
                                        icon: const Icon(IconsaxPlusLinear.info_circle),
                                        action: () {
                                          Navigator.of(context).pop();
                                          item.navigateTo(context, ref: ref);
                                        },
                                      ).toListItem(context, useIcons: true),
                                      const Divider(),
                                      ...actions.listTileItems(context, useIcons: true),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        )
                      else
                        SliverFillRemaining(
                          child: Center(
                            child: Text(context.localized.noItemsToShow),
                          ),
                        ),
                      SliverPadding(padding: EdgeInsets.only(bottom: MediaQuery.sizeOf(context).height * 0.20))
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LibrarySearchBottomBar extends ConsumerWidget {
  final Key uniqueKey;
  final ScrollController scrollController;
  final LibrarySearchNotifier libraryProvider;
  final List<ItemBaseModel> postersList;
  final GlobalKey<RefreshIndicatorState> refreshKey;
  final bool isDPadBar;
  const _LibrarySearchBottomBar({
    required this.uniqueKey,
    required this.scrollController,
    required this.libraryProvider,
    required this.postersList,
    required this.refreshKey,
    this.isDPadBar = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final librarySearchResults = ref.watch(librarySearchProvider(uniqueKey));
    final actions = [
      ItemActionButton(
        action: () async {
          await libraryProvider.setSelectedAsFavorite(true);
          if (context.mounted) context.refreshData();
        },
        label: Text(context.localized.addAsFavorite),
        icon: const Icon(IconsaxPlusLinear.heart_add),
      ),
      ItemActionButton(
        action: () async {
          await libraryProvider.setSelectedAsFavorite(false);
          if (context.mounted) context.refreshData();
        },
        label: Text(context.localized.removeAsFavorite),
        icon: const Icon(IconsaxPlusLinear.heart_remove),
      ),
      ItemActionButton(
        action: () async {
          await libraryProvider.setSelectedAsWatched(true);
          if (context.mounted) context.refreshData();
        },
        label: Text(context.localized.markAsWatched),
        icon: const Icon(IconsaxPlusLinear.eye),
      ),
      ItemActionButton(
        action: () async {
          await libraryProvider.setSelectedAsWatched(false);
          if (context.mounted) context.refreshData();
        },
        label: Text(context.localized.markAsUnwatched),
        icon: const Icon(IconsaxPlusLinear.eye_slash),
      ),
      if (librarySearchResults.nestedCurrentItem is BoxSetModel)
        ItemActionButton(
            action: () async {
              await libraryProvider.removeSelectedFromCollection();
              if (context.mounted) context.refreshData();
            },
            label: Text(context.localized.removeFromCollection),
            icon: Container(
              decoration:
                  BoxDecoration(color: Theme.of(context).colorScheme.onPrimary, borderRadius: BorderRadius.circular(6)),
              child: const Padding(
                padding: EdgeInsets.all(3.0),
                child: Icon(IconsaxPlusLinear.save_remove, size: 20),
              ),
            )),
      if (librarySearchResults.nestedCurrentItem is PlaylistModel)
        ItemActionButton(
          action: () async {
            await libraryProvider.removeSelectedFromPlaylist();
            if (context.mounted) context.refreshData();
          },
          label: Text(context.localized.removeFromPlaylist),
          icon: const Icon(IconsaxPlusLinear.save_remove),
        ),
      ItemActionButton(
        action: () async {
          await addItemToCollection(context, librarySearchResults.selectedPosters);
          if (context.mounted) context.refreshData();
        },
        label: Text(context.localized.addToCollection),
        icon: const Icon(
          IconsaxPlusLinear.save_add,
          size: 20,
        ),
      ),
      ItemActionButton(
        action: () async {
          await addItemToPlaylist(context, librarySearchResults.selectedPosters);
          if (context.mounted) context.refreshData();
        },
        label: Text(context.localized.addToPlaylist),
        icon: const Icon(IconsaxPlusLinear.save_add),
      ),
    ];

    final paddingOf = MediaQuery.paddingOf(context);
    Widget content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          FocusTraversalGroup(
            policy: _BoundedRowTraversalPolicy(),
            child: Row(
              spacing: 6,
              children: [
                if (!isDPadBar)
                  ScrollStatePosition(
                    controller: scrollController,
                    positionBuilder: (state) => AnimatedFadeSize(
                      child: state != ScrollState.top
                          ? Tooltip(
                              message: context.localized.scrollToTop,
                              child: IconButton.filled(
                                onPressed: () => scrollController.animateTo(0,
                                    duration: const Duration(milliseconds: 500), curve: Curves.easeInOutCubic),
                                icon: const Icon(
                                  IconsaxPlusLinear.arrow_up,
                                ),
                              ),
                            )
                          : const SizedBox(),
                    ),
                  ),
                if (!librarySearchResults.selecteMode) ...{
                  IconButton(
                    tooltip: context.localized.sortBy,
                    onPressed: () async {
                      final newOptions = await openSortByDialogue(
                        context,
                        libraryProvider: libraryProvider,
                        uniqueKey: uniqueKey,
                        options: (librarySearchResults.filters.sortingOption, librarySearchResults.filters.sortOrder),
                      );
                      if (newOptions != null) {
                        if (newOptions.$1 != null) {
                          libraryProvider.setSortBy(newOptions.$1!);
                        }
                        if (newOptions.$2 != null) {
                          libraryProvider.setSortOrder(newOptions.$2!);
                        }
                      }
                    },
                    icon: const Icon(IconsaxPlusLinear.sort),
                  ),
                  if (librarySearchResults.hasActiveFilters) ...{
                    IconButton(
                      tooltip: context.localized.disableFilters,
                      onPressed: disableFilters(librarySearchResults, libraryProvider),
                      icon: const Icon(IconsaxPlusLinear.filter_remove),
                    ),
                  },
                },
                IconButton(
                  onPressed: () => libraryProvider.toggleSelectMode(),
                  color: librarySearchResults.selecteMode ? Theme.of(context).colorScheme.primary : null,
                  icon: const Icon(IconsaxPlusLinear.category_2),
                ),
                AnimatedFadeSize(
                  child: librarySearchResults.selecteMode
                      ? Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(16)),
                          child: Row(
                            spacing: 6,
                            children: [
                              Tooltip(
                                message: context.localized.selectAll,
                                child: IconButton(
                                  onPressed: () => libraryProvider.selectAll(true),
                                  icon: const Icon(IconsaxPlusLinear.box_add),
                                ),
                              ),
                              Tooltip(
                                message: context.localized.clearSelection,
                                child: IconButton(
                                  onPressed: () => libraryProvider.selectAll(false),
                                  icon: const Icon(IconsaxPlusLinear.box_remove),
                                ),
                              ),
                              if (librarySearchResults.selectedPosters.isNotEmpty) ...{
                                if (AdaptiveLayout.of(context).isDesktop)
                                  PopupMenuButton(
                                    itemBuilder: (context) => actions.popupMenuItems(useIcons: true),
                                  )
                                else
                                  IconButton(
                                      onPressed: () {
                                        showBottomSheetPill(
                                          context: context,
                                          content: (context, scrollController) => ListView(
                                            shrinkWrap: true,
                                            controller: scrollController,
                                            children: actions.listTileItems(context, useIcons: true),
                                          ),
                                        );
                                      },
                                      icon: const Icon(IconsaxPlusLinear.more))
                              },
                            ],
                          ),
                        )
                      : const SizedBox(),
                ),
                if (!isDPadBar) const Spacer(),
              if (librarySearchResults.activePosters.isNotEmpty)
                IconButton(
                  tooltip: context.localized.random,
                  onPressed: () => libraryProvider.openRandom(context),
                  icon: const Icon(
                    IconsaxPlusBold.slider_vertical,
                  ),
                ),
              if (librarySearchResults.activePosters.isNotEmpty)
                IconButton(
                  tooltip: context.localized.shuffleVideos,
                  onPressed: () async {
                    if (librarySearchResults.showGalleryButtons && !librarySearchResults.showPlayButtons) {
                      libraryProvider.viewGallery(context, shuffle: true);
                      return;
                    } else if (!librarySearchResults.showGalleryButtons && librarySearchResults.showPlayButtons) {
                      libraryProvider.playLibraryItems(context, ref, shuffle: true);
                      return;
                    }

                    await showLibraryPlayOptions(
                      context,
                      context.localized.libraryShuffleAndPlayItems,
                      playVideos: librarySearchResults.showPlayButtons
                          ? () => libraryProvider.playLibraryItems(context, ref, shuffle: true)
                          : null,
                      viewGallery: librarySearchResults.showGalleryButtons
                          ? () => libraryProvider.viewGallery(context, shuffle: true)
                          : null,
                    );
                  },
                  icon: const Icon(IconsaxPlusLinear.shuffle),
                ),
            ],
          ),
        ),
        ],
      ),
    );

    if (isDPadBar) {
      return content;
    }
    return Padding(
      padding: EdgeInsets.only(left: paddingOf.left, right: paddingOf.right),
      child: NestedBottomAppBar(
        child: content,
      ),
    );
  }

  void Function()? disableFilters(LibrarySearchModel librarySearchResults, LibrarySearchNotifier libraryProvider) {
    return () {
      libraryProvider.clearAllFilters();
      refreshKey.currentState?.show();
    };
  }
}

// Custom traversal policy that stops at row boundaries
class _BoundedRowTraversalPolicy extends ReadingOrderTraversalPolicy {
  @override
  bool inDirection(FocusNode currentNode, TraversalDirection direction) {
    if (direction == TraversalDirection.left || direction == TraversalDirection.right) {
      final parent = currentNode.parent;
      if (parent == null) return super.inDirection(currentNode, direction);
      
      final nodes = parent.descendants.where((n) => n.canRequestFocus && n.context != null).toList()
        ..sort((a, b) => a.rect.left.compareTo(b.rect.left));
      
      final currentIndex = nodes.indexOf(currentNode);
      if (currentIndex == -1) return super.inDirection(currentNode, direction);
      
      if (direction == TraversalDirection.left) {
        if (currentIndex > 0) {
          nodes[currentIndex - 1].requestFocus();
          return true;
        }
        return true; // Stay at first item
      } else {
        if (currentIndex < nodes.length - 1) {
          nodes[currentIndex + 1].requestFocus();
          return true;
        }
        return true; // Stay at last item
      }
    }
    return super.inDirection(currentNode, direction);
  }
}
