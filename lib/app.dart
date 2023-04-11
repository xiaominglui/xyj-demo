import 'package:flutter/material.dart';
import 'package:webview_app/account_list_page.dart';
import 'package:webview_app/my_page.dart';
import 'package:webview_app/overview_page.dart';
import 'browse_page.dart';
import 'l10n/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) =>
      DemoLocalizations.of(context).title,
      localizationsDelegates: const [
        DemoLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('es', ''),
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
    const BrowsePage(),
    const AccountListPage(),
    const MyPage(),
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
      appBar: AppBar(title: Text(DemoLocalizations.of(context).title),),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: '概览'),
          BottomNavigationBarItem(icon: Icon(Icons.explore_rounded), label: '自动登录'),
          BottomNavigationBarItem(icon: Icon(Icons.account_tree_rounded), label: '帐号管理'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle_rounded), label: '我的'),
        ],
      ),
    );
  }
}
