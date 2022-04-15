// ignore_for_file: camel_case_types, unused_import, type_annotate_public_apis, always_declare_return_types, prefer_final_locals

import 'package:flutter/material.dart';
import 'package:shareme/box/receivedi.dart';

// ignore: avoid_classes_with_only_static_members
class navigate {
  static Future pushPage(BuildContext context, Widget page) {
    var val = Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return page;
        },
      ),
    );
    return val;
  }

  static Future pushpagedialog(BuildContext context, Widget page) {
    var val = Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return page;
        },
        fullscreenDialog: true,
      ),
    );
    return val;
  }

  static pushpagereplace(BuildContext context, Widget page) {
    var val = Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return page;
        },
        fullscreenDialog: true,
      ),
    );
    return val;
  }

  static pushpagereplacement(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return page;
        },
      ),
    );
  }
}
