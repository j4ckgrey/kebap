import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import 'package:kebap/models/item_base_model.dart';
import 'package:kebap/screens/details_screens/components/overview_header_v3.dart';
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

    return SizedBox(
      width: double.infinity,
      height: bannerHeight,
      child: Stack(
        children: [
          // Backdrop image - full width
          ExcludeFocus(
            child: Align(
              alignment: viewSize < ViewSize.desktop ? Alignment.center : Alignment.centerRight,
              child: FractionallySizedBox(
                widthFactor: viewSize < ViewSize.desktop ? 1.0 : 0.8, // Full width on phone/tablet, 80% on desktop
                child: AspectRatio(
                  aspectRatio: viewSize < ViewSize.desktop ? 0.7 : 0.75, // Taller aspect ratio
                  child: CustomShaderMask(
                    child: KebapImage(
                      image: item!.images?.backDrop?.firstOrNull ?? item!.images?.primary,
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
                          subTitle: item!.label(context),
                          image: item!.getPosters,
                          showImage: false,
                          logoAlignment: Alignment.centerLeft,
                          summary: item!.overview.summary,
                          productionYear: item!.overview.productionYear,
                          duration: item!.overview.runTime,
                          genres: item!.overview.genreItems,
                          studios: item!.overview.studios,
                          officialRating: item!.overview.parentalRating,
                          communityRating: item!.overview.communityRating,
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
