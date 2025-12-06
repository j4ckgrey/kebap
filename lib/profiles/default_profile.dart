import 'package:flutter/foundation.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kebap/jellyfin/jellyfin_open_api.swagger.dart';
import 'package:kebap/models/settings/video_player_settings.dart';
import 'package:kebap/profiles/dynamic_web_profile.dart';
import 'package:kebap/providers/video_player_provider.dart';

final videoProfileProvider = StateProvider.autoDispose<DeviceProfile>((ref) =>
    defaultProfile(ref.read(videoPlayerProvider.select((value) => value.backend)) ?? PlayerOptions.platformDefaults));

DeviceProfile defaultProfile(PlayerOptions player) => kIsWeb
    ? buildDynamicWebProfile()
    : const DeviceProfile(
        maxStreamingBitrate: 120000000,
        maxStaticBitrate: 120000000,
        musicStreamingTranscodingBitrate: 384000,
        directPlayProfiles: [
          DirectPlayProfile(
            type: DlnaProfileType.video,
            container: 'mkv,mp4,m4v,avi,mov,wmv,asf,wma,mp3,flac,ogg,ogv,webm',
            videoCodec: 'h264,hevc,vp8,vp9,av1,mpeg4,mpeg2video',
            audioCodec: 'aac,mp3,ac3,eac3,flac,vorbis,opus,dts,dca,truehd',
          ),
          DirectPlayProfile(
            type: DlnaProfileType.audio,
            container: 'mp3,flac,ogg,opus,wav,m4a,aac,alac',
            audioCodec: 'aac,mp3,flac,vorbis,opus,pcm,alac',
          )
        ],
        transcodingProfiles: [
          TranscodingProfile(
            audioCodec: 'aac,mp3,mp2',
            container: 'ts',
            maxAudioChannels: '2',
            protocol: MediaStreamProtocol.hls,
            type: DlnaProfileType.video,
            videoCodec: 'h264',
          ),
        ],
        containerProfiles: [],
        subtitleProfiles: [
          SubtitleProfile(format: 'vtt', method: SubtitleDeliveryMethod.$external),
          SubtitleProfile(format: 'ass', method: SubtitleDeliveryMethod.$external),
          SubtitleProfile(format: 'ssa', method: SubtitleDeliveryMethod.$external),
          SubtitleProfile(format: 'pgssub', method: SubtitleDeliveryMethod.$external),
        ],
      );
