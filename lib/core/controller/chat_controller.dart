import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:telegram_flutter/core/data/repositories/chat_repository.dart';

import '../data/models/message.dart';
import '../utils/enums.dart';

class ChatController extends GetxController {
  final ChatRepository _chatRepository;

  ChatController(this._chatRepository);

  List<MessageModel> messages = [];
  List<UserTyping> typingUser = [];

  String userName = "";

  var socketState = SocketState.none.obs;

  @override
  void onInit() {
    _chatRepository.socketConnected(() {
      _chatRepository.listen().listen(
        (event) {
          if (event is UserTyping || event is UserTypingStop) {
            if (event is UserTypingStop) {
              remove(event);
            } else {
              if (!find(event as UserTyping)) {
                typingUser.add(event);
              }
            }
          } else {
            messages.add(event);
          }
          socketState.value = SocketState.connected;
          update();
        },
      );
      socketState.value = SocketState.connected;
      update();
    });
    _chatRepository.socketConnecting(() {
      socketState.value = SocketState.connecting;
      update();
    });
    _chatRepository.socketConnectionFailed(() {
      socketState.value = SocketState.failed;
      update();
    });
    super.onInit();
  }

  @override
  void dispose() {
    _chatRepository.socketDisconnected(() {
      socketState.value = SocketState.disconnected;
      update();
    });
    super.dispose();
  }

  sendMessage(String message) {
    Message inProcessMessage = Message(userName: userName, message: message, my: true);
    _chatRepository.sendMessage(message).then((value) {
      if (!value) {
        Get.showSnackbar(const GetSnackBar(
          message: "try again",
        ));
      } else {
        messages.add(inProcessMessage);
        update();
      }
    });
  }

  sendImJoined() {
    UserJoined inProcessMessage = UserJoined(userName: userName);
    _chatRepository.sendImJoined(userName).then((value) {
      if (!value) {
        Get.showSnackbar(const GetSnackBar(
          message: "try again",
        ));
      } else {
        messages.add(inProcessMessage);
        update();
      }
    });
  }

  sendImLeft() {
    UserLeft inProcessMessage = UserLeft(userName: userName);
    _chatRepository.sendImLeft().then((value) {
      if (!value) {
        Get.showSnackbar(const GetSnackBar(
          message: "try again",
        ));
      } else {
        messages.add(inProcessMessage);
        update();
      }
    });
  }

  sendImTyping() {
    _chatRepository.sendImTyping().then((value) {});
  }

  sendImStopTyping() {
    _chatRepository.sendImTypingStop().then((value) {});
  }

  String typingUsers() {
    String typingUsers = "";
    debugPrint(typingUser.length.toString());
    for (int i = 0; i < typingUser.length; i++) {
      typingUsers += ((typingUser[i]).userName ??
          "" + (i + 1 == typingUser.length ? "," : ""));
    }
    debugPrint("UserTyping:" + typingUsers);
    return typingUsers + " is typing...";
  }

  bool find(UserTyping event) {
    bool res = false;
    for (var element in typingUser) {
      res = event.userName == element.userName;
    }
    return res;
  }

  bool remove(UserTypingStop event) {
    for (int i = 0; i < typingUser.length; i++) {
      if (event.userName == typingUser[i].userName) {
        typingUser.removeAt(i);
        return true;
      }
    }
    return false;
  }
}
