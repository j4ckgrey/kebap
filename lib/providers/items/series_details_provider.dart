import 'package:chopper/chopper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kebap/jellyfin/jellyfin_open_api.swagger.dart';
import 'package:kebap/models/item_base_model.dart';
import 'package:kebap/models/items/episode_model.dart';
import 'package:kebap/models/items/media_streams_model.dart';
import 'package:kebap/models/items/season_model.dart';
import 'package:kebap/models/items/series_model.dart';
import 'package:kebap/providers/api_provider.dart';
import 'package:kebap/providers/baklava_requests_provider.dart';
import 'package:kebap/providers/related_provider.dart';
import 'package:kebap/providers/service_provider.dart';

final seriesDetailsProvider =
    StateNotifierProvider.autoDispose.family<SeriesDetailViewNotifier, SeriesModel?, String>((ref, id) {
  return SeriesDetailViewNotifier(ref);
});

class SeriesDetailViewNotifier extends StateNotifier<SeriesModel?> {
  SeriesDetailViewNotifier(this.ref) : super(null);

  final Ref ref;

  late final JellyService api = ref.read(jellyApiProvider);

  Future<Response?> fetchDetails(ItemBaseModel seriesModel) async {
    try {
      if (seriesModel is SeriesModel) {
        state = state ?? seriesModel;
      }
      SeriesModel? newState;
      final response = await api.itemsGet(
        ids: [seriesModel.id],
        enableImageTypes: [
          ImageType.backdrop,
          ImageType.primary,
          ImageType.logo,
          ImageType.banner
        ],
        fields: [
          ItemFields.overview,
          ItemFields.genres,
          ItemFields.parentid,
          ItemFields.datecreated,
          ItemFields.primaryimageaspectratio,
          ItemFields.mediastreams,
          ItemFields.mediasources,
        ],
      );
      if (response.body == null || response.body!.items.isEmpty) return null;
      newState = response.body!.items.first as SeriesModel;

      // CRITICAL: Use newState.id (canonical ID from response) instead of seriesModel.id!
      // Gelato may redirect to a different canonical ID, so we must use the response's ID.
      final effectiveSeriesId = newState.id;

      final seasons = await api.showsSeriesIdSeasonsGet(seriesId: effectiveSeriesId, fields: [
        ItemFields.mediastreams,
        ItemFields.mediasources,
        ItemFields.overview,
        ItemFields.candownload,
        ItemFields.childcount,
      ]);

      final episodes = await api.showsSeriesIdEpisodesGet(
        seriesId: effectiveSeriesId,
        enableImageTypes: [
          ImageType.backdrop,
          ImageType.primary,
          ImageType.logo,
          ImageType.banner,
          ImageType.thumb,
        ],
        enableUserData: true,
        enableImages: true,
        fields: [
          ItemFields.mediastreams,
          ItemFields.mediasources,
          ItemFields.overview,
          ItemFields.candownload,
          ItemFields.childcount,
          ItemFields.primaryimageaspectratio,
          ItemFields.seasonuserdata,
          ItemFields.datecreated,
        ],
      );

      var newEpisodes = EpisodeModel.episodesFromDto(
        episodes.body?.items,
        ref,
      );

      var nextUpEpisode = newEpisodes.nextUp ?? newEpisodes.firstOrNull;

      // Fetch media streams for nextUp episode from Baklava (like episode_details_provider)
      if (nextUpEpisode != null) {
        var currentNextUp = nextUpEpisode;
        
        // Fetch full episode details to ensure we have media sources/ids
        try {
          final fullEpisodeResponse = await api.usersUserIdItemsItemIdGet(itemId: currentNextUp.id);
          if (fullEpisodeResponse.body != null) {
            currentNextUp = fullEpisodeResponse.bodyOrThrow as EpisodeModel;
            // Update the episode in newEpisodes list
            final epIndex = newEpisodes.indexWhere((e) => e.id == currentNextUp.id);
            if (epIndex >= 0) {
              newEpisodes = List.from(newEpisodes)..[epIndex] = currentNextUp;
            }
          }
        } catch (e) {
          debugPrint('[SeriesDetail] Error fetching full episode details: $e');
        }

        final effectiveItemId = currentNextUp.id;

        // If item has no media sources (non-Gelato items), fetch from PlaybackInfo
        if (currentNextUp.mediaStreams.versionStreams.isEmpty) {
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
              currentNextUp = currentNextUp.copyWith(
                mediaStreams: MediaStreamsModel.fromMediaStreamsList(playbackInfo.body!.mediaSources, ref),
              );
              // Update the episode in newEpisodes list
              final epIndex = newEpisodes.indexWhere((e) => e.id == effectiveItemId);
              if (epIndex >= 0) {
                newEpisodes = List.from(newEpisodes)..[epIndex] = currentNextUp;
              }
            }
          } catch (e) {
            // Ignore error
          }
        }

        final firstVersion = currentNextUp.mediaStreams.versionStreams.firstOrNull;
        final totalStreams = (firstVersion?.videoStreams.length ?? 0) +
            (firstVersion?.audioStreams.length ?? 0) +
            (firstVersion?.subStreams.length ?? 0);

        debugPrint('[SeriesDetail] NextUp: ${currentNextUp.name}, version: ${firstVersion?.name}, streams: $totalStreams, id: ${firstVersion?.id}');

        if (firstVersion != null &&
            (totalStreams == 0 || (firstVersion.audioStreams.isEmpty) || (firstVersion.subStreams.isEmpty)) &&
            firstVersion.id != null) {
          // Set loading state
          currentNextUp = currentNextUp.copyWith(
            mediaStreams: currentNextUp.mediaStreams.copyWith(isLoading: true),
          );
          // Update the episode in newEpisodes list
          final epLoadingIndex = newEpisodes.indexWhere((e) => e.id == effectiveItemId);
          if (epLoadingIndex >= 0) {
            newEpisodes = List.from(newEpisodes)..[epLoadingIndex] = currentNextUp;
          }

          // Push local state change for loading indicator
          state = newState.copyWith(availableEpisodes: newEpisodes);

          try {
            final baklavaService = ref.read(baklavaServiceProvider);
            final streamsResponse = await baklavaService.getMediaStreams(
              itemId: effectiveItemId,
              mediaSourceId: firstVersion.id,
            );

            debugPrint('[SeriesDetail] Baklava response body: ${streamsResponse.body}');

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
                ...currentNextUp.mediaStreams.versionStreams.skip(1),
              ];

              // Update nextUpEpisode with new streams
              currentNextUp = currentNextUp.copyWith(
                mediaStreams: currentNextUp.mediaStreams.copyWith(
                  isLoading: false,
                  versionStreams: updatedVersionStreams,
                  defaultAudioStreamIndex: audioStreams.firstOrNull?.index,
                  defaultSubStreamIndex: subStreams.firstOrNull?.index,
                ),
              );

              // Update the episode in newEpisodes list as well
              final epIndex = newEpisodes.indexWhere((e) => e.id == effectiveItemId);
              if (epIndex >= 0) {
                newEpisodes = List.from(newEpisodes)..[epIndex] = currentNextUp;
              }
            }
          } catch (e) {
            // Ignore error, but clear loading state
            currentNextUp = currentNextUp.copyWith(
              mediaStreams: currentNextUp.mediaStreams.copyWith(isLoading: false),
            );
            final epIndex = newEpisodes.indexWhere((e) => e.id == effectiveItemId);
            if (epIndex >= 0) {
              newEpisodes = List.from(newEpisodes)..[epIndex] = currentNextUp;
            }
          }
        }
        nextUpEpisode = currentNextUp;
      }
    // Only override if the Series itself has no backdrops
      if (newState.images?.backDrop?.isEmpty ?? true) {
        if (nextUpEpisode != null) {
          final nextUpImages = nextUpEpisode.images;
          if (nextUpImages?.backDrop?.isNotEmpty ?? false) {
            final backDrop = nextUpImages!.backDrop;
            newState = newState.copyWith(
              images: newState.images?.copyWith(
                backDrop: () => backDrop,
              ),
            );
          } else if (nextUpImages?.primary != null) {
            final primary = nextUpImages!.primary!;
            newState = newState.copyWith(
              images: newState.images?.copyWith(
                backDrop: () => [primary],
              ),
            );
          }
        }
      }



      final episodesCanDownload =
          newEpisodes.any((episode) => episode.canDownload == true);

      newState = newState.copyWith(
        seasons: SeasonModel.seasonsFromDto(seasons.body?.items, ref)
            .map((element) => element.copyWith(
                  canDownload: true,
                  episodes: newEpisodes
                      .where((episode) => episode.season == element.season)
                      .toList(),
                ))
            .toList(),
      );

      newState = newState.copyWith(
        canDownload: episodesCanDownload,
        availableEpisodes: newEpisodes,
      );

      final related =
          await ref.read(relatedUtilityProvider).relatedContent(effectiveSeriesId);
      state = newState.copyWith(related: related.body);
      return response;
    } catch (e) {
      print("Error fetching series details: $e");
      return null;
    }
  }

  void updateEpisodeInfo(EpisodeModel episode) {
    if (state?.availableEpisodes == null) return;
    
    final index = state!.availableEpisodes!.indexWhere((e) => e.id == episode.id);

    if (index != -1) {
      final updatedEpisodes = List<EpisodeModel>.from(state!.availableEpisodes!);
      updatedEpisodes[index] = episode;
      
      state = state!.copyWith(
        availableEpisodes: updatedEpisodes,
      );
    }
  }
}
