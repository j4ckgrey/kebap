// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i48;

import 'package:auto_route/auto_route.dart' as _i40;
import 'package:collection/collection.dart' as _i46;
import 'package:flutter/foundation.dart' as _i44;
import 'package:flutter/material.dart' as _i41;
import 'package:kebap/jellyfin/jellyfin_open_api.swagger.dart' as _i42;
import 'package:kebap/models/item_base_model.dart' as _i43;
import 'package:kebap/models/items/photos_model.dart' as _i47;
import 'package:kebap/models/library_search/library_search_options.dart'
    as _i45;
import 'package:kebap/routes/nested_details_screen.dart' as _i20;
import 'package:kebap/screens/admin/admin_activity_screen.dart' as _i2;
import 'package:kebap/screens/admin/admin_branding_screen.dart' as _i3;
import 'package:kebap/screens/admin/admin_dashboard_screen.dart' as _i4;
import 'package:kebap/screens/admin/admin_general_screen.dart' as _i6;
import 'package:kebap/screens/admin/admin_library_detail_screen.dart' as _i7;
import 'package:kebap/screens/admin/admin_placeholder_screens.dart' as _i5;
import 'package:kebap/screens/admin/admin_resume_screen.dart' as _i8;
import 'package:kebap/screens/admin/admin_selection_screen.dart' as _i9;
import 'package:kebap/screens/admin/admin_streaming_screen.dart' as _i10;
import 'package:kebap/screens/admin/admin_task_detail_screen.dart' as _i11;
import 'package:kebap/screens/admin/admin_transcoding_screen.dart' as _i12;
import 'package:kebap/screens/admin/admin_trickplay_screen.dart' as _i13;
import 'package:kebap/screens/admin/admin_user_edit_screen.dart' as _i14;
import 'package:kebap/screens/dashboard/dashboard_screen.dart' as _i18;
import 'package:kebap/screens/favourites/favourites_screen.dart' as _i23;
import 'package:kebap/screens/home_screen.dart' as _i25;
import 'package:kebap/screens/library/library_screen.dart' as _i28;
import 'package:kebap/screens/library_search/library_search_screen.dart'
    as _i29;
import 'package:kebap/screens/login/lock_screen.dart' as _i30;
import 'package:kebap/screens/login/login_screen.dart' as _i31;
import 'package:kebap/screens/photo_viewer/photo_viewer_screen.dart' as _i32;
import 'package:kebap/screens/requests_screen.dart' as _i35;
import 'package:kebap/screens/settings/about_settings_page.dart' as _i1;
import 'package:kebap/screens/settings/advanced_settings_page.dart' as _i15;
import 'package:kebap/screens/settings/client_settings_page.dart' as _i16;
import 'package:kebap/screens/settings/content_filter_settings_page.dart'
    as _i17;
import 'package:kebap/screens/settings/dashboard_settings_page.dart' as _i19;
import 'package:kebap/screens/settings/details_settings_page.dart' as _i21;
import 'package:kebap/screens/settings/downloads_settings_page.dart' as _i22;
import 'package:kebap/screens/settings/general_ui_settings_page.dart' as _i24;
import 'package:kebap/screens/settings/kebap_settings_page.dart' as _i26;
import 'package:kebap/screens/settings/libraries_settings_page.dart' as _i27;
import 'package:kebap/screens/settings/player_settings_page.dart' as _i33;
import 'package:kebap/screens/settings/profile_settings_page.dart' as _i34;
import 'package:kebap/screens/settings/settings_screen.dart' as _i36;
import 'package:kebap/screens/settings/settings_selection_screen.dart' as _i37;
import 'package:kebap/screens/splash_screen.dart' as _i38;
import 'package:kebap/screens/syncing/synced_screen.dart' as _i39;

/// generated route for
/// [_i1.AboutSettingsPage]
class AboutSettingsRoute extends _i40.PageRouteInfo<void> {
  const AboutSettingsRoute({List<_i40.PageRouteInfo>? children})
      : super(AboutSettingsRoute.name, initialChildren: children);

  static const String name = 'AboutSettingsRoute';

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      return const _i1.AboutSettingsPage();
    },
  );
}

