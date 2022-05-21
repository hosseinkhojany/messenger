import 'package:flutter/cupertino.dart';
import 'package:telegram_flutter/core/utils/ext.dart';
import 'package:telegram_flutter/presentation/chatListPage/chat_list_page.dart';
import 'package:telegram_flutter/presentation/chatPage/chat_page.dart';

class MergedChatListChatPageScreen extends StatefulWidget {
  MergedChatListChatPageScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MergedChatListChatPageScreenState();
  }
}

class MergedChatListChatPageScreenState
    extends State<MergedChatListChatPageScreen> {
  bool isHaveOpeningChat = false;

  @override
  Widget build(BuildContext context) {
    if (context.isHorizontalScreen()) {
      //use horizontal |
      if (isHaveOpeningChat) {
        //open fullscreen chat page
        return ChatPage();
      } else {
        //open fullscreen chat list page
        return ChatListPage();
      }
    } else {
      return Row(children: [
        ChatPage(),
        ChatListPage()
      ]);
    }
  }
}
