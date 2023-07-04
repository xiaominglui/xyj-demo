import 'package:authing_sdk/authing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xyj_helper/account_list_page.dart';
import 'package:xyj_helper/task_config.dart';
import 'account.dart';
import 'browser_task_page.dart';
import 'l10n/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'l10n/l10n_utils.dart';
import 'settings_page2.dart';



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

  @override
  void initState() {
    Authing.init('644a98699d66f835f88d4bc8', '644a99927a5a5e9d1f42b4ad');
    super.initState();
    _checkPolicyConfirmed();
  }

  Future<void> _checkPolicyConfirmed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _confirmed = (prefs.getBool('policy_confirmed') ?? false);

    if (!_confirmed) {
      _showPolicyDialog();
    }
  }

  void _showPolicyDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Privacy Policy"),
            content: Text("TBD"),
            actions: <Widget>[
              TextButton(
                child: Text("取消"),
                onPressed: () => _exitAppIfNeeded(),
              ),
              TextButton(
                child: Text("同意"),
                onPressed: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('policy_confirmed', true);
                  Navigator.of(context).pop();
                  // Do something when user accepts
                },
              ),
            ],
          );
        });
  }

  void _exitAppIfNeeded() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Future.delayed(Duration.zero, () {
        SystemNavigator.pop();
      });
    }
  }

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
