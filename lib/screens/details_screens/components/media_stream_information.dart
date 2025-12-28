import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import 'package:kebap/models/items/media_streams_model.dart';
import 'package:kebap/models/settings/media_stream_view_type.dart';
import 'package:kebap/providers/settings/media_stream_view_type_provider.dart';
import 'package:kebap/screens/details_screens/components/label_title_item.dart';
import 'package:kebap/screens/details_screens/components/media_stream_carousel.dart';
import 'package:kebap/util/focus_provider.dart';
import 'package:kebap/util/localization_helper.dart';
import 'package:kebap/util/size_formatting.dart';
// removed unused import
import 'package:kebap/widgets/shared/item_actions.dart';
import 'package:kebap/widgets/shared/modal_bottom_sheet.dart';

class ParsedVersionName {
  final String quality;
  final String filename;
  
  ParsedVersionName({required this.quality, required this.filename});
}

ParsedVersionName parseVersionName(String name) {
  return ParsedVersionName(quality: name, filename: "");
}

class MediaStreamInformation extends ConsumerWidget {
  final MediaStreamsModel mediaStream;
  final Function(int index)? onVersionIndexChanged;
  final Function(int index)? onAudioIndexChanged;
  final Function(int index)? onSubIndexChanged;
  final FocusNode? focusNode; // Version dropdown focus
  final FocusNode? audioFocusNode; // Audio dropdown focus
  final FocusNode? subFocusNode; // Subtitle dropdown focus
  
