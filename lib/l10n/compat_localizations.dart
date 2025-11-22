import 'package:kebap/l10n/generated/app_localizations.dart';

// Compatibility shims for old localization getter names left over from
// the original 'Fladder' branding. These delegate to the new generated
// getters (e.g. exitKebapTitle) so we don't need to refactor all call
// sites at once.
extension FladderCompatLocalizations on AppLocalizations {
  String get exitFladderTitle => exitKebapTitle;

  String get exitFladderDesc => exitKebapDesc;
}
