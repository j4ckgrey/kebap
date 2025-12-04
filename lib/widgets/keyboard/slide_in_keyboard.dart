import 'dart:async';

import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import 'package:kebap/screens/shared/animated_fade_size.dart';
import 'package:kebap/util/adaptive_layout/adaptive_layout.dart';
import 'package:kebap/util/focus_provider.dart';
import 'package:kebap/util/localization_helper.dart';
import 'package:kebap/widgets/keyboard/alpha_numeric_keyboard.dart';

ValueNotifier<bool> isKeyboardOpen = ValueNotifier<bool>(false);

double keyboardWidthFactor = 0.25;

class CustomKeyboardWrapper extends StatelessWidget {
  final Widget child;
  const CustomKeyboardWrapper({
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: ValueListenableBuilder(
        valueListenable: isKeyboardOpen,
        builder: (context, value, _) {
          return AnimatedFractionallySizedBox(
            duration: const Duration(milliseconds: 175),
            widthFactor: 1.0,
            heightFactor: 1.0,
            alignment: Alignment.center,
            child: child,
          );
        },
      ),
    );
  }
}

Future<bool?> openKeyboard<T>(
  BuildContext context,
  TextEditingController controller, {
  TextInputType? inputType,
  TextInputAction? inputAction,
  FutureOr<List<String>> Function(String query)? searchQuery,
  VoidCallback? onChanged,
}) async {
  isKeyboardOpen.value = true;
  final result = await showGeneralDialog<bool>(
    context: context,
    transitionDuration: const Duration(milliseconds: 175),
    barrierDismissible: true,
    barrierColor: Colors.transparent,
    barrierLabel: 'Custom keyboard',
    useRootNavigator: true,
    fullscreenDialog: true,
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0)).animate(
          animation,
        ),
        child: child,
      );
    },
    pageBuilder: (context, animation1, animation2) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: _SlideInKeyboard(
          controller: controller,
          onChanged: onChanged ?? () {},
          onClose: (submitted) {
            context.router.pop(submitted);
            isKeyboardOpen.value = false;
          },
          inputType: inputType,
          inputAction: inputAction,
          searchQuery: searchQuery,
        ),
      );
    },
  );
  isKeyboardOpen.value = false;
  return result;
}

class _SlideInKeyboard extends StatefulWidget {
  final TextEditingController controller;
  final Function() onChanged;
  final Function(bool) onClose;
  final TextInputType? inputType;
  final TextInputAction? inputAction;
  final FutureOr<List<String>> Function(String query)? searchQuery;
  const _SlideInKeyboard({
    required this.controller,
    required this.onChanged,
    required this.onClose,
    this.inputType,
    this.inputAction,
    this.searchQuery,
  });

  @override
  State<_SlideInKeyboard> createState() => __SlideInKeyboardState();
}

class __SlideInKeyboardState extends State<_SlideInKeyboard> {
  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.paddingOf(context);
    final size = MediaQuery.sizeOf(context);
    final height = size.height * 0.35;
    
    // Use 80% width on non-mobile devices, 100% on mobile
    final isMobile = AdaptiveLayout.viewSizeOf(context) == ViewSize.phone;
    final width = isMobile ? size.width : size.width * 0.8;
    
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: height,
        width: width,
        child: Padding(
          padding: padding.copyWith(top: 0),
          child: Container(
            height: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: _CustomKeyboardView(
                controller: widget.controller,
                onChanged: widget.onChanged,
                onClose: widget.onClose,
                keyboardType: widget.inputType,
                keyboardActionType: widget.inputAction,
                searchQuery: widget.searchQuery,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CustomKeyboardView extends StatefulWidget {
  final TextEditingController controller;
  final TextInputAction? keyboardActionType;
  final TextInputType? keyboardType;

  final VoidCallback onChanged;
  final Function(bool) onClose;
  final FutureOr<List<String>> Function(String query)? searchQuery;

  const _CustomKeyboardView({
    required this.controller,
    required this.onChanged,
    required this.onClose,
    this.keyboardActionType,
    this.keyboardType,
    this.searchQuery,
  });

  @override
  State<_CustomKeyboardView> createState() => _CustomKeyboardViewState();
}

class _CustomKeyboardViewState extends State<_CustomKeyboardView> {
  final FocusScopeNode scope = FocusScopeNode();

  ValueNotifier<List<String>> searchQueryResults = ValueNotifier([]);



  Future<void> startUpdate(String text) async {
    final newValues = await widget.searchQuery?.call(widget.controller.text) ?? [];
    searchQueryResults.value = newValues;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((value) {
      startUpdate(widget.controller.text);
    });
  }

  @override
  void dispose() {
    scope.dispose();

    searchQueryResults.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!scope.hasFocus) {
      scope.requestFocus();
    }
    return FocusScope(
      node: scope,
      autofocus: true,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 16,
          children: [

            if (widget.searchQuery != null)
              ValueListenableBuilder(
                valueListenable: searchQueryResults,
                builder: (context, values, child) => _SearchResults(
                  results: values,
                  query: widget.controller.text,
                  onTap: (value) {
                    widget.controller.text = value;
                    widget.onClose(true);
                  },
                ),
              ),
            Flexible(
              child: AlphaNumericKeyboard(
                onCharacter: (value) => setState(() {
                  widget.controller.text += value;
                  widget.onChanged();
                  startUpdate(widget.controller.text);
                }),
                keyboardType: widget.keyboardType ?? TextInputType.name,
                keyboardActionType: widget.keyboardActionType ?? TextInputAction.done,
                onBackspace: () {
                  setState(() {
                    widget.controller.text = widget.controller.text.substring(0, widget.controller.text.length - 1);
                    widget.onChanged();
                  });
                  startUpdate(widget.controller.text);
                },
                onClear: () => setState(() => widget.controller.clear()),
                onDone: () => widget.onClose(true),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchResults extends StatelessWidget {
  final List<String> results;
  final String query;
  final Function(String value) onTap;
  const _SearchResults({
    required this.results,
    required this.query,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final minHeight = MediaQuery.sizeOf(context).height * 0.25;
    return AnimatedFadeSize(
      alignment: Alignment.topCenter,
      child: results.isNotEmpty && query.isNotEmpty
          ? ConstrainedBox(
              constraints: BoxConstraints(minHeight: minHeight),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 6,
                children: [
                  ...results.map(
                    (result) => FocusButton(
                      onTap: () => onTap(result),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            spacing: 8,
                            children: [
                              const Icon(IconsaxPlusLinear.arrow_right),
                              Flexible(
                                child: Text(
                                  result,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : SizedBox(
              height: minHeight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 8,
                children: [
                  const Icon(IconsaxPlusLinear.search_status_1),
                  Text(
                    context.localized.noResults,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            ),
    );
  }
}
