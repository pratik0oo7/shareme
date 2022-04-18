// ignore_for_file: always_use_package_imports, require_trailing_commas, deprecated_member_use, sized_box_for_whitespace

import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shareme/box/customalert.dart';

import '../service/sharingobject_service.dart';

// todo not only file model but generic interface
Future<shareObject?> opendialog(BuildContext context, Widget dialog,
    {bool dismissible = true}) {
  return Hive.box<String>('strings').get('disable_blur', defaultValue: '0') ==
          '1'
      ? showDialog(
          context: context,
          barrierDismissible: dismissible,
          barrierLabel: 'close',
          builder: (_) => dialog,
        )
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
          pageBuilder: (_, __, ___) => dialog,
        );
}

// ignore: avoid_classes_with_only_static_members
class Dialogs {
  static showexitdialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CustomAlert(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 15),
              Text(
                'Sync & Share',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 25),
              Text(
                'Are you sure you want to quit?',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    height: 40,
                    width: 130,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        side: MaterialStateProperty.all(
                          BorderSide(color: Theme.of(context).accentColor),
                        ),
                      ),
                      child: Text(
                        'No',
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 40,
                    width: 130,
                    child: ElevatedButton(
                      onPressed: () => exit(0),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Theme.of(context).accentColor),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                      ),
                      child: Text(
                        'Yes',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  static showToast(value) {
    Fluttertoast.showToast(
      msg: '$value',
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIosWeb: 1,
    );
  }
}
