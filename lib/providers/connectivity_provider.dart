import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:kebap/jellyfin/jellyfin_open_api.swagger.dart';
import 'package:kebap/providers/api_provider.dart';
import 'package:kebap/providers/user_provider.dart';

part 'connectivity_provider.g.dart';

enum ConnectionState {
  offline,
  mobile,
  wifi,
  ethernet;

  bool get homeInternet => switch (this) {
        ConnectionState.offline => false,
        ConnectionState.mobile => false,
        ConnectionState.wifi => true,
        ConnectionState.ethernet => true,
      };
}

@Riverpod(keepAlive: true)
class ConnectivityStatus extends _$ConnectivityStatus {
  String? localUrl;

  @override
  ConnectionState build() {
    ref.watch(userProvider);
    // Wrap connectivity plugin initialization in try/catch to avoid unhandled
    // DBus exceptions on platforms without NetworkManager (WSL, minimal VMs).
    // Wrap connectivity plugin initialization in runZonedGuarded to catch
    // unhandled async errors from the plugin (e.g. DBus/NetworkManager missing).
    runZonedGuarded(() {
      try {
        final connectivity = Connectivity();
        // connectivity.onConnectivityChanged.listen(
        //   (result) => onStateChange(result),
        //   onError: (e) {
        //     log('[Connectivity] Stream error: $e');
        //   },
        // );
        checkConnectivity();
      } catch (e, s) {
        log('[Connectivity] initialization failed: $e\n$s');
      }
    }, (error, stack) {
      log('[Connectivity] Unhandled async error: $error\n$stack');
    });
    return ConnectionState.mobile;
  }
  // Accept either a single ConnectivityResult or an Iterable/list of them.
  // isInitialCheck: if true, don't debounce offline detection (for startup)
  void onStateChange(dynamic connectivityResult, {bool isInitialCheck = false}) async {
    List<ConnectivityResult> results;
    if (connectivityResult is Iterable<ConnectivityResult>) {
      results = connectivityResult.cast<ConnectivityResult>().toList();
    } else if (connectivityResult is ConnectivityResult) {
      results = [connectivityResult];
    } else {
      // Unknown type; log and bail out.
      log('[Connectivity] onStateChange called with unexpected type: ${connectivityResult.runtimeType}');
      return;
    }

    log('[Connectivity] onStateChange: results=$results, isInitialCheck=$isInitialCheck');

    if (results.contains(ConnectivityResult.ethernet)) {
      state = ConnectionState.ethernet;
    } else if (results.contains(ConnectivityResult.wifi)) {
      state = ConnectionState.wifi;
    } else if (results.contains(ConnectivityResult.mobile)) {
      state = ConnectionState.mobile;
    } else if (results.contains(ConnectivityResult.none)) {
      if (isInitialCheck) {
        // On initial check, set offline immediately without debounce
        state = ConnectionState.offline;
        log('[Connectivity] Initial check detected offline, setting state immediately');
      } else {
        // Debounce offline state to avoid flickering during network switches
        await Future.delayed(const Duration(seconds: 2));
        final current = await Connectivity().checkConnectivity();
        if (current.contains(ConnectivityResult.none) && 
            !current.contains(ConnectivityResult.wifi) && 
            !current.contains(ConnectivityResult.ethernet) && 
            !current.contains(ConnectivityResult.mobile)) {
          state = ConnectionState.offline;
        }
      }
    }

    final newUrl = ref.read(userProvider.select((value) => value?.credentials.localUrl));
    if (localUrl == newUrl) return;
    localUrl = newUrl;
    final localConnection =
        localUrl != null && localUrl?.isNotEmpty == true ? await fetchSystemInfoDynamic(normalizeUrl(localUrl!)) : null;
    final correctServerResponse = localConnection?.id == ref.read(userProvider.select((value) => value?.credentials.serverId));
    ref.read(localConnectionAvailableProvider.notifier).update((state) => correctServerResponse);
  }

  void checkConnectivity() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      log('[Connectivity] checkConnectivity: result=$connectivityResult');
      onStateChange(connectivityResult, isInitialCheck: true);
    } catch (e, s) {
      // Plugin failed (e.g. DBus / NetworkManager not available). Log and keep running.
      log('[Connectivity] checkConnectivity failed: $e\n$s');
    }
  }
}

Future<PublicSystemInfo?> fetchSystemInfoDynamic(String baseUrl) async {
  if (baseUrl.isEmpty) return null;
  try {
    final uri = Uri.parse(baseUrl).resolve('/System/Info/Public');
    final response = await http.get(uri).timeout(const Duration(seconds: 1));
    if (response.statusCode == 200) {
      return PublicSystemInfo.fromJson(jsonDecode(response.body));
    }
    return null;
  } catch (e) {
    log(e.toString());
    return null;
  }
}

final localConnectionAvailableProvider = StateProvider<bool>((ref) {
  return false;
});