/// generated route for
/// [_i2.AdminActivityScreen]
class AdminActivityRoute extends _i40.PageRouteInfo<void> {
  const AdminActivityRoute({List<_i40.PageRouteInfo>? children})
      : super(AdminActivityRoute.name, initialChildren: children);

  static const String name = 'AdminActivityRoute';

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      return const _i2.AdminActivityScreen();
    },
  );
}

/// generated route for
/// [_i3.AdminBrandingScreen]
class AdminBrandingRoute extends _i40.PageRouteInfo<void> {
  const AdminBrandingRoute({List<_i40.PageRouteInfo>? children})
      : super(AdminBrandingRoute.name, initialChildren: children);

  static const String name = 'AdminBrandingRoute';

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      return const _i3.AdminBrandingScreen();
    },
  );
}

/// generated route for
/// [_i4.AdminDashboardScreen]
class AdminDashboardRoute extends _i40.PageRouteInfo<void> {
  const AdminDashboardRoute({List<_i40.PageRouteInfo>? children})
      : super(AdminDashboardRoute.name, initialChildren: children);

  static const String name = 'AdminDashboardRoute';

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      return const _i4.AdminDashboardScreen();
    },
  );
}

/// generated route for
/// [_i5.AdminDevicesScreen]
class AdminDevicesRoute extends _i40.PageRouteInfo<void> {
  const AdminDevicesRoute({List<_i40.PageRouteInfo>? children})
      : super(AdminDevicesRoute.name, initialChildren: children);

  static const String name = 'AdminDevicesRoute';

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      return const _i5.AdminDevicesScreen();
    },
  );
}

/// generated route for
/// [_i5.AdminDisplayScreen]
class AdminDisplayRoute extends _i40.PageRouteInfo<void> {
  const AdminDisplayRoute({List<_i40.PageRouteInfo>? children})
      : super(AdminDisplayRoute.name, initialChildren: children);

  static const String name = 'AdminDisplayRoute';

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      return const _i5.AdminDisplayScreen();
    },
  );
}

/// generated route for
/// [_i6.AdminGeneralScreen]
class AdminGeneralRoute extends _i40.PageRouteInfo<void> {
  const AdminGeneralRoute({List<_i40.PageRouteInfo>? children})
      : super(AdminGeneralRoute.name, initialChildren: children);

  static const String name = 'AdminGeneralRoute';

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      return const _i6.AdminGeneralScreen();
    },
  );
}

/// generated route for
/// [_i5.AdminLibrariesScreen]
class AdminLibrariesRoute extends _i40.PageRouteInfo<void> {
  const AdminLibrariesRoute({List<_i40.PageRouteInfo>? children})
      : super(AdminLibrariesRoute.name, initialChildren: children);

  static const String name = 'AdminLibrariesRoute';

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      return const _i5.AdminLibrariesScreen();
    },
  );
}

/// generated route for
/// [_i7.AdminLibraryDetailScreen]
class AdminLibraryDetailRoute
    extends _i40.PageRouteInfo<AdminLibraryDetailRouteArgs> {
  AdminLibraryDetailRoute({
    _i41.Key? key,
    required String libraryId,
    String? libraryName,
    List<_i40.PageRouteInfo>? children,
  }) : super(
          AdminLibraryDetailRoute.name,
          args: AdminLibraryDetailRouteArgs(
            key: key,
            libraryId: libraryId,
            libraryName: libraryName,
          ),
          rawPathParams: {'libraryId': libraryId},
          rawQueryParams: {'name': libraryName},
          initialChildren: children,
        );

  static const String name = 'AdminLibraryDetailRoute';

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final queryParams = data.queryParams;
      final args = data.argsAs<AdminLibraryDetailRouteArgs>(
        orElse: () => AdminLibraryDetailRouteArgs(
          libraryId: pathParams.getString('libraryId'),
          libraryName: queryParams.optString('name'),
        ),
      );
      return _i7.AdminLibraryDetailScreen(
        key: args.key,
        libraryId: args.libraryId,
        libraryName: args.libraryName,
      );
    },
  );
}

