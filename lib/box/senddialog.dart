// ignore_for_file: avoid_dynamic_calls, unused_import, use_build_context_synchronously, prefer_const_constructors

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:shareme/box/dialog.dart';
import 'package:shareme/box/shareapp.dart';
import 'package:shareme/box/sharetext.dart';
import 'package:shareme/helper.dart';
import 'package:shareme/main.dart';
import 'package:shareme/navigators%20&%20view/buttons.dart';
import 'package:shareme/service/localizationservice.dart';

class Send extends StatelessWidget {
  const Send({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 0,
      insetPadding: const EdgeInsets.all(24),
      title: Text(
        'Send',
        style: GoogleFonts.comfortaa(
          // context.l.fontComfortaa,
          fontWeight: FontWeight.w700,
        ),
      ),
      scrollable: true,
      content: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: TransparentButton(
              Row(
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  const Icon(
                    LucideIcons.file,
                    size: 20,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    'Files',
                    style: GoogleFonts.andika(
                      // context.l.fontAndika,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              () async {
                if (Platform.isAndroid || Platform.isIOS) {
                  final f =
                      await FilePicker.platform.pickFiles(allowMultiple: true);
                  if (f != null) {
                    Navigator.of(context).pop(
                      shareObject(
                        type: SharingObjectType.file,
                        data: f.paths.join(multipleFilesDelimiter),
                        name: shareObject.getshareName(
                          SharingObjectType.file,
                          f.paths.join(multipleFilesDelimiter),
                        ),
                      ),
                    );
                  }
                } else {
                  final f = await openFiles();
                  if (f.isNotEmpty) {
                    final data =
                        f.map((e) => e.path).join(multipleFilesDelimiter);
                    Navigator.of(context).pop(
                      shareObject(
                        data: data,
                        type: SharingObjectType.file,
                        name: shareObject.getshareName(
                          SharingObjectType.file,
                          data,
                        ),
                      ),
                    );
                  }
                }
              },
              TransparentButtonBackground.def,
              border: true,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: TransparentButton(
              Row(
                children: [
                  const Icon(
                    LucideIcons.fileText,
                    size: 20,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    'Text',
                    style: GoogleFonts.andika(
                      // context.l.fontAndika,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              () async {
                final text = await opendialog(context, shareText());
                if (text != null) {
                  Navigator.of(context).pop(text);
                }
              },
              TransparentButtonBackground.def,
              border: true,
            ),
          ),
          if (Platform.isAndroid || Platform.isIOS) const SizedBox(height: 12),
          if (Platform.isAndroid)
            SizedBox(
              width: double.infinity,
              child: TransparentButton(
                Row(
                  children: [
                    const Icon(
                      LucideIcons.binary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'App',
                      style: GoogleFonts.andika(
                        // context.l.fontAndika,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                () async {
                  final f = await opendialog(context, shareApp());
                  if (f != null) {
                    Navigator.of(context).pop(f);
                  }
                },
                TransparentButtonBackground.def,
                border: true,
              ),
            ),
          if (Platform.isIOS)
            SizedBox(
              width: double.infinity,
              child: TransparentButton(
                Row(
                  children: [
                    const Icon(
                      LucideIcons.image,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Gallery',
                      style: GoogleFonts.andika(fontSize: 18),
                    ),
                  ],
                ),
                () async {
                  final f = await FilePicker.platform
                      .pickFiles(type: FileType.media, allowMultiple: true);

                  if (f != null) {
                    Navigator.of(context).pop(
                      shareObject(
                        data: f.paths.join(multipleFilesDelimiter),
                        type: SharingObjectType.file,
                        name: shareObject.getshareName(
                          SharingObjectType.file,
                          f.paths.join(multipleFilesDelimiter),
                        ),
                      ),
                    );
                  }
                },
                TransparentButtonBackground.def,
                border: true,
              ),
            ),
        ],
      ),
      actions: [
        DialogTextButton('Close', () {
          Navigator.of(context).pop();
        }),
        const SizedBox(width: 4),
      ],
    );
  }
}
