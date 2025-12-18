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
  const MediaStreamInformation({
    required this.mediaStream,
    required this.onVersionIndexChanged,
    this.onAudioIndexChanged,
    this.onSubIndexChanged,
    this.focusNode,
    super.key,
  });

  final FocusNode? focusNode;

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
    // video stream presence is not used directly here, so skip computing it to avoid unused var
    final hasAnyAudioStreams = mediaStream.versionStreams.any((v) => v.audioStreams.isNotEmpty);
    final hasAnySubStreams = mediaStream.versionStreams.any((v) => v.subStreams.isNotEmpty);
    
    // Show audio/subtitle dropdowns if loading OR if any version has streams
    final showAudioDropdown = mediaStream.isLoading || hasAnyAudioStreams;
    final showSubDropdown = mediaStream.isLoading || hasAnySubStreams;
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
          // Stream Options
          if (mediaStream.versionStreams.length > 1)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: _StreamOptionSelect(
                label: const Icon(IconsaxPlusBold.cd),
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
          if (showAudioDropdown)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: _StreamOptionSelect(
                label: const Icon(IconsaxPlusBold.volume_high),
                current: mediaStream.isLoading 
                    ? context.localized.loading 
                    : (mediaStream.currentAudioStream?.extendedDisplayTitle ?? context.localized.none),
                isLoading: mediaStream.isLoading,
                itemBuilder: (context) => mediaStream.isLoading
                    ? []
                    : [AudioStreamModel.no(), ...mediaStream.audioStreams]
                        .map(
                          (e) => ItemActionButton(
                            selected: mediaStream.currentAudioStream?.index == e.index,
                            label: textWidget(
                              context,
                              label: e.extendedDisplayTitle,
                            ),
                            action: () => onAudioIndexChanged?.call(e.index),
                          ),
                        )
                        .toList(),
              ),
            ),
          if (showSubDropdown)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: _StreamOptionSelect(
                label: const Icon(IconsaxPlusBold.message_text_1),
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
    // Force use of FocusButton/BottomSheet logic to ensure keyboard navigation works reliably
    // even if the device reports as having a pointer (e.g. Linux desktop with mouse).
    // This fixes the issue where dropdowns were skipped during focus traversal.
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: LabelTitleItem(
        title: label,
        content: isLoading
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
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
              : SizedBox(
                  width: double.infinity,
                  child: Card(
                    color: itemList.length > 1 ? Theme.of(context).colorScheme.primaryContainer : Colors.transparent,
                    shadowColor: Colors.transparent,
                    elevation: 0,
                    child: FocusButton(
                            focusNode: focusNode,
                            darkOverlay: false,
                            onTap: () {
                              if (itemList.length > 1) {
                                showBottomSheetPill(
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
                              }
                            },
                            child: _buildDropdownContent(context, itemList),
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
                              ? Theme.of(context).colorScheme.onPrimaryContainer
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
