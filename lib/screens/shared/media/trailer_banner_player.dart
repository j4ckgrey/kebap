import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart' as mpv;
import 'package:media_kit_video/media_kit_video.dart' as mpv_video;
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import 'package:kebap/util/kebap_image.dart';
import 'package:kebap/models/items/images_models.dart';

import 'package:kebap/providers/settings/home_settings_provider.dart';

/// A widget that plays a trailer video in the banner area.
/// Supports both direct video URLs and YouTube URLs.
/// Falls back to displaying an image if the trailer fails to load.
class TrailerBannerPlayer extends ConsumerStatefulWidget {
  // DEBUG: Force use of muxed streams to verify basic playback
  static const bool FORCE_MUXED = true;

  final String trailerUrl;
  final ImageData? fallbackImage;

  const TrailerBannerPlayer({
    super.key,
    required this.trailerUrl,
    this.fallbackImage,
  });

  @override
  ConsumerState<TrailerBannerPlayer> createState() => _TrailerBannerPlayerState();
}

class _TrailerBannerPlayerState extends ConsumerState<TrailerBannerPlayer> 
    with WidgetsBindingObserver, AutoRouteAwareStateMixin<TrailerBannerPlayer> {
  mpv.Player? _player;
  mpv_video.VideoController? _controller;
  bool _hasError = false;
  bool _isLoading = true;
  bool _isInitialized = false;
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Delay initialization on Linux to avoid PipeWire race condition crash
    if (Platform.isLinux) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) _initializePlayer();
      });
    } else {
      _initializePlayer();
    }
  }

  // AutoRouteAware callbacks
  @override
  void didPush() {
    debugPrint('[TrailerBannerPlayer] Route didPush - playing');
    _isVisible = true;
    if (_isInitialized) {
      _player?.play();
    }
  }

  @override
  void didPop() {
    debugPrint('[TrailerBannerPlayer] Route didPop - pausing');
    _isVisible = false;
    _player?.pause();
  }

  @override
  void didPushNext() {
    debugPrint('[TrailerBannerPlayer] Route didPushNext - pausing (new route pushed on top)');
    _isVisible = false;
    _player?.pause();
  }

  @override
  void didPopNext() {
    debugPrint('[TrailerBannerPlayer] Route didPopNext - playing (returned to this route)');
    _isVisible = true;
    if (_isInitialized) {
      _player?.play();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (_player == null || !_isInitialized) return;
    
    if (state == AppLifecycleState.resumed) {
      if (_isVisible) {
        _player?.play();
      }
    } else if (state == AppLifecycleState.paused || 
               state == AppLifecycleState.inactive) {
      _player?.pause();
    }
  }

  Future<void> _initializePlayer() async {
    YoutubeExplode? youtubeExplode;
    
    try {
      // Ensure MediaKit is initialized first
      mpv.MediaKit.ensureInitialized();

      // Create the player immediately
      _player = mpv.Player();
      _controller = mpv_video.VideoController(_player!);
      
      // Set up the player for banner mode
      final isMuted = ref.read(homeSettingsProvider).bannerTrailerMuted;
      debugPrint('[TrailerBannerPlayer] Muted: $isMuted');
      
      
      // Configure player with hardware acceleration and buffer settings
      // Skip on web as NativePlayer.setProperty is not available on web stub
      // Use dynamic typing to avoid dart2js compile-time errors
      if (!kIsWeb) {
        try {
          final dynamic nativePlayer = _player!.platform;
          if (nativePlayer != null) {
            await nativePlayer.setProperty('config', 'yes');
            
            // Enable hardware decoding
            // This is critical for Windows performance to avoid "squishy" 30fps feel
            // when software decoding takes up all CPU resources
            debugPrint('[TrailerBannerPlayer] Enabling hardware acceleration');
            await nativePlayer.setProperty('hwdec', 'auto');
            
            if (Platform.isWindows) {
               debugPrint('[TrailerBannerPlayer] Setting Windows GPU context to d3d11');
               await nativePlayer.setProperty('gpu-context', 'd3d11');
            }
          }
        } catch (e) {
          debugPrint('[TrailerBannerPlayer] Error setting native player properties: $e');
        }
      }

      await _player!.setVolume(isMuted ? 0 : 100);
      await _player!.setPlaylistMode(mpv.PlaylistMode.loop); // Loop

      String videoUrl = widget.trailerUrl;
      
      // Check if this is a YouTube URL
      final youtubeVideoId = _extractYouTubeVideoId(widget.trailerUrl);
      
      if (youtubeVideoId != null) {
        // ... (existing logic) ...
        youtubeExplode = YoutubeExplode();
        final urls = await _getYouTubeStreams(youtubeExplode, youtubeVideoId);
        videoUrl = urls.videoUrl;
        
        // Pass audio file if available (skip on web as setProperty not available)
        // Use dynamic typing to avoid dart2js compile-time errors
        if (urls.audioUrl != null && !isMuted && !kIsWeb) {
          try {
            final dynamic nativePlayer = _player!.platform;
            debugPrint('[TrailerBannerPlayer] Setting separate audio file: ${urls.audioUrl}');
            await nativePlayer.setProperty('audio-file', urls.audioUrl!);
          } catch (e) {
            debugPrint('[TrailerBannerPlayer] Error setting audio-file property: $e');
          }
        }
        
        youtubeExplode.close();
        youtubeExplode = null;
      }

      if (!mounted) return;

      // Open the video stream
      debugPrint('[TrailerBannerPlayer] Opening stream: $videoUrl');
      await _player!.open(mpv.Media(videoUrl), play: true);

      if (mounted) {
        setState(() {
          _isLoading = false;
          _isInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('[TrailerBannerPlayer] Error initializing player: $e');
      // Make sure to close YoutubeExplode if an error occurred
      youtubeExplode?.close();
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    }
  }

  /// Extracts YouTube video ID from a URL
  String? _extractYouTubeVideoId(String url) {
    final youtubeRegex = RegExp(
      r'^(?:https?:\/\/)?(?:www\.)?(?:youtube\.com\/watch\?v=|youtu\.be\/|youtube\.com\/embed\/)([a-zA-Z0-9_-]{11})',
    );
    
    final match = youtubeRegex.firstMatch(url);
    return match?.group(1);
  }

  /// Gets video URL from YouTube - intelligently picks best available stream
  /// Strategy:
  /// 1. Find best video-only stream (Highest resolution, e.g. 1080p, 4K)
  /// 2. Find best audio-only stream
  /// 3. Return both to be merged by player
  /// Fallback: Use muxed stream if no separate streams found
  Future<({String videoUrl, String? audioUrl})> _getYouTubeStreams(
    YoutubeExplode yt, 
    String videoId,
  ) async {
    final manifest = await yt.videos.streamsClient.getManifest(videoId);
    
    // 1. Get best candidates
    final videoOnlyStreams = manifest.videoOnly.toList();
    final audioOnlyStreams = manifest.audioOnly.toList();
    final muxedStreams = manifest.muxed.toList();
    
    // Sort Video-only by resolution (descending)
    videoOnlyStreams.sort((a, b) => b.videoResolution.height.compareTo(a.videoResolution.height));

    // Sort Audio-only by bitrate (descending)
    audioOnlyStreams.sort((a, b) => b.bitrate.compareTo(a.bitrate));

    // Sort Muxed by resolution (descending)
    muxedStreams.sort((a, b) => b.videoResolution.height.compareTo(a.videoResolution.height));

    // 2. Select the Best Strategy
    final bestSeparateVideo = videoOnlyStreams.isNotEmpty ? videoOnlyStreams.first : null;
    final bestSeparateAudio = audioOnlyStreams.isNotEmpty ? audioOnlyStreams.first : null;
    final bestMuxed = muxedStreams.isNotEmpty ? muxedStreams.first : null;

    debugPrint('[TrailerBannerPlayer] Best Separate Candidate: ${bestSeparateVideo?.videoQuality.name} ${bestSeparateVideo?.videoResolution}');
    debugPrint('[TrailerBannerPlayer] Best Muxed Candidate: ${bestMuxed?.videoQuality.name} ${bestMuxed?.videoResolution}');

    // DEBUG: Force Muxed
    if (TrailerBannerPlayer.FORCE_MUXED) {
      debugPrint('[TrailerBannerPlayer] DEBUG: FORCE_MUXED is enabled. Skipping separate stream selection.');
    } else if (bestSeparateVideo != null && bestSeparateAudio != null) {
      // ...check if they are actually better than muxed (or if no muxed exists)
      bool isSeparateBetter = true;
      if (bestMuxed != null) {
        // If separate video is smaller than muxed video, don't use it!
        // E.g. Separate is 144p, Muxed is 360p -> Use Muxed
        if (bestSeparateVideo.videoResolution.height < bestMuxed.videoResolution.height) {
          isSeparateBetter = false;
        }
      }

      if (isSeparateBetter) {
        debugPrint('[TrailerBannerPlayer] Selected Strategy: Separate Streams (Better or Equal Quality)');
        return (videoUrl: bestSeparateVideo.url.toString(), audioUrl: bestSeparateAudio.url.toString());
      } else {
        debugPrint('[TrailerBannerPlayer] Strategy Override: Separate stream quality is lower than Muxed. Preferring Muxed.');
      }
    }
    
    // 3. Fallback to Muxed
    if (bestMuxed != null) {
      debugPrint('[TrailerBannerPlayer] Selected Strategy: Muxed Stream');
      return (videoUrl: bestMuxed.url.toString(), audioUrl: null);
    }

    throw Exception('No video streams available');
  }

  @override
  void deactivate() {
    debugPrint('[TrailerBannerPlayer] deactivate called');
    _isVisible = false;
    _player?.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    debugPrint('[TrailerBannerPlayer] dispose called');
    WidgetsBinding.instance.removeObserver(this);
    _player?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch for mute setting changes
    final isMuted = ref.watch(homeSettingsProvider.select((s) => s.bannerTrailerMuted));
    
    // Update volume when mute setting changes
    if (_isInitialized && _player != null) {
      _player!.setVolume(isMuted ? 0 : 100);
    }
    
    // Show loading indicator while initializing
    if (_isLoading) {
      return Stack(
        fit: StackFit.expand,
        children: [
          KebapImage(
            image: widget.fallbackImage,
            fit: BoxFit.cover,
          ),
          const Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ),
          ),
        ],
      );
    }

    // If there's an error, show fallback image
    if (_hasError || !_isInitialized) {
      return KebapImage(
        image: widget.fallbackImage,
        fit: BoxFit.cover,
      );
    }

    // Show the video player
    return ClipRRect(
      child: mpv_video.Video(
        controller: _controller!,
        fit: BoxFit.cover,
        controls: mpv_video.NoVideoControls,
      ),
    );
  }
}
