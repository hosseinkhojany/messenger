import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:telegram_flutter/app/router.dart';
import 'package:telegram_flutter/core/data/config/hive_config.dart';
import 'package:telegram_flutter/presentation/chatPage/chat_page.dart';
import 'package:telegram_flutter/presentation/editNamePage/edit_name_page.dart';
import 'app/bindings.dart';
import 'app/bloc_observer.dart';

void main() async {
  await HiveConfig.init();
  BlocOverrides.runZoned(
        () => runApp(AppBindingsBloc(child: const MyApp())),
    blocObserver: AppBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Telegram Chat app',
      initialRoute: EDIT_NAME_PAGE,
      routes: {
        EDIT_NAME_PAGE: (context) => const EditNamePage(),
        CHAT_PAGE: (context) => const ChatPage()
      },
      onGenerateRoute: AppRouter().generateRoute,
    );
  }
}