class AdminLibraryDetailRouteArgs {
  const AdminLibraryDetailRouteArgs({
    this.key,
    required this.libraryId,
    this.libraryName,
  });

  final _i41.Key? key;

  final String libraryId;

  final String? libraryName;

  @override
  String toString() {
    return 'AdminLibraryDetailRouteArgs{key: $key, libraryId: $libraryId, libraryName: $libraryName}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AdminLibraryDetailRouteArgs) return false;
    return key == other.key &&
        libraryId == other.libraryId &&
        libraryName == other.libraryName;
  }

  @override
  int get hashCode => key.hashCode ^ libraryId.hashCode ^ libraryName.hashCode;
}

/// generated route for
/// [_i5.AdminMetadataScreen]
class AdminMetadataRoute extends _i40.PageRouteInfo<void> {
  const AdminMetadataRoute({List<_i40.PageRouteInfo>? children})
      : super(AdminMetadataRoute.name, initialChildren: children);

  static const String name = 'AdminMetadataRoute';

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      return const _i5.AdminMetadataScreen();
    },
  );
}

/// generated route for
/// [_i5.AdminNfoScreen]
class AdminNfoRoute extends _i40.PageRouteInfo<void> {
  const AdminNfoRoute({List<_i40.PageRouteInfo>? children})
      : super(AdminNfoRoute.name, initialChildren: children);

  static const String name = 'AdminNfoRoute';

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      return const _i5.AdminNfoScreen();
    },
  );
}

/// generated route for
/// [_i8.AdminResumeScreen]
class AdminResumeRoute extends _i40.PageRouteInfo<void> {
  const AdminResumeRoute({List<_i40.PageRouteInfo>? children})
      : super(AdminResumeRoute.name, initialChildren: children);

  static const String name = 'AdminResumeRoute';

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      return const _i8.AdminResumeScreen();
    },
  );
}

/// generated route for
/// [_i9.AdminSelectionScreen]
class AdminSelectionRoute extends _i40.PageRouteInfo<void> {
  const AdminSelectionRoute({List<_i40.PageRouteInfo>? children})
      : super(AdminSelectionRoute.name, initialChildren: children);

  static const String name = 'AdminSelectionRoute';

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      return const _i9.AdminSelectionScreen();
    },
  );
}

/// generated route for
/// [_i5.AdminSessionsScreen]
class AdminSessionsRoute extends _i40.PageRouteInfo<void> {
  const AdminSessionsRoute({List<_i40.PageRouteInfo>? children})
      : super(AdminSessionsRoute.name, initialChildren: children);

  static const String name = 'AdminSessionsRoute';

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      return const _i5.AdminSessionsScreen();
    },
  );
}

/// generated route for
/// [_i10.AdminStreamingScreen]
class AdminStreamingRoute extends _i40.PageRouteInfo<void> {
  const AdminStreamingRoute({List<_i40.PageRouteInfo>? children})
      : super(AdminStreamingRoute.name, initialChildren: children);

  static const String name = 'AdminStreamingRoute';

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      return const _i10.AdminStreamingScreen();
    },
  );
}

/// generated route for
/// [_i11.AdminTaskDetailScreen]
class AdminTaskDetailRoute
    extends _i40.PageRouteInfo<AdminTaskDetailRouteArgs> {
  AdminTaskDetailRoute({
    _i41.Key? key,
    required String taskId,
    List<_i40.PageRouteInfo>? children,
  }) : super(
          AdminTaskDetailRoute.name,
          args: AdminTaskDetailRouteArgs(key: key, taskId: taskId),
          rawPathParams: {'taskId': taskId},
          initialChildren: children,
        );

  static const String name = 'AdminTaskDetailRoute';

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<AdminTaskDetailRouteArgs>(
        orElse: () =>
            AdminTaskDetailRouteArgs(taskId: pathParams.getString('taskId')),
      );
      return _i11.AdminTaskDetailScreen(key: args.key, taskId: args.taskId);
    },
  );
}

class AdminTaskDetailRouteArgs {
  const AdminTaskDetailRouteArgs({this.key, required this.taskId});

