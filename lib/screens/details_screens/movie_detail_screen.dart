import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import 'package:kebap/models/item_base_model.dart';
import 'package:kebap/models/items/movie_model.dart';
import 'package:kebap/providers/items/movies_details_provider.dart';
import 'package:kebap/providers/user_provider.dart';
import 'package:kebap/screens/details_screens/components/media_stream_information.dart';
import 'components/overview_header_v3.dart';
import 'package:kebap/screens/shared/detail_scaffold.dart';
import 'package:kebap/screens/shared/media/chapter_row.dart';
import 'package:kebap/screens/shared/media/components/media_play_button.dart';
import 'package:kebap/screens/shared/media/expanding_overview.dart';
import 'package:kebap/screens/shared/media/external_urls.dart';
import 'package:kebap/screens/shared/media/people_row.dart';
import 'package:kebap/screens/shared/media/poster_row.dart';
import 'package:kebap/util/adaptive_layout/adaptive_layout.dart';
import 'package:kebap/util/item_base_model/item_base_model_extensions.dart';
import 'package:kebap/util/item_base_model/play_item_helpers.dart';
import 'package:kebap/util/list_padding.dart';
import 'package:kebap/util/router_extension.dart';
import 'package:kebap/util/widget_extensions.dart';
import 'package:kebap/widgets/shared/item_actions.dart';
import 'package:kebap/widgets/shared/item_details_reviews_carousel.dart';
import 'package:kebap/widgets/shared/modal_bottom_sheet.dart';
import 'package:kebap/widgets/shared/selectable_icon_button.dart';

