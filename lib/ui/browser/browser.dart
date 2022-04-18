import 'package:flutter/material.dart';

class browserScreen extends StatelessWidget {
  const browserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange.shade50,
      body: Container(
        color: Colors.amber,
        child: Text('browser'),
      ),
    );
  }
}
