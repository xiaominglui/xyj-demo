import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xyj_helper/l10n/l10n.dart';

import 'account.dart';
import 'account_provider.dart';

class AccountFormScreen extends StatefulWidget {
  final Account? account;

  const AccountFormScreen({super.key, this.account});

  @override
  _AccountFormScreenState createState() => _AccountFormScreenState();
}

class _AccountFormScreenState extends State<AccountFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _phoneNumberController;
  late TextEditingController _passwordController;
  late TextEditingController _aliasController;
  late TextEditingController _remarkController;

  @override
  void initState() {
    super.initState();
    _phoneNumberController =
        TextEditingController(text: widget.account?.phoneNumber ?? '');
    _passwordController =
        TextEditingController(text: widget.account?.password ?? '');
    _aliasController = TextEditingController(text: widget.account?.alias ?? '');
    _remarkController = TextEditingController(text: widget.account?.remark ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.account == null ? AppLocalizations.of(context).addAccount : AppLocalizations.of(context).editAccount),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _phoneNumberController,
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).mobile),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context).mobileEmptyHint;
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: AppLocalizations.of(context).password),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context).passwordEmptyHint;
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _aliasController,
                decoration: InputDecoration(labelText: AppLocalizations.of(context).alias),
              ),
              TextFormField(
                controller: _remarkController,
                decoration: InputDecoration(labelText: AppLocalizations.of(context).remark),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: (){
                  _saveAccount(widget.account);
                },
                child: Text(widget.account == null ? AppLocalizations.of(context).add : AppLocalizations.of(context).update),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveAccount(Account? account) {
    if (_formKey.currentState!.validate()) {
      final accountProvider =
          Provider.of<AccountProvider>(context, listen: false);
      if (widget.account == null) {
        final newAccount = Account(
          phoneNumber: _phoneNumberController.text,
          password: _passwordController.text,
          alias: _aliasController.text,
          remark: _remarkController.text,
        );
        accountProvider.addAccount(newAccount);
      } else {
        final updatedAccount = Account(
          id: widget.account!.id,
          phoneNumber: _phoneNumberController.text,
          password: _passwordController.text,
          alias: _aliasController.text,
          remark: _remarkController.text,
          isLoggedIn: account!.isLoggedIn,
          lastLoggedIn: account.lastLoggedIn,
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
