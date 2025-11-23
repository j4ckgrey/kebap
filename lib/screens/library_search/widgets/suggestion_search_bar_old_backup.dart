import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:page_transition/page_transition.dart';

import 'package:kebap/models/item_base_model.dart';
import 'package:kebap/providers/library_search_provider.dart';
import 'package:kebap/providers/search_mode_provider.dart';
import 'package:kebap/screens/shared/outlined_text_field.dart';
import 'package:kebap/theme.dart';
import 'package:kebap/util/debouncer.dart';
import 'package:kebap/util/kebap_image.dart';
import 'package:kebap/util/localization_helper.dart';
import 'package:kebap/widgets/search/search_result_modal.dart';

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
        hideOnEmpty: isEmpty,
        emptyBuilder: (context) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "${context.localized.noSuggestionsFound}...",
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        suggestionsController: suggestionsBoxController,
        decorationBuilder: (context, child) => DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
            borderRadius: KebapTheme.smallShape.borderRadius,
          ),
          child: child,
        ),
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
          },
          searchQuery: (query) async {
            if (query.isEmpty) return [];
            if (widget.key != null) {
              final items =
                  await ref.read(librarySearchProvider(widget.key!).notifier).fetchSuggestions(query, limit: 5);
              return items.map((e) => e.name).toList();
            }
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
        loadingBuilder: (context) => const SizedBox(
          height: 50,
          child: Center(child: CircularProgressIndicator(strokeCap: StrokeCap.round)),
        ),
        onSelected: (suggestion) {
          suggestionsBoxController.close();
        },
        itemBuilder: (context, suggestion) {
          return ListTile(
            onTap: () async {
              if (widget.onItem != null) {
                widget.onItem?.call(suggestion);
              } else {
                // Check search mode
                final searchMode = ref.read(searchModeNotifierProvider);
                
                if (searchMode == SearchMode.local) {
                  // Local search - navigate directly to item details
                  Navigator.of(context).push(
                    PageTransition(
                      child: suggestion.detailScreenWidget,
                      type: PageTransitionType.fade,
                    ),
                  );
                } else {
                  // Global search - show modal with import/request options
                  // The item came from external search (Gelato/TMDB via Baklava)
                  await showDialog(
                    context: context,
                    builder: (_) => SearchResultModal(item: suggestion),
                  );
                }
              }
            },
            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
            title: ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: 50,
                maxHeight: 65,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                      child: AspectRatio(
                        aspectRatio: 0.8,
                        child: KebapImage(
                          image: suggestion.images?.primary,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Flexible(
                              child: Text(
                            suggestion.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )),
                          if (suggestion.overview.yearAired.toString().isNotEmpty)
                            Flexible(
                                child: Opacity(
                                    opacity: 0.45, child: Text(suggestion.overview.yearAired?.toString() ?? ""))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        suggestionsCallback: (pattern) async {
          if (pattern.isEmpty) return [];
          if (widget.key != null) {
            return (await ref.read(librarySearchProvider(widget.key!).notifier).fetchSuggestions(pattern));
          }
          return [];
        },
      ),
    );
  }
}
