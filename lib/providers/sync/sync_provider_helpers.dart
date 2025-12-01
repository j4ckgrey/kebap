import 'package:background_downloader/background_downloader.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:kebap/models/item_base_model.dart';
import 'package:kebap/models/syncing/download_stream.dart';
import 'package:kebap/models/syncing/sync_item.dart';
import 'package:kebap/providers/sync_provider.dart';

part 'sync_provider_helpers.g.dart';

@riverpod
Stream<SyncedItem?> syncedItem(Ref ref, ItemBaseModel? item) {
  final id = item?.id;
  if (id == null || id.isEmpty) {
    return Stream.value(null);
  }

  return ref.watch(syncProvider.notifier).watchItem(id);
}

@riverpod
class SyncedChildren extends _$SyncedChildren {
  @override
  FutureOr<List<SyncedItem>> build(SyncedItem item) => ref.read(syncProvider.notifier).getChildren(item.id);
}

@riverpod
class SyncedNestedChildren extends _$SyncedNestedChildren {
  @override
  FutureOr<List<SyncedItem>> build(SyncedItem item) => ref.read(syncProvider.notifier).getNestedChildren(item);
}

@riverpod
class SyncDownloadStatus extends _$SyncDownloadStatus {
  @override
  DownloadStream? build(SyncedItem arg, List<SyncedItem> children) {
    final nestedChildren = children;

    ref.watch(downloadTasksProvider(arg.id));
    for (var element in nestedChildren) {
      ref.watch(downloadTasksProvider(element.id));
    }

    DownloadStream mainStream = ref.read(downloadTasksProvider(arg.id));
    int downloadCount = 0;
    double fullProgress = 0.0;

    // Count main stream if it's downloading
    if (mainStream.isEnqueuedOrDownloading) {
      downloadCount++;
      fullProgress += mainStream.progress.clamp(0.0, 1.0);
    }

    int fullySyncedChildren = 0;

    for (var i = 0; i < nestedChildren.length; i++) {
      final childItem = nestedChildren[i];
      final downloadStream = ref.read(downloadTasksProvider(childItem.id));
      if (childItem.videoFile.existsSync()) {
        fullySyncedChildren++;
      }
      if (downloadStream.isEnqueuedOrDownloading) {
        downloadCount++;
        fullProgress += downloadStream.progress.clamp(0.0, 1.0);

        mainStream = mainStream.copyWith(
          status: mainStream.status != TaskStatus.running ? downloadStream.status : mainStream.status,
        );
      }
    }

    int syncAbleChildren = nestedChildren.where((element) => element.hasVideoFile).length;

    var fullySynced = nestedChildren.isNotEmpty ? fullySyncedChildren == syncAbleChildren : arg.videoFile.existsSync();
    
    // Calculate average progress, or 1.0 if fully synced
    double finalProgress = fullySynced ? 1.0 : (downloadCount > 0 ? fullProgress / downloadCount : 0.0);
    
    return mainStream.copyWith(
      status: fullySynced ? TaskStatus.complete : mainStream.status,
      progress: finalProgress,
    );
  }
}

@riverpod
class SyncSize extends _$SyncSize {
  @override
  int? build(SyncedItem arg, List<SyncedItem>? children) {
    final nestedChildren = children;

    ref.watch(downloadTasksProvider(arg.id));
    int size = arg.fileSize ?? 0;

    if (nestedChildren != null) {
      for (var element in nestedChildren) {
        ref.watch(downloadTasksProvider(element.id));
      }
      for (var element in nestedChildren) {
        size += element.fileSize ?? 0;
      }
    }

    return size;
  }
}
