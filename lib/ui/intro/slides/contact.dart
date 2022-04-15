// ignore_for_file: use_named_constants, camel_case_types

import 'package:flutter/material.dart';
import 'package:shareme/configfile.dart';
import 'package:shareme/navigators%20&%20view/page_route.dart';

class contactslide extends StatelessWidget {
  final AnimationController animationController;
  const contactslide({Key? key, required this.animationController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _globalkey = GlobalKey();
    final _firstHalfAnimation =
        Tween<Offset>(begin: const Offset(1, 0), end: const Offset(0, 0))
            .animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(
          0.6,
          0.8,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );
    final _secondHalfAnimation =
        Tween<Offset>(begin: const Offset(0, 0), end: const Offset(-1, 0))
            .animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(
          0.8,
          1.0,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );

    final _welcomeFirstHalfAnimation =
        Tween<Offset>(begin: const Offset(2, 0), end: const Offset(0, 0))
            .animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(
          0.6,
          0.8,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );

    final _welcomeImageAnimation =
        Tween<Offset>(begin: const Offset(4, 0), end: const Offset(0, 0))
            .animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(
          0.6,
          0.8,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );
    return SafeArea(
      top: false,
      child: Center(
        child: RepaintBoundary(
          key: _globalkey,
          child: SlideTransition(
            position: _firstHalfAnimation,
            child: SlideTransition(
              position: _secondHalfAnimation,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 100),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SlideTransition(
                      position: _welcomeImageAnimation,
                      child: Container(
                        constraints:
                            const BoxConstraints(maxWidth: 350, maxHeight: 350),
                        // ignore: deprecated_member_use
                        child: FlatButton(
                          padding: const EdgeInsets.only(left: 8.0),
                          onPressed: () {
                            SharemeRoute.navigateTo(
                              _globalkey,
                              Screens.home,
                              RouteDirection.left,
                            );
                          },
                          child: Image.asset(
                            'assets/introduction_animation/welcome.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    SlideTransition(
                      position: _welcomeFirstHalfAnimation,
                      child: const Text(
                        'Welcome',
                        style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // ignore: prefer_const_constructors
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 64,
                        right: 64,
                        top: 16,
                        bottom: 16,
                      ),
                      // ignore: prefer_const_constructors
                      child: Text(
                        'Share & Sync',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
