import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kebap/models/item_base_model.dart';
import 'package:kebap/providers/focused_item_provider.dart';
import 'package:kebap/screens/shared/media/compact_item_banner.dart';
import 'package:kebap/screens/shared/media/poster_row.dart';

class MultiRowView extends ConsumerStatefulWidget {
  final List<RowData> rows;
  final EdgeInsets contentPadding;

  const MultiRowView({
    required this.rows,
    required this.contentPadding,
    super.key,
  });

  @override
  ConsumerState<MultiRowView> createState() => _MultiRowViewState();
}

class _MultiRowViewState extends ConsumerState<MultiRowView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.rows.isNotEmpty && widget.rows[0].posters.isNotEmpty) {
        ref.read(focusedItemProvider.notifier).state = widget.rows[0].posters.first;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final navbarHeight = MediaQuery.paddingOf(context).top + 56.0;
    final availableHeight = size.height - navbarHeight;

    final bannerHeight = (availableHeight * 0.4).clamp(180.0, availableHeight * 0.6);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: bannerHeight,
          child: CompactItemBanner(
            item: ref.watch(focusedItemProvider),
            maxHeight: bannerHeight,
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: widget.contentPadding,
            itemBuilder: (context, index) {
              final row = widget.rows[index];
              return PosterRow(
                contentPadding: widget.contentPadding,
                label: row.label,
                posters: row.posters,
                autoFocus: index == 0,
                collectionAspectRatio: row.aspectRatio,
                onLabelClick: row.onLabelClick,
                onFocused: (item) => ref.read(focusedItemProvider.notifier).state = item,
              );
            },
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemCount: widget.rows.length,
          ),
        ),
      ],
    );
  }
}
