
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:telegram_flutter/presentation/sharedBloc/socket_bloc.dart';

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
  sendMessage(String message){
    read<SocketBloc>().add(SendMessageEvent(message));
  }
  getTypingUsersList(){
    return read<SocketBloc>().typingUser;
  }
  getTypingUsers(){
    return read<SocketBloc>().typingUsers();
  }
  getMessages(){
    return read<SocketBloc>().messages;
  }
}