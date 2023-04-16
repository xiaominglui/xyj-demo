import 'account.dart';

bool isLoggedToday(Account account) {
  return account.lastLoggedIn != null && DateTime.now().difference(account.lastLoggedIn!).inDays == 0;
}