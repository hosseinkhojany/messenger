import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../data/repositories/chat_repository.dart';

part 'socket_event.dart';
part 'socket_state.dart';

class SocketBloc extends Bloc<SocketEvent, SocketState> {
  final ChatRepository _chatRepository;


  SocketBloc(this._chatRepository) : super(SocketConnecting()) {
    on<SocketEvent>((event, emit) {
      switch(event.runtimeType){
        case Typing:
          _chatRepository.sendImTyping();
          break;
        case TypingStop:
          _chatRepository.sendImTypingStop();
          break;
        case SendMessage:
          _chatRepository.sendMessage("");
          break;
      }
    });
  }
}
