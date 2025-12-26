import 'package:chopper/chopper.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:kebap/jellyfin/jellyfin_open_api.swagger.dart';
import 'package:kebap/models/item_base_model.dart';
import 'package:kebap/models/items/media_streams_model.dart';
import 'package:kebap/models/items/movie_model.dart';
import 'package:kebap/providers/api_provider.dart';
import 'package:kebap/providers/baklava_requests_provider.dart';
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

      // Fetch detailed item information
      final response = await api.usersUserIdItemsItemIdGet(
        itemId: item.id!,
      );

      if (response.body == null) {
        return null;
      }
      newState = (response.bodyOrThrow as MovieModel).copyWith(related: state?.related);
      
      // Preserve media streams from input item if it has MORE versions than API response
      // AND if the IDs match (to avoid mixing metadata from different items/redirects)
      final inputVersionCount = (item is MovieModel) ? item.mediaStreams.versionStreams.length : 0;
      final responseVersionCount = newState.mediaStreams.versionStreams.length;
      
      if (item.id == newState.id) { // CRITICAL CHECKS
        if (inputVersionCount > responseVersionCount) {
          newState = newState.copyWith(mediaStreams: (item as MovieModel).mediaStreams);
        } else if (state?.mediaStreams.versionStreams.isNotEmpty == true && newState.mediaStreams.versionStreams.isEmpty) {
          newState = newState.copyWith(mediaStreams: state!.mediaStreams);
        }
      }
      
      // CRITICAL: Use newState.id (canonical ID from response) instead of item.id!
      // Gelato may redirect to a different canonical ID, so we must use the response's ID.
      final effectiveItemId = newState.id;
      
      // If item has no media sources (non-Gelato items), fetch from PlaybackInfo
      if (newState.mediaStreams.versionStreams.isEmpty) {
        debugPrint('[MovieDetailsProvider] No versions, trying PlaybackInfo...');
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
            newState = newState.copyWith(
              mediaStreams: MediaStreamsModel.fromMediaStreamsList(playbackInfo.body!.mediaSources, ref),
            );
          }
        } catch (e) {
          // Ignore error, use empty streams
        }
      } else {
        final firstVersion = newState.mediaStreams.versionStreams.firstOrNull;
        final totalStreams = (firstVersion?.videoStreams.length ?? 0) + 
                             (firstVersion?.audioStreams.length ?? 0) + 
                             (firstVersion?.subStreams.length ?? 0);
        
        if (firstVersion != null &&
            (totalStreams == 0 ||
                (firstVersion.audioStreams.isEmpty) ||
                (firstVersion.subStreams.isEmpty)) &&
            firstVersion.id != null) {
          newState = newState.copyWith(
            mediaStreams: newState.mediaStreams.copyWith(isLoading: true),
          );
          state = newState;
          
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
                ...newState.mediaStreams.versionStreams.skip(1),
              ];
              
              newState = newState.copyWith(
                mediaStreams: newState.mediaStreams.copyWith(
                  versionStreams: updatedVersionStreams,
                  defaultAudioStreamIndex: audioStreams.firstOrNull?.index,
                  defaultSubStreamIndex: subStreams.firstOrNull?.index,
                  isLoading: false,
                ),
              );
            }
          } catch (e) {
            // Ignore error, use empty streams, clear loading state
            newState = newState?.copyWith(
              mediaStreams: newState?.mediaStreams.copyWith(isLoading: false) ?? newState.mediaStreams,
            ) ?? newState;
          }
        }
      }
      
      final related = await ref.read(relatedUtilityProvider).relatedContent(effectiveItemId);
      state = newState?.copyWith(related: related.body);
      debugPrint('[MovieDetailsProvider] ========== FETCH DETAILS END ==========');
      debugPrint('[MovieDetailsProvider] Final state.id: ${state?.id}');
      debugPrint('[MovieDetailsProvider] Final state has ${state?.mediaStreams.versionStreams.length ?? 0} versions');
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
    debugPrint('[setVersionIndex] Called with index: $index');
    final newVersionStream = state?.mediaStreams.versionStreams.elementAtOrNull(index);
    if (newVersionStream == null) {
      debugPrint('[setVersionIndex] newVersionStream is null, returning');
      return;
    }
    debugPrint('[setVersionIndex] newVersionStream.id: ${newVersionStream.id}, audio: ${newVersionStream.audioStreams.length}, subs: ${newVersionStream.subStreams.length}');
    
    // First, switch to this version immediately (no loading state)
    state = state?.copyWith(
      mediaStreams: state?.mediaStreams.copyWith(
        versionStreamIndex: index,
        defaultAudioStreamIndex: newVersionStream.defaultAudioStreamIndex,
        defaultSubStreamIndex: newVersionStream.defaultSubStreamIndex,
      ),
    );
    
    // Always fetch from Baklava to get complete stream data
    // (Jellyfin initial data may be incomplete)
    if (newVersionStream.id != null && state != null) {
      debugPrint('[setVersionIndex] Fetching from Baklava for mediaSourceId: ${newVersionStream.id}');
      try {
        final baklavaService = ref.read(baklavaServiceProvider);
        final streamsResponse = await baklavaService.getMediaStreams(
          itemId: state!.id,
          mediaSourceId: newVersionStream.id,
        );
        
        debugPrint('[setVersionIndex] Baklava response body: ${streamsResponse.body}');
        
        if (streamsResponse.body != null) {
          final audioList = (streamsResponse.body!['audio'] as List?)?.cast<Map<String, dynamic>>() ?? [];
          final subsList = (streamsResponse.body!['subs'] as List?)?.cast<Map<String, dynamic>>() ?? [];
          
          debugPrint('[setVersionIndex] Parsed ${audioList.length} audio, ${subsList.length} subs');
          
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
          
          debugPrint('[setVersionIndex] Built ${audioStreams.length} AudioStreamModels, ${subStreams.length} SubStreamModels');
          
          // Update ONLY this version's data, using list position (enumerate)
          int listIndex = 0;
          final updatedVersionStreams = state!.mediaStreams.versionStreams.map((v) {
            final currentListIndex = listIndex++;
            if (currentListIndex == index) {
              debugPrint('[setVersionIndex] Updating version at list position $currentListIndex');
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
          
          state = state?.copyWith(
            mediaStreams: state?.mediaStreams.copyWith(
              versionStreams: updatedVersionStreams,
              defaultAudioStreamIndex: audioStreams.firstOrNull?.index,
              defaultSubStreamIndex: subStreams.firstOrNull?.index,
            ),
          );
          debugPrint('[setVersionIndex] State updated with new streams');
        }
      } catch (e, stack) {
        debugPrint('[setVersionIndex] Error: $e\n$stack');
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
    final currentState = state;
    if (currentState == null) return;

    final firstVersion = currentState.mediaStreams.versionStreams.firstOrNull;
    final totalStreams = (firstVersion?.videoStreams.length ?? 0) +
        (firstVersion?.audioStreams.length ?? 0) +
        (firstVersion?.subStreams.length ?? 0);

    if (firstVersion != null &&
        (totalStreams == 0 ||
            (firstVersion.audioStreams.isEmpty) ||
            (firstVersion.subStreams.isEmpty)) &&
        firstVersion.id != null) {
      try {
        final baklavaService = ref.read(baklavaServiceProvider);
        final streamsResponse = await baklavaService.getMediaStreams(
          itemId: currentState.id,
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
          
          // Check equality before updating
          if (_areAudioStreamsEqual(firstVersion.audioStreams, audioStreams) &&
              _areSubStreamsEqual(firstVersion.subStreams, subStreams)) {
            // No changes, skip update to prevent rebuilds/flicker
            return;
          }

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
            ...currentState.mediaStreams.versionStreams.skip(1),
          ];

          state = state?.copyWith(
            mediaStreams: state!.mediaStreams.copyWith(
              versionStreams: updatedVersionStreams,
              defaultAudioStreamIndex: audioStreams.firstOrNull?.index,
              defaultSubStreamIndex: subStreams.firstOrNull?.index,
            ),
          );
        }
      } catch (e) {
        // Ignore error
      }
    } else if (currentState.mediaStreams.versionStreams.isEmpty) {
      try {
        final playbackInfo = await api.itemsItemIdPlaybackInfoPost(
          itemId: currentState.id,
          body: const PlaybackInfoDto(
            enableDirectPlay: true,
            enableDirectStream: true,
            enableTranscoding: false,
          ),
        );

        if (playbackInfo.body?.mediaSources != null && playbackInfo.body!.mediaSources!.isNotEmpty) {
           // Basic equality check for version count (simple heuristic)
           final newStreams = MediaStreamsModel.fromMediaStreamsList(playbackInfo.body!.mediaSources, ref);
           if (newStreams.versionStreams.length == currentState.mediaStreams.versionStreams.length) {
             // Deeper check needed? For now, if versions match count 0->0, no update.
             // But here we are in isEmpty block, so count is 0. If new is >0, we definitely update.
             if (newStreams.versionStreams.isEmpty) return;
           }
           
          state = state?.copyWith(
            mediaStreams: newStreams,
          );
        }
      } catch (e) {
        // Ignore error
      }
    }
  }
}

