// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i34;

import 'package:auto_route/auto_route.dart' as _i28;
import 'package:collection/collection.dart' as _i32;
import 'package:flutter/foundation.dart' as _i30;
import 'package:flutter/material.dart' as _i35;
import 'package:kebap/models/item_base_model.dart' as _i29;
import 'package:kebap/models/items/photos_model.dart' as _i33;
import 'package:kebap/models/library_search/library_search_options.dart'
    as _i31;
import 'package:kebap/routes/nested_details_screen.dart' as _i8;
import 'package:kebap/screens/dashboard/dashboard_screen.dart' as _i6;
import 'package:kebap/screens/favourites/favourites_screen.dart' as _i11;
import 'package:kebap/screens/home_screen.dart' as _i13;
import 'package:kebap/screens/library/library_screen.dart' as _i16;
import 'package:kebap/screens/library_search/library_search_screen.dart'
    as _i17;
import 'package:kebap/screens/login/lock_screen.dart' as _i18;
import 'package:kebap/screens/login/login_screen.dart' as _i19;
import 'package:kebap/screens/photo_viewer/photo_viewer_screen.dart' as _i20;
import 'package:kebap/screens/requests_screen.dart' as _i23;
import 'package:kebap/screens/settings/about_settings_page.dart' as _i1;
import 'package:kebap/screens/settings/advanced_settings_page.dart' as _i2;
import 'package:kebap/screens/settings/baklava_settings_page.dart' as _i3;
import 'package:kebap/screens/settings/client_settings_page.dart' as _i4;
import 'package:kebap/screens/settings/content_filter_settings_page.dart'
    as _i5;
import 'package:kebap/screens/settings/dashboard_settings_page.dart' as _i7;
import 'package:kebap/screens/settings/details_settings_page.dart' as _i9;
import 'package:kebap/screens/settings/downloads_settings_page.dart' as _i10;
import 'package:kebap/screens/settings/general_ui_settings_page.dart' as _i12;
import 'package:kebap/screens/settings/kebap_settings_page.dart' as _i14;
import 'package:kebap/screens/settings/libraries_settings_page.dart' as _i15;
import 'package:kebap/screens/settings/player_settings_page.dart' as _i21;
import 'package:kebap/screens/settings/profile_settings_page.dart' as _i22;
import 'package:kebap/screens/settings/settings_screen.dart' as _i24;
import 'package:kebap/screens/settings/settings_selection_screen.dart' as _i25;
import 'package:kebap/screens/splash_screen.dart' as _i26;
import 'package:kebap/screens/syncing/synced_screen.dart' as _i27;

/// generated route for
/// [_i1.AboutSettingsPage]
class AboutSettingsRoute extends _i28.PageRouteInfo<void> {
  const AboutSettingsRoute({List<_i28.PageRouteInfo>? children})
      : super(AboutSettingsRoute.name, initialChildren: children);

  static const String name = 'AboutSettingsRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i1.AboutSettingsPage();
    },
  );
}

/// generated route for
/// [_i2.AdvancedSettingsPage]
class AdvancedSettingsRoute extends _i28.PageRouteInfo<void> {
  const AdvancedSettingsRoute({List<_i28.PageRouteInfo>? children})
      : super(AdvancedSettingsRoute.name, initialChildren: children);

  static const String name = 'AdvancedSettingsRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i2.AdvancedSettingsPage();
    },
  );
}

/// generated route for
/// [_i3.BaklavaSettingsPage]
class BaklavaSettingsRoute extends _i28.PageRouteInfo<void> {
  const BaklavaSettingsRoute({List<_i28.PageRouteInfo>? children})
      : super(BaklavaSettingsRoute.name, initialChildren: children);

  static const String name = 'BaklavaSettingsRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i3.BaklavaSettingsPage();
    },
  );
}

