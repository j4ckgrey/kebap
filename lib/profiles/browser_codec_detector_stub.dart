/// Stub implementation of BrowserCodecDetector for non-web platforms.
/// On native platforms, MPV/libmpv handles all decoding, so we return true for everything.
class BrowserCodecDetector {
  const BrowserCodecDetector();

  // Video codec detection - native platforms can play everything
  bool canPlayH264() => true;
  bool canPlayHevc() => true;
  bool canPlayVp8() => true;
  bool canPlayVp9() => true;
  bool canPlayAv1() => true;
  bool canPlayMpeg2() => true;
  bool canPlayMpeg4() => true;
  bool canPlayVc1() => true;

  // Audio codec detection - native platforms can play everything
  bool canPlayAac() => true;
  bool canPlayMp3() => true;
  bool canPlayOpus() => true;
  bool canPlayFlac() => true;
  bool canPlayVorbis() => true;
  bool canPlayAc3() => true;
  bool canPlayEac3() => true;
  bool canPlayDts() => true;
  bool canPlayTrueHd() => true;
  bool canPlayAlac() => true;
  bool canPlayMp2() => true;
  bool canPlayPcm() => true;

  // Container detection - native platforms can play everything
  bool canPlayMkv() => true;
  bool canPlayWebm() => true;
  bool canPlayMp4() => true;
  bool canPlayMov() => true;
  bool canPlayAvi() => true;
  bool canPlayTs() => true;
  bool canPlayM2ts() => true;
  bool canPlayFlv() => true;
  bool canPlayWmv() => true;
  bool canPlayOgv() => true;

  // HLS detection - native platforms can play everything
  bool canPlayHls() => true;
  bool canPlayHlsInFmp4() => true;
  bool canPlayNativeHls() => true;
  bool canPlayHlsWithMSE() => true;

  // Feature detection
  bool supportsHdr10() => true;
  bool supportsHlg() => true;

  // Browser/Platform info - stub methods for non-web platforms
  String getUserAgent() => 'Native Platform';
  String getPlatform() => 'Native';
  bool supportsDolbyVision() => true;
  int getMaxAudioChannels() => 8;
}
