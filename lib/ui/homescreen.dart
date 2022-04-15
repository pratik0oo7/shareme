// ignore_for_file: use_build_context_synchronously, camel_case_types, prefer_const_constructors, unnecessary_import, unused_import, depend_on_referenced_packages, implementation_imports

import 'dart:ui';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/src/provider.dart';
import 'package:shareme/box/dialog.dart';
import 'package:shareme/box/receivedi.dart';
import 'package:shareme/box/senddialog.dart';
import 'package:shareme/box/track.dart';
import 'package:shareme/configfile.dart';
import 'package:shareme/helper.dart';
import 'package:shareme/navigators%20&%20view/buttons.dart';
import 'package:shareme/navigators%20&%20view/page_route.dart';
import 'package:shareme/navigators%20&%20view/sharemelogo.dart';
import 'package:shareme/service/localizationservice.dart';
import 'package:shareme/service/themeservice.dart';

class homeScreen extends StatefulWidget {
  @override
  _homeScreenState createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  List<shareObject> _history = <shareObject>[];
  final _globalKey = GlobalKey();

  @override
  void initState() {
    _history = Hive.box<shareObject>('history').values.toList();
    _checkTracking();

    super.initState();
  }

  Future<void> _checkTracking() async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (!Hive.box<String>('strings').containsKey('tracking')) {
      opendialog(context, const Trackbox());
    }
  }

  Future<void> _saveLatest() async {
    await Hive.box<shareObject>('history').clear();
    await Hive.box<shareObject>('history').addAll(_history);
  }

  Future<void> _shareFile(shareObject file) async {
    setState(() {
      _history.removeWhere((element) => element.name == file.name);

      _history.insert(0, file);
    });

    await _saveLatest();

    SharemeRoute.navigateTo(
      _globalKey,
      Screens.sharing,
      RouteDirection.right,
      file,
    );
  }

  @override
  Widget build(BuildContext con) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.deepOrange.shade50,
        body: RepaintBoundary(
          key: _globalKey,
          child: Scaffold(
            backgroundColor: Colors.deepOrange.shade50,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SafeArea(
                  bottom: false,
                  left: false,
                  right: false,
                  child: SizedBox(
                    height: 22,
                  ),
                ),
                // Hero(
                // tag: 'icon',
                // child: ,
                // ),
                const SizedBox(height: 24),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // todo review constraints
                      if (constraints.maxWidth < 720) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            children: [
                              _sharingButtons(con),
                              const SizedBox(
                                height: 24,
                              ),
                              Expanded(
                                child: _sharingHistoryList(con),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(width: 24),
                            Expanded(child: _sharingButtons(con)),
                            const SizedBox(width: 24),
                            Expanded(child: _sharingHistoryList(con)),
                            const SizedBox(width: 24),
                          ],
                        );
                      }
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade100,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Row(
                    children: [
                      // IconButton(
                      //   icon: Icon(
                      //     LucideIcons.languages,
                      //     size: 20,
                      //   ),
                      //   onPressed: () {
                      //     SharemeRoute.navigateTo(
                      //       _globalKey,
                      //       Screens.languagePicker,
                      //       RouteDirection.left,
                      //     );
                      //   },
                      // ),
                      const SizedBox(width: 2),
                      IconButton(
                        icon: Icon(
                          LucideIcons.helpCircle,
                          size: 20,
                        ),
                        onPressed: () {
                          SharemeRoute.navigateTo(
                            _globalKey,
                            Screens.intro,
                            RouteDirection.left,
                          );
                        },
                      ),
                      const SizedBox(width: 2),
                      IconButton(
                        icon: Icon(
                          LucideIcons.settings2,
                          color: Colors.deepPurple.shade700,
                          size: 20,
                        ),
                        onPressed: () {
                          SharemeRoute.navigateTo(
                            _globalKey,
                            Screens.settings,
                            RouteDirection.left,
                          );
                        },
                      ),
                      const Spacer(),
                      TextButton(
                        child: Text(
                          'v$currentVersion ',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 16,
                          ),
                        ),
                        onPressed: () {
                          SharemeRoute.navigateTo(
                            _globalKey,
                            Screens.about,
                            RouteDirection.right,
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  // color: Colors.deepPurple.shade100,
                  child: SafeArea(
                    top: false,
                    right: false,
                    left: false,
                    child: Container(),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sharingHistoryList(BuildContext con) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 4),
      // shrinkWrap: true,
      // todo there's probably a more elegant way to do this
      itemCount: _history.length + 1,
      itemBuilder: (context, index) => index == 0
          ? _sharingHistoryHeader(con)
          : _card(context, _history[index - 1]),
    );
  }

  Widget _sharingHistoryHeader(BuildContext con) {
    if (_history.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            Text(
              'History',
              style: TextStyle(fontSize: 24),
            ),
            const Spacer(),
            TransparentButton(
              const Icon(LucideIcons.trash),
              () {
                setState(() => _history.clear());

                _saveLatest();
              },
              TransparentButtonBackground.purpleDark,
            )
          ],
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  Widget _sharingButtons(BuildContext con) {
    return Padding(
      padding: const EdgeInsets.only(top: 150.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          FloatingActionButton.large(
            onPressed: () async {
              final obj = await opendialog(context, const Send());
              if (obj != null) {
                _shareFile(obj);
              }
            },
            child: Icon(
              LucideIcons.upload,
              size: 42,
            ),
          ),
          const SizedBox(width: 20),
          FloatingActionButton.large(
            onPressed: () async {
              opendialog(context, receive());
            },
            child: Icon(
              LucideIcons.download,
              size: 42,
            ),
          ),
        ],
      ),
    );
  }

  Widget _card(BuildContext con, shareObject shr) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ListButton(
        Row(
          children: [
            Icon(
              shr.icon,
              size: 22,
              color: Colors.grey.shade100,
              // semanticsLabel: 'file',
              // width: 18,
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  shr.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                  maxLines: 1,
                ),
              ),
            )
          ],
        ),
        () => _shareFile(shr),
      ),
    );
  }
}
