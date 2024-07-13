import 'package:flutter/material.dart';
import 'package:flutter_appcenter_bundle_updated_to_null_safety/flutter_appcenter_bundle_updated_to_null_safety.dart';
import 'package:package_info_plus/package_info_plus.dart';
class AppCenterTest extends StatefulWidget {
  const AppCenterTest({super.key});

  @override
  _AppCenterTestState createState() => _AppCenterTestState();
}

class _AppCenterTestState extends State<AppCenterTest> {
  @override
  void initState() {
    super.initState();
    AppCenter.trackEventAsync('_MyAppState.initState');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const PackageInfoContent(),
              const SizedBox(height: 8.0),
              FutureBuilder(
                future: AppCenter.isCrashesEnabledAsync(),
                builder: (_, AsyncSnapshot<bool?> snapshot) {
                  if (snapshot.hasData) {
                    final isCrashesEnabled = snapshot.data!;

                    return Text('IsCrashesEnabled: $isCrashesEnabled');
                  }

                  return const CircularProgressIndicator.adaptive();
                },
              ),
              const SizedBox(height: 8.0),
              FutureBuilder(
                future: AppCenter.isAnalyticsEnabledAsync(),
                builder: (_, AsyncSnapshot<bool?> snapshot) {
                  if (snapshot.hasData) {
                    final isAnalyticsEnabled = snapshot.data!;

                    return Text('IsAnalyticsEnabled: $isAnalyticsEnabled');
                  }

                  return const CircularProgressIndicator.adaptive();
                },
              ),
              const SizedBox(height: 8.0),
              FutureBuilder(
                future: AppCenter.isDistributeEnabledAsync(),
                builder: (_, AsyncSnapshot<bool?> snapshot) {
                  if (snapshot.hasData) {
                    final isDistributeEnabled = snapshot.data!;

                    return Text('IsDistributeEnabled: $isDistributeEnabled');
                  }

                  return const CircularProgressIndicator.adaptive();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PackageInfoContent extends StatelessWidget {
  const PackageInfoContent({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: PackageInfo.fromPlatform(),
      builder: (_, AsyncSnapshot<PackageInfo> snapshot) {
        if (snapshot.hasData) {
          final packageInfo = snapshot.data!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('App name:\n${packageInfo.appName}'),
              const SizedBox(height: 8.0),
              Text('Package name:\n${packageInfo.packageName}'),
              const SizedBox(height: 8.0),
              Text('Version:\n${packageInfo.version}'),
              const SizedBox(height: 8.0),
              Text('Build:\n${packageInfo.buildNumber}'),
            ],
          );
        }

        return const CircularProgressIndicator.adaptive();
      },
    );
  }
}