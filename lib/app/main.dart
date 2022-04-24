import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:telegram_flutter/app/router.dart';
import 'package:telegram_flutter/di/bindings.dart';

import '../data/config/hive_config.dart';

void main() async {
  await HiveConfig.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Telegram Chat app',
        initialRoute: CHAT_PAGE,
        initialBinding: AppBindings(),
        onGenerateRoute: AppRouter().generateRoute,);
  }
}
