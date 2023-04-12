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
      'addAccount': 'Add Account',
      'accountManager': 'Account Manager',
      'mobile': 'Mobile',
      'password': 'Password',
      'alias': 'Alias',
      'remark': 'Remark',
      'add': 'Add',
      'update': 'Update',
      'settings': 'Settings',
      'share': 'Share',
      'about': 'About',
      'composeAutoTask': 'Compose Auto Task',
      'delete': 'Delete',
      'edit': 'Edit',
      'addAnAccount': 'Add an Account',
      'passwordEmptyHint': 'Password cannot be empty',
      'mobileEmptyHint': 'Mobile number cannot be empty',
      'editAccount': 'Edit Account',
    },
    'zh': {
      'hello': '你好世界',
      'overall': '总览',
      'autoTask': '自动任务',
      'welcome': '欢迎',
      'signIn': '登录',
      'addAccount': '添加账户',
      'accountManager': '账户管理',
      'mobile': '手机号',
      'password': '密码',
      'alias': '别名',
      'remark': '备注',
      'add': '添加',
      'update': '更新',
      'settings': '设置',
      'share': '分享',
      'about': '关于',
      'composeAutoTask': '编写自动任务',
      'delete': '删除',
      'edit': '编辑',
      'addAnAccount': '添加一个账户',
      'passwordEmptyHint': '密码不能为空',
      'mobileEmptyHint': '手机号不能为空',
      'editAccount': '编辑账户',
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

  String get addAccount {
    return _localizedValues[locale.languageCode]!['addAccount']!;
  }

  String get accountManager {
    return _localizedValues[locale.languageCode]!['accountManager']!;
  }

  String get mobile {
    return _localizedValues[locale.languageCode]!['mobile']!;
  }

  String get password {
    return _localizedValues[locale.languageCode]!['password']!;
  }

  String get alias {
    return _localizedValues[locale.languageCode]!['alias']!;
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

  String get settings {
    return _localizedValues[locale.languageCode]!['settings']!;
  }

  String get share {
    return _localizedValues[locale.languageCode]!['share']!;
  }

  String get about {
    return _localizedValues[locale.languageCode]!['about']!;
  }

  String get composeAutoTask {
    return _localizedValues[locale.languageCode]!['composeAutoTask']!;
  }

  String get delete {
    return _localizedValues[locale.languageCode]!['delete']!;
  }

  String get edit {
    return _localizedValues[locale.languageCode]!['edit']!;
  }

  String get addAnAccount {
    return _localizedValues[locale.languageCode]!['addAnAccount']!;
  }

  String get passwordEmptyHint {
    return _localizedValues[locale.languageCode]!['passwordEmptyHint']!;
  }

  String get mobileEmptyHint {
    return _localizedValues[locale.languageCode]!['mobileEmptyHint']!;
  }

  String get editAccount {
    return _localizedValues[locale.languageCode]!['editAccount']!;
  }
}
