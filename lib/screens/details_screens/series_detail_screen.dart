import 'dart:async';
import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import 'package:kebap/models/item_base_model.dart';
import 'package:kebap/models/items/series_model.dart';
import 'package:kebap/providers/items/series_details_provider.dart';
import 'package:kebap/providers/user_provider.dart';
import 'package:kebap/screens/details_screens/components/overview_header_v3.dart';
import 'package:kebap/screens/shared/detail_scaffold.dart';
import 'package:kebap/screens/shared/media/components/media_play_button.dart';
import 'package:kebap/screens/shared/media/components/next_up_episode.dart';
import 'package:kebap/screens/shared/media/episode_posters.dart';
import 'package:kebap/screens/shared/media/expanding_overview.dart';
import 'package:kebap/screens/shared/media/external_urls.dart';
import 'package:kebap/screens/shared/media/people_row.dart';
import 'package:kebap/screens/shared/media/poster_row.dart';
import 'package:kebap/screens/shared/media/season_row.dart';
import 'package:kebap/util/adaptive_layout/adaptive_layout.dart';
import 'package:kebap/util/item_base_model/item_base_model_extensions.dart';
import 'package:kebap/util/item_base_model/play_item_helpers.dart';
import 'package:kebap/util/list_padding.dart';
import 'package:kebap/util/localization_helper.dart';
import 'package:kebap/util/router_extension.dart';
import 'package:kebap/util/widget_extensions.dart';
import 'package:kebap/widgets/shared/item_actions.dart';
import 'package:kebap/widgets/shared/item_details_reviews_carousel.dart';
import 'package:kebap/widgets/shared/modal_bottom_sheet.dart';
import 'package:kebap/widgets/shared/selectable_icon_button.dart';

