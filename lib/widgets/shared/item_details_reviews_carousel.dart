import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kebap/models/item_base_model.dart';
import 'package:kebap/models/tmdb_metadata_model.dart';
import 'package:kebap/providers/effective_baklava_config_provider.dart';
import 'package:kebap/providers/baklava_metadata_provider.dart';
import 'package:kebap/util/adaptive_layout/adaptive_layout.dart';
import 'package:kebap/util/list_padding.dart';
import 'package:kebap/util/focus_provider.dart';

class ItemDetailsReviewsCarousel extends ConsumerStatefulWidget {
  final ItemBaseModel item;
  final EdgeInsets contentPadding;

  const ItemDetailsReviewsCarousel({
    required this.item,
    this.contentPadding = EdgeInsets.zero,
    super.key,
  });

  @override
  ConsumerState<ItemDetailsReviewsCarousel> createState() => _ItemDetailsReviewsCarouselState();
}

class _ItemDetailsReviewsCarouselState extends ConsumerState<ItemDetailsReviewsCarousel> {
  List<TMDBReview>? _reviews;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchReviews();
  }

  Future<void> _fetchReviews() async {
    final config = await ref.read(effectiveBaklavaConfigProvider.future);
    
    // Don't show if reviews carousel is disabled in config
    if (config.showReviewsCarousel != true) {
      setState(() {
        _loading = false;
      });
      return;
    }

    // Get TMDB ID from item
    final tmdbId = widget.item.overview.providerIds?['Tmdb'];
    if (tmdbId == null) {
      setState(() {
        _loading = false;
      });
      return;
    }

    // Determine media type
    final mediaType = widget.item.type.name.toLowerCase() == 'movie' ? 'movie' : 'tv';

    // Fetch metadata with reviews
    await ref.read(baklavaMetadataProvider.notifier).fetchTMDBMetadata(
      tmdbId: tmdbId,
      itemType: mediaType,
      includeCredits: false,
      includeReviews: true,
    );

    final metadataState = ref.read(baklavaMetadataProvider);
    setState(() {
      _reviews = metadataState.reviews;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const SizedBox.shrink();
    }

    // Don't show carousel if no reviews
    if (_reviews == null || _reviews!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: widget.contentPadding,
      child: _ReviewsCarouselWidget(
        reviews: _reviews!.take(10).toList(),
        theme: Theme.of(context),
      ),
    );
  }
}

class _ReviewsCarouselWidget extends StatefulWidget {
  final List<TMDBReview> reviews;
  final ThemeData theme;

  const _ReviewsCarouselWidget({
    required this.reviews,
    required this.theme,
  });

  @override
  State<_ReviewsCarouselWidget> createState() => _ReviewsCarouselWidgetState();
}

class _ReviewsCarouselWidgetState extends State<_ReviewsCarouselWidget> {
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 0;
  final double _cardWidth = 300;
  final double _cardMargin = 12;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToNext() {
    if (_currentPage < widget.reviews.length - 1) {
      setState(() {
        _currentPage++;
      });
      _scrollController.animateTo(
        (_cardWidth + _cardMargin) * _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _scrollToPrevious() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
      });
      _scrollController.animateTo(
        (_cardWidth + _cardMargin) * _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final layoutMode = AdaptiveLayout.layoutModeOf(context);
    final isDesktop = layoutMode == LayoutMode.dual;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Reviews',
              style: widget.theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (isDesktop)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: _currentPage > 0 ? _scrollToPrevious : null,
                    icon: const Icon(Icons.arrow_back_ios),
                    iconSize: 20,
                  ),
                  IconButton(
                    onPressed: _currentPage < widget.reviews.length - 1 ? _scrollToNext : null,
                    icon: const Icon(Icons.arrow_forward_ios),
                    iconSize: 20,
                  ),
                ],
              ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 180,
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: widget.reviews.length,
            itemBuilder: (context, index) {
              final review = widget.reviews[index];
              final truncatedContent = review.content.length > 200
                  ? '${review.content.substring(0, 200)}...'
                  : review.content;
              return FocusButton(
                onTap: () {}, // Make it focusable
                child: Container(
                  width: _cardWidth,
                  margin: EdgeInsets.only(right: _cardMargin),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: widget.theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (review.authorDetails?.rating != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.star,
                                    size: 14,
                                    color: Colors.black,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    review.authorDetails!.rating!.toStringAsFixed(1),
                                    style: widget.theme.textTheme.bodySmall?.copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              review.author,
                              style: widget.theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: Text(
                          truncatedContent,
                          style: widget.theme.textTheme.bodySmall,
                          maxLines: 6,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        if (!isDesktop) ...[
          const SizedBox(height: 12),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                widget.reviews.length,
                (index) => Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index
                        ? widget.theme.colorScheme.primary
                        : widget.theme.colorScheme.surfaceContainerHighest,
                  ),
                ),
              ),
            ),
          ),
        ],
      ].addPadding(const EdgeInsets.symmetric(vertical: 8)),
    );
  }
}
