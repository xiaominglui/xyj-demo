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
      'appName': 'XYJ Helper',
      'overall': 'Overall',
      'autoTask': 'Auto Task',
      'welcome': 'Welcome',
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
      'chooseTheExecutionScope': 'Choose the execution scope',
      'chooseTaskType': 'Choose task type',
      'accountsNotLoggedIn': 'Accounts not logged in',
      'allAccounts': 'All accounts',
      'startToExecute': 'Start',
      'noAccountsNeedToLogInToday': 'No accounts need to log in today',
      'checkInTask': 'Check in',
      'logInTask': 'Login',
      'chooseAnAccount': 'Choose an account',
      'tooManyAccountsToLogIn': 'Too many accounts to log in',
      'inProcessing': 'In processing',
      'stopTask': 'Stop',
    },
    'zh': {
      'hello': '你好世界',
      'appName': '信友助手',
      'overall': '总览',
      'autoTask': '任务',
      'welcome': '欢迎',
      'addAccount': '添加帐号',
      'accountManager': '帐号',
      'mobile': '手机号',
      'password': '密码',
      'alias': '别名',
      'remark': '备注',
      'add': '添加',
      'update': '更新',
      'settings': '设置',
      'share': '分享',
      'about': '关于',
      'composeAutoTask': '创建自动任务',
      'delete': '删除',
      'edit': '编辑',
      'addAnAccount': '添加一个帐号',
      'passwordEmptyHint': '密码不能为空',
      'mobileEmptyHint': '手机号不能为空',
      'editAccount': '编辑帐号',
      'chooseTheExecutionScope': '选择登录帐号范围',
      'chooseTaskType': '选择任务类型',
      'accountsNotLoggedIn': '未登录',
      'allAccounts': '全部',
      'startToExecute': '开始',
      'noAccountsNeedToLogInToday': '👏🏻所有帐号今日已登录',
      'checkInTask': '签到',
      'logInTask': '登录',
      'chooseAnAccount': '选择一个帐号',
      'tooManyAccountsToLogIn': '目前不能同时登录多个帐号',
      'inProcessing': '正在处理',
      'stopTask': '停止',
    },
  };

  static List<String> languages ()=> _localizedValues.keys.toList();

  String get hello {
    return _localizedValues[locale.languageCode]!['hello']!;
  }

  String get appName {
    return _localizedValues[locale.languageCode]!['appName']!;
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

  String get chooseTaskType {
    return _localizedValues[locale.languageCode]!['chooseTaskType']!;
  }

  String get chooseTheExecutionScope {
    return _localizedValues[locale.languageCode]!['chooseTheExecutionScope']!;
  }

  String get accountsNotLoggedIn {
    return _localizedValues[locale.languageCode]!['accountsNotLoggedIn']!;
  }

  String get allAccounts {
    return _localizedValues[locale.languageCode]!['allAccounts']!;
  }

  String get startToExecute {
    return _localizedValues[locale.languageCode]!['startToExecute']!;
  }

  String get noAccountsNeedToLogInToday {
    return _localizedValues[locale.languageCode]!['noAccountsNeedToLogInToday']!;
  }

  String get checkInTask {
    return _localizedValues[locale.languageCode]!['checkInTask']!;
  }

  String get logInTask {
    return _localizedValues[locale.languageCode]!['logInTask']!;
  }

  String get chooseAnAccount {
    return _localizedValues[locale.languageCode]!['chooseAnAccount']!;
  }

  String get tooManyAccountsToLogIn {
    return _localizedValues[locale.languageCode]!['tooManyAccountsToLogIn']!;
  }

  String get inProcessing {
    return _localizedValues[locale.languageCode]!['inProcessing']!;
  }

  String get stopTask {
    return _localizedValues[locale.languageCode]!['stopTask']!;
  }
}
