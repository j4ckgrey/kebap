import 'dart:developer';

import 'package:flutter/material.dart' hide ConnectionState;

import 'package:background_downloader/background_downloader.dart';
import 'package:chopper/chopper.dart';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';

import 'package:kebap/jellyfin/jellyfin_open_api.swagger.dart';
import 'package:kebap/jellyfin/enum_models.dart';
import 'package:kebap/models/item_base_model.dart';
import 'package:kebap/models/items/chapters_model.dart';
import 'package:kebap/models/items/episode_model.dart';
import 'package:kebap/models/items/item_shared_models.dart';
import 'package:kebap/models/items/media_segments_model.dart';
import 'package:kebap/models/items/media_streams_model.dart';
import 'package:kebap/models/items/season_model.dart';
import 'package:kebap/models/items/series_model.dart';
import 'package:kebap/models/items/trick_play_model.dart';
import 'package:kebap/models/playback/direct_playback_model.dart';
import 'package:kebap/models/playback/offline_playback_model.dart';
import 'package:kebap/models/playback/playback_options_dialogue.dart';
import 'package:kebap/models/playback/transcode_playback_model.dart';
import 'package:kebap/models/settings/video_player_settings.dart';
import 'package:kebap/models/syncing/sync_item.dart';
import 'package:kebap/models/video_stream_model.dart';
import 'package:kebap/profiles/default_profile.dart';
import 'package:kebap/providers/api_provider.dart';
import 'package:kebap/providers/connectivity_provider.dart';
import 'package:kebap/providers/service_provider.dart';
import 'package:kebap/providers/settings/video_player_settings_provider.dart';
import 'package:kebap/providers/sync_provider.dart';
import 'package:kebap/providers/user_provider.dart';
import 'package:kebap/providers/video_player_provider.dart';
import 'package:kebap/util/bitrate_helper.dart';
import 'package:kebap/util/duration_extensions.dart';
import 'package:kebap/util/list_extensions.dart';
import 'package:kebap/util/map_bool_helper.dart';
import 'package:kebap/util/streams_selection.dart';
import 'package:kebap/wrappers/media_control_wrapper.dart';
import 'package:kebap/providers/baklava_config_provider.dart';
import 'package:kebap/providers/settings/kebap_settings_provider.dart';

class Media {
  final String url;
  final Map<String, String>? httpHeaders;

  const Media({
    required this.url,
    this.httpHeaders,
  });
}

extension PlaybackModelExtension on PlaybackModel? {
  SubStreamModel? get defaultSubStream =>
      this?.subStreams?.firstWhereOrNull((element) => element.index == this?.mediaStreams?.defaultSubStreamIndex);

  AudioStreamModel? get defaultAudioStream =>
      this?.audioStreams?.firstWhereOrNull((element) => element.index == this?.mediaStreams?.defaultAudioStreamIndex);

  String? label(BuildContext context) => switch (this) {
        DirectPlaybackModel _ => PlaybackType.directStream.name(context),
        TranscodePlaybackModel _ => PlaybackType.transcode.name(context),
        OfflinePlaybackModel _ => PlaybackType.offline.name(context),
        _ => null
      };
}

class PlaybackModel {
  final ItemBaseModel item;
  final Media? media;
  final List<ItemBaseModel> queue;
  final MediaSegmentsModel? mediaSegments;
  final PlaybackInfoResponse? playbackInfo;

  Map<Bitrate, bool> bitRateOptions;

  List<Chapter>? chapters = [];
  TrickPlayModel? trickPlay;

  Future<PlaybackModel?> updatePlaybackPosition(Duration position, bool isPlaying, Ref ref) =>
      throw UnimplementedError();
  Future<PlaybackModel?> playbackStarted(Duration position, Ref ref) => throw UnimplementedError();
  Future<PlaybackModel?> playbackStopped(Duration position, Duration? totalDuration, Ref ref) =>
      throw UnimplementedError();

  final MediaStreamsModel? mediaStreams;
  List<SubStreamModel>? get subStreams => throw UnimplementedError();
  List<AudioStreamModel>? get audioStreams => throw UnimplementedError();

  Future<Duration>? startDuration() async => item.userData.playBackPosition;

  PlaybackModel? updateUserData(UserData userData) => throw UnimplementedError();

