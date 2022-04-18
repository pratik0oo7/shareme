import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:shareme/box/dialog.dart';
import 'package:shareme/box/track.dart';
import 'package:shareme/configfile.dart';
import 'package:shareme/helper.dart';
import 'package:shareme/navigators%20&%20view/page_route.dart';
import 'package:shareme/service/themeservice.dart';

import '../navigators & view/buttons.dart'
    show TransparentButton, TransparentButtonBackground;

// todo tweak colors
// todo checkboxes look weird

class settingScreen extends StatelessWidget {
  final _globalKey = GlobalKey();

  void _exit(BuildContext context) {
    SharemeRoute.navigateTo(_globalKey, Screens.home, RouteDirection.left);
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: _globalKey,
      child: Scaffold(
        body: WillPopScope(
          onWillPop: () {
            _exit(context);
            return Future.value(false);
          },
          child: GestureDetector(
            onHorizontalDragEnd: (DragEndDetails details) {
              if ((details.primaryVelocity ?? 0) > 0) {
                _exit(context);
              }
            },
            child: Column(
              children: [
                ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  children: [
                    const SafeArea(
                      bottom: false,
                      left: false,
                      right: false,
                      child: SizedBox(height: 22),
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
                              () => _exit(context),
                              TransparentButtonBackground.def,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Theme(
                      data: context.t.copyWith(
                        splashColor: context.t.dividerColor.withOpacity(0.08),
                        highlightColor: Colors.transparent,
                      ),
                      child: LayoutBuilder(builder: (context, constraints) {
                        if (constraints.maxWidth < 720) {
                          return Column(
                            children: [
                              _appearanceSection(context),
                              const SizedBox(height: 24),
                              _privacySection(context),
                            ],
                          );
                        } else {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: _appearanceSection(context)),
                              const SizedBox(width: 24),
                              Expanded(child: _privacySection(context)),
                            ],
                          );
                        }
                      }),
                    ),
                    const SizedBox(height: 22),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _appearanceSection(BuildContext context) {
    final box = Hive.box<String>('strings');
    const transition = 'disable_transition_effects';
    const blur = 'disable_blur';

    return Column(
      children: [
        Text('Appearance',
            // context.l.settingsAppearance,
            textAlign: TextAlign.center,
            style: GoogleFonts.comfortaa(
                // context.l.fontComfortaa,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 14),
        ListTile(
            hoverColor: context.t.dividerColor.withOpacity(0.04),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            leading: const Icon(LucideIcons.sun),
            onTap: () {
              context.read<thememanager>().change();
            },
            title: Text(
              'Theme',
              // context.l.settingsTheme,
              style: GoogleFonts.andika(),
            ),
            trailing: Text(
              context.watch<thememanager>().name(context),
              style: GoogleFonts.comfortaa(),
            )),
        const SizedBox(height: 8),
        ListTile(
          hoverColor: context.t.dividerColor.withOpacity(0.04),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          leading: const Icon(LucideIcons.move),
          onTap: () {
            box.put(transition,
                box.get(transition, defaultValue: '0')! == '0' ? '1' : '0');
          },
          title: Text(
            'Disable screen transitions',
            // context.l.settingsDisableScreenTransitions,
            style: GoogleFonts.andika(),
          ),
          trailing: StreamBuilder<BoxEvent>(
              stream: box.watch(key: transition),
              initialData: BoxEvent(
                  transition, box.get(transition, defaultValue: '0'), false),
              builder: (_, snapshot) => Checkbox(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                    value: snapshot.data!.value as String == '1',
                    onChanged: (val) {
                      box.put(transition, val! ? '1' : '0');
                    },
                    activeColor: Colors.deepPurple.shade300,
                  )),
        ),
        const SizedBox(height: 8),
        ListTile(
          hoverColor: context.t.dividerColor.withOpacity(0.04),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          leading: const Icon(LucideIcons.palette),
          onTap: () {
            box.put(blur, box.get(blur, defaultValue: '0')! == '0' ? '1' : '0');
          },
          title: Text(
            'Disable blur',
            // context.l.settingsDisableBlur,
            style: GoogleFonts.andika(),
          ),
          trailing: StreamBuilder<BoxEvent>(
              stream: box.watch(key: blur),
              initialData:
                  BoxEvent(blur, box.get(blur, defaultValue: '0'), false),
              builder: (_, snapshot) => Checkbox(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                    value: snapshot.data!.value as String == '1',
                    onChanged: (val) {
                      box.put(blur, val! ? '1' : '0');
                    },
                    activeColor: Colors.deepPurple.shade300,
                  )),
        ),
      ],
    );
  }

  Widget _privacySection(BuildContext context) {
    final box = Hive.box<String>('strings');

    return Column(
      children: [
        Text('Privacy',
            // context.l.settingsPrivacy,
            textAlign: TextAlign.center,
            style: GoogleFonts.comfortaa(
                // context.l.fontComfortaa,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 14),
        ListTile(
            hoverColor: context.t.dividerColor.withOpacity(0.04),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            leading: const Icon(LucideIcons.pieChart),
            onTap: () {
              opendialog(context, const Trackbox());
            },
            title: Text(
              'Disable',
              // context.l.settingsDisableTracking,
              style: GoogleFonts.andika(),
            ),
            trailing: StreamBuilder<BoxEvent>(
              stream: box.watch(key: 'tracking'),
              initialData: BoxEvent(
                  'tracking', box.get('tracking', defaultValue: '1'), false),
              builder: (context, data) => Switch(
                  value: data.data!.value == '0',
                  activeColor: Colors.deepPurple.shade200,
                  onChanged: (_) {
                    opendialog(context, const TrackingConsentDialog());
                  }),
            )),
      ],
    );
  }
}
