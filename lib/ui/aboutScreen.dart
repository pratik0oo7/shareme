// ignore_for_file: camel_case_types, file_names, prefer_const_constructors

import 'package:flutter/material.dart';

class aboutScreen extends StatelessWidget {
  const aboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange.shade50,
      body: Center(
        child: Container(
          color: Colors.amber,
          child: Text('about!!!'),
        ),
      ),
    );
  }
}
