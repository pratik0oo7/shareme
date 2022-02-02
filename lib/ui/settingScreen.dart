// ignore_for_file: camel_case_types, file_names

import 'package:flutter/material.dart';

class settingScreen extends StatelessWidget {
  const settingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange.shade50,
      body: Container(
        color: Colors.amber,
        child: const Text('SettingScreen'),
      ),
    );
  }
}
