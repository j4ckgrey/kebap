import 'package:chopper/chopper.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kebap/jellyfin/jellyfin_open_api.enums.swagger.dart' as enums;
import 'package:kebap/jellyfin/jellyfin_open_api.swagger.dart';
import 'package:kebap/models/item_base_model.dart';
import 'package:kebap/models/view_model.dart';
import 'package:kebap/models/views_model.dart';
import 'package:kebap/providers/api_provider.dart';
import 'package:kebap/providers/connectivity_provider.dart';
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
  ViewsNotifier(this.ref) : super(ViewsModel()) {
    // Listen to connectivity changes: refresh views when coming back online
    ref.listen<ConnectionState>(connectivityStatusProvider, (previous, next) {
      if (previous == ConnectionState.offline && next != ConnectionState.offline) {
        debugPrint('[ViewsProvider] Device came back online, refreshing views');
        fetchViews();
      }
    });
    // Listen to dashboard setting changes
    ref.listen<bool>(clientSettingsProvider.select((s) => s.dashboardShowLibraryContents), (previous, next) {
      if (previous != next) {
        debugPrint('[ViewsProvider] Dashboard mode changed to $next, refreshing views');
        fetchViews();
      }
    });
  }

  final Ref ref;

  late final JellyService api = ref.read(jellyApiProvider);

  Future<ViewsModel?> fetchViews() async {
    if (state.loading) return null;
    state = state.copyWith(loading: true); // FIX: Set loading state at start
    
    final showAllCollections = ref.read(clientSettingsProvider.select((value) => value.showAllCollectionTypes));
    final showLibraryContents = ref.read(clientSettingsProvider.select((value) => value.dashboardShowLibraryContents));
    
    try {
      final response = await api.usersUserIdViewsGet(
        includeExternalContent: showAllCollections,
      );
      
      // If API returned null, keep existing state
      if (response.body?.items == null) {
        debugPrint('[ViewsProvider] API returned null items, keeping existing state');
        state = state.copyWith(loading: false);
        return state;
      }
      
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
          
          debugPrint('[ViewsProvider] Fetching items for view ${e.name} (id: ${e.id}, mode: ${showLibraryContents ? "Library" : "Latest"})');
          
          try {
            Response<List<BaseItemDto>>? recents;
            
            if (showLibraryContents) {
              // Fetch Library Contents (A-Z)
                 final libraryItems = await api.usersUserIdItemsGet(
                  parentId: e.id,
                  imageTypeLimit: 1,
                  limit: 16,
                  recursive: true,
                  sortBy: [enums.ItemSortBy.sortname],
                  sortOrder: [SortOrder.ascending],
                  includeItemTypes: (e.collectionType == CollectionType.books && !showAllCollections)
                      ? [BaseItemKind.book]
                      : (e.collectionType == CollectionType.tvshows ? [BaseItemKind.series] : null),
                  enableImageTypes: [
                    ImageType.primary,
                    ImageType.backdrop,
                    ImageType.thumb,
                  ],
                  fields: [
                    enums.ItemFields.parentid,
                    enums.ItemFields.mediastreams,
                    enums.ItemFields.mediasources,
                    enums.ItemFields.candelete,
                    enums.ItemFields.candownload,
                    enums.ItemFields.primaryimageaspectratio,
                    enums.ItemFields.overview,
                    enums.ItemFields.providerids,
                  ],
                );
                recents = Response<List<BaseItemDto>>(libraryItems.base, libraryItems.body?.items ?? []);
            } else {
              // Fetch Latest Items
              recents = await api.usersUserIdItemsLatestGet(
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
                  enums.ItemFields.parentid,
                  enums.ItemFields.mediastreams,
                  enums.ItemFields.mediasources,
                  enums.ItemFields.candelete,
                  enums.ItemFields.candownload,
                  enums.ItemFields.primaryimageaspectratio,
                  enums.ItemFields.overview,
                  enums.ItemFields.providerids,
                ],
              );
            }
            
            debugPrint('[ViewsProvider] View ${e.name} returned ${recents?.body?.length ?? 0} items');
            return e.copyWith(recentlyAdded: recents?.body?.map((e) => ItemBaseModel.fromBaseDto(e, ref)).toList());
          } catch (itemError) {
            debugPrint('[ViewsProvider] Error fetching items for view ${e.name}: $itemError');
            // Return view without items - don't fail the whole fetch
            return e;
          }
        }));
      }

      final enableCatalogs = ref.read(clientSettingsProvider.select((value) => value.enableCatalogs));
      if (enableCatalogs) {
        try {
          final collectionsView = response.body?.items?.firstWhereOrNull((e) => e.collectionType == CollectionType.boxsets);
          if (collectionsView != null && collectionsView.id != null) {
            debugPrint('[ViewsProvider] Fetching catalogs from Collections view: ${collectionsView.id}');
            final catalogs = await api.usersUserIdItemsGet(
              parentId: collectionsView.id,
              recursive: false,
              includeItemTypes: [BaseItemKind.folder, BaseItemKind.boxset],
            );

            if (catalogs.body?.items != null) {
              // Eagerly fetch content for each catalog
              final catalogViews = await Future.wait(catalogs.body!.items!.map((catalogItem) async {
                final catalogView = ViewModel.fromBodyDto(catalogItem, ref).copyWith(
                  collectionType: CollectionType.boxsets,
                );
                
                // Fetch content for this catalog
                try {
                  final catalogContent = await api.usersUserIdItemsGet(
                    parentId: catalogView.id,
                    imageTypeLimit: 1,
                    limit: 16,
                    recursive: true,
                    sortBy: showLibraryContents 
                        ? [enums.ItemSortBy.sortname] 
                        : [enums.ItemSortBy.datecreated, enums.ItemSortBy.sortname],
                    sortOrder: showLibraryContents 
                        ? [SortOrder.ascending] 
                        : [SortOrder.descending],
                    includeItemTypes: [
                      BaseItemKind.movie,
                      BaseItemKind.series,
                      BaseItemKind.boxset,
                      BaseItemKind.video,
                    ],
                    enableImageTypes: [
                      ImageType.primary,
                      ImageType.backdrop,
                      ImageType.thumb,
                    ],
                    fields: [
                      enums.ItemFields.parentid,
                      enums.ItemFields.primaryimageaspectratio,
                      enums.ItemFields.overview,
                    ],
                  );
                  
                  final items = catalogContent.body?.items?.map((e) => ItemBaseModel.fromBaseDto(e, ref)).toList();
                  debugPrint('[ViewsProvider] Catalog ${catalogView.name} returned ${items?.length ?? 0} items');
                  return catalogView.copyWith(recentlyAdded: items);
                } catch (e) {
                  debugPrint('[ViewsProvider] Error fetching content for catalog ${catalogView.name}: $e');
                  return catalogView; // Return without content if fetch fails
                }
              }));
              
              debugPrint('[ViewsProvider] Added ${catalogViews.length} catalogs as libraries');
              newList.addAll(catalogViews);
              
              // Remove the parent "Collections" view if we successfully added its children
              newList.removeWhere((element) => element.id == collectionsView.id);
            }
          }
        } catch (catalogError) {
          debugPrint('[ViewsProvider] Error fetching catalogs: $catalogError');
          // Continue without catalogs
        }
      }


      state = state.copyWith(
          views: newList,
          dashboardViews: newList
              .where((element) =>
                  showLibraryContents || !(ref.read(userProvider)?.latestItemsExcludes.contains(element.id) ?? true))
              .toList(),
          loading: false);
      return state;
    } catch (e) {
      debugPrint('[ViewsProvider] Error fetching views: $e');
      // Keep existing state, just clear loading flag
      state = state.copyWith(loading: false);
      return state;
    }
  }


  Future<void> loadCatalogContent(String viewId) async {
    final viewIndex = state.views.indexWhere((element) => element.id == viewId);
    if (viewIndex == -1) return;

    final view = state.views[viewIndex];
    // If already loaded or not a boxset/folder we might want to skip or force reload?
    // For now, simple check if empty? No, maybe force reload is better for "retry".
    // But to avoid spamming, maybe check if already has items?
    if (view.recentlyAdded?.isNotEmpty == true) return;

    debugPrint('[ViewsProvider] Lazy loading content for catalog ${view.name} ($viewId)');
    
    final showLibraryContents = ref.read(clientSettingsProvider.select((value) => value.dashboardShowLibraryContents));

    final recents = await api.usersUserIdItemsGet(
      parentId: view.id,
      imageTypeLimit: 1,
      limit: 16,
      recursive: true,
      sortBy: showLibraryContents 
          ? [enums.ItemSortBy.sortname] 
          : [enums.ItemSortBy.datecreated, enums.ItemSortBy.sortname],
      sortOrder: showLibraryContents 
          ? [SortOrder.ascending] 
          : [SortOrder.descending],
      includeItemTypes: [
        BaseItemKind.movie,
        BaseItemKind.series,
        BaseItemKind.boxset,
        BaseItemKind.video,
      ],
      enableImageTypes: [
        ImageType.primary,
        ImageType.backdrop,
        ImageType.thumb,
      ],
      fields: [
        enums.ItemFields.parentid,
        enums.ItemFields.mediastreams,
        enums.ItemFields.mediasources,
        enums.ItemFields.candelete,
        enums.ItemFields.candownload,
        enums.ItemFields.primaryimageaspectratio,
        enums.ItemFields.overview,
        enums.ItemFields.providerids,
      ],
    );

    final newItems = recents.body?.items?.map((e) => ItemBaseModel.fromBaseDto(e, ref)).toList();
    final newView = view.copyWith(recentlyAdded: newItems);
    
    final newViewsList = List<ViewModel>.from(state.views);
    newViewsList[viewIndex] = newView;
    
    state = state.copyWith(
      views: newViewsList,
      dashboardViews: newViewsList
            .where((element) =>
                showLibraryContents || !(ref.read(userProvider)?.latestItemsExcludes.contains(element.id) ?? true))
            .toList(),
    );
  }

  void clear() {
    state = ViewsModel();
  }
}
