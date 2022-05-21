import 'package:flutter/material.dart';
import 'package:telegram_flutter/gen/colors.gen.dart';
import 'package:telegram_flutter/presentation/chatListPage/components/tabbar.dart';

import '../../core/utils/ext.dart';
import '../globalWidgets/advanceDrawerMenu/src/controller.dart';
import '../globalWidgets/advanceDrawerMenu/src/widget.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({Key? key}) : super(key: key);

  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  final _advancedDrawerController = AdvancedDrawerController();

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      backdropColor: Colors.blueGrey,
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
                child: InkWell(
                  child: Image.asset(
                    'assets/images/flutter_logo.png',
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.account_circle_rounded),
                title: Text("Accounts"),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: Text("Contacts"),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: Text("Settings"),
              ),
              const Spacer(),
              DefaultTextStyle(
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white54,
                ),
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 16.0,
                  ),
                  child: Text('Terms of Service | Privacy Policy'),
                ),
              ),
            ],
          ),
        ),
      ),
      child: Container(
        color: ColorName.chatPageMainBackground,
        child: Row(
          children: [
            Column(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.menu,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    _advancedDrawerController.showDrawer();
                  },
                ),
                Padding(
                  padding:
                      EdgeInsets.only(right: 10, top: 25, bottom: 25, left: 10),
                  child: CustomTabBar(
                    background: HexColor("331F5E"),
                    iconColor: Colors.white,
                    orientation: CustomTabBarOrientation.horizontal,
                    customTabBarItems: [
                      CustomTabBarItem(icon: Icons.add),
                      CustomTabBarItem(icon: Icons.add),
                      CustomTabBarItem(icon: Icons.add),
                      CustomTabBarItem(icon: Icons.add),
                      CustomTabBarItem(icon: Icons.add),
                      CustomTabBarItem(icon: Icons.add),
                      CustomTabBarItem(icon: Icons.add),
                      CustomTabBarItem(icon: Icons.add),
                    ],
                  ),
                )
              ],
            ),
            Expanded(
              child: Column(
                children: [
                  //title of fragment
                  Row(
                    children: [],
                  ),
                  //search item
                  Row(
                    children: [],
                  ),
                  //list of chats
                  Container()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
