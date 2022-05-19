import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:telegram_flutter/presentation/chatPage/ext.dart';
import 'package:telegram_flutter/presentation/sharedBloc/socket_bloc.dart';
import 'package:telegram_flutter/core/data/models/message.dart';
import 'package:telegram_flutter/presentation/chatPage/components/message_widget.dart';
import 'package:telegram_flutter/presentation/chatPage/components/user_joined_left_widget.dart';

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
        title: BlocBuilder<SocketBloc, SocketState>(
          builder: (context, state) {
            switch (state.runtimeType) {
              case SocketConnectedState:
              case TypingState:
              case TypingStopState:
              case SocketNewMessageState:
              case UserJoinedState:
              case UserLeftState:
                if (context.getTypingUsersList().isNotEmpty) {
                  return Text(context.getTypingUsers());
                } else {
                  return const Text("Connected");
                }
              case SocketConnectingState:
                return const Text("Connecting...");
              case SocketFailedState:
                return const Text("Connection Failed o_O");
              default:
                return const Text(">_<");
            }
          },
        ),
      ),
      body: Container(
        child: Stack(
          children: const [ChatListWidget(), InputBoxWidget()],
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/b.png"), fit: BoxFit.cover),
        ),
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
      child: BlocBuilder<SocketBloc, SocketState>(
        builder: (context, state) {
          return ListView.builder(
            itemCount: context.getMessages().length,
            itemBuilder: (BuildContext context, int index) {
              switch (context.getMessages()[index].runtimeType) {
                case Message:
                  Message message = (context.getMessages()[index] as Message);
                  return MessageWidget(
                      width: 300, height: 60, message: message);
                case UserJoined:
                  UserJoined userJoined =
                      (context.getMessages()[index] as UserJoined);
                  return UserJoinedLeftWidget(
                    joined: userJoined,
                  );
                case UserLeft:
                  UserLeft userLeft =
                      (context.getMessages()[index] as UserLeft);
                  return UserJoinedLeftWidget(
                    left: userLeft,
                  );
                default:
                  return const Text("Un Support message");
              }
            },
          );
        },
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
                    onChanged: (str) => context.sendImTypingEvent(),
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
                padding: const EdgeInsets.only(right: 10),
                child: InkWell(
                  child: const Icon(Icons.mic_rounded),
                  onTap: () {
                    if (textEditingController.text.toString().isNotEmpty) {
                      context.sendImTypingStopEvent();
                      context
                          .sendMessage(textEditingController.text.toString());
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: InkWell(
                  child: const Icon(Icons.send),
                  onTap: () {
                    if (textEditingController.text.toString().isNotEmpty) {
                      context.sendImTypingStopEvent();
                      context
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
