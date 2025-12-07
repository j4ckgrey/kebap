import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:kebap/models/profanity_filter_models.dart';
import 'package:kebap/providers/profanity_filter_service.dart';
import 'package:kebap/providers/user_provider.dart';

part 'profanity_filter_provider.g.dart';

/// Provider for the profanity filter service
@riverpod
ProfanityFilterService profanityFilterService(ProfanityFilterServiceRef ref) {
  return ProfanityFilterService(ref);
}

/// Provider to check if the profanity filter plugin is available on the server
@riverpod
class ProfanityPluginAvailable extends _$ProfanityPluginAvailable {
  @override
  Future<bool> build() async {
    final service = ref.read(profanityFilterServiceProvider);
    return service.checkPluginAvailable();
  }

  /// Force refresh the availability check
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final service = ref.read(profanityFilterServiceProvider);
      return service.checkPluginAvailable();
    });
  }
}

/// Provider for the current user's profanity filter preferences
@riverpod
class ProfanityUserPrefs extends _$ProfanityUserPrefs {
  @override
  Future<ProfanityUserPreferences> build() async {
    final user = ref.watch(userProvider);
    if (user == null) return ProfanityUserPreferences();

    final service = ref.read(profanityFilterServiceProvider);
    final response = await service.getUserPreferences(user.id);
    return response.body ?? ProfanityUserPreferences();
  }

  /// Update user preferences
  Future<void> updatePreferences({
    bool? enabled,
    bool? muteEntireSentence,
  }) async {
    final user = ref.read(userProvider);
    if (user == null) return;

    final current = state.valueOrNull ?? ProfanityUserPreferences();
    final updated = ProfanityUserPreferences(
      enabled: enabled ?? current.enabled,
      muteEntireSentence: muteEntireSentence ?? current.muteEntireSentence,
    );

    final service = ref.read(profanityFilterServiceProvider);
    final response = await service.updateUserPreferences(user.id, updated);
    
    if (response.isSuccessful) {
      state = AsyncData(response.body ?? updated);
    }
  }

  /// Toggle the filter on/off
  Future<void> toggleEnabled() async {
    final current = state.valueOrNull ?? ProfanityUserPreferences();
    await updatePreferences(enabled: !current.enabled);
  }
}

/// Provider for the plugin configuration (admin only)
@riverpod
class ProfanityConfig extends _$ProfanityConfig {
  @override
  Future<ProfanityPluginConfig> build() async {
    final service = ref.read(profanityFilterServiceProvider);
    final response = await service.getPluginConfig();
    return response.body ?? ProfanityPluginConfig();
  }

  /// Update plugin configuration
  Future<void> updateConfig(ProfanityPluginConfig config) async {
    final service = ref.read(profanityFilterServiceProvider);
    final response = await service.updatePluginConfig(config);
    
    if (response.isSuccessful) {
      state = AsyncData(response.body ?? config);
    }
  }

  /// Trigger a library scan
  Future<void> triggerScan() async {
    final service = ref.read(profanityFilterServiceProvider);
    await service.triggerLibraryScan();
  }
}

/// Provider for profanity metadata of a specific item
@riverpod
Future<ProfanityMetadata?> profanityMetadata(
  ProfanityMetadataRef ref,
  String itemId,
) async {
  // Check if plugin is available first
  final available = await ref.watch(profanityPluginAvailableProvider.future);
  if (!available) return null;

  // Check if user has filter enabled
  final prefs = await ref.watch(profanityUserPrefsProvider.future);
  if (!prefs.enabled) return null;

  final service = ref.read(profanityFilterServiceProvider);
  final response = await service.getMetadata(itemId);
  return response.body;
}

/// Convenience provider to check if filter is currently active for the user
@riverpod
Future<bool> profanityFilterActive(ProfanityFilterActiveRef ref) async {
  final available = await ref.watch(profanityPluginAvailableProvider.future);
  if (!available) return false;

  final prefs = await ref.watch(profanityUserPrefsProvider.future);
  return prefs.enabled;
}
