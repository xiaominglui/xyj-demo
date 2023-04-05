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
    _phoneNumberController.clear();
    _passwordController.clear();
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
          return _AccountItem(account: account, onToggle: () => accountProvider.toggleLoginStatus(index), onLongPress: () => _showAccountContextMenu(context, account),);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddAccountDialog(context),
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _showAccountContextMenu(BuildContext context, Account account) async {
    final accountProvider = Provider.of<AccountProvider>(context, listen: false);
    final selected = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(100, 100, 100, 100),
      items: [
        PopupMenuItem<String>(value: 'edit', child: Text('编辑')),
        PopupMenuItem<String>(value: 'delete', child: Text('删除')),
      ],
    );

    if (selected == 'edit') {
      _editAccount(context, account);
    } else if (selected == 'delete') {
      accountProvider.deleteAccount(account.id!);
    }
  }

  Future<void> _editAccount(BuildContext context, Account account) async {
    final phoneController = TextEditingController(text: account.phoneNumber);
    final passwordController = TextEditingController(text: account.password);
    final accountProvider = Provider.of<AccountProvider>(context, listen: false);

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('编辑帐号'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: phoneController,
                decoration: InputDecoration(labelText: '手机号'),
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: '登录密码'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('取消'),
            ),
            TextButton(
              onPressed: () {
                final updatedAccount = Account(
                  id: account.id,
                  phoneNumber: phoneController.text,
                  password: passwordController.text,
                  isLoggedIn: account.isLoggedIn,
                );
                accountProvider.updateAccount(updatedAccount);
                Navigator.of(context).pop();
              },
              child: Text('保存'),
            ),
          ],
        );
      },
    );
  }
}

class _AccountItem extends StatelessWidget {
  final Account account;
  final VoidCallback onToggle;
  final VoidCallback onLongPress;

  const _AccountItem({Key? key, required this.account, required this.onToggle, required this.onLongPress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isLoggedToday = account.lastLoggedIn != null && DateTime.now().difference(account.lastLoggedIn!).inDays == 0;

    return ListTile(
      leading: Icon(
        isLoggedToday ? Icons.check_circle_outline : Icons.radio_button_unchecked,
        color: isLoggedToday ? Colors.green : null,
      ),
      title: Text('手机号: ${account.phoneNumber}'),
      subtitle: Text('登录状态: ${isLoggedToday ? '已登录' : '未登录'}'),
      trailing: isLoggedToday ? Text('登录成功: ${_formatDate(account.lastLoggedIn!)}') : null,
      onLongPress: onLongPress,
    );
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
  }
}