import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:telegram_flutter/core/controller/chat_controller.dart';
import 'package:telegram_flutter/core/data/models/message.dart';
import 'package:telegram_flutter/presentation/chatPage/message_widget.dart';
import 'package:telegram_flutter/presentation/chatPage/user_joined_left_widget.dart';

import '../../core/utils/enums.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ChatPageStater();
}

class ChatPageStater extends State<ChatPage> {
  TextEditingController textEditingController = TextEditingController();

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GetBuilder<ChatController>(
          builder: (chatController) {
            switch (chatController.socketState.value) {
              case SocketState.connected:
                if (chatController.typingUser.isNotEmpty) {
                  return Text(chatController.typingUsers());
                } else {
                  return const Text("Connected");
                }
              case SocketState.connecting:
                return const Text("Connecting...");
              case SocketState.failed:
                return const Text("Connection Failed o_O");
              default:
                return const Text(">_<");
            }
          },
        ),
      ),
      body: Stack(
        children: const [ChatListWidget(), InputBoxWidget()],
      ),
    );
  }
}

class ChatListWidget extends StatefulWidget {
  const ChatListWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ChatListWidgetStater();
}

class ChatListWidgetStater extends State<ChatListWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 60, right: 5, left: 5, top: 5),
      child: GetBuilder<ChatController>(
        builder: (chatController) => ListView.builder(
          itemCount: chatController.messages.length,
          itemBuilder: (BuildContext context, int index) {
            switch (chatController.messages[index].runtimeType) {
              case Message:
                Message message = (chatController.messages[index] as Message);
                return MessageWidget(width: 300, height: 60, message: message);
              case UserJoined:
                UserJoined userJoined =
                    (chatController.messages[index] as UserJoined);
                return UserJoinedLeftWidget(joined: userJoined,);
              case UserLeft:
                UserLeft userLeft =
                    (chatController.messages[index] as UserLeft);
                return UserJoinedLeftWidget(left: userLeft,);
              default:
                return const Text("Un Support message");
            }
          },
        ),
      ),
    );
  }
}

class InputBoxWidget extends StatefulWidget {
  const InputBoxWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => InputBoxWidgetStater();
}

class InputBoxWidgetStater extends State<InputBoxWidget> {
  TextEditingController textEditingController = TextEditingController();
  ChatController chatController = Get.find();

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: TextField(
                    onChanged: (str) =>
                        {Get.find<ChatController>().sendImTyping()},
                    onSubmitted: (str) {
                      Get.find<ChatController>().sendImStopTyping();
                    },
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    controller: textEditingController,
                    decoration: const InputDecoration(
                      hintText: "Message",
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: InkWell(
                  child: const Icon(Icons.send),
                  onTap: () {
                    if (textEditingController.text.toString().isNotEmpty) {
                      Get.find<ChatController>().sendImStopTyping();
                      chatController
                          .sendMessage(textEditingController.text.toString());
                    }
                  },
                ),
              ),
            ],
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            shape: BoxShape.rectangle,
            color: Colors.black54,
          ),
          width: double.infinity,
        ),
      ),
    );
  }
}
