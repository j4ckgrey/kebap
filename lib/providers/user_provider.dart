import 'package:chopper/chopper.dart';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:kebap/jellyfin/enum_models.dart';
import 'package:kebap/models/account_model.dart';
import 'package:kebap/models/item_base_model.dart';
import 'package:kebap/models/items/item_shared_models.dart';
import 'package:kebap/models/library_filters_model.dart';
import 'package:kebap/providers/api_provider.dart';
import 'package:kebap/providers/service_provider.dart';
import 'package:kebap/providers/shared_provider.dart';
import 'package:kebap/providers/image_provider.dart';
import 'package:kebap/providers/sync_provider.dart';
import 'package:kebap/providers/video_player_provider.dart';

part 'user_provider.g.dart';

@riverpod
bool showSyncButtonProvider(Ref ref) {
  final userCanSync = ref.watch(userProvider.select((value) => value?.canDownload ?? false));
  final hasSyncedItems = ref.watch(syncProvider.select((value) => value.items.isNotEmpty));
  return userCanSync || hasSyncedItems;
}

@Riverpod(keepAlive: true)
class User extends _$User {
  late final JellyService api = ref.read(jellyApiProvider);

  set userState(AccountModel? account) {
    print('[LAG_DEBUG] UserProvider: userState updated');
    state = account?.copyWith(lastUsed: DateTime.now());
    if (account != null) {
      ref.read(sharedUtilityProvider).updateAccountInfo(account);
    }
  }

  Future<Response<bool>> quickConnect(String pin) async => api.quickConnect(pin);

  Future<Response<AccountModel>?> updateInformation() async {
    if (state == null) return null;
    try {
      var response = await api.usersMeGet();
      var quickConnectStatus = await api.quickConnectEnabled();
      var systemConfiguration = await api.systemConfigurationGet();

      final customConfig = await api.getCustomConfig();

      if (response.isSuccessful && response.body != null) {
        final newTag = response.body?.primaryImageTag;
        final oldTag = state?.avatar; // avatar url contains the old tag usually, but let's check the construct
        print('[LAG_DEBUG] Fetched User Me: ${response.body?.name}, ID: ${response.body?.id}');
        print('[LAG_DEBUG] New PrimaryImageTag: $newTag');
        
        userState = state?.copyWith(
          name: response.body?.name ?? state?.name ?? "",
          policy: response.body?.policy,
          serverConfiguration: systemConfiguration.body,
          userConfiguration: response.body?.configuration,
          quickConnectState: quickConnectStatus.body ?? false,
          latestItemsExcludes: response.body?.configuration?.latestItemsExcludes ?? [],
          userSettings: customConfig.body,
          avatar: ref.read(imageUtilityProvider).getUserImageUrl(
                state?.id ?? "",
                tag: newTag,
              ),
        );
        print('[LAG_DEBUG] UserState updated. New Avatar URL: ${state?.avatar}');
        return response.copyWith(body: state);
      }
    } catch (e) {
      // Log error or ignore
    }
    return null;
  }

  void setRememberAudioSelections() async {
    final newUserConfiguration = await api.updateRememberAudioSelections();
    if (newUserConfiguration != null) {
      userState = state?.copyWith(userConfiguration: newUserConfiguration);
    }
  }

  void setRememberSubtitleSelections() async {
    final newUserConfiguration = await api.updateRememberSubtitleSelections();
    if (newUserConfiguration != null) {
      userState = state?.copyWith(userConfiguration: newUserConfiguration);
    }
  }

  void setBackwardSpeed(int value) {
    final userSettings = state?.userSettings?.copyWith(skipBackDuration: Duration(seconds: value));
    if (userSettings != null) {
      updateCustomConfig(userSettings);
    }
  }

  void setForwardSpeed(int value) {
    final userSettings = state?.userSettings?.copyWith(skipForwardDuration: Duration(seconds: value));
    if (userSettings != null) {
      updateCustomConfig(userSettings);
    }
  }

  Future<Response<dynamic>> updateCustomConfig(UserSettings settings) async {
    print('[LAG_DEBUG] UserProvider: updateCustomConfig');
    state = state?.copyWith(userSettings: settings);
    return api.setCustomConfig(settings);
  }

