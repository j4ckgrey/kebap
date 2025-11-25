import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import 'package:kebap/models/media_request_model.dart';
import 'package:kebap/providers/baklava_requests_provider.dart';
import 'package:kebap/providers/user_provider.dart';
import 'package:kebap/screens/shared/nested_scaffold.dart';
import 'package:kebap/theme.dart';

import 'package:kebap/widgets/requests/request_card.dart';
import 'package:kebap/widgets/requests/request_detail_modal.dart';
import 'package:kebap/widgets/shared/modal_bottom_sheet.dart';
import 'package:kebap/widgets/shared/status_card.dart';
import 'package:kebap/models/items/images_models.dart';
import 'package:kebap/widgets/navigation_scaffold/components/background_image.dart';

import 'package:kebap/widgets/navigation_scaffold/components/navigation_constants.dart';

@RoutePage()
class RequestsScreen extends ConsumerStatefulWidget {
  const RequestsScreen({super.key});

  @override
  ConsumerState<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends ConsumerState<RequestsScreen> {
  final FocusScopeNode _contentFocusNode = FocusScopeNode();

  @override
  void initState() {
    super.initState();
    // Load requests when screen opens
    Future.microtask(() {
      ref.read(baklavaRequestsProvider.notifier).loadRequests();
    });
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      registerFirstContentNode(_contentFocusNode);
    });
  }

  @override
  void dispose() {
    _contentFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final requestsState = ref.watch(baklavaRequestsProvider);
    final user = ref.watch(userProvider);
    final isAdmin = user?.policy?.isAdministrator ?? false;

    // Filter requests based on user role
    final filteredRequests = requestsState.filterByUser(user?.name ?? '', isAdmin: isAdmin);

    // Movies: exclude approved/rejected for both admin and non-admin
    final movies = isAdmin
        ? requestsState.movies.where((r) => r.status != 'approved' && r.status != 'rejected').toList()
        : filteredRequests.where((r) => r.itemType?.toLowerCase() == 'movie' && r.status != 'approved' && r.status != 'rejected').toList();

    // Series: exclude approved/rejected for both admin and non-admin
    final series = isAdmin
        ? requestsState.series.where((r) => r.status != 'approved' && r.status != 'rejected').toList()
        : filteredRequests.where((r) => (r.itemType?.toLowerCase() == 'series' || r.itemType?.toLowerCase() == 'tv') && r.status != 'approved' && r.status != 'rejected').toList();

    final pending = isAdmin
        ? requestsState.pending
        : filteredRequests.where((r) => r.status == 'pending').toList();

    final approved = isAdmin
        ? requestsState.requests
            .where((r) => r.status == 'approved' && r.username != null && r.username == user?.name)
            .toList()
        : filteredRequests.where((r) => r.status == 'approved').toList();

    final rejected = isAdmin
        ? requestsState.requests
            .where((r) => r.status == 'rejected' && r.username != null && r.username == user?.name)
            .toList()
        : filteredRequests.where((r) => r.status == 'rejected').toList();

    return NestedScaffold(
      background: BackgroundImage(
        images: filteredRequests
            .map((r) => r.img != null 
                ? ImagesData(primary: ImageData(path: r.img!, hash: 'LEHV6nWB2yk8pyo0adR*.7kCMdnj'))
                : null)
            .nonNulls
            .toList(),
      ),
      body: FocusScope(
        node: _contentFocusNode,
        child: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text('Media Requests'),
            automaticallyImplyLeading: false,
            floating: true,
            pinned: false,
            primary: false,
            backgroundColor: Colors.transparent,
          ),
          requestsState.loading
              ? const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
              : requestsState.error != null
                  ? SliverFillRemaining(
                      child: Center(
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
                      ),
                    )
                  : SliverPadding(
                      padding: const EdgeInsets.all(16),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          // Movie Requests
                          _RequestSection(
                            title: 'Movie Requests',
                            titleColor: theme.colorScheme.primary,
                            icon: IconsaxPlusLinear.video,
                            requests: movies,
                            isAdminView: isAdmin,
                          ),

                          const SizedBox(height: 24),

                          // Series Requests
                          _RequestSection(
                            title: 'Series Requests',
                            titleColor: theme.colorScheme.primary,
                            icon: IconsaxPlusLinear.video_play,
                            requests: series,
                            isAdminView: isAdmin,
                          ),

                          const SizedBox(height: 24),

                          // Approved
                          _RequestSection(
                            title: 'Approved',
                            titleColor: Colors.green,
                            icon: IconsaxPlusLinear.tick_circle,
                            requests: approved,
                            isAdminView: isAdmin,
                          ),

                          const SizedBox(height: 24),

                          // Rejected
                          _RequestSection(
                            title: 'Rejected',
                            titleColor: Colors.red,
                            icon: IconsaxPlusLinear.close_circle,
                            requests: rejected,
                            isAdminView: isAdmin,
                          ),
                        ]),
                      ),
                    ),
        ],
      ),
    ),
    );
  }
}

class _RequestSection extends ConsumerWidget {
  const _RequestSection({
    required this.title,
    required this.titleColor,
    required this.icon,
    required this.requests,
    required this.isAdminView,
  });

  final String title;
  final Color titleColor;
  final IconData icon;
  final List<MediaRequest> requests;
  final bool isAdminView;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            StatusCard(
              color: titleColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(icon, size: 20),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                color: titleColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            StatusCard(
              color: titleColor,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(
                  requests.length.toString(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: titleColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
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
    showBottomSheetPill(
      context: context,
      content: (context, scrollController) => RequestDetailModal(request: request),
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
        borderRadius: KebapTheme.smallShape.borderRadius,
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
