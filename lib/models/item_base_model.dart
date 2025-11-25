import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import 'package:kebap/jellyfin/jellyfin_open_api.enums.swagger.dart';
import 'package:kebap/jellyfin/jellyfin_open_api.swagger.dart' as dto;
import 'package:kebap/models/book_model.dart';
import 'package:kebap/models/boxset_model.dart';
import 'package:kebap/models/items/episode_model.dart';
import 'package:kebap/models/items/folder_model.dart';
import 'package:kebap/models/items/images_models.dart';
import 'package:kebap/models/items/item_shared_models.dart';
import 'package:kebap/models/items/media_streams_model.dart';
import 'package:kebap/models/items/movie_model.dart';
import 'package:kebap/models/items/overview_model.dart';
import 'package:kebap/models/items/person_model.dart';
import 'package:kebap/models/items/photos_model.dart';
import 'package:kebap/models/items/season_model.dart';
import 'package:kebap/models/items/series_model.dart';
import 'package:kebap/models/library_search/library_search_options.dart';
import 'package:kebap/models/playlist_model.dart';
import 'package:kebap/providers/api_provider.dart';
import 'package:kebap/routes/auto_router.gr.dart';
import 'package:kebap/screens/details_screens/book_detail_screen.dart';
import 'package:kebap/screens/details_screens/details_screens.dart';
import 'package:kebap/screens/details_screens/episode_detail_screen.dart';
import 'package:kebap/screens/details_screens/season_detail_screen.dart';
import 'package:kebap/screens/library_search/library_search_screen.dart';
import 'package:kebap/screens/photo_viewer/photo_viewer_screen.dart';
import 'package:kebap/src/video_player_helper.g.dart' show SimpleItemModel;
import 'package:kebap/util/localization_helper.dart';

part 'item_base_model.mapper.dart';

@MappableClass()
class ItemBaseModel with ItemBaseModelMappable {
  final String name;
  final String id;
  final OverviewModel overview;
  final String? parentId;
  final String? playlistId;
  final ImagesData? images;
  final int? childCount;
  final double? primaryRatio;
  final UserData userData;
  final bool? canDownload;
  final bool? canDelete;
  final dto.BaseItemKind? jellyType;

  const ItemBaseModel({
    required this.name,
    required this.id,
    required this.overview,
    required this.parentId,
    required this.playlistId,
    required this.images,
    required this.childCount,
    required this.primaryRatio,
    required this.userData,
    required this.canDownload,
    required this.canDelete,
    required this.jellyType,
  });

  ItemBaseModel? setProgress(double progress) {
    return copyWith(userData: userData.copyWith(progress: progress));
  }

  Widget? subTitle(SortingOptions options) => switch (options) {
        SortingOptions.parentalRating => Row(
            children: [
              const Icon(
                IconsaxPlusBold.star_1,
                size: 14,
                color: Colors.yellowAccent,
              ),
              const SizedBox(width: 6),
              Text(overview.parentalRating?.toString() ?? "--"),
            ],
          ),
        SortingOptions.communityRating => Row(
            children: [
              const Icon(
                IconsaxPlusBold.star_1,
                size: 14,
                color: Colors.yellowAccent,
              ),
              const SizedBox(width: 6),
              Text(overview.communityRating?.toStringAsFixed(2) ?? "--"),
            ],
          ),
        _ => null,
      };

  String get title => name;

  ///Used for retrieving the correct id when fetching queue
  String get streamId => id;

  ItemBaseModel get parentBaseModel => copyWith(id: parentId);

  bool get emptyShow => false;

  bool get identifiable => false;

  int? get unPlayedItemCount => userData.unPlayedItemCount;

  bool get unWatched => !userData.played && userData.progress <= 0 && userData.unPlayedItemCount == 0;

  bool get watched => userData.played;

  String? unplayedLabel(BuildContext context) => null;

  String? detailedName(BuildContext context) => "$name${overview.yearAired != null ? " (${overview.yearAired})" : ""}";

  String? get subText => null;
  String? subTextShort(BuildContext context) => null;
  String? label(BuildContext context) => null;

  ImagesData? get getPosters => images;

  ImageData? get bannerImage => images?.backDrop?.firstOrNull ?? images?.primary ?? getPosters?.backDrop?.firstOrNull ?? getPosters?.primary;

  bool get playAble => false;

  bool get syncAble => false;

  bool get galleryItem => false;

  MediaStreamsModel? get streamModel => null;

  String playText(BuildContext context) => context.localized.play(name);

  double get progress => userData.progress;

  String playButtonLabel(BuildContext context) =>
      progress != 0 ? context.localized.resumeLabel : context.localized.playLabel;

