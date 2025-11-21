import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fladder/models/items/media_streams_model.dart';
import 'package:fladder/models/settings/media_stream_view_type.dart';
import 'package:fladder/providers/settings/media_stream_view_type_provider.dart';
import 'package:fladder/screens/details_screens/components/label_title_item.dart';
import 'package:fladder/screens/details_screens/components/media_stream_carousel.dart';
import 'package:fladder/util/adaptive_layout/adaptive_layout.dart';
import 'package:fladder/util/focus_provider.dart';
import 'package:fladder/util/localization_helper.dart';
import 'package:fladder/widgets/shared/enum_selection.dart';
import 'package:fladder/widgets/shared/item_actions.dart';
import 'package:fladder/widgets/shared/modal_bottom_sheet.dart';

class ParsedVersionName {
  final String quality;
  final String filename;
  
  ParsedVersionName({required this.quality, required this.filename});
}

ParsedVersionName parseVersionName(String name) {
  // Extract filename (after folder emoji)
  String filename = name;
  final parts = name.split('📁');
  if (parts.length > 1) {
    filename = parts.last.trim();
  } else {
    // Fallback: remove all emojis for filename
    filename = name.replaceAll(RegExp(r'[\u{1F300}-\u{1F9FF}]|[\u{2600}-\u{26FF}]|[\u{2700}-\u{27BF}]', unicode: true), '').trim();
  }
  
  // Extract quality information from the full name (before filename)
  final qualityPart = parts.length > 1 ? parts.first : '';
  
  // Extract resolution (2160p, 1080p, 720p, etc.)
  final resolutionMatch = RegExp(r'\b(\d{3,4}p)\b', caseSensitive: false).firstMatch(name);
  final resolution = resolutionMatch?.group(1) ?? '';
  
  // Extract quality markers (WEB-DL, BluRay, WEBRip, etc.)
  final qualityMatch = RegExp(r'\b(WEB-DL|BluRay|WEBRip|HDRip|DVDRip|BDRip)\b', caseSensitive: false).firstMatch(name);
  final qualityType = qualityMatch?.group(1) ?? '';
  
  // Extract codec (HEVC, AVC, x265, x264, etc.)
  final codecMatch = RegExp(r'\b(HEVC|AVC|x265|x264|H\.?265|H\.?264)\b', caseSensitive: false).firstMatch(name);
  final codec = codecMatch?.group(1) ?? '';
  
  // Extract HDR info
  final hdrMatch = RegExp(r'\b(HDR10\+|HDR10|HDR|DV|Dolby Vision)\b', caseSensitive: false).firstMatch(name);
  final hdr = hdrMatch?.group(1) ?? '';
  
  // Build quality string
  final qualityParts = [resolution, qualityType, codec, hdr]
      .where((s) => s.isNotEmpty)
      .toList();
  
  final quality = qualityParts.isNotEmpty ? qualityParts.join(' · ') : 'Unknown';
  
  return ParsedVersionName(quality: quality, filename: filename);
}

