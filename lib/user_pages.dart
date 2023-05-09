import 'dart:async';

import 'package:authing_sdk_v3/authing.dart';
import 'package:authing_sdk_v3/client.dart';
import 'package:authing_sdk_v3/result.dart';
import 'package:authing_sdk_v3/user.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:xyj_helper/l10n/l10n.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true;
  bool _isAgreementChecked = false;
  bool _isLoginInfoValid = false;

  late TextEditingController _accountController;
  late TextEditingController _passwordController;

  String _selectedCountryCode = 'CN +86';
  final List<String> _supportedCountryCodes = [
    'CN +86',
    'HK +852',
    'MO +853',
    'TW +886',
    'JP +81',
    'KR +82',
    'IN +91',
    'UK +44',
    'US +1',
    'DE +49',
    'IT +39',
    'FR +33',
    'AU +61',
    'NZ +64'
  ];

  initState() {
    super.initState();
    _accountController = TextEditingController();
    _accountController.addListener(_onTextFieldChanged);
    _passwordController = TextEditingController();
    _passwordController.addListener(_onTextFieldChanged);
  }

  dispose() {
    _accountController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onTextFieldChanged() {
    setState(() {
      _isLoginInfoValid = _accountController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty;
    });
  }

  _goToRegisterPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterPage()),
    );
  }

  _goToPasswordResetPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PasswordResetPage()),
    );
  }

  _loginByAccount() async {
    print("_loginByAccount");
    AuthResult result = await AuthClient.loginByAccount(
        _accountController.text, _passwordController.text);

    String msg = '';
    if (result.statusCode == 200) {
      print("ok");
      msg = AppLocalizations.of(context).loginSuccess;
      Navigator.pop(context);
    } else {
      print("not ok, err: ${result.apiCode} === ${result.message}");
      msg = result.message;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _toggleAgreementChecked() {
    setState(() {
      _isAgreementChecked = !_isAgreementChecked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.network('https://via.placeholder.com/300', height: 200),
                  const SizedBox(height: 16),
                  TextField(
                    keyboardType: TextInputType.text,
                    controller: _accountController,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context).hintForAccount,
                      prefixIcon: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedCountryCode,
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedCountryCode = newValue!;
                            });
                          },
                          items: _supportedCountryCodes
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    obscureText: _obscureText,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context).enterPassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: _toggleObscureText,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _isLoginInfoValid ? _loginByAccount : null,
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48)),
                    child: Text(AppLocalizations.of(context).login),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: _goToRegisterPage,
                        child: Text(AppLocalizations.of(context).signUpNow),
                      ),
                      TextButton(
                        onPressed: _goToPasswordResetPage,
                        child: Text(AppLocalizations.of(context).passwordReset),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Checkbox(
                    value: _isAgreementChecked,
                    onChanged: (bool? newValue) {
                      _toggleAgreementChecked();
                    },
                  ),
                  Expanded(
                    child: Wrap(
                      children: [
                        RichText(
                          text: TextSpan(
                            text: "I've read and agree to the ",
                            style: TextStyle(color: Colors.black54),
                            children: [
                              TextSpan(
                                text: "User Agreement",
                                style: TextStyle(color: Colors.blue),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => print('Tap Here onTap'),
                              ),
                              TextSpan(text: " and "),
                              TextSpan(
                                text: "Privacy Policy",
                                style: TextStyle(color: Colors.blue),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => print('Tap Here onTap'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PasswordResetPage extends StatefulWidget {
  const PasswordResetPage({super.key});

  @override
  _PasswordResetPageState createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends State<PasswordResetPage> {
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _verificationCodeController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();

  bool _obscureText1 = true;
  bool _obscureText2 = true;

  bool _isResetInfoValid = false;
  bool _isConfirmValid = false;

  String _selectedCountryCode = 'CN +86';
  final List<String> _supportedCountryCodes = [
    'CN +86',
    'HK +852',
    'MO +853',
    'TW +886',
    'JP +81',
    'KR +82',
    'IN +91',
    'UK +44',
    'US +1',
    'DE +49',
    'IT +39',
    'FR +33',
    'AU +61',
    'NZ +64'
  ];

  int counter = 60;
  bool counterIsRunning = false;
  String _verificationButtonText = '';

  @override
  void initState() {
    super.initState();
    _accountController.addListener(_onTextFieldChanged);
    _verificationCodeController.addListener(_onTextFieldChanged);
    _passwordController.addListener(_onTextFieldChanged);
    _passwordConfirmController.addListener(_onTextFieldChanged);
  }

  @override
  void dispose() {
    _accountController.dispose();
    _verificationCodeController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  void _onTextFieldChanged() {
    setState(() {
      _isResetInfoValid = _accountController.text.isNotEmpty &&
          _verificationCodeController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          _passwordConfirmController.text.isNotEmpty;

      if (_isResetInfoValid) {
        if (_passwordController.text != _passwordConfirmController.text) {
          _isConfirmValid = false;
        } else {
          _isConfirmValid = true;
        }
      }
    });
  }

  void _startCountdown() {
    setState(() {
      counter = 60;
      counterIsRunning = true;
      _verificationButtonText = '$counter s';
    });

    Timer.periodic(const Duration(seconds: 1), (timer) {
      print('$counter s; t: ${timer.tick}');
      if (counter == 1) {
        timer.cancel();
        counterIsRunning = false;
        setState(() {
          _verificationButtonText =
              AppLocalizations.of(context).getVerificationCode;
        });
      } else {
        setState(() {
          counter -= 1;
          _verificationButtonText = '$counter s';
        });
      }
    });
  }

  void _toggleObscureText1() {
    setState(() {
      _obscureText1 = !_obscureText1;
    });
  }

  void _toggleObscureText2() {
    setState(() {
      _obscureText2 = !_obscureText2;
    });
  }

  void _resetAccountPassword() async {
    print("_resetAccountPassword");

    if (isPhoneNumber(_accountController.text)) {
      AuthResult result = await AuthClient.resetPasswordByPhone(
          _accountController.text,
          _verificationCodeController.text,
          _passwordConfirmController.text);
      String msg = '';
      if (result.statusCode == 200) {
        print("ok");
        msg = AppLocalizations.of(context).passwordResetSuccess;
      } else {
        msg = result.message;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg)),
      );
    } else if (isEmail(_accountController.text)) {
      AuthResult result = await AuthClient.resetPasswordByEmailCode(
          _accountController.text,
          _verificationCodeController.text,
          _passwordConfirmController.text);
      String msg = '';
      if (result.statusCode == 200) {
        print("ok");
        msg = AppLocalizations.of(context).passwordResetSuccess;
      } else {
        msg = result.message;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg)),
      );
    }
  }

  bool isPhoneNumber(String input) {
    RegExp phoneRegex = RegExp(r'^1[3-9]\d{9}$');
    return phoneRegex.hasMatch(input);
  }

  bool isEmail(String input) {
    RegExp emailRegex =
        RegExp(r'^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$');
    return emailRegex.hasMatch(input);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).titlePasswordReset),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
            child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                keyboardType: TextInputType.text,
                controller: _accountController,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context).hintForAccount,
                  prefixIcon: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedCountryCode,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedCountryCode = newValue!;
                        });
                      },
                      items: _supportedCountryCodes
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _verificationCodeController,
                decoration: InputDecoration(
                  labelText:
                      AppLocalizations.of(context).hintForVerificationCode,
                  suffix: TextButton(
                    onPressed: () async {
                      // Handle sending verification code and start the countdown

                      if (isEmail(_accountController.text)) {
                        AuthResult sendEmailResult = await AuthClient.sendEmail(
                            _accountController.text, "CHANNEL_RESET_PASSWORD");
                        String msg = "";
                        if (sendEmailResult.statusCode == 200) {
                          msg = "发送成功";
                        } else {
                          msg = sendEmailResult.message;
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(msg)),
                        );
                      }
                      if (isPhoneNumber(_accountController.text)) {
                        AuthResult sendSmsResult = await AuthClient.sendSms(
                            _accountController.text, "CHANNEL_RESET_PASSWORD");

                        String msg = "";
                        if (sendSmsResult.statusCode == 200) {
                          msg = "发送成功";
                        } else {
                          msg = sendSmsResult.message;
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(msg)),
                        );
                      }
                      _startCountdown();
                    },
                    child: Text(counterIsRunning
                        ? _verificationButtonText
                        : AppLocalizations.of(context).getVerificationCode),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: _obscureText1,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context).setPassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText1 ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: _toggleObscureText1,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordConfirmController,
                obscureText: _obscureText2,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context).confirmPassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText2 ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: _toggleObscureText2,
                  ),
                ),
              ),
              if (!_isConfirmValid && _isResetInfoValid)
                Text(
                  "password not same",
                  style: TextStyle(color: Colors.red),
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isResetInfoValid && _isConfirmValid ? _resetAccountPassword : null,
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 48)),
                child: Text(AppLocalizations.of(context).submit),
              ),
            ],
          ),
        )),
      ),
    );
  }
}

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _verificationCodeController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordConfirmController = TextEditingController();

  bool _obscureText1 = true;
  bool _obscureText2 = true;

  String _selectedCountryCode = 'CN +86';
  List<String> _supportedCountryCodes = [
    'CN +86',
    'HK +852',
    'MO +853',
    'TW +886',
    'JP +81',
    'KR +82',
    'IN +91',
    'UK +44',
    'US +1',
    'DE +49',
    'IT +39',
    'FR +33',
    'AU +61',
    'NZ +64'
  ];

  int counter = 60;
  bool counterIsRunning = false;
  String _verificationButtonText = 'Get verification code';

  void _startCountdown() {
    setState(() {
      counter = 60;
      counterIsRunning = true;
      _verificationButtonText = '$counter s';
    });

    Timer.periodic(const Duration(seconds: 1), (timer) {
      print('$counter s; t: ${timer.tick}');
      if (counter == 1) {
        timer.cancel();
        setState(() {
          counterIsRunning = false;
          _verificationButtonText = 'Get verification code';
        });
      } else {
        setState(() {
          counter -= 1;
          _verificationButtonText = '$counter s';
        });
      }
    });
  }

  void _toggleObscureText1() {
    setState(() {
      _obscureText1 = !_obscureText1;
    });
  }

  void _toggleObscureText2() {
    setState(() {
      _obscureText2 = !_obscureText2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).titleSignUp),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).hintForUsername,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context).hintForAccount,
                    prefixIcon: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedCountryCode,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedCountryCode = newValue!;
                          });
                        },
                        items: _supportedCountryCodes
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _verificationCodeController,
                  decoration: InputDecoration(
                    labelText:
                        AppLocalizations.of(context).hintForVerificationCode,
                    suffix: TextButton(
                      onPressed: () {
                        // Handle sending verification code and start the countdown
                        _startCountdown();
                      },
                      child: Text(counterIsRunning
                          ? _verificationButtonText
                          : AppLocalizations.of(context).getVerificationCode),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: _obscureText1,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).setPassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText1 ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: _toggleObscureText1,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordConfirmController,
                  obscureText: _obscureText2,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).confirmPassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText2 ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: _toggleObscureText2,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Handle registration here
                  },
                  child: Text(AppLocalizations.of(context).submit),
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 48)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
