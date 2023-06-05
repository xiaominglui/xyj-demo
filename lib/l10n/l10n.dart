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
      'signUpNow': 'Sign up now',
      'passwordReset': 'Password forgot?',
      'login': 'Login',
      'loginOrSignup': 'Log In / Sign Up',
      'enterPassword': 'Enter password',
      'hintForAccount': 'Enter Email or Phone number',
      'hintForUserName': 'Enter Username',
      'hintForPhoneNumber': 'Enter Phone number',
      'titlePasswordReset': 'Reset password',
      'titleSignUp': 'Sign up',
      'hintForVerificationCode': 'Enter verification code',
      'getVerificationCode': 'Get verification code',
      'setPassword': 'Set password',
      'confirmPassword': 'Confirm password',
      'submit': 'Submit',
      'loginSuccess': 'Login success',
      'passwordResetSuccess': 'Password reset success',
      'twoPasswordsDoNotMatch': 'The two passwords entered do not match',
      'joinVIP': 'Join VIP',
      'renewalDate': 'Renewal Date: ',
      'titleNotLoggedIn': 'Not logged in',
      'titlePrivacySettings': 'Privacy Settings',
      'titleHelpAndFeedback': 'Help and Feedback',
      'titleContactUs': 'Contact Us',
      'titleShare': 'Share',
      'titleBackupAndRestore': 'Backup and Restore',
      'adFree': 'Ad-free',
      'autoCheckin': 'Auto-checkin',
      'autoLogin': 'Auto-login',
      'vipCustomerService': 'VIP Customer Service',
      'priorityAccess': 'Priority access to new features',
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
      'signUpNow': '立即注册',
      'passwordReset': '忘记密码?',
      'login': '登录',
      'loginOrSignup': '登录/注册',
      'enterPassword': '请输入密码',
      'hintForAccount': '请输入邮箱或手机号',
      'hintForUsername': '请输入用户名',
      'hintForPhoneNumber': '请输入手机号',
      'titlePasswordReset': '忘记密码',
      'titleSignUp': '注册帐号',
      'hintForVerificationCode': '请输入验证码',
      'getVerificationCode': '获取验证码',
      'setPassword': '请设置密码',
      'confirmPassword': '请再次确认密码',
      'submit': '提交',
      'loginSuccess': '登录成功...',
      'passwordResetSuccess': '密码重置成功...',
      'twoPasswordsDoNotMatch': '两次输入的密码不一致',
      'joinVIP': '开通VIP会员',
      'renewalDate': '会员有效期： ',
      'titleNotLoggedIn': '未登录',
      'titlePrivacySettings': '隐私设置',
      'titleHelpAndFeedback': '帮助与反馈',
      'titleContactUs': '联系我们',
      'titleShare': '分享给朋友',
      'titleBackupAndRestore': '备份与恢复',
      'adFree': '免除广告',
      'autoCheckin': '签到助手',
      'autoLogin': '登录助手',
      'vipCustomerService': 'VIP客服',
      'priorityAccess': '抢先体验',
    },
  };

  static List<String> languages() => _localizedValues.keys.toList();

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
    return _localizedValues[locale.languageCode]![
        'noAccountsNeedToLogInToday']!;
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

  String get signUpNow {
    return _localizedValues[locale.languageCode]!['signUpNow']!;
  }

  String get passwordReset {
    return _localizedValues[locale.languageCode]!['passwordReset']!;
  }

  String get login {
    return _localizedValues[locale.languageCode]!['login']!;
  }

  String get loginOrSignup {
    return _localizedValues[locale.languageCode]!['loginOrSignup']!;
  }

  String get enterPassword {
    return _localizedValues[locale.languageCode]!['enterPassword']!;
  }

  String get hintForAccount {
    return _localizedValues[locale.languageCode]!['hintForAccount']!;
  }

  String get hintForUsername {
    return _localizedValues[locale.languageCode]!['hintForUsername']!;
  }

  String get hintForPhoneNumber {
    return _localizedValues[locale.languageCode]!['hintForPhoneNumber']!;
  }

  String get titlePasswordReset {
    return _localizedValues[locale.languageCode]!['titlePasswordReset']!;
  }

  String get titleSignUp {
    return _localizedValues[locale.languageCode]!['titleSignUp']!;
  }

  String get hintForVerificationCode {
    return _localizedValues[locale.languageCode]!['hintForVerificationCode']!;
  }

  String get getVerificationCode {
    return _localizedValues[locale.languageCode]!['getVerificationCode']!;
  }

  String get setPassword {
    return _localizedValues[locale.languageCode]!['setPassword']!;
  }

  String get confirmPassword {
    return _localizedValues[locale.languageCode]!['confirmPassword']!;
  }

  String get submit {
    return _localizedValues[locale.languageCode]!['submit']!;
  }

  String get loginSuccess {
    return _localizedValues[locale.languageCode]!['loginSuccess']!;
  }

  String get passwordResetSuccess {
    return _localizedValues[locale.languageCode]!['passwordResetSuccess']!;
  }

  String get twoPasswordsDoNotMatch {
    return _localizedValues[locale.languageCode]!['twoPasswordsDoNotMatch']!;
  }

  String get joinVIP {
    return _localizedValues[locale.languageCode]!['joinVIP']!;
  }

  String get renewalDate {
    return _localizedValues[locale.languageCode]!['renewalDate']!;
  }

  String get titleNotLoggedIn {
    return _localizedValues[locale.languageCode]!['titleNotLoggedIn']!;
  }

  String get titlePrivacySettings {
    return _localizedValues[locale.languageCode]!['titlePrivacySettings']!;
  }

  String get titleHelpAndFeedback {
    return _localizedValues[locale.languageCode]!['titleHelpAndFeedback']!;
  }

  String get titleContactUs {
    return _localizedValues[locale.languageCode]!['titleContactUs']!;
  }

  String get titleShare {
    return _localizedValues[locale.languageCode]!['titleShare']!;
  }

  String get titleBackupAndRestore {
    return _localizedValues[locale.languageCode]!['titleBackupAndRestore']!;
  }

  String get adFree {
    return _localizedValues[locale.languageCode]!['adFree']!;
  }

  String get autoCheckin {
    return _localizedValues[locale.languageCode]!['autoCheckin']!;
  }

  String get autoLogin {
    return _localizedValues[locale.languageCode]!['autoLogin']!;
  }

  String get vipCustomerService {
    return _localizedValues[locale.languageCode]!['vipCustomerService']!;
  }

  String get priorityAccess {
    return _localizedValues[locale.languageCode]!['priorityAccess']!;
  }
}
