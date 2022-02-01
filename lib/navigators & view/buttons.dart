// ignore_for_file: unnecessary_import, always_use_package_imports, require_trailing_commas, avoid_redundant_argument_values

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../helper.dart';

class PrimaryButton extends StatelessWidget {
  final Function()? onClick;
  final String text;
  final int height;
  final int fontSize;
  final int roundedRadius;
  final bool loading;

  final Widget? secondaryIcon;
  final String? font;

  const PrimaryButton({
    required this.onClick,
    required this.text,
    required this.height,
    this.secondaryIcon,
    this.loading = false,
    this.font,
    this.fontSize = 24,
    // todo maybe enum for radius and fontSize?
    this.roundedRadius = 12,
  });

//   // todo reevaluate hover and splash colors
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height.toDouble(),
      child: Material(
        borderRadius: BorderRadius.circular(roundedRadius.toDouble()),
        shadowColor: Colors.amber,
        color: Colors.deepPurple, // language button color
        borderOnForeground: true,
        child: InkWell(
          splashColor: Colors.blue.shade300.withOpacity(0.4),
          hoverColor: Colors.red.shade200.withOpacity(0.12),
          highlightColor: Colors.amber,
          focusColor: Colors.brown.withOpacity(1),
          borderRadius: BorderRadius.circular(roundedRadius.toDouble()),
          onTap: onClick,
          child: secondaryIcon != null
              ? Stack(
                  children: [
                    Align(
                      alignment: const Alignment(0.9, 0.0),
                      child: secondaryIcon,
                    ),
                    // Language text property
                    Center(
                      child: Text(
                        text,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.getFont(
                          font ?? context.l.fontAndika,
                          color: Colors.white70, //language text color
                          fontSize: fontSize.toDouble(),
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ],
                )
              : Center(
                  child: loading
                      ? SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.4,
                            valueColor: AlwaysStoppedAnimation<Color?>(
                              Colors.deepOrange.shade100,
                            ),
                          ),
                        )
                      : Text(
                          text,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.getFont(
                            font ?? context.l.fontAndika,
                            color: Colors.green.shade100,
                            fontSize: fontSize.toDouble(),
                          ),
                        ),
                ),
        ),
      ),
    );
  }
}

class DialogTextButton extends StatelessWidget {
  final String text;
  final Function()? onClick;

  const DialogTextButton(this.text, this.onClick);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.indigo,
      borderRadius: BorderRadius.circular(6),
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        splashColor: context.t.dividerColor.withOpacity(0.08),
        hoverColor: context.t.dividerColor.withOpacity(0.04),
        highlightColor: Colors.transparent,
        focusColor: Colors.pink.withOpacity(0.2),
        onTap: onClick,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
          child: Text(
            text,
            style: GoogleFonts.getFont(
              context.l.fontAndika,
              fontSize: 15,
              color: onClick != null
                  ? context.t.dividerColor
                  : context.t.dividerColor.withOpacity(0.6),
            ),
          ),
        ),
      ),
    );
  }
}

class TransparentButton extends StatelessWidget {
  final Widget child;
  final Function() onClick;
  final TransparentButtonBackground background;
  final bool border;

  const TransparentButton(this.child, this.onClick, this.background,
      {this.border = false});

  @override
  Widget build(BuildContext context) {
    Color splashColor;
    Color hoverColor;

    switch (background) {
      case TransparentButtonBackground.def:
        splashColor = context.t.dividerColor.withOpacity(0.08);
        hoverColor = context.t.dividerColor.withOpacity(0.04);
        break;
      case TransparentButtonBackground.purpleLight:
        splashColor = Colors.teal.shade300.withOpacity(0.16);
        hoverColor = Colors.yellow.shade200.withOpacity(0.6);
        break;
      case TransparentButtonBackground.purpleDark:
        splashColor = Colors.teal.shade200.withOpacity(0.2);
        hoverColor = Colors.lime.shade200.withOpacity(0.4);
        break;
    }

    return Material(
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: border
              ? Colors.deepOrange.shade100.withOpacity(0.16)
              : Colors.yellowAccent,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      color: Colors.blueAccent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        splashColor: splashColor,
        hoverColor: hoverColor,
        highlightColor: Colors.blueGrey,
        focusColor: Colors.cyanAccent.withOpacity(0.2),
        onTap: onClick,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          child: child,
        ),
      ),
    );
  }
}

class ListButton extends StatelessWidget {
  final Widget child;
  final Function() onPressed;

  const ListButton(this.child, this.onPressed);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(12),
      color: Colors.deepOrangeAccent,
      child: InkWell(
        splashColor: Colors.greenAccent.shade100.withOpacity(0.2),
        hoverColor: Colors.tealAccent.shade100.withOpacity(0.4),
        highlightColor: Colors.redAccent,
        focusColor: Colors.white10.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: child,
        ),
      ),
    );
  }
}

enum TransparentButtonBackground { def, purpleLight, purpleDark }
