import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kebap/models/item_base_model.dart';
import 'package:kebap/screens/details_screens/components/overview_header.dart';
import 'package:kebap/util/adaptive_layout/adaptive_layout.dart';
import 'package:kebap/util/focus_provider.dart';
import 'package:kebap/util/kebap_image.dart';
import 'package:kebap/widgets/shared/custom_shader_mask.dart';

class DetailedBanner extends ConsumerStatefulWidget {
  final List<ItemBaseModel> posters;
  final Function(ItemBaseModel selected) onSelect;
  const DetailedBanner({
    required this.posters,
    required this.onSelect,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DetailedBannerState();
}

class _DetailedBannerState extends ConsumerState<DetailedBanner> {
  late ValueNotifier<ItemBaseModel> selectedPoster = ValueNotifier(widget.posters.first);
  bool _isHovering = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final viewSize = AdaptiveLayout.viewSizeOf(context);
    final layoutMode = AdaptiveLayout.layoutModeOf(context);

    return layoutMode == LayoutMode.single
        ? Stack(
      children: [
        ExcludeFocus(
          child: Align(
            alignment: Alignment.topRight,
            child: FractionallySizedBox(
              widthFactor: 0.85,
              child: AspectRatio(
                aspectRatio: 1.8,
                child: CustomShaderMask(
                  child: ValueListenableBuilder<ItemBaseModel>(
                    valueListenable: selectedPoster,
                    builder: (context, value, child) => KebapImage(
                      image: value.images?.backDrop?.firstOrNull ?? value.images?.primary,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: double.infinity,
          height: size.height * 0.85,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 4),
                  child: FractionallySizedBox(
                    widthFactor: viewSize <= ViewSize.phone ? 1.0 : 0.55,
                    child: ValueListenableBuilder<ItemBaseModel>(
                      valueListenable: selectedPoster,
                      builder: (context, value, child) => FocusButton(
                        focusNode: _focusNode,
                        autofocus: false, // Don't autofocus to avoid conflicts
                        onTap: () => widget.onSelect(value),
                        onFocusChanged: (hasFocus) => setState(() => _isHovering = hasFocus),
                        child: Stack(
                          children: [
                            OverviewHeader(
                              name: value.parentBaseModel.name,
                              subTitle: value.label(context),
                              image: value.getPosters,
                              showImage: false,
                              logoAlignment: viewSize <= ViewSize.phone
                                  ? Alignment.center
                                  : Alignment.centerLeft,
                              summary: value.overview.summary,
                              productionYear: value.overview.productionYear,
                              runTime: value.overview.runTime,
                              genres: value.overview.genreItems,
                              studios: value.overview.studios,
                              officialRating: value.overview.parentalRating,
                              communityRating: value.overview.communityRating,
                            ),
                            if (_isHovering)
                              Positioned(
                                top: 16,
                                right: 16,
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
                                        Icons.open_in_new,
                                        size: 16,
                                        color: Theme.of(context).colorScheme.onPrimary,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Open',
                                        style: TextStyle(
                                          color: Theme.of(context).colorScheme.onPrimary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
      )
        : Stack(
            children: [
              ExcludeFocus(
                child: Align(
                  alignment: Alignment.topRight,
                  child: FractionallySizedBox(
                    widthFactor: 0.85,
                    child: AspectRatio(
                      aspectRatio: 1.8,
                      child: CustomShaderMask(
                        child: ValueListenableBuilder<ItemBaseModel>(
                          valueListenable: selectedPoster,
                          builder: (context, value, child) => KebapImage(
                            image: value.images?.backDrop?.firstOrNull ?? value.images?.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: size.height * 0.85,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 4),
                        child: FractionallySizedBox(
                          widthFactor: 0.55,
                          child: ValueListenableBuilder<ItemBaseModel>(
                            valueListenable: selectedPoster,
                            builder: (context, value, child) => FocusButton(
                              focusNode: _focusNode,
                              autofocus: false, // Don't autofocus to avoid conflicts
                              onTap: () => widget.onSelect(value),
                              onFocusChanged: (hasFocus) => setState(() => _isHovering = hasFocus),
                              child: Stack(
                                children: [
                                  OverviewHeader(
                                    name: value.parentBaseModel.name,
                                    subTitle: value.label(context),
                                    image: value.getPosters,
                                    showImage: false,
                                    logoAlignment: Alignment.centerLeft,
                                    summary: value.overview.summary,
                                    productionYear: value.overview.productionYear,
                                    runTime: value.overview.runTime,
                                    genres: value.overview.genreItems,
                                    studios: value.overview.studios,
                                    officialRating: value.overview.parentalRating,
                                    communityRating: value.overview.communityRating,
                                  ),
                                  if (_isHovering)
                                    Positioned(
                                      top: 16,
                                      right: 16,
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
                                              Icons.open_in_new,
                                              size: 16,
                                              color: Theme.of(context).colorScheme.onPrimary,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              'Open',
                                              style: TextStyle(
                                                color: Theme.of(context).colorScheme.onPrimary,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
  }
}
