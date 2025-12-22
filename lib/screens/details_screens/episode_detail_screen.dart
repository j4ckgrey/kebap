import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import 'package:kebap/models/item_base_model.dart';
import 'package:kebap/providers/items/episode_details_provider.dart';
import 'package:kebap/providers/user_provider.dart';
import 'package:kebap/screens/details_screens/components/media_stream_information.dart';
import 'package:kebap/screens/details_screens/components/overview_header_v3.dart';
import 'package:kebap/screens/shared/detail_scaffold.dart';
import 'package:kebap/screens/shared/kebap_snackbar.dart';
import 'package:kebap/screens/shared/media/chapter_row.dart';
import 'package:kebap/screens/shared/media/components/media_play_button.dart';
import 'package:kebap/screens/shared/media/episode_posters.dart';
import 'package:kebap/screens/shared/media/expanding_overview.dart';
import 'package:kebap/screens/shared/media/external_urls.dart';
import 'package:kebap/screens/shared/media/people_row.dart';
import 'package:kebap/util/adaptive_layout/adaptive_layout.dart';
import 'package:kebap/util/item_base_model/item_base_model_extensions.dart';
import 'package:kebap/util/item_base_model/play_item_helpers.dart';
import 'package:kebap/util/list_padding.dart';
import 'package:kebap/util/localization_helper.dart';
import 'package:kebap/util/people_extension.dart';
import 'package:kebap/util/router_extension.dart';
import 'package:kebap/util/widget_extensions.dart';
import 'package:kebap/widgets/shared/item_actions.dart';
import 'package:kebap/widgets/shared/modal_bottom_sheet.dart';
import 'package:kebap/widgets/shared/selectable_icon_button.dart';

class EpisodeDetailScreen extends ConsumerStatefulWidget {
  final ItemBaseModel item;
  const EpisodeDetailScreen({required this.item, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends ConsumerState<EpisodeDetailScreen> {
  AutoDisposeStateNotifierProvider<EpisodeDetailsProvider, EpisodeDetailModel> get providerInstance =>
      episodeDetailsProvider(widget.item.id);
  final FocusNode _playButtonNode = FocusNode(); // Re-add FocusNode
  final FocusNode _mediaInfoNode = FocusNode();

  Timer? _pollingTimer;
  int _pollCount = 0;
  static const int _maxPolls = 15; // 30 seconds max (2s interval)
  bool _focusLocked = false;  // Set to true once all async ops complete
  Timer? _lockTimer;  // Debounce timer for focus lock

  @override
  void initState() {
    super.initState();
    _playButtonNode.addListener(_onPlayButtonFocusChange);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _checkAndStartPolling();
      }
    });
  }

  void _onPlayButtonFocusChange() {
    // Not used for locking anymore, but kept for potential future use
  }

  void _scheduleFocusLock() {
    _lockTimer?.cancel();
    _lockTimer = Timer(const Duration(seconds: 2), () {
      _focusLocked = true;
      debugPrint('[FocusDebug] Episode focus locked - no rebuilds for 2 seconds');
    });
  }

