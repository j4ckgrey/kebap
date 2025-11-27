import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  final Function(String value)? onSubmited;
  final Function(String value)? onChanged;
  const SuggestionSearchBar({
    this.title,
    this.autoFocus = false,
    this.textEditingController,
    this.debounceDuration = const Duration(milliseconds: 250),
    this.onSubmited,
    this.onChanged,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchBarState();
}

class _SearchBarState extends ConsumerState<SuggestionSearchBar> {
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
      child: OutlinedTextField(
        focusNode: focusNode,
        useFocusWrapper: true,
        autoFocus: widget.autoFocus,
        controller: textEditingController,
        onSubmitted: (value) {
          widget.onSubmited?.call(value);
        },
        onChanged: (value) {
          widget.onChanged?.call(value);
          setState(() {
            isEmpty = value.isEmpty;
          });
        },
        placeHolder: widget.title ?? "${context.localized.search}...",
        decoration: InputDecoration(
          hintText: widget.title ?? "${context.localized.search}...",
          prefixIcon: const Icon(IconsaxPlusLinear.search_normal),
          contentPadding: const EdgeInsets.only(top: 13),
          suffixIcon: textEditingController.text.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    widget.onSubmited?.call('');
                    textEditingController.text = '';
                    setState(() {
                      isEmpty = true;
                    });
                  },
                  icon: const Icon(Icons.clear))
              : null,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
