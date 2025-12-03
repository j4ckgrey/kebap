import 'package:flutter/material.dart';

import 'package:iconsax_plus/iconsax_plus.dart';

import 'package:kebap/jellyfin/jellyfin_open_api.enums.swagger.dart';
import 'package:kebap/jellyfin/jellyfin_open_api.swagger.dart';
import 'package:kebap/models/item_base_model.dart';
import 'package:kebap/models/library_filter_model.dart';

extension CollectionTypeExtension on CollectionType {
  IconData get iconOutlined {
    return getIconType(true);
  }

  IconData get icon {
    return getIconType(false);
  }

  Set<KebapItemType> get itemKinds {
    switch (this) {
      case CollectionType.music:
        return {KebapItemType.musicAlbum};
      case CollectionType.movies:
        return {KebapItemType.movie};
      case CollectionType.tvshows:
        return {KebapItemType.series};
      case CollectionType.homevideos:
        return {KebapItemType.photoAlbum, KebapItemType.folder, KebapItemType.photo, KebapItemType.video};
      default:
        return {};
    }
  }

  IconData getIconType(bool outlined) {
    switch (this) {
      case CollectionType.music:
        return outlined ? IconsaxPlusLinear.music_square : IconsaxPlusBold.music_square;
      case CollectionType.movies:
        return outlined ? IconsaxPlusLinear.video_horizontal : IconsaxPlusBold.video_horizontal;
      case CollectionType.tvshows:
        return outlined ? IconsaxPlusLinear.video_vertical : IconsaxPlusBold.video_vertical;
      case CollectionType.boxsets:
        return outlined ? IconsaxPlusLinear.box : IconsaxPlusBold.box;
      case CollectionType.folders:
        return outlined ? IconsaxPlusLinear.folder_2 : IconsaxPlusBold.folder_2;
      case CollectionType.homevideos:
        return outlined ? IconsaxPlusLinear.gallery : IconsaxPlusBold.gallery;
      case CollectionType.books:
        return outlined ? IconsaxPlusLinear.book : IconsaxPlusBold.book;
      case CollectionType.playlists:
        return outlined ? IconsaxPlusLinear.archive : IconsaxPlusBold.archive;
      case CollectionType.livetv:
        return outlined ? IconsaxPlusLinear.monitor : IconsaxPlusBold.monitor;
      default:
        return IconsaxPlusLinear.information;
    }
  }

  LibraryFilterModel get defaultFilters => switch (this) {
        CollectionType.homevideos || CollectionType.photos => const LibraryFilterModel(recursive: false),
        _ => const LibraryFilterModel(
            recursive: true,
          )
      };

  double? get aspectRatio => switch (this) {
        CollectionType.music ||
        CollectionType.homevideos ||
        CollectionType.boxsets ||
        CollectionType.photos ||
        CollectionType.livetv ||
        CollectionType.playlists =>
          0.8,
        CollectionType.folders => 1.3,
        _ => null,
      };
}
