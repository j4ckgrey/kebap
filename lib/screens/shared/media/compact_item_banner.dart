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
class CompactItemBanner extends StatelessWidget {
  final ItemBaseModel? item;
  final double? maxHeight;

  const CompactItemBanner({
    required this.item,
    this.maxHeight,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (item == null) return const SizedBox.shrink();

    final size = MediaQuery.sizeOf(context);
    final viewSize = AdaptiveLayout.viewSizeOf(context);
    final layoutMode = AdaptiveLayout.layoutModeOf(context);
    
    final bannerHeight = maxHeight ?? (size.height * 0.38);

    // Use Consumer only for the specific settings we need
    return Consumer(
      builder: (context, ref, child) {
        // Check banner media type setting with select to avoid unnecessary rebuilds
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
    
    // Conditionally watch trailer provider ONLY when needed
    String? trailerUrl;
    if (shouldFetchTrailer && trailerItemId.isNotEmpty) {
      final trailerUrlAsync = ref.watch(trailerUrlProvider(trailerItemId));
      trailerUrl = trailerUrlAsync.valueOrNull;
    }
    
    final showTrailer = trailerUrl != null;

        // Check if we need to fetch a fallback overview (only for episodes with empty overview)
        String? fallbackOverview;
        if (item!.type == KebapItemType.episode && item!.overview.summary.isEmpty) {
          final seriesOverviewAsync = ref.watch(seriesOverviewProvider(item!.parentId ?? ''));
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
                            fallbackImage: item!.bannerImage,
                          )
                        : KebapImage(
                            image: item!.bannerImage,
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
                          enableSpacer: false, // Fix overlap on homepage
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
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
        );
      },
    );
  }
}