  const MediaStreamInformation({
    required this.mediaStream,
    required this.onVersionIndexChanged,
    this.onAudioIndexChanged,
    this.onSubIndexChanged,
    this.focusNode,
    this.audioFocusNode,
    this.subFocusNode,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('[MediaStreamInfo] build - versionStreamIndex: ${mediaStream.versionStreamIndex}');
    debugPrint('[MediaStreamInfo] build - currentVersionStream: ${mediaStream.currentVersionStream?.name}');
    debugPrint('[MediaStreamInfo] build - audioStreams.length: ${mediaStream.audioStreams.length}');
    debugPrint('[MediaStreamInfo] build - subStreams.length: ${mediaStream.subStreams.length}');
    
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
    // video stream presence is not used directly here, so skip computing it to avoid unused var
    final hasAnyAudioStreams = mediaStream.versionStreams.any((v) => v.audioStreams.isNotEmpty);
    final hasAnySubStreams = mediaStream.versionStreams.any((v) => v.subStreams.isNotEmpty);
    
    // Show audio/subtitle dropdowns if loading OR if any version has streams
    final showAudioDropdown = mediaStream.isLoading || hasAnyAudioStreams;
    final showSubDropdown = mediaStream.isLoading || hasAnySubStreams;
    
    return LayoutBuilder(
      builder: (context, constraints) {
        debugPrint('[MediaStreamInfo] build constraints: $constraints');
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
          // Stream Options - Always show
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: _StreamOptionSelect(
              focusNode: focusNode,
              label: const Icon(IconsaxPlusBold.cd),
              isLoading: mediaStream.isLoading && mediaStream.versionStreams.isEmpty,
              current: mediaStream.isLoading && mediaStream.versionStreams.isEmpty ? context.localized.loading : null,
              currentQuality: parseVersionName(mediaStream.currentVersionStream?.name ?? "").quality,
              currentFilename: "${mediaStream.currentVersionStream?.size.byteFormat ?? ''}",
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
                            "${e.size.byteFormat ?? ''}",
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
          ),
          // Audio Options - Always show
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: _StreamOptionSelect(
              focusNode: audioFocusNode,
              label: const Icon(IconsaxPlusBold.volume_high),
              current: mediaStream.isLoading 
                  ? context.localized.loading 
                  : (mediaStream.currentAudioStream?.displayTitle ?? context.localized.none),
              // Treat as loading if global loading is true, OR if we have versions but no audio/subs yet (masking the 'None' flash)
              isLoading: mediaStream.isLoading || (mediaStream.versionStreams.isNotEmpty && mediaStream.audioStreams.isEmpty),
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
          ),
          // Subtitle Options - Always show
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: _StreamOptionSelect(
              focusNode: subFocusNode,
              label: const Icon(IconsaxPlusBold.message_text_1),
              current: mediaStream.isLoading
                  ? context.localized.loading
                  : (mediaStream.currentSubStream?.displayTitle ?? context.localized.none),
              // Treat as loading if global loading is true, OR if we have versions but no audio/subs yet
              isLoading: mediaStream.isLoading || (mediaStream.versionStreams.isNotEmpty && mediaStream.subStreams.isEmpty),
              itemBuilder: (context) => mediaStream.isLoading
                  ? []
                  : [
                      SubStreamModel.no(), 
                      ...mediaStream.subStreams.where((s) => 
                        s.index != -1 && 
                        s.name.toLowerCase() != 'off' && 
                        s.name.toLowerCase() != 'none' &&
                        !s.displayTitle.toLowerCase().contains('none') // Extra safety
                      )
                    ]
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
          ),
          ],
        );
      },
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
  final Widget label;
  final String? current;
  final String? currentQuality;
  final String? currentFilename;
  final bool isLoading;
  final List<ItemAction> Function(BuildContext context) itemBuilder;
  final FocusNode? focusNode;
  const _StreamOptionSelect({
    required this.label,
    this.current,
    this.currentQuality,
    this.currentFilename,
    this.isLoading = false,
    required this.itemBuilder,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    final itemList = itemBuilder(context);
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: LabelTitleItem(
        title: label,
        content: SizedBox(
          width: double.infinity,
          child: Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            shadowColor: Colors.transparent,
            elevation: 0,
            child: FocusButton(
              focusNode: focusNode,
              darkOverlay: false,
              onTap: () async {
                if (!isLoading && itemList.length > 1) {
                  // Show bottom sheet and wait for it to close
                  await showBottomSheetPill(
                    context: context,
                    content: (context, scrollController) => ListView(
                      shrinkWrap: true,
                      controller: scrollController,
                      children: [
                        const SizedBox(height: 6),
                        ...itemList.map((e) => e.toListItem(context)),
                      ],
                    ),
                  );
                  // Focus restore AFTER all rebuilds complete (including async stream data)
                  // Need to wait longer because: 
                  // 1. Version change triggers immediate rebuild
                  // 2. Stream data fetch triggers another rebuild when complete
                  if (focusNode != null) {
                    // Wait for widget tree to stabilize after all async updates
                    Future.delayed(const Duration(milliseconds: 500), () {
                      if (focusNode!.canRequestFocus) {
                        focusNode!.requestFocus();
                        debugPrint('[FocusDebug] Dropdown focus restored (delayed 500ms)');
                      }
                    });
                  }
                }
              },
              child: _buildContent(context, itemList),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, List<ItemAction> itemList) {
    final onPrimary = Theme.of(context).colorScheme.onPrimaryContainer;

    // Loading State
    if (isLoading) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), // Match loaded padding
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 40), // Standard height
          child: Row(
            children: [
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: onPrimary,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  current ?? currentQuality ?? context.localized.loading,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: onPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    
    // Loaded State
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 40), // Standard height
        child: Row(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: currentQuality != null && currentFilename != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            currentQuality!,
                            textAlign: TextAlign.start,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: onPrimary,
                            ),
                          ),
                          Text(
                            currentFilename!,
                            textAlign: TextAlign.start,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: onPrimary.withValues(alpha: 0.8),
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
                          color: onPrimary,
                        ),
                      ),
              ),
            ),
            if (itemList.length > 1) ...[
              const SizedBox(width: 8),
              Icon(
                Icons.keyboard_arrow_down,
                color: onPrimary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
