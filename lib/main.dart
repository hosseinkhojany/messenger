import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:telegram_flutter/app/getx_binding.dart';
import 'package:telegram_flutter/app/router.dart';
import 'package:telegram_flutter/presentation/editNamePage/edit_name_page.dart';
import 'package:telegram_flutter/presentation/chatPage/components/dialogs.dart';
import 'package:telegram_flutter/presentation/globalWidgets/improvedScrolling/lazy_load_scrollview.dart';
import 'package:telegram_flutter/presentation/unitHorizontalScreen/horizontal_merged_chatlist_chatpage_screen.dart';
import 'app/bloc_binding.dart';
import 'app/bloc_observer.dart';
import 'core/data/datasources/local/sharedStore.dart';

void main() async {
  await SharedStore.init();
  BlocOverrides.runZoned(
    () => runApp(AppBindingsBloc(child: MyApp())),
    blocObserver: AppBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  int page = 0;
  int limit = 0;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Telegram Chat app',
      initialBinding: GetxBinding(),
      initialRoute: SharedStore.getUserName().isNotEmpty ? CHAT_PAGE : EDIT_NAME_PAGE,
      routes: {
        EDIT_NAME_PAGE: (context) => const EditNamePage(),
        CHAT_PAGE: (context) => MergedChatListChatPageScreen()
      },
      onGenerateRoute: AppRouter().generateRoute,
    );
  }
}
