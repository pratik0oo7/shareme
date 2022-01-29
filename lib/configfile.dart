// ignore_for_file: depend_on_referenced_packages, implementation_imports, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_ar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_br.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_de.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_en.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_es.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_fa.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_fr.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_id.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_it.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_ja.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_ml.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_pl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_pt.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_ru.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_sk.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_te.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_th.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_tr.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_uk.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_zh.dart';
import 'package:shareme/service/localizationservice.dart';
import 'package:shareme/ui/aboutScreen.dart';
import 'package:shareme/ui/errorscreen.dart';
import 'package:shareme/ui/homescreen.dart';
import 'package:shareme/ui/introduction.dart';
import 'package:shareme/ui/language.dart';
import 'package:shareme/ui/load.dart';
import 'package:shareme/ui/settingScreen.dart';
import 'package:shareme/ui/sharefileScreen.dart';

const List<int> ports = [50500, 50050];
const String currentVersion = '1.0';
List<Language> get languagelist => [
      Language(
        // 1.3 billion (400+700)
        name: 'english',
        nameLocal: 'English',
        locale: const Locale('en'),
        localizations: AppLocalizationsEn(),
      ),
      Language(
        // 1.3 billion (400+700)
        name: 'chinese',
        nameLocal: '汉语',
        locale:
            const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
        localizations: AppLocalizationsZh(),
      ),
      // Language(
      //     // 592 million (322+270)
      //     name: 'hindi',
      //     nameLocal: 'हिन्दी',
      //     locale: const Locale('hi'),
      //     localizations: AppLocalizationsHi()),

      Language(
        // 590 million
        name: 'spanish',
        nameLocal: 'español',
        locale: const Locale.fromSubtags(languageCode: 'es'),
        localizations: AppLocalizationsEs(),
      ),
      Language(
        // 300+ million
        name: 'french',
        nameLocal: 'français',
        locale: const Locale('fr'),
        localizations: AppLocalizationsFr(),
      ),
      Language(
        // rtl
        // 313 million
        name: 'arabic',
        nameLocal: 'اتصل',
        locale: const Locale('ar'),
        localizations: AppLocalizationsAr(),
      ),
      Language(
        // 313 million
        name: 'portuguese',
        nameLocal: 'português',
        locale: const Locale('pt'),
        localizations: AppLocalizationsPt(),
      ),
      Language(
        // 260 million (150+110)
        name: 'russian',
        nameLocal: 'Русский',
        locale: const Locale('ru'),
        localizations: AppLocalizationsRu(),
      ),
      Language(
        // 200+ million
        name: 'german',
        nameLocal: 'Deutsch',
        locale: const Locale('de'),
        localizations: AppLocalizationsDe(),
      ),
      Language(
        // 200 million
        name: 'indonesian',
        nameLocal: 'bahasa Indonesia',
        locale: const Locale('id'),
        localizations: AppLocalizationsId(),
      ),
      Language(
        // 120+  million
        name: 'japanese',
        nameLocal: '日本語',
        locale: const Locale('ja'),
        localizations: AppLocalizationsJa(),
      ),
      Language(
        // rtl
        // 110 million
        name: 'farsi',
        nameLocal: 'فارسی',
        locale: const Locale('fa'),
        localizations: AppLocalizationsFa(),
      ),
      Language(
        // 94 million
        name: 'telugu',
        nameLocal: 'తెలుగు',
        locale: const Locale('te'),
        localizations: AppLocalizationsTe(),
      ),
      Language(
        // 90 million
        name: 'brazilian_portuguese',
        nameLocal: 'português brasileiro',
        locale: const Locale('br'),
        localizations: AppLocalizationsBr(),
      ),
      Language(
        // 85 million
        name: 'italian',
        nameLocal: 'italiano',
        locale: const Locale('it'),
        localizations: AppLocalizationsIt(),
      ),
      Language(
        // 80 million
        name: 'turkish',
        nameLocal: 'Türkçe',
        locale: const Locale('tr'),
        localizations: AppLocalizationsTr(),
      ),

      Language(
        // 70+ million
        name: 'thai',
        nameLocal: 'ภาษาไทย',
        locale: const Locale('th'),
        localizations: AppLocalizationsTh(),
      ),

      // Language(
      //     // 60 million (56+4)
      //     name: 'gujarati',
      //     nameLocal: 'ગુજરાતી',
      //     locale: const Locale('gu'),
      //     localizations: AppLocalizationsGu()),
      Language(
        // 50 million (45+5)
        name: 'polish',
        nameLocal: 'Polski',
        locale: const Locale('pl'),
        localizations: AppLocalizationsPl(),
      ),
      Language(
        // 45 million
        name: 'malayalam',
        nameLocal: 'മലയാളം',
        locale: const Locale('ml'),
        localizations: AppLocalizationsMl(),
      ),
      Language(
        // 40 million
        name: 'ukrainian',
        nameLocal: 'Українська',
        locale: const Locale('uk'),
        localizations: AppLocalizationsUk(),
      ),
      // Language(
      //     // 20 million
      //     name: 'sinhala',
      //     nameLocal: 'සිංහල',
      //     locale: const Locale('sin'),
      //     localizations: AppLocalizationsSi()),
      Language(
        // 5 million
        name: 'slovak',
        nameLocal: 'Slovenčina',
        locale: const Locale('sk'),
        localizations: AppLocalizationsSk(),
      )
    ];

class Language {
  final String name;
  final String nameLocal;
  final Locale locale;
  final AppLocalizations localizations;
  const Language({
    required this.name,
    required this.nameLocal,
    required this.locale,
    required this.localizations,
  });
}

enum Screens {
  loading,
  languagePicker,
  intro,
  home,
  about,
  sharing,
  error,
  settings,
}

Widget screen2widget(Screens s, [Object? args]) {
  switch (s) {
    case Screens.loading:
      return LoadingScreen();
    case Screens.languagePicker:
      return LanguagePickerScreen();
    case Screens.intro:
      return introductionScreen();
    case Screens.home:
      return homeScreen();
    case Screens.about:
      return aboutScreen();
    case Screens.sharing:
      return shareScreen(args! as shareObject);
    case Screens.settings:
      return settingScreen();
    case Screens.error:
      return errordisplayScreen(args! as String);
  }
}
