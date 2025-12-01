import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dart:math' as math;

import 'package:kebap/models/items/media_streams_model.dart';
import 'package:kebap/screens/details_screens/components/media_stream_information.dart';
import 'package:kebap/util/localization_helper.dart';
import 'package:kebap/util/size_formatting.dart';

class MediaStreamCarousel extends ConsumerStatefulWidget {
  final MediaStreamsModel mediaStream;
  final Function(int index)? onVersionIndexChanged;
  final Function(int index)? onAudioIndexChanged;
  final Function(int index)? onSubIndexChanged;
  
  const MediaStreamCarousel({
    required this.mediaStream,
    required this.onVersionIndexChanged,
    this.onAudioIndexChanged,
    this.onSubIndexChanged,
    super.key,
  });

  @override
  ConsumerState<MediaStreamCarousel> createState() => _MediaStreamCarouselState();
}

class _MediaStreamCarouselState extends ConsumerState<MediaStreamCarousel> {
  int? _focusedVersionIndex;
  int? _focusedAudioIndex;
  int? _focusedSubIndex;

  @override
  Widget build(BuildContext context) {
    final mediaStream = widget.mediaStream;
    final hasAnyAudioStreams = mediaStream.versionStreams.any((v) => v.audioStreams.isNotEmpty);
    final hasAnySubStreams = mediaStream.versionStreams.any((v) => v.subStreams.isNotEmpty);
    
    // Show audio/subtitle carousels if loading OR if any version has streams
    final showAudioCarousel = mediaStream.isLoading || hasAnyAudioStreams;
    final showSubCarousel = mediaStream.isLoading || hasAnySubStreams;
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Versions carousel
        if (mediaStream.versionStreams.length > 1) ...[
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
            child: Text(
              "${context.localized.version} (${(_focusedVersionIndex ?? mediaStream.versionStreams.indexWhere((v) => mediaStream.currentVersionStream == v)).clamp(0, mediaStream.versionStreams.length - 1) + 1}/${mediaStream.versionStreams.length})",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 110,
            child: _CarouselSection(
              itemCount: mediaStream.versionStreams.length,
              itemBuilder: (context, index) {
                final version = mediaStream.versionStreams[index];
                final isSelected = mediaStream.currentVersionStream == version;
                final parsed = parseVersionName(version.name);
                
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: _CarouselCard(
                    title: parsed.quality,
                    subtitle: "${parsed.filename}${version.size.byteFormat != null ? ' • ${version.size.byteFormat}' : ''}",
                    isSelected: isSelected,
                    onTap: () => widget.onVersionIndexChanged?.call(version.index),
                    onFocused: (value) {
                      if (value) setState(() => _focusedVersionIndex = index);
                    },
                  ),
                );
              },
            ),
          ),
        ],
        
        // Audio carousel
        if (showAudioCarousel) ...[
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
            child: Text(
              "${context.localized.audio} (${mediaStream.isLoading ? '...' : '${(_focusedAudioIndex ?? mediaStream.audioStreams.indexWhere((a) => mediaStream.currentAudioStream?.index == a.index)).clamp(0, math.max(0, mediaStream.audioStreams.length - 1)) + 1}/${mediaStream.audioStreams.length}'})",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (mediaStream.isLoading)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _LoadingCard(label: context.localized.loading),
            )
          else
            SizedBox(
              height: 75,
              child: _CarouselSection(
                itemCount: mediaStream.audioStreams.length,
                itemBuilder: (context, index) {
                  final audio = mediaStream.audioStreams[index];
                  final isSelected = mediaStream.currentAudioStream?.index == audio.index;
                  
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: _CarouselCard(
                      title: audio.displayTitle,
                      isSelected: isSelected,
                      onTap: () => widget.onAudioIndexChanged?.call(audio.index),
                      onFocused: (value) {
                        if (value) setState(() => _focusedAudioIndex = index);
                      },
                    ),
                  );
                },
              ),
            ),
        ],
        
        // Subtitles carousel
        if (showSubCarousel) ...[
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
            child: Text(
              "${context.localized.subtitles} (${mediaStream.isLoading ? '...' : '${(_focusedSubIndex ?? (mediaStream.currentSubStream == null ? 0 : mediaStream.subStreams.indexWhere((s) => mediaStream.currentSubStream?.index == s.index) + 1)).clamp(0, mediaStream.subStreams.length)}/${mediaStream.subStreams.length + 1}'})",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (mediaStream.isLoading)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _LoadingCard(label: context.localized.loading),
            )
          else
            SizedBox(
              height: 75,
              child: _CarouselSection(
                itemCount: mediaStream.subStreams.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    // "None" option
                    final noSub = SubStreamModel.no();
                    // Selected if currentSubStream is null OR index is -1
                    final isSelected = mediaStream.currentSubStream == null || 
                                     mediaStream.currentSubStream?.index == -1 ||
                                     mediaStream.defaultSubStreamIndex == -1;
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: _CarouselCard(
                        title: context.localized.none,
                        isSelected: isSelected,
                        onTap: () => widget.onSubIndexChanged?.call(noSub.index),
                        onFocused: (value) {
                          if (value) setState(() => _focusedSubIndex = index);
                        },
                      ),
                    );
                  }
                  
                  final sub = mediaStream.subStreams[index - 1];
                  final isSelected = mediaStream.currentSubStream?.index == sub.index;
                  
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: _CarouselCard(
                      title: sub.displayTitle,
                      isSelected: isSelected,
                      onTap: () => widget.onSubIndexChanged?.call(sub.index),
                      onFocused: (value) {
                        if (value) setState(() => _focusedSubIndex = index);
                      },
                    ),
                  );
                },
              ),
            ),
        ],
        const SizedBox(height: 16),
      ],
    );
  }
}

