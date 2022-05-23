part of 'socket_bloc.dart';

@immutable
abstract class SocketState {}

class SocketConnectingState extends SocketState {}
class SocketFailedState extends SocketState {}
class SocketConnectedState extends SocketState {}
class SocketDisconnectedState extends SocketState {}
class SocketNewMessageState extends SocketState {}
class TypingState extends SocketState {}
class TypingStopState extends SocketState {}
class UserJoinedState extends SocketState {
  bool success;
  bool loading;
  UserJoinedState(this.success, this.loading): super();
}
class UserLeftState extends SocketState {}
