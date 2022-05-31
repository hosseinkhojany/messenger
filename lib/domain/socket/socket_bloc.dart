import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:telegram_flutter/presentation/globalWidgets/app_snackbar.dart';

import '../../data/datasources/local/sharedStore.dart';
import '../../data/models/message.dart';
import '../../data/repositories/chat_repository.dart';


part 'socket_event.dart';
part 'socket_state.dart';

class SocketBloc extends Bloc<SocketEvent, SocketState> {
  final ChatRepository _chatRepository;

  List<UserTypingModel> typingUser = [];

  late DateTime lastTypingTime;
  bool connected = false;
  bool typing = false;
  int typingTimerLength = 400;

  String userName = "";

  SocketBloc(this._chatRepository) : super(SocketConnectedState()) {
    _chatRepository.socketConnected(() {
      if(SharedStore.getUserName().isNotEmpty || userName.isNotEmpty){
        add(SocketUserJoinedEvent(SharedStore.getUserName().isNotEmpty ? SharedStore.getUserName() : userName));
      }
      _chatRepository.listen().listen(
        (event) {
          if (event is UserTypingModel || event is UserTypingStopModel) {
            if (event is UserTypingStopModel) {
              remove(event);
            } else {
              if (!find(event as UserTypingModel)) {
                typingUser.add(event);
              }
            }
          } else {
            _chatRepository.addMessage(event);
          }
          add(SocketNewMessageReceivedEvent());
        },
      );
      connected = true;
      add(SocketConnectedEvent());
    });
    _chatRepository.socketConnecting(() {
      add(SocketConnectingEvent());
      connected = false;
    });
    _chatRepository.socketConnectionFailed(() {
      add(SocketFailedEvent());
      connected = false;
    });
    on<SocketEvent>((event, emit) async {
      switch (event.runtimeType) {
        case SocketConnectedEvent:
          emit(SocketConnectedState());
          break;
        case SocketConnectingEvent:
          emit(SocketConnectedState());
          break;
        case SocketDisconnectedEvent:
          emit(SocketDisconnectedState());
          break;
        case SocketFailedEvent:
          emit(SocketFailedState());
          break;
        case SocketTypingEvent:
          await sendImTyping(emit);
          break;
        case SocketTypingStopEvent:
          sendImStopTyping(emit);
          break;
        case SocketUserJoinedEvent:
            await sendImJoin((event as SocketUserJoinedEvent).userName, emit);
          break;
        case SocketUserLeftEvent:
          sendImLeft(emit);
          break;
        case SocketSendMessageEvent:
          sendMessage((event as SocketSendMessageEvent).message,(event).messageType, emit);
          break;
        case SocketNewMessageReceivedEvent:
          emit(SocketNewMessageState());
          break;
      }
    });
  }

  sendMessage(String message,String messageType, Emitter<SocketState> emit) {
    MessageModel inProcessMessage =
        MessageModel(userName: userName, message: message,messageType: messageType, my: true);
    _chatRepository.sendMessage(message, messageType).then((value) {
      if (!value) {
        AppSnackBar.show("if you are in (Iran, Syria, Cuba, South Korea) make sure VPN connected");
      } else {
        _chatRepository.addMessage(inProcessMessage);
        emit(SocketNewMessageState());
      }
    });
  }

  bool isSignedIn = false;
  bool loginLoading = false;

  sendImJoin(String userName, Emitter<SocketState> emit) async {
    if(!isSignedIn && !loginLoading){
      loginLoading = true;
      emit(SocketUserJoinedState());
      UserJoinedModel inProcessMessage = UserJoinedModel(userName: userName, my: true);
      await _chatRepository.sendImJoined(userName).then((value) {
        if (!value) {
          AppSnackBar.show("if you are in (Iran, Syria, Cuba, South Korea) make sure VPN connected");
          emit(SocketUserJoinedState());
          isSignedIn = false;
          loginLoading = false;
        } else {
          _chatRepository.addMessage(inProcessMessage);
          emit(SocketUserJoinedState());
          SharedStore.setUserName(userName);
          isSignedIn = true;
          loginLoading = false;
        }
      });
    }
  }

  sendImLeft(Emitter<SocketState> emit) {
    UserLeftModel inProcessMessage = UserLeftModel(userName: userName, my: true);
    _chatRepository.sendImLeft().then((value) {
      if (!value) {
        AppSnackBar.show("if you are in (Iran, Syria, Cuba, South Korea) make sure VPN connected");
      } else {
        _chatRepository.addMessage(inProcessMessage);
        emit(SocketUserLeftState());
      }
    });
  }

  sendImTyping(Emitter<SocketState> emit) async {
    if (connected) {
      if (!typing) {
        typing = true;
        _chatRepository.sendImTyping().then((value) {});
        emit(SocketTypingState());
        debugPrint("send typing");
      }
      lastTypingTime = DateTime.now();
      await Future.delayed(Duration(milliseconds: typingTimerLength), () {
        DateTime typingTimer = DateTime.now();
        int timeDiff = typingTimer.millisecondsSinceEpoch -
            lastTypingTime.millisecondsSinceEpoch;
        if (timeDiff >= typingTimerLength && typing) {
          typing = false;
          _chatRepository.sendImTypingStop().then((value) {});
          emit(SocketTypingStopState());
          debugPrint("timer true");
        } else {
          debugPrint("$timeDiff typing :$typing");
        }
      });
    }
  }

//   const updateTyping = () => {
//   if (connected) {
//   if (!typing) {
//   typing = true;
//   socket.emit('typing');
//   }
//   lastTypingTime = (new Date()).getTime();
//
//   setTimeout(() => {
//   const typingTimer = (new Date()).getTime();
//   const timeDiff = typingTimer - lastTypingTime;
//   if (timeDiff >= TYPING_TIMER_LENGTH && typing) {
//   socket.emit('stop typing');
//   typing = false;
//   }
//   }, TYPING_TIMER_LENGTH);
// }
// }
  sendImStopTyping(Emitter<SocketState> emit) {
    _chatRepository.sendImTypingStop().then((value) {});
    emit(SocketTypingStopState());
  }

  String typingUsers() {
    String typingUsers = "";
    debugPrint(typingUser.length.toString());
    for (int i = 0; i < typingUser.length; i++) {
      typingUsers += ((typingUser[i]).userName ??
          (i + 1 == typingUser.length ? "," : ""));
    }
    debugPrint("UserTyping:$typingUsers");
    return "$typingUsers is typing...";
  }

  bool find(UserTypingModel event) {
    bool res = false;
    for (var element in typingUser) {
      res = event.userName == element.userName;
    }
    return res;
  }

  bool remove(UserTypingStopModel event) {
    for (int i = 0; i < typingUser.length; i++) {
      if (event.userName == typingUser[i].userName) {
        typingUser.removeAt(i);
        return true;
      }
    }
    return false;
  }
}
