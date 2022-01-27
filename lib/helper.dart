import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shareme/ui/language.dart';

T? cast<T>(dynamic x) => x is T ? x : null;

extension LocaleContext on BuildContext {
  AppLocalizations get l => AppLocalizations.of(this)!;
}

extension ThemeContext on BuildContext {
  ThemeData get t => Theme.of(this);
}

enum Screens {
  // loading,
  languagePicker,
  // intro,
  // home,
  // about,
  // sharing,
  // error,
  // settings,
}
Widget screen2widget(Screens screen, [Object? args]) {
  switch (screen) {
    // case Screens.loading:
    //   return LoadingScreen();
    case Screens.languagePicker:
      return LanguagePickerScreen();
    // case Screens.intro:
    //   return IntroScreen();
    // case Screens.home:
    //   return HomeScreen();
    // case Screens.about:
    //   return AboutScreen();
    // case Screens.sharing:
    //   return SharingScreen(args! as SharingObject);
    // case Screens.settings:
    //   return SettingsScreen();
    // case Screens.error:
    //   return ErrorScreen(args! as String);
  }
}
