import 'package:chopper/chopper.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kebap/jellyfin/jellyfin_open_api.swagger.dart';
import 'package:kebap/models/item_base_model.dart';
import 'package:kebap/models/items/episode_model.dart';
import 'package:kebap/models/items/item_shared_models.dart';
import 'package:kebap/models/items/media_streams_model.dart';
import 'package:kebap/models/items/series_model.dart';
import 'package:kebap/providers/api_provider.dart';
import 'package:kebap/providers/baklava_requests_provider.dart';
import 'package:kebap/providers/service_provider.dart';
import 'package:kebap/providers/sync_provider.dart';

class EpisodeDetailModel {
  final SeriesModel? series;
  final List<EpisodeModel> episodes;
  final EpisodeModel? episode;
  final List<Person> guestActors;
  EpisodeDetailModel({
    this.series,
    this.episodes = const [],
    this.episode,
    this.guestActors = const [],
  });

  EpisodeDetailModel copyWith({
    SeriesModel? series,
    List<EpisodeModel>? episodes,
    EpisodeModel? episode,
    List<Person>? guestActors,
  }) {
    return EpisodeDetailModel(
      series: series ?? this.series,
      episodes: episodes ?? this.episodes,
      episode: episode ?? this.episode,
      guestActors: guestActors ?? this.guestActors,
    );
  }
}

final episodeDetailsProvider =
    StateNotifierProvider.autoDispose.family<EpisodeDetailsProvider, EpisodeDetailModel, String>((ref, id) {
  return EpisodeDetailsProvider(ref);
});

class EpisodeDetailsProvider extends StateNotifier<EpisodeDetailModel> {
  EpisodeDetailsProvider(this.ref) : super(EpisodeDetailModel());

  final Ref ref;

  late final JellyService api = ref.read(jellyApiProvider);

