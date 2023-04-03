import 'package:flutter/material.dart';
import 'account.dart';
import 'account_provider.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatelessWidget {
  final _phoneNumberController = TextEditingController();
  final _passwordController = TextEditingController();

  void _addAccount(BuildContext context) {
    String phoneNumber = _phoneNumberController.text;
    String password = _passwordController.text;

    if (phoneNumber.isNotEmpty && password.isNotEmpty) {
      Provider.of<AccountProvider>(context, listen: false).addAccount(Account(
        phoneNumber: phoneNumber,
        password: password,
      ));
    }
  }

  void _showAddAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('新增帐号'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _phoneNumberController,
                decoration: InputDecoration(labelText: '手机号'),
                keyboardType: TextInputType.phone,
              ),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: '登录密码'),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _addAccount(context);
                Navigator.pop(context);
              },
              child: Text('添加'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('取消'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final accountProvider = Provider.of<AccountProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text('帐号')),
      body: ListView.builder(
        itemCount: accountProvider.accounts.length,
        itemBuilder: (context, index) {
          Account account = accountProvider.accounts[index];
          return ListTile(
            title: Text('手机号: ${account.phoneNumber}'),
            subtitle: Text('登录状态: ${account.isLoggedIn ? '已登录' : '未登录'}'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddAccountDialog(context),
        child: Icon(Icons.add),
      ),
    );
  }
}