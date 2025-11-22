import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kebap/models/item_base_model.dart';
import 'package:kebap/screens/details_screens/components/overview_header.dart';
import 'package:kebap/util/adaptive_layout/adaptive_layout.dart';
import 'package:kebap/util/fladder_image.dart';
import 'package:kebap/util/localization_helper.dart';
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
              // Use original sizing: 85% width for better visual balance
              widthFactor: 0.85,
              child: AspectRatio(
                // Use original aspect ratio: 1.8 for wider poster
                aspectRatio: 1.8,
                child: CustomShaderMask(
                  child: ValueListenableBuilder<ItemBaseModel>(
                    valueListenable: selectedPoster,
                    builder: (context, value, child) => FladderImage(
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
          // Increase height to give banner more vertical space
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
                    // Use original sizing to match the poster width
                    widthFactor: viewSize <= ViewSize.phone ? 1.0 : 0.55,
                    child: ValueListenableBuilder<ItemBaseModel>(
                      valueListenable: selectedPoster,
                      builder: (context, value, child) => Focus(
                        focusNode: _focusNode,
                        onFocusChange: (hasFocus) => setState(() => _isHovering = hasFocus),
                        onKeyEvent: (node, event) {
                          if (event is KeyDownEvent) {
                            if (event.logicalKey == LogicalKeyboardKey.enter ||
                                event.logicalKey == LogicalKeyboardKey.select) {
                              widget.onSelect(value);
                              return KeyEventResult.handled;
                            }
                          }
                          return KeyEventResult.ignored;
                        },
                        child: MouseRegion(
                          onEnter: (_) => setState(() => _isHovering = true),
                          onExit: (_) => setState(() => _isHovering = false),
                          child: GestureDetector(
                            onTap: () => widget.onSelect(value),
                            child: Stack(
                              children: [
                                OverviewHeader(
                                  name: value.parentBaseModel.name,
                                  subTitle: value.label(context),
                                  image: value.getPosters,
                                  showImage: false,
                                  logoAlignment: AdaptiveLayout.viewSizeOf(context) <= ViewSize.phone
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
                    // Use original 85% width for proper visual balance
                    widthFactor: 0.85,
                    child: AspectRatio(
                      // Use original 1.8 aspect ratio for wider poster
                      aspectRatio: 1.8,
                      child: CustomShaderMask(
                        child: ValueListenableBuilder<ItemBaseModel>(
                          valueListenable: selectedPoster,
                          builder: (context, value, child) => FladderImage(
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
                          // Match original 55% width to align with poster
                          widthFactor: 0.55,
                          child: ValueListenableBuilder<ItemBaseModel>(
                            valueListenable: selectedPoster,
                            builder: (context, value, child) => Focus(
                              focusNode: _focusNode,
                              onFocusChange: (hasFocus) => setState(() => _isHovering = hasFocus),
                              onKeyEvent: (node, event) {
                                if (event is KeyDownEvent) {
                                  if (event.logicalKey == LogicalKeyboardKey.enter ||
                                      event.logicalKey == LogicalKeyboardKey.select) {
                                    widget.onSelect(value);
                                    return KeyEventResult.handled;
                                  }
                                }
                                return KeyEventResult.ignored;
                              },
                              child: MouseRegion(
                                onEnter: (_) => setState(() => _isHovering = true),
                                onExit: (_) => setState(() => _isHovering = false),
                                child: GestureDetector(
                                  onTap: () => widget.onSelect(value),
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
                  ],
                ),
              ),
            ],
          );
  }
}
