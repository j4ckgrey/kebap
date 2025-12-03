import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kebap/jellyfin/jellyfin_open_api.swagger.dart';
import 'package:kebap/models/item_base_model.dart';
import 'package:kebap/models/view_model.dart';
import 'package:kebap/models/views_model.dart';
import 'package:kebap/providers/api_provider.dart';
import 'package:kebap/providers/service_provider.dart';
import 'package:kebap/providers/settings/client_settings_provider.dart';
import 'package:kebap/providers/user_provider.dart';

//Known supported collection types
const enableCollectionTypes = {
  CollectionType.movies,
  CollectionType.books,
  CollectionType.tvshows,
  CollectionType.homevideos,
  CollectionType.boxsets,
  CollectionType.playlists,
  CollectionType.photos,
  CollectionType.folders,
  CollectionType.livetv,
};

final viewsProvider = StateNotifierProvider<ViewsNotifier, ViewsModel>((ref) {
  return ViewsNotifier(ref);
});

class ViewsNotifier extends StateNotifier<ViewsModel> {
  ViewsNotifier(this.ref) : super(ViewsModel());

  final Ref ref;

  late final JellyService api = ref.read(jellyApiProvider);

  Future<ViewsModel?> fetchViews() async {
    if (state.loading) return null;
    final showAllCollections = ref.read(clientSettingsProvider.select((value) => value.showAllCollectionTypes));
    final response = await api.usersUserIdViewsGet(
      includeExternalContent: showAllCollections,
    );
    final createdViews = response.body?.items?.map((e) => ViewModel.fromBodyDto(e, ref)).where((element) {
      return showAllCollections ? true : enableCollectionTypes.contains(element.collectionType);
    });

    List<ViewModel> newList = [];

    if (createdViews != null) {
      newList = await Future.wait(createdViews.map((e) async {
        if (ref.read(userProvider)?.latestItemsExcludes.contains(e.id) == true) {
          debugPrint('[ViewsProvider] Skipping view ${e.name} due to user exclusion');
          return e;
        }
        debugPrint('[ViewsProvider] Fetching latest items for view ${e.name} (id: ${e.id}, type: ${e.collectionType})');
        final recents = await api.usersUserIdItemsLatestGet(
          parentId: e.id,
          imageTypeLimit: 1,
          limit: 16,
          includeItemTypes:
              (e.collectionType == CollectionType.books && !showAllCollections) ? [BaseItemKind.book] : null,
          enableImageTypes: [
            ImageType.primary,
            ImageType.backdrop,
            ImageType.thumb,
          ],
          fields: [
            ItemFields.parentid,
            ItemFields.mediastreams,
            ItemFields.mediasources,
            ItemFields.candelete,
            ItemFields.candownload,
            ItemFields.primaryimageaspectratio,
            ItemFields.overview,
            ItemFields.providerids,
          ],
        );
        debugPrint('[ViewsProvider] View ${e.name} returned ${recents.body?.length ?? 0} items');
        return e.copyWith(recentlyAdded: recents.body?.map((e) => ItemBaseModel.fromBaseDto(e, ref)).toList());
      }));
    }

    state = state.copyWith(
        views: newList,
        dashboardViews: newList
            .where((element) => !(ref.read(userProvider)?.latestItemsExcludes.contains(element.id) ?? true))
            .toList(),
        loading: false);
    return state;
  }

  void clear() {
    state = ViewsModel();
  }
}
