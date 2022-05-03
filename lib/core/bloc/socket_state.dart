part of 'socket_bloc.dart';

@immutable
abstract class SocketState {}

class SocketConnecting extends SocketState {}
class SocketConnected extends SocketState {}
class SocketDisconnected extends SocketState {}
class SocketNewMessage extends SocketState {}
