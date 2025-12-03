import 'dart:async';

import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kebap/jellyfin/jellyfin_open_api.enums.swagger.dart';
import 'package:kebap/jellyfin/jellyfin_open_api.swagger.dart';
import 'package:kebap/models/collection_types.dart';
import 'package:kebap/models/item_base_model.dart';
import 'package:kebap/models/library_search/library_search_options.dart';
import 'package:kebap/models/settings/home_settings_model.dart';
import 'package:kebap/providers/baklava_requests_provider.dart';
import 'package:kebap/providers/dashboard_provider.dart';
import 'package:kebap/providers/settings/home_settings_provider.dart';
import 'package:kebap/providers/user_provider.dart';
import 'package:kebap/providers/views_provider.dart';
import 'package:kebap/routes/auto_router.gr.dart';
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
  late final Timer _timer;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  final FocusScopeNode _focusScopeNode = FocusScopeNode();

  final textController = TextEditingController();

  final selectedPoster = ValueNotifier<ItemBaseModel?>(null);

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 120), (timer) {
      _refreshIndicatorKey.currentState?.show();
    });
    
    // Trigger initial fetch for Continue Watching and Next Up
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshHome();
      _focusScopeNode.requestFocus();
    });
  }

  @override
  void didPopNext() {
    _refreshHome();
    _focusScopeNode.requestFocus();
  }

  @override
  void dispose() {
    _timer.cancel();
    _focusScopeNode.dispose();
    super.dispose();
  }

  Future<void> _refreshHome() async {
    if (mounted) {
      await ref.read(userProvider.notifier).updateInformation();
      await ref.read(viewsProvider.notifier).fetchViews();
      await ref.read(viewsProvider.notifier).fetchViews();
      await ref.read(dashboardProvider.notifier).fetchNextUpAndResume();
      // Refresh requests
      ref.read(baklavaRequestsProvider.notifier).loadRequests(notify: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final padding = AdaptiveLayout.adaptivePadding(context);

    final dashboardData = ref.watch(dashboardProvider);
    final views = ref.watch(viewsProvider);
    final homeSettings = ref.watch(homeSettingsProvider);
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
              final rows = [
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
                if ([...allResume, ...dashboardData.nextUp].isNotEmpty && homeSettings.nextUp == HomeNextUp.combined)
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
