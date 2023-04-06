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
  Set<int> _processedAccountIndexes = {};
  final _accountProcessedController = StreamController<void>.broadcast();
  var _completers = Map<int, Completer<void>>();
  bool _isAutoLoggingIn = false;
  bool _isManualStop = false;

  @override
  void dispose() {
    _accountProcessedController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accountProvider = Provider.of<AccountProvider>(context);

    Future<void> _logout() async {
      await _webViewController?.evaluateJavascript('''
        (function() {
          document.getElementsByClassName("header-message-t back")[2].click();
          setTimeout(function() {
            document.querySelector("body > div.modal.modal-in > div.modal-buttons > span.modal-button.modal-button-bold").click();
          }, 500);
        })();
      ''');
    }

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

    Future<void> _autoLogin() async {
      setState(() {
        _isAutoLoggingIn = true;
        _isManualStop = false;
      });
      var length = accountProvider.accounts.length;
      print("autoLogin===${length}");
      _processedAccountIndexes.clear();
      _completers.clear();


      for (int i = 0; i < length && !_isManualStop; i++) {
        _currentAccountIndex = i;
        print("autoLogin===${i}===${_currentAccountIndex}");
        await Future.delayed(Duration(seconds: 3));
        await _loginWithAccount(accountProvider.accounts[i]);
        print("autoLogin waiting===${_currentAccountIndex}");
        _completers[i] = Completer<void>();
        _waitForPageFinishedOrTimeout(i, Duration(seconds: 10));
        await _accountProcessedController.stream.first;
      }

      setState(() {
        _isAutoLoggingIn = false;
      });
    }

    void _onPageFinished(String url) async {
      print("onPageFinished===${_currentAccountIndex}");
      if (_currentAccountIndex > -1) {
        // in auto logging
        if (url == 'https://m.zmxyj.com/login/me.html') {
          if(_processedAccountIndexes.contains(_currentAccountIndex)) {
            return; // if processed, ignore. Due to onPageFinished multi-callback
          }
          accountProvider.toggleLoginStatus(_currentAccountIndex);
          _processedAccountIndexes.add(_currentAccountIndex);
          await Future.delayed(Duration(seconds: 1));
          await _logout();
          await Future.delayed(Duration(seconds: 1));
          _completers[_currentAccountIndex]!.complete();
          _accountProcessedController.add(null);
          print("autoLogin continue via logged in===${_currentAccountIndex}, continue");
        } else {
          print("autoLogin ignore");
        }
      } else {
        // normal loading
        print("normal loading");
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text('浏览')),
      body: Stack(
        children: [
          WebView(
            initialUrl: '$_url',
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _webViewController = webViewController;
            },
            onPageFinished: _onPageFinished,
          ),
          if (_isAutoLoggingIn) _buildAutoLoginOverlay(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _autoLogin,
        child: Icon(Icons.auto_mode),
      ),
    );
  }

  Future<void> _waitForPageFinishedOrTimeout(int p, Duration timeout) async {
    Future.delayed(timeout).then((_) {
      if (!_completers[p]!.isCompleted) {
        print("autoLogin timeout===${p}");
        _accountProcessedController.add(null);
        _completers[p]!.complete();
      } else {
        print("autoLogin page finished===${p}");
      }
    });

    return _completers[p]!.future;
  }



  Widget _buildAutoLoginOverlay() {
    final accountProvider = Provider.of<AccountProvider>(context);
    return Positioned.fill(
      child: Opacity(
        opacity: 0.5,
        child: Container(
          color: Colors.black,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '正在登录：${_currentAccountIndex != -1 ? accountProvider.accounts[_currentAccountIndex].phoneNumber : ''}',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isManualStop = true;
                    });
                  },
                  child: Text('停止自动登录'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
