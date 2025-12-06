// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;

/// Web implementation of BrowserCodecDetector.
/// Uses the browser's canPlayType() API to detect actual codec support.
/// Based on Jellyfin's browserDeviceProfile.js implementation.
class BrowserCodecDetector {
  html.VideoElement? _videoElement;
  html.AudioElement? _audioElement;

  BrowserCodecDetector() {
    _videoElement = html.VideoElement();
    _audioElement = html.AudioElement();
  }

  /// Helper to test video codec support
  bool _canPlayVideoType(String mimeType) {
    final result = _videoElement?.canPlayType(mimeType) ?? '';
    return result.isNotEmpty && result != 'no';
  }

  /// Helper to test audio codec support
  bool _canPlayAudioType(String mimeType) {
    final result = _audioElement?.canPlayType(mimeType) ?? '';
    return result.isNotEmpty && result != 'no';
  }

  // ============ VIDEO CODEC DETECTION ============

  /// H.264/AVC - universally supported
  bool canPlayH264() {
    return _canPlayVideoType('video/mp4; codecs="avc1.42E01E, mp4a.40.2"') ||
        _canPlayVideoType('video/mp4; codecs="avc1.42E01E"');
  }

  /// HEVC/H.265 - Safari, Edge, some Chrome
  bool canPlayHevc() {
    // Test multiple HEVC codec strings as browsers report differently
    return _canPlayVideoType('video/mp4; codecs="hvc1.1.L120"') ||
        _canPlayVideoType('video/mp4; codecs="hev1.1.L120"') ||
        _canPlayVideoType('video/mp4; codecs="hvc1.1.0.L120"') ||
        _canPlayVideoType('video/mp4; codecs="hev1.1.0.L120"');
  }

  /// VP8 - Chrome, Firefox
  bool canPlayVp8() {
    return _canPlayVideoType('video/webm; codecs="vp8"');
  }

  /// VP9 - Chrome, Firefox
  bool canPlayVp9() {
    return _canPlayVideoType('video/webm; codecs="vp9"');
  }

  /// AV1 - Newer browsers (Chrome 70+, Firefox 67+)
  bool canPlayAv1() {
    // Test both 8-bit and 10-bit AV1
    return _canPlayVideoType('video/mp4; codecs="av01.0.15M.08"') ||
        _canPlayVideoType('video/mp4; codecs="av01.0.15M.10"') ||
        _canPlayVideoType('video/webm; codecs="av01.0.15M.08"');
  }

  /// MPEG-2 - Usually not supported in browsers
  bool canPlayMpeg2() {
    return _canPlayVideoType('video/mpeg');
  }

  /// MPEG-4 Part 2 (DivX/Xvid) - Limited support
  bool canPlayMpeg4() {
    return _canPlayVideoType('video/mp4; codecs="mp4v.20.8"');
  }

  /// VC-1 - Edge only
  bool canPlayVc1() {
    return _canPlayVideoType('video/mp4; codecs="vc-1"');
  }

  // ============ AUDIO CODEC DETECTION ============

  /// AAC - universally supported
  bool canPlayAac() {
    return _canPlayVideoType('video/mp4; codecs="avc1.640029, mp4a.40.2"') ||
        _canPlayAudioType('audio/mp4; codecs="mp4a.40.2"') ||
        _canPlayAudioType('audio/aac');
  }

  /// MP3 - universally supported
  bool canPlayMp3() {
    return _canPlayVideoType('video/mp4; codecs="avc1.640029, mp4a.69"') ||
        _canPlayVideoType('video/mp4; codecs="avc1.640029, mp4a.6B"') ||
        _canPlayAudioType('audio/mpeg');
  }

  /// Opus - Chrome, Firefox, Safari 17+
  bool canPlayOpus() {
    return _canPlayAudioType('audio/ogg; codecs="opus"') ||
        _canPlayAudioType('audio/webm; codecs="opus"');
  }

  /// FLAC - Chrome, Firefox, Safari
  bool canPlayFlac() {
    return _canPlayAudioType('audio/flac');
  }

  /// Vorbis - Chrome, Firefox
  bool canPlayVorbis() {
    return _canPlayAudioType('audio/ogg; codecs="vorbis"') ||
        _canPlayAudioType('audio/webm; codecs="vorbis"');
  }

  /// AC-3 (Dolby Digital) - Safari, Edge
  bool canPlayAc3() {
    return _canPlayAudioType('audio/mp4; codecs="ac-3"');
  }

  /// E-AC-3 (Dolby Digital Plus) - Safari, Edge
  bool canPlayEac3() {
    return _canPlayAudioType('audio/mp4; codecs="ec-3"');
  }

  /// DTS - Very limited browser support
  bool canPlayDts() {
    return _canPlayVideoType('video/mp4; codecs="dts-"') ||
        _canPlayVideoType('video/mp4; codecs="dts+"');
  }

  /// TrueHD - Not supported in browsers
  bool canPlayTrueHd() {
    return false;
  }

  /// ALAC - Safari
  bool canPlayAlac() {
    return _canPlayAudioType('audio/m4a; codecs="alac"') ||
        _canPlayAudioType('audio/mp4; codecs="alac"');
  }

  /// MP2 - Limited support
  bool canPlayMp2() {
    return _canPlayAudioType('audio/mpeg');
  }