  Future<Response?> fetchDetails(ItemBaseModel item) async {
    try {
      final seriesResponse = await api.usersUserIdItemsItemIdGet(itemId: item.parentBaseModel.id);
      if (seriesResponse.body == null) return null;
      final episodes = await api.showsSeriesIdEpisodesGet(seriesId: item.parentBaseModel.id);

      if (episodes.body == null) return null;

      state = state.copyWith(
        series: seriesResponse.bodyOrThrow as SeriesModel,
      );

      var episode = (await api.usersUserIdItemsItemIdGet(itemId: item.id)).bodyOrThrow as EpisodeModel;

      // ALWAYS use API response versions - server is the source of truth
      // Previously we preserved existing state if new had none, but this caused stale data issues

      // CRITICAL: Use episode.id (canonical ID from response) instead of item.id!
      // Gelato may redirect to a different canonical ID, so we must use the response's ID.
      final effectiveItemId = episode.id;
      
      // If item has no media sources (non-Gelato items), fetch from PlaybackInfo
      if (episode.mediaStreams.versionStreams.isEmpty) {
        try {
          final playbackInfo = await api.itemsItemIdPlaybackInfoPost(
            itemId: effectiveItemId,
            body: const PlaybackInfoDto(
              enableDirectPlay: true,
              enableDirectStream: true,
              enableTranscoding: false,
            ),
          );
          
          if (playbackInfo.body?.mediaSources != null && playbackInfo.body!.mediaSources!.isNotEmpty) {
            episode = episode.copyWith(
              mediaStreams: MediaStreamsModel.fromMediaStreamsList(playbackInfo.body!.mediaSources, ref),
            );
          }
        } catch (e) {
          // Ignore error, use empty streams
        }
      }

      final firstVersion = episode.mediaStreams.versionStreams.firstOrNull;
      final totalStreams = (firstVersion?.videoStreams.length ?? 0) + 
                           (firstVersion?.audioStreams.length ?? 0) + 
                           (firstVersion?.subStreams.length ?? 0);
      
      if (firstVersion != null &&
          (totalStreams == 0 ||
              (firstVersion.audioStreams.isEmpty) ||
              (firstVersion.subStreams.isEmpty)) &&
          firstVersion.id != null) {
        episode = episode.copyWith(
          mediaStreams: episode.mediaStreams.copyWith(isLoading: true),
        );
        state = state.copyWith(episode: episode);
        
        try {
          final baklavaService = ref.read(baklavaServiceProvider);
          final streamsResponse = await baklavaService.getMediaStreams(
            itemId: effectiveItemId,
            mediaSourceId: firstVersion.id,
          );
          
          if (streamsResponse.body != null) {
            final audioList = (streamsResponse.body!['audio'] as List?)?.cast<Map<String, dynamic>>() ?? [];
            final subsList = (streamsResponse.body!['subs'] as List?)?.cast<Map<String, dynamic>>() ?? [];
            
            final audioStreams = <AudioStreamModel>[
              for (final a in audioList)
                AudioStreamModel(
                  displayTitle: (a['title'] as String?) ?? 'Audio ${a['index']}',
                  name: (a['title'] as String?) ?? '',
                  codec: (a['codec'] as String?) ?? '',
                  isDefault: false,
                  isExternal: false,
                  index: a['index'] as int,
                  language: (a['language'] as String?) ?? '',
                  channelLayout: '',
                )
            ];
            
            final subStreams = <SubStreamModel>[
              for (final s in subsList)
                SubStreamModel(
                  name: (s['title'] as String?) ?? '',
                  id: s['index'].toString(),
                  title: (s['title'] as String?) ?? 'Subtitle ${s['index']}',
                  displayTitle: (s['title'] as String?) ?? 'Subtitle ${s['index']}',
                  language: (s['language'] as String?) ?? '',
                  codec: (s['codec'] as String?) ?? '',
                  isDefault: s['isDefault'] as bool? ?? false,
                  isExternal: false,
                  index: s['index'] as int,
                )
            ];
            
            final updatedFirstVersion = VersionStreamModel(
              name: firstVersion.name,
              index: firstVersion.index,
              id: firstVersion.id,
              defaultAudioStreamIndex: audioStreams.firstOrNull?.index,
              defaultSubStreamIndex: subStreams.firstOrNull?.index,
              videoStreams: [],
              audioStreams: audioStreams,
              subStreams: subStreams,
            );
            
            final updatedVersionStreams = [
              updatedFirstVersion,
              ...episode.mediaStreams.versionStreams.skip(1),
            ];
            
            episode = episode.copyWith(
              mediaStreams: episode.mediaStreams.copyWith(
                versionStreams: updatedVersionStreams,
                defaultAudioStreamIndex: audioStreams.firstOrNull?.index,
                defaultSubStreamIndex: subStreams.firstOrNull?.index,
                isLoading: false,
              ),
            );
          }
        } catch (e) {
          // Ignore error, use empty streams, clear loading state
          episode = episode.copyWith(
            mediaStreams: episode.mediaStreams.copyWith(isLoading: false),
          );
        }
      }

      state = state.copyWith(
        series: seriesResponse.bodyOrThrow as SeriesModel,
        episodes: EpisodeModel.episodesFromDto(episodes.bodyOrThrow.items, ref),
        episode: episode,
      );

      return seriesResponse;
    } catch (e) {
      _tryToCreateOfflineState(item);
      return null;
    }
  }

  Future<void> _tryToCreateOfflineState(ItemBaseModel item) async {
    final syncNotifier = ref.read(syncProvider.notifier);
    final episodeModel = (await syncNotifier.getSyncedItem(item.id))?.itemModel as EpisodeModel?;
    if (episodeModel == null) return;
    final seriesSyncedItem = await syncNotifier.getSyncedItem(episodeModel.parentBaseModel.id);
    if (seriesSyncedItem == null) return;
    final seriesModel = seriesSyncedItem.itemModel as SeriesModel?;
    if (seriesModel == null) return;
    final episodes = (await syncNotifier.getNestedChildren(seriesSyncedItem))
        .map((e) => e.itemModel)
        .whereType<EpisodeModel>()
        .toList();
    state = state.copyWith(
      series: seriesModel,
      episode: episodes.firstWhereOrNull((element) => element.id == item.id),
      episodes: episodes,
    );
    return;
  }

  void setSubIndex(int index) {
    state = state.copyWith(
        episode: state.episode?.copyWith(
            mediaStreams: state.episode?.mediaStreams.copyWith(
      defaultSubStreamIndex: index,
    )));
  }

