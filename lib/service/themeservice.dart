// ignore_for_file: unnecessary_import, camel_case_types

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:shareme/helper.dart';

class thememanager extends ChangeNotifier {
  ThemeMode _theme = ThemeMode.system;
  ThemeMode get theme => _theme;
  set theme(ThemeMode val) {
    _theme = val;
    if (val == ThemeMode.system) {
      Hive.box<String>('strings').delete('theme');
    } else {
      Hive.box<String>('string')
          .put('theme', val == ThemeMode.light ? 'light' : 'dark');
    }
    notifyListeners();
  }

  Brightness get brightness => _theme == ThemeMode.system
      ? SchedulerBinding.instance!.window.platformBrightness
      : (_theme == ThemeMode.dark ? Brightness.dark : Brightness.light);

  void change() {
    if (theme == ThemeMode.system) {
      theme = ThemeMode.dark;
    } else if (theme == ThemeMode.dark) {
      theme = ThemeMode.light;
    } else {
      theme = ThemeMode.system;
    }
  }

  String name(BuildContext context) {
    switch (theme) {
      case ThemeMode.system:
        return 'System';
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
    }
  }

  void init() {
    if (Hive.box<String>('strings').containsKey('theme')) {
      final theme = Hive.box<String>('strings').get('theme');
      if (theme == 'light') {
        _theme = ThemeMode.light;
      } else if (theme == 'dark') {
        _theme = ThemeMode.dark;
      }
    }
    notifyListeners();
  }
}
