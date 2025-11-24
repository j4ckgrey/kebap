import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import 'package:kebap/models/item_base_model.dart';
import 'package:kebap/screens/details_screens/components/overview_header.dart';
import 'package:kebap/util/adaptive_layout/adaptive_layout.dart';
import 'package:kebap/util/focus_provider.dart';
import 'package:kebap/util/kebap_image.dart';
import 'package:kebap/widgets/shared/custom_shader_mask.dart';

/// Compact banner for displaying focused item details above horizontal rows.
/// Similar to DetailedBanner but with reduced height to fit: navbar + banner + row = viewport.
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
    final isTouchDevice = AdaptiveLayout.inputDeviceOf(context) == InputDevice.touch;
    
    // Compact height: ~25-30% of viewport vs 85% for DetailedBanner
    // For touch devices on mobile, use even smaller height (40-45%)
    final bannerHeight = maxHeight ?? (isTouchDevice && viewSize <= ViewSize.phone 
        ? size.height * 0.42 
        : size.height * 0.30);

    return SizedBox(
      width: double.infinity,
      height: bannerHeight,
      child: Stack(
        children: [
          // Backdrop image
          ExcludeFocus(
            child: Align(
              alignment: isTouchDevice && viewSize <= ViewSize.phone 
                  ? Alignment.center  // Center for touch devices
                  : Alignment.topRight,
              child: FractionallySizedBox(
                widthFactor: isTouchDevice && viewSize <= ViewSize.phone ? 0.6 : 0.85,
                child: AspectRatio(
                  aspectRatio: isTouchDevice && viewSize <= ViewSize.phone ? 1.0 : 1.8,
                  child: CustomShaderMask(
                    child: KebapImage(
                      image: item!.images?.backDrop?.firstOrNull ?? item!.images?.primary,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Content overlay
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: FractionallySizedBox(
                    widthFactor: layoutMode == LayoutMode.single
                        ? (viewSize <= ViewSize.phone ? 1.0 : 0.55)
                        : 0.55,
                    child: OverviewHeader(
                      name: item!.parentBaseModel.name,
                      subTitle: item!.label(context),
                      image: item!.getPosters,
                      showImage: false,
                      logoAlignment: viewSize <= ViewSize.phone
                          ? Alignment.centerLeft
                          : Alignment.centerLeft,
                      summary: item!.overview.summary,
                      productionYear: item!.overview.productionYear,
                      runTime: item!.overview.runTime,
                      genres: item!.overview.genreItems,
                      studios: item!.overview.studios,
                      officialRating: item!.overview.parentalRating,
                      communityRating: item!.overview.communityRating,
                    ),
                  ),
                ),
                // Open button for touch devices
                if (isTouchDevice && viewSize <= ViewSize.phone)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: FocusButton(
                      onTap: () async {
                        await item!.navigateTo(context, ref: ref);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Open',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
        ],
      ),
    );
  }
}
