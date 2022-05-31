part of 'socket_bloc.dart';

@immutable
abstract class SocketState {}

class SocketConnectingState extends SocketState {}
class SocketFailedState extends SocketState {}
class SocketConnectedState extends SocketState {}
class SocketDisconnectedState extends SocketState {}
class SocketNewMessageState extends SocketState {}
class SocketTypingState extends SocketState {}
class SocketTypingStopState extends SocketState {}
class SocketUserJoinedState extends SocketState {}
class SocketUserLeftState extends SocketState {}
