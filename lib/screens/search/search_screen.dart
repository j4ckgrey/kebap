import 'package:kebap/providers/search_provider.dart';
import 'package:kebap/screens/shared/media/poster_grid.dart';
import 'package:kebap/util/debouncer.dart';
import 'package:kebap/util/string_extensions.dart';
import 'package:kebap/widgets/search/search_mode_toggle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kebap/widgets/shared/modal_bottom_sheet.dart';
import 'package:kebap/widgets/shared/item_actions.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  final Debouncer searchDebouncer = Debouncer(const Duration(milliseconds: 500));

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(searchProvider.notifier).clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final searchResults = ref.watch(searchProvider);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          SearchModeToggle(
            onModeChanged: () {
              // Trigger search refresh when mode changes
              if (_controller.text.isNotEmpty) {
                ref.read(searchProvider.notifier).searchQuery();
              }
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: Stack(
            children: [
              Transform.translate(
                offset: const Offset(0, 4),
                child: Container(
                  height: 1,
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
              ),
              Transform.translate(
                offset: const Offset(0, -4),
                child: AnimatedOpacity(
                  opacity: searchResults.loading ? 1 : 0,
                  duration: const Duration(milliseconds: 250),
                  child: Transform.translate(
                    offset: const Offset(0, 5),
                    child: const LinearProgressIndicator(),
                  ),
                ),
              ),
            ],
          ),
        ),
        title: TextField(
          controller: _controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: "Search library...",
            border: InputBorder.none,
          ),
          onSubmitted: (value) {
            ref.read(searchProvider.notifier).searchQuery();
          },
          onChanged: (query) {
            ref.read(searchProvider.notifier).setQuery(query);
            searchDebouncer.run(() {
              ref.read(searchProvider.notifier).searchQuery();
            });
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 60),
        child: ListView(
        children: searchResults.results.entries
            .map(
              (e) => PosterGrid(
                stickyHeader: false,
                name: e.key.name.capitalize(),
                posters: e.value,
                onPressed: (action, item) {
                  showBottomSheetPill(
                    context: context,
                    content: (context, scrollController) {
                      final actions = item.generateActions(context, ref);
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ItemActionButton(
                            label: Text('View Details'),
                            icon: const Icon(Icons.info_outline),
                            action: () {
                              Navigator.of(context).pop();
                              action();
                            },
                          ).toListItem(context, useIcons: true),
                          const Divider(),
                          ...actions.listTileItems(context, useIcons: true),
                        ],
                      );
                    },
                  );
                },
              ),
            )
            .toList(),
      ),
    );
  }
}
