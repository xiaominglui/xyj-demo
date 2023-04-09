import 'package:flutter/material.dart';

class OverviewPage extends StatelessWidget {
  const OverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: 实现今日概览页面的UI和功能
    return const Scaffold(
      body: SafeArea(
        child: Center(child: Text('时间轴，建设中，每次自动登录形成一个事件，事件按天分组，形成一个时间轴，点击一个事件，进入事件详情；时间轴可分享'),),
      ),
    );
  }
}
