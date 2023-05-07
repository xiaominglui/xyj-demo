import 'package:authing_sdk_v3/authing.dart';
import 'package:authing_sdk_v3/client.dart';
import 'package:authing_sdk_v3/result.dart';
import 'package:authing_sdk_v3/user.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage> {
  TextEditingController _accountController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initAuthClient();
  }

  _initAuthClient() async {
    Authing.init('644a98699d66f835f88d4bc8', '644a99927a5a5e9d1f42b4ad');
  }


  _login() async {
    String account = _accountController.text.trim();
    String password = _passwordController.text.trim();
    try {
      AuthResult result = await AuthClient.loginByAccount(account, password);
      print(result.apiCode); // 200 upon success
    } catch (e) {
      print(e);
    }
  }

  _goToRegisterPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('输入帐号'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _accountController,
                decoration: InputDecoration(labelText: '邮箱'),
              ),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: '密码'),
                obscureText: true,
              ),
              SizedBox(height: 24.0),
              TextButton(
                onPressed: _goToRegisterPage,
                child: Text('找回密码'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(500, 50),
                ),
                onPressed: _login,
                child: Text('登录'),
              ),
              TextButton(
                onPressed: _goToRegisterPage,
                child: Text('还没有帐号'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RegisterPage extends StatefulWidget {

  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _verificationCodeController = TextEditingController();
  bool _codeSent = true;

  _sendVerificationCode() async {
    String email = _emailController.text.trim();
    AuthResult result = await AuthClient.sendEmail(email, "VERIFY_CODE");
    print(result.apiCode); // 200 upon success
    setState(() {
      _codeSent = true;
    });
  }

  _registerByEmail() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    // String verificationCode = _verificationCodeController.text.trim();

    try {
      AuthResult result = await AuthClient.registerByEmail(email, password);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.message)),
      );
      print('result=====${result.message}');
      User? user = result.user;
      print(user?.toString());
      Navigator.pop(context);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('注册新帐号'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: '邮箱'),
              ),
              if (!_codeSent)
                ElevatedButton(
                  onPressed: _sendVerificationCode,
                  child: Text('发送验证码'),
                ),
              if (!_codeSent)
                TextField(
                  controller: _verificationCodeController,
                  decoration: InputDecoration(labelText: '验证码'),
                ),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: '密码'),
                obscureText: true,
              ),
              SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: _registerByEmail,
                child: Text('注册'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}