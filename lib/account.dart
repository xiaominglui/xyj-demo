class Account {
  final String phoneNumber;
  final String password;
  bool isLoggedIn;

  Account({required this.phoneNumber, required this.password, this.isLoggedIn = false});
}
