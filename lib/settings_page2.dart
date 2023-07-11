import 'package:authing_sdk/client.dart';
import 'package:authing_sdk/result.dart';
import 'package:authing_sdk/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appcenter_bundle_updated_to_null_safety/flutter_appcenter_bundle_updated_to_null_safety.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:xyj_helper/l10n/l10n.dart';
import 'package:xyj_helper/membership_page.dart';
import 'package:xyj_helper/utils.dart';

import 'user_info_page.dart';
import 'user_pages.dart';

class SettingsPage2 extends StatefulWidget {
  const SettingsPage2({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage2> {
  User? _currentUser;

  initState() {
    super.initState();
    _getCurrentUser();
  }

  _getCurrentUser() async {
    AuthResult result = await AuthClient.getCurrentUser();
    if (result.code == 200) {
      if (result.user != null) {
        print("_getCurrentUser: ok");
        setState(() {
          _currentUser = result.user;
        });

        AuthResult r = await AuthClient.getCustomData(_currentUser!.id);
        if (r.code == 200) {
          print("_getCustomData: ok");
        } else {
          print("_getCustomData: ${r.message}");
        }
      }
    } else {
      print("_getCurrentUser: ${result.message}");
      setState(() {
        _currentUser = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('settings'),
      onVisibilityChanged: (visibilityInfo) {
        if (visibilityInfo.visibleFraction == 1.0) {
          print('settings Visible');
          _getCurrentUser();
        } else {
          print('settings Invisible');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).settings),
        ),
        body: ListView(
          children: [
            SettingGroup(settings: [
              AccountSettingItem(
                currentUser: _currentUser,
                onTap: () {
                  if (_currentUser != null) {
                    print("logged in");
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('确认退出？'),
                            actions: <Widget>[
                              TextButton(
                                child: Text('取消'),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              TextButton(
                                child: Text('确定'),
                                onPressed: () async {
                                  AuthResult result = await AuthClient.logout();
                                  var code = result.code;
                                  print("logout: $code");
                                  Navigator.pop(context);
                                  setState(() {
                                    _currentUser = null;
                                  });
                                },
                              )
                            ],
                          );
                        });
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SimpleSMSLoginPage()),
                    );
                  }
                },
              ),
            ]),
            SettingGroup(
              settings: [
                SettingItem(
                    title: AppLocalizations.of(context).joinVIP,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MembershipPage()),
                      );
                    }),
                //SettingItem(title: '我的优惠券'),
                //SettingItem(title: '邀请与兑奖'),
              ],
            ),
            // SettingGroup(
            //   settings: [
            //     SettingItem(
            //         title: AppLocalizations.of(context).titleBackupAndRestore),
            //   ],
            // ),
            SettingGroup(
              settings: [
                SettingItem(
                  title: AppLocalizations.of(context).titlePrivacySettings,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PrivacySettingsPage()),
                    );
                  },
                ),
                SettingItem(
                  title: AppLocalizations.of(context).titleHelpAndFeedback,
                  onTap: () {
                    Fluttertoast.showToast(
                      msg: AppLocalizations.of(context).feedbackToast,
                    );
                  },
                ),
                SettingItem(title: AppLocalizations.of(context).titleShare),
                SettingItem(
                  title: AppLocalizations.of(context).titleContactUs,
                  onTap: () {
                    Fluttertoast.showToast(
                      msg: AppLocalizations.of(context).feedbackToast,
                    );
                  },
                ),
              ],
            ),
            SizedBox(
              height: 16.0,
            ),
            FutureBuilder(
              future: PackageInfo.fromPlatform(),
              builder: (_, AsyncSnapshot<PackageInfo> snapshot) {
                if (snapshot.hasData) {
                  final packageInfo = snapshot.data!;

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          print('manual update checking...');
                          await AppCenter.checkForUpdateAsync();
                        },
                        child: Text('version: ${packageInfo.version}',
                            style: TextStyle(color: Colors.grey)),
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      const Text('made with ❤️️ by jeff-studio',
                          style: TextStyle(color: Colors.grey)),
                    ],
                  );
                }

                return const CircularProgressIndicator.adaptive();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SettingGroup extends StatelessWidget {
  final List<StatelessWidget> settings;

  const SettingGroup({super.key, required this.settings});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: settings,
      ),
    );
  }
}

class SettingItem extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  const SettingItem({super.key, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      onTap: onTap,
    );
  }
}

class AccountSettingItem extends StatelessWidget {
  final User? currentUser;
  final VoidCallback? onTap;

  const AccountSettingItem({super.key, this.onTap, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    String displayName = AppLocalizations.of(context).accountsNotLoggedIn;
    if (currentUser != null) {
      displayName = obscurePhoneNumber(currentUser!.phone);
    }
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            currentUser != null
                ? Image.network(currentUser!.photo, height: 96)
                : const Icon(
                    Icons.account_circle,
                    size: 96,
                    color: Colors.grey,
                  ),
            Text(displayName, style: const TextStyle(color: Colors.grey))
          ],
        ),
      ),
    );
  }
}

class PrivacySettingsPage extends StatelessWidget {
  const PrivacySettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).titlePrivacySettings),
      ),
      body: ListView(
        children: const [
          SettingItem(title: '系统权限管理'),
          SettingItem(title: '隐私政策'),
          SettingItem(title: '第三方信息共享清单'),
          SettingItem(title: '设备权限调用列表'),
          SettingItem(title: '个人信息收集清单'),
        ],
      ),
    );
  }
}
