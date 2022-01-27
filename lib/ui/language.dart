import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shareme/main.dart';
import 'package:shareme/navigators%20&%20view/buttons.dart';
import 'package:shareme/navigators%20&%20view/grid.dart';
import 'package:shareme/navigators%20&%20view/page_route.dart';
import 'package:shareme/service/languageservice.dart';

import '../helper.dart';
import '../service/languageservice.dart';

// review: done

class LanguagePickerScreen extends StatelessWidget {
  final _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: _globalKey,
      child: WillPopScope(
        onWillPop: () async {
          final set = context.read<Languagemanager>().isLanguageSet;
          if (set) {
            SharemeRoute.navigateTo(
                _globalKey, Screens.languagePicker, RouteDirection.right);

            return false;
          }

          return true;
        },
        child: Scaffold(
          body: ListView(
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
                // Hero(tag: 'icon', child: SharikLogo()),
                const SizedBox(
                  height: 24,
                ),
                Text(
                  'Select the language\nyou are familiar with',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.getFont(
                    'Comfortaa',
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 24),
                LayoutBuilder(builder: (context, constraints) {
                  return GridView.builder(
                    gridDelegate:
                        SilverGried_fixCrossAxis_FixedHEight(
                      crossAxisCount: constraints.maxWidth < 720 ? 1 : 2,
                      crossAxisSpacing: 18,
                      mainAxisSpacing: 18,
                      height: 80,
                    ),
                    primary: false,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: languagelist.length,
                    itemBuilder: (BuildContext context, int index) =>
                        LanguageButton(languagelist[index], () {
                      final set = context.read<Languagemanager>().isLanguageSet;

                      context.read<Languagemanager>().language =
                          languagelist[index];

                      if (set) {
                        SharemeRoute.navigateTo(
                            _globalKey, Screens.languagePicker, RouteDirection.right);
                      } else {
                        SharemeRoute.navigateTo(
                            _globalKey, Screens.languagePicker, RouteDirection.right);
                      }
                    }),
                  );
                }),
                const SizedBox(height: 24),
              ]),
        ),
      ),
    );
  }
}

class LanguageButton extends StatelessWidget {
  final Language _language;
  final Function() _onClick;

  const LanguageButton(this._language, this._onClick);

  @override
  Widget build(BuildContext context) => PrimaryButton(
        height: 80,
        onClick: _onClick,
        text: _language.nameLocal,
        secondaryIcon: Opacity(
          opacity: 0.4,
          child: SvgPicture.asset(
            'assets/flags/${_language.name}.svg',
          ),
        ),
        font: _language.localizations.fontAndika,
      );
}
