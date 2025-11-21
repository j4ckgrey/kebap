import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import 'package:fladder/models/media_request_model.dart';
import 'package:fladder/models/tmdb_metadata_model.dart';
import 'package:fladder/providers/baklava_metadata_provider.dart';
import 'package:fladder/providers/baklava_requests_provider.dart';
import 'package:fladder/providers/user_provider.dart';
import 'package:fladder/routes/auto_router.gr.dart';
import 'package:fladder/screens/shared/fladder_snackbar.dart';
import 'package:fladder/util/adaptive_layout/adaptive_layout.dart';
import 'package:fladder/widgets/shared/status_card.dart';

class RequestDetailModal extends ConsumerStatefulWidget {
  const RequestDetailModal({
    super.key,
    required this.request,
  });

  final MediaRequest request;

  @override
  ConsumerState<RequestDetailModal> createState() => _RequestDetailModalState();
}

class _RequestDetailModalState extends ConsumerState<RequestDetailModal> {
  bool _isApproving = false;
  bool _isRejecting = false;
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
    
    // Fetch TMDB metadata using the request's IDs
    await metadataNotifier.fetchTMDBMetadata(
      tmdbId: widget.request.tmdbId,
      imdbId: widget.request.imdbId,
      itemType: widget.request.itemType ?? 'movie',
      title: widget.request.title,
      year: widget.request.year != null ? int.tryParse(widget.request.year!) : null,
    );

    // Fetch external IDs if we have TMDB ID but no IMDB ID
    if (widget.request.imdbId == null && widget.request.tmdbId != null) {
      await metadataNotifier.fetchExternalIds(
        widget.request.tmdbId!,
        widget.request.tmdbMediaType ?? 'movie',
      );
    }

    // Check library status
    await metadataNotifier.checkLibraryStatus(
      widget.request.imdbId,
      widget.request.tmdbId,
      widget.request.itemType ?? 'movie',
    );
  }

  Future<void> _handleApprove() async {
    setState(() => _isApproving = true);
    try {
      final user = ref.read(userProvider);
      await ref.read(baklavaRequestsProvider.notifier).approveRequest(
        widget.request.id,
        user?.name ?? 'admin',
      );
      if (mounted) {
        Navigator.of(context).pop();
        fladderSnackbar(context, title: 'Request approved');
      }
    } catch (e) {
      if (mounted) {
        fladderSnackbar(context, title: 'Failed to approve request: $e');
      }
    } finally {
      if (mounted) setState(() => _isApproving = false);
    }
  }

  Future<void> _handleReject() async {
    setState(() => _isRejecting = true);
    try {
      await ref.read(baklavaRequestsProvider.notifier).rejectRequest(widget.request.id);
      if (mounted) {
        Navigator.of(context).pop();
        fladderSnackbar(context, title: 'Request rejected');
      }
    } catch (e) {
      if (mounted) {
        fladderSnackbar(context, title: 'Failed to reject request: $e');
      }
    } finally {
      if (mounted) setState(() => _isRejecting = false);
    }
  }

  void _handleOpenInJellyfin() {
    if (widget.request.jellyfinId != null) {
      context.router.push(DetailsRoute(id: widget.request.jellyfinId!));
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = ref.watch(userProvider);
    final isAdmin = user?.policy?.isAdministrator ?? false;
    final metadataState = ref.watch(baklavaMetadataProvider);
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
                  // Left: Poster
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
                              : widget.request.img ?? '',
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
                                  metadata?.title ?? metadata?.name ?? widget.request.title,
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
                              if (widget.request.year != null)
                                Text(
                                  widget.request.year!,
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
                                    const Icon(
                                      Icons.star,
                                      size: 16,
                                      color: Colors.amber,
                                    ),
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

                          // Status and Type badges
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              StatusCard(
                                color: _getStatusColor(widget.request.status),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        _getStatusIcon(widget.request.status),
                                        size: 16,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        widget.request.status.toUpperCase(),
                                        style: theme.textTheme.labelMedium?.copyWith(
                                          color: _getStatusColor(widget.request.status),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              StatusCard(
                                color: theme.colorScheme.primary,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        widget.request.itemType == 'movie'
                                            ? IconsaxPlusLinear.video
                                            : IconsaxPlusLinear.video_play,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        (widget.request.itemType ?? 'unknown').toUpperCase(),
                                        style: theme.textTheme.labelMedium?.copyWith(
                                          color: theme.colorScheme.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (isAdmin && widget.request.username != null)
                                StatusCard(
                                  color: Colors.blue,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          IconsaxPlusLinear.user,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          widget.request.username!,
                                          style: theme.textTheme.labelMedium?.copyWith(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // Overview/Plot
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
                              // Open in Jellyfin (if approved and has ID)
                              if (widget.request.status == 'approved' && widget.request.jellyfinId != null)
                                FilledButton.icon(
                                  onPressed: _handleOpenInJellyfin,
                                  icon: const Icon(IconsaxPlusLinear.play),
                                  label: const Text('Open'),
                                )
                              // Admin actions (pending requests only)
                              else if (isAdmin && widget.request.status == 'pending') ...[
                                OutlinedButton.icon(
                                  onPressed: _isRejecting ? null : _handleReject,
                                  icon: _isRejecting
                                      ? const SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(strokeWidth: 2),
                                        )
                                      : const Icon(IconsaxPlusLinear.close_circle),
                                  label: Text(_isRejecting ? 'Rejecting...' : 'Reject'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: theme.colorScheme.error,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                FilledButton.icon(
                                  onPressed: _isApproving ? null : _handleApprove,
                                  icon: _isApproving
                                      ? const SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(strokeWidth: 2),
                                        )
                                      : const Icon(IconsaxPlusLinear.tick_circle),
                                  label: Text(_isApproving ? 'Approving...' : 'Approve'),
                                ),
                              ],
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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return IconsaxPlusLinear.clock;
      case 'approved':
        return IconsaxPlusLinear.tick_circle;
      case 'rejected':
        return IconsaxPlusLinear.close_circle;
      default:
        return IconsaxPlusLinear.info_circle;
    }
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

