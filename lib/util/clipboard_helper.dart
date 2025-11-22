import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:kebap/screens/shared/kebap_snackbar.dart';
import 'package:kebap/util/localization_helper.dart';

extension ClipboardHelper on BuildContext {
  Future<void> copyToClipboard(String value, {String? customMessage}) async {
    await Clipboard.setData(ClipboardData(text: value));
    if (mounted) {
      fladderSnackbar(
        this,
        title: customMessage ?? localized.copiedToClipboard,
      );
    }
  }
}
