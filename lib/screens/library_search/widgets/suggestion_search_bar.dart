import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import 'package:kebap/models/item_base_model.dart';
import 'package:kebap/providers/library_search_provider.dart';
import 'package:kebap/screens/shared/outlined_text_field.dart';
import 'package:kebap/theme.dart';
import 'package:kebap/util/debouncer.dart';
import 'package:kebap/util/localization_helper.dart';

class SuggestionSearchBar extends ConsumerStatefulWidget {
  final String? title;
  final bool autoFocus;
  final TextEditingController? textEditingController;
  final Duration debounceDuration;
  final SuggestionsController<ItemBaseModel>? suggestionsBoxController;
  final Function(String value)? onSubmited;
  final Function(String value)? onChanged;
  final Function(ItemBaseModel value)? onItem;
  const SuggestionSearchBar({
    this.title,
    this.autoFocus = false,
    this.textEditingController,
    this.debounceDuration = const Duration(milliseconds: 250),
    this.suggestionsBoxController,
    this.onSubmited,
    this.onChanged,
    this.onItem,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchBarState();
}

class _SearchBarState extends ConsumerState<SuggestionSearchBar> {
  late final Debouncer debouncer = Debouncer(widget.debounceDuration);
  late final SuggestionsController<ItemBaseModel> suggestionsBoxController =
      widget.suggestionsBoxController ?? SuggestionsController<ItemBaseModel>();
  late final TextEditingController textEditingController = widget.textEditingController ?? TextEditingController();
  bool isEmpty = true;
  final FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    ref.listen(librarySearchProvider(widget.key!).select((value) => value.searchQuery), (previous, next) {
      if (textEditingController.text != next) {
        setState(() {
          textEditingController.text = next;
        });
      }
    });
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: KebapTheme.smallShape.borderRadius,
      ),
      shadowColor: Colors.transparent,
      child: TypeAheadField<ItemBaseModel>(
        focusNode: focusNode,
        hideOnEmpty: true,
        hideOnSelect: true,
        hideOnLoading: true,
        hideOnUnfocus: true,
        emptyBuilder: (context) => const SizedBox.shrink(),
        suggestionsController: suggestionsBoxController,
        decorationBuilder: (context, child) => const SizedBox.shrink(),
        builder: (context, controller, focusNode) => OutlinedTextField(
          focusNode: focusNode,
          autoFocus: widget.autoFocus,
          controller: controller,
          onSubmitted: (value) {
            widget.onSubmited!(value);
            suggestionsBoxController.close();
          },
          onChanged: (value) {
            setState(() {
              isEmpty = value.isEmpty;
            });
            // Trigger search immediately to update grid results below
            widget.onSubmited?.call(value);
          },
          searchQuery: (query) async {
            // Return empty list to disable autocomplete dropdown
            return [];
          },
          placeHolder: widget.title ?? "${context.localized.search}...",
          decoration: InputDecoration(
            hintText: widget.title ?? "${context.localized.search}...",
            prefixIcon: const Icon(IconsaxPlusLinear.search_normal),
            contentPadding: const EdgeInsets.only(top: 13),
            suffixIcon: controller.text.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      widget.onSubmited?.call('');
                      controller.text = '';
                      suggestionsBoxController.close();
                      setState(() {
                        isEmpty = true;
                      });
                    },
                    icon: const Icon(Icons.clear))
                : null,
            border: InputBorder.none,
          ),
        ),
        loadingBuilder: (context) => const SizedBox.shrink(),
        onSelected: (suggestion) {
          suggestionsBoxController.close();
        },
        itemBuilder: (context, suggestion) {
          // This won't be shown since we're returning empty suggestions
          return const SizedBox.shrink();
        },
        suggestionsCallback: (pattern) async {
          // Return empty list to disable dropdown suggestions completely
          return [];
        },
      ),
    );
  }
}
