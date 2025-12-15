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
import 'package:kebap/screens/shared/default_alert_dialog.dart';
import 'package:kebap/screens/shared/kebap_snackbar.dart';
import 'package:kebap/screens/shared/media/single_row_view.dart';
import 'package:kebap/screens/shared/nested_scaffold.dart';
import 'package:kebap/util/adaptive_layout/adaptive_layout.dart';
import 'package:kebap/util/localization_helper.dart';
import 'package:kebap/widgets/navigation_scaffold/components/background_image.dart';

@RoutePage()
class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> with AutoRouteAwareStateMixin<DashboardScreen> {
  final ValueNotifier<ItemBaseModel?> selectedPoster = ValueNotifier(null);
  final FocusScopeNode _focusScopeNode = FocusScopeNode();
  FocusNode? _lastFocusedNode;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Trigger initial fetch - providers will handle connectivity state
      ref.read(dashboardProvider.notifier).fetchNextUpAndResume();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didPushNext() {
    super.didPushNext();
    debugPrint('[FocusRestore] didPushNext - saving focus');
    // A route is about to be pushed on top - save the current focus
    _saveCurrentFocus();
  }

  @override
  void didPopNext() {
    super.didPopNext();
    debugPrint('[FocusRestore] didPopNext - restoring focus');
    // Returning from a pushed route - restore focus
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _lastFocusedNode != null && _lastFocusedNode!.canRequestFocus) {
        debugPrint('[FocusRestore] Restoring focus to saved node');
        _lastFocusedNode!.requestFocus();
      } else if (mounted) {
        debugPrint('[FocusRestore] No saved node, falling back to scope');
        // Fallback: focus the scope itself which will find a focusable child
        _focusScopeNode.requestFocus();
      }
    });
  }

  void _saveCurrentFocus() {
    // Save the currently focused node before navigating away
    final focusManager = FocusManager.instance;
    debugPrint('[FocusRestore] _saveCurrentFocus - primaryFocus: ${focusManager.primaryFocus?.debugLabel}, hasFocus: ${_focusScopeNode.hasFocus}');
    if (focusManager.primaryFocus != null && _focusScopeNode.hasFocus) {
      _lastFocusedNode = focusManager.primaryFocus;
      debugPrint('[FocusRestore] Saved focus node: ${_lastFocusedNode?.debugLabel}');
    } else {
      debugPrint('[FocusRestore] Could not save focus - scope does not have focus');
    }
  }

  @override
  void dispose() {
    selectedPoster.dispose();
    _focusScopeNode.dispose();
    super.dispose();
  }

  Future<void> _refreshHome() async {
    await ref.read(dashboardProvider.notifier).fetchNextUpAndResume();
  }

  @override
  Widget build(BuildContext context) {
    final padding = AdaptiveLayout.adaptivePadding(context);

    final dashboardData = ref.watch(dashboardProvider);
    final views = ref.watch(viewsProvider);
    final homeSettings = ref.watch(homeSettingsProvider);
    final clientSettings = ref.watch(clientSettingsProvider);
    final resumeVideo = dashboardData.resumeVideo;
    final resumeAudio = dashboardData.resumeAudio;
    final resumeBooks = dashboardData.resumeBooks;

    final allResume = [...resumeVideo, ...resumeAudio, ...resumeBooks].toList();

    return MediaQuery.removeViewInsets(
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
          body: FocusScope(
            node: _focusScopeNode,
            autofocus: true,
            child: Builder(
              builder: (context) {
                  final isOffline = ref.watch(connectivityStatusProvider) == ConnectionState.offline;

                  final offlineMovies = allResume.where((e) => e.type == KebapItemType.movie || e.type == KebapItemType.video).toList();
                  final offlineShows = allResume.where((e) => e.type == KebapItemType.episode || e.type == KebapItemType.series).toList();

                  final rows = [
                    // Libraries Row (Top of Dashboard)
                    if (views.dashboardViews.isNotEmpty && clientSettings.libraryLocation == LibraryLocation.dashboard)
                      RowData(
                        label: context.localized.library(2),
                        aspectRatio: 1.2, // Much wider
                        useStandardHeight: true,
                        // onItemTap not provided -> Defaults to Focus behavior (updates banner)
                        onItemOpen: (item) => context.router.push(LibrarySearchRoute(viewModelId: item.id)),
                        posters: views.dashboardViews.map((view) => ItemBaseModel(
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
                      // Fallback or other types (like music/books) if needed, or if movies/shows are empty but others exist?
                      // User asked for 2 carousels specifically.
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
                    ...views.views
                        .where((element) => element.recentlyAdded.isNotEmpty)
                        .map(
                          (view) => RowData(
                            label: context.localized.dashboardRecentlyAdded(view.name),
                            posters: view.recentlyAdded,
                            aspectRatio: view.collectionType.aspectRatio,
                            onLabelClick: () => context.router.push(
                              LibrarySearchRoute(
                                viewModelId: view.id,
                                types: switch (view.collectionType) {
                                  CollectionType.tvshows => {
                                      KebapItemType.episode: true,
                                    },
                                  _ => {},
                                },
                                sortingOptions: switch (view.collectionType) {
                                  CollectionType.books ||
                                  CollectionType.boxsets ||
                                  CollectionType.folders ||
                                  CollectionType.music =>
                                    SortingOptions.dateLastContentAdded,
                                  _ => SortingOptions.dateAdded,
                                },
                                sortOrder: SortingOrder.descending,
                                recursive: true,
                              ),
                            ),
                          ),
                        ),
                  ]
                ];
                return SingleRowView(
                  contentPadding: padding,
                  rows: rows,
                  onRefresh: _refreshHome,
                );
              },
            ),
          ),
        ),
    );
  }
}
