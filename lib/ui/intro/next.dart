// ignore_for_file: require_trailing_commas, use_named_constants, avoid_redundant_argument_values, sort_child_properties_last

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:shareme/configfile.dart';
import 'package:shareme/navigators%20&%20view/page_route.dart';

class CenterNextButton extends StatelessWidget {
  final AnimationController animationController;
  final VoidCallback onNextClick;
  const CenterNextButton(
      {Key? key, required this.animationController, required this.onNextClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _globalkey = GlobalKey();
    final _topMoveAnimation =
        Tween<Offset>(begin: const Offset(0, 5), end: const Offset(0, 0))
            .animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(
          0.0,
          0.2,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );
    final _signUpMoveAnimation = Tween<double>(begin: 0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(
          0.6,
          0.8,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );
    final _loginTextMoveAnimation =
        Tween<Offset>(begin: const Offset(0, 5), end: const Offset(0, 0))
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
      child: RepaintBoundary(
        key: _globalkey,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: 16 + MediaQuery.of(context).padding.bottom,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SlideTransition(
                position: _topMoveAnimation,
                child: AnimatedBuilder(
                  animation: animationController,
                  builder: (context, child) => AnimatedOpacity(
                    opacity: animationController.value >= 0.2 &&
                            animationController.value <= 0.6
                        ? 1
                        : 0,
                    duration: const Duration(milliseconds: 480),
                    child: _pageView(),
                  ),
                ),
              ),
              SlideTransition(
                position: _topMoveAnimation,
                child: AnimatedBuilder(
                  animation: animationController,
                  builder: (context, child) => Padding(
                    padding: EdgeInsets.only(
                      bottom: 38 - (0 * _signUpMoveAnimation.value),
                    ),
                    child: Container(
                      height: 58,
                      width: 58 + (150 * _signUpMoveAnimation.value),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          8 + 30 * (20 - _signUpMoveAnimation.value),
                        ),
                        color: const Color(0xff132137),
                      ),
                      child: PageTransitionSwitcher(
                        duration: const Duration(milliseconds: 480),
                        reverse: _signUpMoveAnimation.value < 0.7,
                        transitionBuilder: (
                          Widget child,
                          Animation<double> animation,
                          Animation<double> secondaryAnimation,
                        ) {
                          return SharedAxisTransition(
                            fillColor: Colors.transparent,
                            child: child,
                            animation: animation,
                            secondaryAnimation: secondaryAnimation,
                            transitionType: SharedAxisTransitionType.vertical,
                          );
                        },
                        child: _signUpMoveAnimation.value > 0.7
                            ? InkWell(
                                key: const ValueKey('Sign Up button'),
                                onTap: () {
                                  SharemeRoute.navigateTo(
                                    _globalkey,
                                    Screens.main,
                                    RouteDirection.right,
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  // ignore: prefer_const_literals_to_create_immutables
                                  children: <Widget>[
                                    const Flexible(
                                      child: Center(
                                        child: Text(
                                          'Sign up',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : InkWell(
                                key: const ValueKey('next button'),
                                onTap: onNextClick,
                                child: const Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Icon(
                                    LucideIcons.arrowRight,
                                    size: 25,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: SlideTransition(
                  position: _loginTextMoveAnimation,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        '',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Text(
                        '',
                        style: TextStyle(
                          color: Color(0xff132137),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pageView() {
    int _selectedIndex = 0;

    if (animationController.value >= 0.7) {
      _selectedIndex = 3;
    } else if (animationController.value >= 0.5) {
      _selectedIndex = 2;
    } else if (animationController.value >= 0.3) {
      _selectedIndex = 1;
    } else if (animationController.value >= 0.1) {
      _selectedIndex = 0;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < 4; i++)
            Padding(
              padding: const EdgeInsets.all(4),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 480),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  color: _selectedIndex == i
                      ? const Color(0xff132137)
                      : const Color(0xffE3E4E4),
                ),
                width: 10,
                height: 10,
              ),
            )
        ],
      ),
    );
  }
}