class MediaStreamInformation extends ConsumerWidget {
  final MediaStreamsModel mediaStream;
  final Function(int index)? onVersionIndexChanged;
  final Function(int index)? onAudioIndexChanged;
  final Function(int index)? onSubIndexChanged;
  const MediaStreamInformation({
    required this.mediaStream,
    required this.onVersionIndexChanged,
    this.onAudioIndexChanged,
    this.onSubIndexChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewType = ref.watch(mediaStreamViewTypeProvider);
    
    // Use carousel if setting is enabled
    if (viewType == MediaStreamViewType.carousel) {
      return MediaStreamCarousel(
        mediaStream: mediaStream,
        onVersionIndexChanged: onVersionIndexChanged,
        onAudioIndexChanged: onAudioIndexChanged,
        onSubIndexChanged: onSubIndexChanged,
      );
    }
    
    // Otherwise use dropdown (default)
    // Check if ANY version has streams (used to keep dropdowns visible while fetching)
    final hasAnyVideoStreams = mediaStream.versionStreams.any((v) => v.videoStreams.isNotEmpty);
    final hasAnyAudioStreams = mediaStream.versionStreams.any((v) => v.audioStreams.isNotEmpty);
    final hasAnySubStreams = mediaStream.versionStreams.any((v) => v.subStreams.isNotEmpty);
    
    // Show audio/subtitle dropdowns if loading OR if any version has streams
    final showAudioDropdown = mediaStream.isLoading || hasAnyAudioStreams;
    final showSubDropdown = mediaStream.isLoading || hasAnySubStreams;
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (mediaStream.versionStreams.length > 1)
          _StreamOptionSelect(
            label: Text(context.localized.version),
            currentQuality: parseVersionName(mediaStream.currentVersionStream?.name ?? "").quality,
            currentFilename: parseVersionName(mediaStream.currentVersionStream?.name ?? "").filename,
            itemBuilder: (context) => mediaStream.versionStreams
                .map((e) {
                  final parsed = parseVersionName(e.name);
                  return ItemActionButton(
                    selected: mediaStream.currentVersionStream == e,
                    label: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          parsed.quality,
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          parsed.filename,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    action: () {
                      onVersionIndexChanged?.call(e.index);
                    },
                  );
                }).toList(),
          ),
        if (showAudioDropdown)
          _StreamOptionSelect(
            label: Text(context.localized.audio),
            current: mediaStream.isLoading 
                ? context.localized.loading 
                : (mediaStream.currentAudioStream?.displayTitle ?? context.localized.none),
            isLoading: mediaStream.isLoading,
            itemBuilder: (context) => mediaStream.isLoading
                ? []
                : [AudioStreamModel.no(), ...mediaStream.audioStreams]
                    .map(
                      (e) => ItemActionButton(
                        selected: mediaStream.currentAudioStream?.index == e.index,
                        label: textWidget(
                          context,
                          label: e.displayTitle,
                        ),
                        action: () => onAudioIndexChanged?.call(e.index),
                      ),
                    )
                    .toList(),
          ),
        if (showSubDropdown)
          _StreamOptionSelect(
            label: Text(context.localized.subtitles),
            current: mediaStream.isLoading
                ? context.localized.loading
                : (mediaStream.currentSubStream?.displayTitle ?? context.localized.none),
            isLoading: mediaStream.isLoading,
            itemBuilder: (context) => mediaStream.isLoading
                ? []
                : [SubStreamModel.no(), ...mediaStream.subStreams]
                    .map(
                      (e) => ItemActionButton(
                        selected: mediaStream.currentSubStream?.index == e.index,
                        label: textWidget(
                          context,
                          label: e.displayTitle,
                        ),
                        action: () => onSubIndexChanged?.call(e.index),
                      ),
                    )
                    .toList(),
          ),
      ],
    );
  }

  Widget textWidget(BuildContext context, {required String label}) {
    return Text(
      label,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }
}

class _StreamOptionSelect<T> extends StatelessWidget {
  final Text label;
  final String? current;
  final String? currentQuality;
  final String? currentFilename;
  final bool isLoading;
  final List<ItemAction> Function(BuildContext context) itemBuilder;
  const _StreamOptionSelect({
    required this.label,
    this.current,
    this.currentQuality,
    this.currentFilename,
    this.isLoading = false,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final itemList = itemBuilder(context);
    final useBottomSheet = AdaptiveLayout.inputDeviceOf(context) != InputDevice.pointer;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: LabelTitleItem(
        title: label,
        content: Expanded(
          child: isLoading
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        current ?? currentQuality ?? '',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                )
              : Card(
                  color: itemList.length > 1 ? Theme.of(context).colorScheme.primaryContainer : Colors.transparent,
                  shadowColor: Colors.transparent,
                  elevation: 0,
                  child: useBottomSheet
                      ? FocusButton(
                          darkOverlay: false,
                          onTap: itemList.length > 1
                              ? () => showBottomSheetPill(
                                    context: context,
                                    content: (context, scrollController) => ListView(
                                      shrinkWrap: true,
                                      controller: scrollController,
                                      children: [
                                        const SizedBox(height: 6),
                                        ...itemList.map((e) => e.toListItem(context)),
                                      ],
                                    ),
                                  )
                              : null,
                          child: _buildDropdownContent(context, itemList),
                        )
                      : LayoutBuilder(
                          builder: (context, constraints) => PopupMenuButton(
                            tooltip: '',
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            enabled: itemList.length > 1,
                            itemBuilder: (context) => itemList.map((e) => e.toPopupMenuItem()).toList(),
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(
                              minWidth: constraints.maxWidth,
                              maxWidth: constraints.maxWidth,
                            ),
                            child: _buildDropdownContent(context, itemList),
                          ),
                        ),
                ),
        ),
      ),
    );
  }

  Widget _buildDropdownContent(BuildContext context, List<ItemAction> itemList) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: currentQuality != null && currentFilename != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        currentQuality!,
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: itemList.length > 1 ? Theme.of(context).colorScheme.onPrimaryContainer : null,
                        ),
                      ),
                      Text(
                        currentFilename!,
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: itemList.length > 1 
                              ? Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.7)
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  )
                : Text(
                    current ?? '',
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: itemList.length > 1 ? Theme.of(context).colorScheme.onPrimaryContainer : null,
                    ),
                  ),
          ),
          if (itemList.length > 1) ...[
            const SizedBox(width: 8),
            Icon(
              Icons.keyboard_arrow_down,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ],
        ],
      ),
    );
  }
}
