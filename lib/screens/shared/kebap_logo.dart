import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kebap/screens/shared/kebap_icon.dart';
import 'package:kebap/util/application_info.dart';
import 'package:kebap/util/string_extensions.dart';
import 'package:kebap/util/theme_extensions.dart';

class FladderLogo extends ConsumerWidget {
  const FladderLogo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Hero(
      tag: "Fladder_Logo_Tag",
      child: Wrap(
        runAlignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.center,
        spacing: 16,
        runSpacing: 8,
        children: [
          const FladderIcon(),
          Text(
            ref.read(applicationInfoProvider).name.capitalize(),
            style: context.textTheme.displayLarge,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