class MovieDetailScreen extends ConsumerStatefulWidget {
  final ItemBaseModel item;
  const MovieDetailScreen({required this.item, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends ConsumerState<MovieDetailScreen> 
    with AutoRouteAwareStateMixin<MovieDetailScreen> {
  MovieDetailsProvider get providerInstance => movieDetailsProvider(widget.item.id);
  final FocusNode _playButtonNode = FocusNode();
  final FocusNode _mediaInfoNode = FocusNode(); // Version dropdown
  final FocusNode _audioFocusNode = FocusNode(); // Audio dropdown
  final FocusNode _subFocusNode = FocusNode(); // Subtitle dropdown

  bool _focusLocked = false; 
  Timer? _lockTimer;
  bool _wasStreamsLoading = true; // Track previous stream loading state
  FocusNode? _lastFocusedNode; // Track which node had focus last

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
      // This prevents stealing focus from the Version dropdown after a stream refresh.
      if (_playButtonNode.hasFocus || _mediaInfoNode.hasFocus || _audioFocusNode.hasFocus || _subFocusNode.hasFocus) {
         debugPrint('[FocusDebug] A widget already has focus (Play: ${_playButtonNode.hasFocus}, Info: ${_mediaInfoNode.hasFocus}). Respecting it.');
         // Do NOT lock here. Let the timer lock it. 
         // This allows us to re-check in subsequent delayed calls if focus was lost briefly.
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

    // Checking immediately + delays covers both instant and settled UI
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
    // Determine loading state
    final details = ref.watch(providerInstance);
    // Treated as loading if details null or explicit loading flag
    final bool isPageLoading = details == null;
    final bool isStreamsLoading = details?.mediaStreams.isLoading ?? true;

    // Detect Transition: Streams Loading -> Loaded
    if (_wasStreamsLoading && !isStreamsLoading) {
      debugPrint('[FocusDebug] Streams finished loading (Transition).');
      _focusLocked = false; 
      
      // RESTORE FOCUS if it was on a dropdown
      if (_lastFocusedNode == _mediaInfoNode || _lastFocusedNode == _audioFocusNode || _lastFocusedNode == _subFocusNode) {
         if (_lastFocusedNode?.canRequestFocus == true) {
             debugPrint('[FocusDebug] Restoring focus to last known dropdown node.');
             _lastFocusedNode?.requestFocus();
             _focusLocked = true; // Lock it immediately so attemptFocus doesn't fight us
         }
      }
    }
    _wasStreamsLoading = isStreamsLoading;

    // Request focus after EVERY build to overcome late async rebuilds
    // Pass isLoading so we don't lock focus prematurely
    if (!_focusLocked) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _requestPlayButtonFocus(isPageLoading);
      });
    }

    final wrapAlignment =
        AdaptiveLayout.viewSizeOf(context) != ViewSize.phone ? WrapAlignment.start : WrapAlignment.center;

    return DetailScaffold(
      label: widget.item.name,
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
      onRefresh: () async => await ref.read(providerInstance.notifier).fetchDetails(widget.item),
      backDrops: details?.images,
      content: (padding) {
        if (details == null) {
          return const SizedBox.shrink();
        }
        return Padding(
              padding: const EdgeInsets.only(bottom: 64),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  OverviewHeaderV3(
                    name: details.name,
                    image: details.images,
                    padding: padding,
                    centerButtons: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: wrapAlignment,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        MediaPlayButton(
                          focusNode: _playButtonNode,
                          // autofocus removed to allow manual control
                          item: details,
                          onLongPressed: (restart) async {
                            await details.play(
                              context,
                              ref,
                              showPlaybackOption: true,
                              startPosition: restart ? Duration.zero : null,
                            );
                          },
                          onPressed: (restart) async {
                            await details.play(
                              context,
                              ref,
                              startPosition: restart ? Duration.zero : null,
                            );
                          },
                        ),
                        SelectableIconButton(
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
                          onPressed: () async {
                            await ref.read(userProvider.notifier).markAsPlayed(!details.userData.played, details.id);
                          },
                          selected: details.userData.played,
                          selectedIcon: IconsaxPlusBold.tick_circle,
                          icon: IconsaxPlusLinear.tick_circle,
                        ),
                        // Removed trapping Shortcuts
                        SelectableIconButton(
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
                    originalTitle: details.originalTitle,
                    productionYear: details.overview.productionYear,
                    duration: details.overview.runTime,
                    genres: details.overview.genreItems,
                    studios: details.overview.studios,
                    officialRating: details.overview.parentalRating,
                    communityRating: details.overview.communityRating,
                    premiereDate: details.overview.premiereDate,
                  ),
                  MediaStreamInformation(
                    focusNode: _mediaInfoNode,
                    audioFocusNode: _audioFocusNode,
                    subFocusNode: _subFocusNode,
                    onVersionIndexChanged: (index) {
                      ref.read(providerInstance.notifier).setVersionIndex(index);
                    },
                    onSubIndexChanged: (index) {
                      ref.read(providerInstance.notifier).setSubIndex(index);
                    },
                    onAudioIndexChanged: (index) {
                      ref.read(providerInstance.notifier).setAudioIndex(index);
                    },
                    mediaStream: details.mediaStreams,
                  ).padding(padding),
                  if (details.overview.summary.isNotEmpty == true)
                    ExpandingOverview(
                      text: details.overview.summary,
                    ).padding(padding),
                  ItemDetailsReviewsCarousel(
                    item: details,
                    contentPadding: padding,
                  ),
                  if (details.chapters.isNotEmpty)
                    ChapterRow(
                      chapters: details.chapters,
                      contentPadding: padding,
                      onPressed: (chapter) {
                        details.play(
                          context,
                          ref,
                          startPosition: chapter.startPosition,
                        );
                      },
                    ),
                  if (details.overview.people.isNotEmpty)
                    PeopleRow(
                      people: details.overview.people,
                      contentPadding: padding,
                    ),

                  if (details.related.isNotEmpty)
                    PosterRow(posters: details.related, contentPadding: padding, label: "Related"),
                  if (details.overview.externalUrls?.isNotEmpty == true)
                    Padding(
                      padding: padding,
                      child: ExternalUrlsRow(
                        urls: details.overview.externalUrls,
                      ),
                    )
                ].addPadding(const EdgeInsets.symmetric(vertical: 16)),
              ),
            );
        },
    );
  }
}
