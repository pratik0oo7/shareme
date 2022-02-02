// ignore_for_file: camel_case_types, avoid_dynamic_calls, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:shareme/configfile.dart';
import 'package:shareme/helper.dart';
import 'package:shareme/navigators%20&%20view/page_route.dart';
import 'package:shareme/ui/intro/next.dart';
import 'package:shareme/ui/intro/skip.dart';
import 'package:shareme/ui/intro/slides/connect.dart';
import 'package:shareme/ui/intro/slides/contact.dart';
import 'package:shareme/ui/intro/slides/receive.dart';
import 'package:shareme/ui/intro/slides/send.dart';
import 'package:shareme/ui/intro/slides/welcome.dart';
import 'package:url_launcher/url_launcher.dart';

class introductionScreen extends StatelessWidget {
  final _globalkey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: _globalkey,
      child: WillPopScope(
        onWillPop: () async {
          SharemeRoute.navigateTo(
            _globalkey,
            Screens.home,
            RouteDirection.right,
          );
          return false;
        },
        child: Scaffold(
          body: IntroSlider(
            isScrollable: true,
            colorDot: Colors.white70,
            colorActiveDot: Colors.white,
            // todo check border radius compared to the bottom bar
            borderRadiusDoneBtn: 8,
            showSkipBtn: false,
            renderNextBtn: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 14),
              child: Text(
                context.l.introGeneralNext,
                style: GoogleFonts.getFont(
                  context.l.fontComfortaa,
                  color: Colors.white,
                ),
              ),
            ),
            renderDoneBtn: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 14),
              child: Text(
                context.l.introGeneralDone,
                style: GoogleFonts.getFont(
                  context.l.fontComfortaa,
                  color: Colors.white,
                ),
              ),
            ),
            onDonePress: () => SharemeRoute.navigateTo(
              _globalkey,
              Screens.home,
              RouteDirection.right,
            ),
            slides: [
              Slide(
                styleTitle: GoogleFonts.getFont(
                  context.l.fontComfortaa,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                ),
                styleDescription: GoogleFonts.getFont(
                  context.l.fontAndika,
                  color: Colors.white,
                  fontSize: 18.0,
                ),
                title: context.l.intro1ConnectTitle,
                description: context.l.intro1ConnectDescription,
                pathImage: 'assets/slides/1_connect.png',
                backgroundColor: Colors.purple.shade400,
              ),
              Slide(
                styleTitle: GoogleFonts.getFont(
                  context.l.fontComfortaa,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                ),
                styleDescription: GoogleFonts.getFont(
                  context.l.fontAndika,
                  color: Colors.white,
                  fontSize: 18.0,
                ),
                title: context.l.intro2SendTitle,
                description: context.l.intro2SendDescription,
                pathImage: 'assets/slides/2_send.png',
                backgroundColor: Colors.indigo.shade400,
              ),
              Slide(
                styleTitle: GoogleFonts.getFont(
                  context.l.fontComfortaa,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                ),
                styleDescription: GoogleFonts.getFont(
                  context.l.fontAndika,
                  color: Colors.white,
                  fontSize: 18.0,
                ),
                title: context.l.intro3ReceiveTitle,
                description: context.l.intro3ReceiveDescription,
                pathImage: 'assets/slides/3_receive.png',
                backgroundColor: Colors.teal.shade400,
              ),
              Slide(
                styleTitle: GoogleFonts.getFont(
                  context.l.fontComfortaa,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
                title: context.l.intro4EverywhereTitle,
                pathImage: 'assets/slides/4_everywhere.png',
                backgroundColor: Colors.blueGrey.shade400,
                widgetDescription: GestureDetector(
                  onTap: () async {
                    if (await canLaunch(
                      'https://github.com/pratik0oo7/shareme',
                    )) {
                      await launch('https://github.com/pratik0oo7/shareme');
                    }
                  },
                  child: Text(
                    context.l.intro4EverywhereDescription,
                    style: GoogleFonts.getFont(
                      context.l.fontAndika,
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 12,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Introductionanimation extends StatefulWidget {
  const Introductionanimation({Key? key}) : super(key: key);

  @override
  _IntroductionanimationState createState() => _IntroductionanimationState();
}

class _IntroductionanimationState extends State<Introductionanimation>
    with TickerProviderStateMixin {
  final _globalkey = GlobalKey();
  AnimationController? _animationController;
  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 8));
    _animationController?.animateTo(0.0);
    super.initState();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(_animationController?.value);
    return RepaintBoundary(
      key: _globalkey,
      child: WillPopScope(
        onWillPop: () async {
          SharemeRoute.navigateTo(
            _globalkey,
            Screens.home,
            RouteDirection.right,
          );
          return false;
        },
        child: Scaffold(
          backgroundColor: Color(0xffF7EBE1),
          body: ClipRect(
            child: Stack(
              children: [
                welcomeslide(
                  animationController: _animationController!,
                ),
                connectslide(
                  animationController: _animationController!,
                ),
                sendslide(
                  animationController: _animationController!,
                ),
                receiveslide(
                  animationController: _animationController!,
                ),
                contactslide(
                  animationController: _animationController!,
                ),
                TopBackSkipView(
                  onBackClick: _onBackClick,
                  onSkipClick: _onSkipClick,
                  animationController: _animationController!,
                ),
                CenterNextButton(
                  animationController: _animationController!,
                  onNextClick: _onNextClick,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onSkipClick() {
    _animationController?.animateTo(
      0.8,
      duration: Duration(milliseconds: 1200),
    );
  }

  void _onBackClick() {
    if (_animationController!.value >= 0 &&
        _animationController!.value <= 0.2) {
      _animationController?.animateTo(0.0);
    } else if (_animationController!.value > 0.2 &&
        _animationController!.value <= 0.4) {
      _animationController?.animateTo(0.2);
    } else if (_animationController!.value > 0.4 &&
        _animationController!.value <= 0.6) {
      _animationController?.animateTo(0.4);
    } else if (_animationController!.value > 0.6 &&
        _animationController!.value <= 0.8) {
      _animationController?.animateTo(0.6);
    } else if (_animationController!.value > 0.8 &&
        _animationController!.value <= 1.0) {
      _animationController?.animateTo(0.8);
    }
  }

  void _onNextClick() {
    if (_animationController!.value >= 0 &&
        _animationController!.value <= 0.2) {
      _animationController?.animateTo(0.4);
    } else if (_animationController!.value > 0.2 &&
        _animationController!.value <= 0.4) {
      _animationController?.animateTo(0.6);
    } else if (_animationController!.value > 0.4 &&
        _animationController!.value <= 0.6) {
      _animationController?.animateTo(0.8);
    } else if (_animationController!.value > 0.6 &&
        _animationController!.value <= 0.8) {
      _signUpClick();
    }
  }

  void _signUpClick() {
    Navigator.pop(context);
  }
}
