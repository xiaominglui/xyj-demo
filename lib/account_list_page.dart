import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xyj_helper/l10n/l10n.dart';
import 'package:xyj_helper/utils.dart';

import 'account.dart';
import 'account_form_screen.dart';
import 'account_provider.dart';

class AccountListPage extends StatefulWidget {
  const AccountListPage({super.key});

  @override
  State<StatefulWidget> createState() => _AccountListPageState();

}

class _AccountListPageState extends State<AccountListPage> {
  bool _isGrid = false;

  @override
  Widget build(BuildContext context) {
    // final accountProvider = Provider.of<AccountProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).accountManager),
        actions: [
          IconButton(
            icon: const Icon(Icons.mobile_friendly),
            onPressed: () {
              Provider.of<AccountProvider>(context, listen: false).toggleShowAlias();
            },
          ),
          IconButton(
            icon: Icon(_isGrid ? Icons.view_list : Icons.view_module),
            onPressed: () {
              setState(() {
                _isGrid = !_isGrid;
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Consumer<AccountProvider>(
          builder: (context, accountProvider, child) {
            final accounts = accountProvider.accounts;
            return _isGrid
                ? GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 3 / 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) => _buildAccountGridItem(accounts[index]),
              itemCount: accounts.length,
              padding: const EdgeInsets.all(10),
            )
                : ListView.builder(
              itemBuilder: (context, index) => _buildAccountListItem(accounts[index]),
              itemCount: accounts.length,
              padding: const EdgeInsets.all(10),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AccountFormScreen()),
          );
        },
        tooltip: AppLocalizations.of(context).addAnAccount,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildAccountGridItem(Account account) {
    return Consumer<AccountProvider>(
      builder: (context, accountProvider, child) {
        return Card(
          child: Column(
            children: [
              const SizedBox(height: 6,),
              CircleAvatar(
                child: isLoggedToday(account) ? const Icon(Icons.check_box) : const Icon(Icons.check_box_outline_blank),
              ),
              Text(_retrieveDisplayName(accountProvider, account)),
              Text(account.remark ?? ""),
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () => _showAccountOptions(account),
              ),
            ],
          ),
        );
      },
    );
  }

  String _retrieveDisplayName(AccountProvider accountProvider, Account account) =>account.alias.isNotEmpty ? accountProvider.showAlias ? account.alias : account.phoneNumber : account.phoneNumber;

  Widget _buildAccountListItem(Account account) {
    return Consumer<AccountProvider>(
      builder: (context, accountProvider, child) {
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              child: isLoggedToday(account) ? const Icon(Icons.check_box) : const Icon(Icons.check_box_outline_blank),
            ),
            title: Text(_retrieveDisplayName(accountProvider, account)),
            subtitle: Text(account.remark ?? ""),
            trailing: IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () => _showAccountOptions(account),
            ),
          ),
        );
      },
    );
  }

  void _showAccountOptions(Account account) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: Text(AppLocalizations.of(context).edit),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AccountFormScreen(account: account),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: Text(AppLocalizations.of(context).delete),
              onTap: () {
                Navigator.of(context).pop();
                Provider.of<AccountProvider>(context, listen: false).deleteAccount(account.id!);
              },
            ),
          ],
        );
      },
    );
  }
}