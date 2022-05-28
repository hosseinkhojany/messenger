
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/data/models/message.dart';
import '../sharedBloc/socket/socket_bloc.dart';

extension BlocExt on BuildContext{
  sendImTypingEvent(){
    read<SocketBloc>().add(TypingEvent());
  }
  sendImTypingStopEvent(){
    read<SocketBloc>().add(TypingStopEvent());
  }
  sendImLeft(){
    read<SocketBloc>().add(UserLeftEvent());
  }
  sendImJoin(String username){
    read<SocketBloc>().add(UserJoinedEvent(username));
  }
  sendMessage(String message, String messageType){
    read<SocketBloc>().add(SendMessageEvent(message, messageType));
  }
  getTypingUsersList(){
    return read<SocketBloc>().typingUser;
  }
  getTypingUsers(){
    return read<SocketBloc>().typingUsers();
  }
  List<MessageModel> getMessages(){
    return read<SocketBloc>().messages;
  }
}