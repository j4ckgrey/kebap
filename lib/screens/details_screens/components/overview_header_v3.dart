import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kebap/models/items/images_models.dart';
import 'package:kebap/models/items/item_shared_models.dart';
import 'package:kebap/screens/shared/media/components/chip_button.dart';
import 'package:kebap/screens/shared/media/components/media_header.dart';
import 'package:kebap/screens/shared/media/components/small_detail_widgets.dart';
import 'package:kebap/util/adaptive_layout/adaptive_layout.dart';
import 'package:kebap/util/humanize_duration.dart';
import 'package:kebap/util/list_padding.dart';

class OverviewHeaderV3 extends ConsumerWidget {
  final String name;
  final ImagesData? image;
  final Widget? centerButtons;
  final EdgeInsets? padding;
  final String? subTitle;
  final String? originalTitle;
  final bool showImage;
  final Alignment logoAlignment;
  final Function()? onTitleClicked;
  final int? productionYear;
  final String? summary;
  final dynamic duration;
  final String? officialRating;
  final double? communityRating;
  final List<Studio> studios;
  final List<GenreItems> genres;
  final DateTime? premiereDate;

  const OverviewHeaderV3({
    required this.name,
    this.image,
    this.centerButtons,
    this.padding,
    this.subTitle,
    this.originalTitle,
    this.showImage = true,
    this.logoAlignment = Alignment.bottomCenter,
    this.onTitleClicked,
    this.productionYear,
    this.summary,
    this.duration,
    this.officialRating,
    this.communityRating,
    this.genres = const [],
    this.studios = const [],
    this.premiereDate,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mainStyle = Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
        );
    final subStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontSize: 18,
        );

    final crossAlignment =
        AdaptiveLayout.viewSizeOf(context) != ViewSize.phone ? CrossAxisAlignment.start : CrossAxisAlignment.stretch;

    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: crossAlignment,
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          if (showImage)
            ExcludeFocus(
              child: MediaHeader(
                name: name,
                logo: image?.logo,
                onTap: onTitleClicked,
                alignment: logoAlignment,
              ),
            ),
          ExcludeFocus(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: crossAlignment,
              children: [
                if (subTitle != null)
                  Text(
                    subTitle ?? "",
                    textAlign: TextAlign.center,
                    style: mainStyle,
                  ),
                if (name.toLowerCase() != originalTitle?.toLowerCase() && originalTitle != null)
                  Text(
                    originalTitle.toString(),
                    textAlign: TextAlign.center,
                    style: subStyle,
                  ),
              ].addInBetween(const SizedBox(height: 4)),
            ),
          ),
          ExcludeFocus(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: crossAlignment,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  direction: Axis.horizontal,
                  alignment: WrapAlignment.center,
                  runAlignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    if (officialRating != null)
                      ChipButton(
                        label: officialRating.toString(),
                      ),
                    if (productionYear != null)
                      ChipButton(
                        label: productionYear.toString(),
                      ),
                    Builder(
                      builder: (context) {
                        Duration? d;
                        if (duration is int) {
                          d = Duration(microseconds: (duration as int) * 10);
                        } else if (duration is Duration) {
                          d = duration;
                        }
                        if (d != null && d.inSeconds > 1) {
                          return ChipButton(
                            label: d.humanize.toString(),
                            backgroundColor: Colors.green,
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    if (communityRating != null)
                      ChipButton(
                        label: '★ ${communityRating?.toStringAsFixed(1)}',
                        backgroundColor: Colors.amber,
                      ),
                    if (premiereDate != null)
                      ChipButton(
                        label: "${premiereDate!.day}.${premiereDate!.month}.${premiereDate!.year}",
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                  ],
                ),
                if (summary?.isNotEmpty == true)
                  Text(
                    summary ?? "",
                    style: Theme.of(context).textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                if (genres.isNotEmpty)
                  Genres(
                    genres: genres.take(6).toList(),
                  ),
              ].addInBetween(const SizedBox(height: 10)),
            ),
          ),
          if (AdaptiveLayout.viewSizeOf(context) <= ViewSize.phone) ...[
            if (centerButtons != null) centerButtons!,
          ] else
            if (centerButtons != null) centerButtons!,
        ],
      ),
    );
  }
}
