import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xyj_helper/account_provider.dart';
import 'package:xyj_helper/l10n/l10n.dart';

class AccountSelectorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).chooseAnAccount),
      ),
      body: Consumer<AccountProvider>(
        builder: (context, accountProvider, child) {
          final accounts = accountProvider.accounts;

          return ListView.builder(
            itemCount: accounts.length,
            itemBuilder: (context, index) {
              final account = accounts[index];
              return ListTile(
                title: Text(account.phoneNumber),
                subtitle: Text(account.alias),
                onTap: () {
                  Navigator.pop(context, account);
                },
              );
            },
          );
        },
      ),
    );
  }
}
