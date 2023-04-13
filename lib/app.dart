import 'package:flutter/material.dart';
import 'package:webview_app/account_list_page.dart';
import 'package:webview_app/my_page.dart';
import 'package:webview_app/overview_page.dart';
import 'browser_page.dart';
import 'l10n/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'l10n/l10n_utils.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context).hello,
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('zh', ''),
      ],
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const OverviewPage(),
    const BrowserPage(),
    const AccountListPage(),
    // const MyPage(),
  ];

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
              icon: const Icon(Icons.home_rounded),
              label: AppLocalizations.of(context).overall),
          BottomNavigationBarItem(
              icon: const Icon(Icons.explore_rounded), label: AppLocalizations.of(context).autoTask),
          BottomNavigationBarItem(
              icon: const Icon(Icons.account_tree_rounded), label: AppLocalizations.of(context).accountManager),
          // BottomNavigationBarItem(
          //     icon: Icon(Icons.account_circle_rounded), label: AppLocalizations.of(context).my),
        ],
      ),
    );
  }
}
