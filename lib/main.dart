import 'package:appcenter_bundle/appcenter_bundle.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'account_provider.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppCenter.startAsync(
    appSecretAndroid: 'ddade691-0c9f-4aae-9581-1fcb87781d80',
    appSecretIOS: 'ccffbb15-069d-460d-9c5c-23d35b878a4f',
    enableDistribute: true,
  );
  await AppCenter.configureDistributeDebugAsync(enabled: true);
  runApp(
    ChangeNotifierProvider(
      create: (context) => AccountProvider(),
      child: const MyApp(),
    ),
  );
}
