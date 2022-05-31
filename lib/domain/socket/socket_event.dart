part of 'socket_bloc.dart';

@immutable
abstract class SocketEvent {}

class SocketConnectedEvent extends SocketEvent{}
class SocketConnectingEvent extends SocketEvent{}
class SocketDisconnectedEvent extends SocketEvent{}
class SocketFailedEvent extends SocketEvent{}
class SocketTypingEvent extends SocketEvent{}
class SocketTypingStopEvent extends SocketEvent{}
class SocketUserJoinedEvent extends SocketEvent{
  final String userName;
  SocketUserJoinedEvent(this.userName);
}
class SocketUserLeftEvent extends SocketEvent{}
class SocketNewMessageReceivedEvent extends SocketEvent{}
class SocketSendMessageEvent extends SocketEvent{
  final String message;
  final String messageType;
  SocketSendMessageEvent(this.message, this.messageType);
}
