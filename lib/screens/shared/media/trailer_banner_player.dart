import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart' as mpv;
import 'package:media_kit_video/media_kit_video.dart' as mpv_video;
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import 'package:kebap/util/kebap_image.dart';
import 'package:kebap/models/items/images_models.dart';
import 'package:kebap/models/settings/home_settings_model.dart';
import 'package:kebap/providers/settings/home_settings_provider.dart';

/// A widget that plays a trailer video in the banner area.
/// Supports both direct video URLs and YouTube URLs.
/// Falls back to displaying an image if the trailer fails to load.
class TrailerBannerPlayer extends ConsumerStatefulWidget {
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
    _initializePlayer();
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
      String videoUrl = widget.trailerUrl;
      String? audioUrl;
      
      // Get quality and mute settings
      final quality = ref.read(homeSettingsProvider).bannerTrailerQuality;
      final isMuted = ref.read(homeSettingsProvider).bannerTrailerMuted;
      debugPrint('[TrailerBannerPlayer] Quality setting: $quality, muted: $isMuted');
      
      // Check if this is a YouTube URL
      final youtubeVideoId = _extractYouTubeVideoId(widget.trailerUrl);
      
      if (youtubeVideoId != null) {
        // Extract direct video URL from YouTube
        // Always use high-quality video-only streams, add separate audio if not muted
        youtubeExplode = YoutubeExplode();
        final urls = await _getYouTubeStreams(youtubeExplode, youtubeVideoId, quality, isMuted);
        videoUrl = urls.videoUrl;
        audioUrl = urls.audioUrl;
        // Close immediately after getting the URLs
        youtubeExplode.close();
        youtubeExplode = null;
      }

      if (!mounted) return;

      // Ensure MediaKit is initialized
      mpv.MediaKit.ensureInitialized();

      // Create the player
      _player = mpv.Player();
      _controller = mpv_video.VideoController(_player!);
      
      // Set up the player for banner mode
      await _player!.setVolume(isMuted ? 0 : 100);
      await _player!.setPlaylistMode(mpv.PlaylistMode.loop); // Loop

      // Open the video with optional external audio track for high quality + sound
      if (audioUrl != null && !isMuted) {
        // Use MPV's audio-file option to add external audio track
        debugPrint('[TrailerBannerPlayer] Opening with separate audio track for HQ + sound');
        await _player!.open(
          mpv.Media(videoUrl, extras: {'audio-file': audioUrl}),
          play: true,
        );
      } else {
        await _player!.open(mpv.Media(videoUrl), play: true);
      }

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

  /// Gets video and audio URLs from YouTube
  /// Always uses high-quality video-only streams (up to 4K)
  /// Returns separate audio URL when not muted for MPV to combine
  Future<({String videoUrl, String? audioUrl})> _getYouTubeStreams(
    YoutubeExplode yt, 
    String videoId, 
    TrailerQuality quality, 
    bool isMuted,
  ) async {
    final manifest = await yt.videos.streamsClient.getManifest(videoId);
    
    // Always use video-only streams for highest quality (up to 4K)
    final videoOnlyStreams = manifest.videoOnly.toList();
    
    debugPrint('[TrailerBannerPlayer] Available video-only streams: ${videoOnlyStreams.length}');
    for (var stream in videoOnlyStreams) {
      debugPrint('[TrailerBannerPlayer]   Video-only: ${stream.videoQuality.name} ${stream.videoResolution} bitrate: ${stream.bitrate.kiloBitsPerSecond.toStringAsFixed(0)}kbps');
    }
    
    String videoUrl;
    
    if (videoOnlyStreams.isNotEmpty) {
      // Sort by resolution height
      videoOnlyStreams.sort((a, b) => a.videoResolution.height.compareTo(b.videoResolution.height));
      
      final int targetIndex;
      switch (quality) {
        case TrailerQuality.low:
          targetIndex = 0; // Lowest quality (usually 144p)
        case TrailerQuality.medium:
          // Find ~720p or middle quality
          final mediumIndex = videoOnlyStreams.indexWhere((s) => s.videoResolution.height >= 720);
          targetIndex = mediumIndex != -1 ? mediumIndex : (videoOnlyStreams.length / 2).floor().clamp(0, videoOnlyStreams.length - 1);
        case TrailerQuality.high:
          targetIndex = videoOnlyStreams.length - 1; // Highest quality (up to 4K!)
      }
      
      final selected = videoOnlyStreams[targetIndex];
      debugPrint('[TrailerBannerPlayer] Selected [$quality] video: ${selected.videoQuality.name} ${selected.videoResolution}');
      videoUrl = selected.url.toString();
    } else {
      // Fallback to muxed if no video-only available (rare)
      final muxedStreams = manifest.muxed.toList();
      if (muxedStreams.isEmpty) {
        throw Exception('No video streams available');
      }
      muxedStreams.sort((a, b) => a.videoResolution.height.compareTo(b.videoResolution.height));
      final selected = muxedStreams.last;
      debugPrint('[TrailerBannerPlayer] Fallback to muxed: ${selected.videoQuality.name} ${selected.videoResolution}');
      // Muxed already has audio, no need for separate audio track
      return (videoUrl: selected.url.toString(), audioUrl: null);
    }
    
    // Get audio stream if not muted
    String? audioUrl;
    if (!isMuted) {
      final audioStreams = manifest.audioOnly.toList();
      
      debugPrint('[TrailerBannerPlayer] Available audio streams: ${audioStreams.length}');
      for (var stream in audioStreams) {
        debugPrint('[TrailerBannerPlayer]   Audio: ${stream.bitrate.kiloBitsPerSecond.toStringAsFixed(0)}kbps codec: ${stream.audioCodec}');
      }
      
      if (audioStreams.isNotEmpty) {
        // Sort by bitrate, pick highest quality audio
        audioStreams.sort((a, b) => a.bitrate.compareTo(b.bitrate));
        final selectedAudio = audioStreams.last;
        debugPrint('[TrailerBannerPlayer] Selected audio: ${selectedAudio.bitrate.kiloBitsPerSecond.toStringAsFixed(0)}kbps');
        audioUrl = selectedAudio.url.toString();
      }
    }
    
    return (videoUrl: videoUrl, audioUrl: audioUrl);
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
