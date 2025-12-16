import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:kebap/jellyfin/jellyfin_open_api.swagger.dart';
import 'package:kebap/providers/api_provider.dart';

part 'server_config_provider.g.dart';

@riverpod
class ServerConfig extends _$ServerConfig {
  @override
  Future<ServerConfiguration> build() async {
    final api = ref.read(jellyApiProvider);
    final response = await api.systemConfigurationGet();
    
    if (response.isSuccessful && response.body != null) {
      return response.body!;
    }
    
    throw Exception('Failed to load server configuration');
  }

  Future<void> updateConfiguration(ServerConfiguration config) async {
    state = const AsyncValue.loading();
    
    try {
      final api = ref.read(jellyApiProvider);
      final response = await api.systemConfigurationPost(config);
      
      if (response.isSuccessful) {
        // Refresh the configuration
        ref.invalidateSelf();
        await future;
      } else {
        throw Exception('Failed to update configuration');
      }
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }
}
