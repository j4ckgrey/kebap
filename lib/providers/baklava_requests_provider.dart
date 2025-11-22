import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:kebap/models/media_request_model.dart';
import 'package:kebap/providers/baklava_api_service.dart';
import 'package:kebap/providers/user_provider.dart';

part 'baklava_requests_provider.g.dart';

@riverpod
BaklavaService baklavaService(Ref ref) {
  return BaklavaService(ref);
}

@riverpod
class BaklavaRequests extends _$BaklavaRequests {
  @override
  RequestsState build() {
    // Load requests on initialization
    loadRequests();
    return const RequestsState();
  }

  /// Load all requests from server
  Future<void> loadRequests() async {
    state = state.copyWith(loading: true, error: null);

    try {
      final service = ref.read(baklavaServiceProvider);
      final response = await service.fetchRequests();

      if (response.isSuccessful && response.body != null) {
        state = state.copyWith(
          requests: response.body!,
          loading: false,
        );
      } else {
        state = state.copyWith(
          loading: false,
          error: 'Failed to load requests',
        );
      }
    } catch (e, stackTrace) {
      print('DEBUG: Stack trace: $stackTrace');
      state = state.copyWith(
        loading: false,
        error: e.toString(),
      );
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
        state = state.copyWith(error: 'Failed to create request');
        return false;
      }
    } catch (e) {
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
