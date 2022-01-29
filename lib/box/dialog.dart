// ignore_for_file: always_use_package_imports, require_trailing_commas

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../service/localizationservice.dart';

// todo not only file model but generic interface
Future<shareObject?> opendialog(BuildContext context, Widget dialog,
    {bool dismissible = true}) {
  return Hive.box<String>('strings').get('disable_blur', defaultValue: '0') ==
          '1'
      ? showDialog(
          context: context,
          barrierDismissible: dismissible,
          barrierLabel: 'close',
          builder: (_) => dialog,)
      : showGeneralDialog<shareObject>(
          context: context,
          barrierDismissible: dismissible,
          barrierLabel: 'close',
          transitionDuration: const Duration(microseconds: 180),
          transitionBuilder: (context, animation1, animation2, child) =>
              BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 2 * animation1.value,
                  sigmaY: 2 * animation2.value,
                ),
                child: FadeTransition(
                  opacity: animation1,
                  child: SafeArea(
                    child: child,
                  ),
                ),
              ),
          pageBuilder: (_, __, ___) => dialog,);
}
