import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kebap/models/settings/media_stream_view_type.dart';

final mediaStreamViewTypeProvider = StateProvider<MediaStreamViewType>((ref) => MediaStreamViewType.dropdown);
