import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import 'package:kebap/models/items/episode_model.dart';
import 'package:kebap/screens/details_screens/components/media_stream_information.dart';
import 'package:kebap/screens/shared/media/episode_posters.dart';
import 'package:kebap/util/adaptive_layout/adaptive_layout.dart';
import 'package:kebap/util/localization_helper.dart';
import 'package:kebap/util/sticky_header_text.dart';
import 'package:kebap/util/string_extensions.dart';
import 'package:kebap/widgets/shared/ensure_visible.dart';

class NextUpEpisode extends ConsumerWidget {
  final EpisodeModel nextEpisode;
  final Function(EpisodeModel episode)? onChanged;
  final FocusNode? mediaInfoNode;
  final FocusNode? audioFocusNode;
  final FocusNode? subFocusNode;
  final FocusNode? posterFocusNode;

  const NextUpEpisode({
    required this.nextEpisode,
    this.onChanged,
    this.mediaInfoNode,
    this.audioFocusNode,
    this.subFocusNode,
    this.posterFocusNode,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alreadyPlayed = nextEpisode.userData.played;
    final episodeSummary = nextEpisode.overview.summary.maxLength(limitTo: 250);
    final style = Theme.of(context).textTheme.titleMedium;
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StickyHeaderText(
          label: alreadyPlayed ? context.localized.reWatch : context.localized.nextUp,
        ),
        Text(
          nextEpisode.seasonEpisodeLabelFull(context),
          style: style?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.75),
          ),
        ),
        Text(
          nextEpisode.name,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 550) {
              return Column(
                children: [
                  EpisodePoster(
                    episode: nextEpisode,
                    focusNode: posterFocusNode,
                    showLabel: false,
                    onTap: () => nextEpisode.navigateTo(context),
                    actions: const [],
                    onFocusChanged: (value) {
                      if (value) {
                        context.ensureVisible();
                      }
                    },
                    isCurrentEpisode: false,
                  ),
                  const SizedBox(height: 16),
                  MediaStreamInformation(
                    focusNode: mediaInfoNode,
                    audioFocusNode: audioFocusNode,
                    subFocusNode: subFocusNode,
                    mediaStream: nextEpisode.mediaStreams,
                    onVersionIndexChanged: (index) => onChanged?.call(nextEpisode.copyWith(
                      mediaStreams: nextEpisode.mediaStreams.copyWith(versionStreamIndex: index),
                    )),
                    onAudioIndexChanged: (index) => onChanged?.call(nextEpisode.copyWith(
                        mediaStreams: nextEpisode.mediaStreams.copyWith(defaultAudioStreamIndex: index))),
                    onSubIndexChanged: (index) => onChanged?.call(nextEpisode.copyWith(
                        mediaStreams: nextEpisode.mediaStreams.copyWith(defaultSubStreamIndex: index))),
                  ),
                  const SizedBox(height: 16),
                  if (nextEpisode.overview.summary.isNotEmpty)
                    HtmlWidget(
                      episodeSummary,
                      textStyle: Theme.of(context).textTheme.titleMedium,
                    ),
                ],
              );
            } else {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   ConstrainedBox(
                    constraints: BoxConstraints(
                        maxHeight: AdaptiveLayout.poster(context).gridRatio,
                        maxWidth: MediaQuery.of(context).size.width / 2),
                    child: CallbackShortcuts(
                      bindings: {
                        SingleActivator(LogicalKeyboardKey.arrowRight): () {
                          debugPrint('[FocusDebug] Shortcut: ArrowRight pressed on Poster. Requesting dropdown focus.');
                          mediaInfoNode?.requestFocus();
                        },
                      },
                      child: EpisodePoster(
                        episode: nextEpisode,
                        focusNode: posterFocusNode,
                        showLabel: false,
                        onTap: () => nextEpisode.navigateTo(context),
                        actions: const [],
                        onFocusChanged: (value) {
                          if (value) {
                            context.ensureVisible();
                          }
                        },
                        isCurrentEpisode: false,
                      ),
                    ),
                  ),
                  const SizedBox(width: 32),
                  Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MediaStreamInformation(
                          focusNode: mediaInfoNode,
                          audioFocusNode: audioFocusNode,
                          subFocusNode: subFocusNode,
                          mediaStream: nextEpisode.mediaStreams,
                          onVersionIndexChanged: (index) => onChanged?.call(nextEpisode.copyWith(
                            mediaStreams: nextEpisode.mediaStreams.copyWith(versionStreamIndex: index),
                          )),
                          onAudioIndexChanged: (index) => onChanged?.call(nextEpisode.copyWith(
                              mediaStreams: nextEpisode.mediaStreams.copyWith(defaultAudioStreamIndex: index))),
                          onSubIndexChanged: (index) => onChanged?.call(nextEpisode.copyWith(
                              mediaStreams: nextEpisode.mediaStreams.copyWith(defaultSubStreamIndex: index))),
                        ),
                        if (nextEpisode.overview.summary.isNotEmpty)
                          HtmlWidget(episodeSummary, textStyle: Theme.of(context).textTheme.titleMedium),
                      ],
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ],
    );
  }
}