  final _i41.Key? key;

  final String taskId;

  @override
  String toString() {
    return 'AdminTaskDetailRouteArgs{key: $key, taskId: $taskId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AdminTaskDetailRouteArgs) return false;
    return key == other.key && taskId == other.taskId;
  }

  @override
  int get hashCode => key.hashCode ^ taskId.hashCode;
}

/// generated route for
/// [_i5.AdminTasksScreen]
class AdminTasksRoute extends _i40.PageRouteInfo<void> {
  const AdminTasksRoute({List<_i40.PageRouteInfo>? children})
      : super(AdminTasksRoute.name, initialChildren: children);

  static const String name = 'AdminTasksRoute';

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      return const _i5.AdminTasksScreen();
    },
  );
}

/// generated route for
/// [_i12.AdminTranscodingScreen]
class AdminTranscodingRoute extends _i40.PageRouteInfo<void> {
  const AdminTranscodingRoute({List<_i40.PageRouteInfo>? children})
      : super(AdminTranscodingRoute.name, initialChildren: children);

  static const String name = 'AdminTranscodingRoute';

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      return const _i12.AdminTranscodingScreen();
    },
  );
}

/// generated route for
/// [_i13.AdminTrickplayScreen]
class AdminTrickplayRoute extends _i40.PageRouteInfo<void> {
  const AdminTrickplayRoute({List<_i40.PageRouteInfo>? children})
      : super(AdminTrickplayRoute.name, initialChildren: children);

  static const String name = 'AdminTrickplayRoute';

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      return const _i13.AdminTrickplayScreen();
    },
  );
}

/// generated route for
/// [_i14.AdminUserEditScreen]
class AdminUserEditRoute extends _i40.PageRouteInfo<AdminUserEditRouteArgs> {
  AdminUserEditRoute({
    _i41.Key? key,
    required _i42.UserDto user,
    List<_i40.PageRouteInfo>? children,
  }) : super(
          AdminUserEditRoute.name,
          args: AdminUserEditRouteArgs(key: key, user: user),
          initialChildren: children,
        );

  static const String name = 'AdminUserEditRoute';

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AdminUserEditRouteArgs>();
      return _i14.AdminUserEditScreen(key: args.key, user: args.user);
    },
  );
}

class AdminUserEditRouteArgs {
  const AdminUserEditRouteArgs({this.key, required this.user});

  final _i41.Key? key;

  final _i42.UserDto user;

  @override
  String toString() {
    return 'AdminUserEditRouteArgs{key: $key, user: $user}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AdminUserEditRouteArgs) return false;
    return key == other.key && user == other.user;
  }

  @override
  int get hashCode => key.hashCode ^ user.hashCode;
}

/// generated route for
/// [_i5.AdminUsersScreen]
class AdminUsersRoute extends _i40.PageRouteInfo<void> {
  const AdminUsersRoute({List<_i40.PageRouteInfo>? children})
      : super(AdminUsersRoute.name, initialChildren: children);

  static const String name = 'AdminUsersRoute';

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      return const _i5.AdminUsersScreen();
    },
  );
}

/// generated route for
/// [_i15.AdvancedSettingsPage]
class AdvancedSettingsRoute extends _i40.PageRouteInfo<void> {
  const AdvancedSettingsRoute({List<_i40.PageRouteInfo>? children})
      : super(AdvancedSettingsRoute.name, initialChildren: children);

  static const String name = 'AdvancedSettingsRoute';

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      return const _i15.AdvancedSettingsPage();
    },
  );
}

/// generated route for
/// [_i16.ClientSettingsPage]
class ClientSettingsRoute extends _i40.PageRouteInfo<void> {
  const ClientSettingsRoute({List<_i40.PageRouteInfo>? children})
      : super(ClientSettingsRoute.name, initialChildren: children);

  static const String name = 'ClientSettingsRoute';

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      return const _i16.ClientSettingsPage();
    },
  );
}

/// generated route for
/// [_i17.ContentFilterSettingsPage]
class ContentFilterSettingsRoute extends _i40.PageRouteInfo<void> {
  const ContentFilterSettingsRoute({List<_i40.PageRouteInfo>? children})
      : super(ContentFilterSettingsRoute.name, initialChildren: children);

