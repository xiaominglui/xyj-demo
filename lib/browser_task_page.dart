import 'dart:io';

import 'package:authing_sdk/client.dart';
import 'package:authing_sdk/result.dart';
import 'package:image_picker/image_picker.dart' as image_picker;
import 'package:image/image.dart' as image;
import 'package:flutter/material.dart';
import 'package:flutter_appcenter_bundle_updated_to_null_safety/flutter_appcenter_bundle_updated_to_null_safety.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:xyj_helper/account_selector_page.dart';
import 'package:xyj_helper/l10n/l10n.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:xyj_helper/task_config.dart';
import 'package:xyj_helper/utils.dart';
import 'account.dart';
import 'account_provider.dart';
import 'package:provider/provider.dart';
import 'dart:async';

class BrowserTaskPage extends StatefulWidget {
  Account? accountParameter;
  bool autoStart;
  ExecuteType? taskType;

  BrowserTaskPage(
      {super.key,
      required this.accountParameter,
      required this.autoStart,
      required this.taskType});

  @override
  _BrowserTaskPageState createState() => _BrowserTaskPageState();
}

class _BrowserTaskPageState extends State<BrowserTaskPage> {
  final _url = 'https://m.zmxyj.com/#/pages/login/login';
  late final WebViewController _webViewController;
  late AccountProvider _accountProvider;
  int _currentAccountIndex = -1;
  final Set<int> _processedAccountIndexes = {};
  final _accountProcessedController = StreamController<void>.broadcast();
  final _completers = <int, Completer<void>>{};
  bool _isTaskRunning = false;
  bool _isManualStop = false;
  final bool _enableMembership = false;
  ExecuteScope? _taskScope = ExecuteScope.notLoggedInOnly;
  ExecuteType? _taskType;
  final List<Account> _accountsToExecute = List.empty(growable: true);

  _BrowserTaskPageState();

  void _onPageFinished(String url) async {
    print("onPageFinished===$_currentAccountIndex");
    if (_currentAccountIndex > -1) {
      // in auto logging
      if (url == 'https://m.zmxyj.com/#/pages/my/my') {
        if (_processedAccountIndexes.contains(_currentAccountIndex)) {
          return; // if processed, ignore. Due to onPageFinished multi-callback
        }
        _accountProvider
            .markAccountLoggedIn(_accountsToExecute[_currentAccountIndex]);
        _processedAccountIndexes.add(_currentAccountIndex);
        await Future.delayed(const Duration(seconds: 1));
        if (_taskType == ExecuteType.checkIn) {
          await _logout();
          await Future.delayed(const Duration(seconds: 1));
        }

        if (!_completers[_currentAccountIndex]!.isCompleted) {
          _completers[_currentAccountIndex]!.complete();
        }

        _accountProcessedController.add(null);
        print(
            "autoTask continue via logged in===$_currentAccountIndex, continue");
      } else {
        print("autoTask ignore");
      }
    } else {
      // normal loading
      print("normal loading");
      if (widget.autoStart) {
        print("handle one account task===${widget.taskType}");
        if (widget.taskType != null && widget.accountParameter != null) {
          _taskType = widget.taskType;
          _taskScope = ExecuteScope.one;
          startAutoTask(_taskType, _taskScope);
        }
        widget.autoStart = false;
      }
    }
  }

  Future<void> _logout() async {
    await _webViewController.runJavaScript('''
        (function() {
          document.getElementsByClassName("my_header_list_tag")[2].click();
          setTimeout(function() {
            document.querySelector('.uni-modal__btn.uni-modal__btn_primary').click();
          }, 1000);
        })();
      ''');
  }

  @override
  void initState() {
    super.initState();
    print(
        "initState: $widget.autoStart===${widget.accountParameter}===$_taskType===${widget.taskType}");
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
          onUrlChange: (v) {
            debugPrint('Page url changed to: ${v.url}');
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
      (controller.platform as AndroidWebViewController)
          .setOnShowFileSelector(_androidFilePicker);
      (controller.platform as AndroidWebViewController)
          .setOnPlatformPermissionRequest((request) async {
        debugPrint(
          'requesting permissions for ${request.types.map((type) => type.name)}',
        );

        for (var type in request.types) {
          if (type.name == 'camera') {
            if (await Permission.camera.request().isGranted) {
              // Either the permission was already granted before or the user just granted it.
              request.grant();
            } else {
              request.deny();
            }
          }
        }
      });
    }
    // #enddocregion platform_features

    _webViewController = controller;
  }