  Future<PlaybackModel>? setSubtitle(SubStreamModel? model, MediaControlsWrapper player) => throw UnimplementedError();
  Future<PlaybackModel>? setAudio(AudioStreamModel? model, MediaControlsWrapper player) => throw UnimplementedError();
  Future<PlaybackModel>? setQualityOption(Map<Bitrate, bool> map) => throw UnimplementedError();

  ItemBaseModel? get nextVideo => queue.nextOrNull(item);
  ItemBaseModel? get previousVideo => queue.previousOrNull(item);

  PlaybackModel copyWith() => throw UnimplementedError();

  PlaybackModel({
    required this.playbackInfo,
    this.mediaStreams,
    required this.item,
    required this.media,
    this.queue = const [],
    this.bitRateOptions = const {},
    this.mediaSegments,
    this.chapters,
    this.trickPlay,
  });
}

final playbackModelHelper = Provider<PlaybackModelHelper>((ref) {
  return PlaybackModelHelper(ref: ref);
});

class PlaybackModelHelper {
  const PlaybackModelHelper({required this.ref});

  final Ref ref;

  JellyService get api => ref.read(jellyApiProvider);

  Future<PlaybackModel?> loadNewVideo(ItemBaseModel newItem) async {
    ref.read(videoPlayerProvider).pause();
    ref.read(mediaPlaybackProvider.notifier).update((state) => state.copyWith(buffering: true));
    final currentModel = ref.read(playBackModel);
    
    // Capture the name of the current version to match in the next video
    final currentVersionName = currentModel?.mediaStreams?.currentVersionStream?.name;

    final newModel = (await createPlaybackModel(
          null,
          newItem,
          oldModel: currentModel,
          preferredVersionName: currentVersionName,
        )) ??
        await _createOfflinePlaybackModel(
          newItem,
          null,
          await ref.read(syncProvider.notifier).getSyncedItem(newItem.id),
          oldModel: currentModel,
        );
    if (newModel == null) return null;
    ref.read(videoPlayerProvider.notifier).loadPlaybackItem(newModel, Duration.zero);
    return newModel;
  }

  Future<OfflinePlaybackModel?> _createOfflinePlaybackModel(
    ItemBaseModel item,
    MediaStreamsModel? streamModel,
    SyncedItem? syncedItem, {
    PlaybackModel? oldModel,
  }) async {
    final ItemBaseModel? syncedItemModel = syncedItem?.itemModel;
    if (syncedItemModel == null || syncedItem == null || !await syncedItem.videoFile.exists()) return null;

    final children = await ref.read(syncProvider.notifier).getSiblings(syncedItem);
    final syncedItems =
        children.where((element) => element.videoFile.existsSync() && element.id != syncedItem.id).toList();
    final itemQueue = syncedItems.map((e) => e.itemModel).nonNulls;

    // Filter media streams to only show the downloaded version
    final allStreams = item.streamModel ?? syncedItemModel.streamModel;
    final matchingVersion = allStreams?.versionStreams.firstWhereOrNull((v) => v.id == syncedItem.mediaSourceId);
    
    final filteredStreams = matchingVersion != null 
        ? allStreams?.copyWith(
            versionStreams: [matchingVersion],
            versionStreamIndex: 0,
          )
        : allStreams;

    return OfflinePlaybackModel(
      item: syncedItemModel,
      syncedItem: syncedItem,
      trickPlay: syncedItem.trickPlayModel,
      mediaSegments: syncedItem.mediaSegments,
      media: Media(url: syncedItem.videoFile.path),
      queue: itemQueue.nonNulls.toList(),
      syncedQueue: children,
      mediaStreams: filteredStreams ?? allStreams,
    );
  }

