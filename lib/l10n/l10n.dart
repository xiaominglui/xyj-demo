import 'package:flutter/material.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const _localizedValues = <String, Map<String, String>>{
    'en': {
      'hello': 'Hello World',
      'overall': 'Overall',
      'autoTask': 'Auto Task',
      'welcome': 'Welcome',
      'signIn': 'Sign In',
      'accountManager': 'Account Manager',
      'my': 'My',
      'about': 'About',
      'share': 'Share',
      'settings': 'Settings',
      'addAccount': 'Add Account',
      'mobile': 'Mobile',
      'password': 'Password',
      'alisa': 'Alisa',
      'remark': 'Remark',
      'add': 'Add',
      'update': 'Update',
    },
    'zh': {
      'hello': '你好世界',
      'overall': '总览',
      'autoTask': '自动任务',
      'welcome': '欢迎',
      'signIn': '登录',
      'accountManager': '账户管理',
      'my': '我的',
      'about': '关于',
      'share': '分享',
      'settings': '设置',
      'addAccount': '添加账户',
      'mobile': '手机号',
      'password': '密码',
      'alisa': '别名',
      'remark': '备注',
      'add': '添加',
      'update': '更新',
    },
  };

  static List<String> languages ()=> _localizedValues.keys.toList();

  String get hello {
    return _localizedValues[locale.languageCode]!['hello']!;
  }

  String get overall {
    return _localizedValues[locale.languageCode]!['overall']!;
  }

  String get autoTask {
    return _localizedValues[locale.languageCode]!['autoTask']!;
  }

  String get welcome {
    return _localizedValues[locale.languageCode]!['welcome']!;
  }

  String get signIn {
    return _localizedValues[locale.languageCode]!['signIn']!;
  }

  String get accountManager {
    return _localizedValues[locale.languageCode]!['accountManager']!;
  }

  String get my {
    return _localizedValues[locale.languageCode]!['my']!;
  }

  String get about {
    return _localizedValues[locale.languageCode]!['about']!;
  }

  String get share {
    return _localizedValues[locale.languageCode]!['share']!;
  }

  String get settings {
    return _localizedValues[locale.languageCode]!['settings']!;
  }

  String get addAccount {
    return _localizedValues[locale.languageCode]!['addAccount']!;
  }

  String get mobile {
    return _localizedValues[locale.languageCode]!['mobile']!;
  }

  String get password {
    return _localizedValues[locale.languageCode]!['password']!;
  }

  String get alisa {
    return _localizedValues[locale.languageCode]!['alisa']!;
  }

  String get remark {
    return _localizedValues[locale.languageCode]!['remark']!;
  }

  String get add {
    return _localizedValues[locale.languageCode]!['add']!;
  }

  String get update {
    return _localizedValues[locale.languageCode]!['update']!;
  }
}
