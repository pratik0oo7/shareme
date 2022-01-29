// ignore_for_file: deprecated_member_use, unused_import, depend_on_referenced_packages, directives_ordering, always_use_package_imports, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shareme/configfile.dart';

import 'package:shareme/service/themeservice.dart';

import 'service/languageservice.dart';
import 'service/themeservice.dart';
import 'ui/language.dart';
import 'ui/load.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Languagemanager()),
        ChangeNotifierProvider(create: (_) => thememanager())
      ],
      child: const Shareme(),
    ),
  );
}

class Shareme extends StatelessWidget {
  const Shareme({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: context.watch<thememanager>().brightness == Brightness.dark
          ? SystemUiOverlayStyle.light.copyWith(
              statusBarColor: Colors.grey.shade900.withOpacity(0.4),
              systemNavigationBarColor: Colors.deepPurple.shade100,
              // systemNavigationBarDividerColor: Colors.deepPurple.shade100,
              systemNavigationBarIconBrightness: Brightness.dark,
            )
          : SystemUiOverlayStyle.dark.copyWith(
              statusBarColor: Colors.grey.shade100.withOpacity(0.6),
              systemNavigationBarColor: Colors.deepPurple.shade100,
              // systemNavigationBarDividerColor: Colors.deepPurple.shade100,
              systemNavigationBarIconBrightness: Brightness.dark,
            ),
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          return ResponsiveWrapper.builder(
            ScrollConfiguration(
              behavior: BouncingScrollBehavior(),
              child: child!,
            ),
            maxWidth: 400,
            defaultScale: true,
            breakpoints: [
              const ResponsiveBreakpoint.resize(400, name: MOBILE),
              const ResponsiveBreakpoint.autoScale(680, name: TABLET),
              const ResponsiveBreakpoint.autoScale(
                1100,
                name: DESKTOP,
                scaleFactor: 1.2,
              ),
            ],
            breakpointsLandscape: [
              const ResponsiveBreakpoint.autoScale(
                400,
                name: MOBILE,
                scaleFactor: 0.7,
              ),
              const ResponsiveBreakpoint.autoScale(
                680,
                name: TABLET,
                scaleFactor: 0.7,
              ),
              const ResponsiveBreakpoint.autoScale(
                1100,
                name: DESKTOP,
                scaleFactor: 0.7,
              )
            ],
          );
        },
        // devicepreview.appbuilder
        locale: context.watch<Languagemanager>().language.locale,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: languagelist.map((e) => e.locale),
        title: 'Share And Connect',
        theme: ThemeData(
          brightness: Brightness.light,
          inputDecorationTheme: InputDecorationTheme(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey.shade900.withOpacity(0.8),
                width: 2,
              ),
            ),
          ),
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: Colors.grey.shade200.withOpacity(0.9),
            selectionHandleColor: Colors.deepPurple.shade100.withOpacity(0.6),
          ),
          // Shareme top icon color
          accentColor: Colors.deepPurple.shade500,
          // right click select color
          cardColor: Colors.grey.shade200.withOpacity(0.9),
          // default button color
          dividerColor: Colors.deepPurple.shade400,
          // cardcolor
          buttonColor: Colors.deepPurple.shade50.withOpacity(0.6),
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          inputDecorationTheme: InputDecorationTheme(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.deepPurple.shade50.withOpacity(0.8),
                width: 2,
              ),
            ),
          ),

          // primarySwatch: Colors.grey,

          textSelectionTheme: TextSelectionThemeData(
            cursorColor: Colors.deepPurple.shade50,
            selectionHandleColor: Colors.deepPurple.shade300.withOpacity(0.9),
            selectionColor: Colors.deepPurple.shade50.withOpacity(0.4),
          ),

          // sharme top icon color
          accentColor: Colors.deepPurple.shade300,

          // right click selection color
          cardColor: Colors.deepPurple.shade400.withOpacity(0.9),

          // color of the button on the default background
          dividerColor: Colors.deepPurple.shade50,

          // about card color
          buttonColor: Colors.deepPurple.shade100.withOpacity(0.8),
        ),
        themeMode: context.watch<thememanager>().theme,
        home: LoadingScreen(),
      ),
    );
  }
}
