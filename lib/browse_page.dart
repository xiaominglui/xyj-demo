import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'account.dart';
import 'account_provider.dart';
import 'package:provider/provider.dart';
import 'dart:async';

class BrowsePage extends StatefulWidget {
  @override
  _BrowsePageState createState() => _BrowsePageState();
}

class _BrowsePageState extends State<BrowsePage> {
  final _url = 'https://m.zmxyj.com/login/index';
  WebViewController? _webViewController;
  int _currentAccountIndex = -1;

  @override
  Widget build(BuildContext context) {
    final accountProvider = Provider.of<AccountProvider>(context);

    Future<void> _loginWithAccount(Account account) async {
      String phoneNumber = account.phoneNumber;
      String password = account.password;

      await _webViewController?.evaluateJavascript('''
        (function() {
          document.getElementById('phone').value = '$phoneNumber';
          document.getElementById('password').value = '$password';
          var arithmeticQuestion = document.getElementById('newCode').innerText.replace(/&nbsp;/g, '');
          var result = eval(arithmeticQuestion.slice(0, -1));
          document.getElementById('veryCode').value = result;
          // alert("qestion: " + arithmeticQuestion + " result: " + result);
          document.getElementById('login-btn').click();
        })();
      ''');
    }

    void _autoLogin() async {
      for (int i = 0; i < accountProvider.accounts.length; i++) {
        _currentAccountIndex = i;
        await _loginWithAccount(accountProvider.accounts[i]);
        await Future.delayed(Duration(seconds: 1));
      }
    }

    void _onPageFinished(String url) {
      if (url == 'https://m.zmxyj.com/login/me.html' && _currentAccountIndex != -1) {
        accountProvider.updateLoginStatus(_currentAccountIndex, true);
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text('浏览')),
      body: WebView(
        initialUrl: '$_url',
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _webViewController = webViewController;
        },
        onPageFinished: _onPageFinished,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _autoLogin,
        child: Icon(Icons.login),
      ),
    );
  }
}
