import 'package:flutter/material.dart';
import 'account.dart';
import 'database.dart';

class AccountProvider with ChangeNotifier {
  List<Account> _accounts = [];

  List<Account> get accounts => _accounts;

  AccountProvider() {
    print("AccountProvider instance");
    _loadAccounts();
  }

  Future<void> _loadAccounts() async {
    final db = await AppDatabase.instance.database;
    final maps = await db.query('accounts');

    _accounts = maps.map((map) => Account.fromMap(map)).toList();
    notifyListeners();
  }

  Future<void> addAccount(Account account) async {
    final db = await AppDatabase.instance.database;
    await db.insert('accounts', account.toMap());
    await _loadAccounts();
  }

  Future<void> updateAccount(Account account) async {
    final db = await AppDatabase.instance.database;
    await db.update('accounts', account.toMap(), where: 'id = ?', whereArgs: [account.id]);
    await _loadAccounts();
  }

  Future<void> deleteAccount(int id) async {
    final db = await AppDatabase.instance.database;
    await db.delete('accounts', where: 'id = ?', whereArgs: [id]);
    await _loadAccounts();
  }

  Future<void> toggleLoginStatus(int index) async {
    final account = _accounts[index];
    final updatedAccount = Account(
      id: account.id,
      phoneNumber: account.phoneNumber,
      password: account.password,
      isLoggedIn: !account.isLoggedIn,
    );
    await updateAccount(updatedAccount);
  }
}
