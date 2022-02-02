// ignore_for_file: depend_on_referenced_packages, unused_import
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shareme/helper.dart';
import 'package:shareme/navigators%20&%20view/buttons.dart';

class Trackbox extends StatefulWidget {
  const Trackbox({Key? key}) : super(key: key);

  @override
  _TrackboxState createState() => _TrackboxState();
}

class _TrackboxState extends State<Trackbox> {
  int _timer = 5;
  void _tick() {
    if (_timer == 0) {
      return;
    }
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) {
        return;
      }
      setState(() {
        _timer--;
      });
      _tick();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _tick();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 0,
      insetPadding: const EdgeInsets.all(24),
      title: Text(
        context.l.settingsTracking,
        style: GoogleFonts.getFont(
          context.l.fontComfortaa,
          fontWeight: FontWeight.w700,
          fontSize: 15,
        ),
      ),
      actions: [
        DialogTextButton(
          '${context.l.settingsDisableTracking}${_timer > 0 ? '($_timer)' : ''}',
          _timer > 0
              ? null
              : () {
                  Hive.box<String>('strings').put('tracking', '0');
                  Navigator.of(context).pop();
                },
        ),
        DialogTextButton(
          context.l.settingsTrackingAllow,
          () {
            Hive.box<String>('strings').put('tracking', '1');
            Navigator.of(context).pop();
          },
        ),
      ],
      scrollable: true,
      content: MarkdownBody(
        data: context.l.settingsTrackingDescription,
        styleSheet: MarkdownStyleSheet(
          p: GoogleFonts.jetBrainsMono(fontSize: 15),
        ),
        listItemCrossAxisAlignment: MarkdownListItemCrossAxisAlignment.start,
      ),
    );
  }
}
