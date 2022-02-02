// language files
// ignore_for_file: unused_import, unnecessary_import, depend_on_referenced_packages, implementation_imports, always_use_package_imports

import 'dart:ui';

import 'package:collection/src/iterable_extensions.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import '../configfile.dart';
// ChangeNotifier

class Languagemanager extends ChangeNotifier {
  Language _language =
      languagelist.firstWhere((element) => element.name == 'english');
  bool _languageSet = false;
  bool get isLanguageSet => _languageSet;
  Language get language => _language;
  set language(Language language) {
    _language = language;
    Hive.box<String>('strings').put('language', _language.name);
    notifyListeners();
  }

  void init() {
    final l = Hive.box<String>('strings').get('language', defaultValue: null);

    if (l != null) {
      _language = languagelist.firstWhere((element) => element.name == l);
      _languageSet = true;
      notifyListeners();
      return;
    }

    final locales = WidgetsBinding.instance!.window.locales;
    for (final locale in locales) {
      // ignore: unused_local_variable
      final language =
          languagelist.firstWhereOrNull((element) => element.locale == locale);
      if (language != null) {
        _language = language;
        break;
      }
    }
    notifyListeners();
  }
}
