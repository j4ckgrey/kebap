import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kebap/models/book_model.dart';
import 'package:kebap/models/item_base_model.dart';
import 'package:kebap/models/items/photos_model.dart';
import 'package:kebap/models/media_playback_model.dart';
import 'package:kebap/models/playback/playback_model.dart';
import 'package:kebap/providers/api_provider.dart';
import 'package:kebap/providers/book_viewer_provider.dart';
import 'package:kebap/providers/items/book_details_provider.dart';
import 'package:kebap/providers/video_player_provider.dart';
import 'package:kebap/routes/auto_router.gr.dart';
import 'package:kebap/screens/book_viewer/book_viewer_screen.dart';
import 'package:kebap/screens/shared/kebap_snackbar.dart';
import 'package:kebap/util/adaptive_layout/adaptive_layout.dart';
import 'package:kebap/util/list_extensions.dart';
import 'package:kebap/util/localization_helper.dart';
import 'package:kebap/util/refresh_state.dart';
import 'package:kebap/widgets/full_screen_helpers/full_screen_wrapper.dart';

Future<void> _showLoadingIndicator(BuildContext context) async {
  return showDialog(
    barrierDismissible: kDebugMode,
    useRootNavigator: true,
    context: context,
    builder: (context) => const LoadIndicator(),
  );
}

class LoadIndicator extends StatelessWidget {
  const LoadIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(strokeCap: StrokeCap.round),
            const SizedBox(width: 70),
            Text(
              context.localized.loading,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(width: 20),
          ],
        ),
      ),
    );
  }
}

Future<void> _playVideo(
  BuildContext context, {
  required PlaybackModel? current,
  Duration? startPosition,
  List<ItemBaseModel>? queue,
  required WidgetRef ref,
  VoidCallback? onPlayerExit,
}) async {
  if (current == null) {
    if (context.mounted) {
      Navigator.of(context, rootNavigator: true).pop();
      kebapSnackbar(context, title: context.localized.unableToPlayMedia);
    }
    return;
  }

  final currentStartDuration = await current.startDuration();
  final actualStartPosition = startPosition ?? currentStartDuration ?? Duration.zero;
  
  print('[_playVideo] startPosition param: ${startPosition?.inSeconds}s, current.startDuration(): ${currentStartDuration?.inSeconds}s, actualStartPosition: ${actualStartPosition.inSeconds}s');

  final loadedCorrectly = await ref.read(videoPlayerProvider.notifier).loadPlaybackItem(
        current,
        actualStartPosition,
      );

  if (!loadedCorrectly) {
    if (context.mounted) {
      Navigator.of(context, rootNavigator: true).pop();
      kebapSnackbar(context, title: context.localized.errorOpeningMedia);
    }
    return;
  }

  //Pop loading screen
  Navigator.of(context, rootNavigator: true).pop();

  ref.read(mediaPlaybackProvider.notifier).update((state) => state.copyWith(state: VideoPlayerState.fullScreen));

  await ref.read(videoPlayerProvider.notifier).openPlayer(context);
  if (AdaptiveLayout.of(context).isDesktop) {
    try {
      fullScreenHelper.closeFullScreen(ref);
    } catch (_) {}
  }

  if (context.mounted) {
    log("Finished refreshing");
    await context.refreshData();
  }

  onPlayerExit?.call();
}

extension BookBaseModelExtension on BookModel? {
  Future<void> play(
    BuildContext context,
    WidgetRef ref, {
    int? currentPage,
    AutoDisposeStateNotifierProvider<BookDetailsProviderNotifier, BookProviderModel>? provider,
    BuildContext? parentContext,
  }) async {
    if (kIsWeb) {
      kebapSnackbar(context, title: context.localized.unableToPlayBooksOnWeb);
      return;
    }
    if (this == null) {
      return;
    }
    var newProvider = provider;

    if (newProvider == null) {
      newProvider = bookDetailsProvider(this?.id ?? "");
      await ref.watch(bookDetailsProvider(this?.id ?? "").notifier).fetchDetails(this!);
    }

    ref.read(bookViewerProvider.notifier).fetchBook(this);
    await openBookViewer(
      context,
      newProvider,
      initialPage: currentPage ?? this?.currentPage,
    );
    parentContext?.refreshData();
    if (context.mounted) {
      await context.refreshData();
    }
  }
}

