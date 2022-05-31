import 'dart:convert';

import 'package:flimer/flimer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:image_compression_flutter/image_compression_flutter.dart';
import 'package:telegram_flutter/common/utils/ext.dart';
import 'package:telegram_flutter/presentation/chatPage/ext.dart';
import 'package:telegram_flutter/presentation/chatPage/components/message_widget.dart';
import 'package:telegram_flutter/presentation/globalWidgets/improvedScrolling/lazy_load_scrollview.dart';

import '../../common/gen/colors.gen.dart';
import '../../common/utils/consts.dart';
import '../../domain/chat/chat_bloc.dart';
import '../../domain/socket/socket_bloc.dart';
import 'components/bottomSheets.dart';
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

  Configuration config = const Configuration();
  ImageFile? image;
  ImageFile? imageOutput;
  bool processing = false;

  @override
  void dispose() {
    scrollControllerVertical.dispose();
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: context.isHorizontalScreen()
            ? null
            : const RoundedRectangleBorder(
                side: BorderSide(
                  width: 0.5,
                  color: Colors.white10,
                ),
              ),
        shadowColor:
            context.isHorizontalScreen() ? Colors.black : Colors.transparent,
        backgroundColor: ColorName.chatPageMainBackground,
        title: BlocBuilder<SocketBloc, SocketState>(
          builder: (context, state) {
            switch (state.runtimeType) {
              case SocketConnectedState:
              case SocketTypingState:
              case SocketTypingStopState:
              case SocketNewMessageState:
              case SocketUserJoinedState:
              case SocketUserLeftState:
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
          decoration: BoxDecoration(
            color: ColorName.chatPageMainBackground,
            border: context.isHorizontalScreen()
                ? null
                : const Border.fromBorderSide(
                    BorderSide(
                      width: 0.3,
                      color: Colors.white10,
                    ),
                  ),
          ),
          child: Stack(
            children: [
              //chat list
              Padding(
                padding: EdgeInsets.only(
                    bottom: context.isHorizontalScreen() ? 60 : 100,
                    right: 5,
                    left: 5,
                    top: 5),
                child: BlocBuilder<SocketBloc, SocketState>(
                  builder: (context, state) {
                    return DefaultStickyHeaderController(
                      child: ImprovedScrolling(
                        scrollController: scrollControllerVertical,
                        enableMMBScrolling: true,
                        enableKeyboardScrolling: true,
                        enableCustomMouseWheelScrolling: true,
                        mmbScrollConfig: const MMBScrollConfig(
                            customScrollCursor: DefaultCustomScrollCursor(),
                            autoScrollDelay: Duration(milliseconds: 60)),
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
                        child: BlocBuilder<ChatBloc, ChatState>(
                          builder: (context, state) {
                            if(state is Initial){
                              context.getHistory();
                            }
                            return ScrollConfiguration(
                              behavior: CustomScrollBehaviour(),
                              child: LazyLoadScrollView(
                                onEndOfPage: () => context.getHistory(),
                                child: CustomScrollView(
                                  reverse: true,
                                  controller: scrollControllerVertical,
                                  slivers: context
                                      .getMessages()
                                      .map((e) => MessageWidget(
                                          width: 300, height: 60, message: e)).toList(),
                                ),
                              ),
                            );
                          },
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
                  padding:
                      EdgeInsets.all(context.isHorizontalScreen() ? 10 : 25),
                  decoration: context.isHorizontalScreen()
                      ? null
                      : const BoxDecoration(
                          border: Border.fromBorderSide(
                            BorderSide(
                              width: 0.3,
                              color: Colors.white10,
                            ),
                          ),
                        ),
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: context.isHorizontalScreen()
                          ? [
                              const BoxShadow(
                                  offset: Offset(0, 0.3),
                                  color: Colors.black,
                                  blurRadius: 3,
                                  blurStyle: BlurStyle.solid)
                            ]
                          : null,
                      borderRadius: BorderRadius.circular(100),
                      shape: BoxShape.rectangle,
                      color: ColorName.defaultChatItemBackground,
                    ),
                    width: double.infinity,
                    child: Row(
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: GestureDetector(
                              child: const Icon(Icons.emoji_emotions_rounded,
                                  color: Colors.white),
                              onTap: () {
                                ChatPageBottomSheets().showLottiePicker(context,
                                    (emoji) {
                                  context.sendMessage(
                                      emoji, MESSAGE_TYPE.lottie.name);
                                });
                              },
                            )),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
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

                                      String suffixText = textEditingController
                                          .text
                                          .substring(cursorPos);

                                      String specialChars = '\n';
                                      int length = specialChars.length;

                                      String prefixText = textEditingController
                                          .text
                                          .substring(0, cursorPos);

                                      textEditingController.text = prefixText +
                                          specialChars +
                                          suffixText;

                                      textEditingController.selection =
                                          TextSelection(
                                        baseOffset: cursorPos + length,
                                        extentOffset: cursorPos + length,
                                      );
                                    }
                                    return KeyEventResult.handled;
                                  } else {
                                    return KeyEventResult.ignored;
                                  }
                                },
                              ),
                              style: const TextStyle(color: Colors.white),
                              cursorColor: Colors.yellow,
                              onChanged: (str) => context.sendImTypingEvent(),
                              onEditingComplete: () {},
                              maxLines: null,
                              textInputAction: TextInputAction.next,
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
                          child: GestureDetector(
                            onTap: () => handleSendImage(),
                            child: const Icon(Icons.image_outlined,
                                color: Colors.white),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: GestureDetector(
                            child: const Icon(Icons.mic_none_rounded,
                                color: Colors.white),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: GestureDetector(
                            child: const Icon(Icons.send, color: Colors.white),
                            onTap: () => sendMessage(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
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
      context.sendMessage(
          textEditingController.text.toString(), MESSAGE_TYPE.text.name);
      scrollControllerVertical.animateTo(
        scrollControllerVertical.position.minScrollExtent,
        duration: const Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
      );
      textEditingController.clear();
    }
  }

  handleSendImage() async {
    final xFile = await flimer.pickImage(source: ImageSource.gallery);
    if (xFile != null) {
      final image = await xFile.asImageFile;

      setState(() {
        processing = true;
      });

        config = Configuration(
          outputType: config.outputType,
          useJpgPngNativeCompressor: context.isMobile(),
          quality: 50,
        );

      final param = ImageFileConfiguration(input: image, config: config);
      final output = await compressor.compress(param);
      print(base64Encode(output.rawBytes));
      context.sendImage(base64Encode(output.rawBytes));

    }
  }

}
