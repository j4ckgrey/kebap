
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kebap/providers/library_search_provider.dart';
import 'package:kebap/screens/shared/adaptive_text_field.dart';
import 'package:kebap/util/localization_helper.dart';

class SuggestionSearchBar extends ConsumerStatefulWidget {
  final String? title;
  final bool autoFocus;
  final TextEditingController? textEditingController;
  final Duration debounceDuration;
  final Function(String value)? onSubmitted;
  final Function(String value)? onChanged;
  final Function()? onDown;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;

  const SuggestionSearchBar({
    this.title,
    this.autoFocus = false,
    this.textEditingController,
    this.debounceDuration = const Duration(milliseconds: 250),
    this.onSubmitted,
    this.onChanged,
    this.onDown,
    this.focusNode,
    this.textInputAction,
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
          color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
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
            textInputAction: widget.textInputAction,
            focusNode: focusNode,
            autoFocus: widget.autoFocus,
            controller: textEditingController,
            onSubmitted: (value) {
              widget.onSubmitted?.call(value);
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