  void _requestPlayButtonFocus() {
    if (_focusLocked) return;
    
    _scheduleFocusLock();
    
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted && !_focusLocked && _playButtonNode.canRequestFocus) {
        _playButtonNode.requestFocus();
        debugPrint('[FocusDebug] Episode Play button focus requested (delayed)');
      }
    });
  }

  void _checkAndStartPolling() {
    final details = ref.read(providerInstance);
    if (details.episode == null) return;

    bool shouldPoll = false;
    if (details.episode!.mediaStreams.versionStreams.isEmpty) {
      shouldPoll = true;
    } else {
      final first = details.episode!.mediaStreams.versionStreams.firstOrNull;
      final totalStreams = (first?.videoStreams.length ?? 0) +
          (first?.audioStreams.length ?? 0) +
          (first?.subStreams.length ?? 0);
      if (totalStreams == 0) shouldPoll = true;
    }

    if (shouldPoll) {
      _startPolling();
    }
  }

  void _startPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      if (!mounted) {
        timer.cancel();
        return;
      }

      _pollCount++;
      if (_pollCount > _maxPolls) {
        timer.cancel();
        return;
      }

      final details = ref.read(providerInstance);
      if (details.episode == null) return;

      bool hasStreams = false;
      if (details.episode!.mediaStreams.versionStreams.isNotEmpty) {
        final first = details.episode!.mediaStreams.versionStreams.firstOrNull;
        final totalStreams = (first?.videoStreams.length ?? 0) +
            (first?.audioStreams.length ?? 0) +
            (first?.subStreams.length ?? 0);
        if (totalStreams > 0) hasStreams = true;
      }

      if (hasStreams) {
        timer.cancel();
        // Request focus after streams are loaded
        _requestPlayButtonFocus();
        return;
      }

      await ref.read(providerInstance.notifier).refreshStreams();
    });
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    _lockTimer?.cancel();
    _playButtonNode.removeListener(_onPlayButtonFocusChange);
    _playButtonNode.dispose();
    _mediaInfoNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Request focus after EVERY build to overcome late async rebuilds
    if (!_focusLocked) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _requestPlayButtonFocus();
      });
    }
    
    ref.listen(providerInstance, (prev, next) {});
    final details = ref.watch(providerInstance);

    final seasonDetails = details.series;
    final episodeDetails = details.episode;
    // Layout alignment
    final wrapAlignment =
        AdaptiveLayout.viewSizeOf(context) != ViewSize.phone ? WrapAlignment.start : WrapAlignment.center;

    final actors = details.episode?.overview.people ?? [];

    return DetailScaffold(
      label: widget.item.name,
      item: details.episode,
      actions: (context) => details.episode?.generateActions(
        context,
        ref,
        exclude: {
          if (details.series == null) ItemActions.openShow,
          ItemActions.details,
        },
        onDeleteSuccesFully: (item) {
          if (context.mounted) {
            context.router.popBack();
          }
        },
      ),
      onRefresh: () async => await ref.read(providerInstance.notifier).fetchDetails(widget.item),
      backDrops: details.episode?.images ?? details.series?.images,
      content: (padding) {
        if (seasonDetails == null || episodeDetails == null) {
          return const SizedBox.shrink();
        }
        return Padding(
              padding: const EdgeInsets.only(bottom: 64),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  OverviewHeaderV3(
                    name: details.series?.name ?? "",
                    image: seasonDetails.images,
                    centerButtons: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: wrapAlignment,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        if (episodeDetails.playAble)
                          MediaPlayButton(
                            focusNode: _playButtonNode, // Use FocusNode
                            autofocus: true,
                            item: episodeDetails,
                            onPressed: (restart) async {
                              await details.episode!.play(
                                context,
                                ref,
                                startPosition: restart ? Duration.zero : null,
                              );
                              ref.read(providerInstance.notifier).fetchDetails(widget.item);
                            },
                            onLongPressed: (restart) async {
                              await details.episode!.play(
                                context,
                                ref,
                                showPlaybackOption: true,
                                startPosition: restart ? Duration.zero : null,
                              );
                              ref.read(providerInstance.notifier).fetchDetails(widget.item);
                            },
                          ),
                        SelectableIconButton(
                          onPressed: () async {
                            await ref
                                .read(userProvider.notifier)
                                .setAsFavorite(!(episodeDetails.userData.isFavourite), episodeDetails.id);
                          },
                          selected: episodeDetails.userData.isFavourite,
                          selectedIcon: IconsaxPlusBold.heart,
                          icon: IconsaxPlusLinear.heart,
                        ),
                        SelectableIconButton(
                          onPressed: () async {
                            await ref
                                .read(userProvider.notifier)
                                .markAsPlayed(!(episodeDetails.userData.played), episodeDetails.id);
                          },
                          selected: episodeDetails.userData.played,
                          selectedIcon: IconsaxPlusBold.tick_circle,
                          icon: IconsaxPlusLinear.tick_circle,
                        ),
                        Shortcuts(
                          shortcuts: {
                            const SingleActivator(LogicalKeyboardKey.arrowRight): const DoNothingIntent(),
                          },
                          child: SelectableIconButton(
                            onPressed: () async {
                              await showBottomSheetPill(
                                context: context,
                                content: (context, scrollController) => ListView(
                                  controller: scrollController,
                                  shrinkWrap: true,
                                  children:
                                      episodeDetails.generateActions(context, ref).listTileItems(context, useIcons: true),
                                ),
                              );
                            },
                            selected: false,
                            icon: IconsaxPlusLinear.more,
                          ),
                        ),
                      ].nonNulls.toList(),
                    ),
                    padding: padding,
                    subTitle: details.episode?.detailedName(context),
                    originalTitle: details.series?.originalTitle,
                    onTitleClicked: () => details.series?.navigateTo(context),
                    productionYear: details.series?.overview.productionYear,
                    duration: details.episode?.overview.runTime,
                    studios: details.series?.overview.studios ?? [],
                    genres: details.series?.overview.genreItems ?? [],
                    officialRating: details.series?.overview.parentalRating,
                    communityRating: details.series?.overview.communityRating,
                    premiereDate: details.episode?.overview.premiereDate,
                  ),
                  if (details.episode?.mediaStreams != null)
                    Padding(
                      padding: padding,
                      child: MediaStreamInformation(
                        focusNode: _mediaInfoNode,
                        mediaStream: details.episode!.mediaStreams,
                        onVersionIndexChanged: (index) {
                          ref.read(providerInstance.notifier).setVersionIndex(index);
                        },
                        onSubIndexChanged: (index) {
                          ref.read(providerInstance.notifier).setSubIndex(index);
                        },
                        onAudioIndexChanged: (index) {
                          ref.read(providerInstance.notifier).setAudioIndex(index);
                        },
                      ),
                    ),
                  if (episodeDetails.overview.summary.isNotEmpty == true)
                    ExpandingOverview(
                      text: episodeDetails.overview.summary,
                    ).padding(padding),
                  if (episodeDetails.chapters.isNotEmpty)
                    ChapterRow(
                      chapters: episodeDetails.chapters,
                      contentPadding: padding,
                      onPressed: (chapter) async {
                        await details.episode?.play(context, ref, startPosition: chapter.startPosition);
                        ref.read(providerInstance.notifier).fetchDetails(widget.item);
                      },
                    ),
                  if (actors.mainCast.isNotEmpty == true)
                    PeopleRow(
                      people: actors.mainCast,
                      contentPadding: padding,
                    ),
                  if (actors.guestActors.isNotEmpty == true)
                    PeopleRow(
                      people: actors.guestActors,
                      contentPadding: padding,
                    ),
                  if (details.episodes.length > 1)
                    EpisodePosters(
                      contentPadding: padding,
                      label: context.localized
                          .moreFrom("${context.localized.season(1).toLowerCase()} ${episodeDetails.season}"),
                      onEpisodeTap: (action, episodeModel) {
                        if (episodeModel.id == episodeDetails.id) {
                          kebapSnackbar(context, title: context.localized.selectedWith(context.localized.episode(0)));
                        } else {
                          action();
                        }
                      },
                      playEpisode: (episode) => episode.play(
                        context,
                        ref,
                      ),
                      episodes: details.episodes.where((element) => element.season == episodeDetails.season).toList(),
                    ),
                  if (details.series?.overview.externalUrls?.isNotEmpty == true)
                    Padding(
                      padding: padding,
                      child: ExternalUrlsRow(
                        urls: details.series?.overview.externalUrls,
                      ),
                    )
                ].addPadding(const EdgeInsets.symmetric(vertical: 16)),
              ),
            );
          },
    );
  }
}
