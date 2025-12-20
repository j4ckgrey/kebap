import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kebap/models/item_base_model.dart';
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
  final Function(ItemBaseModel? focused)? onFocused;
  final bool primaryPosters;
  final double? explicitHeight; // Explicit height for cards
  final FocusNode? firstItemFocusNode;
  final Function(ItemBaseModel item)? onCardTap;
  final Function(ItemBaseModel item)? onCardAction;
  final String? selectedItemId; // ID of item shown in banner for persistent selection

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
    this.onCardTap,
    this.onCardAction,
    this.selectedItemId,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dominantRatio = primaryPosters ? 1.2 : collectionAspectRatio ?? posters.getMostCommonType.aspectRatio;
    
    // Calculate start index based on selected item ID
    int? startIndex;
    if (selectedItemId != null) {
      final index = posters.indexWhere((element) => element.id == selectedItemId);
      if (index != -1) {
        startIndex = index;
      }
    }

    return HorizontalList(
      contentPadding: contentPadding,
      label: label,
      hideLabel: hideLabel,
      autoFocus: FocusProvider.autoFocusOf(context) || startIndex != null,
      onLabelClick: onLabelClick,
      dominantRatio: dominantRatio,
      items: posters,
      startIndex: startIndex, // Pass the calculated start index
      height: explicitHeight, // Use explicit height if provided
      onFocused: (index) {
        if (onFocused != null) {
          if (index < posters.length) {
            onFocused?.call(posters[index]);
          } else {
            // Placeholder (Show More) focused
            onFocused?.call(null);
          }
        }
        // Only trigger tap action on focus if NO explicit tap handler is provided
        // This preserves "Focus updates banner" vs "Tap navigates" distinction
        // if (onCardTap != null && onLabelClick == null) {
        //   onCardTap!(posters[index]);
        // }
      },
      itemBuilder: (context, index) {
        final poster = posters[index];
        final isSelected = selectedItemId == poster.id;
        return PosterWidget(
          key: Key(poster.id),
          focusNode: index == 0 ? firstItemFocusNode : null,
          poster: poster,
          aspectRatio: dominantRatio,
          primaryPosters: primaryPosters,
          underTitle: !hideLabel, 
          onCustomTap: onCardTap != null ? () => onCardTap!(poster) : null,
          onCustomAction: onCardAction != null ? () => onCardAction!(poster) : null,
          isSelectedForBanner: isSelected, 
        );
      },
    );
  }
}
