import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:kebap/models/account_model.dart';
import 'package:kebap/screens/shared/fladder_snackbar.dart';
import 'package:kebap/screens/shared/passcode_input.dart';
import 'package:kebap/util/auth_service.dart';
import 'package:kebap/util/list_padding.dart';
import 'package:kebap/util/localization_helper.dart';
import 'package:flutter/material.dart';

void showAuthOptionsDialogue(
  BuildContext context,
  AccountModel currentUser,
  Function(AccountModel) setMethod,
) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      scrollable: true,
      icon: const Icon(IconsaxPlusBold.lock_1),
      title: Text(context.localized.appLockTitle(currentUser.name)),
      actionsOverflowDirection: VerticalDirection.down,
      actions: Authentication.values
          .where((element) => element.available(context))
          .map(
            (method) => SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  switch (method) {
                    case Authentication.autoLogin:
                      setMethod.call(currentUser.copyWith(authMethod: method));
                      break;
                    case Authentication.biometrics:
                      final authenticated = await AuthService.authenticateUser(context, currentUser);
                      if (authenticated) {
                        setMethod.call(currentUser.copyWith(authMethod: method));
                      } else if (context.mounted) {
                        fladderSnackbar(context, title: context.localized.biometricsFailedCheckAgain);
                      }
                      break;
                    case Authentication.passcode:
                      if (context.mounted) {
                        Navigator.of(context).pop();
                        Future.microtask(() {
                          showPassCodeDialog(context, (newPin) {
                            setMethod.call(currentUser.copyWith(authMethod: method, localPin: newPin));
                          });
                        });
                      }
                      return;
                    case Authentication.none:
                      setMethod.call(currentUser.copyWith(authMethod: method));
                      break;
                  }
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
                icon: Icon(method.icon),
                label: Text(
                  method.name(context),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          )
          .toList()
          .addPadding(const EdgeInsets.symmetric(vertical: 8)),
    ),
  );
}