class _CarouselCard extends StatefulWidget {
  final String title;
  final String? subtitle;
  final bool isSelected;
  final VoidCallback? onTap;
  final ValueChanged<bool>? onFocused;

  const _CarouselCard({
    required this.title,
    this.subtitle,
    required this.isSelected,
    this.onTap,
    this.onFocused,
  });

  @override
  State<_CarouselCard> createState() => _CarouselCardState();
}

class _CarouselCardState extends State<_CarouselCard> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final isSelected = widget.isSelected;
    final isFocused = _isFocused;

    return InkWell(
      onTap: widget.onTap,
      onFocusChange: (value) {
        setState(() => _isFocused = value);
        widget.onFocused?.call(value);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 250,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.green
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: isFocused
              ? Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 3,
                )
              : null,
          boxShadow: isFocused
              ? [
                  BoxShadow(
                    color: Theme.of(context).shadowColor.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                widget.title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: isSelected || isFocused ? FontWeight.bold : FontWeight.normal,
                      color: isSelected
                          ? Colors.white
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                overflow: TextOverflow.fade,
                softWrap: true,
              ),
            ),
            if (widget.subtitle != null) ...[
              const SizedBox(height: 4),
              Flexible(
                child: Text(
                  widget.subtitle!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isSelected
                            ? Colors.white70
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                  overflow: TextOverflow.fade,
                  softWrap: true,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _LoadingCard extends StatelessWidget {
  final String label;

  const _LoadingCard({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}

class _CarouselSection extends StatefulWidget {
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  const _CarouselSection({
    required this.itemCount,
    required this.itemBuilder,
  });

  @override
  State<_CarouselSection> createState() => _CarouselSectionState();
}

class _CarouselSectionState extends State<_CarouselSection> {
  final FocusNode _parentNode = FocusNode();

  @override
  void dispose() {
    _parentNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _parentNode,
      skipTraversal: true,
      child: FocusTraversalGroup(
        policy: _CarouselFocusPolicy(parentNode: _parentNode),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: widget.itemCount,
          itemBuilder: widget.itemBuilder,
        ),
      ),
    );
  }
}

class _CarouselFocusPolicy extends WidgetOrderTraversalPolicy {
  final FocusNode parentNode;

  _CarouselFocusPolicy({required this.parentNode});

  @override
  bool inDirection(FocusNode currentNode, TraversalDirection direction) {
    if (direction != TraversalDirection.left && direction != TraversalDirection.right) {
      return super.inDirection(currentNode, direction);
    }

    final sortedNodes = parentNode.descendants
        .where((n) => n.canRequestFocus && n.context != null)
        .toList()
      ..sort((a, b) => a.rect.left.compareTo(b.rect.left));

    final index = sortedNodes.indexOf(currentNode);

    if (index == -1) return super.inDirection(currentNode, direction);

    if (direction == TraversalDirection.left) {
      if (index == 0) {
        return true; // Block left on first item
      }
    } else if (direction == TraversalDirection.right) {
      if (index == sortedNodes.length - 1) {
        return true; // Block right on last item
      }
    }

    return super.inDirection(currentNode, direction);
  }
}
