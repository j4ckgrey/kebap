import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';

import 'package:background_downloader/background_downloader.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import 'package:kebap/models/syncing/download_stream.dart';
import 'package:kebap/providers/settings/client_settings_provider.dart';
import 'package:kebap/providers/sync_provider.dart';
import 'package:kebap/util/localization_helper.dart';



final itemDownloadGroup = "ITEM_DOWNLOAD_GROUP";

final backgroundDownloaderProvider = NotifierProvider<BackgroundDownloaderNotifier, FileDownloader?>(BackgroundDownloaderNotifier.new);

class BackgroundDownloaderNotifier extends Notifier<FileDownloader?> {
  late StreamSubscription<TaskUpdate> updateListener;

  @override
  FileDownloader? build() {
    ref.onDispose(
      () => updateListener.cancel(),
    );
    
    // On Web, return a dummy or handle differently, as FileDownloader might use Platform calls
    if (kIsWeb) {
      // We can return a FileDownloader, but we must be careful. 
      // The error trace suggests 'instance' access in base_downloader triggers Platform check.
      // If the package supports web, it should handle this. 
      // Assuming for now we disable background downloader logic on web to prevent crash.
      // We return the singleton instance which might be safe if configured correctly, 
      // OR we just assume it won't be used. 
      // BUT the provider returns FileDownloader.
      // Let's rely on the fact that we can't fix the library, so we guard where possible.
      // Actually, looking at the logs: Unsupported operation: Platform._operatingSystem
      // This happens during 'build'.
      
      // If we cannot instantiate FileDownloader safely on Web due to library bug, we might need a dummy wrapper?
      // Since we can't change the return type easily without breaking consumers...
      // Let's try to just NOT configure it if on web, or return the default instance if it's safe.
      // But 'FileDownloader()' creates an instance.
      
      // Warning: If FileDownloader() constructor fails, we are stuck.
      // The log says: `new (package:background_downloader/src/file_downloader.dart:61:35)` -> `_internal` -> `instance` -> `Platform._operatingSystem`.
      // This means JUST creating `new FileDownloader()` crashes on Web.
      
      // We must Throw or return null? But return type is FileDownloader.
      // We can throw an UnimplementedError, but that might crash the app if watched.
      // Better to modify the code to not use this provider on Web? 
      // Or we can try to return a mocked version? We can't mock easily here.
      
      // Implementation hack: The user is likely not needing background downloads on Web.
      // We will create a fake class if possible? No, we need to return FileDownloader.
      
      // Wait, is there a web implementation? The package says it supports all platforms.
      // Maybe we need to wait for the package to fix it, or we are using an old version?
      // Version is ^9.2.3.
      
      // Let's assume we can't use it on Web.
      // If we can't use it, we should avoid calling this provider on Web.
      // But `SyncProvider` or others might read it.
      
      // Let's try to guard:
      // If kIsWeb, we throw or return something safe?
      // We can't avoid the crash if the library crashes in constructor.
      // Wait, we can import `crypto`? No.
      
      // We will try to wrap it in a try-catch and return a dummy if possible?
      // But `FileDownloader` is a class.
      
      return null;
    }

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
    state?.configure(
      globalConfig: globalConfig(value),
    );
  }

  void updateTranslations(BuildContext context) async {
    state?.configureNotification(
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