/// generated route for
/// [_i4.ClientSettingsPage]
class ClientSettingsRoute extends _i28.PageRouteInfo<void> {
  const ClientSettingsRoute({List<_i28.PageRouteInfo>? children})
      : super(ClientSettingsRoute.name, initialChildren: children);

  static const String name = 'ClientSettingsRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i4.ClientSettingsPage();
    },
  );
}

/// generated route for
/// [_i5.ContentFilterSettingsPage]
class ContentFilterSettingsRoute extends _i28.PageRouteInfo<void> {
  const ContentFilterSettingsRoute({List<_i28.PageRouteInfo>? children})
      : super(ContentFilterSettingsRoute.name, initialChildren: children);

  static const String name = 'ContentFilterSettingsRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i5.ContentFilterSettingsPage();
    },
  );
}

/// generated route for
/// [_i6.DashboardScreen]
class DashboardRoute extends _i28.PageRouteInfo<void> {
  const DashboardRoute({List<_i28.PageRouteInfo>? children})
      : super(DashboardRoute.name, initialChildren: children);

  static const String name = 'DashboardRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i6.DashboardScreen();
    },
  );
}

/// generated route for
/// [_i7.DashboardSettingsPage]
class DashboardSettingsRoute extends _i28.PageRouteInfo<void> {
  const DashboardSettingsRoute({List<_i28.PageRouteInfo>? children})
      : super(DashboardSettingsRoute.name, initialChildren: children);

  static const String name = 'DashboardSettingsRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i7.DashboardSettingsPage();
    },
  );
}

/// generated route for
/// [_i8.DetailsScreen]
class DetailsRoute extends _i28.PageRouteInfo<DetailsRouteArgs> {
  DetailsRoute({
    String id = '',
    _i29.ItemBaseModel? item,
    Object? tag,
    _i30.Key? key,
    List<_i28.PageRouteInfo>? children,
  }) : super(
          DetailsRoute.name,
          args: DetailsRouteArgs(id: id, item: item, tag: tag, key: key),
          rawQueryParams: {'id': id},
          initialChildren: children,
        );

  static const String name = 'DetailsRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      final queryParams = data.queryParams;
      final args = data.argsAs<DetailsRouteArgs>(
        orElse: () => DetailsRouteArgs(id: queryParams.getString('id', '')),
      );
      return _i8.DetailsScreen(
        id: args.id,
        item: args.item,
        tag: args.tag,
        key: args.key,
      );
    },
  );
}

class DetailsRouteArgs {
  const DetailsRouteArgs({this.id = '', this.item, this.tag, this.key});

  final String id;

  final _i29.ItemBaseModel? item;

  final Object? tag;

  final _i30.Key? key;

  @override
  String toString() {
    return 'DetailsRouteArgs{id: $id, item: $item, tag: $tag, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! DetailsRouteArgs) return false;
    return id == other.id &&
        item == other.item &&
        tag == other.tag &&
        key == other.key;
  }

  @override
  int get hashCode => id.hashCode ^ item.hashCode ^ tag.hashCode ^ key.hashCode;
}

/// generated route for
/// [_i9.DetailsSettingsPage]
class DetailsSettingsRoute extends _i28.PageRouteInfo<void> {
  const DetailsSettingsRoute({List<_i28.PageRouteInfo>? children})
      : super(DetailsSettingsRoute.name, initialChildren: children);

  static const String name = 'DetailsSettingsRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i9.DetailsSettingsPage();
    },
  );
}

/// generated route for
/// [_i10.DownloadsSettingsPage]
class DownloadsSettingsRoute extends _i28.PageRouteInfo<void> {
  const DownloadsSettingsRoute({List<_i28.PageRouteInfo>? children})
      : super(DownloadsSettingsRoute.name, initialChildren: children);

  static const String name = 'DownloadsSettingsRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i10.DownloadsSettingsPage();
    },
  );
}

/// generated route for
/// [_i11.FavouritesScreen]
class FavouritesRoute extends _i28.PageRouteInfo<void> {
  const FavouritesRoute({List<_i28.PageRouteInfo>? children})
      : super(FavouritesRoute.name, initialChildren: children);

