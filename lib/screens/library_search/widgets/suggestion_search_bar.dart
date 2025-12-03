
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:kebap/models/item_base_model.dart';
import 'package:kebap/providers/library_search_provider.dart';
import 'package:kebap/screens/shared/adaptive_text_field.dart';
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
  final Function()? onDown;
  final FocusNode? focusNode;
  const SuggestionSearchBar({
    this.title,
    this.autoFocus = false,
    this.textEditingController,
    this.debounceDuration = const Duration(milliseconds: 250),
    this.onSubmited,
    this.onChanged,
    this.onDown,
    this.focusNode,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchBarState();
}

class _SearchBarState extends ConsumerState<SuggestionSearchBar> {
  late final TextEditingController textEditingController = widget.textEditingController ?? TextEditingController();
  bool isEmpty = true;
  late final FocusNode focusNode = widget.focusNode ?? FocusNode();

  @override
  Widget build(BuildContext context) {
    ref.listen(librarySearchProvider(widget.key!).select((value) => value.searchQuery), (previous, next) {
      if (textEditingController.text != next) {
        setState(() {
          textEditingController.text = next;
        });
      }
    });
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: CallbackShortcuts(
          bindings: {
            const SingleActivator(LogicalKeyboardKey.arrowDown): () {
              widget.onDown?.call();
            },
          },
          child: AdaptiveTextField(
            focusNode: focusNode,
            autoFocus: widget.autoFocus,
            controller: textEditingController,
            onDown: widget.onDown,
            onSubmitted: (value) {
              widget.onSubmited?.call(value);
            },
            onChanged: (value) {
              if (value.isEmpty) {
                setState(() {
                  isEmpty = true;
                });
              } else {
                setState(() {
                  isEmpty = false;
                });
              }
              widget.onChanged?.call(value);
            },
            placeHolder: widget.title ?? "${context.localized.search}...",
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: widget.title ?? "${context.localized.search}...",
              icon: const Icon(Icons.search),
              suffixIcon: !isEmpty
                  ? IconButton(
                      onPressed: () {
                        textEditingController.clear();
                        widget.onChanged?.call("");
                        setState(() {
                          isEmpty = true;
                        });
                      },
                      icon: const Icon(Icons.clear),
                    )
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}
