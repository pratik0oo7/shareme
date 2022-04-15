// ignore_for_file: depend_on_referenced_packages, implementation_imports, prefer_const_constructors, avoid_classes_with_only_static_members, avoid_dynamic_calls

import 'package:flutter/material.dart';
import 'package:shareme/service/localizationservice.dart';
import 'package:shareme/ui/aboutScreen.dart';
import 'package:shareme/ui/errorscreen.dart';
import 'package:shareme/ui/homescreen.dart';
import 'package:shareme/ui/intro/introduction.dart';
import 'package:shareme/ui/language.dart';
import 'package:shareme/ui/load.dart';
import 'package:shareme/ui/main_screen.dart';
import 'package:shareme/ui/settingScreen.dart';
import 'package:shareme/ui/sharefileScreen.dart';

const List<int> ports = [50500, 50050];
const String currentVersion = '1.0';
// List<Language> get languagelist => [
//       Language(
//         // 1.3 billion (400+700)
//         name: 'english',
//         nameLocal: 'English',
//         locale: const Locale('en'),
//         localizations: AppLocalizationsEn(),
//       ),
//       Language(
//         // 1.3 billion (400+700)
//         name: 'chinese',
//         nameLocal: '汉语',
//         locale:
//             const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
//         localizations: AppLocalizationsZh(),
//       ),
//       // Language(
//       //     // 592 million (322+270)
//       //     name: 'hindi',
//       //     nameLocal: 'हिन्दी',
//       //     locale: const Locale('hi'),
//       //     localizations: AppLocalizationsHi()),

//       Language(
//         // 590 million
//         name: 'spanish',
//         nameLocal: 'español',
//         locale: const Locale.fromSubtags(languageCode: 'es'),
//         localizations: AppLocalizationsEs(),
//       ),
//       Language(
//         // 300+ million
//         name: 'french',
//         nameLocal: 'français',
//         locale: const Locale('fr'),
//         localizations: AppLocalizationsFr(),
//       ),
//       Language(
//         // rtl
//         // 313 million
//         name: 'arabic',
//         nameLocal: 'اتصل',
//         locale: const Locale('ar'),
//         localizations: AppLocalizationsAr(),
//       ),
//       Language(
//         // 313 million
//         name: 'portuguese',
//         nameLocal: 'português',
//         locale: const Locale('pt'),
//         localizations: AppLocalizationsPt(),
//       ),
//       Language(
//         // 260 million (150+110)
//         name: 'russian',
//         nameLocal: 'Русский',
//         locale: const Locale('ru'),
//         localizations: AppLocalizationsRu(),
//       ),
//       Language(
//         // 200+ million
//         name: 'german',
//         nameLocal: 'Deutsch',
//         locale: const Locale('de'),
//         localizations: AppLocalizationsDe(),
//       ),
//       Language(
//         // 200 million
//         name: 'indonesian',
//         nameLocal: 'bahasa\nIndonesia',
//         locale: const Locale('id'),
//         localizations: AppLocalizationsId(),
//       ),
//       Language(
//         // 120+  million
//         name: 'japanese',
//         nameLocal: '日本語',
//         locale: const Locale('ja'),
//         localizations: AppLocalizationsJa(),
//       ),
//       Language(
//         // rtl
//         // 110 million
//         name: 'farsi',
//         nameLocal: 'فارسی',
//         locale: const Locale('fa'),
//         localizations: AppLocalizationsFa(),
//       ),
//       Language(
//         // 94 million
//         name: 'telugu',
//         nameLocal: 'తెలుగు',
//         locale: const Locale('te'),
//         localizations: AppLocalizationsTe(),
//       ),
//       Language(
//         // 90 million
//         name: 'brazilian_portuguese',
//         nameLocal: 'português\nbrasileiro',
//         locale: const Locale('br'),
//         localizations: AppLocalizationsBr(),
//       ),
//       Language(
//         // 85 million
//         name: 'italian',
//         nameLocal: 'italiano',
//         locale: const Locale('it'),
//         localizations: AppLocalizationsIt(),
//       ),
//       Language(
//         // 80 million
//         name: 'turkish',
//         nameLocal: 'Türkçe',
//         locale: const Locale('tr'),
//         localizations: AppLocalizationsTr(),
//       ),