  static const String name = 'ContentFilterSettingsRoute';

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      return const _i17.ContentFilterSettingsPage();
    },
  );
}

/// generated route for
/// [_i18.DashboardScreen]
class DashboardRoute extends _i40.PageRouteInfo<void> {
  const DashboardRoute({List<_i40.PageRouteInfo>? children})
      : super(DashboardRoute.name, initialChildren: children);

  static const String name = 'DashboardRoute';

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      return const _i18.DashboardScreen();
    },
  );
}

/// generated route for
/// [_i19.DashboardSettingsPage]
class DashboardSettingsRoute extends _i40.PageRouteInfo<void> {
  const DashboardSettingsRoute({List<_i40.PageRouteInfo>? children})
      : super(DashboardSettingsRoute.name, initialChildren: children);

  static const String name = 'DashboardSettingsRoute';

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      return const _i19.DashboardSettingsPage();
    },
  );
}

/// generated route for
/// [_i20.DetailsScreen]
class DetailsRoute extends _i40.PageRouteInfo<DetailsRouteArgs> {
  DetailsRoute({
    String id = '',
    _i43.ItemBaseModel? item,
    Object? tag,
    _i44.Key? key,
    List<_i40.PageRouteInfo>? children,
  }) : super(
          DetailsRoute.name,
          args: DetailsRouteArgs(id: id, item: item, tag: tag, key: key),
          rawQueryParams: {'id': id},
          initialChildren: children,
        );

  static const String name = 'DetailsRoute';

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      final queryParams = data.queryParams;
      final args = data.argsAs<DetailsRouteArgs>(
        orElse: () => DetailsRouteArgs(id: queryParams.getString('id', '')),
      );
      return _i20.DetailsScreen(
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

  final _i43.ItemBaseModel? item;

  final Object? tag;

  final _i44.Key? key;

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
/// [_i21.DetailsSettingsPage]
class DetailsSettingsRoute extends _i40.PageRouteInfo<void> {
  const DetailsSettingsRoute({List<_i40.PageRouteInfo>? children})
      : super(DetailsSettingsRoute.name, initialChildren: children);

  static const String name = 'DetailsSettingsRoute';

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      return const _i21.DetailsSettingsPage();
    },
  );
}

/// generated route for
/// [_i22.DownloadsSettingsPage]
class DownloadsSettingsRoute extends _i40.PageRouteInfo<void> {
  const DownloadsSettingsRoute({List<_i40.PageRouteInfo>? children})
      : super(DownloadsSettingsRoute.name, initialChildren: children);

  static const String name = 'DownloadsSettingsRoute';

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      return const _i22.DownloadsSettingsPage();
    },
  );
}

/// generated route for
/// [_i23.FavouritesScreen]
class FavouritesRoute extends _i40.PageRouteInfo<void> {
  const FavouritesRoute({List<_i40.PageRouteInfo>? children})
      : super(FavouritesRoute.name, initialChildren: children);

  static const String name = 'FavouritesRoute';

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      return const _i23.FavouritesScreen();
    },
  );
}

/// generated route for
/// [_i24.GeneralUiSettingsPage]
class GeneralUiSettingsRoute extends _i40.PageRouteInfo<void> {
  const GeneralUiSettingsRoute({List<_i40.PageRouteInfo>? children})
      : super(GeneralUiSettingsRoute.name, initialChildren: children);

  static const String name = 'GeneralUiSettingsRoute';

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      return const _i24.GeneralUiSettingsPage();
    },
  );
}

/// generated route for
/// [_i25.HomeScreen]
class HomeRoute extends _i40.PageRouteInfo<void> {
  const HomeRoute({List<_i40.PageRouteInfo>? children})
      : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      return const _i25.HomeScreen();
    },
  );
}

/// generated route for
/// [_i26.KebapSettingsPage]
class KebapSettingsRoute extends _i40.PageRouteInfo<void> {
  const KebapSettingsRoute({List<_i40.PageRouteInfo>? children})
      : super(KebapSettingsRoute.name, initialChildren: children);

