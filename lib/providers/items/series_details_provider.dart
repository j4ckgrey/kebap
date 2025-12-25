import 'dart:developer';

import 'package:chopper/chopper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kebap/jellyfin/jellyfin_open_api.swagger.dart';
import 'package:kebap/models/item_base_model.dart';
import 'package:kebap/models/items/episode_model.dart';
import 'package:kebap/models/items/season_model.dart';
import 'package:kebap/models/items/series_model.dart';
import 'package:kebap/providers/api_provider.dart';
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

      final newEpisodes = EpisodeModel.episodesFromDto(
        episodes.body?.items,
        ref,
      );

      final nextUpEpisode = newEpisodes.nextUp ?? newEpisodes.firstOrNull;

      // Only override if the Series itself has no backdrops
      if (newState.images?.backDrop?.isEmpty ?? true) {
        if (nextUpEpisode != null) {
          if (nextUpEpisode.images?.backDrop?.isNotEmpty ?? false) {
            newState = newState.copyWith(
              images: newState?.images?.copyWith(
                backDrop: () => nextUpEpisode.images!.backDrop,
              ),
            );
          } else if (nextUpEpisode.images?.primary != null) {
            newState = newState.copyWith(
              images: newState?.images?.copyWith(
                backDrop: () => [nextUpEpisode.images!.primary!],
              ),
            );
          }
        }
      }

      final episodesCanDownload =
          newEpisodes.any((episode) => episode.canDownload == true);

      newState = newState!.copyWith(
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
    final index = state?.availableEpisodes?.indexOf(episode);

    if (index != null) {
      state = state?.copyWith(
        availableEpisodes: state?.availableEpisodes
          ?..remove(episode)
          ..insert(index, episode),
      );
    }
  }
}
