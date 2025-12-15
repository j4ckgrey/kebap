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
  final FocusNode _mediaInfoNode = FocusNode(); // NEW FOCUS NODE

  Timer? _pollingTimer;
  int _pollCount = 0;
  static const int _maxPolls = 15; // 30 seconds max (2s interval)

  bool _focusLocked = false;  // Set to true once all async ops complete
  Timer? _lockTimer;  // Debounce timer for focus lock

  @override
  void initState() {
    super.initState();
    _playButtonNode.addListener(_onPlayButtonFocusChange);
  }

  // AutoRouteAware callback - called when returning to this screen from another route (e.g. video player)
  @override
  void didPopNext() {
    debugPrint('[MovieDetailScreen] didPopNext - refreshing details for resume button');
    // Refresh the item details so that playback progress/resume button updates
    ref.read(providerInstance.notifier).fetchDetails(widget.item);
  }

  void _onPlayButtonFocusChange() {
    // Not used for locking anymore, but kept for potential future use
  }

  void _scheduleFocusLock() {
    // Cancel any pending lock timer and restart
    _lockTimer?.cancel();
    // Lock focus 2 seconds after the LAST build (no more rebuilds = async complete)
    _lockTimer = Timer(const Duration(seconds: 2), () {
      _focusLocked = true;
      debugPrint('[FocusDebug] Focus locked - no rebuilds for 2 seconds');
    });
  }

  void _requestPlayButtonFocus() {
    if (_focusLocked) return;
    
    // Reset the lock timer on every focus request (debounce)
    _scheduleFocusLock();
    
    // Use a delay to ensure widgets have built, then ALWAYS request focus
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted && !_focusLocked && _playButtonNode.canRequestFocus) {
        _playButtonNode.requestFocus();
        debugPrint('[FocusDebug] Play button focus requested (delayed)');
      }
    });
  }

  void _checkAndStartPolling(MovieModel? details) {
    if (details == null) return;
    if (_pollingTimer != null && _pollingTimer!.isActive) return; // Don't restart if active

    debugPrint('[StreamRefresh] Checking if polling is needed for ${details.name}');

    bool shouldPoll = false;
    if (details.mediaStreams.versionStreams.isEmpty) {
      debugPrint('[StreamRefresh] No version streams found. Polling required.');
      shouldPoll = true;
    } else {
      final first = details.mediaStreams.versionStreams.firstOrNull;
      final totalStreams = (first?.videoStreams.length ?? 0) +
          (first?.audioStreams.length ?? 0) +
          (first?.subStreams.length ?? 0);
      debugPrint('[StreamRefresh] First version has $totalStreams streams.');
      if (totalStreams == 0) shouldPoll = true;
    }

    if (shouldPoll) {
      _startPolling();
    }
  }

  void _startPolling() {
    debugPrint('[StreamRefresh] Starting polling timer (max $_maxPolls polls)...');
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      if (!mounted) {
        timer.cancel();
        return;
      }

      _pollCount++;
       debugPrint('[StreamRefresh] Poll #$_pollCount...');
      if (_pollCount > _maxPolls) {
        debugPrint('[StreamRefresh] Max polls reached. Stopping.');
        timer.cancel();
        return;
      }

      final details = ref.read(providerInstance);
      if (details == null) return;

      bool hasStreams = false;
      if (details.mediaStreams.versionStreams.isNotEmpty) {
        final first = details.mediaStreams.versionStreams.firstOrNull;
        final totalStreams = (first?.videoStreams.length ?? 0) +
            (first?.audioStreams.length ?? 0) +
            (first?.subStreams.length ?? 0);
        if (totalStreams > 0) hasStreams = true;
      }

      if (hasStreams) {
        debugPrint('[StreamRefresh] Streams found! Stopping polling.');
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
    // print('[LAG_DEBUG] ${DateTime.now()} MovieDetailScreen build: ${widget.item.name}');
    
    // Request focus after EVERY build to overcome late async rebuilds
    if (!_focusLocked) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _requestPlayButtonFocus();
      });
    }
    
    ref.listen(providerInstance, (prev, next) {
      if (next != null) {
         _checkAndStartPolling(next);
      }
    });
    final details = ref.watch(providerInstance);

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
          return const Center(child: CircularProgressIndicator());
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
                          autofocus: true,
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
                                  children: details.generateActions(context, ref).listTileItems(context, useIcons: true),
                                ),
                              );
                            },
                            selected: false,
                            icon: IconsaxPlusLinear.more,
                          ),
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
                  if (details.mediaStreams.versionStreams.isNotEmpty || details.mediaStreams.isLoading)
                    MediaStreamInformation(
                      focusNode: _mediaInfoNode,
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
