import 'package:kebap/l10n/generated/app_localizations.dart';

// Compatibility shims for old localization getter names left over from
// the original 'Kebap' branding. These delegate to the new generated
// getters (e.g. exitKebapTitle) so we don't need to refactor all call
// sites at once.
extension KebapCompatLocalizations on AppLocalizations {
  String get exitKebapTitle => exitKebapTitle;

  String get exitKebapDesc => exitKebapDesc;
}
