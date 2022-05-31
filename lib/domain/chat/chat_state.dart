part of 'chat_bloc.dart';

@immutable
abstract class ChatState {}

class Initial extends ChatState {}
class ChatGetHistoryState extends ChatState {}

class ChatImageDownloadingState extends ChatState {}
class ChatImageDownloadedState extends ChatState {
  String? value;
  ChatImageDownloadedState(this.value);
}

class ChatImageUploadingState extends ChatState {}
class ChatImageUploadedState extends ChatState {
  bool success;
  ChatImageUploadedState(this.success);
}
