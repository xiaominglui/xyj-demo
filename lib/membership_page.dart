import 'package:authing_sdk/client.dart';
import 'package:authing_sdk/result.dart';
import 'package:authing_sdk/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xyj_helper/l10n/l10n.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:xyj_helper/utils.dart';

class MembershipPage extends StatefulWidget {
  const MembershipPage({super.key});

  @override
  _MembershipPageState createState() => _MembershipPageState();
}

class _MembershipPageState extends State<MembershipPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  User? _currentUser;
  List<dynamic>? _customData;

  final List<Map<String, String>> vipPaymentOptions = [
    {
      'name': '包月',
      'description': '限时内测优惠',
      'promotionalPrice': '¥28.9',
      'price': '￥59.9',
      'discount': '仅需￥0.96/天'
    },
    {
      'name': '包半年',
      'description': '限时早鸟优惠',
      'promotionalPrice': '¥158',
      'price': '¥299.9',
      'discount': '仅需￥0.87/天',
    },
    {
      'name': '包年',
      'description': '限时早鸟优惠',
      'promotionalPrice': '¥299',
      'price': '¥599.9',
      'discount': '仅需￥0.82/天',
    },
  ];
  final List<Map<String, String>> svipPaymentOptions = [
    {
      'name': '包半年',
      'description': '低至3.9折',
      'promotionalPrice': '¥258',
      'price': '¥399.9',
      'discount': '仅需￥1.43/天',
    },
    {
      'name': '包年',
      'description': '低至3.3折',
      'promotionalPrice': '¥399',
      'price': '¥699',
      'discount': '仅需￥1.09/天',
    },
    {
      'name': '一次性买断',
      'description': '终身免费更新、享用所有特权',
      'promotionalPrice': '¥799',
      'price': '¥999',
      'discount': '限时开放',
    }
  ];

  _getCurrentUser() async {
    AuthResult result = await AuthClient.getCurrentUser();
    if (result.code == 200) {
      if (result.user != null) {
        print("_getCurrentUser: ok");
        setState(() {
          _currentUser = result.user;
        });

        AuthResult r = await AuthClient.getCustomData(_currentUser!.id);
        if (r.code == 200) {
          print("_getCustomData: ok");
          setState(() {
            _customData = _currentUser?.customData;
          });
        } else {
          print("_getCustomData: ${r.message}");
          setState(() {
            _customData = null;
          });
        }
      } else {
        setState(() {
          _currentUser = null;
        });
      }
    } else {
      print("_getCurrentUser: ${result.message}");
      setState(() {
        _currentUser = null;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("=====build=====");
    final List<String> vipBenefits = [
      AppLocalizations.of(context).adFree,
      AppLocalizations.of(context).autoCheckin,
      AppLocalizations.of(context).autoLogin,
      AppLocalizations.of(context).vipCustomerService,
    ];

    final List<String> svipBenefits = [
      AppLocalizations.of(context).adFree,
      AppLocalizations.of(context).autoCheckin,
      AppLocalizations.of(context).autoLogin,
      AppLocalizations.of(context).vipCustomerService,
      AppLocalizations.of(context).priorityAccess,
    ];

    var renewalDateString = getNextRenewalTimeString(_customData) ?? "-";
    var renewalDate = getNextRenewalTime(_customData) ?? 0;
    var userName = _currentUser != null
        ? obscurePhoneNumber(_currentUser!.phone)
        : AppLocalizations.of(context).accountsNotLoggedIn;
    var isLoggedIn = _currentUser != null;
    var vipExpired = isVipExpired(renewalDate);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).joinVIP),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                const Icon(
                  Icons.account_circle_rounded,
                  size: 50.0,
                  color: Colors.black45,
                ),
                const SizedBox(
                  width: 16.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        isLoggedIn
                            ? userName
                            : AppLocalizations.of(context).titleNotLoggedIn,
                        style: const TextStyle(fontSize: 20.0)),
                    Text(
                        AppLocalizations.of(context).renewalDate +
                            renewalDateString,
                        style: TextStyle(
                            fontSize: 16.0,
                            color: vipExpired ? Colors.red : Colors.black45)),
                  ],
                ),
              ],
            ),
          ),
          TabBar(
            controller: _tabController,
            indicator: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.yellow, Colors.yellowAccent],
                end: Alignment.centerLeft,
                begin: Alignment.centerRight,
              ),
            ),
            tabs: [
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SvgPicture.asset(
                      'assets/icons/crown.svg',
                      height: 36,
                      width: 36,
                      color: Colors.black45,
                    ),
                    const Text("VIP", style: TextStyle(color: Colors.black54)),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SvgPicture.asset(
                      'assets/icons/crown.svg',
                      height: 36,
                      width: 36,
                      color: Colors.black45,
                    ),
                    const Text("SVIP", style: TextStyle(color: Colors.black54)),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                MembershipTab(
                    benefits: vipBenefits, paymentOptions: vipPaymentOptions),
                MembershipTab(
                    benefits: svipBenefits, paymentOptions: svipPaymentOptions),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MembershipTab extends StatelessWidget {
  final List<String> benefits;
  final List<Map<String, String>> paymentOptions;

  const MembershipTab({super.key, required this.benefits, required this.paymentOptions});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BenefitsList(benefits: benefits),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: const Row(children: [
            Icon(
              Icons.support_agent_rounded,
              color: Colors.blue,
              size: 32.0,
            ),
            SizedBox(
              width: 8.0,
            ),
            Column(children: [
              Text(
                "新注册用户免费体验7天ViP会员服务",
                textAlign: TextAlign.center,
              ),
              Text(
                "会员随时退，无忧退。",
                textAlign: TextAlign.center,
              ),
            ])
          ]),
        ),
        PaymentOptionsList(paymentOptions: paymentOptions),
      ],
    );
  }
}

