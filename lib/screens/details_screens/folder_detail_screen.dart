import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kebap/models/item_base_model.dart';
import 'package:kebap/models/items/photos_model.dart';
import 'package:kebap/providers/items/folder_details_provider.dart';
import 'package:kebap/routes/auto_router.gr.dart';
import 'package:kebap/screens/shared/media/poster_grid.dart';
import 'package:kebap/widgets/shared/pull_to_refresh.dart';

class FolderDetailScreen extends ConsumerWidget {
  final ItemBaseModel item;
  const FolderDetailScreen({required this.item, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final providerInstance = folderDetailsProvider(item.id);
    final details = ref.watch(providerInstance);

    return PullToRefresh(
      child: Scaffold(
        appBar: AppBar(
            title: Text(
          details?.name ?? "",
        )),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: PosterGrid(
                posters: details?.items ?? [],
                onPressed: (action, item) async {
                  switch (item) {
                    case PhotoModel photoModel:
                      final photoItems = details?.items.whereType<PhotoModel>().toList();
                      await context.pushRoute(PhotoViewerRoute(
                        items: photoItems,
                        selected: photoModel.id,
                      ));
                      break;
                    default:
                      if (context.mounted) {
                        await item.navigateTo(context);
                      }
                  }
                },
              ),
            )
          ],
        ),
      ),
      onRefresh: () async {
        await ref.read(providerInstance.notifier).fetchDetails(item.id);
      },
    );
  }
}
