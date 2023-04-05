class Account {
  final int? id;
  final String phoneNumber;
  final String password;
  final bool isLoggedIn;
  final DateTime? lastLoggedIn;

  Account({this.id, required this.phoneNumber, required this.password, this.isLoggedIn = false, this.lastLoggedIn});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'phoneNumber': phoneNumber,
      'password': password,
      'isLoggedIn': isLoggedIn ? 1 : 0,
      'lastLoggedIn': lastLoggedIn?.toIso8601String(),
    };
  }

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      id: map['id'],
      phoneNumber: map['phoneNumber'],
      password: map['password'],
      isLoggedIn: map['isLoggedIn'] == 1,
      lastLoggedIn: map['lastLoggedIn'] != null ? DateTime.parse(map['lastLoggedIn']) : null,
    );
  }
}
