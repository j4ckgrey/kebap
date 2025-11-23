// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_filter_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LibraryFilterModel _$LibraryFilterModelFromJson(Map<String, dynamic> json) =>
    _LibraryFilterModel(
      genres: (json['genres'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as bool),
          ) ??
          const {},
      itemFilters: (json['itemFilters'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry($enumDecode(_$ItemFilterEnumMap, k), e as bool),
          ) ??
          const {
            ItemFilter.isplayed: false,
            ItemFilter.isunplayed: false,
            ItemFilter.isresumable: false
          },
      studios: json['studios'] == null
          ? const {}
          : const StudioEncoder().fromJson(json['studios'] as String),
      tags: (json['tags'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as bool),
          ) ??
          const {},
      years: (json['years'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(int.parse(k), e as bool),
          ) ??
          const {},
      officialRatings: (json['officialRatings'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as bool),
          ) ??
          const {},
      types: (json['types'] as Map<String, dynamic>?)?.map(
            (k, e) =>
                MapEntry($enumDecode(_$KebapItemTypeEnumMap, k), e as bool),
          ) ??
          const {
            KebapItemType.audio: false,
            KebapItemType.boxset: false,
            KebapItemType.book: false,
            KebapItemType.collectionFolder: false,
            KebapItemType.episode: false,
            KebapItemType.folder: false,
            KebapItemType.movie: false,
            KebapItemType.musicAlbum: false,
            KebapItemType.musicVideo: false,
            KebapItemType.photo: false,
            KebapItemType.person: false,
            KebapItemType.photoAlbum: false,
            KebapItemType.series: false,
            KebapItemType.video: false
          },
      sortingOption:
          $enumDecodeNullable(_$SortingOptionsEnumMap, json['sortingOption']) ??
              SortingOptions.sortName,
      sortOrder:
          $enumDecodeNullable(_$SortingOrderEnumMap, json['sortOrder']) ??
              SortingOrder.ascending,
      favourites: json['favourites'] as bool? ?? false,
      hideEmptyShows: json['hideEmptyShows'] as bool? ?? true,
      recursive: json['recursive'] as bool? ?? true,
      groupBy: $enumDecodeNullable(_$GroupByEnumMap, json['groupBy']) ??
          GroupBy.none,
    );

Map<String, dynamic> _$LibraryFilterModelToJson(_LibraryFilterModel instance) =>
    <String, dynamic>{
      'genres': instance.genres,
      'itemFilters': instance.itemFilters
          .map((k, e) => MapEntry(_$ItemFilterEnumMap[k], e)),
      'studios': const StudioEncoder().toJson(instance.studios),
      'tags': instance.tags,
      'years': instance.years.map((k, e) => MapEntry(k.toString(), e)),
      'officialRatings': instance.officialRatings,
      'types':
          instance.types.map((k, e) => MapEntry(_$KebapItemTypeEnumMap[k]!, e)),
      'sortingOption': _$SortingOptionsEnumMap[instance.sortingOption]!,
      'sortOrder': _$SortingOrderEnumMap[instance.sortOrder]!,
      'favourites': instance.favourites,
      'hideEmptyShows': instance.hideEmptyShows,
      'recursive': instance.recursive,
      'groupBy': _$GroupByEnumMap[instance.groupBy]!,
    };

const _$ItemFilterEnumMap = {
  ItemFilter.swaggerGeneratedUnknown: null,
  ItemFilter.isfolder: 'IsFolder',
  ItemFilter.isnotfolder: 'IsNotFolder',
  ItemFilter.isunplayed: 'IsUnplayed',
  ItemFilter.isplayed: 'IsPlayed',
  ItemFilter.isfavorite: 'IsFavorite',
  ItemFilter.isresumable: 'IsResumable',
  ItemFilter.likes: 'Likes',
  ItemFilter.dislikes: 'Dislikes',
  ItemFilter.isfavoriteorlikes: 'IsFavoriteOrLikes',
};

const _$KebapItemTypeEnumMap = {
  KebapItemType.baseType: 'baseType',
  KebapItemType.audio: 'audio',
  KebapItemType.musicAlbum: 'musicAlbum',
  KebapItemType.musicVideo: 'musicVideo',
  KebapItemType.collectionFolder: 'collectionFolder',
  KebapItemType.video: 'video',
  KebapItemType.movie: 'movie',
  KebapItemType.series: 'series',
  KebapItemType.season: 'season',
  KebapItemType.episode: 'episode',
  KebapItemType.photo: 'photo',
  KebapItemType.person: 'person',
  KebapItemType.photoAlbum: 'photoAlbum',
  KebapItemType.folder: 'folder',
  KebapItemType.boxset: 'boxset',
  KebapItemType.playlist: 'playlist',
  KebapItemType.book: 'book',
};

const _$SortingOptionsEnumMap = {
  SortingOptions.sortName: 'sortName',
  SortingOptions.communityRating: 'communityRating',
  SortingOptions.parentalRating: 'parentalRating',
  SortingOptions.dateAdded: 'dateAdded',
  SortingOptions.dateLastContentAdded: 'dateLastContentAdded',
  SortingOptions.favorite: 'favorite',
  SortingOptions.datePlayed: 'datePlayed',
  SortingOptions.folders: 'folders',
  SortingOptions.playCount: 'playCount',
  SortingOptions.releaseDate: 'releaseDate',
  SortingOptions.runTime: 'runTime',
  SortingOptions.random: 'random',
};

const _$SortingOrderEnumMap = {
  SortingOrder.ascending: 'ascending',
  SortingOrder.descending: 'descending',
};

const _$GroupByEnumMap = {
  GroupBy.none: 'none',
  GroupBy.name: 'name',
  GroupBy.genres: 'genres',
  GroupBy.dateAdded: 'dateAdded',
  GroupBy.tags: 'tags',
  GroupBy.releaseDate: 'releaseDate',
  GroupBy.rating: 'rating',
  GroupBy.type: 'type',
};