class SeriesDetailScreen extends ConsumerStatefulWidget {
  final ItemBaseModel item;
  const SeriesDetailScreen({required this.item, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SeriesDetailScreenState();
}

class _SeriesDetailScreenState extends ConsumerState<SeriesDetailScreen> {
  AutoDisposeStateNotifierProvider<SeriesDetailViewNotifier, SeriesModel?> get providerId =>
      seriesDetailsProvider(widget.item.id);
  final FocusNode _playButtonNode = FocusNode(debugLabel: '[FocusDebug] PlayButton');
  final FocusNode _nextUpPosterNode = FocusNode(debugLabel: '[FocusDebug] NextUpPoster');
  final FocusNode _mediaInfoNode = FocusNode(debugLabel: '[FocusDebug] VersionDropdown'); // Version dropdown
  final FocusNode _audioFocusNode = FocusNode(debugLabel: '[FocusDebug] AudioDropdown'); // Audio dropdown
  final FocusNode _subFocusNode = FocusNode(debugLabel: '[FocusDebug] SubDropdown'); // Subtitle dropdown
  
  final FocusNode _favoriteNode = FocusNode(debugLabel: '[FocusDebug] FavoriteButton');
  final FocusNode _playedNode = FocusNode(debugLabel: '[FocusDebug] PlayedButton');
  final FocusNode _moreNode = FocusNode(debugLabel: '[FocusDebug] MoreButton');
  
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
  
  // didPopNext removed as it's not AutoRouteAware? Wait, EpisodeDetailScreen uses it but SeriesDetailScreen doesn't seem to implement AutoRouteAware in the file view.
  // Actually, checking original code, EpisodeDetailScreen extends ConsumerStatefulWidget, but doesn't implement AutoRouteAware mixin explicitly in the class def shown?
  // Ah, the view_file for EpisodeDetailScreen didn't show the `with AutoRouteAware` mixin, maybe it's not there or I missed it.
  // SeriesDetailScreen code shown also doesn't show mixin.
  // I will just stick to the focus logic updates for now.

  @override
  void dispose() {
    _lockTimer?.cancel();
    _playButtonNode.dispose();
    _nextUpPosterNode.dispose();
    _mediaInfoNode.dispose();
    _audioFocusNode.dispose();
    _subFocusNode.dispose();
    _favoriteNode.dispose();
    _playedNode.dispose();
    _moreNode.dispose();
    super.dispose();
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
      if (_playButtonNode.hasFocus || _mediaInfoNode.hasFocus || _audioFocusNode.hasFocus || _subFocusNode.hasFocus || _nextUpPosterNode.hasFocus) {
         debugPrint('[FocusDebug] A widget already has focus. Respecting it.');
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
  Widget build(BuildContext context) {
    final details = ref.watch(providerId);

    bool isPageLoading = details == null;
    bool isStreamsLoading = true;
    if (details != null) {
      if (details.nextUp != null) {
        isStreamsLoading = details.nextUp!.mediaStreams.isLoading;
      } else {
        isStreamsLoading = false;
      }
    }

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
                // Re-lock briefly to prevent play button from stealing it back immediately
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

    final wrapAlignment =
        AdaptiveLayout.viewSizeOf(context) != ViewSize.phone ? WrapAlignment.start : WrapAlignment.center;

    return DetailScaffold(
      label: details?.name ?? "",
      item: details,
      actions: (context) => details?.generateActions(
        context,
        ref,
        exclude: {
          ItemActions.play,
          ItemActions.playFromStart,
          ItemActions.details,
        },
        onDeleteSuccesFully: (item) {
          if (context.mounted) {
            context.router.popBack();
          }
        },
      ),
      onRefresh: () => ref.read(providerId.notifier).fetchDetails(widget.item),
      backDrops: details?.images,
      content: (padding) => details != null
          ? Padding(
              padding: const EdgeInsets.only(bottom: 64),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  OverviewHeaderV3(
                    name: details.name,
                    image: details.images,
                    centerButtons: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: wrapAlignment,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        if (details.nextUp != null)
                          MediaPlayButton(
                            focusNode: _playButtonNode,
                            autofocus: true,
                            item: details.nextUp,
                            onPressed: (restart) async {
                              await details.nextUp.play(
                                context,
                                ref,
                                startPosition: restart ? Duration.zero : null,
                              );
                            },
                            onLongPressed: (restart) async {
                              await details.nextUp.play(
                                context,
                                ref,
                                showPlaybackOption: true,
                                startPosition: restart ? Duration.zero : null,
                              );
                            },
                          ),
                        SelectableIconButton(
                          focusNode: _favoriteNode,
                          onPressed: () async {
                            await ref
                                .read(userProvider.notifier)
                                .setAsFavorite(!details.userData.isFavourite, details.id);
                          },
                          selected: details.userData.isFavourite,
                          selectedIcon: IconsaxPlusBold.heart,
                          icon: IconsaxPlusLinear.heart,
                        ),
                        SelectableIconButton(
                          focusNode: _playedNode,
                          onPressed: () async {
                            await ref.read(userProvider.notifier).markAsPlayed(!details.userData.played, details.id);
                          },
                          selected: details.userData.played,
                          selectedIcon: IconsaxPlusBold.tick_circle,
                          icon: IconsaxPlusLinear.tick_circle,
                        ),
                        SelectableIconButton(
                          focusNode: _moreNode,
                          onPressed: () async {
                            await showBottomSheetPill(
                              context: context,
                              content: (context, scrollController) => ListView(
                                controller: scrollController,
                                shrinkWrap: true,
                                children: details.generateActions(context, ref).listTileItems(context, useIcons: true),
                              ),
                            );
                          },
                          selected: false,
                          icon: IconsaxPlusLinear.more,
                        ),
                      ],
                    ),
                    padding: padding,
                    originalTitle: details.originalTitle,
                    productionYear: details.overview.productionYear,
                    duration: details.overview.runTime,
                    studios: details.overview.studios,
                    officialRating: details.overview.parentalRating,
                    genres: details.overview.genreItems,
                    communityRating: details.overview.communityRating,
                    premiereDate: details.overview.premiereDate,
                  ),
                  if (details.nextUp != null)
                    NextUpEpisode(
                      nextEpisode: details.nextUp!,
                      posterFocusNode: _nextUpPosterNode,
                      mediaInfoNode: _mediaInfoNode,
                      audioFocusNode: _audioFocusNode,
                      subFocusNode: _subFocusNode,
                      onChanged: (episode) => ref.read(providerId.notifier).updateEpisodeInfo(episode),
                    ).padding(padding),
                  if (details.overview.summary.isNotEmpty)
                    ExpandingOverview(
                      text: details.overview.summary,
                    ).padding(padding),
                  ItemDetailsReviewsCarousel(
                    item: details,
                    contentPadding: padding,
                  ),
                  if (details.availableEpisodes?.isNotEmpty ?? false)
                    EpisodePosters(
                      contentPadding: padding,
                      label: context.localized.episode(details.availableEpisodes?.length ?? 2),
                      playEpisode: (episode) async {
                        await episode.play(
                          context,
                          ref,
                        );
                        ref.read(providerId.notifier).fetchDetails(widget.item);
                      },
                      episodes: details.availableEpisodes ?? [],
                    ),
                  if (details.seasons?.isNotEmpty ?? false)
                    SeasonsRow(
                      contentPadding: padding,
                      seasons: details.seasons,
                    ),
                  if (details.overview.people.isNotEmpty)
                    PeopleRow(
                      people: details.overview.people,
                      contentPadding: padding,
                    ),

                  if (details.related.isNotEmpty)
                    PosterRow(posters: details.related, contentPadding: padding, label: context.localized.related),
                  if (details.overview.externalUrls?.isNotEmpty == true)
                    Padding(
                      padding: padding,
                      child: ExternalUrlsRow(
                        urls: details.overview.externalUrls,
                      ),
                    )
                ].addPadding(const EdgeInsets.symmetric(vertical: 16)),
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
