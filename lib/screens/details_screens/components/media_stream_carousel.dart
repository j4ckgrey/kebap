import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kebap/models/items/media_streams_model.dart';
import 'package:kebap/screens/details_screens/components/media_stream_information.dart';
import 'package:kebap/util/localization_helper.dart';

class MediaStreamCarousel extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
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
              context.localized.version,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 110,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: mediaStream.versionStreams.length,
              itemBuilder: (context, index) {
                final version = mediaStream.versionStreams[index];
                final isSelected = mediaStream.currentVersionStream == version;
                final parsed = parseVersionName(version.name);
                
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: _CarouselCard(
                    title: parsed.quality,
                    subtitle: parsed.filename,
                    isSelected: isSelected,
                    onTap: () => onVersionIndexChanged?.call(version.index),
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
              context.localized.audio,
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
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: mediaStream.audioStreams.length,
                itemBuilder: (context, index) {
                  final audio = mediaStream.audioStreams[index];
                  final isSelected = mediaStream.currentAudioStream?.index == audio.index;
                  
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: _CarouselCard(
                      title: audio.displayTitle,
                      isSelected: isSelected,
                      onTap: () => onAudioIndexChanged?.call(audio.index),
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
              context.localized.subtitles,
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
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
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
                        onTap: () => onSubIndexChanged?.call(noSub.index),
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
                      onTap: () => onSubIndexChanged?.call(sub.index),
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

class _CarouselCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool isSelected;
  final VoidCallback? onTap;

  const _CarouselCard({
    required this.title,
    this.subtitle,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 250,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primaryContainer
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                )
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected
                          ? Theme.of(context).colorScheme.onPrimaryContainer
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                overflow: TextOverflow.fade,
                softWrap: true,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Flexible(
                child: Text(
                  subtitle!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isSelected
                            ? Theme.of(context).colorScheme.onPrimaryContainer.withValues(alpha: 0.7)
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
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
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
