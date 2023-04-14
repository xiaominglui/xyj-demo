import 'account.dart';

class TaskConfig {
  final ExecuteScope scope;
  final List<Account>? accounts;

  TaskConfig({this.scope = ExecuteScope.notLoggedInOnly, this.accounts});
}

enum ExecuteScope {all, notLoggedInOnly}
enum ExecuteType {auto, manual}