import 'package:flutter/material.dart';
import 'package:xyj_helper/l10n/l10n.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:xyj_helper/task_config.dart';
import 'account.dart';
import 'account_provider.dart';
import 'package:provider/provider.dart';
import 'dart:async';

class BrowserPage extends StatefulWidget {
  const BrowserPage({super.key});

  @override
  _BrowserPageState createState() => _BrowserPageState();
}

class _BrowserPageState extends State<BrowserPage> {
  final _url = 'https://m.zmxyj.com/login/index';
  late final WebViewController _webViewController;
  late AccountProvider _accountProvider;
  int _currentAccountIndex = -1;
  final Set<int> _processedAccountIndexes = {};
  final _accountProcessedController = StreamController<void>.broadcast();
  final _completers = <int, Completer<void>>{};
  bool _isAutoLoggingIn = false;
  bool _isManualStop = false;
  ExecuteScope? _taskScope = ExecuteScope.notLoggedInOnly;
  ExecuteType _taskType = ExecuteType.auto;

  void _onPageFinished(String url) async {
    print("onPageFinished===$_currentAccountIndex");
    if (_currentAccountIndex > -1) {
      // in auto logging
      if (url == 'https://m.zmxyj.com/login/me.html') {
        if (_processedAccountIndexes.contains(_currentAccountIndex)) {
          return; // if processed, ignore. Due to onPageFinished multi-callback
        }
        _accountProvider.toggleLoginStatus(_currentAccountIndex);
        _processedAccountIndexes.add(_currentAccountIndex);
        await Future.delayed(const Duration(seconds: 1));
        await _logout();
        await Future.delayed(const Duration(seconds: 1));
        _completers[_currentAccountIndex]!.complete();
        _accountProcessedController.add(null);
        print(
            "autoLogin continue via logged in===$_currentAccountIndex, continue");
      } else {
        print("autoLogin ignore");
      }
    } else {
      // normal loading
      print("normal loading");
    }
  }

  Future<void> _logout() async {
    await _webViewController.runJavaScript('''
        (function() {
          document.getElementsByClassName("header-message-t back")[2].click();
          setTimeout(function() {
            document.querySelector("body > div.modal.modal-in > div.modal-buttons > span.modal-button.modal-button-bold").click();
          }, 500);
        })();
      ''');
  }

  @override
  void initState() {
    super.initState();
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);
    // #enddocregion platform_features

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {
            debugPrint('Page started loading: $url');
          },
          onPageFinished: (String url) {
            debugPrint('Page finished loading: $url');
            _onPageFinished(url);
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('''
Page resource error:
  code: ${error.errorCode}
  description: ${error.description}
  errorType: ${error.errorType}
  isForMainFrame: ${error.isForMainFrame}
          ''');
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              debugPrint('blocking navigation to ${request.url}');
              return NavigationDecision.prevent;
            }
            debugPrint('allowing navigation to ${request.url}');
            return NavigationDecision.navigate;
          },
        ),
      )
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        },
      )
      ..loadRequest(Uri.parse(_url));

    // #docregion platform_features
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
    // #enddocregion platform_features

    _webViewController = controller;
  }

  @override
  void dispose() {
    _accountProcessedController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _accountProvider = Provider.of<AccountProvider>(context);

    Future<void> _loginWithAccount(Account account) async {
      String phoneNumber = account.phoneNumber;
      String password = account.password;

      await _webViewController.runJavaScript('''
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



    void _beginCompose() {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          final theme = Theme.of(context);
          // Using Wrap makes the bottom sheet height the height of the content.
          // Otherwise, the height will be half the height of the screen.

          return Wrap(
            children: [
              ListTile(
                title: const Text(
                  'Header',
                ),
                tileColor: theme.colorScheme.primary,
              ),
              const ListTile(
                title: Text('Execute Scope'),
              ),
              Column(
                children: <Widget>[
                  RadioListTile<ExecuteScope>(
                    title: const Text('notLoggedInOnly 2'),
                    value: ExecuteScope.notLoggedInOnly,
                    groupValue: _taskScope,
                    onChanged: (ExecuteScope? value) {
                      setState(() {
                        _taskScope = value;
                      });
                    },
                  ),
                  RadioListTile<ExecuteScope>(
                    title: const Text('all 2'),
                    value: ExecuteScope.all,
                    groupValue: _taskScope,
                    onChanged: (ExecuteScope? value) {
                      setState(() {
                        _taskScope = value;
                      });
                    },
                  ),
                ],
              ),
              const ListTile(
                title: Text('Title 3'),
              ),
              const ListTile(
                title: Text('Title 4'),
              ),
              ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.start),
                  label: const Text("立即执行")),
            ],
          );
        },
      );
    }

    Future<void> _startAutoLogin(ExecuteScope? scope) async {
      setState(() {
        _isAutoLoggingIn = true;
        _isManualStop = false;
      });
      var length = _accountProvider.accounts.length;
      print("autoLogin===$length===@$scope");
      _processedAccountIndexes.clear();
      _completers.clear();

      // get accounts list to login by filtering out accounts based on scope


      for (int i = 0; i < length && !_isManualStop; i++) {
        _currentAccountIndex = i;
        print("autoLogin===$i===$_currentAccountIndex");
        await Future.delayed(const Duration(seconds: 3));
        await _loginWithAccount(_accountProvider.accounts[i]);
        print("autoLogin waiting===$_currentAccountIndex");
        _completers[i] = Completer<void>();
        _waitForPageFinishedOrTimeout(i, const Duration(seconds: 10));
        await _accountProcessedController.stream.first;
      }

      setState(() {
        _isAutoLoggingIn = false;
      });
    }

    void _showBottomSheet() {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'Choose the execution scope',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    ListTile(
                      title: const Text('Accounts not logged in'),
                      leading: Radio<ExecuteScope>(
                        value: ExecuteScope.notLoggedInOnly,
                        groupValue: _taskScope,
                        onChanged: (ExecuteScope? value) {
                          setState(() {
                            _taskScope = value;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('All accounts'),
                      leading: Radio<ExecuteScope>(
                        value: ExecuteScope.all,
                        groupValue: _taskScope,
                        onChanged: (ExecuteScope? value) {
                          setState(() {
                            _taskScope = value;
                          });
                        },
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _startAutoLogin(_taskScope);
                      },
                      child: const Text('Start to execute'),
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    }

    return Scaffold(
      // appBar: AppBar(title: Text('浏览')),
      body: SafeArea(
        child: Stack(
          children: [
            WebViewWidget(controller: _webViewController),
            if (_isAutoLoggingIn) _buildAutoLoginOverlay(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // onPressed: _beginCompose,
        onPressed: _showBottomSheet,
        tooltip: AppLocalizations.of(context).composeAutoTask,
        child: const Icon(Icons.auto_mode),
      ),
    );
  }

  Future<void> _waitForPageFinishedOrTimeout(int p, Duration timeout) async {
    Future.delayed(timeout).then((_) {
      if (!_completers[p]!.isCompleted) {
        print("autoLogin timeout===$p");
        _accountProcessedController.add(null);
        _completers[p]!.complete();
      } else {
        print("autoLogin page finished===$p");
      }
    });

    return _completers[p]!.future;
  }

  Widget _buildAutoLoginOverlay() {
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
                  '正在登录：${_currentAccountIndex != -1 ? _accountProvider.accounts[_currentAccountIndex].phoneNumber : ''}',
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isManualStop = true;
                    });
                  },
                  child: const Text('停止自动登录'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}