  static const String name = 'FavouritesRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i11.FavouritesScreen();
    },
  );
}

/// generated route for
/// [_i12.GeneralUiSettingsPage]
class GeneralUiSettingsRoute extends _i28.PageRouteInfo<void> {
  const GeneralUiSettingsRoute({List<_i28.PageRouteInfo>? children})
      : super(GeneralUiSettingsRoute.name, initialChildren: children);

  static const String name = 'GeneralUiSettingsRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i12.GeneralUiSettingsPage();
    },
  );
}

/// generated route for
/// [_i13.HomeScreen]
class HomeRoute extends _i28.PageRouteInfo<void> {
  const HomeRoute({List<_i28.PageRouteInfo>? children})
      : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i13.HomeScreen();
    },
  );
}

/// generated route for
/// [_i14.KebapSettingsPage]
class KebapSettingsRoute extends _i28.PageRouteInfo<void> {
  const KebapSettingsRoute({List<_i28.PageRouteInfo>? children})
      : super(KebapSettingsRoute.name, initialChildren: children);

  static const String name = 'KebapSettingsRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i14.KebapSettingsPage();
    },
  );
}

/// generated route for
/// [_i15.LibrariesSettingsPage]
class LibrariesSettingsRoute extends _i28.PageRouteInfo<void> {
  const LibrariesSettingsRoute({List<_i28.PageRouteInfo>? children})
      : super(LibrariesSettingsRoute.name, initialChildren: children);

  static const String name = 'LibrariesSettingsRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i15.LibrariesSettingsPage();
    },
  );
}

/// generated route for
/// [_i16.LibraryScreen]
class LibraryRoute extends _i28.PageRouteInfo<void> {
  const LibraryRoute({List<_i28.PageRouteInfo>? children})
      : super(LibraryRoute.name, initialChildren: children);

  static const String name = 'LibraryRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i16.LibraryScreen();
    },
  );
}

/// generated route for
/// [_i17.LibrarySearchScreen]
class LibrarySearchRoute extends _i28.PageRouteInfo<LibrarySearchRouteArgs> {
  LibrarySearchRoute({
    String? viewModelId,
    List<String>? folderId,
    bool? favourites,
    _i31.SortingOrder? sortOrder,
    _i31.SortingOptions? sortingOptions,
    Map<_i29.KebapItemType, bool>? types,
    Map<String, bool>? genres,
    bool? recursive,
    _i30.Key? key,
    List<_i28.PageRouteInfo>? children,
  }) : super(
          LibrarySearchRoute.name,
          args: LibrarySearchRouteArgs(
            viewModelId: viewModelId,
            folderId: folderId,
            favourites: favourites,
            sortOrder: sortOrder,
            sortingOptions: sortingOptions,
            types: types,
            genres: genres,
            recursive: recursive,
            key: key,
          ),
          rawQueryParams: {
            'parentId': viewModelId,
            'folderId': folderId,
            'favourites': favourites,
            'sortOrder': sortOrder,
            'sortOptions': sortingOptions,
            'itemTypes': types,
            'genres': genres,
            'recursive': recursive,
          },
          initialChildren: children,
        );

  static const String name = 'LibrarySearchRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      final queryParams = data.queryParams;
      final args = data.argsAs<LibrarySearchRouteArgs>(
        orElse: () => LibrarySearchRouteArgs(
          viewModelId: queryParams.optString('parentId'),
          folderId: queryParams.optList('folderId'),
          favourites: queryParams.optBool('favourites'),
          sortOrder: queryParams.get('sortOrder'),
          sortingOptions: queryParams.get('sortOptions'),
          types: queryParams.get('itemTypes'),
          genres: queryParams.get('genres'),
          recursive: queryParams.optBool('recursive'),
        ),
      );
      return _i17.LibrarySearchScreen(
        viewModelId: args.viewModelId,
        folderId: args.folderId,
        favourites: args.favourites,
        sortOrder: args.sortOrder,
        sortingOptions: args.sortingOptions,
        types: args.types,
        genres: args.genres,
        recursive: args.recursive,
        key: args.key,
      );
    },
  );
}

