import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_app/my_page.dart';
import 'package:webview_app/overview_page.dart';
import 'browse_page.dart';
import 'account_page.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    OverviewPage(),
    BrowsePage(),
    AccountPage(),
    MyPage(),
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
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: '概览'),
          BottomNavigationBarItem(icon: Icon(Icons.explore_rounded), label: '自动登录'),
          BottomNavigationBarItem(icon: Icon(Icons.account_tree_rounded), label: '帐号管理'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle_rounded), label: '我的'),
        ],
      ),
    );
  }
}
