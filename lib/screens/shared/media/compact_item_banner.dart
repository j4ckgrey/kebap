import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import 'package:kebap/models/item_base_model.dart';
import 'package:kebap/models/settings/home_settings_model.dart';
import 'package:kebap/providers/items/series_overview_provider.dart';
import 'package:kebap/providers/settings/home_settings_provider.dart';
import 'package:kebap/providers/trailer_provider.dart';
import 'package:kebap/screens/details_screens/components/overview_header_v3.dart';
import 'package:kebap/screens/shared/media/trailer_banner_player.dart';
import 'package:kebap/util/adaptive_layout/adaptive_layout.dart';
import 'package:kebap/util/focus_provider.dart';
import 'package:kebap/util/kebap_image.dart';
import 'package:kebap/widgets/shared/custom_shader_mask.dart';

/// Compact banner for displaying focused item details above horizontal rows.
/// Optimized for all devices with centered poster and "Open" button.
class CompactItemBanner extends ConsumerWidget {
  final ItemBaseModel? item;
  final double? maxHeight;

  const CompactItemBanner({
    required this.item,
    this.maxHeight,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (item == null) return const SizedBox.shrink();

    final size = MediaQuery.sizeOf(context);
    final viewSize = AdaptiveLayout.viewSizeOf(context);
    final layoutMode = AdaptiveLayout.layoutModeOf(context);
    
    final bannerHeight = maxHeight ?? (size.height * 0.38);

    // Check banner media type setting
    final bannerMediaType = ref.watch(
      homeSettingsProvider.select((value) => value.bannerMediaType),
    );
    
    // Only fetch trailer URL if trailer mode is enabled and item type supports trailers
    // For episodes, we fetch the trailer from the parent series
    final supportsTrailers = item!.type == KebapItemType.movie || 
        item!.type == KebapItemType.series ||
        item!.type == KebapItemType.episode;
    final shouldFetchTrailer = bannerMediaType == HomeBannerMediaType.trailer && supportsTrailers;
    
    // For episodes, use the parent series ID to fetch the trailer
    final trailerItemId = item!.type == KebapItemType.episode 
        ? item!.parentBaseModel.id  // Parent series ID
        : item!.id;
    
    // Fetch trailer URL on-demand (cached by riverpod)
    final trailerUrlAsync = shouldFetchTrailer && trailerItemId.isNotEmpty
        ? ref.watch(trailerUrlProvider(trailerItemId))
        : const AsyncData<String?>(null);
    
    final trailerUrl = trailerUrlAsync.valueOrNull;
    final showTrailer = trailerUrl != null;
    
    debugPrint('[CompactItemBanner] Item: ${item!.name}, Type: ${item!.type}, TrailerItemId: $trailerItemId, TrailerUrl: $trailerUrl, ShowTrailer: $showTrailer');

    // Check if we need to fetch a fallback overview
    String? fallbackOverview;
    if (item?.type == KebapItemType.episode && (item?.overview.summary.isEmpty ?? true)) {
      final seriesOverviewAsync = ref.watch(seriesOverviewProvider(item?.parentId ?? ''));
      fallbackOverview = seriesOverviewAsync.value;
    }

    return SizedBox(
      width: double.infinity,
      height: bannerHeight,
      child: Stack(
        children: [
          // Backdrop image or trailer - full width
          ExcludeFocus(
            child: Align(
              alignment: viewSize < ViewSize.desktop ? Alignment.center : Alignment.centerRight,
              child: FractionallySizedBox(
                widthFactor: viewSize < ViewSize.desktop ? 1.0 : 0.8, // Full width on phone/tablet, 80% on desktop
                child: AspectRatio(
                  aspectRatio: viewSize < ViewSize.desktop ? 0.7 : 0.75, // Taller aspect ratio
                  child: CustomShaderMask(
                    child: showTrailer
                        ? TrailerBannerPlayer(
                            trailerUrl: trailerUrl,
                            fallbackImage: item!.images?.backDrop?.firstOrNull ?? item!.images?.primary,
                          )
                        : KebapImage(
                            image: item!.images?.backDrop?.firstOrNull ?? item!.images?.primary,
                            decodeHeight: null,
                          ),
                  ),
                ),
              ),
            ),
          ),
          // Content overlay - optimized layout
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: viewSize < ViewSize.desktop ? 8 : 12,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: viewSize < ViewSize.desktop ? 1.0 : 0.33,
                child: Container(
                  height: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Flexible(
                        child: OverviewHeaderV3(
                          name: item!.parentBaseModel.name,
                          subTitle: item!.type == KebapItemType.episode
                              ? "${item!.parentBaseModel.name}\n${item!.label(context)}"
                              : item!.type == KebapItemType.series
                                  ? item!.name
                                  : item!.label(context),
                          image: item!.getPosters,
                          showImage: false,
                          logoAlignment: Alignment.centerLeft,
                          summary: (item!.overview.summary.isNotEmpty) 
                              ? item!.overview.summary 
                              : fallbackOverview,
                          productionYear: item!.overview.productionYear,
                          duration: item!.overview.runTime,
                          genres: item!.overview.genreItems,
                          studios: item!.overview.studios,
                          officialRating: item!.overview.parentalRating,
                          communityRating: item!.overview.communityRating,
                          premiereDate: item!.overview.premiereDate,
                        ),
                      ),
                      // Open button - hide on TV, keep focusable for mouse/touch on other devices
                      if (viewSize != ViewSize.television)
                        Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 4),
                          child: FocusButton(
                            onTap: () async {
                              await item!.navigateTo(context, ref: ref);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    IconsaxPlusBold.play_circle,
                                    color: Theme.of(context).colorScheme.onPrimary,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Open',
                                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                      color: Theme.of(context).colorScheme.onPrimary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