  static const String name = 'KebapSettingsRoute';

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      return const _i26.KebapSettingsPage();
    },
  );
}

/// generated route for
/// [_i27.LibrariesSettingsPage]
class LibrariesSettingsRoute extends _i40.PageRouteInfo<void> {
  const LibrariesSettingsRoute({List<_i40.PageRouteInfo>? children})
      : super(LibrariesSettingsRoute.name, initialChildren: children);

  static const String name = 'LibrariesSettingsRoute';

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      return const _i27.LibrariesSettingsPage();
    },
  );
}

/// generated route for
/// [_i28.LibraryScreen]
class LibraryRoute extends _i40.PageRouteInfo<void> {
  const LibraryRoute({List<_i40.PageRouteInfo>? children})
      : super(LibraryRoute.name, initialChildren: children);

  static const String name = 'LibraryRoute';

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      return const _i28.LibraryScreen();
    },
  );
}

/// generated route for
/// [_i29.LibrarySearchScreen]
class LibrarySearchRoute extends _i40.PageRouteInfo<LibrarySearchRouteArgs> {
  LibrarySearchRoute({
    String? viewModelId,
    List<String>? folderId,
    bool? favourites,
    _i45.SortingOrder? sortOrder,
    _i45.SortingOptions? sortingOptions,
    Map<_i43.KebapItemType, bool>? types,
    Map<String, bool>? genres,
    bool? recursive,
    _i44.Key? key,
    List<_i40.PageRouteInfo>? children,
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

  static _i40.PageInfo page = _i40.PageInfo(
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
      return _i29.LibrarySearchScreen(
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

  final _i45.SortingOrder? sortOrder;

  final _i45.SortingOptions? sortingOptions;

  final Map<_i43.KebapItemType, bool>? types;

  final Map<String, bool>? genres;

  final bool? recursive;

  final _i44.Key? key;

  @override
  String toString() {
    return 'LibrarySearchRouteArgs{viewModelId: $viewModelId, folderId: $folderId, favourites: $favourites, sortOrder: $sortOrder, sortingOptions: $sortingOptions, types: $types, genres: $genres, recursive: $recursive, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! LibrarySearchRouteArgs) return false;
    return viewModelId == other.viewModelId &&
        const _i46.ListEquality().equals(folderId, other.folderId) &&
        favourites == other.favourites &&
        sortOrder == other.sortOrder &&
        sortingOptions == other.sortingOptions &&
        const _i46.MapEquality().equals(types, other.types) &&
        const _i46.MapEquality().equals(genres, other.genres) &&
        recursive == other.recursive &&
        key == other.key;
  }

  @override
  int get hashCode =>
      viewModelId.hashCode ^
      const _i46.ListEquality().hash(folderId) ^
      favourites.hashCode ^
      sortOrder.hashCode ^
      sortingOptions.hashCode ^
      const _i46.MapEquality().hash(types) ^
      const _i46.MapEquality().hash(genres) ^
      recursive.hashCode ^
      key.hashCode;
}

/// generated route for
/// [_i30.LockScreen]
class LockRoute extends _i40.PageRouteInfo<void> {
  const LockRoute({List<_i40.PageRouteInfo>? children})
      : super(LockRoute.name, initialChildren: children);

  static const String name = 'LockRoute';

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      return const _i30.LockScreen();
    },
  );
}

/// generated route for
/// [_i31.LoginScreen]
class LoginRoute extends _i40.PageRouteInfo<void> {
  const LoginRoute({List<_i40.PageRouteInfo>? children})
      : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      return const _i31.LoginScreen();
    },
  );
}

