import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:telegram_flutter/core/data/models/message.dart';
import 'package:telegram_flutter/presentation/globalWidgets/app_snackbar.dart';

import '../../core/data/repositories/chat_repository.dart';

part 'socket_event.dart';

part 'socket_state.dart';

class SocketBloc extends Bloc<SocketEvent, SocketState> {
  final ChatRepository _chatRepository;

  List<MessageModel> messages = [];
  List<UserTyping> typingUser = [];

  late DateTime lastTypingTime;
  bool connected = false;
  bool typing = false;
  int typingTimerLength = 400;

  String userName = "";

  SocketBloc(this._chatRepository) : super(SocketConnectedState()) {
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
          add(NewMessageReceivedEvent());
        },
      );
      connected = true;
      add(ConnectedEvent());
    });
    _chatRepository.socketConnecting(() {
      add(ConnectingEvent());
      connected = false;
    });
    _chatRepository.socketConnectionFailed(() {
      add(FailedEvent());
      connected = false;
    });
    on<SocketEvent>((event, emit) async {
      switch (event.runtimeType) {
        case ConnectedEvent:
          emit(SocketConnectedState());
          break;
        case ConnectingEvent:
          emit(SocketConnectedState());
          break;
        case DisconnectedEvent:
          emit(SocketDisconnectedState());
          break;
        case FailedEvent:
          emit(SocketFailedState());
          break;
        case TypingEvent:
          await sendImTyping(emit);
          break;
        case TypingStopEvent:
          sendImStopTyping(emit);
          break;
        case UserJoinedEvent:
          if((event as UserJoinedEvent).createAccount == null){
            //join request
            await sendImJoin((event).userName, emit);
          }else{
          // login&join request
            await sendLoginAndJoin((event).createAccount ?? false, (event).userName, (event).password ?? "", emit);
          }  
          break;
        case UserLeftEvent:
          sendImLeft(emit);
          break;
        case SendMessageEvent:
          sendMessage((event as SendMessageEvent).message, emit);
          break;
        case NewMessageReceivedEvent:
          emit(SocketNewMessageState());
          break;
      }
    });
  }

  sendMessage(String message, Emitter<SocketState> emit) {
    Message inProcessMessage =
        Message(userName: userName, message: message, my: true);
    _chatRepository.sendMessage(message).then((value) {
      if (!value) {
        AppSnackBar.show("try again");
      } else {
        messages.add(inProcessMessage);
        emit(SocketNewMessageState());
      }
    });
  }

  sendLoginAndJoin(bool createAccount, String userName, String password, Emitter<SocketState> emit) async {
    emit(UserJoinedState(false, true));
    await _chatRepository.login(createAccount, userName, password).then((response) async {
      if (response.success) {
        UserJoined inProcessMessage = UserJoined(userName: userName, my: true);
        await _chatRepository.sendImJoined(userName).then((value) {
          if (!value) {
            AppSnackBar.show("try again");
            emit(UserJoinedState(false, false));
          } else {
            AppSnackBar.show(response.message);
            messages.add(inProcessMessage);
            emit(UserJoinedState(true, false));
          }
        });
      } else {
        AppSnackBar.show(response.message);
        emit(UserJoinedState(false, false));
      }
    });
  }

  sendImJoin(String userName, Emitter<SocketState> emit) async {
    emit(UserJoinedState(false, true));
    UserJoined inProcessMessage = UserJoined(userName: userName, my: true);
    await _chatRepository.sendImJoined(userName).then((value) {
      if (!value) {
        AppSnackBar.show("try again");
        emit(UserJoinedState(false, false));
      } else {
        messages.add(inProcessMessage);
        emit(UserJoinedState(true, false));
      }
    });
  }

  sendImLeft(Emitter<SocketState> emit) {
    UserLeft inProcessMessage = UserLeft(userName: userName, my: true);
    _chatRepository.sendImLeft().then((value) {
      if (!value) {
        AppSnackBar.show("try again");
      } else {
        messages.add(inProcessMessage);
        emit(UserLeftState());
      }
    });
  }

  sendImTyping(Emitter<SocketState> emit) async {
    if (connected) {
      if (!typing) {
        typing = true;
        _chatRepository.sendImTyping().then((value) {});
        emit(TypingState());
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
          emit(TypingStopState());
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
    emit(TypingStopState());
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
