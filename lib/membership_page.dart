import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xyj_helper/l10n/l10n.dart';

class MembershipPage extends StatefulWidget {
  const MembershipPage({super.key});

  @override
  _MembershipPageState createState() => _MembershipPageState();
}

class _MembershipPageState extends State<MembershipPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> vipBenefits = [
    'Ad-free',
    'Auto-checkin',
    'Auto-login',
    'VIP Customer Service'
  ];
  final List<String> svipBenefits = [
    'Ad-free',
    'Auto-checkin',
    'Auto-login',
    'VIP Customer Service',
    'Priority access to new features'
  ];
  final List<String> vipPaymentOptions = ['年付', '季付', '半年付', '月付'];
  final List<String> svipPaymentOptions = ['年付', '半年付'];

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
                const Icon(Icons.account_circle_rounded, size: 50.0, color: Colors.black45,),
                SizedBox(width: 16.0,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(isLoggedIn ? userName : AppLocalizations.of(context).titleNotLoggedIn, style: TextStyle(fontSize: 20.0)),
                    Text(AppLocalizations.of(context).renewalDate + renewalDateString,
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
  final List<String> paymentOptions;

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
      height: 100.0,
      margin: EdgeInsets.only(bottom: 8.0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: benefits.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.all(10.0),
            child: Column(
              children: [
                Icon(Icons.star, size: 50.0),
                Text(benefits[index], style: TextStyle(fontSize: 16.0)),
              ],
            ),
          );
        },
      ),
    );
  }
}

class PaymentOptionsList extends StatelessWidget {
  final List<String> paymentOptions;

  const PaymentOptionsList({super.key, required this.paymentOptions});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150.0,
      margin: EdgeInsets.only(bottom: 20.0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: paymentOptions.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '包年',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '低至3.9折',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      '¥66',
                      style: TextStyle(
                        color: Colors.yellow,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '¥168',
                      style: TextStyle(
                        fontSize: 12,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      color: Colors.red,
                      alignment: Alignment.center,
                      child: Text(
                        '仅需¥0.16/天',
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

