import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../data/models/message.dart';
import '../../data/repositories/chat_repository.dart';

part 'chat_event.dart';

part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository _chatRepository;

  int page = 0;

  ChatBloc(this._chatRepository) : super(Initial()) {
    on<ChatEvent>((event, emit) async {
      switch (event.runtimeType) {
        case ChatGetHistoryEvent:
          getHistory(emit);
          break;
        case ChatImageDownloadEvent:
          await downloadImage((event as ChatImageDownloadEvent).imageId, emit);
          break;
        case ChatImageUploadEvent:
          await uploadImage((event as ChatImageUploadEvent).base64Image, emit);
          break;
      }
    });
  }

  getHistory(Emitter<ChatState> emit) {
    debugPrint(page.toString());
    _chatRepository.getHistory(++page).then((value) {
      if (value?.isNotEmpty == true) {
        _chatRepository.addHistoryMessages(value!);
        emit(ChatGetHistoryState());
      }
    });
  }

  List<BaseMessageModel> messages() => _chatRepository.messages;

  downloadImage(String imageId, Emitter<ChatState> emit) async {
    emit(ChatImageDownloadingState());
    await _chatRepository.downloadImage(imageId).then(
          (value) => {
            emit(ChatImageDownloadedState(value)),
          },
        );
  }

  uploadImage(String base64Image, Emitter<ChatState> emit) async {
    emit(ChatImageDownloadingState());
    await _chatRepository.uploadImage(base64Image).then(
          (value) => {
            emit(ChatImageUploadedState(value)),
          },
        );
  }
}