//       Language(
//         // 70+ million
//         name: 'thai',
//         nameLocal: 'ภาษาไทย',
//         locale: const Locale('th'),
//         localizations: AppLocalizationsTh(),
//       ),

//       // Language(
//       //     // 60 million (56+4)
//       //     name: 'gujarati',
//       //     nameLocal: 'ગુજરાતી',
//       //     locale: const Locale('gu'),
//       //     localizations: AppLocalizationsGu()),
//       Language(
//         // 50 million (45+5)
//         name: 'polish',
//         nameLocal: 'Polski',
//         locale: const Locale('pl'),
//         localizations: AppLocalizationsPl(),
//       ),
//       Language(
//         // 45 million
//         name: 'malayalam',
//         nameLocal: 'മലയാളം',
//         locale: const Locale('ml'),
//         localizations: AppLocalizationsMl(),
//       ),
//       Language(
//         // 40 million
//         name: 'ukrainian',
//         nameLocal: 'Українська',
//         locale: const Locale('uk'),
//         localizations: AppLocalizationsUk(),
//       ),
//       // Language(
//       //     // 20 million
//       //     name: 'sinhala',
//       //     nameLocal: 'සිංහල',
//       //     locale: const Locale('sin'),
//       //     localizations: AppLocalizationsSi()),
//       Language(
//         // 5 million
//         name: 'slovak',
//         nameLocal: 'Slovenčina',
//         locale: const Locale('sk'),
//         localizations: AppLocalizationsSk(),
//       )
//     ];

// class Language {
//   final String name;
//   final String nameLocal;
//   final Locale locale;
//   final AppLocalizations localizations;
//   const Language({
//     required this.name,
//     required this.nameLocal,
//     required this.locale,
//     required this.localizations,
//   });
// }

enum Screens {
  loading,
  // languagePicker,
  intro,
  home,
  about,
  sharing,
  error,
  settings,
  main,
}

Widget screen2widget(Screens s, [Object? args]) {
  switch (s) {
    case Screens.loading:
      return LoadingScreen();
    // case Screens.languagePicker:
    //   return LanguagePickerScreen();
    case Screens.intro:
      return Introductionanimation();
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
    case Screens.main:
      return MainScreen();
  }
}

class CustomDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            height: 1,
            color: Theme.of(context).dividerColor,
            width: size.width - 70,
          ),
        ),
      ],
    );
  }
}

class Constants {
  static List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]) as T);
    }

    return result;
  }

  static List categories = [
    {
      'title': 'Downloads',
      'icon': Icons.download,
      'path': '',
      'color': Colors.purple
    },
    {'title': 'Images', 'icon': Icons.image, 'path': '', 'color': Colors.blue},
    {
      'title': 'Videos',
      'icon': Icons.ondemand_video,
      'path': '',
      'color': Colors.red
    },
    {
      'title': 'Audio',
      'icon': Icons.headphones,
      'path': '',
      'color': Colors.teal
    },
    {
      'title': 'Documents & Others',
      'icon': Icons.drive_file_move,
      'path': '',
      'color': Colors.pink
    },
    {'title': 'Apps', 'icon': Icons.android, 'path': '', 'color': Colors.green},
    {
      'title': 'Whatsapp Statuses',
      'icon': Icons.wifi_calling,
      'path': '',
      'color': Colors.green
    },
  ];

  static List sortList = [
    'File name (A to Z)',
    'File name (Z to A)',
    'Date (oldest first)',
    'Date (newest first)',
    'Size (largest first)',
    'Size (Smallest first)',
  ];
}
