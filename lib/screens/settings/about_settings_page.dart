import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:kebap/screens/crash_screen/crash_screen.dart';
import 'package:kebap/screens/settings/settings_scaffold.dart';
import 'package:kebap/screens/settings/widgets/settings_update_information.dart';
import 'package:kebap/screens/shared/kebap_icon.dart';
import 'package:kebap/screens/shared/kebap_logo.dart';
import 'package:kebap/screens/shared/media/external_urls.dart';
import 'package:kebap/util/application_info.dart';
import 'package:kebap/util/list_padding.dart';
import 'package:kebap/util/localization_helper.dart';

class _Socials {
  final String label;
  final String url;
  final IconData icon;

  const _Socials(this.label, this.url, this.icon);
}

const socials = [
  _Socials(
    'Github',
    'https://github.com/j4ckgrey/Kebap',
    FontAwesomeIcons.githubAlt,
  ),
];

@RoutePage()
class AboutSettingsPage extends ConsumerWidget {
  const AboutSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final applicationInfo = ref.watch(applicationInfoProvider);

    return SettingsScaffold(
      label: "",
      items: [
        const KebapLogo(useGradient: false),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(context.localized.aboutVersion(applicationInfo.versionAndPlatform)),
            Text(context.localized.aboutBuild(applicationInfo.buildNumber)),
            const SizedBox(height: 16),
            Text(context.localized.aboutCreatedBy),
          ],
        ),
        const FractionallySizedBox(
          widthFactor: 0.25,
          child: Divider(
            indent: 16,
            endIndent: 16,
          ),
        ),
        Column(
          children: [
            Text(
              context.localized.aboutSocials,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: socials
                  .map(
                    (e) => IconButton.filledTonal(
                      onPressed: () => launchUrl(context, e.url),
                      icon: Column(
                        children: [
                          Icon(e.icon),
                          Text(e.label),
                        ],
                      ),
                    ),
                  )
                  .toList()
                  .addInBetween(const SizedBox(width: 16)),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FilledButton.tonal(
              onPressed: () => showLicensePage(
                context: context,
                applicationIcon: const KebapIcon(size: 55, useGradient: false),
                applicationVersion: applicationInfo.versionPlatformBuild,
                applicationLegalese: "j4ckgrey",
                useRootNavigator: true,
              ),
              child: Text(context.localized.aboutLicenses),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FilledButton.tonal(
              onPressed: () => showDialog(
                context: context,
                builder: (context) => const CrashScreen(),
              ),
              child: Text(context.localized.errorLogs),
            )
          ],
        ),
        const SettingsUpdateInformation(),
      ].addInBetween(const SizedBox(height: 16)),
    );
  }
}
