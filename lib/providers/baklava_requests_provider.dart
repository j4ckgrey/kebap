import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:async';
import 'package:collection/collection.dart';
import 'package:kebap/util/notification_helper.dart';

import 'package:kebap/models/media_request_model.dart';
import 'package:kebap/providers/baklava_api_service.dart';
import 'package:kebap/providers/user_provider.dart';
import 'package:kebap/providers/effective_baklava_config_provider.dart';

part 'baklava_requests_provider.g.dart';

@riverpod
BaklavaService baklavaService(Ref ref) {
  return BaklavaService(ref);
}

@riverpod
class BaklavaRequests extends _$BaklavaRequests {
  Timer? _timer;

  @override
  RequestsState build() {
    // Load requests on initialization
    loadRequests();
    
    // Start polling every minute
    _timer = Timer.periodic(const Duration(minutes: 1), (_) => loadRequests(notify: true));
    
    ref.onDispose(() {
      _timer?.cancel();
    });
    
    return const RequestsState();
  }

  /// Load all media requests
  Future<void> loadRequests({bool notify = false}) async {
    if (!notify) state = state.copyWith(loading: true);

    try {
      final service = ref.read(baklavaServiceProvider);
      final response = await service.fetchRequests();

      if (response.isSuccessful && response.body != null) {
        final newRequests = response.body!;
        
        if (notify) {
          _checkNotifications(state.requests, newRequests);
        }

        state = state.copyWith(
          requests: newRequests,
          loading: false,
          error: null,
        );
      } else {
        // Baklava unavailable (404) - show empty list instead of error
        state = state.copyWith(
          requests: [],
          loading: false,
          error: null,
        );
      }
    } catch (e) {
      // Baklava plugin not installed - show empty list
      state = state.copyWith(
        requests: [],
        loading: false,
        error: null,
      );
    }
  }

  void _checkNotifications(List<MediaRequest> oldList, List<MediaRequest> newList) {
    final user = ref.read(userProvider);
    if (user == null) return;
    final isAdmin = user.policy?.isAdministrator ?? false;

    // Check for new requests (Admin only)
    if (isAdmin) {
      final oldIds = oldList.map((r) => r.id).toSet();
      final newPending = newList.where((r) => r.status == 'pending' && !oldIds.contains(r.id));
      for (var req in newPending) {
        // Don't notify if I created it myself
        if (req.username != user.name) {
          NotificationHelper().showNotification(
            id: req.id.hashCode,
            title: 'New Request',
            body: '${req.username} requested ${req.title}',
          );
        }
      }
    }

    // Check for status changes (My requests)
    final myOldRequests = oldList.where((r) => r.username == user.name);
    for (var oldReq in myOldRequests) {
      final newReq = newList.firstWhereOrNull((r) => r.id == oldReq.id);
      if (newReq != null && newReq.status != oldReq.status) {
        if (newReq.status == 'approved') {
          NotificationHelper().showNotification(
            id: newReq.id.hashCode,
            title: 'Request Approved',
            body: '${newReq.title} has been approved!',
          );
        } else if (newReq.status == 'rejected') {
          NotificationHelper().showNotification(
            id: newReq.id.hashCode,
            title: 'Request Rejected',
            body: '${newReq.title} was rejected.',
          );
        }
      }
    }
  }

  /// Create a new media request
  Future<bool> createRequest({
    required String title,
    String? year,
    String? img,
    String? imdbId,
    String? tmdbId,
    String? jellyfinId,
    required String itemType,
    String? tmdbMediaType,
  }) async {
    try {
      final user = ref.read(userProvider);
      if (user == null) {
        state = state.copyWith(error: 'User not logged in');
        return false;
      }

      // Respect server/local configuration: if non-admin requests are disabled
      // and the current user is not an admin, block client-side creation.
      final config = await ref.read(effectiveBaklavaConfigProvider.future);
      final isAdmin = user.policy?.isAdministrator ?? false;
      if (config.disableNonAdminRequests == true && !isAdmin) {
        state = state.copyWith(error: 'Requests are disabled for non-admin users');
        return false;
      }

      final request = MediaRequest(
        id: '', // Server will generate
        username: user.name,
        userId: user.id,
        timestamp: DateTime.now().millisecondsSinceEpoch,
        title: title,
        year: year,
        img: img,
        imdbId: imdbId,
        tmdbId: tmdbId,
        jellyfinId: jellyfinId,
        itemType: itemType,
        tmdbMediaType: tmdbMediaType,
        status: 'pending',
      );

      final service = ref.read(baklavaServiceProvider);
      final response = await service.createRequest(request);

      if (response.isSuccessful && response.body != null) {
        // Add to local state
        state = state.copyWith(
          requests: [...state.requests, response.body!],
        );
        return true;
      } else {
        final errorMsg = 'Failed to create request: status=${response.statusCode}, body=${response.body}, error=${response.error}';
        print('DEBUG createRequest failed: $errorMsg');
        state = state.copyWith(error: errorMsg);
        return false;
      }
    } catch (e, stackTrace) {
      print('DEBUG createRequest exception: $e');
      print('DEBUG Stack trace: $stackTrace');
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// Update request status (approve/reject)
  Future<bool> updateRequestStatus({
    required String requestId,
    required String status,
  }) async {
    try {
      final user = ref.read(userProvider);
      if (user == null) {
        state = state.copyWith(error: 'User not logged in');
        return false;
      }

      final service = ref.read(baklavaServiceProvider);
      final response = await service.updateRequestStatus(
        requestId: requestId,
        status: status,
        approvedBy: user.name,
      );

      if (response.isSuccessful) {
        // Reload requests to get updated state
        await loadRequests();
        return true;
      } else {
        state = state.copyWith(error: 'Failed to update request');
        return false;
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// Delete a request
  Future<bool> deleteRequest(String requestId) async {
    try {
      final service = ref.read(baklavaServiceProvider);
      final response = await service.deleteRequest(requestId);

      if (response.isSuccessful) {
        // Remove from local state
        final updatedRequests =
            state.requests.where((r) => r.id != requestId).toList();
        state = state.copyWith(requests: updatedRequests);
        return true;
      } else {
        state = state.copyWith(error: 'Failed to delete request');
        return false;
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// Approve a request (admin only)
  Future<bool> approveRequest(String requestId, String approvedBy) async {
    return updateRequestStatus(requestId: requestId, status: 'approved');
  }

  /// Reject a request (admin only)
  Future<bool> rejectRequest(String requestId) async {
    return updateRequestStatus(requestId: requestId, status: 'rejected');
  }

  /// Get filtered requests based on user role
  List<MediaRequest> getFilteredRequests() {
    final user = ref.read(userProvider);
    if (user == null) return [];

    final isAdmin = user.policy?.isAdministrator ?? false;
    return state.filterByUser(user.name, isAdmin: isAdmin);
  }

  /// Get pending count for badge
  int getPendingCount() {
    final user = ref.read(userProvider);
    if (user == null) return 0;

    final isAdmin = user.policy?.isAdministrator ?? false;
    final filtered = state.filterByUser(user.name, isAdmin: isAdmin);

    return filtered.where((r) => r.status == 'pending').length;
  }
}
