import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import 'package:flutter/services.dart';

import 'package:kebap/models/item_base_model.dart';
import 'package:kebap/jellyfin/jellyfin_open_api.swagger.dart';
import 'package:kebap/providers/api_provider.dart';
import 'package:kebap/models/tmdb_metadata_model.dart';
import 'package:kebap/providers/baklava_metadata_provider.dart';
import 'package:kebap/providers/baklava_requests_provider.dart';
import 'package:kebap/providers/effective_baklava_config_provider.dart';
import 'package:kebap/providers/user_provider.dart';
import 'package:kebap/screens/shared/kebap_snackbar.dart';
import 'package:kebap/util/focus_provider.dart';
import 'package:kebap/widgets/shared/item_details_reviews_carousel.dart';

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
    if (!mounted) return;
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
      var effectiveTmdbId = tmdbId ?? metadata.id.toString();
      var effectiveImdbId = imdbId ?? metadata.imdbId;

      // Fetch external IDs if needed
      if (effectiveImdbId == null) {
        final externalIds = await metadataNotifier.fetchExternalIds(
          effectiveTmdbId,
          itemType == 'series' ? 'tv' : 'movie',
        );
        // Update IMDB ID if found
        if (externalIds?.imdbId != null) {
          effectiveImdbId = externalIds!.imdbId;
        }
      }

      // Check library status (includes request status check)
      await metadataNotifier.checkLibraryStatus(effectiveImdbId, effectiveTmdbId, itemType);
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

  Future<bool> _performImport() async {
    final metadataState = ref.read(baklavaMetadataProvider);
    final imdbId = metadataState.metadata?.imdbId ?? _extractIMDBId(widget.item);
    final tmdbId = metadataState.metadata?.id.toString() ?? _extractTMDBId(widget.item);

    if (imdbId == null && tmdbId == null) {
      if (mounted) {
        kebapSnackbar(context, title: 'Cannot import: No IMDB ID found');
      }
      return false;
    }

    final itemType = _detectItemType(widget.item);
    
    try {
      // 1. Search for the item by title to trigger Stremio search and caching
      final api = ref.read(jellyApiProvider).api;
      final user = ref.read(userProvider);
      final userId = user?.id;
      if (userId == null) throw Exception('User not found');

      final searchResults = await api.usersUserIdItemsGet(
        userId: userId,
        searchTerm: widget.item.name,
        includeItemTypes: [
          BaseItemKind.values.firstWhere(
            (e) => e.value?.toLowerCase() == itemType.toLowerCase(),
            orElse: () => BaseItemKind.movie,
          )
        ],
        recursive: true,
        limit: 20,
        fields: [ItemFields.providerids],
      );

      if (!mounted) return false;

      // 2. Find the matching item in the search results
      String? stremioItemId;
      if (searchResults.body != null) {
        for (final item in searchResults.body!.items ?? []) {
          final providers = item.providerIds;
          if (providers == null) continue;

          if (imdbId != null && providers['Imdb'] == imdbId) {
            stremioItemId = item.id;
            break;
          }
          if (tmdbId != null && providers['Tmdb'] == tmdbId) {
            stremioItemId = item.id;
            break;
          }
        }
      }

      if (stremioItemId != null) {
          // 3. Trigger import via API
          try {
            await api.itemsItemIdGet(
              userId: userId,
              itemId: stremioItemId,
            );
            
            if (mounted) {
              // Refresh library status
              ref.read(baklavaMetadataProvider.notifier).setLibraryStatus(stremioItemId);
              return true;
            }
          } catch (e) {
            print('DEBUG: Background import failed: $e');
          }
      } else {
        // Fallback: Poll
        String? newItemId;
        for (var i = 0; i < 5; i++) {
          await Future.delayed(const Duration(seconds: 1));
          if (!mounted) return false;
          
          newItemId = await ref.read(baklavaMetadataProvider.notifier).checkLibraryStatus(imdbId, tmdbId, itemType);
          if (newItemId != null) return true;
        }
      }
    } catch (e) {
      print('DEBUG: Search-based import failed: $e');
    }
    
    return false;
  }

  Future<void> _handleImport() async {
    setState(() => _importing = true);
    try {
      await _performImport();
    } finally {
      if (mounted) setState(() => _importing = false);
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
        kebapSnackbar(context, title: 'Request created successfully');
        Navigator.of(context).pop();
      } else {
        kebapSnackbar(context, title: 'Failed to create request');
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
    final effectiveConfigAsync = ref.watch(effectiveBaklavaConfigProvider);
    final disableNonAdminRequests = effectiveConfigAsync.maybeWhen(
      data: (cfg) => cfg.disableNonAdminRequests == true,
      orElse: () => false,
    );

    print('DEBUG: SearchResultModal build - inLibrary: ${metadataState.inLibrary}, existingRequestId: ${metadataState.existingRequestId}, isAdmin: $isAdmin');

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.backspace): () => Navigator.of(context).pop(),
        const SingleActivator(LogicalKeyboardKey.escape): () => Navigator.of(context).pop(),
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;

        Widget content = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with title
            Text(
              metadata?.title ?? metadata?.name ?? widget.item.name,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
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
                      if (metadataState.jellyfinItemId != null) {
                        final item = widget.item.copyWith(id: metadataState.jellyfinItemId);
                        item.navigateTo(context, ref: ref);
                      } else {
                        widget.item.navigateTo(context, ref: ref);
                      }
                    },
                    icon: const Icon(IconsaxPlusLinear.play),
                    label: const Text('Open'),
                  )
                else if (metadataState.existingRequestId != null)
                  FilledButton.icon(
                    onPressed: null, // TODO: Open request details
                    icon: const Icon(IconsaxPlusLinear.clock),
                    label: const Text('Requested'),
                    style: FilledButton.styleFrom(
                      backgroundColor: theme.colorScheme.tertiaryContainer,
                      foregroundColor: theme.colorScheme.onTertiaryContainer,
                    ),
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
                  Builder(builder: (context) {
                    final isConfigLoading = effectiveConfigAsync is AsyncLoading;
                    final isAdminUser = isAdmin;

                    // If request exists and user is admin, show Approve/Reject
                    if (metadataState.existingRequestId != null && isAdminUser) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          OutlinedButton.icon(
                            onPressed: _requesting ? null : () async {
                              setState(() => _requesting = true);
                              try {
                                await ref.read(baklavaRequestsProvider.notifier).rejectRequest(metadataState.existingRequestId!);
                                if (context.mounted) {
                                  kebapSnackbar(context, title: 'Request rejected');
                                  Navigator.of(context).pop();
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  kebapSnackbar(context, title: 'Failed to reject request');
                                }
                              } finally {
                                if (mounted) setState(() => _requesting = false);
                              }
                            },
                            icon: _requesting
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : const Icon(IconsaxPlusLinear.close_circle),
                            label: const Text('Reject'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: theme.colorScheme.error,
                            ),
                          ),
                          const SizedBox(width: 8),
                          FilledButton.icon(
                            onPressed: _importing ? null : () async {
                              setState(() => _importing = true);
                              try {
                                // 1. Trigger Import using robust method
                                final success = await _performImport();
                                
                                if (success) {
                                  // 2. Approve Request
                                  final user = ref.read(userProvider);
                                  await ref.read(baklavaRequestsProvider.notifier).approveRequest(
                                    metadataState.existingRequestId!,
                                    user?.name ?? 'admin',
                                  );

                                  if (context.mounted) {
                                    kebapSnackbar(context, title: 'Request approved');
                                  }
                                } else {
                                  if (context.mounted) {
                                    kebapSnackbar(context, title: 'Import failed, request not approved');
                                  }
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  kebapSnackbar(context, title: 'Failed to approve request');
                                }
                              } finally {
                                if (mounted) setState(() => _importing = false);
                              }
                            },
                            icon: _importing
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : const Icon(IconsaxPlusLinear.tick_circle),
                            label: const Text('Approve'),
                          ),
                        ],
                      );
                    }


                    // If no request exists but user is admin, show Import
                    if (isAdminUser) {
                      return FilledButton.icon(
                        onPressed: _importing ? null : _handleImport,
                        icon: _importing
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(IconsaxPlusLinear.import),
                        label: Text(_importing ? 'Importing...' : 'Import'),
                      );
                    }

                    final allowRequest = !disableNonAdminRequests || isAdminUser;

                    // Show a disabled button while config is loading, or a disabled
                    // button with explanatory tooltip if requests are blocked.
                    if (isConfigLoading) {
                      return FilledButton.icon(
                        onPressed: null,
                        icon: const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        label: const Text('Loading...'),
                      );
                    }

                    if (!allowRequest) {
                      return Tooltip(
                        message: 'Requests are disabled for non-admin users',
                        child: FilledButton.icon(
                          onPressed: null,
                          icon: const Icon(IconsaxPlusLinear.add),
                          label: const Text('Requests disabled'),
                        ),
                      );
                    }

                    return FilledButton.icon(
                      onPressed: _requesting ? null : _handleRequest,
                      icon: _requesting
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(IconsaxPlusLinear.add),
                      label: Text(_requesting ? 'Requesting...' : 'Request'),
                    );
                  }),
              ],
            ),
          ],
        );

        return Material(
            color: theme.colorScheme.surface,
            clipBehavior: Clip.antiAlias,
            child: Container(
              height: 700,
              constraints: const BoxConstraints(maxWidth: 1100),
          child: metadataState.loading
                ? const Center(child: CircularProgressIndicator())
                : isMobile
                    ? SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Top: Poster
                            Stack(
                              children: [
                                Container(
                                  height: 200,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                    image: DecorationImage(
                                      image: CachedNetworkImageProvider(
                                        metadata?.posterPath != null
                                            ? 'https://image.tmdb.org/t/p/w500${metadata!.posterPath}'
                                            : widget.item.images?.primary?.path ?? '',
                                      ),
                                      fit: BoxFit.cover,
                                      alignment: Alignment.topCenter,
                                    ),
                                  ),
                                ),
                                if (metadataState.existingRequestId != null) ...[
                                  Positioned(
                                    top: 8,
                                    left: 8,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withValues(alpha: 0.7),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        metadataState.requestUsername ?? 'Unknown',
                                        style: theme.textTheme.bodySmall?.copyWith(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: metadataState.requestStatus?.toLowerCase() == 'approved'
                                            ? Colors.green.withValues(alpha: 0.8)
                                            : metadataState.requestStatus?.toLowerCase() == 'rejected'
                                                ? Colors.red.withValues(alpha: 0.8)
                                                : Colors.orange.withValues(alpha: 0.8),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        metadataState.requestStatus ?? 'Pending',
                                        style: theme.textTheme.bodySmall?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: content,
                            ),
                          ],
                        ),
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Left: Poster - show item poster immediately, fallback to TMDB
                          Expanded(
                            flex: 1,
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
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
                                if (metadataState.existingRequestId != null) ...[
                                  Positioned(
                                    top: 8,
                                    left: 8,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withValues(alpha: 0.7),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        metadataState.requestUsername ?? 'Unknown',
                                        style: theme.textTheme.bodySmall?.copyWith(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: metadataState.requestStatus?.toLowerCase() == 'approved'
                                            ? Colors.green.withValues(alpha: 0.8)
                                            : metadataState.requestStatus?.toLowerCase() == 'rejected'
                                                ? Colors.red.withValues(alpha: 0.8)
                                                : Colors.orange.withValues(alpha: 0.8),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        metadataState.requestStatus ?? 'Pending',
                                        style: theme.textTheme.bodySmall?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),

                          // Right: Content
                          Expanded(
                            flex: 2,
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.all(24),
                              child: content,
                            ),
                          ),
                      ],
                    ),
      ),
    );
  },
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reviews',
          style: widget.theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
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
                onTap: () {
                  showDialog(
                    context: context,
                    barrierDismissible: true,
                    barrierColor: Colors.black.withValues(alpha: 0.7),
                    builder: (context) => ReviewModal(review: review, theme: widget.theme),
                  );
                },
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
      ],
    );
  }
}
