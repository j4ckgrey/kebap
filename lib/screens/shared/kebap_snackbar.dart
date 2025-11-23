import 'package:flutter/material.dart';

import 'package:chopper/chopper.dart';

void kebapSnackbar(
  BuildContext context, {
  String title = "",
  bool permanent = false,
  SnackBarAction? action,
  bool showCloseButton = false,
  Duration duration = const Duration(seconds: 3),
}) {
  try {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.onSecondary),
      ),
      clipBehavior: Clip.none,
      showCloseIcon: showCloseButton,
      duration: duration,
      padding: const EdgeInsets.all(18),
      action: action,
    ));
  } catch (e) {
    // Handle the case where the context is not mounted or any other error
    debugPrint("Error showing snackbar: $e");
  }
}

void kebapSnackbarResponse(BuildContext context, Response? response, {String? altTitle}) {
  if (response != null) {
    kebapSnackbar(context,
        title: "(${response.base.statusCode}) ${response.base.reasonPhrase ?? "Something went wrong!"}");
    return;
  } else if (altTitle != null) {
    kebapSnackbar(context, title: altTitle);
  }
}
