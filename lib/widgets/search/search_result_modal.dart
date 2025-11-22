import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import 'package:kebap/models/item_base_model.dart';
import 'package:kebap/models/tmdb_metadata_model.dart';
import 'package:kebap/providers/baklava_metadata_provider.dart';
import 'package:kebap/providers/baklava_requests_provider.dart';
import 'package:kebap/providers/user_provider.dart';
import 'package:kebap/screens/shared/kebap_snackbar.dart';
import 'package:kebap/util/adaptive_layout/adaptive_layout.dart';

class SearchResultModal extends ConsumerStatefulWidget {
  final ItemBaseModel item;

  const SearchResultModal({
    required this.item,
    super.key,
  });

  @override
  ConsumerState<SearchResultModal> createState() => _SearchResultModalState();
}

class _SearchResultModalState extends ConsumerState<SearchResultModal> {
  bool _importing = false;
  bool _requesting = false;
  bool _metadataFetched = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Fetch metadata only once when dependencies are ready
    if (!_metadataFetched) {
      _metadataFetched = true;
      Future.microtask(() => _fetchMetadata());
    }
  }

  Future<void> _fetchMetadata() async {
    final metadataNotifier = ref.read(baklavaMetadataProvider.notifier);

    // Extract IDs from item
    final tmdbId = _extractTMDBId(widget.item);
    final imdbId = _extractIMDBId(widget.item);
    final itemType = _detectItemType(widget.item);

    // Fetch TMDB metadata
    final metadata = await metadataNotifier.fetchTMDBMetadata(
      tmdbId: tmdbId,
      imdbId: imdbId,
      itemType: itemType,
      title: widget.item.name,
      year: widget.item.overview.productionYear,
    );

    if (metadata != null) {
      // Fetch external IDs if needed
      if (imdbId == null && tmdbId != null) {
        await metadataNotifier.fetchExternalIds(
          tmdbId,
          itemType == 'series' ? 'tv' : 'movie',
        );
        // Update IMDB ID if found
      }

      // Check library status
      await metadataNotifier.checkLibraryStatus(imdbId, tmdbId, itemType);
    }
  }

  String? _extractTMDBId(ItemBaseModel item) {
    // Try to extract TMDB ID from provider IDs
    final tmdbProvider = item.overview.providerIds?['Tmdb'];
    if (tmdbProvider != null) return tmdbProvider;

    // Try to extract from item ID
    final itemId = item.id;
    if (itemId.contains('tmdb')) {
      final match = RegExp(r'tmdb[_-](\d+)').firstMatch(itemId);
      if (match != null) return match.group(1);
    }

    return null;
  }

  String? _extractIMDBId(ItemBaseModel item) {
    // Try to extract IMDB ID from provider IDs
    final imdbProvider = item.overview.providerIds?['Imdb'];
    if (imdbProvider != null) return imdbProvider;

    // Try to extract from item ID
    final itemId = item.id;
    if (RegExp(r'^tt\d+$').hasMatch(itemId)) {
      return itemId;
    }

    return null;
  }

  String _detectItemType(ItemBaseModel item) {
    final type = item.type.name.toLowerCase();
    if (type.contains('series') || type.contains('show')) {
      return 'series';
    }
    return 'movie';
  }

  Future<void> _handleImport() async {
    setState(() => _importing = true);

    final metadataState = ref.read(baklavaMetadataProvider);
    final imdbId = metadataState.metadata?.imdbId ?? _extractIMDBId(widget.item);

    if (imdbId == null) {
      if (mounted) {
        fladderSnackbar(context, title: 'Cannot import: No IMDB ID found');
      }
      setState(() => _importing = false);
      return;
    }

    final itemType = _detectItemType(widget.item);
    final success = await ref.read(baklavaMetadataProvider.notifier).importToLibrary(imdbId, itemType);

    setState(() => _importing = false);

    if (mounted) {
      if (success) {
        fladderSnackbar(context, title: 'Import started successfully');
        Navigator.of(context).pop();
      } else {
        fladderSnackbar(context, title: 'Import failed');
      }
    }
  }

  Future<void> _handleRequest() async {
    setState(() => _requesting = true);

    final metadataState = ref.read(baklavaMetadataProvider);
    
    final success = await ref.read(baklavaRequestsProvider.notifier).createRequest(
      title: widget.item.name,
      year: widget.item.overview.productionYear?.toString(),
      img: widget.item.images?.primary?.path,
      imdbId: metadataState.metadata?.imdbId ?? _extractIMDBId(widget.item),
      tmdbId: metadataState.metadata?.id.toString() ?? _extractTMDBId(widget.item),
      jellyfinId: widget.item.id,
      itemType: _detectItemType(widget.item),
    );

    setState(() => _requesting = false);

    if (mounted) {
      if (success) {
        fladderSnackbar(context, title: 'Request created successfully');
        Navigator.of(context).pop();
      } else {
        fladderSnackbar(context, title: 'Failed to create request');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final metadataState = ref.watch(baklavaMetadataProvider);
    final user = ref.watch(userProvider);
    final isAdmin = user?.policy?.isAdministrator ?? false;

    final metadata = metadataState.metadata;
    final credits = metadataState.credits;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        height: 600,
        width: double.maxFinite,
        constraints: const BoxConstraints(maxWidth: 900),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: metadataState.loading
            ? const Center(child: CircularProgressIndicator())
            : Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Left: Poster - show item poster immediately, fallback to TMDB
                  Container(
                    width: 300,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                      ),
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(
                          metadata?.posterPath != null
                              ? 'https://image.tmdb.org/t/p/w500${metadata!.posterPath}'
                              : widget.item.images?.primary?.path ?? '',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  // Right: Content
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header with title and close button
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  metadata?.title ?? metadata?.name ?? widget.item.name,
                                  style: theme.textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Metadata row
                          Wrap(
                            spacing: 16,
                            runSpacing: 8,
                            children: [
                              if (metadata?.releaseDate != null || metadata?.firstAirDate != null)
                                Text(
                                  (metadata?.releaseDate ?? metadata?.firstAirDate ?? '').substring(0, 4),
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                                  ),
                                ),
                              if (metadata?.runtime != null)
                                Text(
                                  '${metadata!.runtime} min',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                                  ),
                                ),
                              if (metadata?.voteAverage != null)
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.star, size: 16, color: Colors.amber),
                                    const SizedBox(width: 4),
                                    Text(
                                      metadata!.voteAverage!.toStringAsFixed(1),
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Genres
                          if (metadata?.genres != null && metadata!.genres!.isNotEmpty) ...[
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: metadata.genres!
                                  .map((genre) => Chip(
                                        label: Text(genre.name),
                                        labelStyle: theme.textTheme.bodySmall,
                                      ))
                                  .toList(),
                            ),
                            const SizedBox(height: 24),
                          ],

                          // Overview
                          if (metadata?.overview != null && metadata!.overview!.isNotEmpty) ...[
                            Text(
                              'Overview',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              metadata.overview!,
                              style: theme.textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 24),
                          ],

                          // Cast with photos
                          if (credits?.cast != null && credits!.cast!.isNotEmpty) ...[
                            Text(
                              'Cast',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              height: 140,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: credits.cast!.take(12).length,
                                itemBuilder: (context, index) {
                                  final cast = credits.cast![index];
                                  return Container(
                                    width: 100,
                                    margin: const EdgeInsets.only(right: 12),
                                    child: Column(
                                      children: [
                                        Container(
                                          width: 80,
                                          height: 80,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            color: theme.colorScheme.surfaceContainerHighest,
                                          ),
                                          clipBehavior: Clip.antiAlias,
                                          child: cast.profilePath != null
                                              ? CachedNetworkImage(
                                                  imageUrl:
                                                      'https://image.tmdb.org/t/p/w185${cast.profilePath}',
                                                  fit: BoxFit.cover,
                                                  errorWidget: (_, __, ___) => const Icon(
                                                    Icons.person,
                                                    size: 40,
                                                  ),
                                                )
                                              : const Icon(Icons.person, size: 40),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          cast.name,
                                          style: theme.textTheme.bodySmall?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                        ),
                                        if (cast.character != null)
                                          Text(
                                            cast.character!,
                                            style: theme.textTheme.bodySmall?.copyWith(
                                              color: theme.colorScheme.onSurface
                                                  .withValues(alpha: 0.6),
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                          ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],

                          // Reviews carousel
                          if (metadataState.reviews != null && metadataState.reviews!.isNotEmpty) ...[
                            _ReviewsCarousel(
                              reviews: metadataState.reviews!.take(10).toList(),
                              theme: theme,
                            ),
                            const SizedBox(height: 24),
                          ],

                          // Action buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (metadataState.inLibrary)
                                FilledButton.icon(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    // Navigate to item details
                                  },
                                  icon: const Icon(IconsaxPlusLinear.play),
                                  label: const Text('Open'),
                                )
                              else if (isAdmin)
                                FilledButton.icon(
                                  onPressed: _importing ? null : _handleImport,
                                  icon: _importing
                                      ? const SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(strokeWidth: 2),
                                        )
                                      : const Icon(IconsaxPlusLinear.import),
                                  label: Text(_importing ? 'Importing...' : 'Import'),
                                )
                              else
                                FilledButton.icon(
                                  onPressed: _requesting ? null : _handleRequest,
                                  icon: _requesting
                                      ? const SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(strokeWidth: 2),
                                        )
                                      : const Icon(IconsaxPlusLinear.add),
                                  label: Text(_requesting ? 'Requesting...' : 'Request'),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

// Reviews Carousel Widget with Navigation
class _ReviewsCarousel extends StatefulWidget {
  final List<TMDBReview> reviews;
  final ThemeData theme;

  const _ReviewsCarousel({
    required this.reviews,
    required this.theme,
  });

  @override
  State<_ReviewsCarousel> createState() => _ReviewsCarouselState();
}

class _ReviewsCarouselState extends State<_ReviewsCarousel> {
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
              return Container(
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
      ],
    );
  }
}

