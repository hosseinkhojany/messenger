import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:telegram_flutter/controller/chat_controller.dart';
import 'package:telegram_flutter/utils/enums.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ChatPageStater();
}

class ChatPageStater extends State<ChatPage> {

  TextEditingController textEditingController = TextEditingController();
  ChatController chatController = Get.find();

  @override
  void dispose() {
    textEditingController.dispose();
    chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx((){
          switch(chatController.socketState.value){
            case SocketState.connected: return Text("Connected");
            case SocketState.none: return Text("O_o");
            case SocketState.connecting: return Text("Connecting...");
            case SocketState.failed: return Text("Connection Failed o_O");
          }
        },),
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
  ChatController chatController = Get.find();

  @override
  void dispose() {
    chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 60, right: 5, left: 5, top: 5),
      child: Container(
        color: Colors.red,
        child: Obx(
          () => ListView.builder(
            itemCount: chatController.messages.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(chatController.messages[index]),
              );
            },
          ),
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
                    if(textEditingController.text.toString().isNotEmpty){
                      chatController.sendMessage(textEditingController.text.toString());
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
