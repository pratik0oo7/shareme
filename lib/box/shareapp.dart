// ignore_for_file: always_use_package_imports, deprecated_member_use, camel_case_types

import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shareme/helper.dart';
import 'package:shareme/navigators%20&%20view/buttons.dart';
import 'package:shareme/service/sharingobject_service.dart';

import '../helper.dart';

// review: done
// todo styling

class shareApp extends StatefulWidget {
  @override
  _shareAppState createState() => _shareAppState();
}

class _shareAppState extends State<shareApp> {
  bool _hideSystem = true;
  bool _hideLaunchLess = true;
  List<ApplicationWithIcon> apps = <ApplicationWithIcon>[];
  String _search = '';
  List<ApplicationWithIcon> selected = [];

  @override
  void initState() {
    getApps();
    super.initState();
  }

  Future<void> getApps() async {
    setState(() {
      selected = [];

      apps.clear();
    });

    final arr = await DeviceApps.getInstalledApplications(
      onlyAppsWithLaunchIntent: _hideLaunchLess,
      includeSystemApps: !_hideSystem,
      includeAppIcons: true,
    );

    arr.sort(
      (a, b) => a.appName.toLowerCase().compareTo(
            b.appName.toLowerCase(),
          ),
    );

    setState(() {
      apps = arr.cast<ApplicationWithIcon>();
    });
  }

  @override
  Widget build(BuildContext context) {
    var _apps = <ApplicationWithIcon>[];
    if (_search.isEmpty) {
      _apps = apps;
    } else {
      for (final srch in apps) {
        if (srch.packageName.toLowerCase().contains(_search) ||
            srch.appName.toLowerCase().contains(_search)) {
          _apps.add(srch);
        }
      }
      for (final el in selected) {
        if (!_apps.contains(el)) {
          selected.remove(el);
        }
      }
    }

    return AlertDialog(
      elevation: 0,
      insetPadding: const EdgeInsets.all(24),
      scrollable: true,
      content: SizedBox(
        width: double.maxFinite,
        child: Theme(
          data: context.t.copyWith(
            highlightColor: Colors.transparent,
          ),
          child: Column(
            children: [
              CheckboxListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'Hide system apps',
                  // context.l.selectAppHideSystem,
                  style: GoogleFonts.getFont('Andika'),
                ),
                value: _hideSystem,
                onChanged: (value) => setState(() {
                  _hideSystem = value!;
                  getApps();
                }),
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: Colors.deepPurple.shade400,
              ),
              // todo ditch checkbox list tile :)
              CheckboxListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'Hide non-launchable apps',
                  // context.l.selectAppHideNonLaunch,
                  style: GoogleFonts.getFont('Andika'),
                ),
                value: _hideLaunchLess,
                onChanged: (value) => setState(() {
                  _hideLaunchLess = value!;
                  getApps();
                }),
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: Colors.deepPurple.shade400,
              ),
              TextField(
                onChanged: (value) =>
                    setState(() => _search = value.toLowerCase()),
                decoration: InputDecoration(
                  hintText: 'Search',
                  // hintText: context.l.selectAppSearch,
                ),
              ),
              const SizedBox(height: 14),
              for (final app in _apps)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: ListTile(
                    // todo colors
                    selectedTileColor: context.t.dividerColor.withOpacity(0.08),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: EdgeInsets.zero,
                    leading: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Image.memory(app.icon),
                    ),
                    title: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        app.appName,
                        style: GoogleFonts.getFont(
                          'Andika',
                          fontWeight: selected.contains(app)
                              ? FontWeight.w500
                              : FontWeight.normal,
                          color: context.t.textTheme.bodyText1!.color,
                        ),
                      ),
                    ),
                    subtitle: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        app.packageName,
                        style: GoogleFonts.getFont(
                          'Andika',
                          color: context.t.textTheme.bodyText1!.color,
                        ),
                      ),
                    ),
                    onTap: () => setState(
                      () => selected.contains(app)
                          ? selected.remove(app)
                          : selected.add(app),
                    ),
                    selected: selected.contains(app),
                  ),
                ),
              if (_apps.isEmpty && _search.isEmpty)
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(
                        context.t.accentColor.withOpacity(0.8),
                      ),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
      actions: [
        DialogTextButton('Close',
            // context.l.generalClose,
            () {
          Navigator.of(context).pop();
        }),
        DialogTextButton(
          'Send',
          // context.l.generalSend,
          selected.isEmpty
              ? null
              : () {
                  Navigator.of(context).pop(
                    shareObject(
                      type: SharingObjectType.app,
                      data: selected
                          .map((e) => e.apkFilePath)
                          .join(multipleFilesDelimiter),
                      name:
                          '${selected.length == 1 ? '' : '${selected.length}: '}${selected.map((e) => e.appName).join(' ')}',
                    ),
                  );
                },
        ),
      ],
    );
  }
}
