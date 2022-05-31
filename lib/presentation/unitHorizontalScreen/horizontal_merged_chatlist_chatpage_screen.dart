import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:telegram_flutter/core/utils/ext.dart';
import 'package:telegram_flutter/gen/colors.gen.dart';
import 'package:telegram_flutter/presentation/chatListPage/chat_list_page.dart';
import 'package:telegram_flutter/presentation/chatPage/chat_page.dart';

import '../../app/router.dart';
import '../globalWidgets/advanceDrawerMenu/src/controller.dart';
import '../globalWidgets/advanceDrawerMenu/src/widget.dart';

class MergedChatListChatPageScreen extends StatefulWidget {
  const MergedChatListChatPageScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MergedChatListChatPageScreenState();
  }
}

class MergedChatListChatPageScreenState
    extends State<MergedChatListChatPageScreen> {
  bool isHaveOpeningChat = false;
  final _advancedDrawerController = AdvancedDrawerController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
        backdropColor: ColorName.sideMenuBackground,
        controller: _advancedDrawerController,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        animateChildDecoration: true,
        rtlOpening: false,
        // openScale: 1.0,
        disabledGestures: false,
        childDecoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        drawer: SafeArea(
          child: ListTileTheme(
            textColor: Colors.white,
            iconColor: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: 128.0,
                  height: 128.0,
                  margin: const EdgeInsets.only(
                    top: 24.0,
                    bottom: 64.0,
                  ),
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(
                    color: Colors.black26,
                    shape: BoxShape.circle,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      log('going to route {USER_PROFILE}');
                      Navigator.pushNamed(context, USER_PROFILE);
                    },
                    child: Image.asset(
                      'assets/images/b.png',
                    ),
                  ),
                ),
                const ListTile(
                  leading: Icon(Icons.account_circle_rounded),
                  title: Text("Accounts"),
                ),
                const ListTile(
                  leading: Icon(Icons.home),
                  title: Text("Contacts"),
                ),
                const ListTile(
                  leading: Icon(Icons.home),
                  title: Text("Settings"),
                ),
                const Spacer(),
                DefaultTextStyle(
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white54,
                  ),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 16.0,
                    ),
                    child: const Text('Terms of Service | Privacy Policy'),
                  ),
                ),
              ],
            ),
          ),
        ),
        child: responiveChooser());
  }

  Widget responiveChooser() {
    Widget widget = Container();
    if (context.isHorizontalScreen()) {
      //use horizontal |
      if (isHaveOpeningChat) {
        //open fullscreen chat page
        widget = ChatListPage(
          onMenuClicked: () {
            _advancedDrawerController.showDrawer();
          },
        );
      } else {
        //open fullscreen chat list page
        widget = const ChatPage();
      }
    } else {
      widget = Row(children: [
        Expanded(child: ChatListPage(
          onMenuClicked: () {
            _advancedDrawerController.showDrawer();
          },
        )),
        const Expanded(child: ChatPage())
      ]);
    }
    return widget;
  }
}
