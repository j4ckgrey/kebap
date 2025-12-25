import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide ConnectionState;
import 'package:flutter/services.dart';

import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';

import 'package:kebap/jellyfin/jellyfin_open_api.enums.swagger.dart';
import 'package:kebap/jellyfin/jellyfin_open_api.swagger.dart';
import 'package:kebap/models/collection_types.dart';
import 'package:kebap/models/items/overview_model.dart';
import 'package:kebap/models/item_base_model.dart';
import 'package:kebap/models/items/item_shared_models.dart';
import 'package:kebap/models/library_search/library_search_options.dart';
import 'package:kebap/models/settings/home_settings_model.dart';
import 'package:kebap/providers/baklava_requests_provider.dart';
import 'package:kebap/providers/connectivity_provider.dart';
import 'package:kebap/providers/dashboard_provider.dart';
import 'package:kebap/providers/settings/home_settings_provider.dart';
import 'package:kebap/providers/settings/client_settings_provider.dart';
import 'package:kebap/models/settings/client_settings_model.dart';
import 'package:kebap/providers/user_provider.dart';
import 'package:kebap/providers/views_provider.dart';
import 'package:kebap/routes/auto_router.gr.dart';
import 'package:kebap/screens/dashboard/dashboard_single_row_view.dart';
import 'package:kebap/screens/shared/default_alert_dialog.dart';
import 'package:kebap/screens/shared/kebap_snackbar.dart';
import 'package:kebap/screens/shared/media/single_row_view.dart';
import 'package:kebap/screens/shared/nested_scaffold.dart';
import 'package:kebap/util/adaptive_layout/adaptive_layout.dart';
import 'package:kebap/util/localization_helper.dart';
import 'package:kebap/widgets/navigation_scaffold/components/background_image.dart';
import 'package:kebap/widgets/shared/pull_to_refresh.dart';