extension PhotoAlbumExtension on PhotoAlbumModel? {
  Future<void> play(
    BuildContext context,
    WidgetRef ref, {
    int? currentPage,
    AutoDisposeStateNotifierProvider<BookDetailsProviderNotifier, BookProviderModel>? provider,
    BuildContext? parentContext,
  }) async {
    _showLoadingIndicator(context);

    final albumModel = this;
    if (albumModel == null) return;
    final api = ref.read(jellyApiProvider);
    final getChildItems = await api.itemsGet(
        parentId: albumModel.id,
        includeItemTypes: KebapItemType.galleryItem.map((e) => e.dtoKind).toList(),
        recursive: true);
    final photos = getChildItems.body?.items.whereType<PhotoModel>() ?? [];

    Navigator.of(context, rootNavigator: true).pop();

    if (photos.isEmpty) {
      return;
    }

    await context.pushRoute(PhotoViewerRoute(
      items: photos.toList(),
    ));

    if (context.mounted) {
      await context.refreshData();
    }
    return;
  }
}

extension ItemBaseModelExtensions on ItemBaseModel? {
  Future<void> play(
    BuildContext context,
    WidgetRef ref, {
    Duration? startPosition,
    bool showPlaybackOption = false,
  }) async =>
      switch (this) {
        PhotoAlbumModel album => album.play(context, ref),
        BookModel book => book.play(context, ref),
        _ => _default(context, this, ref, startPosition: startPosition, showPlaybackOption: showPlaybackOption),
      };

  Future<void> _default(
    BuildContext context,
    ItemBaseModel? itemModel,
    WidgetRef ref, {
    Duration? startPosition,
    bool showPlaybackOption = false,
  }) async {
    print("[ItemBaseModelExtensions] _default called for item: ${itemModel?.name} (ID: ${itemModel?.id})");
    if (itemModel == null) {
      print("[ItemBaseModelExtensions] Item model is null, returning.");
      return;
    }

    _showLoadingIndicator(context);

    Duration? actualStartPosition = startPosition;
    // If we are resuming (startPosition is null) and not showing options, trust the client's current item state for position
    // This fixes issues where the server re-fetch returns 0 progress for remote/sync items
    if (actualStartPosition == null && !showPlaybackOption && itemModel.userData.playbackPositionTicks > 0) {
      actualStartPosition = itemModel.userData.playBackPosition;
      print("[ItemBaseModelExtensions] Using client-side resume position: ${actualStartPosition?.inSeconds}s (from playbackPositionTicks: ${itemModel.userData.playbackPositionTicks})");
    } else {
      print("[ItemBaseModelExtensions] StartPosition: ${actualStartPosition?.inSeconds}s, showPlaybackOption: $showPlaybackOption, playbackPositionTicks: ${itemModel.userData.playbackPositionTicks}");
    }

    print("[ItemBaseModelExtensions] Calling createPlaybackModel...");
    PlaybackModel? model = await ref.read(playbackModelHelper).createPlaybackModel(
          context,
          itemModel,
          showPlaybackOptions: showPlaybackOption,
          startPosition: actualStartPosition,
        );
    print("[ItemBaseModelExtensions] createPlaybackModel returned: ${model != null ? 'Model found' : 'Null'}");

    await _playVideo(context, startPosition: actualStartPosition, current: model, ref: ref);
  }
}

extension ItemBaseModelsBooleans on List<ItemBaseModel> {
  Future<void> playLibraryItems(BuildContext context, WidgetRef ref, {bool shuffle = false}) async {
    if (isEmpty) return;

    _showLoadingIndicator(context);

    // Replace all shows/seasons with all episodes
    List<List<ItemBaseModel>> newList = await Future.wait(map((element) async {
      switch (element.type) {
        case KebapItemType.series:
          return await ref.read(jellyApiProvider).fetchEpisodeFromShow(seriesId: element.id);
        default:
          return [element];
      }
    }));

    var expandedList =
        newList.expand((element) => element).toList().where((element) => element.playAble).toList().uniqueBy(
              (value) => value.id,
            );

    if (shuffle) {
      expandedList.shuffle();
    }

    PlaybackModel? model = await ref.read(playbackModelHelper).createPlaybackModel(
          context,
          expandedList.firstOrNull,
          libraryQueue: expandedList,
        );

    if (context.mounted) {
      await _playVideo(context, ref: ref, queue: expandedList, current: model);
      if (context.mounted) {
        RefreshState.maybeOf(context)?.refresh();
      }
    }
  }
}
