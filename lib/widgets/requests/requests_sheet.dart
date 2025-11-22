import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kebap/models/media_request_model.dart';
import 'package:kebap/providers/baklava_requests_provider.dart';
import 'package:kebap/providers/user_provider.dart';
import 'package:kebap/widgets/requests/request_card.dart';

class RequestsSheet extends ConsumerStatefulWidget {
  const RequestsSheet({super.key});

  @override
  ConsumerState<RequestsSheet> createState() => _RequestsSheetState();
}

class _RequestsSheetState extends ConsumerState<RequestsSheet> {
  @override
  void initState() {
    super.initState();
    // Load requests when sheet opens
    Future.microtask(() {
      ref.read(baklavaRequestsProvider.notifier).loadRequests();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final requestsState = ref.watch(baklavaRequestsProvider);
    final user = ref.watch(userProvider);
    final isAdmin = user?.policy?.isAdministrator ?? false;

    // Filter requests based on user role
    final filteredRequests = isAdmin
        ? requestsState.requests
        : requestsState.requests
            .where((r) => r.username == user?.name)
            .toList();

    // Categorize requests
    final movies = filteredRequests
        .where((r) =>
            r.itemType == 'movie' &&
            r.status != 'approved' &&
            r.status != 'rejected')
        .toList();

    final series = filteredRequests
        .where((r) =>
            r.itemType == 'series' &&
            r.status != 'approved' &&
            r.status != 'rejected')
        .toList();

    final approved = isAdmin
        ? requestsState.requests
            .where((r) => r.status == 'approved' && r.username == user?.name)
            .toList()
        : filteredRequests.where((r) => r.status == 'approved').toList();

    final rejected = isAdmin
        ? requestsState.requests
            .where((r) => r.status == 'rejected' && r.username == user?.name)
            .toList()
        : filteredRequests.where((r) => r.status == 'rejected').toList();

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: theme.colorScheme.outlineVariant,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Media Requests',
                  style: theme.textTheme.titleLarge,
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: requestsState.loading
                ? const Center(child: CircularProgressIndicator())
                : requestsState.error != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 48,
                              color: theme.colorScheme.error,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Error loading requests',
                              style: theme.textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              requestsState.error!,
                              style: theme.textTheme.bodySmall,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                ref
                                    .read(baklavaRequestsProvider.notifier)
                                    .loadRequests();
                              },
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    : ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          // Movie Requests
                          _RequestSection(
                            title: 'Movie Requests',
                            titleColor: theme.colorScheme.primary,
                            requests: movies,
                            isAdminView: isAdmin,
                          ),

                          const SizedBox(height: 24),

                          // Series Requests
                          _RequestSection(
                            title: 'Series Requests',
                            titleColor: theme.colorScheme.primary,
                            requests: series,
                            isAdminView: isAdmin,
                          ),

                          const SizedBox(height: 24),

                          // Approved
                          _RequestSection(
                            title: 'Approved',
                            titleColor: Colors.green,
                            requests: approved,
                            isAdminView: isAdmin,
                          ),

                          const SizedBox(height: 24),

                          // Rejected
                          _RequestSection(
                            title: 'Rejected',
                            titleColor: Colors.red,
                            requests: rejected,
                            isAdminView: isAdmin,
                          ),
                        ],
                      ),
          ),
        ],
      ),
    );
  }
}

class _RequestSection extends ConsumerWidget {
  const _RequestSection({
    required this.title,
    required this.titleColor,
    required this.requests,
    required this.isAdminView,
  });

  final String title;
  final Color titleColor;
  final List<MediaRequest> requests;
  final bool isAdminView;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            color: titleColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        requests.isEmpty
            ? _EmptyPlaceholder(theme: theme)
            : SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: requests.length,
                  itemBuilder: (context, index) {
                    final request = requests[index];
                    return RequestCard(
                      request: request,
                      isAdminView: isAdminView,
                      onTap: () {
                        _showRequestDetail(context, ref, request);
                      },
                      onDelete: request.status == 'rejected' && isAdminView
                          ? () async {
                              final confirmed = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Delete Request'),
                                  content: Text(
                                      'Delete rejected request for "${request.title}"?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                ),
                              );

                              if (confirmed == true) {
                                await ref
                                    .read(baklavaRequestsProvider.notifier)
                                    .deleteRequest(request.id);
                              }
                            }
                          : null,
                    );
                  },
                ),
              ),
      ],
    );
  }

  void _showRequestDetail(
      BuildContext context, WidgetRef ref, MediaRequest request) {
    // TODO: Implement request detail modal
    // For now, show a simple dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(request.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (request.year != null) Text('Year: ${request.year}'),
            Text('Type: ${request.itemType}'),
            Text('Status: ${request.status}'),
            if (request.username?.isNotEmpty ?? false)
              Text('Requested by: ${request.username}'),
            if (request.imdbId != null) Text('IMDB: ${request.imdbId}'),
            if (request.tmdbId != null) Text('TMDB: ${request.tmdbId}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class _EmptyPlaceholder extends StatelessWidget {
  const _EmptyPlaceholder({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.outlineVariant,
          width: 2,
          strokeAlign: BorderSide.strokeAlignInside,
        ),
      ),
      child: Center(
        child: Icon(
          Icons.inbox_outlined,
          size: 40,
          color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}
