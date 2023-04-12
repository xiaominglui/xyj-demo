class Account {
  final int? id;
  final String alias;
  final String remark;
  final String phoneNumber;
  final String password;
  final bool isLoggedIn;
  final DateTime? lastLoggedIn;

  Account({this.id, this.alias = '', this.remark = '', required this.phoneNumber, required this.password, this.isLoggedIn = false, this.lastLoggedIn});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'alias': alias,
      'remark': remark,
      'phoneNumber': phoneNumber,
      'password': password,
      'isLoggedIn': isLoggedIn ? 1 : 0,
      'lastLoggedIn': lastLoggedIn?.toIso8601String(),
    };
  }

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      id: map['id'],
      alias: map['alias'],
      remark: map['remark'],
      phoneNumber: map['phoneNumber'],
      password: map['password'],
      isLoggedIn: map['isLoggedIn'] == 1,
      lastLoggedIn: map['lastLoggedIn'] != null ? DateTime.parse(map['lastLoggedIn']) : null,
    );
  }
}
