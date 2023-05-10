import 'package:authing_sdk_v3/client.dart';
import 'package:authing_sdk_v3/result.dart';
import 'package:authing_sdk_v3/user.dart';
import 'package:flutter/material.dart';
import 'package:xyj_helper/l10n/l10n.dart';

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
    if (result.statusCode == 200) {
      if (result.user != null) {
        print("_getCurrentUser: ok");
        setState(() {
          _currentUser = result.user;
        });
      }
    } else {
      print("_getCurrentUser: ${result.message}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).settings),
      ),
      body: ListView(
        children: [
          SettingGroup(settings: [
            AccountSettingItem(
              currentUser: _currentUser,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SimpleSMSLoginPage()),
                );
              },
            ),
          ]),
          SettingGroup(
            settings: [
              SettingItem(title: '开通VIP会员'),
              //SettingItem(title: '我的优惠券'),
              //SettingItem(title: '邀请与兑奖'),
            ],
          ),
          SettingGroup(
            settings: [
              SettingItem(title: '帐号导出与导入'),
            ],
          ),
          SettingGroup(
            settings: [
              SettingItem(
                title: '隐私设置',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PrivacySettingsPage()),
                  );
                },
              ),
              SettingItem(title: '帮助与反馈'),
              SettingItem(title: '分享给朋友'),
              SettingItem(title: '联系我们'),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text('version: 1.0.0 ', style: TextStyle(color: Colors.grey))
            ],
          ),
        ],
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
      displayName = currentUser!.phone;
    }
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
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
        title: Text('隐私设置'),
      ),
      body: ListView(
        children: [
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
