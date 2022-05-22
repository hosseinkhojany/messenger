import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:telegram_flutter/core/data/datasources/local/sharedStore.dart';
import 'package:telegram_flutter/core/utils/ext.dart';
import 'package:telegram_flutter/gen/assets.gen.dart';
import 'package:telegram_flutter/gen/colors.gen.dart';
import 'package:telegram_flutter/presentation/chatPage/ext.dart';
import 'package:telegram_flutter/presentation/sharedBloc/socket_bloc.dart';
import 'package:telegram_flutter/presentation/chatPage/components/message_widget.dart';

import '../globalWidgets/improvedScrolling/MMB_scroll_cursor_activity.dart';
import '../globalWidgets/improvedScrolling/config.dart';
import '../globalWidgets/improvedScrolling/custom_behavior.dart';
import '../globalWidgets/improvedScrolling/custom_scroll_cursor.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ChatPageStater();
}

class ChatPageStater extends State<ChatPage> {
  TextEditingController textEditingController = TextEditingController();

  ScrollController scrollControllerVertical = ScrollController();

  @override
  void dispose() {
    scrollControllerVertical.dispose();
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (SharedStore.getUserName().isNotEmpty) {
      context.sendImJoin(SharedStore.getUserName());
    }
    return Scaffold(
      appBar: AppBar(
        shape: context.isHorizontalScreen() ? null : RoundedRectangleBorder(
          side: BorderSide(
            width: 0.5,
            color: Colors.white10,
          ),
        ),
        shadowColor: context.isHorizontalScreen() ?Colors.black : Colors.transparent,
        backgroundColor: ColorName.chatPageMainBackground,
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
      body: RawKeyboardListener(
        focusNode: FocusNode(),
        child: Container(
          child: Stack(
            children: [
              //chat list
              Padding(
                padding: EdgeInsets.only(
                    bottom: context.isHorizontalScreen() ? 60 : 100, right: 5, left: 5, top: 5),
                child: BlocBuilder<SocketBloc, SocketState>(
                  builder: (context, state) {
                    return DefaultStickyHeaderController(
                      child: ImprovedScrolling(
                        scrollController: scrollControllerVertical,
                        enableMMBScrolling: true,
                        enableKeyboardScrolling: true,
                        enableCustomMouseWheelScrolling: true,
                        mmbScrollConfig: MMBScrollConfig(
                            customScrollCursor: DefaultCustomScrollCursor(),
                            autoScrollDelay: const Duration(milliseconds: 60)),
                        keyboardScrollConfig: KeyboardScrollConfig(
                          homeScrollDurationBuilder:
                              (currentScrollOffset, minScrollOffset) {
                            return const Duration(milliseconds: 100);
                          },
                          endScrollDurationBuilder:
                              (currentScrollOffset, maxScrollOffset) {
                            return const Duration(milliseconds: 2000);
                          },
                        ),
                        customMouseWheelScrollConfig:
                            const CustomMouseWheelScrollConfig(
                          scrollAmountMultiplier: 4.0,
                          scrollDuration: Duration(milliseconds: 350),
                        ),
                        child: ScrollConfiguration(
                          behavior: CustomScrollBehaviour(),
                          child: CustomScrollView(
                            controller: scrollControllerVertical,
                            reverse: true,
                            slivers: context
                                .getMessages()
                                .map((e) => MessageWidget(
                                    width: 300, height: 60, message: e))
                                .toList(),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              //bottom bar
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: EdgeInsets.all(context.isHorizontalScreen() ? 10 : 25),
                    child: Container(
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                EdgeInsets.only(left: 20, right: 20),
                                child: TextField(
                                  autofocus: true,
                                  focusNode: FocusNode(
                                    onKey: (FocusNode node, RawKeyEvent evt) {
                                      if (evt.isShiftPressed &&
                                          evt.logicalKey ==
                                              LogicalKeyboardKey.enter) {
                                        if (evt is RawKeyUpEvent) {
                                          var cursorPos = textEditingController
                                              .selection.base.offset;

                                          String suffixText =
                                          textEditingController.text
                                              .substring(cursorPos);

                                          String specialChars = '\n';
                                          int length = specialChars.length;

                                          String prefixText =
                                          textEditingController.text
                                              .substring(0, cursorPos);

                                          textEditingController.text =
                                              prefixText +
                                                  specialChars +
                                                  suffixText;

                                          textEditingController.selection =
                                              TextSelection(
                                                baseOffset: cursorPos + length,
                                                extentOffset: cursorPos + length,
                                              );
                                        }
                                        debugPrint("adding new line");
                                        return KeyEventResult.handled;
                                      } else {
                                        debugPrint("ingored textfield fokos");
                                        return KeyEventResult.ignored;
                                      }
                                    },
                                  ),
                                  style: TextStyle(color: Colors.white),
                                  cursorColor: Colors.yellow,
                                  onChanged: (str) => context.sendImTypingEvent(),
                                  onEditingComplete: () {},
                                  maxLines: null,
                                  textInputAction: TextInputAction.send,
                                  keyboardType: TextInputType.multiline,
                                  controller: textEditingController,
                                  decoration: const InputDecoration(
                                    hintStyle: TextStyle(color: Colors.white60),
                                    hintText: "Message",
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: InkWell(
                                child: Icon(Icons.mic_none_rounded,
                                    color: Colors.white),
                                onTap: () => sendMessage(),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: InkWell(
                                child:
                                const Icon(Icons.send, color: Colors.white),
                                onTap: () => sendMessage(),
                              ),
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                          boxShadow: context.isHorizontalScreen() ? [
                            BoxShadow(
                                offset: Offset(0, 0.3),
                                color: Colors.black,
                                blurRadius: 3,
                                blurStyle: BlurStyle.solid)
                          ] : null,
                          borderRadius: BorderRadius.circular(100),
                          shape: BoxShape.rectangle,
                          color: ColorName.defaultChatItemBackground,
                        ),
                        width: double.infinity,
                      ),
                    decoration: context.isHorizontalScreen() ? null : BoxDecoration(
                      border: Border.fromBorderSide(
                        BorderSide(
                          width: 0.3,
                          color: Colors.white10,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          decoration: BoxDecoration(
            color: ColorName.chatPageMainBackground,
            border: context.isHorizontalScreen()? null : Border.fromBorderSide(
              BorderSide(
                width: 0.3,
                color: Colors.white10,
              ),
            ),
          ),
        ),
        onKey: (event) {
          if (event.logicalKey == LogicalKeyboardKey.enter &&
              !event.isShiftPressed &&
              event.runtimeType == RawKeyUpEvent) {
            sendMessage();
          }
        },
      ),
    );
  }

  sendMessage() {
    if (textEditingController.text.toString().isNotEmpty) {
      context.sendImTypingStopEvent();
      context.sendMessage(textEditingController.text.toString());
      scrollControllerVertical.animateTo(
        scrollControllerVertical.position.minScrollExtent,
        duration: Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
      );
      textEditingController.clear();
    }
  }
}
