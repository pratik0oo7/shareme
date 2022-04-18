// ignore_for_file: avoid_web_libraries_in_flutter, unused_impor, camel_case_types

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shareme/helper.dart';
import 'package:shareme/navigators%20&%20view/buttons.dart';
import 'package:shareme/service/sharingobject_service.dart';

class shareText extends StatefulWidget {
  const shareText({Key? key}) : super(key: key);

  @override
  _shareTextState createState() => _shareTextState();
}

class _shareTextState extends State<shareText> {
  String text = '';
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 0,
      insetPadding: const EdgeInsets.all(24),
      title: Text(
        'Type some text',
        // context.l.homeSelectTextTypeSomeText,
        style: GoogleFonts.comfortaa(
          // context.l.fontComfortaa,
          fontWeight: FontWeight.w700,
        ),
      ),
      scrollable: true,
      content: TextField(
        autofocus: true,
        maxLines: null,
        minLines: 2,
        onChanged: (str) {
          setState(() {
            text = str;
          });
        },
      ),
      actions: [
        DialogTextButton(
          'Close',
          // context.l.generalClose,
          () {
            Navigator.of(context).pop();
          },
        ),
        DialogTextButton(
          'Send',
          // context.l.generalSend,
          text.isEmpty
              ? null
              : () {
                  Navigator.of(context).pop(
                    shareObject(
                      type: SharingObjectType.text,
                      data: text,
                      name: shareObject.getshareName(
                        SharingObjectType.text,
                        text,
                      ),
                    ),
                  );
                },
        ),
        const SizedBox(
          width: 4,
        ),
      ],
    );
  }
}
