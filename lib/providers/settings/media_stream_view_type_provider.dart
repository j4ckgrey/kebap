import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kebap/models/settings/client_settings_model.dart';
import 'package:kebap/models/settings/media_stream_view_type.dart';
import 'package:kebap/providers/settings/client_settings_provider.dart';

final mediaStreamViewTypeProvider = StateProvider<MediaStreamViewType>((ref) {
  return ref.watch(clientSettingsProvider.select((value) => value.mediaStreamViewType));
});