class LibrarySearchRouteArgs {
  const LibrarySearchRouteArgs({
    this.viewModelId,
    this.folderId,
    this.favourites,
    this.sortOrder,
    this.sortingOptions,
    this.types,
    this.genres,
    this.recursive,
    this.key,
  });

  final String? viewModelId;

  final List<String>? folderId;

  final bool? favourites;

  final _i31.SortingOrder? sortOrder;

  final _i31.SortingOptions? sortingOptions;

  final Map<_i29.KebapItemType, bool>? types;

  final Map<String, bool>? genres;

  final bool? recursive;

  final _i30.Key? key;

  @override
  String toString() {
    return 'LibrarySearchRouteArgs{viewModelId: $viewModelId, folderId: $folderId, favourites: $favourites, sortOrder: $sortOrder, sortingOptions: $sortingOptions, types: $types, genres: $genres, recursive: $recursive, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! LibrarySearchRouteArgs) return false;
    return viewModelId == other.viewModelId &&
        const _i32.ListEquality().equals(folderId, other.folderId) &&
        favourites == other.favourites &&
        sortOrder == other.sortOrder &&
        sortingOptions == other.sortingOptions &&
        const _i32.MapEquality().equals(types, other.types) &&
        const _i32.MapEquality().equals(genres, other.genres) &&
        recursive == other.recursive &&
        key == other.key;
  }

  @override
  int get hashCode =>
      viewModelId.hashCode ^
      const _i32.ListEquality().hash(folderId) ^
      favourites.hashCode ^
      sortOrder.hashCode ^
      sortingOptions.hashCode ^
      const _i32.MapEquality().hash(types) ^
      const _i32.MapEquality().hash(genres) ^
      recursive.hashCode ^
      key.hashCode;
}

/// generated route for
/// [_i18.LockScreen]
class LockRoute extends _i28.PageRouteInfo<void> {
  const LockRoute({List<_i28.PageRouteInfo>? children})
      : super(LockRoute.name, initialChildren: children);

  static const String name = 'LockRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i18.LockScreen();
    },
  );
}

/// generated route for
/// [_i19.LoginScreen]
class LoginRoute extends _i28.PageRouteInfo<void> {
  const LoginRoute({List<_i28.PageRouteInfo>? children})
      : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i19.LoginScreen();
    },
  );
}

/// generated route for
/// [_i20.PhotoViewerScreen]
class PhotoViewerRoute extends _i28.PageRouteInfo<PhotoViewerRouteArgs> {
  PhotoViewerRoute({
    List<_i33.PhotoModel>? items,
    String? selected,
    _i34.Future<List<_i33.PhotoModel>>? loadingItems,
    _i35.Key? key,
    List<_i28.PageRouteInfo>? children,
  }) : super(
          PhotoViewerRoute.name,
          args: PhotoViewerRouteArgs(
            items: items,
            selected: selected,
            loadingItems: loadingItems,
            key: key,
          ),
          rawQueryParams: {'selectedId': selected},
          initialChildren: children,
        );

  static const String name = 'PhotoViewerRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      final queryParams = data.queryParams;
      final args = data.argsAs<PhotoViewerRouteArgs>(
        orElse: () =>
            PhotoViewerRouteArgs(selected: queryParams.optString('selectedId')),
      );
      return _i20.PhotoViewerScreen(
        items: args.items,
        selected: args.selected,
        loadingItems: args.loadingItems,
        key: args.key,
      );
    },
  );
}

class PhotoViewerRouteArgs {
  const PhotoViewerRouteArgs({
    this.items,
    this.selected,
    this.loadingItems,
    this.key,
  });

