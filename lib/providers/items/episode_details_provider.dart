import 'package:chopper/chopper.dart';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kebap/jellyfin/jellyfin_open_api.swagger.dart';
import 'package:kebap/models/item_base_model.dart';
import 'package:kebap/models/items/episode_model.dart';
import 'package:kebap/models/items/item_shared_models.dart';
import 'package:kebap/models/items/media_streams_model.dart';
import 'package:kebap/models/items/series_model.dart';
import 'package:kebap/providers/api_provider.dart';
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

      // Preserve existing media streams if new state has none (prevents UI flicker)
      if (state.episode?.mediaStreams.versionStreams.isNotEmpty == true && episode.mediaStreams.versionStreams.isEmpty) {
        episode = episode.copyWith(mediaStreams: state.episode!.mediaStreams);
      }

      // If item has no media sources (non-Gelato items), fetch from PlaybackInfo
      if (episode.mediaStreams.versionStreams.isEmpty) {
        try {
          final playbackInfo = await api.itemsItemIdPlaybackInfoPost(
            itemId: item.id,
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

      // Check if first version has 0 streams and fetch them
      final firstVersion = episode.mediaStreams.versionStreams.firstOrNull;
      final totalStreams = (firstVersion?.videoStreams.length ?? 0) + 
                           (firstVersion?.audioStreams.length ?? 0) + 
                           (firstVersion?.subStreams.length ?? 0);
      
      if (firstVersion != null && totalStreams == 0 && firstVersion.id != null) {
        // Set loading state before fetching
        episode = episode.copyWith(
          mediaStreams: episode.mediaStreams.copyWith(isLoading: true),
        );
        state = state.copyWith(episode: episode);
        
        try {
          final playbackInfo = await api.itemsItemIdPlaybackInfoPost(
            itemId: item.id,
            body: PlaybackInfoDto(
              enableDirectPlay: true,
              enableDirectStream: true,
              enableTranscoding: false,
              autoOpenLiveStream: true,
              mediaSourceId: firstVersion.id,
            ),
          );
          
          final mediaSources = playbackInfo.body?.mediaSources;
          if (mediaSources != null && mediaSources.firstOrNull != null) {
            final sourceWithStreams = mediaSources.first;
            
            if (sourceWithStreams.mediaStreams != null) {
              final streams = sourceWithStreams.mediaStreams!;
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
                audioStreams: streams
                    .where((element) => element.type == MediaStreamType.audio)
                    .map((e) => AudioStreamModel.fromMediaStream(e))
                    .toList(),
                subStreams: streams
                    .where((element) => element.type == MediaStreamType.subtitle)
                    .map((sub) => SubStreamModel.fromMediaStream(sub, ref))
                    .toList(),
              );
              
                final updatedVersionStreams = [
                updatedFirstVersion,
                ...episode.mediaStreams.versionStreams.skip(1),
              ];
              
              episode = episode.copyWith(
                mediaStreams: episode.mediaStreams.copyWith(
                  versionStreams: updatedVersionStreams,
                  defaultAudioStreamIndex: sourceWithStreams.defaultAudioStreamIndex,
                  defaultSubStreamIndex: sourceWithStreams.defaultSubtitleStreamIndex,
                  isLoading: false,
                ),
              );
            }
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
    final newVersionStream = state.episode?.mediaStreams.versionStreams.elementAtOrNull(index);
    
    // If the new version has no streams (not probed yet), we need to fetch them
    final totalStreams = (newVersionStream?.videoStreams.length ?? 0) + 
                         (newVersionStream?.audioStreams.length ?? 0) + 
                         (newVersionStream?.subStreams.length ?? 0);
    
    if (newVersionStream != null && totalStreams == 0 && newVersionStream.id != null && state.episode != null) {
      // Set loading state and clear audio/sub selections
      state = state.copyWith(
        episode: state.episode?.copyWith(
          mediaStreams: state.episode?.mediaStreams.copyWith(
            versionStreamIndex: index,
            isLoading: true,
            defaultAudioStreamIndex: null,
            defaultSubStreamIndex: null,
          ),
        ),
      );
      
      try {
        final playbackInfo = await api.itemsItemIdPlaybackInfoPost(
          itemId: state.episode!.id,
          body: PlaybackInfoDto(
            enableDirectPlay: true,
            enableDirectStream: true,
            enableTranscoding: false,
            autoOpenLiveStream: true,
            mediaSourceId: newVersionStream.id,
          ),
        );
        
        if (playbackInfo.body?.mediaSources?.firstOrNull != null) {
          final sourceWithStreams = playbackInfo.body!.mediaSources!.first;
          
          // Update the version stream with the fetched streams
          final updatedVersionStreams = state.episode!.mediaStreams.versionStreams.map((v) {
            if (v.index == index && sourceWithStreams.mediaStreams != null) {
              final streams = sourceWithStreams.mediaStreams!;
              return VersionStreamModel(
                name: v.name,
                index: v.index,
                id: v.id,
                defaultAudioStreamIndex: sourceWithStreams.defaultAudioStreamIndex,
                defaultSubStreamIndex: sourceWithStreams.defaultSubtitleStreamIndex,
                videoStreams: streams
                    .where((element) => element.type == MediaStreamType.video)
                    .map((e) => VideoStreamModel.fromMediaStream(e))
                    .toList(),
                audioStreams: streams
                    .where((element) => element.type == MediaStreamType.audio)
                    .map((e) => AudioStreamModel.fromMediaStream(e))
                    .toList(),
                subStreams: streams
                    .where((element) => element.type == MediaStreamType.subtitle)
                    .map((sub) => SubStreamModel.fromMediaStream(sub, ref))
                    .toList(),
              );
            }
            return v;
          }).toList();
          
          state = state.copyWith(
            episode: state.episode?.copyWith(
              mediaStreams: state.episode?.mediaStreams.copyWith(
                versionStreamIndex: index,
                versionStreams: updatedVersionStreams,
                defaultAudioStreamIndex: sourceWithStreams.defaultAudioStreamIndex,
                defaultSubStreamIndex: sourceWithStreams.defaultSubtitleStreamIndex,
                isLoading: false,
              ),
            ),
          );
          return;
        }
      } catch (e) {
        // On error, clear loading state but keep version selected
        state = state.copyWith(
          episode: state.episode?.copyWith(
            mediaStreams: state.episode?.mediaStreams.copyWith(
              isLoading: false,
            ),
          ),
        );
      }
    } else {
      // Version already has streams, just switch to it
      final currentVersion = state.episode?.mediaStreams.versionStreams.elementAtOrNull(index);
      state = state.copyWith(
        episode: state.episode?.copyWith(
          mediaStreams: state.episode?.mediaStreams.copyWith(
            versionStreamIndex: index,
            defaultAudioStreamIndex: currentVersion?.defaultAudioStreamIndex,
            defaultSubStreamIndex: currentVersion?.defaultSubStreamIndex,
          ),
        ),
      );
    }
  }
}
