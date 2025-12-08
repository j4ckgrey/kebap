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
    // Listen to Sync changes: when offline, if local DB loads, update UI
    ref.listen<SyncSettingsModel>(syncProvider, (previous, next) {
      if (ref.read(connectivityStatusProvider) == ConnectionState.offline) {
        // If items changed (e.g. initial load finished), refresh dashboard
        if (previous?.items != next.items) {
           fetchNextUpAndResume();
        }
      }
    });

    // Listen to Connection changes: re-fetch data on any connectivity change
    ref.listen<ConnectionState>(connectivityStatusProvider, (previous, next) {
      if (previous != next) {
         fetchNextUpAndResume();
      }
    });

    ref.listen<ViewsModel>(viewsProvider, (previous, next) {
      if (previous?.views != next.views) {
        debugPrint('[DashboardProvider] Views updated, re-fetching dashboard');
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
    print('[OFFLINE_DEBUG] fetchNextUpAndResume - connectionState: $connectionState');
    
    if (connectionState == ConnectionState.offline) {
      print('[OFFLINE_DEBUG] We are OFFLINE - loading sync items');
      // Wait for sync provider to finish loading items from database
      var syncState = ref.read(syncProvider);
      print('[OFFLINE_DEBUG] Initial syncState - items: ${syncState.items.length}, isLoading: ${syncState.isLoading}');
      
      if (syncState.items.isEmpty && syncState.isLoading) {
        print('[OFFLINE_DEBUG] Waiting for sync items to load...');
        // Wait up to 2 seconds for items to load
        for (int i = 0; i < 8; i++) {
          await Future.delayed(const Duration(milliseconds: 250));
          syncState = ref.read(syncProvider);
          print('[OFFLINE_DEBUG] Retry $i - items: ${syncState.items.length}, isLoading: ${syncState.isLoading}');
          if (!syncState.isLoading || syncState.items.isNotEmpty) break;
        }
      }
      
      final syncedItems = syncState.items;
      final allItems = syncedItems.map((e) => e.itemModel).nonNulls.toList();
      print('[OFFLINE_DEBUG] Final allItems count: ${allItems.length}');

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

    if (viewTypes.containsAny([CollectionType.movies, CollectionType.tvshows])) {
      final resumeVideoResponse = await api.usersUserIdItemsResumeGet(
        enableImageTypes: imagesToFetch,
        fields: fieldsToFetch,
        mediaTypes: [MediaType.video],
        enableTotalRecordCount: false,
        limit: limit,
      );

      final items = resumeVideoResponse.body?.items?.map((e) => ItemBaseModel.fromBaseDto(e, ref)).toList();

      state = state.copyWith(
        resumeVideo: items,
      );
    }

    if (viewTypes.contains(CollectionType.music)) {
      final resumeAudioResponse = await api.usersUserIdItemsResumeGet(
        enableImageTypes: imagesToFetch,
        fields: fieldsToFetch,
        mediaTypes: [MediaType.audio],
        enableTotalRecordCount: false,
        limit: limit,
      );

      state = state.copyWith(
        resumeAudio: resumeAudioResponse.body?.items?.map((e) => ItemBaseModel.fromBaseDto(e, ref)).toList(),
      );
    }

    if (viewTypes.contains(CollectionType.books)) {
      final resumeBookResponse = await api.usersUserIdItemsResumeGet(
        enableImageTypes: imagesToFetch,
        fields: fieldsToFetch,
        mediaTypes: [MediaType.book],
        enableTotalRecordCount: false,
        limit: limit,
      );

      state = state.copyWith(
        resumeBooks: resumeBookResponse.body?.items?.map((e) => ItemBaseModel.fromBaseDto(e, ref)).toList(),
      );
    }

    final nextResponse = await api.showsNextUpGet(
      nextUpDateCutoff: DateTime.now().subtract(
          ref.read(clientSettingsProvider.select((value) => value.nextUpDateCutoff ?? const Duration(days: 28)))),
      fields: fieldsToFetch,
    );

    final next = nextResponse.body?.items
            ?.map(
              (e) => ItemBaseModel.fromBaseDto(e, ref),
            )
            .toList() ??
        [];

    state = state.copyWith(nextUp: next, loading: false);
  }

  void clear() {
    state = HomeModel();
  }
}
