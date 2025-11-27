import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kebap/util/focus_provider.dart';

import 'package:kebap/models/media_request_model.dart';

class RequestCard extends ConsumerWidget {
  const RequestCard({
    super.key,
    required this.request,
    required this.isAdminView,
    this.onTap,
    this.onDelete,
    this.autofocus = false,
  });

  final MediaRequest request;
  final bool isAdminView;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final bool autofocus;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Container(
      width: 120,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Poster with badges
          SizedBox(
            height: 180,
            width: 120,
            child: Stack(
              children: [
                // Poster image
                FocusButton(
                  onTap: onTap,
                  autoFocus: autofocus,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: request.img != null
                          ? DecorationImage(
                              image: NetworkImage(request.img!),
                              fit: BoxFit.cover,
                            )
                          : null,
                      color: theme.colorScheme.surfaceContainerHighest,
                    ),
                    child: request.img == null
                        ? Center(
                            child: Icon(
                              Icons.movie,
                              size: 48,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          )
                        : null,
                  ),
                ),
                
                // Status badge in top-right
                Positioned(
                  top: 4,
                  right: 4,
                  child: _StatusBadge(status: request.status),
                ),
                
                // User badge in top-left (admin only)
                if (isAdminView && (request.username?.isNotEmpty ?? false))
                  Positioned(
                    top: 4,
                    left: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        request.username!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                
                // Delete button for rejected requests (admin only)
                if (request.status == 'rejected' && isAdminView && onDelete != null)
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: onDelete,
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.error.withValues(alpha: 0.9),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 16,
                            color: Colors.white,
                          ),
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

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color backgroundColor;
    String label;

    switch (status.toLowerCase()) {
      case 'pending':
        backgroundColor = Colors.orange.withValues(alpha: 0.9);
        label = 'Pending';
        break;
      case 'approved':
        backgroundColor = Colors.green.withValues(alpha: 0.95);
        label = 'Approved';
        break;
      case 'rejected':
        backgroundColor = Colors.red.withValues(alpha: 0.95);
        label = 'Rejected';
        break;
      default:
        backgroundColor = theme.colorScheme.surfaceContainerHighest;
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
