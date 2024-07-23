import 'account.dart';

bool isLoggedToday(Account account) {
  if (account.lastLoggedIn == null) {
    return false;
  }

  DateTime now = DateTime.now();
  DateTime todayStart = DateTime(now.year, now.month, now.day);
  DateTime loginStart = DateTime(account.lastLoggedIn!.year, account.lastLoggedIn!.month, account.lastLoggedIn!.day);

  return todayStart == loginStart;
}

String obscurePhoneNumber(String str) {
  var start = str.length ~/ 2 - 2;
  var end = start + 4;
  return '${str.substring(0, start)}****${str.substring(end)}';
}


// 检查会员资格是否到期，输入参数为时间戳，单位毫秒，可为空，返回布尔值。
bool isVipExpired(int? timestamp) {
  if (timestamp == null) {
    return true;
  }
  if (timestamp < DateTime.now().millisecondsSinceEpoch) {
    return true;
  }
  return false;
}

int? getNextRenewalTime(List<dynamic>? customData) {
  if (customData == null) {
    return null;
  }
  for (var element in customData) {
    if (element['key'] == 'next_renewal') {
      return element['value'];
    }
  }
  return null;
}

String? getNextRenewalTimeString(List<dynamic>? customData) {
  if (customData == null) {
    return null;
  }
  for (var element in customData) {
    if (element['key'] == 'next_renewal') {
      return DateTime.fromMillisecondsSinceEpoch(element['value']).toLocal().toString();
    }
  }
  return null;
}

String? getMemberType(List<dynamic>? customData) {
  if (customData == null) {
    return null;
  }
  for (var element in customData) {
    if (element['key'] == 'member_type') {
      return element['value'];
    }
  }
  return null;
}

String? getRenewalType(List<dynamic>? customData) {
  if (customData == null) {
    return null;
  }
  for (var element in customData) {
    if (element['key'] == 'renewal_type') {
      return element['value'];
    }
  }
  return null;
}