  Widget get detailScreenWidget {
    switch (this) {
      case PersonModel _:
        return PersonDetailScreen(person: Person(id: id, image: images?.primary));
      case SeasonModel _:
        return SeasonDetailScreen(item: this);
      case FolderModel _:
      case BoxSetModel _:
      case PlaylistModel _:
      case PhotoAlbumModel _:
        return LibrarySearchScreen(folderId: [id]);
      case PhotoModel _:
        final photo = this as PhotoModel;
        return PhotoViewerScreen(
          items: [photo],
        );
      case BookModel book:
        return BookDetailScreen(item: book);
      case MovieModel _:
        return MovieDetailScreen(item: this);
      case EpisodeModel _:
        return EpisodeDetailScreen(item: this);
      case SeriesModel series:
        return SeriesDetailScreen(item: series);
      default:
        return EmptyItem(item: this);
    }
  }

  Future<void> navigateTo(BuildContext context, {WidgetRef? ref, Object? tag}) async {
    switch (this) {
      case FolderModel _:
      case BoxSetModel _:
      case PlaylistModel _:
        context.router.push(LibrarySearchRoute(folderId: [id], recursive: true));
        break;
      case PhotoAlbumModel _:
        context.router.push(LibrarySearchRoute(folderId: [id], recursive: false));
        break;
      case PhotoModel _:
        final photo = this as PhotoModel;
        context.router.push(
          PhotoViewerRoute(
            items: [photo],
            loadingItems: ref?.read(jellyApiProvider).itemsGetAlbumPhotos(albumId: photo.albumId),
            selected: photo.id,
          ),
        );
        break;
      case BookModel _:
      case MovieModel _:
      case EpisodeModel _:
      case SeriesModel _:
      case SeasonModel _:
      case PersonModel _:
      default:
        context.router.push(DetailsRoute(id: id, item: this, tag: tag));
        break;
    }
  }

  factory ItemBaseModel.fromBaseDto(dto.BaseItemDto item, Ref ref) {
    return switch (item.type) {
      BaseItemKind.photo || BaseItemKind.video => PhotoModel.fromBaseDto(item, ref),
      BaseItemKind.photoalbum => PhotoAlbumModel.fromBaseDto(item, ref),
      BaseItemKind.folder ||
      BaseItemKind.collectionfolder ||
      BaseItemKind.aggregatefolder =>
        FolderModel.fromBaseDto(item, ref),
      BaseItemKind.episode => EpisodeModel.fromBaseDto(item, ref),
      BaseItemKind.movie => MovieModel.fromBaseDto(item, ref),
      BaseItemKind.series => SeriesModel.fromBaseDto(item, ref),
      BaseItemKind.person => PersonModel.fromBaseDto(item, ref),
      BaseItemKind.season => SeasonModel.fromBaseDto(item, ref),
      BaseItemKind.boxset => BoxSetModel.fromBaseDto(item, ref),
      BaseItemKind.book => BookModel.fromBaseDto(item, ref),
      BaseItemKind.playlist => PlaylistModel.fromBaseDto(item, ref),
      _ => ItemBaseModel._fromBaseDto(item, ref)
    };
  }