  /// PCM - Usually not supported directly
  bool canPlayPcm() {
    return _canPlayAudioType('audio/wav');
  }

  // ============ CONTAINER DETECTION ============

  /// MKV - Very limited browser support (Chrome on Windows with extensions)
  bool canPlayMkv() {
    // Most browsers don't support MKV natively
    // Firefox has buggy MKV support that should be avoided
    final userAgent = html.window.navigator.userAgent.toLowerCase();
    if (userAgent.contains('firefox')) {
      return false; // Firefox MKV is buggy per Jellyfin's notes
    }

    return _canPlayVideoType('video/x-matroska') ||
        _canPlayVideoType('video/mkv');
  }

  /// WebM - Chrome, Firefox
  bool canPlayWebm() {
    return _canPlayVideoType('video/webm');
  }

  /// MP4 - universally supported
  bool canPlayMp4() {
    return _canPlayVideoType('video/mp4');
  }

  /// MOV - Safari, Chrome, Edge
  bool canPlayMov() {
    return _canPlayVideoType('video/quicktime');
  }

  /// AVI - Very limited browser support
  bool canPlayAvi() {
    return _canPlayVideoType('video/x-msvideo');
  }

  /// MPEG-TS - Limited browser support
  bool canPlayTs() {
    return _canPlayVideoType('video/mp2t');
  }

  /// M2TS - Limited browser support
  bool canPlayM2ts() {
    return _canPlayVideoType('video/mp2t');
  }

  /// FLV - Not supported in modern browsers
  bool canPlayFlv() {
    return _canPlayVideoType('video/x-flv');
  }

  /// WMV - Edge only
  bool canPlayWmv() {
    return _canPlayVideoType('video/x-ms-wmv');
  }

  /// OGV - Chrome, Firefox
  bool canPlayOgv() {
    return _canPlayVideoType('video/ogg');
  }

  // ============ HLS DETECTION ============

  /// Native HLS support (Safari, some mobile browsers)
  bool canPlayNativeHls() {
    return _canPlayVideoType('application/x-mpegURL') ||
        _canPlayVideoType('application/vnd.apple.mpegURL');
  }

  /// HLS with fMP4 container (Safari 11+, iOS)
  bool canPlayHlsInFmp4() {
    final userAgent = html.window.navigator.userAgent.toLowerCase();
    // Safari on macOS or iOS 11+ supports fMP4 HLS
    if (userAgent.contains('safari') && !userAgent.contains('chrome')) {
      return true;
    }
    return false;
  }

  /// HLS via MediaSource Extensions (most browsers)
  bool canPlayHlsWithMSE() {
    // Check if MediaSource API is available
    return html.window.navigator.userAgent.isNotEmpty &&
        _hasMediaSourceSupport();
  }

  bool _hasMediaSourceSupport() {
    try {
      // Check for MediaSource support using JavaScript interop
      final hasMediaSource = html.window.navigator.userAgent.isNotEmpty;
      return hasMediaSource;
    } catch (e) {
      return false;
    }
  }

  /// Can play HLS in any form
  bool canPlayHls() {
    return canPlayNativeHls() || canPlayHlsWithMSE();
  }

  // ============ HDR/FEATURE DETECTION ============

  /// HDR10 support
  bool supportsHdr10() {
    final userAgent = html.window.navigator.userAgent.toLowerCase();
    // Safari, Chrome (desktop), Edge 121+
    if (userAgent.contains('safari') && !userAgent.contains('chrome')) {
      return true;
    }
    if (userAgent.contains('chrome') && !userAgent.contains('mobile')) {
      return true;
    }
    if (userAgent.contains('edg/')) {
      return true;
    }
    return false;
  }

  /// HLG support
  bool supportsHlg() {
    return supportsHdr10(); // Usually same as HDR10 support
  }

  /// Dolby Vision support
  bool supportsDolbyVision() {
    final userAgent = html.window.navigator.userAgent.toLowerCase();
    // Only Safari on iOS 13+ and macOS
    if (userAgent.contains('safari') && !userAgent.contains('chrome')) {
      return true;
    }
    return false;
  }

  /// Get max audio channels
  int getMaxAudioChannels() {
    // Most browsers support 2 channels by default
    // Some can support surround via AC3/EAC3
    if (canPlayAc3() || canPlayEac3()) {
      return 6;
    }
    return 2;
  }

  /// Get a summary of detected codecs (for debugging)
  Map<String, bool> getCodecSummary() {
    return {
      // Video
      'h264': canPlayH264(),
      'hevc': canPlayHevc(),
      'vp8': canPlayVp8(),
      'vp9': canPlayVp9(),
      'av1': canPlayAv1(),
      // Audio
      'aac': canPlayAac(),
      'mp3': canPlayMp3(),
      'opus': canPlayOpus(),
      'flac': canPlayFlac(),
      'vorbis': canPlayVorbis(),
      'ac3': canPlayAc3(),
      'eac3': canPlayEac3(),
      // Containers
      'mkv': canPlayMkv(),
      'webm': canPlayWebm(),
      'mp4': canPlayMp4(),
      // HLS
      'hls_native': canPlayNativeHls(),
      'hls_mse': canPlayHlsWithMSE(),
    };
  }
}
