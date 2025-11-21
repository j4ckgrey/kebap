import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'search_mode_provider.g.dart';

enum SearchMode {
  local,
  global;

  String get displayName => switch (this) {
        SearchMode.local => 'Local Search',
        SearchMode.global => 'Global Search',
      };

  String get description => switch (this) {
        SearchMode.local => 'Search your Jellyfin library',
        SearchMode.global => 'Search external sources (Gelato)',
      };
}

const String _searchModeKey = 'jellyfin_search_mode';

@Riverpod(keepAlive: true)
class SearchModeNotifier extends _$SearchModeNotifier {
  @override
  SearchMode build() {
    _loadSavedMode();
    return SearchMode.global; // Default to global search
  }

  Future<void> _loadSavedMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedMode = prefs.getString(_searchModeKey);

      if (savedMode != null) {
        final mode = SearchMode.values.firstWhere(
          (m) => m.name == savedMode,
          orElse: () => SearchMode.global,
        );
        state = mode;
      }
    } catch (e) {
      // Ignore errors, use default
    }
  }

  Future<void> _saveMode(SearchMode mode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_searchModeKey, mode.name);
    } catch (e) {
      // Ignore errors
    }
  }

  void toggleMode() {
    final newMode =
        state == SearchMode.local ? SearchMode.global : SearchMode.local;
    setMode(newMode);
  }

  void setMode(SearchMode mode) {
    state = mode;
    _saveMode(mode);
  }

  /// Get search term with appropriate prefix based on mode
  String processSearchTerm(String searchTerm) {
    const localPrefix = 'local:';

    if (state == SearchMode.local) {
      // Add prefix if not already present
      if (!searchTerm.startsWith(localPrefix)) {
        return '$localPrefix$searchTerm';
      }
      return searchTerm;
    } else {
      // Remove prefix if present
      if (searchTerm.startsWith(localPrefix)) {
        return searchTerm.substring(localPrefix.length);
      }
      return searchTerm;
    }
  }
}
