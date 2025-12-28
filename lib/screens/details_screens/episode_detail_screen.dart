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
  final FocusNode _playButtonNode = FocusNode();
  final FocusNode _mediaInfoNode = FocusNode(); // Version dropdown
  final FocusNode _audioFocusNode = FocusNode(); // Audio dropdown
  final FocusNode _subFocusNode = FocusNode(); // Subtitle dropdown

  bool _focusLocked = false; 
  Timer? _lockTimer;
  bool _wasStreamsLoading = true;
  FocusNode? _lastFocusedNode;

  @override
  void initState() {
    super.initState();
    // Track focus changes
    void listener() {
      if (_playButtonNode.hasFocus) _lastFocusedNode = _playButtonNode;
      if (_mediaInfoNode.hasFocus) _lastFocusedNode = _mediaInfoNode;
      if (_audioFocusNode.hasFocus) _lastFocusedNode = _audioFocusNode;
      if (_subFocusNode.hasFocus) _lastFocusedNode = _subFocusNode;
    }
    _playButtonNode.addListener(listener);
    _mediaInfoNode.addListener(listener);
    _audioFocusNode.addListener(listener);
    _subFocusNode.addListener(listener);
  }

  // ... didPopNext ...
  
  // AutoRouteAware callback - called when returning to this screen from another route (e.g. video player)
  @override
  void didPopNext() {
    debugPrint('[EpisodeDetailScreen] didPopNext - refreshing details for resume button');
    // Refresh the item details so that playback progress/resume button updates
    ref.read(providerInstance.notifier).fetchDetails(widget.item);
    // Reset focus lock when returning
    _focusLocked = false;
    final details = ref.read(providerInstance);
    // If details are null, it's loading. If not, check the mediaStreams loading state.
    final isLoading = details?.episode?.mediaStreams.isLoading ?? true;
    _requestPlayButtonFocus(isLoading);
  }

  void _scheduleFocusLock(bool isPageLoading) {
    _lockTimer?.cancel();
    if (isPageLoading) return;
    _lockTimer = Timer(const Duration(seconds: 2), () {
      _focusLocked = true;
      debugPrint('[FocusDebug] Focus locked - no rebuilds for 2 seconds');
    });
  }

  void _requestPlayButtonFocus(bool isPageLoading) {
    if (isPageLoading) {
      _scheduleFocusLock(true);
      return;
    }

    void attemptFocus() {
      if (!mounted) {
        debugPrint('[FocusDebug] attemptFocus aborted: not mounted');
        return;
      }
      
      // If ANY of our interactive nodes has focus, respect it!
      if (_playButtonNode.hasFocus || _mediaInfoNode.hasFocus || _audioFocusNode.hasFocus || _subFocusNode.hasFocus) {
         debugPrint('[FocusDebug] A widget already has focus (Play: ${_playButtonNode.hasFocus}, Info: ${_mediaInfoNode.hasFocus}). Respecting it.');
         // Do NOT lock here. Let the timer lock it.
         return;
      }

      if (_focusLocked) {
         debugPrint('[FocusDebug] attemptFocus aborted: Focus is locked.');
         return;
      }
      
      if (_playButtonNode.canRequestFocus) {
        _playButtonNode.requestFocus();
        debugPrint('[FocusDebug] Play button focus requested successfully.');
      } else {
         debugPrint('[FocusDebug] Play button CANNOT request focus yet (not attached or visible).');
      }
    }

    attemptFocus(); 
    Future.delayed(const Duration(milliseconds: 100), attemptFocus);
    Future.delayed(const Duration(milliseconds: 300), attemptFocus);
    Future.delayed(const Duration(milliseconds: 600), attemptFocus);

    _scheduleFocusLock(false);
  }

  @override
  void dispose() {
    _lockTimer?.cancel();
    _playButtonNode.dispose();
    _mediaInfoNode.dispose();
    _audioFocusNode.dispose();
    _subFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final details = ref.watch(providerInstance);
    
    // Page Loading = details missing.
    // Streams Loading = streams still fetching.
    final bool isPageLoading = details.episode == null;
    final bool isStreamsLoading = details.episode?.mediaStreams.isLoading ?? true;

    // Detect Transition: Streams Loading -> Loaded
    if (_wasStreamsLoading && !isStreamsLoading) {
      debugPrint('[FocusDebug] Streams finished loading (Transition).');
      
      // Schedule restoration for after this frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // RESTORE FOCUS if it was on a dropdown
        if (_lastFocusedNode == _mediaInfoNode || _lastFocusedNode == _audioFocusNode || _lastFocusedNode == _subFocusNode) {
            if (_lastFocusedNode?.canRequestFocus == true) {
                debugPrint('[FocusDebug] Restoring focus to last known dropdown node (PostFrame).');
                _lastFocusedNode?.requestFocus();
                // Re-lock briefly
                _focusLocked = true;
                Future.delayed(const Duration(milliseconds: 500), () {
                   if (mounted) _focusLocked = false;
                });
                return;
            }
        }
        // If we didn't restore, just unlock
        _focusLocked = false;
      });
    }
    _wasStreamsLoading = isStreamsLoading;

    if (!_focusLocked) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _requestPlayButtonFocus(isPageLoading);
      });
    }

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
                            // autofocus removed
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
                  Padding(
                    padding: padding,
                    child: MediaStreamInformation(
                      focusNode: _mediaInfoNode,
                      audioFocusNode: _audioFocusNode,
                      subFocusNode: _subFocusNode,
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
