import 'package:kebap/providers/search_provider.dart';
import 'package:kebap/util/debouncer.dart';
import 'package:kebap/util/string_extensions.dart';
import 'package:kebap/widgets/search/search_mode_toggle.dart';
import 'package:kebap/widgets/search/search_result_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kebap/util/item_base_model/item_base_model_extensions.dart';

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
                (e) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16, bottom: 8),
                        child: Text(
                          e.key.name.capitalize(),
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 280, // Height for horizontal carousel
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: e.value.length,
                          itemBuilder: (context, index) {
                            final item = e.value[index];
                            return Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: SizedBox(
                                width: 150,
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    print('DEBUG: Search item tapped, showing modal');
                                    showDialog(
                                      context: context,
                                      builder: (context) => Dialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: SearchResultModal(item: item),
                                      ),
                                    );
                                  },
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 225,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: item.images?.primary != null
                                              ? Image.network(
                                                  item.images!.primary!.path,
                                                  fit: BoxFit.cover,
                                                  width: double.infinity,
                                                )
                                              : Container(
                                                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                                                  child: Icon(
                                                    Icons.movie,
                                                    size: 48,
                                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                                  ),
                                                ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        item.name,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context).textTheme.bodyMedium,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
