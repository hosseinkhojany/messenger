import 'package:flutter/material.dart';
import 'package:telegram_flutter/core/data/models/chat.dart';
import 'package:telegram_flutter/gen/colors.gen.dart';
import 'package:telegram_flutter/presentation/chatListPage/components/tabbar.dart';

import '../../core/utils/ext.dart';
import '../globalWidgets/improvedScrolling/MMB_scroll_cursor_activity.dart';
import '../globalWidgets/improvedScrolling/config.dart';
import '../globalWidgets/improvedScrolling/custom_behavior.dart';
import '../globalWidgets/improvedScrolling/custom_scroll_cursor.dart';
import 'components/chat_item.dart';

class ChatListPage extends StatefulWidget {
  final Function onMenuClicked;

  const ChatListPage({Key? key, required this.onMenuClicked}) : super(key: key);

  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  @override
  void dispose() {
    super.dispose();
  }
// == ====
  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorName.chatPageMainBackground,
      child: !context.isHorizontalScreen()
          ? Row(
              children: [
                Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 25),
                        child: IconButton(
                          icon: const Icon(
                            Icons.menu,
                            color: Colors.white,
                          ),
                          onPressed: () => widget.onMenuClicked.call(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          right: 10, top: 25, bottom: 25, left: 10),
                      child: CustomTabBar(
                        background: ColorName.tabBarBackground,
                        iconColor: Colors.white,
                        orientation: CustomTabBarOrientation.horizontal,
                        customTabBarItems: tabItems,
                      ),
                    )
                  ],
                ),
                Expanded(
                  child: Column(
                    children: [
                      //search item
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  right: 10, top: 20, bottom: 10, left: 25),
                              child: Container(
                                padding: const EdgeInsets.only(
                                    right: 10, left: 10, top: 3, bottom: 3),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(17),
                                  color: ColorName.defaultChatItemBackground,
                                ),
                                child: Center(
                                  child: TextField(
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      hintText: "Search",
                                      hintStyle: TextStyle(
                                        color: Colors.white60,
                                      ),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10, right: 25),
                            child: Container(
                              height: 50,
                              width: 50,
                              decoration: const BoxDecoration(
                                color: ColorName.defaultChatItemBackground,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(17),
                                ),
                              ),
                              child: Center(
                                child: Icon(Icons.search, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const ListChats()
                    ],
                  ),
                ),
              ],
            )
          : Column(
              children: [
                Row(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: IconButton(
                          icon: const Icon(
                            Icons.menu,
                            color: Colors.white,
                          ),
                          onPressed: () => widget.onMenuClicked.call(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          right: 10, top: 20, bottom: 10, left: 25),
                      child: CustomTabBar(
                        background: ColorName.tabBarBackground,
                        iconColor: Colors.white,
                        orientation: CustomTabBarOrientation.vertical,
                        customTabBarItems: tabItems,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: const BoxDecoration(
                          color: ColorName.defaultChatItemBackground,
                          borderRadius: BorderRadius.all(
                            Radius.circular(17),
                          ),
                        ),
                        child: Center(
                          child: Icon(Icons.search, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                const ListChats()
              ],
            ),
    );
  }

  List<CustomTabBarItem> tabItems = [
    CustomTabBarItem(icon: Icons.person),
    CustomTabBarItem(icon: Icons.group_outlined),
    CustomTabBarItem(icon: Icons.call),
    CustomTabBarItem(icon: Icons.vertical_align_bottom),
    CustomTabBarItem(icon: Icons.home),
  ];
}

class ListChats extends StatefulWidget {
  const ListChats({Key? key}) : super(key: key);

  @override
  _ListChatsState createState() => _ListChatsState();
}

class _ListChatsState extends State<ListChats> {
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ImprovedScrolling(
        scrollController: scrollController,
        enableMMBScrolling: true,
        enableKeyboardScrolling: true,
        enableCustomMouseWheelScrolling: true,
        mmbScrollConfig: const MMBScrollConfig(
            customScrollCursor: DefaultCustomScrollCursor(),
            autoScrollDelay: Duration(milliseconds: 60)),
        keyboardScrollConfig: KeyboardScrollConfig(
          homeScrollDurationBuilder: (currentScrollOffset, minScrollOffset) {
            return const Duration(milliseconds: 100);
          },
          endScrollDurationBuilder: (currentScrollOffset, maxScrollOffset) {
            return const Duration(milliseconds: 2000);
          },
        ),
        customMouseWheelScrollConfig: const CustomMouseWheelScrollConfig(
          scrollAmountMultiplier: 4.0,
          scrollDuration: Duration(milliseconds: 350),
        ),
        child: ScrollConfiguration(
          behavior: CustomScrollBehaviour(),
          child: ListView.builder(
              itemCount: testChatList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => setState(() {
                    unSelectAll();
                    testChatList[index].isActive = true;
                  }),
                  child: ChatItem(chatModel: testChatList[index]),
                );
              }),
        ),
      ),
    );
  }

  void unSelectAll() {
    for (var chat in testChatList) {
      chat.isActive = false;
    }
  }

  List<PrivateChat> testChatList = [
    PrivateChat(
      username: "this.username",
      lastMessage: "this.lastMessage",
      imageUrl: "this.imageUrl",
      time: "this.time",
      unreadCounts: 0,
    ),
    PrivateChat(
      username: "this.username",
      lastMessage: "this.lastMessage",
      imageUrl: "this.imageUrl",
      time: "this.time",
      unreadCounts: 0,
    ),
    PrivateChat(
      username: "this.username",
      lastMessage: "this.lastMessage",
      imageUrl: "this.imageUrl",
      time: "this.time",
      unreadCounts: 0,
    ),
    PrivateChat(
      username: "this.username",
      lastMessage: "this.lastMessage",
      imageUrl: "this.imageUrl",
      time: "this.time",
      unreadCounts: 0,
    ),
    PrivateChat(
      username: "this.username",
      lastMessage: "this.lastMessage",
      imageUrl: "this.imageUrl",
      time: "this.time",
      unreadCounts: 0,
    ),
    PrivateChat(
      username: "this.username",
      lastMessage: "this.lastMessage",
      imageUrl: "this.imageUrl",
      time: "this.time",
      unreadCounts: 0,
    ),
    PrivateChat(
      username: "this.username",
      lastMessage: "this.lastMessage",
      imageUrl: "this.imageUrl",
      time: "this.time",
      unreadCounts: 0,
    ),
  ];
}
