import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import 'package:kebap/util/localization_helper.dart';

class ExpandingOverview extends ConsumerWidget {
  final String text;
  const ExpandingOverview({required this.text, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          context.localized.overview,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        HtmlWidget(
          text,
          textStyle: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}
