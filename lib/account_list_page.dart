import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xyj_helper/l10n/l10n.dart';
import 'package:xyj_helper/task_config.dart';
import 'package:xyj_helper/utils.dart';

import 'account.dart';
import 'account_form_screen.dart';
import 'account_provider.dart';

class AccountListPage extends StatefulWidget {
  final Function(Account, ExecuteType) onOneAccountTaskRequest;

  const AccountListPage({super.key, required this.onOneAccountTaskRequest});

  @override
  State<StatefulWidget> createState() => _AccountListPageState();
}

class _AccountListPageState extends State<AccountListPage> {
  bool _isGrid = false;

  @override
  Widget build(BuildContext context) {
    final accountProvider = Provider.of<AccountProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "${AppLocalizations.of(context).accountManager} (${accountProvider.accounts.length})"),
        actions: [
          IconButton(
            icon: const Icon(Icons.notes_rounded),
            onPressed: () {
              Provider.of<AccountProvider>(context, listen: false)
                  .toggleShowAlias();
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
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.4,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) =>
                        _buildAccountGridItem(accounts[index]),
                    itemCount: accounts.length,
                    padding: const EdgeInsets.all(10),
                  )
                : ListView.builder(
                    itemBuilder: (context, index) =>
                        _buildAccountListItem(accounts[index]),
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

  String _retrieveDisplayName(
          AccountProvider accountProvider, Account account) =>
      account.alias.isNotEmpty
          ? accountProvider.showAlias
              ? account.alias
              : account.phoneNumber
          : account.phoneNumber;

  Widget _buildAccountGridItem(Account account) {
    return Consumer<AccountProvider>(
      builder: (context, accountProvider, child) {
        return GestureDetector(
          onLongPress: () {
            _showAccountOptions(account);
          },
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(account.id.toString()),
                      const SizedBox(
                        width: 16.0,
                      ),
                      Text(_retrieveDisplayName(accountProvider, account)),
                    ],
                  ),
                  Row(
                    children: [
                      isLoggedToday(account)
                          ? const Icon(
                              Icons.check_box,
                              size: 16,
                            )
                          : const Icon(
                              Icons.check_box_outline_blank,
                              size: 16,
                            ),
                      const SizedBox(
                        width: 8.0,
                      ),
                      Text(account.remark),
                    ],
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: () {
                            print("onLoginIconButtonPressed");
                            widget.onOneAccountTaskRequest(
                                account, ExecuteType.login);
                          },
                          icon: const Icon(Icons.login)),
                      const SizedBox(width: 8.0),
                      IconButton(
                        onPressed: () {
                          widget.onOneAccountTaskRequest(
                              account, ExecuteType.checkIn);
                        },
                        icon: const Icon(Icons.check),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAccountListItem(Account account) {
    return Consumer<AccountProvider>(
      builder: (context, accountProvider, child) {
        return Card(
          child: ListTile(
            onLongPress: () {
              _showAccountOptions(account);
            },
            leading: Text(account.id.toString()),
            title: Text(_retrieveDisplayName(accountProvider, account)),
            subtitle: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                isLoggedToday(account)
                    ? const Icon(
                        Icons.check_box,
                        size: 16,
                      )
                    : const Icon(
                        Icons.check_box_outline_blank,
                        size: 16,
                      ),
                const SizedBox(
                  width: 8.0,
                ),
                Text(account.remark),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ElevatedButton(onPressed: (){}, child: const Text("Edit")),
                IconButton(
                    onPressed: () {
                      print("onLoginIconButtonPressed");
                      widget.onOneAccountTaskRequest(
                          account, ExecuteType.login);
                    },
                    icon: const Icon(Icons.login)),
                const SizedBox(
                  width: 8.0,
                ),
                IconButton(
                  onPressed: () {
                    widget.onOneAccountTaskRequest(
                        account, ExecuteType.checkIn);
                  },
                  icon: const Icon(Icons.check),
                )
              ],
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
                Provider.of<AccountProvider>(context, listen: false)
                    .deleteAccount(account.id!);
              },
            ),
          ],
        );
      },
    );
  }
}