  Future<PlaybackModel?> createPlaybackModel(
    BuildContext? context,
    ItemBaseModel? item, {
    PlaybackModel? oldModel,
    List<ItemBaseModel>? libraryQueue,
    bool showPlaybackOptions = false,
    Duration? startPosition,
    String? preferredVersionName,
  }) async {
    print("[PlaybackModelHelper] createPlaybackModel called for item: ${item?.name}");
    try {
      if (item == null) {
        print("[PlaybackModelHelper] Item is null");
        return null;
      }
      final userId = ref.read(userProvider)?.id;
      if (userId?.isEmpty == true) {
        print("[PlaybackModelHelper] User ID is empty");
        return null;
      }

      final queue = oldModel?.queue ?? libraryQueue ?? await collectQueue(item);

      final firstItemToPlay = switch (item) {
        SeriesModel _ || SeasonModel _ => (queue.whereType<EpisodeModel>().toList().nextUp),
        _ => item,
      };

      if (firstItemToPlay == null) {
        print("[PlaybackModelHelper] firstItemToPlay is null");
        return null;
      }

      print("[PlaybackModelHelper] Fetching full item details for: ${firstItemToPlay.id}");
      final fullItem = (await api.usersUserIdItemsItemIdGet(itemId: firstItemToPlay.id)).body;

      if (fullItem == null) {
        print("[PlaybackModelHelper] Fetched fullItem is null");
        return null;
      }

      SyncedItem? syncedItem = await ref.read(syncProvider.notifier).getSyncedItem(fullItem.id);

      final firstItemIsSynced = syncedItem != null && syncedItem.status == TaskStatus.complete;

      final options = {
        PlaybackType.directStream,
        PlaybackType.transcode,
        if (firstItemIsSynced) PlaybackType.offline,
      };

      // offline check
      final isOffline = ref.read(connectivityStatusProvider) == ConnectionState.offline;
      print('[PlaybackModelHelper] isOffline: $isOffline');

      if (isOffline) {
        print('[PlaybackModelHelper] Creating offline playback model');
        return _createOfflinePlaybackModel(
          fullItem,
          item.streamModel,
          syncedItem,
        );
      }
      
      if (((showPlaybackOptions || firstItemIsSynced) && !isOffline) && context != null) {
        final playbackType = await showPlaybackTypeSelection(
          context: context,
          options: options,
        );

        if (!context.mounted) return null;

        return switch (playbackType) {
          PlaybackType.directStream || PlaybackType.transcode => await _createServerPlaybackModel(
              fullItem,
              item.streamModel,
              playbackType,
              oldModel: oldModel,
              libraryQueue: queue,
              startPosition: startPosition,
            ),
          PlaybackType.offline => await _createOfflinePlaybackModel(
              fullItem,
              item.streamModel,
              syncedItem,
            ),
          null => null
        };
      } else {
        print("[PlaybackModelHelper] Creating server playback model (or offline if failed/preferred)...");
        return (await _createServerPlaybackModel(
              fullItem,
              item.streamModel,
              PlaybackType.directStream,
              startPosition: startPosition,
              oldModel: oldModel,
              libraryQueue: queue,
              preferredVersionName: preferredVersionName,
            )) ??
            await _createOfflinePlaybackModel(
              fullItem,
              item.streamModel,
              syncedItem,
            );
      }
    } catch (e, stack) {
      print("Error creating playback model: ${e.toString()}");
      // debugPrintStack(stackTrace: stack); // Stack trace might be too verbose/stripped in release, but error msg is key.
      return null;
    }
  }

