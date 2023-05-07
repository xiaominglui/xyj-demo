import 'package:flutter/material.dart';
import 'package:xyj_helper/account_list_page.dart';
import 'package:xyj_helper/settings_page.dart';
import 'package:xyj_helper/task_config.dart';
import 'account.dart';
import 'browser_task_page.dart';
import 'l10n/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'l10n/l10n_utils.dart';
import 'settings_page2.dart';

import 'package:authing_sdk_v3/authing.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context).appName,
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
  Account? _accountParameter;
  ExecuteType _executeType = ExecuteType.checkIn;
  bool _autoStart = false;



  void _onTap(int index) {
    setState(() {
      _autoStart = false;
      _currentIndex = index;
      _accountParameter = null;
    });
  }

  void _navigateToTaskTabWithAccountParameterAndStart(
      int index, Account? parameter, ExecuteType executeType) {
    print(
        '_navigateToTabWithAccountParameterAndStart===$index===${parameter?.phoneNumber}===$executeType');
    setState(() {
      _autoStart = true;
      _currentIndex = index;
      _accountParameter = parameter;
      _executeType = executeType;
    });
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    final List<Widget> pages = [
      // const OverviewPage(),
      AccountListPage(
          onOneAccountTaskRequest: (Account account, ExecuteType executeType) {
            print('callback onOneAccountTaskRequest');
        _navigateToTaskTabWithAccountParameterAndStart(1, account, executeType);
      }),
      BrowserTaskPage(
          accountParameter: _accountParameter, autoStart: _autoStart, taskType: _executeType),
      const SettingsPage2(),
      // const MyPage(),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
        type: BottomNavigationBarType.fixed,
        items: [
          // BottomNavigationBarItem(
          //     icon: const Icon(Icons.home_rounded),
          //     label: AppLocalizations.of(context).overall),
          BottomNavigationBarItem(
              icon: const Icon(Icons.account_tree_rounded), label: AppLocalizations.of(context).accountManager),
          BottomNavigationBarItem(
              icon: const Icon(Icons.explore_rounded), label: AppLocalizations.of(context).autoTask),
          BottomNavigationBarItem(
              icon: const Icon(Icons.settings), label: AppLocalizations.of(context).settings),
        ],
      ),
    );
  }
}
