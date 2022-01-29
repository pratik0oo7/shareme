// ignore_for_file: use_build_context_synchronously, camel_case_types, prefer_const_constructors, unnecessary_import, unused_import, depend_on_referenced_packages

import 'dart:ui';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:lucide_icons/lucide_icons.dart';
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
    return RepaintBoundary(
      key: _globalKey,
      child: Scaffold(
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
            Hero(
              tag: 'icon',
              child: Logo(),
            ),
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
                color: Colors.deepPurple.shade100,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  TransparentButton(
                    SizedBox(
                      height: 20,
                      width: 20,
                      child: Icon(
                        LucideIcons.languages,
                        color: Colors.deepPurple.shade700,
                        size: 20,
                      ),
                    ),
                    () => SharemeRoute.navigateTo(
                      _globalKey,
                      Screens.languagePicker,
                      RouteDirection.left,
                    ),
                    TransparentButtonBackground.purpleLight,
                  ),
                  const SizedBox(width: 2),
                  TransparentButton(
                    SizedBox(
                      height: 20,
                      width: 20,
                      child: Icon(
                        LucideIcons.helpCircle,
                        color: Colors.deepPurple.shade700,
                        size: 20,
                      ),
                    ),
                    () => SharemeRoute.navigateTo(
                      _globalKey,
                      Screens.intro,
                      RouteDirection.left,
                    ),
                    TransparentButtonBackground.purpleLight,
                  ),
                  const SizedBox(width: 2),
                  TransparentButton(
                    SizedBox(
                      height: 20,
                      width: 20,
                      child: Icon(
                        LucideIcons.settings,
                        color: Colors.deepPurple.shade700,
                        size: 20,
                      ),
                    ),
                    () => SharemeRoute.navigateTo(
                      _globalKey,
                      Screens.settings,
                      RouteDirection.right,
                    ),
                    TransparentButtonBackground.purpleLight,
                  ),
                  // TransparentButton(
                  //     SizedBox(
                  //         height: 20,
                  //         width: 20,
                  //         child: Icon(context.watch<ThemeManager>().icon,
                  //             color: Colors.deepPurple.shade700, size: 20)),
                  //     () => context.read<ThemeManager>().change(),
                  //     TransparentButtonBackground.purpleLight),
                  const Spacer(),
                  TransparentButton(
                    Text(
                      'share Me v$currentVersion →',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 16,
                        color: Colors.deepPurple.shade700,
                      ),
                    ),
                    () => SharemeRoute.navigateTo(
                      _globalKey,
                      Screens.about,
                      RouteDirection.right,
                    ),
                    TransparentButtonBackground.purpleLight,
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.deepPurple.shade100,
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
              con.l.homeHistory,
              style: GoogleFonts.getFont(con.l.fontComfortaa, fontSize: 24),
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
    return Column(
      children: [
        PrimaryButton(
          height: 110,
          onClick: () async {
            final obj = await opendialog(context, const Send());
            if (obj != null) {
              _shareFile(obj);
            }
          },
          text: con.l.homeSend,
          secondaryIcon: Icon(
            LucideIcons.upload,
            size: 42,
            color: Colors.deepPurple.shade200.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 12),
        PrimaryButton(
          height: 60,
          onClick: () async {
            opendialog(context, receive());
          },
          text: con.l.homeReceive,
        )
      ],
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
                  style: GoogleFonts.getFont(
                    con.l.fontAndika,
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
