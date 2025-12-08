import 'package:flutter/material.dart';

import 'package:background_downloader/background_downloader.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import 'package:kebap/models/items/episode_model.dart';
import 'package:kebap/models/items/season_model.dart';
import 'package:kebap/models/items/series_model.dart';
import 'package:kebap/models/syncing/download_stream.dart';
import 'package:kebap/models/syncing/sync_item.dart';
import 'package:kebap/providers/sync/background_download_provider.dart';
import 'package:kebap/providers/sync/sync_provider_helpers.dart';
import 'package:kebap/providers/sync_provider.dart';
import 'package:kebap/screens/shared/default_alert_dialog.dart';
import 'package:kebap/util/localization_helper.dart';
import 'package:kebap/util/size_formatting.dart';

const _cancellableStatuses = {
  TaskStatus.canceled,
  TaskStatus.failed,
  TaskStatus.enqueued,
  TaskStatus.waitingToRetry,
};

class SyncLabel extends ConsumerWidget {
  final String? label;
  final TaskStatus status;
  const SyncLabel({this.label, required this.status, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: status.color(context).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        child: Text(
          label ?? status.name(context),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: status.color(context),
              ),
        ),
      ),
    );
  }
}

class SyncProgressBar extends ConsumerWidget {
  final SyncedItem item;
  final DownloadStream task;
  const SyncProgressBar({required this.item, required this.task, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final children = ref.watch(syncedNestedChildrenProvider(item)).valueOrNull ?? [];
    final totalSize = ref.watch(syncSizeProvider(item, children)) ?? 0;

    double currentBytes = 0;
    if (children.isNotEmpty) {
      for (var child in children) {
        final childTask = ref.watch(downloadTasksProvider(child.id));
        final childSize = child.fileSize ?? 0;
        if (child.videoFile.existsSync()) {
          currentBytes += childSize;
        } else if (childTask.hasDownload) {
          currentBytes += childTask.progress * childSize;
        }
      }
    } else {
      final size = item.fileSize ?? 0;
      if (item.videoFile.existsSync()) {
        currentBytes = size.toDouble();
      } else if (task.hasDownload) {
        currentBytes = task.progress * size;
      }
    }

    final downloadStatus = task.status;
    final downloadProgress = totalSize > 0 ? currentBytes / totalSize : 0.0;
    final downloadSpeed = task.downloadSpeed;
    print('[DEBUG] Sync progress: item=${item.id}, progress=${(downloadProgress * 100).toStringAsFixed(1)}%, bytes=${currentBytes.toInt()}/${totalSize.toInt()}, speed=$downloadSpeed');
    final downloadTask = task.task;

    if (!task.hasDownload && currentBytes == 0) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IgnorePointer(
          child: Row(
            spacing: 8,
            children: [
              Text(downloadStatus.name(context)),
              if (downloadSpeed.isNotEmpty) Opacity(opacity: 0.45, child: Text("($downloadSpeed)")),
            ],
          ),
        ),
        // Progress Bar (Full Width)
        IgnorePointer(
          child: TweenAnimationBuilder(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            tween: Tween<double>(
              begin: 0,
              end: downloadProgress,
            ),
            builder: (context, value, child) => LinearProgressIndicator(
              minHeight: 8,
              value: value,
              color: downloadStatus.color(context),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Controls Row
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Size and Percentage Text
            Text(
              "${(downloadProgress * 100).toStringAsFixed(0)}% (${currentBytes.toInt().byteFormat} / ${totalSize.byteFormat})",
              style: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.75)),
            ),
            const Spacer(),
            // Control Buttons
            if (downloadTask != null) ...{
              if (downloadStatus != TaskStatus.paused && downloadStatus != TaskStatus.enqueued)
                IconButton(
                  onPressed: () => ref.read(backgroundDownloaderProvider)?.pause(downloadTask),
                  icon: const Icon(IconsaxPlusBold.pause),
                ),
              if (downloadStatus == TaskStatus.paused) ...[
                IconButton(
                  onPressed: () => showDefaultAlertDialog(
                    context,
                    context.localized.stopDownload,
                    context.localized.stopDownloadConfirmation,
                    (context) {
                      ref.read(syncProvider.notifier).stopDownload(context, item, downloadTask);
                      Navigator.of(context).pop();
                    },
                    context.localized.yes,
                    (context) => Navigator.of(context).pop(),
                    context.localized.no,
                  ),
                  icon: const Icon(IconsaxPlusBold.stop),
                ),
                IconButton(
                  onPressed: () => ref.read(backgroundDownloaderProvider)?.resume(downloadTask),
                  icon: const Icon(IconsaxPlusBold.play),
                ),
              ],
              if (_cancellableStatuses.contains(downloadStatus)) ...[
                IconButton(
                  onPressed: () => showDefaultAlertDialog(
                    context,
                    context.localized.stopDownload,
                    context.localized.stopDownloadConfirmation,
                    (context) {
                      ref.read(syncProvider.notifier).stopDownload(context, item, downloadTask);
                      Navigator.of(context).pop();
                    },
                    context.localized.yes,
                    (context) => Navigator.of(context).pop(),
                    context.localized.no,
                  ),
                  icon: const Icon(IconsaxPlusBold.stop),
                ),
              ],
            },
          ],
        ),
      ],
    );
  }
}

class SyncSubtitle extends ConsumerWidget {
  final SyncedItem syncItem;
  final List<SyncedItem> children;
  const SyncSubtitle({
    required this.syncItem,
    this.children = const [],
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final baseItem = syncItem.itemModel;
    final syncStatus = ref
        .watch(syncDownloadStatusProvider(syncItem, children).select((value) => value?.status ?? TaskStatus.notFound));
    return Container(
      decoration: BoxDecoration(
          color: syncStatus.color(context).withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10)),
      child: Material(
        color: const Color.fromARGB(0, 208, 130, 130),
        textStyle: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(fontWeight: FontWeight.bold, color: syncStatus.color(context)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          child: switch (baseItem) {
            SeasonModel _ => Builder(
                builder: (context) {
                  final itemBaseModels = children.map((e) => e.itemModel);
                  final episodes = itemBaseModels.whereType<EpisodeModel>().length;
                  final syncedCount = children.where((element) {
                    final task = ref.read(downloadTasksProvider(element.id));
                    final exists = element.videoFile.existsSync();
                    if (!exists && !task.isEnqueuedOrDownloading) {
                       print('[DEBUG] File not found for ${element.id}: ${element.videoFile.path}');
                    }
                    return exists || task.isEnqueuedOrDownloading;
                  }).length;
                  return Text(
                    [
                      "${context.localized.episode(2)}: $episodes | ${context.localized.syncStatusSynced}: $syncedCount"
                    ].join('\n'),
                  );
                },
              ),
            SeriesModel _ => Builder(
                builder: (context) {
                  final itemBaseModels = children.map((e) => e.itemModel);
                  final seasons = itemBaseModels.whereType<SeasonModel>().length;
                  final episodes = itemBaseModels.whereType<EpisodeModel>().length;
                  final syncedCount = children.where((element) {
                    final task = ref.read(downloadTasksProvider(element.id));
                    return element.videoFile.existsSync() || task.isEnqueuedOrDownloading;
                  }).length;
                  return Text(
                    [
                      "${context.localized.season(2)}: $seasons",
                      "${context.localized.episode(2)}: $episodes | ${context.localized.syncStatusSynced}: $syncedCount"
                    ].join('\n'),
                  );
                },
              ),
            _ => Text(syncStatus.name(context)),
          },
        ),
      ),
    );
  }
}
