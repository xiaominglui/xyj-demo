import 'package:authing_sdk/client.dart';
import 'package:authing_sdk/result.dart';
import 'package:flutter/material.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({super.key});

  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  String nickname = '昵称';
  String phoneNumber = '手机号';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('用户信息')),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: const Text('昵称'),
            trailing: Text(nickname),
            onTap: () async {
              final result = await showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('设置昵称'),
                      content: TextField(
                        onChanged: (value) {
                          nickname = value;
                        },
                        decoration: InputDecoration(
                            hintText: "请输入昵称",
                            counterText: "${nickname.length}/12"),
                        maxLength: 12,
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('取消'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        TextButton(
                          child: const Text('确定'),
                          onPressed: () {
                            Navigator.pop(context);
                            setState(() {});
                          },
                        )
                      ],
                    );
                  });
            },
          ),
          ListTile(
            title: const Text('手机号'),
            trailing: Text(phoneNumber),
          ),
          TextButton(
              style: TextButton.styleFrom(textStyle: const TextStyle()),
              onPressed: () async {
                // show a dialog with cancel and confirm button

                await showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('确认退出？'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('取消'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          TextButton(
                            child: const Text('确定'),
                            onPressed: () async {
                              AuthResult result = await AuthClient.logout();
                              var code = result.code;
                              print("logout: $code");
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                          )
                        ],
                      );
                    });
              },
              child: const Text('退出登录'))
        ],
      ),
    );
  }
}
