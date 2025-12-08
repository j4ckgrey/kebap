import 'package:flutter/foundation.dart';

import 'package:kebap/jellyfin/jellyfin_open_api.swagger.dart';

// Conditional import for browser codec detection
import 'browser_codec_detector_stub.dart'
    if (dart.library.html) 'browser_codec_detector_web.dart';

/// Builds a DeviceProfile dynamically based on actual browser capabilities.
/// Uses canPlayType() to detect what codecs the browser can actually play.
DeviceProfile buildDynamicWebProfile() {
  final detector = BrowserCodecDetector();

  // Log detected codecs for debugging - these will show in browser console
  debugPrint('=== KEBAP: Building dynamic web profile ===');
  debugPrint('KEBAP Video Codecs - H.264: ${detector.canPlayH264()}, HEVC: ${detector.canPlayHevc()}, VP8: ${detector.canPlayVp8()}, VP9: ${detector.canPlayVp9()}, AV1: ${detector.canPlayAv1()}');
  debugPrint('KEBAP Audio Codecs - AAC: ${detector.canPlayAac()}, MP3: ${detector.canPlayMp3()}, Opus: ${detector.canPlayOpus()}, AC3: ${detector.canPlayAc3()}');
  debugPrint('KEBAP Containers - MP4: ${detector.canPlayMp4()}, WebM: ${detector.canPlayWebm()}, MKV: ${detector.canPlayMkv()}');
  debugPrint('KEBAP HLS Support - Native: ${detector.canPlayNativeHls()}, MSE: ${detector.canPlayHlsWithMSE()}');

  final directPlayProfiles = <DirectPlayProfile>[];
  final transcodingProfiles = <TranscodingProfile>[];
  final codecProfiles = <CodecProfile>[];
  final subtitleProfiles = <SubtitleProfile>[];

  // Build video codec lists based on detection
  final List<String> mp4VideoCodecs = [];
  final List<String> webmVideoCodecs = [];
  final List<String> mp4AudioCodecs = [];
  final List<String> webmAudioCodecs = [];

  // ============ VIDEO CODECS ============

  if (detector.canPlayH264()) {
    mp4VideoCodecs.add('h264');
  }

  if (detector.canPlayHevc()) {
    mp4VideoCodecs.add('hevc');
  }

  if (detector.canPlayVp8()) {
    webmVideoCodecs.add('vp8');
  }

  if (detector.canPlayVp9()) {
    webmVideoCodecs.add('vp9');
    // VP9 in MP4 is also possible in some browsers
    mp4VideoCodecs.add('vp9');
  }

  if (detector.canPlayAv1()) {
    mp4VideoCodecs.add('av1');
    webmVideoCodecs.add('av1');
  }

  // ============ AUDIO CODECS ============

  if (detector.canPlayAac()) {
    mp4AudioCodecs.add('aac');
  }

  if (detector.canPlayMp3()) {
    mp4AudioCodecs.add('mp3');
  }

  if (detector.canPlayOpus()) {
    mp4AudioCodecs.add('opus');
    webmAudioCodecs.add('opus');
  }

  if (detector.canPlayVorbis()) {
    webmAudioCodecs.add('vorbis');
  }

  if (detector.canPlayFlac()) {
    mp4AudioCodecs.add('flac');
  }

  if (detector.canPlayAc3()) {
    mp4AudioCodecs.add('ac3');
  }

  if (detector.canPlayEac3()) {
    mp4AudioCodecs.add('eac3');
  }

  // ============ DIRECT PLAY PROFILES ============

  // MP4 container (most common for web)
  if (mp4VideoCodecs.isNotEmpty && detector.canPlayMp4()) {
    directPlayProfiles.add(DirectPlayProfile(
      container: 'mp4,m4v',
      type: DlnaProfileType.video,
      videoCodec: mp4VideoCodecs.join(','),
      audioCodec: mp4AudioCodecs.join(','),
    ));
  }

  // WebM container
  if (webmVideoCodecs.isNotEmpty && detector.canPlayWebm()) {
    directPlayProfiles.add(DirectPlayProfile(
      container: 'webm',
      type: DlnaProfileType.video,
      videoCodec: webmVideoCodecs.join(','),
      audioCodec: webmAudioCodecs.join(','),
    ));
  }

  // MKV container - only if browser truly supports it
  if (detector.canPlayMkv() && mp4VideoCodecs.isNotEmpty) {
    directPlayProfiles.add(DirectPlayProfile(
      container: 'mkv',
      type: DlnaProfileType.video,
      videoCodec: mp4VideoCodecs.join(','),
      audioCodec: mp4AudioCodecs.join(','),
    ));
  }

  // MOV container
  if (detector.canPlayMov() && detector.canPlayH264()) {
    directPlayProfiles.add(DirectPlayProfile(
      container: 'mov',
      type: DlnaProfileType.video,
      videoCodec: 'h264',
      audioCodec: mp4AudioCodecs.join(','),
    ));
  }

  // ============ AUDIO DIRECT PLAY PROFILES ============

  if (detector.canPlayOpus()) {
    directPlayProfiles.add(const DirectPlayProfile(
      container: 'opus',
      type: DlnaProfileType.audio,
    ));
    directPlayProfiles.add(const DirectPlayProfile(
      container: 'webm',
      audioCodec: 'opus',
      type: DlnaProfileType.audio,
    ));
  }

  if (detector.canPlayMp3()) {
    directPlayProfiles.add(const DirectPlayProfile(
      container: 'mp3',
      type: DlnaProfileType.audio,
    ));
  }

  if (detector.canPlayAac()) {
    directPlayProfiles.add(const DirectPlayProfile(
      container: 'aac',
      type: DlnaProfileType.audio,
    ));
    directPlayProfiles.add(const DirectPlayProfile(
      container: 'm4a',
      audioCodec: 'aac',
      type: DlnaProfileType.audio,
    ));
  }

  if (detector.canPlayFlac()) {
    directPlayProfiles.add(const DirectPlayProfile(
      container: 'flac',
      type: DlnaProfileType.audio,
    ));
  }

  if (detector.canPlayVorbis()) {
    directPlayProfiles.add(const DirectPlayProfile(
      container: 'ogg',
      type: DlnaProfileType.audio,
    ));
  }

  directPlayProfiles.add(const DirectPlayProfile(
    container: 'wav',
    type: DlnaProfileType.audio,
  ));

  // ============ HLS DIRECT PLAY ============

  if (detector.canPlayHls()) {
    // HLS with H.264 is most compatible
    final hlsAudioCodecs = <String>['aac'];

    if (detector.canPlayMp3()) {
      hlsAudioCodecs.add('mp3');
    }
    if (detector.canPlayMp2()) {
      hlsAudioCodecs.add('mp2');
    }

    directPlayProfiles.add(DirectPlayProfile(
      container: 'hls',
      type: DlnaProfileType.video,
      videoCodec: 'h264',
      audioCodec: hlsAudioCodecs.join(','),
    ));
  }

  // ============ TRANSCODING PROFILES ============

  // HLS transcoding - always use as fallback
  // Determine best audio codec for transcoding
  final transcodingAudioCodec = detector.canPlayAac() ? 'aac' : 'mp3';

  // HLS in TS container (most compatible)
  transcodingProfiles.add(TranscodingProfile(
    container: 'ts',
    type: DlnaProfileType.video,
    videoCodec: 'h264',
    audioCodec: transcodingAudioCodec,
    context: EncodingContext.streaming,
    protocol: MediaStreamProtocol.hls,
    maxAudioChannels: detector.getMaxAudioChannels().toString(),
    minSegments: 1,
    breakOnNonKeyFrames: true,
  ));

  // HLS in fMP4 (Safari, iOS)
  if (detector.canPlayHlsInFmp4()) {
    transcodingProfiles.add(TranscodingProfile(
      container: 'mp4',
      type: DlnaProfileType.video,
      videoCodec: 'h264',
      audioCodec: transcodingAudioCodec,
      context: EncodingContext.streaming,
      protocol: MediaStreamProtocol.hls,
      maxAudioChannels: detector.getMaxAudioChannels().toString(),
      minSegments: 1,
      breakOnNonKeyFrames: true,
    ));
  }

  // Audio transcoding
  transcodingProfiles.add(TranscodingProfile(
    container: 'ts',
    type: DlnaProfileType.audio,
    audioCodec: transcodingAudioCodec,
    context: EncodingContext.streaming,
    protocol: MediaStreamProtocol.hls,
    maxAudioChannels: '2',
    minSegments: 1,
    breakOnNonKeyFrames: true,
  ));

  // ============ CODEC PROFILES ============

  // H.264 profile constraints
  codecProfiles.add(const CodecProfile(
    type: CodecType.video,
    codec: 'h264',
    conditions: [
      ProfileCondition(
        condition: ProfileConditionType.notequals,
        property: ProfileConditionValue.isanamorphic,
        $Value: 'true',
        isRequired: false,
      ),
      ProfileCondition(
        condition: ProfileConditionType.equalsany,
        property: ProfileConditionValue.videoprofile,
        $Value: 'high|main|baseline|constrained baseline|high 10',
        isRequired: false,
      ),
      ProfileCondition(
        condition: ProfileConditionType.lessthanequal,
        property: ProfileConditionValue.videolevel,
        $Value: '52',
        isRequired: false,
      ),
    ],
  ));

  // HEVC profile constraints (if supported)
  if (detector.canPlayHevc()) {
    codecProfiles.add(const CodecProfile(
      type: CodecType.video,
      codec: 'hevc',
      conditions: [
        ProfileCondition(
          condition: ProfileConditionType.notequals,
          property: ProfileConditionValue.isanamorphic,
          $Value: 'true',
          isRequired: false,
        ),
        ProfileCondition(
          condition: ProfileConditionType.equalsany,
          property: ProfileConditionValue.videoprofile,
          $Value: 'main|main 10',
          isRequired: false,
        ),
        ProfileCondition(
          condition: ProfileConditionType.lessthanequal,
          property: ProfileConditionValue.videolevel,
          $Value: '183',
          isRequired: false,
        ),
      ],
    ));
  }

  // ============ SUBTITLE PROFILES ============

  // VTT is universally supported in browsers
  subtitleProfiles.add(const SubtitleProfile(
    format: 'vtt',
    method: SubtitleDeliveryMethod.$external,
  ));

  // SSA/ASS need to be converted to VTT
  subtitleProfiles.add(const SubtitleProfile(
    format: 'ass',
    method: SubtitleDeliveryMethod.$external,
  ));
  subtitleProfiles.add(const SubtitleProfile(
    format: 'ssa',
    method: SubtitleDeliveryMethod.$external,
  ));
  subtitleProfiles.add(const SubtitleProfile(
    format: 'srt',
    method: SubtitleDeliveryMethod.$external,
  ));


  debugPrint('KEBAP: Built dynamic web profile with ${directPlayProfiles.length} direct play profiles');

  return DeviceProfile(
    maxStreamingBitrate: 120000000,
    maxStaticBitrate: 100000000,
    musicStreamingTranscodingBitrate: 384000,
    directPlayProfiles: directPlayProfiles,
    transcodingProfiles: transcodingProfiles,
    codecProfiles: codecProfiles,
    containerProfiles: const [],
    subtitleProfiles: subtitleProfiles,
  );
}
