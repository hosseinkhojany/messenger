
import 'package:get/get.dart';
import 'package:telegram_flutter/data/repositories/chat_repository.dart';

class ChatController extends GetxController{

  final ChatRepository _chatRepository;
  ChatController(this._chatRepository);

  Stream<String> chatStream() => _chatRepository.listen();

  @override
  void onInit() {
    _chatRepository.socketConnect();
    super.onInit();
  }

  @override
  void dispose() {
    _chatRepository.socketDisconnect();
    super.dispose();
  }

  sendMessage(String message){
    _chatRepository.sendMessage(message).then((value) => {
      if(!value){
        Get.showSnackbar(GetSnackBar(message: "try again",))
      }
    });
  }


}