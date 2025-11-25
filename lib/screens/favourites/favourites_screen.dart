import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kebap/models/library_filter_model.dart';
import 'package:kebap/providers/favourites_provider.dart';
import 'package:kebap/providers/settings/client_settings_provider.dart';
import 'package:kebap/routes/auto_router.gr.dart';
import 'package:kebap/screens/home_screen.dart';
import 'package:kebap/screens/shared/media/poster_row.dart';
import 'package:kebap/screens/shared/nested_scaffold.dart';
import 'package:kebap/screens/shared/nested_sliver_appbar.dart';
import 'package:kebap/util/adaptive_layout/adaptive_layout.dart';
import 'package:kebap/util/focus_provider.dart';
import 'package:kebap/util/localization_helper.dart';
import 'package:kebap/util/sliver_list_padding.dart';
import 'package:kebap/widgets/navigation_scaffold/components/background_image.dart';
import 'package:kebap/widgets/shared/pinch_poster_zoom.dart';
import 'package:kebap/widgets/shared/poster_size_slider.dart';
import 'package:kebap/widgets/shared/pull_to_refresh.dart';

@RoutePage()
class FavouritesScreen extends ConsumerStatefulWidget {
  const FavouritesScreen({super.key});

  @override
  ConsumerState<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends ConsumerState<FavouritesScreen> {
  final FocusNode _mainFocusNode = FocusNode();
  bool _initialFocusSet = false;

  @override
  void dispose() {
    _mainFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final favourites = ref.watch(favouritesProvider);
    final padding = AdaptiveLayout.adaptivePadding(context);

    // Attempt to set initial focus when data is available
    if (!_initialFocusSet && favourites.favourites.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_initialFocusSet && favourites.favourites.isNotEmpty) {
          if (_mainFocusNode.canRequestFocus) {
            _mainFocusNode.requestFocus();
            _initialFocusSet = true;
          }
        }
      });
    }

    return PullToRefresh(
      onRefresh: () async => await ref.read(favouritesProvider.notifier).fetchFavourites(),
      child: NestedScaffold(
        background: BackgroundImage(items: favourites.favourites.values.expand((element) => element).toList()),
        body: PinchPosterZoom(
          scaleDifference: (difference) => ref.read(clientSettingsProvider.notifier).addPosterSize(difference / 2),
          child: FocusScope(
            autofocus: true,
            child: FocusTraversalGroup(
              policy: OrderedTraversalPolicy(),
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                controller: AdaptiveLayout.scrollOf(context, HomeTabs.favorites),
                slivers: [
                  if (AdaptiveLayout.viewSizeOf(context) == ViewSize.phone)
                    NestedSliverAppBar(
                      parent: context,
                      route: LibrarySearchRoute(favourites: true),
                    )
                  else
                    const DefaultSliverTopBadding(),
                  if (AdaptiveLayout.of(context).isDesktop)
                    SliverToBoxAdapter(
                      child: FocusTraversalOrder(
                        order: const NumericFocusOrder(2),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            PosterSizeWidget(),
                          ],
                        ),
                      ),
                    ),
                  ...[
                    ...favourites.favourites.entries.where((element) => element.value.isNotEmpty).map(
                          (e) => PosterRow(
                            contentPadding: padding,
                            onLabelClick: () => context.pushRoute(
                              LibrarySearchRoute().withFilter(
                                LibraryFilterModel(
                                  favourites: true,
                                  types: {e.key: true},
                                  recursive: true,
                                ),
                              ),
                            ),
                            label: e.key.label(context),
                            posters: e.value,
                            // We will inject focus node in mapIndexed below? No, mapIndexed is on the list of Widgets.
                            // But we need index to know if it's the first row.
                            // The list includes People row potentially.
                            // So we should construct the list first, then mapIndexed?
                            // Or just pass it to the first item if we can identify it.
                            // Let's do mapIndexed on the list of widgets.
                          ),
                        ),
                    if (favourites.people.isNotEmpty)
                      PosterRow(
                        contentPadding: padding,
                        label: context.localized.actor(favourites.people.length),
                        posters: favourites.people,
                      ),
                  ].mapIndexed(
                    (index, e) {
                      // If it's the first PosterRow (index 0), inject the focus node.
                      // But 'e' is already a Widget (PosterRow).
                      // We can't easily modify it.
                      // We should have mapped the data first.
                      
                      // Wait, I can wrap it? No, PosterRow needs the node.
                      // I should restructure the loop.
                      return SliverToBoxAdapter(
                        child: FocusTraversalOrder(
                          order: const NumericFocusOrder(1),
                          child: FocusProvider(
                            hasFocus: false, 
                            autoFocus: index == 0, 
                            child: index == 0 && e is PosterRow 
                                ? PosterRow(
                                    key: e.key,
                                    posters: e.posters,
                                    label: e.label,
                                    hideLabel: e.hideLabel,
                                    collectionAspectRatio: e.collectionAspectRatio,
                                    onLabelClick: e.onLabelClick,
                                    contentPadding: e.contentPadding,
                                    onFocused: e.onFocused,
                                    primaryPosters: e.primaryPosters,
                                    explicitHeight: e.explicitHeight,
                                    onCardTap: e.onCardTap,
                                    firstItemFocusNode: _mainFocusNode, // Inject here
                                  )
                                : e
                          ),
                        ),
                      );
                    },
                  ),
                  const DefautlSliverBottomPadding(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
