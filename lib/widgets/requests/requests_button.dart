import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fladder/providers/baklava_requests_provider.dart';
import 'package:fladder/providers/user_provider.dart';

class RequestsButton extends ConsumerWidget {
  const RequestsButton({
    super.key,
    this.onPressed,
  });

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final requestsState = ref.watch(baklavaRequestsProvider);
    
    if (user == null) {
      return IconButton(
        icon: const Icon(Icons.list_alt),
        tooltip: 'Media Requests',
        onPressed: onPressed,
      );
    }

    final isAdmin = user.policy?.isAdministrator ?? false;
    final filtered = requestsState.filterByUser(user.name, isAdmin: isAdmin);
    final pendingCount = filtered.where((r) => r.status == 'pending').length;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          icon: const Icon(Icons.list_alt),
          tooltip: 'Media Requests',
          onPressed: onPressed,
        ),
        if (pendingCount > 0)
          Positioned(
            top: 4,
            right: 4,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.error,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(
                minWidth: 18,
                minHeight: 18,
              ),
              child: Center(
                child: Text(
                  pendingCount > 99 ? '99+' : pendingCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