  void setAudioIndex(int index) {
    state = state.copyWith(
        episode: state.episode?.copyWith(
            mediaStreams: state.episode?.mediaStreams.copyWith(
      defaultAudioStreamIndex: index,
    )));
  }

  Future<void> setVersionIndex(int index) async {
    debugPrint('[Episode.setVersionIndex] Called with index: $index');
    final newVersionStream = state.episode?.mediaStreams.versionStreams.elementAtOrNull(index);
    if (newVersionStream == null || state.episode == null) {
      debugPrint('[Episode.setVersionIndex] newVersionStream or episode is null, returning');
      return;
    }
    debugPrint('[Episode.setVersionIndex] newVersionStream.id: ${newVersionStream.id}, audio: ${newVersionStream.audioStreams.length}, subs: ${newVersionStream.subStreams.length}');
    
    // First, switch to this version immediately (no loading state)
    state = state.copyWith(
      episode: state.episode?.copyWith(
        mediaStreams: state.episode?.mediaStreams.copyWith(
          versionStreamIndex: index,
          defaultAudioStreamIndex: newVersionStream.defaultAudioStreamIndex,
          defaultSubStreamIndex: newVersionStream.defaultSubStreamIndex,
        ),
      ),
    );
    
    // Always fetch from Baklava to get complete stream data
    // (Jellyfin initial data may be incomplete)
    if (newVersionStream.id != null) {
      debugPrint('[Episode.setVersionIndex] Fetching from Baklava for mediaSourceId: ${newVersionStream.id}');
      try {
        final baklavaService = ref.read(baklavaServiceProvider);
        final streamsResponse = await baklavaService.getMediaStreams(
          itemId: state.episode!.id,
          mediaSourceId: newVersionStream.id,
        );
        
        debugPrint('[Episode.setVersionIndex] Baklava response body: ${streamsResponse.body}');
        
        if (streamsResponse.body != null) {
          final audioList = (streamsResponse.body!['audio'] as List?)?.cast<Map<String, dynamic>>() ?? [];
          final subsList = (streamsResponse.body!['subs'] as List?)?.cast<Map<String, dynamic>>() ?? [];
          
          debugPrint('[Episode.setVersionIndex] Parsed ${audioList.length} audio, ${subsList.length} subs');
          
          final audioStreams = <AudioStreamModel>[
            for (final a in audioList)
              AudioStreamModel(
                displayTitle: (a['title'] as String?) ?? 'Audio ${a['index']}',
                name: (a['title'] as String?) ?? '',
                codec: (a['codec'] as String?) ?? '',
                isDefault: false,
                isExternal: false,
                index: a['index'] as int,
                language: (a['language'] as String?) ?? '',
                channelLayout: '',
              )
          ];
          
          final subStreams = <SubStreamModel>[
            for (final s in subsList)
              SubStreamModel(
                name: (s['title'] as String?) ?? '',
                  id: s['index'].toString(),
                  title: (s['title'] as String?) ?? 'Subtitle ${s['index']}',
                  displayTitle: (s['title'] as String?) ?? 'Subtitle ${s['index']}',
                  language: (s['language'] as String?) ?? '',
                  codec: (s['codec'] as String?) ?? '',
                  isDefault: s['isDefault'] as bool? ?? false,
                  isExternal: false,
                  index: s['index'] as int,
                )
          ];
          
          debugPrint('[Episode.setVersionIndex] Built ${audioStreams.length} AudioStreamModels, ${subStreams.length} SubStreamModels');
          
          // Update ONLY this version's data, using list position (enumerate)
          int listIndex = 0;
          final updatedVersionStreams = state.episode!.mediaStreams.versionStreams.map((v) {
            final currentListIndex = listIndex++;
            if (currentListIndex == index) {
              debugPrint('[Episode.setVersionIndex] Updating version at list position $currentListIndex');
              return VersionStreamModel(
                name: v.name,
                index: v.index,
                id: v.id,
                size: v.size,
                defaultAudioStreamIndex: audioStreams.firstOrNull?.index,
                defaultSubStreamIndex: subStreams.firstOrNull?.index,
                videoStreams: v.videoStreams,
                audioStreams: audioStreams,
                subStreams: subStreams,
              );
            }
            return v;
          }).toList();
          
          state = state.copyWith(
            episode: state.episode?.copyWith(
              mediaStreams: state.episode?.mediaStreams.copyWith(
                versionStreams: updatedVersionStreams,
                defaultAudioStreamIndex: audioStreams.firstOrNull?.index,
                defaultSubStreamIndex: subStreams.firstOrNull?.index,
              ),
            ),
          );
          debugPrint('[Episode.setVersionIndex] State updated with new streams');
        }
      } catch (e, stack) {
        debugPrint('[Episode.setVersionIndex] Error: $e\n$stack');
      }
    }
  }

