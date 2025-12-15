import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kebap/screens/settings/client_sections/client_settings_download.dart';
import 'package:kebap/screens/settings/settings_scaffold.dart';

@RoutePage()
class DownloadsSettingsPage extends ConsumerStatefulWidget {
  const DownloadsSettingsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DownloadsSettingsPageState();
}

class _DownloadsSettingsPageState extends ConsumerState<DownloadsSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return SettingsScaffold(
      label: "Downloads",
      items: [
        ...buildClientSettingsDownload(context, ref, setState),
      ],
    );
  }
}
