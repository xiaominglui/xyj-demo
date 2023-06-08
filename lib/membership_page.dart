import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xyj_helper/l10n/l10n.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MembershipPage extends StatefulWidget {
  const MembershipPage({super.key});

  @override
  _MembershipPageState createState() => _MembershipPageState();
}

class _MembershipPageState extends State<MembershipPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, String>> vipPaymentOptions = [
    {
      'name': '包月',
      'description': '限时早鸟优惠',
      'promotionalPrice': '¥28.9',
      'price': '￥39.9',
      'discount': '仅需￥0.96/天'
    },
    {
      'name': '包半年',
      'description': '限时早鸟优惠',
      'promotionalPrice': '¥158',
      'price': '¥239.4',
      'discount': '仅需￥0.87/天',
    },
    {
      'name': '包年',
      'description': '限时早鸟优惠',
      'promotionalPrice': '¥299',
      'price': '¥499',
      'discount': '仅需￥0.82/天',
    },
  ];
  final List<Map<String, String>> svipPaymentOptions = [
    {
      'name': '包半年',
      'description': '低至3.9折',
      'promotionalPrice': '¥155',
      'price': '¥399',
      'discount': '仅需￥0.85/天',
    },
    {
      'name': '包年',
      'description': '低至3.3折',
      'promotionalPrice': '¥199',
      'price': '¥599',
      'discount': '仅需￥0.55/天',
    },
    {
      'name': '一次性买断',
      'description': '终身免费更新、享用所有特权',
      'promotionalPrice': '¥699',
      'price': '¥899',
      'discount': '限时开放',
    }
  ];

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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

    var renewalDateString = "-";
    var userName = "张三";
    var isLoggedIn = false;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).joinVIP),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(20.0),
            child: Row(
              children: [
                const Icon(
                  Icons.account_circle_rounded,
                  size: 50.0,
                  color: Colors.black45,
                ),
                SizedBox(
                  width: 16.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        isLoggedIn
                            ? userName
                            : AppLocalizations.of(context).titleNotLoggedIn,
                        style: TextStyle(fontSize: 20.0)),
                    Text(
                        AppLocalizations.of(context).renewalDate +
                            renewalDateString,
                        style: TextStyle(fontSize: 16.0)),
                  ],
                ),
              ],
            ),
          ),
          TabBar(
            controller: _tabController,
            indicator: BoxDecoration(
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
                    Text("VIP", style: TextStyle(color: Colors.black54)),
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
                    Text("SVIP", style: TextStyle(color: Colors.black54)),
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

  MembershipTab({required this.benefits, required this.paymentOptions});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BenefitsList(benefits: benefits),
        PaymentOptionsList(paymentOptions: paymentOptions),
      ],
    );
  }
}

class BenefitsList extends StatelessWidget {
  final List<String> benefits;

  BenefitsList({required this.benefits});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: benefits.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.all(10.0),
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
                        Icon(
                          Icons.card_giftcard,
                          size: 50.0,
                          color: Colors.orange,
                        ),
                        Text(benefits[index], style: TextStyle(fontSize: 16.0)),
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

  PaymentOptionsList({super.key, required this.paymentOptions});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220.0,
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
                          title: Text("👑请添加客服微信充值或咨询👑"),
                          content: Text(" 🙋客服微信: jeff-studio"),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('我再想想'),
                            ),
                            TextButton(
                              onPressed: () async {
                                Fluttertoast.showToast(
                                  msg: "客服微信号已复制",
                                );
                                await Clipboard.setData(
                                    const ClipboardData(text: 'jeff-studio'));
                              },
                              child: Text('点我复制'),
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
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        paymentOptions[index]['description']!,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        paymentOptions[index]['promotionalPrice']!,
                        style: TextStyle(
                          color: Colors.deepOrange,
                          fontSize: 32,
                        ),
                      ),
                      Text(
                        paymentOptions[index]['price']!,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black26,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                        color: Colors.red,
                        alignment: Alignment.center,
                        child: Text(
                          paymentOptions[index]['discount']!,
                          style: TextStyle(
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

  PaymentOptionCard(this.currentPrice);

  @override
  Widget build(BuildContext context) {
    return new Card(
      child: new Padding(
        padding: const EdgeInsets.all(16.0),
        child: new Column(children: <Widget>[
          new Text('Option title',
              style: TextStyle(fontSize: 20.0, color: Colors.blue)),
          new SizedBox(height: 16.0),
          new Text('Option hint'),
          new SizedBox(height: 16.0),
          new Text('￥ $currentPrice'),
          new SizedBox(height: 16.0),
          new Text('Origin price'),
          new SizedBox(height: 16.0),
          new Text('Due date'),
        ]),
      ),
    );
  }
}