  final List<_i33.PhotoModel>? items;

  final String? selected;

  final _i34.Future<List<_i33.PhotoModel>>? loadingItems;

  final _i35.Key? key;

  @override
  String toString() {
    return 'PhotoViewerRouteArgs{items: $items, selected: $selected, loadingItems: $loadingItems, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PhotoViewerRouteArgs) return false;
    return const _i32.ListEquality().equals(items, other.items) &&
        selected == other.selected &&
        loadingItems == other.loadingItems &&
        key == other.key;
  }

  @override
  int get hashCode =>
      const _i32.ListEquality().hash(items) ^
      selected.hashCode ^
      loadingItems.hashCode ^
      key.hashCode;
}

/// generated route for
/// [_i21.PlayerSettingsPage]
class PlayerSettingsRoute extends _i28.PageRouteInfo<void> {
  const PlayerSettingsRoute({List<_i28.PageRouteInfo>? children})
      : super(PlayerSettingsRoute.name, initialChildren: children);

  static const String name = 'PlayerSettingsRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i21.PlayerSettingsPage();
    },
  );
}

/// generated route for
/// [_i22.ProfileSettingsPage]
class ProfileSettingsRoute extends _i28.PageRouteInfo<void> {
  const ProfileSettingsRoute({List<_i28.PageRouteInfo>? children})
      : super(ProfileSettingsRoute.name, initialChildren: children);

  static const String name = 'ProfileSettingsRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i22.ProfileSettingsPage();
    },
  );
}

/// generated route for
/// [_i23.RequestsScreen]
class RequestsRoute extends _i28.PageRouteInfo<void> {
  const RequestsRoute({List<_i28.PageRouteInfo>? children})
      : super(RequestsRoute.name, initialChildren: children);

  static const String name = 'RequestsRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i23.RequestsScreen();
    },
  );
}

/// generated route for
/// [_i24.SettingsScreen]
class SettingsRoute extends _i28.PageRouteInfo<void> {
  const SettingsRoute({List<_i28.PageRouteInfo>? children})
      : super(SettingsRoute.name, initialChildren: children);

  static const String name = 'SettingsRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i24.SettingsScreen();
    },
  );
}

/// generated route for
/// [_i25.SettingsSelectionScreen]
class SettingsSelectionRoute extends _i28.PageRouteInfo<void> {
  const SettingsSelectionRoute({List<_i28.PageRouteInfo>? children})
      : super(SettingsSelectionRoute.name, initialChildren: children);

  static const String name = 'SettingsSelectionRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i25.SettingsSelectionScreen();
    },
  );
}

/// generated route for
/// [_i26.SplashScreen]
class SplashRoute extends _i28.PageRouteInfo<SplashRouteArgs> {
  SplashRoute({
    dynamic Function(bool)? loggedIn,
    _i35.Key? key,
    List<_i28.PageRouteInfo>? children,
  }) : super(
          SplashRoute.name,
          args: SplashRouteArgs(loggedIn: loggedIn, key: key),
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SplashRouteArgs>(
        orElse: () => const SplashRouteArgs(),
      );
      return _i26.SplashScreen(loggedIn: args.loggedIn, key: args.key);
    },
  );
}

class SplashRouteArgs {
  const SplashRouteArgs({this.loggedIn, this.key});

  final dynamic Function(bool)? loggedIn;

  final _i35.Key? key;

  @override
  String toString() {
    return 'SplashRouteArgs{loggedIn: $loggedIn, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SplashRouteArgs) return false;
    return key == other.key;
  }

  @override
  int get hashCode => key.hashCode;
}

/// generated route for
/// [_i27.SyncedScreen]
class SyncedRoute extends _i28.PageRouteInfo<void> {
  const SyncedRoute({List<_i28.PageRouteInfo>? children})
      : super(SyncedRoute.name, initialChildren: children);

  static const String name = 'SyncedRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i27.SyncedScreen();
    },
  );
}
