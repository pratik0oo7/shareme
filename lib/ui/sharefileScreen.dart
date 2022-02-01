// ignore_for_file: avoid_unused_constructor_parameters, prefer_const_constructors_in_immutables, camel_case_types, file_names, unused_field, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:shareme/service/localizationservice.dart';

class shareScreen extends StatefulWidget {
  // shareScreen( {Key? key, this._file, this.}) : super(key: key);
  final shareObject _file;
  const shareScreen(this._file);
  @override
  State<shareScreen> createState() => _shareScreenState();
}

class _shareScreenState extends State<shareScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange.shade50,
      body: Container(
        color: Colors.amber,
        child: Text('shareScreen'),
      ),
    );
  }
}