  Future<Response> refreshMetaData(
    String itemId, {
    MetadataRefresh? metadataRefreshMode,
    bool? replaceAllMetadata,
  }) async {
    return api.itemsItemIdRefreshPost(
      itemId: itemId,
      metadataRefreshMode: metadataRefreshMode,
      imageRefreshMode: metadataRefreshMode,
      replaceAllMetadata: switch (metadataRefreshMode) {
        MetadataRefresh.fullRefresh => false,
        MetadataRefresh.validation => true,
        _ => false,
      },
      replaceAllImages: switch (metadataRefreshMode) {
        MetadataRefresh.fullRefresh => true,
        MetadataRefresh.validation => true,
        _ => false,
      },
    );
  }

  Future<Response<UserData>?> setAsFavorite(bool favorite, String itemId) async {
    final response = await (favorite
        ? api.usersUserIdFavoriteItemsItemIdPost(itemId: itemId)
        : api.usersUserIdFavoriteItemsItemIdDelete(itemId: itemId));
    return Response(response.base, UserData.fromDto(response.body));
  }

  Future<Response<UserData>?> markAsPlayed(bool enable, String itemId) async {
    final response = await (enable
        ? api.usersUserIdPlayedItemsItemIdPost(
            itemId: itemId,
            datePlayed: DateTime.now(),
          )
        : api.usersUserIdPlayedItemsItemIdDelete(
            itemId: itemId,
          ));
    return Response(response.base, UserData.fromDto(response.body));
  }

  void clear() => userState = null;
  void updateUser(AccountModel? user) => userState = user;
  void loginUser(AccountModel? user) => state = user;
  void setAuthMethod(Authentication method) => userState = state?.copyWith(authMethod: method);
  void setLocalURL(String? value) {
    final user = state;
    if (user == null) return;
    state = user.copyWith(
      credentials: user.credentials.copyWith(localUrl: value?.isEmpty == true ? null : value),
    );
  }

  void addSearchQuery(String value) {
    if (value.isEmpty) return;
    final newList = state?.searchQueryHistory.toList() ?? [];
    if (newList.contains(value)) {
      newList.remove(value);
    }
    newList.add(value);
    userState = state?.copyWith(searchQueryHistory: newList);
  }

  void removeSearchQuery(String value) {
    userState = state?.copyWith(
      searchQueryHistory: state?.searchQueryHistory ?? []
        ..remove(value)
        ..take(50),
    );
  }

  void clearSearchQuery() {
    userState = state?.copyWith(searchQueryHistory: []);
  }

  Future<void> logoutUser() async {
    await ref.read(videoPlayerProvider).stop();
    if (state == null) return;
    userState = null;
  }

  Future<void> forceLogoutUser(AccountModel account) async {
    userState = account;
    await api.sessionsLogoutPost();
    userState = null;
  }

  @override
  AccountModel? build() {
    return null;
  }

  void removeFilter(LibraryFiltersModel model) {
    final currentList = ((state?.libraryFilters ?? [])).toList(growable: true);
    currentList.remove(model);
    userState = state?.copyWith(libraryFilters: currentList);
  }

  void saveFilter(LibraryFiltersModel model) {
    final currentList = (state?.libraryFilters ?? []).toList(growable: true);
    if (currentList.firstWhereOrNull((value) => value.id == model.id) != null) {
      userState = state?.copyWith(
          libraryFilters: currentList.map(
        (e) {
          if (e.id == model.id) {
            return model;
          } else {
            return e.copyWith(
              isFavourite: model.isFavourite && model.containsSameIds(e.ids) ? false : e.isFavourite,
            );
          }
        },
      ).toList());
    } else {
      userState = state?.copyWith(libraryFilters: [model, ...currentList]);
    }
  }

  void deleteAllFilters() => userState = state?.copyWith(libraryFilters: []);

  String? createDownloadUrl(ItemBaseModel item) =>
      Uri.encodeFull("${state?.credentials.url}/Items/${item.id}/Download?api_key=${state?.credentials.token}");
}
