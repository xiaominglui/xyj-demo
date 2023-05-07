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
                    obscureText: _obscureText,
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
                    onPressed: () {},
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
  final TextEditingController _verificationCodeController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();

  bool _obscureText1 = true;
  bool _obscureText2 = true;

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
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Handle password reset here
                },
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
