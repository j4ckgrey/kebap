import 'package:flutter/material.dart';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:palette_generator_master/palette_generator_master.dart';

import 'package:kebap/models/item_base_model.dart';
import 'package:kebap/models/items/images_models.dart';
import 'package:kebap/providers/settings/client_settings_provider.dart';
import 'package:kebap/shaders/fade_edges.dart';
import 'package:kebap/util/adaptive_layout/adaptive_layout.dart';
import 'package:kebap/util/kebap_image.dart';
import 'package:kebap/widgets/navigation_scaffold/components/navigation_body.dart';
import 'package:kebap/widgets/shared/item_actions.dart';
import 'package:kebap/widgets/shared/pull_to_refresh.dart';
import 'package:kebap/util/focus_provider.dart';

Future<Color?> getDominantColor(ImageProvider imageProvider) async {
  final paletteGenerator = await PaletteGeneratorMaster.fromImageProvider(
    imageProvider,
    size: const Size(200, 200),
    maximumColorCount: 20,
  );

  return paletteGenerator.dominantColor?.color;
}

class DetailScaffold extends ConsumerStatefulWidget {
  final String label;
  final ItemBaseModel? item;
  final List<ItemAction>? Function(BuildContext context)? actions;
  final Color? backgroundColor;
  final ImagesData? backDrops;
  final Function(EdgeInsets padding) content;
  final Future<void> Function()? onRefresh;
  const DetailScaffold({
    required this.label,
    this.item,
    this.actions,
    this.backgroundColor,
    required this.content,
    this.backDrops,
    this.onRefresh,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DetailScaffoldState();
}

class _DetailScaffoldState extends ConsumerState<DetailScaffold> {
  List<ImageData>? lastImages;
  ImageData? backgroundImage;
  Color? dominantColor;

  ImageProvider? _lastRequestedImage;

  @override
  void didUpdateWidget(covariant DetailScaffold oldWidget) {
    super.didUpdateWidget(oldWidget);
    updateImage();
    _updateDominantColor();
  }

  void updateImage() {
    print("[DETAIL_SCAFFOLD] updateImage called. LastImages: ${lastImages?.length}, NewImages: ${widget.backDrops?.backDrop?.length}");
    if (lastImages == null ||
        (lastImages!.isEmpty && widget.backDrops?.backDrop?.isNotEmpty == true)) {
      // log("[DETAIL_SCAFFOLD] Updating background image!");
      lastImages = widget.backDrops?.backDrop;
      backgroundImage = widget.backDrops?.randomBackDrop;
      // log("[DETAIL_SCAFFOLD] Selected background: ${backgroundImage?.key}");
    } else {
       // log("[DETAIL_SCAFFOLD] Update skipped.");
    }
  }

  Future<void> _updateDominantColor() async {
    if (!ref.read(clientSettingsProvider.select((value) => value.deriveColorsFromItem))) return;
    final newImage = widget.item?.getPosters?.logo;
    if (newImage == null) return;

    final provider = newImage.imageProvider;
    _lastRequestedImage = provider;

    final newColor = await getDominantColor(provider);

    if (!mounted || _lastRequestedImage != provider) return;

    setState(() {
      dominantColor = newColor;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final padding = EdgeInsets.symmetric(horizontal: size.width / 25);
    final backGroundColor = Theme.of(context).colorScheme.surface.withValues(alpha: 0.8);
    final minHeight = 450.0.clamp(0, size.height).toDouble();
    final maxHeight = size.height - 10;
    final newColorScheme = dominantColor != null
        ? ColorScheme.fromSeed(
            seedColor: dominantColor!,
            brightness: Theme.brightnessOf(context),
            dynamicSchemeVariant: ref.watch(clientSettingsProvider.select((value) => value.schemeVariant)),
          )
        : null;
    final amoledBlack = ref.watch(clientSettingsProvider.select((value) => value.amoledBlack));
    final amoledOverwrite = amoledBlack ? Colors.black : null;
    return Theme(
      data: Theme.of(context)
          .copyWith(
            colorScheme: newColorScheme,
          )
          .copyWith(
            scaffoldBackgroundColor: amoledOverwrite,
            cardColor: amoledOverwrite,
            canvasColor: amoledOverwrite,
            colorScheme: newColorScheme?.copyWith(
              surface: amoledOverwrite,
              surfaceContainerHighest: amoledOverwrite,
              surfaceContainerLow: amoledOverwrite,
            ),
          ),
      child: Builder(builder: (context) {
        return PullToRefresh(
          onRefresh: () async {
            await widget.onRefresh?.call();
            if (context.mounted) {
              setState(() {
                if (widget.backDrops?.backDrop?.contains(backgroundImage) == true) {
                  backgroundImage = widget.backDrops?.randomBackDrop;
                }
              });
            }
          },
          refreshOnStart: true,
          child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.surface,
            extendBodyBehindAppBar: true,
            body: Stack(
              children: [
                SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Stack(
                    children: [
                      SizedBox(
                        height: maxHeight,
                        width: size.width,
                        child: KebapImage(
                          image: backgroundImage,
                          blurOnly: true,
                        ),
                      ),
                      if (backgroundImage != null)
                        Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: AdaptiveLayout.layoutModeOf(context) != LayoutMode.single ? 25.0 : 0.0,
                            ),
                            child: FadeEdges(
                              leftFade: AdaptiveLayout.layoutModeOf(context) != LayoutMode.single ? 0.05 : 0.0,
                              bottomFade: 0.3,
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minWidth: double.infinity,
                                  minHeight: minHeight - 20,
                                  maxHeight: maxHeight.clamp(minHeight, 2500) - 20,
                                ),
                                child: FadeInImage(
                                  placeholder: ResizeImage(
                                    backgroundImage!.imageProvider,
                                    height: maxHeight ~/ 1.5,
                                  ),
                                  placeholderColor: Colors.transparent,
                                  fit: BoxFit.cover,
                                  alignment: Alignment.topCenter,
                                  placeholderFit: BoxFit.cover,
                                  excludeFromSemantics: true,
                                  image: ResizeImage(
                                    backgroundImage!.imageProvider,
                                    height: maxHeight ~/ 1.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      Container(
                        width: double.infinity,
                        height: maxHeight + 10,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Theme.of(context).colorScheme.surface.withValues(alpha: 0),
                              Theme.of(context).colorScheme.surface.withValues(alpha: 0.10),
                              Theme.of(context).colorScheme.surface.withValues(alpha: 0.35),
                              Theme.of(context).colorScheme.surface.withValues(alpha: 0.85),
                              Theme.of(context).colorScheme.surface,
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: size.height,
                        width: size.width,
                        color: widget.backgroundColor,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: 0,
                          top: 0,
                        ),
                        child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: size.height,
                              maxWidth: size.width,
                            ),
                            child: FocusProvider(
                              autoFocus: false, // Prevent carousels from autofocusing
                              child: widget.content(
                                padding.copyWith(
                                  left: 25 + MediaQuery.paddingOf(context).left,
                                ),
                              ),
                            ),
                          ),
                      ),
                    ],
                  ),
                ),
                // Top row buttons: show only the item actions and refresh. Back/home/user icons removed.
                // Floating button group removed as per user request
              ],
            ),
            ),
        );
      }),
    );
  }
}

