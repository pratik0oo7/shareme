// ignore_for_file: camel_case_types, avoid_unused_constructor_parameters

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class errordisplayScreen extends StatefulWidget {
  final String _error;
  const errordisplayScreen(this._error);

  @override
  _errordisplayScreenState createState() => _errordisplayScreenState();
}

class _errordisplayScreenState extends State<errordisplayScreen> {
  @override
  void initState() {
    Clipboard.setData(ClipboardData(text: widget._error));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange.shade50,
      // ignore: prefer_const_constructors
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          // ignore: prefer_const_constructors
          child: Text(
            "Unfortunately, an error has occurred.\n\nError information was copied to the clipboard, please file an issue on GitHub:\nhttps://github.com/pratik0oo7/shareme\n\n\nRestarting or reinstalling the app might help solve the problem.\n\nThanks for using Share Me!!!! :=>",
            textAlign: TextAlign.center,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 15,
              color: Colors.grey.shade300,
            ),
          ),
        ),
      ),
    );
  }
}