  @override
  void dispose() {
    _accountProcessedController.close();
    super.dispose();
  }

  Future<void> startAutoTask(ExecuteType? type, ExecuteScope? scope) async {
    AuthResult result = await AuthClient.getCurrentUser();
    if (!_enableMembership || result.code == 200) {
      if (!_enableMembership || result.user != null) {
        AuthResult r = await AuthClient.getCustomData(result.user?.id ?? '-1');
        if (!_enableMembership || r.code == 200) {
          List<dynamic>? customData = result.user?.customData;
          var renewalDate = getNextRenewalTime(customData) ?? 0;
          var renewalDateString = getNextRenewalTimeString(customData) ?? "-";
          print(
              "startAutoTask, logged: ${result.user != null ? "yes" : "no"}, $renewalDateString, ${customData != null ? "yes" : "no"}");
          var vipExpired = isVipExpired(renewalDate);
          AppCenter.trackEventAsync('startAutoTask', <String, String>{
            'renewalDate': 'v[$renewalDateString]',
            'userId': result.user?.id ?? '-1',
          });
          if (_enableMembership && vipExpired) {
            Fluttertoast.showToast(
              msg: AppLocalizations.of(context).vipExpired,
            );
            return;
          }

          _accountsToExecute.clear();
          if (scope == ExecuteScope.one) {
            if (widget.accountParameter != null) {
              _accountsToExecute.add(widget.accountParameter!);
            }
          } else if (scope == ExecuteScope.notLoggedInOnly) {
            var notLoggedInAccounts = _accountProvider.accounts
                .where((a) => !isLoggedToday(a))
                .toList();
            _accountsToExecute.addAll(notLoggedInAccounts);
          } else if (scope == ExecuteScope.all) {
            var allAccounts = _accountProvider.accounts;
            _accountsToExecute.addAll(allAccounts);
          }

          var length = _accountsToExecute.length;
          print("autoTask===$length===[$type]@$scope");

          if (length > 0) {
            if (type == ExecuteType.login && length > 1) {
              print(
                  "autoTask === multiple accounts can not login at the same time now");
              Fluttertoast.showToast(
                  msg: AppLocalizations.of(context).tooManyAccountsToLogIn,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 2,
                  backgroundColor: Colors.blue,
                  textColor: Colors.white,
                  fontSize: 16.0);
            } else {
              setState(() {
                _isTaskRunning = true;
                _isManualStop = false;
              });

              _processedAccountIndexes.clear();
              _completers.clear();

              for (int i = 0; i < length && !_isManualStop; i++) {
                _currentAccountIndex = i;
                print("autoTask===$i===$_currentAccountIndex");
                await Future.delayed(const Duration(seconds: 3));
                await _loginWithAccount(_accountsToExecute[i]);
                print("autoTask waiting===$_currentAccountIndex");
                _completers[i] = Completer<void>();
                _waitForPageFinishedOrTimeout(i, const Duration(seconds: 10));
                await _accountProcessedController.stream.first;
              }

              setState(() {
                _isTaskRunning = false;
              });
            }
          } else {
            print("autoTask === no account need to process");
            Fluttertoast.showToast(
                msg: AppLocalizations.of(context).noAccountsNeedToLogInToday,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 2,
                backgroundColor: Colors.blue,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        } else {
          _toastRetry();
        }
      } else {
        _toastRetry();
      }
    } else {
      _toastRetry();
    }
  }

  void _toastRetry() {
    Fluttertoast.showToast(
        msg: AppLocalizations.of(context).errorOccurred,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  Future<void> _loginWithAccount(Account account) async {
    String phoneNumber = account.phoneNumber;
    String password = account.password;

    await _webViewController.runJavaScript('''
        (function() {
          const needAgreement = document.querySelector('.checkBox_on.checkBox_none');
          if (needAgreement) {
            document.querySelector('.checkBox.login_agreement_check').click();
          } else {
            console.log('has agreement');
          }
          
          const clearIconElement = document.querySelector('.u-icon.u-icon--right');
          if (clearIconElement) {
            clearIconElement.click();
          } else {
            console.log('clear button NOT exist');
          }
          
          document.querySelectorAll('input')[0].valueAsNumber = '$phoneNumber';
          document.querySelectorAll('input')[0].dispatchEvent(new Event('input'));
          
          document.querySelectorAll('input')[1].value = '$password';
          document.querySelectorAll('input')[1].dispatchEvent(new Event('input'));
          
          var arithmeticQuestion = document.querySelector('.register_cont_list_text').querySelector('span').textContent.replace(/&nbsp;/g, '');
          var result = eval(arithmeticQuestion.slice(0, -1));
          
          document.querySelectorAll('input')[2].value = result;
          document.querySelectorAll('input')[2].dispatchEvent(new Event('input'));

          
          // alert("question: " + arithmeticQuestion + " result: " + result);
          // alert("password: " + document.getElementById('password').value);
          
          setTimeout(function() {
            document.querySelector('.login_btn .apy_buttom_confirm_large').click();
          }, 500);
        })();
      ''');
  }

  @override
  Widget build(BuildContext context) {
    _accountProvider = Provider.of<AccountProvider>(context);
    return VisibilityDetector(
        key: const Key('browser_task'),
        onVisibilityChanged: (visibilityInfo) {
          if (visibilityInfo.visibleFraction == 1.0) {
            print('browser_task Visible');
          } else {
            print('browser_task Invisible');
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context).autoTask),
            actions: [
              IconButton(
                icon: const Icon(Icons.auto_mode),
                onPressed: _showBottomSheet,
                tooltip: AppLocalizations.of(context).composeAutoTask,
              ),
              // IconButton(
              //   icon: const Icon(Icons.coffee),
              //   onPressed: _showBuyMeCoffee,
              //   tooltip: AppLocalizations.of(context).buyMeCoffee,
              // )
            ],
          ),
          body: SafeArea(
            child: Stack(
              children: [
                WebViewWidget(controller: _webViewController),
                if (_isTaskRunning) _buildAutoTaskOverlay(),
              ],
            ),
          ),
        ));
  }

  void _showBuyMeCoffee() {
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
                    Column(
                      children: [
                        Text(
                          AppLocalizations.of(context).chooseTaskType,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        ListTile(
                          title: Text(AppLocalizations.of(context).checkInTask),
                          leading: Radio<ExecuteType>(
                            value: ExecuteType.checkIn,
                            groupValue: _taskType,
                            onChanged: (ExecuteType? value) {
                              setState(() {
                                _taskType = value;
                              });
                            },
                          ),
                        ),
                        ListTile(
                          title: Text(AppLocalizations.of(context).logInTask),
                          leading: Radio<ExecuteType>(
                            value: ExecuteType.login,
                            groupValue: _taskType,
                            onChanged: (ExecuteType? value) {
                              setState(() {
                                _taskType = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    _taskType == ExecuteType.login
                        ? ListTile(
                            title: widget.accountParameter == null
                                ? const Text('')
                                : Text(widget.accountParameter!.phoneNumber),
                            subtitle: widget.accountParameter == null
                                ? const Text('')
                                : Text(widget.accountParameter!.alias),
                            trailing: widget.accountParameter == null
                                ? IconButton(
                                    icon: const Icon(Icons.add_circle),
                                    onPressed: () async {
                                      Account selectedAccount =
                                          await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const AccountSelectorPage()),
                                      );
                                      setState(() {
                                        widget.accountParameter =
                                            selectedAccount;
                                      });
                                    },
                                  )
                                : IconButton(
                                    icon: const Icon(Icons.remove_circle),
                                    onPressed: () {
                                      setState(() {
                                        widget.accountParameter = null;
                                      });
                                    },
                                  ),
                          )
                        : Column(
                            children: [
                              Text(
                                AppLocalizations.of(context)
                                    .chooseTheExecutionScope,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              ListTile(
                                title: Text(AppLocalizations.of(context)
                                    .accountsNotLoggedIn),
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
                                title: Text(
                                    AppLocalizations.of(context).allAccounts),
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
                            ],
                          ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          startAutoTask(_taskType, _taskScope);
                        },
                        child:
                            Text(AppLocalizations.of(context).startToExecute),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
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
                  Column(
                    children: [
                      Text(
                        AppLocalizations.of(context).chooseTaskType,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      ListTile(
                        title: Text(AppLocalizations.of(context).checkInTask),
                        leading: Radio<ExecuteType>(
                          value: ExecuteType.checkIn,
                          groupValue: _taskType,
                          onChanged: (ExecuteType? value) {
                            setState(() {
                              _taskType = value;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: Text(AppLocalizations.of(context).logInTask),
                        leading: Radio<ExecuteType>(
                          value: ExecuteType.login,
                          groupValue: _taskType,
                          onChanged: (ExecuteType? value) {
                            setState(() {
                              _taskType = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  _taskType == ExecuteType.login
                      ? ListTile(
                          title: widget.accountParameter == null
                              ? const Text('')
                              : Text(widget.accountParameter!.phoneNumber),
                          subtitle: widget.accountParameter == null
                              ? const Text('')
                              : Text(widget.accountParameter!.alias),
                          trailing: widget.accountParameter == null
                              ? IconButton(
                                  icon: const Icon(Icons.add_circle),
                                  onPressed: () async {
                                    Account selectedAccount =
                                        await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const AccountSelectorPage()),
                                    );
                                    setState(() {
                                      widget.accountParameter = selectedAccount;
                                    });
                                  },
                                )
                              : IconButton(
                                  icon: const Icon(Icons.remove_circle),
                                  onPressed: () {
                                    setState(() {
                                      widget.accountParameter = null;
                                    });
                                  },
                                ),
                        )
                      : Column(
                          children: [
                            Text(
                              AppLocalizations.of(context)
                                  .chooseTheExecutionScope,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            ListTile(
                              title: Text(AppLocalizations.of(context)
                                  .accountsNotLoggedIn),
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
                              title: Text(
                                  AppLocalizations.of(context).allAccounts),
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
                          ],
                        ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        startAutoTask(_taskType, _taskScope);
                      },
                      child: Text(AppLocalizations.of(context).startToExecute),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _waitForPageFinishedOrTimeout(int p, Duration timeout) async {
    Future.delayed(timeout).then((_) {
      if (!_completers[p]!.isCompleted) {
        print("autoTask timeout===$p");
        _accountProcessedController.add(null);
        _completers[p]!.complete();
      } else {
        print("autoTask page finished===$p");
      }
    });

    return _completers[p]!.future;
  }

  Widget _buildAutoTaskOverlay() {
    return Positioned.fill(
      child: Opacity(
        opacity: 0.8,
        child: Container(
          color: Colors.black,
          child: Align(
            alignment: Alignment.topCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${AppLocalizations.of(context).inProcessing}：${_currentAccountIndex != -1 ? _accountsToExecute[_currentAccountIndex].phoneNumber : ''}',
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
                const SizedBox(height: 500),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isManualStop = true;
                    });
                  },
                  child: Text(AppLocalizations.of(context).stopTask),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<List<String>> _androidFilePicker(FileSelectorParams params) async {
    if (params.acceptTypes.any((type) => true)) {
      final picker = image_picker.ImagePicker();
      final photo =
          await picker.pickImage(source: image_picker.ImageSource.gallery);

      if (photo == null) {
        return [];
      }

      final imageData = await photo.readAsBytes();
      final decodedImage = image.decodeImage(imageData)!;
      final scaledImage = image.copyResize(decodedImage, width: 500);
      final jpg = image.encodeJpg(scaledImage, quality: 90);

      final filePath = (await getTemporaryDirectory()).uri.resolve(
            './image_${DateTime.now().microsecondsSinceEpoch}.jpg',
          );
      final file = await File.fromUri(filePath).create(recursive: true);
      await file.writeAsBytes(jpg, flush: true);

      return [file.uri.toString()];
    }

    return [];
  }
}