  bool _areAudioStreamsEqual(List<AudioStreamModel> a, List<AudioStreamModel> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i].index != b[i].index ||
          a[i].name != b[i].name ||
          a[i].codec != b[i].codec ||
          a[i].language != b[i].language) {
        return false;
      }
    }
    return true;
  }

  bool _areSubStreamsEqual(List<SubStreamModel> a, List<SubStreamModel> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i].index != b[i].index ||
          a[i].name != b[i].name ||
          a[i].codec != b[i].codec ||
          a[i].language != b[i].language || 
          a[i].isDefault != b[i].isDefault) {
        return false;
      }
    }
    return true;
  }

  Future<void> refreshStreams() async {
    final currentEpisode = state.episode;
    if (currentEpisode == null) return;

    final firstVersion = currentEpisode.mediaStreams.versionStreams.firstOrNull;
    final totalStreams = (firstVersion?.videoStreams.length ?? 0) +
        (firstVersion?.audioStreams.length ?? 0) +
        (firstVersion?.subStreams.length ?? 0);

    if (firstVersion != null &&
        (totalStreams == 0 ||
            (firstVersion.audioStreams.isEmpty) ||
            (firstVersion.subStreams.isEmpty)) &&
        firstVersion.id != null) {
      try {
        final playbackInfo = await api.itemsItemIdPlaybackInfoPost(
          itemId: currentEpisode.id,
          body: PlaybackInfoDto(
            enableDirectPlay: true,
            enableDirectStream: true,
            enableTranscoding: false,
            autoOpenLiveStream: true,
            mediaSourceId: firstVersion.id,
          ),
        );

        if (playbackInfo.body?.mediaSources?.firstOrNull != null) {
          final sourceWithStreams = playbackInfo.body!.mediaSources!.first;

          if (sourceWithStreams.mediaStreams != null) {
            final streams = sourceWithStreams.mediaStreams!;
            
            final audioStreams = streams
                  .where((element) => element.type == MediaStreamType.audio)
                  .map((e) => AudioStreamModel.fromMediaStream(e))
                  .toList();
            
            final subStreams = streams
                  .where((element) => element.type == MediaStreamType.subtitle)
                  .map((sub) => SubStreamModel.fromMediaStream(sub, ref))
                  .toList();

            // Check equality
            if (_areAudioStreamsEqual(firstVersion.audioStreams, audioStreams) &&
                _areSubStreamsEqual(firstVersion.subStreams, subStreams)) {
              return;
            }

            final updatedFirstVersion = VersionStreamModel(
              name: firstVersion.name,
              index: firstVersion.index,
              id: firstVersion.id,
              defaultAudioStreamIndex: sourceWithStreams.defaultAudioStreamIndex,
              defaultSubStreamIndex: sourceWithStreams.defaultSubtitleStreamIndex,
              videoStreams: streams
                  .where((element) => element.type == MediaStreamType.video)
                  .map((e) => VideoStreamModel.fromMediaStream(e))
                  .toList(),
              audioStreams: audioStreams,
              subStreams: subStreams,
            );

            final updatedVersionStreams = [
              updatedFirstVersion,
              ...currentEpisode.mediaStreams.versionStreams.skip(1),
            ];

            state = state.copyWith(
              episode: currentEpisode.copyWith(
                mediaStreams: currentEpisode.mediaStreams.copyWith(
                  versionStreams: updatedVersionStreams,
                  defaultAudioStreamIndex: sourceWithStreams.defaultAudioStreamIndex,
                  defaultSubStreamIndex: sourceWithStreams.defaultSubtitleStreamIndex,
                ),
              ),
            );
          }
        }
      } catch (e) {
        // Ignore error
      }
    }
  }
}