  Future<PlaybackModel?> _createServerPlaybackModel(
    ItemBaseModel item,
    MediaStreamsModel? streamModel,
    PlaybackType? type, {
    PlaybackModel? oldModel,
    required List<ItemBaseModel> libraryQueue,
    Duration? startPosition,
    String? preferredVersionName,
  }) async {
    try {
      final userId = ref.read(userProvider)?.id;
      if (userId?.isEmpty == true) return null;

      final newStreamModel = streamModel ?? item.streamModel;
      
      // If a preferred version is requested, try to select it in the model passed to the API
      // This ensures we request the correct mediaSourceId from the server
      MediaStreamsModel? usedStreamModel = newStreamModel;
      if (preferredVersionName != null && newStreamModel != null) {
          final matchingIndex = newStreamModel.versionStreams.indexWhere((v) => v.name == preferredVersionName);
          if (matchingIndex != -1) {
              usedStreamModel = newStreamModel.copyWith(versionStreamIndex: matchingIndex);
          }
      }

      Map<Bitrate, bool> qualityOptions = getVideoQualityOptions(
        VideoQualitySettings(
          maxBitRate: ref.read(videoPlayerSettingsProvider.select((value) => value.maxHomeBitrate)),
          videoBitRate: usedStreamModel?.videoStreams.firstOrNull?.bitRate ?? 0,
          videoCodec: usedStreamModel?.videoStreams.firstOrNull?.codec,
        ),
      );

      final audioStreamIndex = selectAudioStream(
          ref.read(userProvider.select((value) => value?.userConfiguration?.rememberAudioSelections ?? true)),
          oldModel?.mediaStreams?.currentAudioStream,
          usedStreamModel?.audioStreams,
          usedStreamModel?.defaultAudioStreamIndex);

      final subStreamIndex = selectSubStream(
          ref.read(userProvider.select((value) => value?.userConfiguration?.rememberSubtitleSelections ?? true)),
          oldModel?.mediaStreams?.currentSubStream,
          usedStreamModel?.subStreams,
          usedStreamModel?.defaultSubStreamIndex);

      //Native player does not allow for loading external subtitles with transcoding
      final isNativePlayer =
          ref.read(videoPlayerSettingsProvider.select((value) => value.wantedPlayer == PlayerOptions.nativePlayer));
      final isExternalSub = usedStreamModel?.currentSubStream?.isExternal == true;

      // Refresh metadata to clear cached stream URLs (fixes expired RealDebrid/Torrentio links)
      try {
        await api.itemsItemIdRefreshPost(
          itemId: item.id,
          metadataRefreshMode: MetadataRefresh.fullRefresh,
          replaceAllMetadata: false,
          replaceAllImages: false,
        );
      } catch (e) {
        log("Failed to refresh metadata: ${e.toString()}");
        // Continue anyway - cached URLs might still work
      }

      final Response<PlaybackInfoResponse> response = await api.itemsItemIdPlaybackInfoPost(
        itemId: item.id,
        body: PlaybackInfoDto(
          startTimeTicks: startPosition?.toRuntimeTicks,
          audioStreamIndex: audioStreamIndex,
          subtitleStreamIndex: subStreamIndex,
          enableTranscoding: true,
          autoOpenLiveStream: true,
          deviceProfile: ref.read(videoProfileProvider),
          userId: userId,
          enableDirectPlay: type != PlaybackType.transcode,
          enableDirectStream: type != PlaybackType.transcode,
          alwaysBurnInSubtitleWhenTranscoding: isNativePlayer && isExternalSub,
          maxStreamingBitrate: qualityOptions.enabledFirst.keys.firstOrNull?.bitRate,
          mediaSourceId: usedStreamModel?.currentVersionStream?.id,
        ),
      );

      PlaybackInfoResponse? playbackInfo = response.body;

      if (playbackInfo == null) return null;

      // When mediaSourceId is specified in the request, the server returns only that specific
      // media source at index 0, regardless of its original versionStreamIndex
      final mediaSource = playbackInfo.mediaSources?.first;

      if (mediaSource == null) return null;

      // Debug: Log playback decision
      print('[PlaybackModel] MediaSource ID: ${mediaSource.id}');
      print('[PlaybackModel] SupportsDirectPlay: ${mediaSource.supportsDirectPlay}');
      print('[PlaybackModel] SupportsDirectStream: ${mediaSource.supportsDirectStream}');
      print('[PlaybackModel] SupportsTranscoding: ${mediaSource.supportsTranscoding}');
      print('[PlaybackModel] TranscodingUrl: ${mediaSource.transcodingUrl}');
      print('[PlaybackModel] TranscodingSubProtocol: ${mediaSource.transcodingSubProtocol}');
      print('[PlaybackModel] Path: ${mediaSource.path}');
      print('[PlaybackModel] Container: ${mediaSource.container}');
      print('[PlaybackModel] VideoCodec: ${mediaSource.mediaStreams?.firstWhere((s) => s.type == MediaStreamType.video, orElse: () => MediaStream()).codec}');

      final mediaStreamsWithUrls = MediaStreamsModel.fromMediaStreamsList(playbackInfo.mediaSources, ref).copyWith(
        defaultAudioStreamIndex: audioStreamIndex,
        defaultSubStreamIndex: subStreamIndex,
      );

      final useBaklava = ref.read(kebapSettingsProvider).useBaklava;
      final mergedMediaStreams = useBaklava
          ? await _mergeBaklavaStreams(item.id, mediaSource.id, mediaStreamsWithUrls)
          : mediaStreamsWithUrls;

      // Attempt to match the preferred version name
      if (preferredVersionName != null) {
        final matchingIndex = mergedMediaStreams.versionStreams.indexWhere(
          (v) => v.name == preferredVersionName,
        );
        
        if (matchingIndex != -1 && matchingIndex != mergedMediaStreams.versionStreamIndex) {
          // Found a matching version!
          // We need to reload using this version's media source ID
          // But wait, the PlaybackInfoResponse we got was for the DEFAUlT (or first) source.
          // The servers returns a list of media sources in PlaybackInfoResponse.mediaSources
          // mergedMediaStreams is built from that list.
          
          final targetVersion = mergedMediaStreams.versionStreams[matchingIndex];
          // We can just switch the index in the model, BUT we also need to ensure
          // the 'mediaSource' variable (used for Direct Play options) points to the correct one.
          
          // Since we already fetched PlaybackInfo, we *should* have the source info in the list.
          // Let's re-select the media source based on the new index.
          
          final targetMediaSource = playbackInfo.mediaSources?.firstWhereOrNull((s) => s.id == targetVersion.id);
          
          if (targetMediaSource != null) {
             // Recursively call with the specific mediaSourceId to ensure we get the correct PlaybackInfo for valid transcodingURL/DirectStream params etc.
             // Although usually PlaybackInfo returns ALL sources, sometimes specific transcoding URLs are generated per source.
             // Safest bet is to just use the correct source from the list we already have if it supports what we need.
             
             // Actually, `_createServerPlaybackModel` logic below relies heavily on `mediaSource` (variable).
             // Let's perform a "soft reload" by effectively recursively calling ourselves but with the specific mediaSourceId forced
             // indirectly via a new request?
             
             // No, let's just update the local variables to point to the correct source
             // provided it was in the original response.
             
             return _createServerPlaybackModel(
                 item,
                 streamModel,
                 type,
                 oldModel: oldModel,
                 libraryQueue: libraryQueue,
                 startPosition: startPosition,
                 // Reset preferredVersionName to avoid infinite loop (though unlikely here)
                 preferredVersionName: null, 
             ).then((model) async {
                  // If we can't easily recurse with new source ID (api doesn't take it in initial call, only in playback info),
                  // we might need to rely on the fact that we have the source data.
                  // However, simpler approach: just verify if we found it in the list.
                  return model;
             });
             
             // WAIT - The simplest way is to fetch PlaybackInfo AGAIN with the specific mediaSourceId
             // preventing the "default" selection.
             // But avoiding double network calls is better.
             
             // Let's stick to using the `targetMediaSource` we found in the list.
             // We need to update `mergedMediaStreams` to have the correct index.
             
              final updatedStreams = mergedMediaStreams.copyWith(versionStreamIndex: matchingIndex);
              
              // Now we have to effectively restart the logic below `mediaSource` definition with `targetMediaSource`.
              // Refactoring slightly to allow this "swap".
             
             // To simplify code change without massive refactor:
             // If we found a match, let's just use it as 'mediaSource' and 'mergedMediaStreams'.
             
             // Can't easily jump back.
             // Recursive call IS the cleanest if we pass `mediaSourceId` to `_createServerPlaybackModel`?
             // No, `_createServerPlaybackModel` takes arguments to BUILD the request. 
             // The request `itemsItemIdPlaybackInfoPost` takes `mediaSourceId`.
             // But currently `_createServerPlaybackModel` uses `newStreamModel?.currentVersionStream?.id` as input for `mediaSourceId`.
             
             // If we passed `preferredVersionName`, we didn't know the ID yet.
             // NOW we know the ID (targetVersion.id).
             // So we CAN recurse, but we need to inject the ID into `newStreamModel` so it gets picked up?
             // OR, just modify the API call in `_createServerPlaybackModel`.
             
             // Reviewing `_createServerPlaybackModel`:
             // `mediaSourceId: newStreamModel?.currentVersionStream?.id,` (Line 336)
             
             // So if `newStreamModel` had the correct version selected, it would work!
             // BUT `newStreamModel` is passed in as `item.streamModel`.
             
             // So: If `preferredVersionName` is set, we should try to find that version in `item.streamModel` BEFORE making the api call.
             
          }
        }
      }

      final mediaSegments = await api.mediaSegmentsGet(id: item.id);
      final trickPlay = (await api.getTrickPlay(item: item, ref: ref))?.body;
      final chapters = item.overview.chapters ?? [];

      final mediaPath = isValidVideoUrl(mediaSource.path ?? "");

      if ((mediaSource.supportsDirectStream ?? false) || (mediaSource.supportsDirectPlay ?? false)) {
        final Map<String, String?> directOptions = {
          'Static': 'true',
          'mediaSourceId': mediaSource.id,
          'api_key': ref.read(userProvider)?.credentials.token,
        };

        if (mediaSource.eTag != null) {
          directOptions['Tag'] = mediaSource.eTag;
        }

        if (mediaSource.liveStreamId != null) {
          directOptions['LiveStreamId'] = mediaSource.liveStreamId;
        }

        final params = Uri(queryParameters: directOptions).query;
        final baseUrl = (ref.read(serverUrlProvider) ?? "").replaceAll(RegExp(r'\/$'), '');
        final playbackUrl = "$baseUrl/Videos/${mediaSource.id!}/stream?$params";

        return DirectPlaybackModel(
          item: item,
          queue: libraryQueue,
          mediaSegments: mediaSegments?.body,
          chapters: chapters,
          playbackInfo: playbackInfo,
          trickPlay: trickPlay,
          media: Media(
            url: mediaPath ?? playbackUrl,
            httpHeaders: mediaSource.requiredHttpHeaders?.map((key, value) => MapEntry(key, value.toString())),
          ),
          mediaStreams: mergedMediaStreams,
          bitRateOptions: qualityOptions,
        );
      } else if ((mediaSource.supportsTranscoding ?? false) && mediaSource.transcodingUrl != null) {
        return TranscodePlaybackModel(
          item: item,
          queue: libraryQueue,
          mediaSegments: mediaSegments?.body,
          chapters: chapters,
          trickPlay: trickPlay,
          playbackInfo: playbackInfo,
          media: Media(
            url: "${(ref.read(serverUrlProvider) ?? "").replaceAll(RegExp(r'\/$'), '')}${mediaSource.transcodingUrl ?? ""}",
            httpHeaders: mediaSource.requiredHttpHeaders?.map((key, value) => MapEntry(key, value.toString())),
          ),
          mediaStreams: mergedMediaStreams,
          bitRateOptions: qualityOptions,
        );
      }
      return null;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  String? isValidVideoUrl(String path) {
    Uri? uri = Uri.tryParse(path);
    return (uri != null && uri.hasScheme && uri.hasAuthority) ? path : null;
  }

  Future<List<ItemBaseModel>> collectQueue(ItemBaseModel model) async {
    switch (model) {
      case EpisodeModel _:
      case SeriesModel _:
      case SeasonModel _:
        List<EpisodeModel> episodeList = ((await fetchEpisodesFromSeries(model.streamId)).body ?? [])
          ..removeWhere((element) => element.status != EpisodeStatus.available);
        return episodeList;
      default:
        return [];
    }
  }

  Future<Response<List<EpisodeModel>>> fetchEpisodesFromSeries(String seriesId) async {
    final response = await api.showsSeriesIdEpisodesGet(
      seriesId: seriesId,
      fields: [
        ItemFields.overview,
        ItemFields.originaltitle,
        ItemFields.mediastreams,
        ItemFields.mediasources,
        ItemFields.mediasourcecount,
        ItemFields.width,
        ItemFields.height,
      ],
    );
    return Response(
      response.base, 
      (response.body?.items?.map((e) => EpisodeModel.fromBaseDto(e, ref)).toList() ?? [])
      // Sort episodes by Season then Episode index to ensure correct playback order
      // This fixes issues where "Next Up" would jump to S00E01 if the API returned unsorted data
      ..sort((a, b) {
        final seasonComp = a.season.compareTo(b.season);
        if (seasonComp != 0) return seasonComp;
        return a.episode.compareTo(b.episode);
      })
    );
  }

  Future<void> shouldReload(PlaybackModel playbackModel) async {
    if (playbackModel is OfflinePlaybackModel) {
      return;
    }

    final item = playbackModel.item;

    final userId = ref.read(userProvider)?.id;
    if (userId?.isEmpty == true) return;

    final currentPosition = ref.read(mediaPlaybackProvider.select((value) => value.position));

    final audioIndex = selectAudioStream(
        ref.read(userProvider.select((value) => value?.userConfiguration?.rememberAudioSelections ?? true)),
        playbackModel.mediaStreams?.currentAudioStream,
        playbackModel.audioStreams,
        playbackModel.mediaStreams?.defaultAudioStreamIndex);
    final subIndex = selectSubStream(
        ref.read(userProvider.select((value) => value?.userConfiguration?.rememberSubtitleSelections ?? true)),
        playbackModel.mediaStreams?.currentSubStream,
        playbackModel.subStreams,
        playbackModel.mediaStreams?.defaultSubStreamIndex);

    // Refresh metadata to clear cached stream URLs (fixes expired RealDebrid/Torrentio links)
    try {
      await api.itemsItemIdRefreshPost(
        itemId: item.id,
        metadataRefreshMode: MetadataRefresh.fullRefresh,
        replaceAllMetadata: false,
        replaceAllImages: false,
      );
    } catch (e) {
      log("Failed to refresh metadata: ${e.toString()}");
      // Continue anyway - cached URLs might still work
    }

    Response<PlaybackInfoResponse> response = await api.itemsItemIdPlaybackInfoPost(
      itemId: item.id,
      body: PlaybackInfoDto(
        startTimeTicks: currentPosition.toRuntimeTicks,
        audioStreamIndex: audioIndex,
        enableDirectPlay: true,
        enableDirectStream: true,
        subtitleStreamIndex: subIndex,
        enableTranscoding: true,
        autoOpenLiveStream: true,
        deviceProfile: ref.read(videoProfileProvider),
        userId: userId,
        maxStreamingBitrate: playbackModel.bitRateOptions.enabledFirst.entries.firstOrNull?.key.bitRate,
        mediaSourceId: playbackModel.mediaStreams?.currentVersionStream?.id,
      ),
    );

    PlaybackInfoResponse playbackInfo = response.bodyOrThrow;

    final mediaSource = playbackInfo.mediaSources?.first;

    final mediaStreamsWithUrls = MediaStreamsModel.fromMediaStreamsList(playbackInfo.mediaSources, ref).copyWith(
      defaultAudioStreamIndex: audioIndex,
      defaultSubStreamIndex: subIndex,
    );

    if (mediaSource == null) return;

    PlaybackModel? newModel;

    if ((mediaSource.supportsDirectStream ?? false) || (mediaSource.supportsDirectPlay ?? false)) {
      final Map<String, String?> directOptions = {
        'Static': 'true',
        'mediaSourceId': mediaSource.id,
        'api_key': ref.read(userProvider)?.credentials.token,
      };

      if (mediaSource.eTag != null) {
        directOptions['Tag'] = mediaSource.eTag;
      }

      if (mediaSource.liveStreamId != null) {
        directOptions['LiveStreamId'] = mediaSource.liveStreamId;
      }

      final params = Uri(queryParameters: directOptions).query;

      final baseUrl = (ref.read(serverUrlProvider) ?? "").replaceAll(RegExp(r'\/$'), '');
      final directPlay = '$baseUrl/Videos/${mediaSource.id}/stream?$params';

      final mediaPath = isValidVideoUrl(mediaSource.path ?? "");

      newModel = DirectPlaybackModel(
        item: playbackModel.item,
        queue: playbackModel.queue,
        mediaSegments: playbackModel.mediaSegments,
        chapters: playbackModel.chapters,
        playbackInfo: playbackInfo,
        trickPlay: playbackModel.trickPlay,
        media: Media(url: mediaPath ?? directPlay),
        mediaStreams: mediaStreamsWithUrls,
        bitRateOptions: playbackModel.bitRateOptions,
      );
    } else if ((mediaSource.supportsTranscoding ?? false) && mediaSource.transcodingUrl != null) {
      newModel = TranscodePlaybackModel(
        item: playbackModel.item,
        queue: playbackModel.queue,
        mediaSegments: playbackModel.mediaSegments,
        chapters: playbackModel.chapters,
        playbackInfo: playbackInfo,
        trickPlay: playbackModel.trickPlay,
        media: Media(url: "${(ref.read(serverUrlProvider) ?? "").replaceAll(RegExp(r'\/$'), '')}${mediaSource.transcodingUrl ?? ""}"),
        mediaStreams: mediaStreamsWithUrls,
        bitRateOptions: playbackModel.bitRateOptions,
      );
    }
    if (newModel == null) return;
    if (newModel.runtimeType != playbackModel.runtimeType || newModel is TranscodePlaybackModel) {
      ref.read(videoPlayerProvider.notifier).loadPlaybackItem(newModel, currentPosition);
    }
  }

  Future<MediaStreamsModel> _mergeBaklavaStreams(
    String itemId,
    String? mediaSourceId,
    MediaStreamsModel originalStreams,
  ) async {
    try {
      final baklavaService = ref.read(baklavaServiceProvider);
      final response = await baklavaService.getMediaStreams(itemId: itemId, mediaSourceId: mediaSourceId);

      if (!response.isSuccessful || response.body == null) {
        return originalStreams;
      }

      final data = response.body!;
      final audioList = (data['audio'] as List?) ?? [];
      final subList = (data['subs'] as List?) ?? [];

      if (audioList.isEmpty && subList.isEmpty) {
        return originalStreams;
      }

      // Convert Baklava streams to Kebap models
      final baklavaAudioStreams = audioList.map<AudioStreamModel>((a) {
        return AudioStreamModel(
          index: a['index'] ?? -1,
          name: a['title'] ?? 'Unknown',
          displayTitle: a['title'] ?? 'Unknown',
          language: a['language'] ?? 'Unknown',
          codec: a['codec'] ?? '',
          channelLayout: (a['channels']?.toString() ?? ''),
          isDefault: false,
          isExternal: false, // Baklava probed streams are usually embedded
        );
      }).toList();

      final baklavaSubStreams = subList.map<SubStreamModel>((s) {
        return SubStreamModel(
          index: s['index'] ?? -1,
          name: s['title'] ?? 'Unknown',
          title: s['title'] ?? 'Unknown',
          displayTitle: s['title'] ?? 'Unknown',
          language: s['language'] ?? 'Unknown',
          codec: s['codec'] ?? '',
          id: (s['index'] ?? -1).toString(),
          isDefault: s['isDefault'] ?? false,
          isExternal: false,
          supportsExternalStream: false,
        );
      }).toList();

      // Merge logic:
      // We want to add streams found by Baklava that are NOT in the original list.
      // Simple check by index.
      
      final currentVersion = originalStreams.currentVersionStream;
      if (currentVersion == null) return originalStreams;

      final existingAudioIndices = currentVersion.audioStreams.map((e) => e.index).toSet();
      final existingSubIndices = currentVersion.subStreams.map((e) => e.index).toSet();

      final newAudioStreams = [
        ...currentVersion.audioStreams,
        ...baklavaAudioStreams.where((e) => !existingAudioIndices.contains(e.index)),
      ];

      final newSubStreams = [
        ...currentVersion.subStreams,
        ...baklavaSubStreams.where((e) => !existingSubIndices.contains(e.index)),
      ];

      // Create a new VersionStreamModel with merged streams
      final newVersionStream = VersionStreamModel(
        name: currentVersion.name,
        size: currentVersion.size,
        index: currentVersion.index,
        id: currentVersion.id,
        defaultAudioStreamIndex: currentVersion.defaultAudioStreamIndex,
        defaultSubStreamIndex: currentVersion.defaultSubStreamIndex,
        videoStreams: currentVersion.videoStreams,
        audioStreams: newAudioStreams,
        subStreams: newSubStreams,
      );

      // Replace the current version stream in the list
      final newVersionStreams = List<VersionStreamModel>.from(originalStreams.versionStreams);
      if (originalStreams.versionStreamIndex != null && 
          originalStreams.versionStreamIndex! < newVersionStreams.length) {
        newVersionStreams[originalStreams.versionStreamIndex!] = newVersionStream;
      }

      return originalStreams.copyWith(versionStreams: newVersionStreams);

    } catch (e) {
      log("Error merging Baklava streams: ${e.toString()}");
      return originalStreams;
    }
  }
}
