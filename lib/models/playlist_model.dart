import 'package:kebap/jellyfin/jellyfin_open_api.swagger.dart';
import 'package:kebap/models/item_base_model.dart';
import 'package:kebap/models/items/images_models.dart';
import 'package:kebap/models/items/item_shared_models.dart';
import 'package:kebap/models/items/overview_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlaylistModel extends ItemBaseModel {
  PlaylistModel({
    required super.name,
    required super.id,
    required super.overview,
    required super.parentId,
    required super.playlistId,
    required super.images,
    required super.childCount,
    required super.primaryRatio,
    required super.userData,
    super.canDelete,
    super.canDownload,
    super.jellyType,
  });

  factory PlaylistModel.fromBaseDto(BaseItemDto item, Ref ref) {
    return PlaylistModel(
      name: item.name ?? "",
      id: item.id ?? "",
      childCount: item.childCount,
      overview: OverviewModel.fromBaseItemDto(item, ref),
      userData: UserData.fromDto(item.userData),
      parentId: item.parentId,
      playlistId: item.playlistItemId,
      images: ImagesData.fromBaseItem(item, ref),
      primaryRatio: item.primaryImageAspectRatio,
      canDelete: item.canDelete,
      canDownload: item.canDownload,
      jellyType: item.type,
    );
  }
}
