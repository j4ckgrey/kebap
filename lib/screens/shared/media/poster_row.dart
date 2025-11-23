import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kebap/models/item_base_model.dart';
import 'package:kebap/providers/arguments_provider.dart';
import 'package:kebap/screens/shared/media/poster_widget.dart';
import 'package:kebap/util/focus_provider.dart';
import 'package:kebap/util/item_base_model/item_base_model_extensions.dart';
import 'package:kebap/widgets/shared/ensure_visible.dart';
import 'package:kebap/widgets/shared/horizontal_list.dart';

class PosterRow extends ConsumerWidget {
  final List<ItemBaseModel> posters;
  final String label;
  final bool hideLabel; // Hide label when showing in banner
  final double? collectionAspectRatio;
  final Function()? onLabelClick;
  final EdgeInsets contentPadding;
  final Function(ItemBaseModel focused)? onFocused;
  final bool primaryPosters;
  final double? explicitHeight; // Explicit height for cards
  final FocusNode? firstItemFocusNode;
  final bool? autoFocus;

  const PosterRow({
    required this.posters,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 16),
    required this.label,
    this.hideLabel = false,
    this.collectionAspectRatio,
    this.onLabelClick,
    this.onFocused,
    this.primaryPosters = false,
    this.explicitHeight,
    this.firstItemFocusNode,
    this.autoFocus,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dominantRatio = primaryPosters ? 1.2 : collectionAspectRatio ?? posters.getMostCommonType.aspectRatio;
    return HorizontalList(
      contentPadding: contentPadding,
      label: label,
      hideLabel: hideLabel,
      autoFocus: autoFocus ?? (ref.read(argumentsStateProvider).htpcMode ? FocusProvider.autoFocusOf(context) : false),
      onLabelClick: onLabelClick,
      dominantRatio: dominantRatio,
      items: posters,
      height: explicitHeight, // Use explicit height if provided
      onFocused: (index) {
        if (onFocused != null) {
          onFocused?.call(posters[index]);
        } else {
          context.ensureVisible();
        }
      },
      itemBuilder: (context, index) {
        final poster = posters[index];
        return PosterWidget(
          key: Key(poster.id),
          focusNode: index == 0 ? firstItemFocusNode : null,
          poster: poster,
          aspectRatio: dominantRatio,
          primaryPosters: primaryPosters,
          underTitle: !hideLabel, // Hide title when label is hidden (shown in banner)
        );
      },
    );
  }
}
