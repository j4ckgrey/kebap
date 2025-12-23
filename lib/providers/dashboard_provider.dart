import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kebap/jellyfin/jellyfin_open_api.enums.swagger.dart';
import 'package:kebap/models/home_model.dart';
import 'package:kebap/models/views_model.dart';
import 'package:kebap/models/item_base_model.dart';
import 'package:kebap/providers/api_provider.dart';
import 'package:kebap/providers/service_provider.dart';
import 'package:kebap/providers/settings/client_settings_provider.dart';
import 'package:kebap/providers/views_provider.dart';
import 'package:kebap/providers/connectivity_provider.dart';
import 'package:kebap/providers/sync_provider.dart';
import 'package:kebap/models/syncing/sync_settings_model.dart';
import 'package:kebap/util/list_extensions.dart';

final dashboardProvider = StateNotifierProvider<DashboardNotifier, HomeModel>((ref) {
  return DashboardNotifier(ref);
});

class DashboardNotifier extends StateNotifier<HomeModel> {
  DashboardNotifier(this.ref) : super(HomeModel()) {
    // Listen to views provider to update resume items when views become available
    ref.listen<ViewsModel>(viewsProvider, (previous, next) {
      final previousTypes = previous?.views.map((e) => e.collectionType).toSet();
      final nextTypes = next.views.map((e) => e.collectionType).toSet();
      
      // Only refetch if collection types change (e.g. initial load or new library)
      // This prevents loop if fetchNextUpAndResume doesn't modify views (which it shouldn't)
      if (!listEquals(previousTypes?.toList(), nextTypes.toList())) {
        debugPrint('[DashboardNotifier] View types changed, fetching dashboard content');
        fetchNextUpAndResume();
      }
    });
  }

  final Ref ref;

  late final JellyService api = ref.read(jellyApiProvider);

  Future<void> fetchNextUpAndResume() async {
    if (state.loading) return;
    state = state.copyWith(loading: true);

    final connectionState = ref.read(connectivityStatusProvider);
    
    if (connectionState == ConnectionState.offline) {
      // Wait for sync provider to finish loading items from database
      var syncState = ref.read(syncProvider);
      
      if (syncState.items.isEmpty && syncState.isLoading) {
        // Wait up to 2 seconds for items to load
        for (int i = 0; i < 8; i++) {
          await Future.delayed(const Duration(milliseconds: 250));
          syncState = ref.read(syncProvider);
          if (!syncState.isLoading || syncState.items.isNotEmpty) break;
        }
      }
      
      final syncedItems = syncState.items;
      final allItems = syncedItems.map((e) => e.itemModel).nonNulls.toList();

      final videos = allItems.where((e) {
        final type = e.type;
        return type == KebapItemType.movie ||
            type == KebapItemType.episode ||
            type == KebapItemType.video ||
            type == KebapItemType.musicVideo;
      }).toList();

      final audio = allItems.where((e) {
        final type = e.type;
        return type == KebapItemType.audio || type == KebapItemType.musicAlbum;
      }).toList();

      final books = allItems.where((e) => e.type == KebapItemType.book).toList();

      state = state.copyWith(
        resumeVideo: videos,
        resumeAudio: audio,
        resumeBooks: books,
        nextUp: [],
        loading: false,
      );
      return;
    }

    final viewTypes =
        ref.read(viewsProvider.select((value) => value.views)).map((e) => e.collectionType).toSet().toList();

    final limit = 16;

    final imagesToFetch = {
      ImageType.logo,
      ImageType.primary,
      ImageType.backdrop,
      ImageType.banner,
    }.toList();

    final fieldsToFetch = [
      ItemFields.parentid,
      ItemFields.mediastreams,
      ItemFields.mediasources,
      ItemFields.candelete,
      ItemFields.candownload,
      ItemFields.primaryimageaspectratio,
      ItemFields.overview,
      ItemFields.genres,
    ];

    try {
      if (viewTypes.containsAny([CollectionType.movies, CollectionType.tvshows])) {
        try {
          final resumeVideoResponse = await api.usersUserIdItemsResumeGet(
            enableImageTypes: imagesToFetch,
            fields: fieldsToFetch,
            mediaTypes: [MediaType.video],
            enableTotalRecordCount: false,
            limit: limit,
          );

          // Only update state if we got valid data
          final items = resumeVideoResponse.body?.items?.map((e) => ItemBaseModel.fromBaseDto(e, ref)).toList();
          if (items != null) {
            state = state.copyWith(resumeVideo: items);
          }
        } catch (e) {
          debugPrint('[DashboardNotifier] Error fetching resume video: $e');
          // Keep existing resumeVideo data
        }
      }

      if (viewTypes.contains(CollectionType.music)) {
        try {
          final resumeAudioResponse = await api.usersUserIdItemsResumeGet(
            enableImageTypes: imagesToFetch,
            fields: fieldsToFetch,
            mediaTypes: [MediaType.audio],
            enableTotalRecordCount: false,
            limit: limit,
          );

          final items = resumeAudioResponse.body?.items?.map((e) => ItemBaseModel.fromBaseDto(e, ref)).toList();
          if (items != null) {
            state = state.copyWith(resumeAudio: items);
          }
        } catch (e) {
          debugPrint('[DashboardNotifier] Error fetching resume audio: $e');
          // Keep existing resumeAudio data
        }
      }

      if (viewTypes.contains(CollectionType.books)) {
        try {
          final resumeBookResponse = await api.usersUserIdItemsResumeGet(
            enableImageTypes: imagesToFetch,
            fields: fieldsToFetch,
            mediaTypes: [MediaType.book],
            enableTotalRecordCount: false,
            limit: limit,
          );

          final items = resumeBookResponse.body?.items?.map((e) => ItemBaseModel.fromBaseDto(e, ref)).toList();
          if (items != null) {
            state = state.copyWith(resumeBooks: items);
          }
        } catch (e) {
          debugPrint('[DashboardNotifier] Error fetching resume books: $e');
          // Keep existing resumeBooks data
        }
      }

      try {
        final nextResponse = await api.showsNextUpGet(
          nextUpDateCutoff: DateTime.now().subtract(
              ref.read(clientSettingsProvider.select((value) => value.nextUpDateCutoff ?? const Duration(days: 28)))),
          fields: fieldsToFetch,
          enableImageTypes: imagesToFetch,
        );

        final next = nextResponse.body?.items
                ?.map(
                  (e) => ItemBaseModel.fromBaseDto(e, ref),
                )
                .toList() ??
            [];

        state = state.copyWith(nextUp: next, loading: false);
      } catch (e) {
        debugPrint('[DashboardNotifier] Error fetching next up: $e');
        // Keep existing nextUp data, just clear loading
        state = state.copyWith(loading: false);
      }
    } catch (e) {
      debugPrint('[DashboardNotifier] Error in fetchNextUpAndResume: $e');
      // Keep existing state, just clear loading flag
      state = state.copyWith(loading: false);
    }
  }


  void clear() {
    state = HomeModel();
  }
}
