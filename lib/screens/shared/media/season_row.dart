import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kebap/models/items/season_model.dart';
import 'package:kebap/providers/sync/sync_provider_helpers.dart';
import 'package:kebap/screens/syncing/sync_button.dart';
import 'package:kebap/theme.dart';
import 'package:kebap/util/adaptive_layout/adaptive_layout.dart';
import 'package:kebap/util/kebap_image.dart';
import 'package:kebap/util/focus_provider.dart';
import 'package:kebap/util/item_base_model/item_base_model_extensions.dart';
import 'package:kebap/util/localization_helper.dart';
import 'package:kebap/util/refresh_state.dart';
import 'package:kebap/widgets/shared/clickable_text.dart';
import 'package:kebap/widgets/shared/horizontal_list.dart';
import 'package:kebap/widgets/shared/item_actions.dart';
import 'package:kebap/widgets/shared/modal_bottom_sheet.dart';
import 'package:kebap/widgets/shared/status_card.dart';

class SeasonsRow extends ConsumerWidget {
  final EdgeInsets contentPadding;
  final List<SeasonModel>? seasons;

  const SeasonsRow({
    super.key,
    required this.seasons,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 16),
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return HorizontalList(
      label: context.localized.season(seasons?.length ?? 1),
      items: seasons ?? [],
      height: AdaptiveLayout.poster(context).size,
      contentPadding: contentPadding,
      itemBuilder: (
        context,
        index,
      ) {
        final season = (seasons ?? [])[index];
        return SeasonPoster(
          season: season,
        );
      },
    );
  }
}

class SeasonPoster extends ConsumerWidget {
  final SeasonModel season;

  const SeasonPoster({required this.season, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myKey = key ?? UniqueKey();
    Padding placeHolder(String title) {
      return Padding(
        padding: const EdgeInsets.all(4),
        child: Container(
          child: Card(
            color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.65),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
        ),
      );
    }

    return AspectRatio(
      aspectRatio: 0.6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Hero(
              tag: myKey,
              child: FocusButton(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: KebapTheme.smallShape.borderRadius,
                    color: Theme.of(context).colorScheme.surfaceContainer,
                  ),
                  foregroundDecoration: KebapTheme.defaultPosterDecoration,
                  child: KebapImage(
                    image: season.getPosters?.primary ??
                        season.parentImages?.backDrop?.firstOrNull ??
                        season.parentImages?.primary,
                    placeHolder: placeHolder(season.name),
                  ),
                ),
                onSecondaryTapDown: (details) async {
                  Offset localPosition = details.globalPosition;
                  RelativeRect position =
                      RelativeRect.fromLTRB(localPosition.dx, localPosition.dy, localPosition.dx, localPosition.dy);
                  await showMenu(
                      context: context,
                      position: position,
                      items: season.generateActions(context, ref).popupMenuItems(useIcons: true));
                },
                onTap: () async {
                  await season.navigateTo(context, ref: ref, tag: myKey);
                  if (!context.mounted) return;
                  context.refreshData();
                },
                onLongPress: AdaptiveLayout.inputDeviceOf(context) == InputDevice.touch
                    ? () {
                        showBottomSheetPill(
                          context: context,
                          content: (context, scrollController) => ListView(
                            shrinkWrap: true,
                            controller: scrollController,
                            children: season.generateActions(context, ref).listTileItems(context, useIcons: true),
                          ),
                        );
                      }
                    : null,
                overlays: [
                  if (season.images?.primary == null)
                    Align(
                      alignment: Alignment.topLeft,
                      child: placeHolder(season.name),
                    ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ref.watch(syncedItemProvider(season)).when(
                              error: (error, stackTrace) => const SizedBox.shrink(),
                              data: (syncedItem) {
                                if (syncedItem == null) {
                                  return const SizedBox.shrink();
                                }
                                return StatusCard(
                                  child: SyncButton(item: season, syncedItem: syncedItem),
                                );
                              },
                              loading: () => const SizedBox.shrink(),
                            ),
                        if (season.userData.unPlayedItemCount != 0)
                          StatusCard(
                            color: Theme.of(context).colorScheme.primary,
                            child: Padding(
                              padding: const EdgeInsets.all(6),
                              child: Text(
                                season.userData.unPlayedItemCount.toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow.visible,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          )
                        else
                          Align(
                            alignment: Alignment.topRight,
                            child: StatusCard(
                              color: Theme.of(context).colorScheme.primary,
                              child: const Icon(
                                Icons.check_rounded,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
                focusedOverlays: [
                  if (AdaptiveLayout.inputDeviceOf(context) == InputDevice.pointer)
                    ExcludeFocus(
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: PopupMenuButton(
                          tooltip: context.localized.options,
                          icon: const Icon(Icons.more_vert, color: Colors.white),
                          itemBuilder: (context) => season.generateActions(context, ref).popupMenuItems(useIcons: true),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          ClickableText(
            text: season.localizedName(context),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
