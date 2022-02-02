// ignore_for_file: unused_import, depend_on_referenced_packages, unnecessary_import, use_build_context_synchronously, avoid_print

import 'dart:io';
import 'dart:typed_data';

import 'package:ackee_dart/ackee_dart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:shareme/configfile.dart';
import 'package:shareme/helper.dart';
import 'package:shareme/navigators%20&%20view/page_route.dart';
import 'package:shareme/service/languageservice.dart';
import 'package:shareme/service/localizationservice.dart';
import 'package:shareme/service/themeservice.dart';
import 'package:widget_to_image/widget_to_image.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  final GlobalKey _globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    init();
  }

  Future<void> init() async {
    await Future.delayed(Duration.zero);

    try {
      Hive.registerAdapter(SharingObjectTypeAdapter());
      Hive.registerAdapter(SharingObjectAdapter());

      await Hive.initFlutter('shareme_storage');

      await Hive.openBox<String>('strings');
      await Hive.openBox<shareObject>('history');

      context.read<Languagemanager>().init();
      context.read<thememanager>().init();

      _initAnalytics(context);

      LicenseRegistry.addLicense(() async* {
        final fonts = ['Andika', 'Comfortaa', 'JetBrains', 'Poppins'];

        for (final el in fonts) {
          final license =
              await rootBundle.loadString('google_fonts/$el/OFL.txt');
          yield LicenseEntryWithLineBreaks(['google_fonts'], license);
        }
      });

      try {
        if (Platform.isAndroid || Platform.isIOS) {
          final sharedFile = await ReceiveSharingIntent.getInitialMedia();
          final sharedText = await ReceiveSharingIntent.getInitialText();

          if (sharedFile.length > 1) {
            SharemeRoute.navigateTo(
              _globalKey,
              Screens.error,
              RouteDirection.right,
              'Sorry, you can only share 1 file at a time',
            );
            return;
          }

          if (sharedFile.isNotEmpty) {
            // todo apply dry
            final _file = shareObject(
              type: SharingObjectType.file,
              data: sharedFile[0].path.replaceFirst('file://', ''),
              name: shareObject.getshareName(
                SharingObjectType.file,
                sharedFile[0].path.replaceFirst('file://', ''),
              ),
            );

            final _history = Hive.box<shareObject>('history').values.toList();
            _history.removeWhere((element) => element.name == _file.name);
            _history.insert(0, _file);
            await Hive.box<shareObject>('history').clear();
            await Hive.box<shareObject>('history').addAll(_history);

            SharemeRoute.navigateTo(
              _globalKey,
              Screens.sharing,
              RouteDirection.right,
              _file,
            );
            return;
          }

          if (sharedText != null) {
            final _file = shareObject(
              type: SharingObjectType.text,
              data: sharedText,
              name: shareObject.getshareName(
                SharingObjectType.text,
                sharedText,
              ),
            );

            final _history = Hive.box<shareObject>('history').values.toList();
            _history.removeWhere((element) => element.name == _file.name);
            _history.insert(0, _file);
            await Hive.box<shareObject>('history').clear();
            await Hive.box<shareObject>('history').addAll(_history);

            SharemeRoute.navigateTo(
              _globalKey,
              Screens.sharing,
              RouteDirection.right,
              _file,
            );
            return;
          }
        }
      } catch (e) {
        print('Error when trying to receive sharing intent: $e');
      }

      if (Platform.isAndroid || Platform.isIOS) {
        await _receivingIntentListener(_globalKey);
      }

      SharemeRoute.navigateTo(
        _globalKey,
        Hive.box<String>('strings').containsKey('language')
            ? Screens.home
            : Screens.home,
        // : Screens.intro,
        RouteDirection.right,
      );
    } catch (error, trace) {
      SharemeRoute.navigateTo(
        _globalKey,
        Screens.error,
        RouteDirection.right,
        '$error \n\n $trace',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.deepOrange.shade50,
        body: RepaintBoundary(
          key: _globalKey,
          child: Scaffold(
            backgroundColor: Colors.deepOrange.shade50,
            // backgroundColor: Color.fromRGBO(245, 235, 226, 2),

            body: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: Image.asset(
                          'assets/logo.png',
                          height: 60,
                          color: Color(0xff132137),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Center(
                        child: Image.asset(
                          'assets/logo_inverse.png',
                          height: 60,
                          color: Color(0xff132137),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> _receivingIntentListener(GlobalKey key) async {
  final byteData = Hive.box<String>('strings')
              .get('disable_transition_effects', defaultValue: '0') ==
          '1'
      ? Uint8List(0)
      : (await WidgetToImage.repaintBoundaryToImage(key)).buffer.asUint8List();

  final files = ReceiveSharingIntent.getMediaStream();
  final texts = ReceiveSharingIntent.getTextStream();

  files.listen((sharedFile) {
    if (sharedFile.length > 1) {
      SharemeRoute.navigateToFromImage(
        byteData,
        Screens.error,
        RouteDirection.right,
        'Sorry, you can only share 1 file at a time',
      );
      return;
    }

    if (sharedFile.isNotEmpty) {
      SharemeRoute.navigateToFromImage(
        byteData,
        Screens.sharing,
        RouteDirection.right,
        shareObject(
          type: SharingObjectType.file,
          data: sharedFile[0].path.replaceFirst('file://', ''),
          name: shareObject.getshareName(
            SharingObjectType.file,
            sharedFile[0].path.replaceFirst('file://', ''),
          ),
        ),
      );
    }
  });

  texts.listen((sharedText) {
    SharemeRoute.navigateToFromImage(
      byteData,
      Screens.sharing,
      RouteDirection.right,
      shareObject(
        type: SharingObjectType.text,
        data: sharedText,
        name: shareObject.getshareName(
          SharingObjectType.text,
          sharedText,
        ),
      ),
    );
    return;
  });
}

void _initAnalytics(BuildContext context) {
  if (!kReleaseMode) {
    print('Analytics is disabled since running in the debug mode');
    return;
  }

  if (Hive.box<String>('strings').get('tracking', defaultValue: '1') != '1') {
    print('Analytics is disables by the user');
    return;
  }
}