class BenefitsList extends StatelessWidget {
  final List<String> benefits;

  const BenefitsList({super.key, required this.benefits});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: benefits.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        )
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      // Add your child widgets here
                      children: [
                        const Icon(
                          Icons.card_giftcard,
                          size: 50.0,
                          color: Colors.orange,
                        ),
                        Text(benefits[index], style: const TextStyle(fontSize: 16.0)),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class PaymentOptionsList extends StatelessWidget {
  final List<Map<String, String>> paymentOptions;

  const PaymentOptionsList({super.key, required this.paymentOptions});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: paymentOptions.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 5.5,
              child: InkWell(
                onTap: () {
                  print('Card tapped!');
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("👑请添加客服微信充值或咨询👑"),
                          content: const Text(" 🙋客服微信: jeff-studio"),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('我再想想'),
                            ),
                            TextButton(
                              onPressed: () async {
                                Fluttertoast.showToast(
                                  msg: "客服微信号已复制",
                                );
                                await Clipboard.setData(
                                    const ClipboardData(text: 'jeff-studio'));
                              },
                              child: const Text('点我复制'),
                            ),
                          ],
                        );
                      });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        paymentOptions[index]['name']!,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        paymentOptions[index]['description']!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        paymentOptions[index]['promotionalPrice']!,
                        style: const TextStyle(
                          color: Colors.deepOrange,
                          fontSize: 32,
                        ),
                      ),
                      Text(
                        paymentOptions[index]['price']!,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black26,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Container(
                        padding:
                            const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                        color: Colors.red,
                        alignment: Alignment.center,
                        child: Text(
                          paymentOptions[index]['discount']!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class PaymentOptionCard extends StatelessWidget {
  final int currentPrice;

  const PaymentOptionCard(this.currentPrice, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: <Widget>[
          const Text('Option title',
              style: TextStyle(fontSize: 20.0, color: Colors.blue)),
          const SizedBox(height: 16.0),
          const Text('Option hint'),
          const SizedBox(height: 16.0),
          Text('￥ $currentPrice'),
          const SizedBox(height: 16.0),
          const Text('Origin price'),
          const SizedBox(height: 16.0),
          const Text('Due date'),
        ]),
      ),
    );
  }
}
