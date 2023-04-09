import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'account.dart';
import 'account_provider.dart';


class AccountFormScreen extends StatefulWidget {
  final Account? account;

  AccountFormScreen({this.account});

  @override
  _AccountFormScreenState createState() => _AccountFormScreenState();
}

class _AccountFormScreenState extends State<AccountFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _phoneNumberController;
  late TextEditingController _passwordController;
  late TextEditingController _aliasController;

  @override
  void initState() {
    super.initState();
    _phoneNumberController = TextEditingController(text: widget.account?.phoneNumber ?? '');
    _passwordController = TextEditingController(text: widget.account?.password ?? '');
    _aliasController = TextEditingController(text: widget.account?.alias ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.account == null ? '添加帐号' : '编辑帐号'),
        ),
        body: Padding(
        padding: const EdgeInsets.all(16.0),
    child: Form(
    key: _formKey,
    child: Column(
    children: [
    TextFormField(
    controller: _phoneNumberController,
    decoration: InputDecoration(labelText: '手机号'),
    keyboardType: TextInputType.phone,
    validator: (value) {
    if (value == null || value.isEmpty) {
    return '手机号不能为空';
    }
    return null;
    },
    ),
    TextFormField(
    controller: _passwordController,
    decoration: InputDecoration(labelText: '登录密码'),
    obscureText: true,
    validator: (value) {
    if (value == null || value.isEmpty) {
    return '登录密码不能为空';
    }
    return null;
    },
    ),
    TextFormField(
    controller: _aliasController,
    decoration: InputDecoration(labelText: '别名'),
    ),
    SizedBox(height: 16),
    ElevatedButton(
      onPressed: _saveAccount,
      child: Text(widget.account == null ? '添加' : '更新'),
    ),
    ],
    ),
    ),
        ),
    );
  }

  void _saveAccount() {
    if (_formKey.currentState!.validate()) {
      final accountProvider = Provider.of<AccountProvider>(context, listen: false);
      if (widget.account == null) {
        final newAccount = Account(
          phoneNumber: _phoneNumberController.text,
          password: _passwordController.text,
          alias: _aliasController.text,
        );
        accountProvider.addAccount(newAccount);
      } else {
        final updatedAccount = Account(
          id: widget.account!.id,
          phoneNumber: _phoneNumberController.text,
          password: _passwordController.text,
          alias: _aliasController.text,
        );
        accountProvider.updateAccount(updatedAccount);
      }

      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    _passwordController.dispose();
    _aliasController.dispose();
    super.dispose();
  }
}