@RoutePage()
class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> with AutomaticKeepAliveClientMixin, AutoRouteAwareStateMixin<DashboardScreen> {
  final ValueNotifier<ItemBaseModel?> selectedPoster = ValueNotifier(null);
  final FocusScopeNode _focusScopeNode = FocusScopeNode();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Trigger initial fetch - providers will handle connectivity state
      ref.read(dashboardProvider.notifier).fetchNextUpAndResume();
    });
  }

  // Flag to skip spurious refresh triggers
  bool _skipRefresh = false;

  // Track visibility for focus restoration
  bool _isVisible = true;

  @override
  void didPushNext() {
    setState(() => _isVisible = false);
    debugPrint('[DashboardScreen] didPushNext: visible=$_isVisible');
  }

  @override
  void didPopNext() {
    setState(() => _isVisible = true);
    debugPrint('[DashboardScreen] didPopNext: visible=$_isVisible');
    
    // Restore focus when we become the top route again
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        debugPrint('[DashboardScreen] Restoring focus on returning to dashboard');
        _focusScopeNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    selectedPoster.dispose();
    _focusScopeNode.dispose();
    super.dispose();
  }

  Future<void> _refreshHome() async {
    // Skip if this is a spurious trigger during route return
    if (_skipRefresh) {
      debugPrint('[DashboardScreen] _refreshHome skipped (route return window)');
      return;
    }
    await ref.read(dashboardProvider.notifier).fetchNextUpAndResume();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Prepare KeepAlive
    
    // Check top route to determine visibility
    // If Settings (child route) is active, topRoute will be SettingsRoute
    // final topRouteName = context.router.topRoute.name; // Removed: Logic moved to AutoRouteAware callbacks
    // final isVisible = topRouteName == DashboardRoute.name; // Removed

    // Focus restoration logic moved to didPopNext

    final padding = AdaptiveLayout.adaptivePadding(context);

    final dashboardData = ref.watch(dashboardProvider);
    final dashboardViews = ref.watch(viewsProvider.select((v) => v.dashboardViews));
    final viewsList = ref.watch(viewsProvider.select((v) => v.views));
    final viewsLoading = ref.watch(viewsProvider.select((v) => v.loading));
    final homeSettings = ref.watch(homeSettingsProvider);
    final libraryLocation = ref.watch(clientSettingsProvider.select((s) => s.libraryLocation));
    final isOffline = ref.watch(connectivityStatusProvider.select((s) => s == ConnectionState.offline));
    
    final resumeVideo = dashboardData.resumeVideo;
    final resumeAudio = dashboardData.resumeAudio;
    final resumeBooks = dashboardData.resumeBooks;

    final allResume = [...resumeVideo, ...resumeAudio, ...resumeBooks].toList();

    return ExcludeFocus(
      excluding: !_isVisible,
      child: MediaQuery.removeViewInsets(
        context: context,
        child: NestedScaffold(
        background: ValueListenableBuilder<ItemBaseModel?>(
          valueListenable: selectedPoster,
          builder: (_, value, __) {
            return BackgroundImage(
              images: (value != null
                      ? [value]
                      : [
                          ...dashboardData.nextUp,
                          ...allResume,
                        ])
                    .map((e) => e.images)
                    .nonNulls
                    .toList(),
              );
            },
          ),
          body: PullToRefresh(
            refreshOnStart: false,
            onRefresh: _refreshHome,
            child: FocusScope(
              node: _focusScopeNode,
              // Only autofocus if we are the current route to prevent stealing focus 
              // from other screens (like Settings) during background rebuilds
              autofocus: _isVisible,
              child: Builder(
              builder: (context) {
                  final offlineMovies = allResume.where((e) => e.type == KebapItemType.movie || e.type == KebapItemType.video).toList();
                  final offlineShows = allResume.where((e) => e.type == KebapItemType.episode || e.type == KebapItemType.series).toList();

                final showLibraryContents = ref.watch(clientSettingsProvider.select((s) => s.dashboardShowLibraryContents));

                /* ... (existing logic for offlineMovies, offlineShows, rows) ... */
                
                final isSingleRow = showLibraryContents && ref.watch(clientSettingsProvider.select((s) => s.dashboardLayoutMode)) == DashboardLayoutMode.singleRow;
                
                final rows = [
                    // ... (existing static rows) ...
                    // Libraries Row (Top of Dashboard)
                    if (dashboardViews.isNotEmpty && libraryLocation == LibraryLocation.dashboard && !isSingleRow)
                      RowData(
                        label: context.localized.library(2),
                        aspectRatio: 2.5, // Wider aspect ratio for chips
                        useStandardHeight: true,
                        textOverlayMode: true, // Enable overlay mode
                        onItemOpen: (item) => context.router.push(LibrarySearchRoute(viewModelId: item.id)),
                        posters: dashboardViews.map((view) => ItemBaseModel(
                          name: view.name,
                          id: view.id,
                          overview: OverviewModel(), 
                          parentId: null,
                          playlistId: null,
                          images: view.imageData,
                          childCount: null,
                          primaryRatio: null,
                          userData: UserData(),
                          canDownload: false,
                          canDelete: false,
                          jellyType: view.dtoKind, 
                        )).toList(),
                      ),

                    if (isOffline) ...[
                      if (offlineMovies.isNotEmpty)
                        RowData(
                          label: context.localized.offlineMovies,
                          posters: offlineMovies,
                        ),
                      if (offlineShows.isNotEmpty)
                        RowData(
                          label: context.localized.offlineShows,
                          posters: offlineShows,
                        ),
                      if (allResume.where((e) => !offlineMovies.contains(e) && !offlineShows.contains(e)).isNotEmpty)
                         RowData(
                          label: context.localized.downloads,
                          posters: allResume.where((e) => !offlineMovies.contains(e) && !offlineShows.contains(e)).toList(),
                        ),
                    ] else ...[
                    if (resumeVideo.isNotEmpty &&
                        (homeSettings.nextUp == HomeNextUp.cont || homeSettings.nextUp == HomeNextUp.separate))
                      RowData(
                        label: context.localized.dashboardContinueWatching,
                        posters: resumeVideo,
                      ),
                    if (resumeAudio.isNotEmpty &&
                        (homeSettings.nextUp == HomeNextUp.cont || homeSettings.nextUp == HomeNextUp.separate))
                      RowData(
                        label: context.localized.dashboardContinueListening,
                        posters: resumeAudio,
                      ),
                    if (resumeBooks.isNotEmpty &&
                        (homeSettings.nextUp == HomeNextUp.cont || homeSettings.nextUp == HomeNextUp.separate))
                      RowData(
                        label: context.localized.dashboardContinueReading,
                        posters: resumeBooks,
                      ),
                    if (dashboardData.nextUp.isNotEmpty &&
                        (homeSettings.nextUp == HomeNextUp.nextUp || homeSettings.nextUp == HomeNextUp.separate))
                      RowData(
                        label: context.localized.nextUp,
                        posters: dashboardData.nextUp,
                      ),
                    if ([...allResume, ...dashboardData.nextUp].isNotEmpty &&
                        homeSettings.nextUp == HomeNextUp.combined)
                      RowData(
                        label: context.localized.dashboardContinue,
                        posters: [...allResume, ...dashboardData.nextUp],
                      ),
                    ...viewsList
                        .where((element) => element.recentlyAdded?.isNotEmpty == true || showLibraryContents)
                        .map(
                          (view) => RowData(
                            label: showLibraryContents ? view.name : context.localized.dashboardRecentlyAdded(view.name),
                            id: view.id,
                            image: view.imageData,
                            requiresLoading: view.recentlyAdded == null,
                            posters: view.recentlyAdded ?? [],
                            aspectRatio: view.collectionType.aspectRatio,
                            onLabelClick: () => context.router.push(
                              LibrarySearchRoute(
                                viewModelId: view.id,
                                types: switch (view.collectionType) {
                                  CollectionType.tvshows => {
                                      KebapItemType.episode: true,
                                    },
                                  _ => null,
                                },
                                sortingOptions: showLibraryContents 
                                    ? SortingOptions.sortName
                                    : switch (view.collectionType) {
                                  CollectionType.books ||
                                  CollectionType.music =>
                                    SortingOptions.dateLastContentAdded,
                                  _ => SortingOptions.dateAdded,
                                },
                                sortOrder: showLibraryContents ? SortingOrder.ascending : SortingOrder.descending,
                                recursive: true,
                              ),
                            ),
                          ),
                        ),
                  ]
                ];
                
                // Show loading indicator when data is being fetched and rows are empty
                // This prevents black screen when Jellyfin is doing media scan
                // Show loading indicator when data is being fetched
                // This prevents content popping in (layout shift) especially for Next Up/Resume
                if (viewsLoading || dashboardData.loading) {
                  return const Center(child: CircularProgressIndicator.adaptive());
                }
                
                if (isSingleRow) {
                  return DashboardSingleRowView(
                    rows: rows,
                    contentPadding: padding,
                    onRefresh: _refreshHome,
                  );
                }

                return SingleRowView(
                  contentPadding: padding,
                  rows: rows,
                  onRefresh: _refreshHome,
                );
              },
            ),
          ),
        ),
      ),
      ),
    );
  }
}
