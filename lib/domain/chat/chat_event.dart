part of 'chat_bloc.dart';

@immutable
abstract class ChatEvent {}
class ChatGetHistoryEvent extends ChatEvent{}

class ChatImageDownloadEvent extends ChatEvent {
  final String imageId;
  ChatImageDownloadEvent(this.imageId);
}

class ChatImageUploadEvent extends ChatEvent {
  final String base64Image;
  ChatImageUploadEvent(this.base64Image);
}
