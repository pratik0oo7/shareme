// ignore_for_file: avoid_dynamic_calls, import_of_legacy_library_into_null_safe, implementation_imports
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:shareme/ui/browser/browser.dart';
// import 'package:shareme/service/coreprovider.dart';
// import 'package:shareme/ui/file/browse.dart';
import 'package:shareme/ui/homescreen.dart';
import 'package:shareme/ui/settingScreen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late PageController _pageController;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      // Provider.of<CoreProvider>(context, listen: false).checkSpace();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: onPageChanged,
        children: <Widget>[
          browserScreen(),
          homeScreen(),
          settingScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.deepOrange.shade50,
        selectedItemColor: Colors.blue.shade900,
        unselectedItemColor: Colors.black, elevation: 4.0,
        type: BottomNavigationBarType.fixed,
        // ignore: prefer_const_literals_to_create_immutables
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            icon: Icon(LucideIcons.folder),
            label: 'Browse',
          ),
          const BottomNavigationBarItem(
            icon: Icon(LucideIcons.share),
            label: 'Share',
          ),
          const BottomNavigationBarItem(
            icon: Icon(LucideIcons.settings),
            label: 'Settings',
          ),
        ],
        onTap: navigationTapped,
        currentIndex: _page,
      ),
    );
  }

  void navigationTapped(int page) {
    _pageController.jumpToPage(page);
  }
}
