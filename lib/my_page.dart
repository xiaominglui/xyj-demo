import 'package:flutter/material.dart';
import 'package:webview_app/l10n/l10n.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            ListTile(
              title: Text(AppLocalizations.of(context).settings),
              onTap: () {
                // TODO: 实现设置页面
              },
            ),
            ListTile(
              title: Text(AppLocalizations.of(context).share),
              onTap: () {
                // TODO: 实现分享功能
              },
            ),
            ListTile(
              title: Text(AppLocalizations.of(context).about),
              onTap: () {
                // TODO: 实现关于页面
              },
            ),
          ],
        ),
      ),
    );
  }
}
