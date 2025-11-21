import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fladder/models/settings/media_stream_view_type.dart';

final mediaStreamViewTypeProvider = StateProvider<MediaStreamViewType>((ref) => MediaStreamViewType.dropdown);
