import 'package:chopper/chopper.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:kebap/jellyfin/jellyfin_open_api.swagger.dart';
import 'package:kebap/models/item_base_model.dart';
import 'package:kebap/models/items/media_streams_model.dart';
import 'package:kebap/models/items/movie_model.dart';
import 'package:kebap/providers/api_provider.dart';
import 'package:kebap/providers/related_provider.dart';
import 'package:kebap/providers/service_provider.dart';

part 'movies_details_provider.g.dart';

@riverpod
class MovieDetails extends _$MovieDetails {
  late final JellyService api = ref.read(jellyApiProvider);

  @override
  MovieModel? build(String arg) => null;

  Future<Response?> fetchDetails(ItemBaseModel item) async {
    try {
      if (item is MovieModel) {
        state = state ?? item;
      }
      MovieModel? newState;
      final response = await api.usersUserIdItemsItemIdGet(itemId: item.id);
      if (response.body == null) return null;
      newState = (response.bodyOrThrow as MovieModel).copyWith(related: state?.related);
      
      // Preserve existing media streams if new state has none (prevents UI flicker)
      if (state?.mediaStreams.versionStreams.isNotEmpty == true && newState.mediaStreams.versionStreams.isEmpty) {
        newState = newState.copyWith(mediaStreams: state!.mediaStreams);
      }
      
      // If item has no media sources (non-Gelato items), fetch from PlaybackInfo
      if (newState.mediaStreams.versionStreams.isEmpty) {
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
            newState = newState.copyWith(
              mediaStreams: MediaStreamsModel.fromMediaStreamsList(playbackInfo.body!.mediaSources, ref),
            );
          }
        } catch (e) {
          // Ignore error, use empty streams
        }
      } else {
        // Check if first version has 0 streams and fetch them
        final firstVersion = newState.mediaStreams.versionStreams.firstOrNull;
        final totalStreams = (firstVersion?.videoStreams.length ?? 0) + 
                             (firstVersion?.audioStreams.length ?? 0) + 
                             (firstVersion?.subStreams.length ?? 0);
        
        if (firstVersion != null && totalStreams == 0 && firstVersion.id != null) {
          // Set loading state before fetching
          newState = newState.copyWith(
            mediaStreams: newState.mediaStreams.copyWith(isLoading: true),
          );
          state = newState;
          
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
            
            if (playbackInfo.body?.mediaSources?.firstOrNull != null) {
              final sourceWithStreams = playbackInfo.body!.mediaSources!.first;
              
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
                  ...newState.mediaStreams.versionStreams.skip(1),
                ];
                
                newState = newState.copyWith(
                  mediaStreams: newState.mediaStreams.copyWith(
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
            if (newState != null) {
              newState = newState.copyWith(
                mediaStreams: newState.mediaStreams.copyWith(isLoading: false),
              );
            }
          }
        }
      }
      
      final related = await ref.read(relatedUtilityProvider).relatedContent(item.id);
      state = newState?.copyWith(related: related.body);
      return null;
    } catch (e) {
      return null;
    }
  }

  void setSubIndex(int index) {
    state = state?.copyWith(mediaStreams: state?.mediaStreams.copyWith(defaultSubStreamIndex: index));
  }

  void setAudioIndex(int index) {
    state = state?.copyWith(mediaStreams: state?.mediaStreams.copyWith(defaultAudioStreamIndex: index));
  }

  Future<void> setVersionIndex(int index) async {
    final newVersionStream = state?.mediaStreams.versionStreams.elementAtOrNull(index);
    
    // If the new version has no streams (not probed yet), we need to fetch them
    final totalStreams = (newVersionStream?.videoStreams.length ?? 0) + 
                         (newVersionStream?.audioStreams.length ?? 0) + 
                         (newVersionStream?.subStreams.length ?? 0);
    
    if (newVersionStream != null && totalStreams == 0 && newVersionStream.id != null) {
      // Set loading state and clear audio/sub selections
      state = state?.copyWith(
        mediaStreams: state?.mediaStreams.copyWith(
          versionStreamIndex: index,
          isLoading: true,
          defaultAudioStreamIndex: null,
          defaultSubStreamIndex: null,
        ),
      );
      
      try {
        final playbackInfo = await api.itemsItemIdPlaybackInfoPost(
          itemId: state!.id,
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
          final updatedVersionStreams = state!.mediaStreams.versionStreams.map((v) {
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
          
          state = state?.copyWith(
            mediaStreams: state?.mediaStreams.copyWith(
              versionStreamIndex: index,
              versionStreams: updatedVersionStreams,
              defaultAudioStreamIndex: sourceWithStreams.defaultAudioStreamIndex,
              defaultSubStreamIndex: sourceWithStreams.defaultSubtitleStreamIndex,
              isLoading: false,
            ),
          );
          return;
        }
      } catch (e) {
        // On error, clear loading state but keep version selected
        state = state?.copyWith(
          mediaStreams: state?.mediaStreams.copyWith(
            isLoading: false,
          ),
        );
      }
    } else {
      // Version already has streams, just switch to it
      final currentVersion = state?.mediaStreams.versionStreams.elementAtOrNull(index);
      state = state?.copyWith(
        mediaStreams: state?.mediaStreams.copyWith(
          versionStreamIndex: index,
          defaultAudioStreamIndex: currentVersion?.defaultAudioStreamIndex,
          defaultSubStreamIndex: currentVersion?.defaultSubStreamIndex,
        ),
      );
    }
  }
  Future<void> refreshStreams() async {
    final currentState = state;
    if (currentState == null) return;

    final firstVersion = currentState.mediaStreams.versionStreams.firstOrNull;
    final totalStreams = (firstVersion?.videoStreams.length ?? 0) +
        (firstVersion?.audioStreams.length ?? 0) +
        (firstVersion?.subStreams.length ?? 0);

    if (firstVersion != null && totalStreams == 0 && firstVersion.id != null) {
      debugPrint('[StreamRefresh] Polling specific version: ${firstVersion.id}');
      try {
        final playbackInfo = await api.itemsItemIdPlaybackInfoPost(
          itemId: currentState.id,
          body: PlaybackInfoDto(
            enableDirectPlay: true,
            enableDirectStream: true,
            enableTranscoding: false,
            autoOpenLiveStream: true,
            mediaSourceId: firstVersion.id,
          ),
        );

        debugPrint('[StreamRefresh] PlaybackInfo response code: ${playbackInfo.statusCode}');
        if (playbackInfo.body?.mediaSources?.firstOrNull != null) {
          final sourceWithStreams = playbackInfo.body!.mediaSources!.first;
          debugPrint('[StreamRefresh] Found source. Streams count: ${sourceWithStreams.mediaStreams?.length}');

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
              ...currentState.mediaStreams.versionStreams.skip(1),
            ];

            state = state?.copyWith(
              mediaStreams: state!.mediaStreams.copyWith(
                versionStreams: updatedVersionStreams,
                defaultAudioStreamIndex: sourceWithStreams.defaultAudioStreamIndex,
                defaultSubStreamIndex: sourceWithStreams.defaultSubtitleStreamIndex,
                // Do not set isLoading: false here as we didn't set it to true
              ),
            );
          }
        }
      } catch (e) {
        // Ignore error
      }
    } else if (currentState.mediaStreams.versionStreams.isEmpty) {
      debugPrint('[StreamRefresh] No versions found. Polling for initial media sources...');
      try {
        final playbackInfo = await api.itemsItemIdPlaybackInfoPost(
          itemId: currentState.id,
          body: const PlaybackInfoDto(
            enableDirectPlay: true,
            enableDirectStream: true,
            enableTranscoding: false,
          ),
        );

        debugPrint('[StreamRefresh] Initial PlaybackInfo response code: ${playbackInfo.statusCode}');
        if (playbackInfo.body?.mediaSources != null) {
             debugPrint('[StreamRefresh] Found sources: ${playbackInfo.body!.mediaSources!.length}');
        }

        if (playbackInfo.body?.mediaSources != null && playbackInfo.body!.mediaSources!.isNotEmpty) {
          state = state?.copyWith(
            mediaStreams: MediaStreamsModel.fromMediaStreamsList(playbackInfo.body!.mediaSources, ref),
          );
        }
      } catch (e) {
        debugPrint('[StreamRefresh] Error polling initial sources: $e');
        // Ignore error
      }
    }
  }
}
