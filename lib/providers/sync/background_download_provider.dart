import 'dart:async';

import 'package:flutter/widgets.dart';

import 'package:background_downloader/background_downloader.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:kebap/models/syncing/download_stream.dart';
import 'package:kebap/providers/settings/client_settings_provider.dart';
import 'package:kebap/providers/sync_provider.dart';
import 'package:kebap/util/localization_helper.dart';

part 'background_download_provider.g.dart';

final itemDownloadGroup = "ITEM_DOWNLOAD_GROUP";

@Riverpod(keepAlive: true)
class BackgroundDownloader extends _$BackgroundDownloader {
  late StreamSubscription<TaskUpdate> updateListener;

  @override
  FileDownloader build() {
    ref.onDispose(
      () => updateListener.cancel(),
    );

    final maxDownloads = ref.read(clientSettingsProvider.select((value) => value.maxConcurrentDownloads));
    final downloader = FileDownloader()
      ..configure(
        globalConfig: globalConfig(maxDownloads),
      );
    updateListener = downloader.updates.listen(updateTask);
    downloader.trackTasks();
    return downloader;
  }

  void updateTask(TaskUpdate update) async {
    switch (update) {
      case TaskStatusUpdate():
        // Debug log for file name
        print('[DEBUG] Download task info: taskId=${update.task.taskId}, displayName=${update.task.displayName}');
        final status = update.status;
        // Debug log for status changes
        print('[DEBUG] Download status update: taskId=${update.task.taskId}, status=$status');
        ref.read(downloadTasksProvider(update.task.taskId).notifier).update(
              (state) {
                print('[DEBUG] TaskStatusUpdate: oldProgress=${state.progress}, newStatus=$status');
                return state.copyWith(status: status);
              },
            );
        if (status == TaskStatus.complete || status == TaskStatus.canceled) {
          // Update file size from actual downloaded file when complete
          if (status == TaskStatus.complete) {
            final syncItem = await ref.read(syncProvider.notifier).getSyncedItem(update.task.taskId);
            if (syncItem != null && syncItem.videoFile.existsSync()) {
              final actualFileSize = await syncItem.videoFile.length();
              if (actualFileSize > 0) {
                print('[DEBUG] Updating file size for ${syncItem.id}: $actualFileSize');
                final updatedItem = syncItem.copyWith(fileSize: actualFileSize);
                await ref.read(syncProvider.notifier).updateItem(updatedItem);
              }
            }
          }
          
          ref.read(downloadTasksProvider(update.task.taskId).notifier).update((state) => DownloadStream.empty());
          ref
              .read(activeDownloadTasksProvider.notifier)
              .update((state) => state.where((element) => element.taskId != update.task.taskId).toList());

          ref.read(syncProvider.notifier).cleanupTemporaryFiles();
        }
      case TaskProgressUpdate():
        final progress = update.progress;
        
        // Try to update file size if we don't have it
        if (progress > 0) {
           final syncItem = await ref.read(syncProvider.notifier).getSyncedItem(update.task.taskId);
           if (syncItem != null && (syncItem.fileSize == null || syncItem.fileSize == 0)) {
               if (update.task is DownloadTask) {
                   final size = await (update.task as DownloadTask).expectedFileSize();
                   if (size > 0) {
                       print('[DEBUG] Updating missing file size for ${syncItem.id}: $size');
                       await ref.read(syncProvider.notifier).updateItem(syncItem.copyWith(fileSize: size));
                   }
               }
           }
        }

        // Debug log for progress updates
        print('[DEBUG] Download progress update: taskId=${update.task.taskId}, progress=${(progress * 100).toStringAsFixed(1)}%, speed=${update.networkSpeedAsString}');
        
        ref.read(downloadTasksProvider(update.task.taskId).notifier).update((state) {
            double newProgress = state.progress;
            if (progress >= 0 && progress <= 1) {
                newProgress = progress;
            }
            print('[DEBUG] Updating task state: oldProgress=${state.progress}, newProgress=$newProgress, status=${state.status}');
            return state.copyWith(
                progress: newProgress,
                downloadSpeed: update.networkSpeedAsString,
            );
        });

    }
  }

  void setMaxConcurrent(int value) {
    state.configure(
      globalConfig: globalConfig(value),
    );
  }

  void updateTranslations(BuildContext context) async {
    state.configureNotification(
      running: TaskNotification(context.localized.notificationDownloadingDownloading, '{displayName}\n{networkSpeed}'),
      complete: TaskNotification(context.localized.notificationDownloadingFinished, '{displayName}'),
      paused: TaskNotification(context.localized.notificationDownloadingPaused, '{displayName}'),
      error: TaskNotification(context.localized.notificationDownloadingError, '{displayName}'),
      progressBar: true,
    );
  }

  (String, dynamic) globalConfig(int value) => value == 0
      ? ("", "")
      : (
          Config.holdingQueue,
          (
            //maxConcurrent
            value,
            //maxConcurrentByHost
            value,
            //maxConcurrentByGroup
            value,
          ),
        );
}
