// ignore_for_file: avoid_unused_constructor_parameters, prefer_const_constructors_in_immutables, camel_case_types, file_names, unused_field, prefer_const_constructors

import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shareme/box/selectnetwork.dart';
import 'package:shareme/helper.dart';
import 'package:shareme/navigators%20&%20view/page_route.dart';
import 'package:shareme/service/ipservice.dart';
import 'package:shareme/service/sharingobject_service.dart';
import 'package:wakelock/wakelock.dart';

import '../box/dialog.dart';
import '../configfile.dart';
import '../navigators & view/buttons.dart';
import '../service/sharing_service.dart';

class shareScreen extends StatefulWidget {
  // shareScreen( {Key? key, this._file, this.}) : super(key: key);
  final shareObject _file;
  const shareScreen(this._file);
  @override
  State<shareScreen> createState() => _shareScreenState();
}

class _shareScreenState extends State<shareScreen>
    with TickerProviderStateMixin {
  late AnimationController _conController;
  late Animation<double> _conAnimation;

  late shareObject _file;

  final localIpservice _ipService = localIpservice();
  late SharingService _sharingService;

  bool _stateShowQr = false;

  @override
  void dispose() {
    _sharingService.end();

    if (_conController.isAnimating) _conController.stop();

    if (!Platform.isLinux) {
      Wakelock.disable();
    }

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // todo init stuff in a separate method
    _file = widget._file;

    _ipService.load();

    _sharingService = SharingService(_file, context);
    _sharingService.start();

    _conController = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    _conAnimation = Tween(begin: 0.0, end: pi).animate(_conController);

    if (!Platform.isLinux) {
      Wakelock.enable();
    }
  }

  final _globalKey = GlobalKey();

  void _exitPage() {
    SharemeRoute.navigateTo(_globalKey, Screens.home, RouteDirection.left);
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: _globalKey,
      child: Scaffold(
        body: WillPopScope(
          onWillPop: () {
            _exitPage();
            return Future.value(false);
          },
          child: GestureDetector(
            onHorizontalDragEnd: (DragEndDetails details) {
              if ((details.primaryVelocity ?? 0) > 0) {
                _exitPage();
              }
            },
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              children: [
                const SafeArea(
                  bottom: false,
                  left: false,
                  right: false,
                  child: SizedBox(
                    height: 22,
                  ),
                ),
                Stack(
                  children: [
                    // Hero(
                    //   tag: 'icon',
                    //   child: SharikLogo(),
                    // ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: TransparentButton(
                            const Icon(LucideIcons.chevronLeft, size: 28),
                            () => _exitPage(),
                            TransparentButtonBackground.purpleDark),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                LayoutBuilder(builder: (context, constraints) {
                  if (constraints.maxWidth < 720) {
                    return Column(
                      children: [
                        fileConnectivitySection(context),
                        const SizedBox(height: 38),
                        const SizedBox(height: 38),
                        linkSection(context),
                      ],
                    );
                  } else {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: fileConnectivitySection(context)),
                        const SizedBox(width: 24),
                        Expanded(child: linkSection(context)),
                      ],
                    );
                  }
                }),
                const SizedBox(height: 38),
                SizedBox(
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

  Widget fileConnectivitySection(BuildContext context) {
    final fileNameScroller = ScrollController();

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.deepPurple.shade400,
          ),
          child: Row(
            children: [
              Icon(
                _file.icon,
                size: 24,
                color: Colors.grey.shade200,
                //todo: add semantics stuff everywhere
                // semanticsLabel: 'file',
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: Scrollbar(
                  isAlwaysShown: true,
                  controller: fileNameScroller,
                  child: SingleChildScrollView(
                    controller: fileNameScroller,
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      _file.data
                          .toString()
                          .replaceAll(multipleFilesDelimiter, ' '),
                      style: GoogleFonts.andika(
                        // 'Andika',
                        color: Colors.grey.shade50,
                        fontSize: 18,
                      ),
                      maxLines: 1,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.deepPurple.shade400,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(LucideIcons.wifi, color: Colors.grey.shade50, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: ChangeNotifierProvider.value(
                  value: _ipService,
                  builder: (context, _) {
                    context.watch<localIpservice>();
                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.zero,
                            child: Text(
                              connectivity2string(
                                  // todo do language inside too
                                  _ipService.getConnectivityType()),
                              style: GoogleFonts.andika(
                                // context.l.fontAndika,
                                color: Colors.grey.shade50,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Text(
                            'Connect to Wi-Fi or set up a Mobile Hotspot',
                            // context.l.sharingConnectToWiFiOrHotspot,
                            style: GoogleFonts.andika(
                              // context.l.fontAndika,
                              fontSize: 16,
                              color: Colors.grey.shade100,
                            ),
                          ),
                        ]);
                  },
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              // todo do not use pure white (about screen)
              Padding(
                padding: const EdgeInsets.all(3),
                child: TransparentButton(
                    AnimatedBuilder(
                        animation: _conAnimation,
                        builder: (context, child) {
                          return Transform.rotate(
                              angle: _conAnimation.value, child: child);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(1),
                          child: Icon(
                            LucideIcons.refreshCw,
                            size: 14,
                            color: Colors.grey.shade100,
                          ),
                        )), () {
                  _conController.forward(from: 0);
                  _ipService.load();
                }, TransparentButtonBackground.purpleDark),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget linkSection(BuildContext context) {
    final urlScroller = ScrollController();

    return Column(
      children: [
        Center(
            child: Text(
          'Now open this link\nin any browser',
          // context.l.sharingOpenInBrowser,
          style: GoogleFonts.comfortaa(
            // context.l.fontComfortaa,
            fontSize: 20,
          ),
          textAlign: TextAlign.center,
        )),
        const SizedBox(height: 14),
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: _ipService),
            ChangeNotifierProvider.value(value: _sharingService),
          ],
          builder: (context, _) {
            context.watch<localIpservice>();
            context.watch<SharingService>();

            final displayAddress =
                'http://${_ipService.getIp()}:${_sharingService.port ?? 'Loading'}';
            return Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.deepPurple.shade400,
                      borderRadius: BorderRadius.circular(12)),
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Scrollbar(
                    controller: urlScroller,
                    isAlwaysShown: true,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      controller: urlScroller,
                      child: Row(
                        children: [
                          Text(
                            'http://',
                            style: GoogleFonts.getFont('Andika',
                                color: Colors.grey.shade50, fontSize: 14),
                          ),
                          Text(
                            displayAddress.replaceFirst('http://', ''),
                            style: GoogleFonts.getFont('Andika',
                                color: Colors.grey.shade50, fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade400,
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12)),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TransparentButton(
                          Icon(LucideIcons.qrCode,
                              size: 17, color: Colors.grey.shade50),
                          () => setState(() => _stateShowQr = !_stateShowQr),
                          TransparentButtonBackground.purpleDark),
                      const SizedBox(width: 2),
                      TransparentButton(
                          Icon(LucideIcons.copy,
                              size: 17, color: Colors.grey.shade50), () {
                        Clipboard.setData(ClipboardData(text: displayAddress))
                            .then((result) {
                          final snackBar = SnackBar(
                            backgroundColor: Colors.deepPurple.shade500,
                            duration: const Duration(seconds: 1),
                            content: Text(
                              'Copied to Clipboard',
                              // context.l.sharingCopiedToClipboard,
                              style: GoogleFonts.andika(
                                // context.l.fontAndika,
                                  color: Colors.grey.shade50),
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        });
                      }, TransparentButtonBackground.purpleDark),
                      const SizedBox(width: 2),
                      TransparentButton(
                          Icon(LucideIcons.network,
                              size: 17, color: Colors.grey.shade50), () {
                        // todo make sure we have loaded the interfaces
                        opendialog(context, picknetworkdialog(_ipService));
                      }, TransparentButtonBackground.purpleDark),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                AnimatedSize(
                  vsync: this,
                  duration: const Duration(milliseconds: 200),
                  child: _stateShowQr
                      ? QrImage(
                          data: displayAddress,
                          foregroundColor: context.t.textTheme.button!.color,
                        )
                      : const SizedBox(),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 38),
        const SizedBox(height: 38),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.deepPurple.shade300,
          ),
          child: Text(
            'The recipient needs to be connected\nto the same network',
            // context.l.sharingRecipientNeedsToBeConnected,
            textAlign: TextAlign.center,
            style: GoogleFonts.andika(
              // context.l.fontAndika,
                color: Colors.white, fontSize: 18),
          ),
        ),
      ],
    );
  }
}
