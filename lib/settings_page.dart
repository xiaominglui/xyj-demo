import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import 'account.dart';
import 'account_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  Future<void> _backupAccounts(BuildContext context) async {
    PermissionStatus status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
    }
    if (!status.isGranted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('无法访问外部存储')));
      return;
    }

    final accounts =
        Provider.of<AccountProvider>(context, listen: false).accounts;
    String content = accounts
        .map((account) => '${account.phoneNumber},${account.password}')
        .join('\n');

    Directory? directory = await getApplicationDocumentsDirectory();
    String backupFilePath = '${directory!.path}/xyj_my_accounts.txt';

    File backupFile = File(backupFilePath);
    await backupFile.writeAsString(content);

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('帐号信息备份成功: $backupFilePath')));
  }

  Future<void> _restoreAccounts(BuildContext context) async {
    PermissionStatus status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
    }
    if (!status.isGranted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('无法访问外部存储')));
      return;
    }

    Directory? directory = await getApplicationDocumentsDirectory();
    String backupFilePath = '${directory!.path}/xyj_my_accounts.txt';

    File backupFile = File(backupFilePath);
    if (!await backupFile.exists()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('无有效备份文件')));
      return;
    }

    String content = await backupFile.readAsString();
    List<String> lines = content.split('\n');
    List<Account> restoredAccounts = lines.map((line) {
      List<String> parts = line.split(',');
      return Account(phoneNumber: parts[0], password: parts[1]);
    }).toList();

    final accountProvider =
        Provider.of<AccountProvider>(context, listen: false);
    await accountProvider.restoreAccounts(restoredAccounts);

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('帐号信息恢复成功')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('设置'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () => _backupAccounts(context),
              child: Text('备份'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _restoreAccounts(context),
              child: Text('恢复'),
            ),
          ],
        ),
      ),
    );
  }
}