/// generated route for
/// [_i32.PhotoViewerScreen]
class PhotoViewerRoute extends _i40.PageRouteInfo<PhotoViewerRouteArgs> {
  PhotoViewerRoute({
    List<_i47.PhotoModel>? items,
    String? selected,
    _i48.Future<List<_i47.PhotoModel>>? loadingItems,
    _i41.Key? key,
    List<_i40.PageRouteInfo>? children,
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

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      final queryParams = data.queryParams;
      final args = data.argsAs<PhotoViewerRouteArgs>(
        orElse: () =>
            PhotoViewerRouteArgs(selected: queryParams.optString('selectedId')),
      );
      return _i32.PhotoViewerScreen(
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

  final List<_i47.PhotoModel>? items;

  final String? selected;

  final _i48.Future<List<_i47.PhotoModel>>? loadingItems;

  final _i41.Key? key;

  @override
  String toString() {
    return 'PhotoViewerRouteArgs{items: $items, selected: $selected, loadingItems: $loadingItems, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PhotoViewerRouteArgs) return false;
    return const _i46.ListEquality().equals(items, other.items) &&
        selected == other.selected &&
        loadingItems == other.loadingItems &&
        key == other.key;
  }

  @override
  int get hashCode =>
      const _i46.ListEquality().hash(items) ^
      selected.hashCode ^
      loadingItems.hashCode ^
      key.hashCode;
}

/// generated route for
/// [_i33.PlayerSettingsPage]
class PlayerSettingsRoute extends _i40.PageRouteInfo<void> {
  const PlayerSettingsRoute({List<_i40.PageRouteInfo>? children})
      : super(PlayerSettingsRoute.name, initialChildren: children);

  static const String name = 'PlayerSettingsRoute';

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      return const _i33.PlayerSettingsPage();
    },
  );
}

/// generated route for
/// [_i34.ProfileSettingsPage]
class ProfileSettingsRoute extends _i40.PageRouteInfo<void> {
  const ProfileSettingsRoute({List<_i40.PageRouteInfo>? children})
      : super(ProfileSettingsRoute.name, initialChildren: children);

  static const String name = 'ProfileSettingsRoute';

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      return const _i34.ProfileSettingsPage();
    },
  );
}

/// generated route for
/// [_i35.RequestsScreen]
class RequestsRoute extends _i40.PageRouteInfo<void> {
  const RequestsRoute({List<_i40.PageRouteInfo>? children})
      : super(RequestsRoute.name, initialChildren: children);

  static const String name = 'RequestsRoute';

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      return const _i35.RequestsScreen();
    },
  );
}

/// generated route for
/// [_i36.SettingsScreen]
class SettingsRoute extends _i40.PageRouteInfo<void> {
  const SettingsRoute({List<_i40.PageRouteInfo>? children})
      : super(SettingsRoute.name, initialChildren: children);

  static const String name = 'SettingsRoute';

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      return const _i36.SettingsScreen();
    },
  );
}

/// generated route for
/// [_i37.SettingsSelectionScreen]
class SettingsSelectionRoute extends _i40.PageRouteInfo<void> {
  const SettingsSelectionRoute({List<_i40.PageRouteInfo>? children})
      : super(SettingsSelectionRoute.name, initialChildren: children);

  static const String name = 'SettingsSelectionRoute';

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      return const _i37.SettingsSelectionScreen();
    },
  );
}

/// generated route for
/// [_i38.SplashScreen]
class SplashRoute extends _i40.PageRouteInfo<SplashRouteArgs> {
  SplashRoute({
    dynamic Function(bool)? loggedIn,
    _i41.Key? key,
    List<_i40.PageRouteInfo>? children,
  }) : super(
          SplashRoute.name,
          args: SplashRouteArgs(loggedIn: loggedIn, key: key),
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SplashRouteArgs>(
        orElse: () => const SplashRouteArgs(),
      );
      return _i38.SplashScreen(loggedIn: args.loggedIn, key: args.key);
    },
  );
}

class SplashRouteArgs {
  const SplashRouteArgs({this.loggedIn, this.key});

  final dynamic Function(bool)? loggedIn;

  final _i41.Key? key;

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
/// [_i39.SyncedScreen]
class SyncedRoute extends _i40.PageRouteInfo<void> {
  const SyncedRoute({List<_i40.PageRouteInfo>? children})
      : super(SyncedRoute.name, initialChildren: children);

  static const String name = 'SyncedRoute';

  static _i40.PageInfo page = _i40.PageInfo(
    name,
    builder: (data) {
      return const _i39.SyncedScreen();
    },
  );
}
