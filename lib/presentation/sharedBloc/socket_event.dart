part of 'socket_bloc.dart';

@immutable
abstract class SocketEvent {}

class ConnectedEvent extends SocketEvent{}
class ConnectingEvent extends SocketEvent{}
class DisconnectedEvent extends SocketEvent{}
class FailedEvent extends SocketEvent{}
class TypingEvent extends SocketEvent{}
class TypingStopEvent extends SocketEvent{}
class UserJoinedEvent extends SocketEvent{
  final String userName;
  final String? password;
  final bool? createAccount;
  UserJoinedEvent(this.userName, {this.createAccount, this.password});
}
class UserLeftEvent extends SocketEvent{}
class NewMessageReceivedEvent extends SocketEvent{}
class SendMessageEvent extends SocketEvent{
  final String message;
  SendMessageEvent(this.message);
}
