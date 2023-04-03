import 'package:flutter/material.dart';
import 'account.dart';

class AccountProvider with ChangeNotifier {
  List<Account> _accounts = [];

  List<Account> get accounts => _accounts;

  void addAccount(Account account) {
    _accounts.add(account);
    notifyListeners();
  }

  void updateLoginStatus(int index, bool isLoggedIn) {
    _accounts[index].isLoggedIn = isLoggedIn;
    notifyListeners();
  }
}
