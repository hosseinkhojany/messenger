
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/message.dart';
import '../../domain/chat/chat_bloc.dart';
import '../../domain/socket/socket_bloc.dart';

extension BlocExt on BuildContext{
  //SocketBloc-------------------------
  sendImTypingEvent(){
    read<SocketBloc>().add(SocketTypingEvent());
  }
  sendImTypingStopEvent(){
    read<SocketBloc>().add(SocketTypingStopEvent());
  }
  sendImLeft(){
    read<SocketBloc>().add(SocketUserLeftEvent());
  }
  sendImJoin(String username){
    read<SocketBloc>().add(SocketUserJoinedEvent(username));
  }
  sendMessage(String message, String messageType){
    read<SocketBloc>().add(SocketSendMessageEvent(message, messageType));
  }
  getTypingUsersList(){
    return read<SocketBloc>().typingUser;
  }
  getTypingUsers(){
    return read<SocketBloc>().typingUsers();
  }
  //ChatBloc--------------------------------
  getHistory(){
    read<ChatBloc>().add(ChatGetHistoryEvent());
  }
  List<BaseMessageModel> getMessages(){
    return read<ChatBloc>().messages();
  }
  sendImage(String base64Image){
    read<ChatBloc>().add(ChatImageUploadEvent(base64Image));
  }
}