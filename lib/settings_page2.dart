import 'package:flutter/material.dart';
import 'package:xyj_helper/l10n/l10n.dart';

class SettingsPage2 extends StatelessWidget {
  const SettingsPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).settings),
      ),
      body: ListView(
        children: [
          SettingGroup(settings: [
            AccountSettingItem(),
          ]),
          SettingGroup(
            settings: [
              SettingItem(title: '开通VIP会员'),
              SettingItem(title: '我的优惠券'),
              SettingItem(title: '邀请与兑奖'),
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

  SettingGroup({required this.settings});

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

  SettingItem({required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      onTap: onTap,
    );
  }
}

class AccountSettingItem extends StatelessWidget {
  final String username;
  final VoidCallback? onTap;

  AccountSettingItem({this.username = '未登录', this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.account_circle,
              size: 96,
              color: Colors.grey,
            ),
            Text('未登录', style: TextStyle(color: Colors.grey))
          ],
        ),
      ),
    );
  }
}

class PrivacySettingsPage extends StatelessWidget {
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
