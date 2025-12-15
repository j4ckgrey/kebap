import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kebap/models/media_playback_model.dart';
import 'package:kebap/models/playback/playback_model.dart';
import 'package:kebap/providers/settings/video_player_settings_provider.dart';
import 'package:kebap/util/debouncer.dart';
import 'package:kebap/wrappers/media_control_wrapper.dart';

final mediaPlaybackProvider = StateProvider<MediaPlaybackModel>((ref) => MediaPlaybackModel());

final playBackModel = StateProvider<PlaybackModel?>((ref) => null);

final videoPlayerProvider = StateNotifierProvider<VideoPlayerNotifier, MediaControlsWrapper>((ref) {
  final videoPlayer = VideoPlayerNotifier(ref);
  videoPlayer.init();
  return videoPlayer;
});

class VideoPlayerNotifier extends StateNotifier<MediaControlsWrapper> {
  VideoPlayerNotifier(this.ref) : super(MediaControlsWrapper(ref: ref));

  final Ref ref;

  List<StreamSubscription> subscriptions = [];

  late final mediaState = ref.read(mediaPlaybackProvider.notifier);

  MediaPlaybackModel get playbackState => ref.read(mediaPlaybackProvider);

  final Debouncer debouncer = Debouncer(const Duration(milliseconds: 125));

  final Completer<void> _initCompleter = Completer();

  void init() async {
    debouncer.run(() async {
      await state.dispose();
      await state.init();

      for (final s in subscriptions) {
        s.cancel();
      }

      final subscription = state.stateStream?.listen((value) {
        updateBuffering(value.buffering);
        updateBuffer(value.buffer);
        updatePlaying(value.playing);
        updatePosition(value.position);
        updateDuration(value.duration);
      });

      if (subscription != null) {
        subscriptions.add(subscription);
      }
      if (!_initCompleter.isCompleted) _initCompleter.complete();
    });
  }

  Future<void> updateBuffering(bool event) async =>
      mediaState.update((state) => state.buffering == event ? state : state.copyWith(buffering: event));

  Future<void> updateBuffer(Duration buffer) async {
    mediaState.update(
      (state) => (state.buffer - buffer).inSeconds.abs() < 1
          ? state
          : state.copyWith(
              buffer: buffer,
            ),
    );
  }

  Future<void> updateDuration(Duration duration) async {
    mediaState.update((state) {
      return (state.duration - duration).inSeconds.abs() < 1
          ? state
          : state.copyWith(
              duration: duration,
            );
    });
  }

  Future<void> updatePlaying(bool event) async {
    final currentState = playbackState;
    if (!state.hasPlayer || currentState.playing == event) return;
    mediaState.update(
      (state) => state.copyWith(playing: event),
    );
    ref.read(playBackModel)?.updatePlaybackPosition(currentState.position, currentState.playing, ref);
  }

  Future<void> updatePosition(Duration event) async {
    if (!state.hasPlayer) return;
    if (playbackState.playing == false) return;
    final currentState = playbackState;
    final currentPosition = currentState.position;

    if ((currentPosition - event).inSeconds.abs() < 1) return;

    final position = event;

    final lastPosition = currentState.lastPosition;
    final diff = (position.inMilliseconds - lastPosition.inMilliseconds).abs();

    if (diff > const Duration(seconds: 10).inMilliseconds) {
      mediaState.update((value) => value.copyWith(
            position: event,
            lastPosition: position,
          ));
      ref.read(playBackModel)?.updatePlaybackPosition(position, playbackState.playing, ref);
    } else {
      mediaState.update((value) => value.copyWith(
            position: event,
          ));
    }
  }

  Future<bool> loadPlaybackItem(PlaybackModel model, Duration startPosition) async {
    if (!_initCompleter.isCompleted) await _initCompleter.future;
    await state.stop();
    mediaState
        .update((state) => state.copyWith(state: VideoPlayerState.fullScreen, buffering: true, errorPlaying: false));

    final media = model.media;
    PlaybackModel? newPlaybackModel = model;

    if (media != null) {
      try {
        await state.loadVideo(model, startPosition, false);
        await state.setVolume(ref.read(videoPlayerSettingsProvider).volume);
        
        final start = startPosition;
        
        debugPrint('[VideoPlayerProvider] Loading video with startPosition: ${start.inSeconds}s');
        
        // Use a more robust approach: wait for buffering to complete AND for the player to be ready
        final completer = Completer<void>();
        StreamSubscription? subscription;
        Timer? timeoutTimer;
        
        subscription = state.stateStream?.listen((event) {
          // debugPrint('[VideoPlayerProvider] State update: buffering=${event.buffering}, position=${event.position.inSeconds}s');
          
          if (!event.buffering && !completer.isCompleted) {
            debugPrint('[VideoPlayerProvider] Buffering complete, seeking to ${start.inSeconds}s');
            completer.complete();
            subscription?.cancel();
            timeoutTimer?.cancel();
            
            // Perform seek, audio/subtitle setup, and play in sequence
            Future.microtask(() async {
              try {
                if (start != Duration.zero) {
                  await state.seek(start);
                  debugPrint('[VideoPlayerProvider] Seek completed to ${start.inSeconds}s');
                  // Give the player a moment to process the seek
                  await Future.delayed(const Duration(milliseconds: 100));
                }
                await state.setAudioTrack(null, model);
                await state.setSubtitleTrack(null, model);
                await state.play();
                debugPrint('[VideoPlayerProvider] Playback started');
                ref.read(playBackModel.notifier).update((state) => newPlaybackModel);
              } catch (e) {
                debugPrint('[VideoPlayerProvider] Error in post-buffering setup: $e');
              }
            });
          }
        });
        
        // Add a timeout to handle cases where buffering never completes
        timeoutTimer = Timer(const Duration(seconds: 30), () {
          if (!completer.isCompleted) {
            debugPrint('[VideoPlayerProvider] Buffering timeout reached, forcing playback start');
            completer.complete();
            subscription?.cancel();
            
            // Try to start anyway
            Future.microtask(() async {
              try {
                if (start != Duration.zero) {
                  await state.seek(start);
                }
                await state.setAudioTrack(null, model);
                await state.setSubtitleTrack(null, model);
                await state.play();
                ref.read(playBackModel.notifier).update((state) => newPlaybackModel);
              } catch (e) {
                debugPrint('[VideoPlayerProvider] Error in timeout fallback: $e');
              }
            });
          }
        });

        ref.read(playBackModel.notifier).update((state) => model);

        return true;
      } catch (e) {
        // Handle network errors (404, connection refused, etc.) gracefully
        debugPrint('[VideoPlayerProvider] Error loading video: $e');
        mediaState.update((state) => state.copyWith(errorPlaying: true, buffering: false));
        return false;
      }
    }

    mediaState.update((state) => state.copyWith(errorPlaying: true));
    return false;
  }

  Future<void> openPlayer(BuildContext context) async => state.openPlayer(context);
}
