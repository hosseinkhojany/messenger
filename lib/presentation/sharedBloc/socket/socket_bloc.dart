import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:telegram_flutter/core/data/models/message.dart';
import 'package:telegram_flutter/core/data/repositories/chat_repository.dart';
import 'package:telegram_flutter/core/data/repositories/user_repository.dart';
import 'package:telegram_flutter/presentation/globalWidgets/app_snackbar.dart';

import '../../../core/data/datasources/local/sharedStore.dart';

part 'socket_event.dart';
part 'socket_state.dart';

class SocketBloc extends Bloc<SocketEvent, SocketState> {
  final ChatRepository _chatRepository;
  final UserRepository _userRepository;

  List<MessageModel> messages = [];
  List<MessageModel> history_messages = [];
  List<UserTyping> typingUser = [];

  late DateTime lastTypingTime;
  bool connected = false;
  bool typing = false;
  int typingTimerLength = 400;

  String userName = "";

  int page = 0;

  SocketBloc(this._chatRepository, this._userRepository) : super(SocketConnectedState()) {
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
            addMessage(event);
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
          sendMessage((event as SendMessageEvent).message,(event).messageType, emit);
          break;
        case NewMessageReceivedEvent:
          emit(SocketNewMessageState());
          break;
        case GetHistoryEvent:
          getHistory(emit);
          break;
      }
    });
  }

  sendMessage(String message,String messageType, Emitter<SocketState> emit) {
    Message inProcessMessage =
        Message(userName: userName, message: message,messageType: messageType, my: true);
    _chatRepository.sendMessage(message, messageType).then((value) {
      if (!value) {
        AppSnackBar.show("if you are in (Iran, Syria, Cuba, South Korea) make sure VPN connected");
      } else {
        addMessage(inProcessMessage);
        emit(SocketNewMessageState());
      }
    });
  }


  getHistory(Emitter<SocketState> emit) {
    debugPrint(page.toString());
    _chatRepository.getHistory(++page).then((value) {
      if (value?.isNotEmpty == true) {
        addHistoryMessages(value!);
        emit(SocketNewMessageState());
      }
    });
  }

  bool isSignedIn = false;
  bool loginLoading = false;

  sendLoginAndJoin(bool createAccount, String userName, String password, Emitter<SocketState> emit) async {
    if(!isSignedIn && !loginLoading){
      loginLoading = true;
      emit(UserJoinedState(false, true));
      await _userRepository.login(createAccount, userName, password).then((response) async {
        if (response.success) {
          UserJoined inProcessMessage = UserJoined(userName: userName, my: true);
          await _chatRepository.sendImJoined(userName).then((value) {
            if (!value) {
              AppSnackBar.show("if you are in (Iran, Syria, Cuba, South Korea) make sure VPN connected");
              emit(UserJoinedState(false, false));
              isSignedIn = false;
              loginLoading = false;
            } else {
              AppSnackBar.show(response.message);
              addMessage(inProcessMessage);
              emit(UserJoinedState(true, false));
              isSignedIn = true;
              loginLoading = false;
            }
          });
        } else {
          AppSnackBar.show(response.message);
          emit(UserJoinedState(false, false));
          SharedStore.setUserName(userName);
          isSignedIn = false;
          loginLoading = false;
        }
      });
    }
  }

  sendImJoin(String userName, Emitter<SocketState> emit) async {
    if(!isSignedIn && !loginLoading){
      loginLoading = true;
      emit(UserJoinedState(false, true));
      UserJoined inProcessMessage = UserJoined(userName: userName, my: true);
      await _chatRepository.sendImJoined(userName).then((value) {
        if (!value) {
          AppSnackBar.show("if you are in (Iran, Syria, Cuba, South Korea) make sure VPN connected");
          emit(UserJoinedState(false, false));
          isSignedIn = false;
          loginLoading = false;
        } else {
          addMessage(inProcessMessage);
          emit(UserJoinedState(true, false));
          SharedStore.setUserName(userName);
          isSignedIn = true;
          loginLoading = false;
        }
      });
    }
  }

  sendImLeft(Emitter<SocketState> emit) {
    UserLeft inProcessMessage = UserLeft(userName: userName, my: true);
    _chatRepository.sendImLeft().then((value) {
      if (!value) {
        AppSnackBar.show("if you are in (Iran, Syria, Cuba, South Korea) make sure VPN connected");
      } else {
        addMessage(inProcessMessage);
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

  void addMessage(MessageModel message){
    List<MessageModel> result = [];
    result.add(message);
    result.addAll(messages);
    messages = result;
  }

  void addHistoryMessages(List<MessageModel> message){
    messages.addAll(message);
  }

}
