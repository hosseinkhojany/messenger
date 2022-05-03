part of 'socket_bloc.dart';

@immutable
abstract class SocketEvent {}

class Typing extends SocketEvent{}
class TypingStop extends SocketEvent{}
class SendMessage extends SocketEvent{}