  factory ItemBaseModel._fromBaseDto(dto.BaseItemDto item, Ref ref) {
    return ItemBaseModel(
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

  SimpleItemModel toSimpleItem(BuildContext? context) {
    return SimpleItemModel(
      id: id,
      title: title,
      subTitle: context != null ? label(context) : null,
      overview: overview.summary,
      logoUrl: getPosters?.logo?.path ?? images?.logo?.path,
      primaryPoster: images?.primary?.path ?? getPosters?.primary?.path ?? "",
    );
  }

  KebapItemType get type => switch (this) {
        MovieModel _ => KebapItemType.movie,
        SeriesModel _ => KebapItemType.series,
        SeasonModel _ => KebapItemType.season,
        PhotoAlbumModel _ => KebapItemType.photoAlbum,
        PhotoModel model => model.internalType,
        EpisodeModel _ => KebapItemType.episode,
        BookModel _ => KebapItemType.book,
        PlaylistModel _ => KebapItemType.playlist,
        FolderModel _ => KebapItemType.folder,
        ItemBaseModel _ => KebapItemType.baseType,
      };

  @override
  bool operator ==(covariant ItemBaseModel other) {
    if (identical(this, other)) return true;
    return other.id == id;
  }

  @override
  int get hashCode {
    return id.hashCode ^ type.hashCode;
  }
}

// Currently supported types
enum KebapItemType {
  baseType(
    icon: IconsaxPlusLinear.folder_2,
    selectedicon: IconsaxPlusBold.folder_2,
  ),
  audio(
    icon: IconsaxPlusLinear.music,
    selectedicon: IconsaxPlusBold.music,
  ),
  musicAlbum(
    icon: IconsaxPlusLinear.music,
    selectedicon: IconsaxPlusBold.music,
  ),
  musicVideo(
    icon: IconsaxPlusLinear.music,
    selectedicon: IconsaxPlusBold.music,
  ),
  collectionFolder(
    icon: IconsaxPlusLinear.music,
    selectedicon: IconsaxPlusBold.music,
  ),
  video(
    icon: IconsaxPlusLinear.video,
    selectedicon: IconsaxPlusBold.video,
  ),
  movie(
    icon: IconsaxPlusLinear.video_horizontal,
    selectedicon: IconsaxPlusBold.video_horizontal,
  ),
  series(
    icon: IconsaxPlusLinear.video_vertical,
    selectedicon: IconsaxPlusBold.video_vertical,
  ),
  season(
    icon: IconsaxPlusLinear.video_vertical,
    selectedicon: IconsaxPlusBold.video_vertical,
  ),
  episode(
    icon: IconsaxPlusLinear.video_vertical,
    selectedicon: IconsaxPlusBold.video_vertical,
  ),
  photo(
    icon: IconsaxPlusLinear.picture_frame,
    selectedicon: IconsaxPlusBold.picture_frame,
  ),
  person(
    icon: IconsaxPlusLinear.user,
    selectedicon: IconsaxPlusBold.user,
  ),
  photoAlbum(
    icon: IconsaxPlusLinear.gallery,
    selectedicon: IconsaxPlusBold.gallery,
  ),
  folder(
    icon: IconsaxPlusLinear.folder,
    selectedicon: IconsaxPlusBold.folder,
  ),
  boxset(
    icon: IconsaxPlusLinear.bookmark,
    selectedicon: IconsaxPlusBold.bookmark,
  ),
  playlist(
    icon: IconsaxPlusLinear.archive_book,
    selectedicon: IconsaxPlusBold.archive_book,
  ),
  book(
    icon: IconsaxPlusLinear.book,
    selectedicon: IconsaxPlusBold.book,
  );

  const KebapItemType({required this.icon, required this.selectedicon});

  double get aspectRatio => switch (this) {
        KebapItemType.video => 0.8,
        KebapItemType.photo => 0.8,
        KebapItemType.photoAlbum => 0.8,
        KebapItemType.folder => 0.8,
        KebapItemType.musicAlbum => 0.8,
        KebapItemType.baseType => 0.8,
        _ => 0.55,
      };

  static Set<KebapItemType> get playable => {
        KebapItemType.series,
        KebapItemType.episode,
        KebapItemType.season,
        KebapItemType.movie,
        KebapItemType.musicVideo,
      };

  static Set<KebapItemType> get galleryItem => {
        KebapItemType.photo,
        KebapItemType.video,
      };

  String label(BuildContext context) => switch (this) {
        KebapItemType.baseType => context.localized.mediaTypeBase,
        KebapItemType.audio => context.localized.audio,
        KebapItemType.collectionFolder => context.localized.collectionFolder,
        KebapItemType.musicAlbum => context.localized.musicAlbum,
        KebapItemType.musicVideo => context.localized.video,
        KebapItemType.video => context.localized.video,
        KebapItemType.movie => context.localized.mediaTypeMovie,
        KebapItemType.series => context.localized.mediaTypeSeries,
        KebapItemType.season => context.localized.mediaTypeSeason,
        KebapItemType.episode => context.localized.mediaTypeEpisode,
        KebapItemType.photo => context.localized.mediaTypePhoto,
        KebapItemType.person => context.localized.mediaTypePerson,
        KebapItemType.photoAlbum => context.localized.mediaTypePhotoAlbum,
        KebapItemType.folder => context.localized.mediaTypeFolder,
        KebapItemType.boxset => context.localized.mediaTypeBoxset,
        KebapItemType.playlist => context.localized.mediaTypePlaylist,
        KebapItemType.book => context.localized.mediaTypeBook,
      };

  BaseItemKind get dtoKind => switch (this) {
        KebapItemType.baseType => BaseItemKind.userrootfolder,
        KebapItemType.audio => BaseItemKind.audio,
        KebapItemType.collectionFolder => BaseItemKind.collectionfolder,
        KebapItemType.musicAlbum => BaseItemKind.musicalbum,
        KebapItemType.musicVideo => BaseItemKind.video,
        KebapItemType.video => BaseItemKind.video,
        KebapItemType.movie => BaseItemKind.movie,
        KebapItemType.series => BaseItemKind.series,
        KebapItemType.season => BaseItemKind.season,
        KebapItemType.episode => BaseItemKind.episode,
        KebapItemType.photo => BaseItemKind.photo,
        KebapItemType.person => BaseItemKind.person,
        KebapItemType.photoAlbum => BaseItemKind.photoalbum,
        KebapItemType.folder => BaseItemKind.folder,
        KebapItemType.boxset => BaseItemKind.boxset,
        KebapItemType.playlist => BaseItemKind.playlist,
        KebapItemType.book => BaseItemKind.book,
      };

  final IconData icon;
  final IconData selectedicon;
}
