
import 'package:get/get.dart';
import 'package:telegram_flutter/data/repositories/chat_repository.dart';
import 'package:telegram_flutter/utils/enums.dart';

class ChatController extends GetxController{

  final ChatRepository _chatRepository;
  ChatController(this._chatRepository);

  RxList<String> rxMessages = <String>[].obs;
  List<String> get messages => rxMessages.toList();

  var socketState = SocketState.none.obs;

  @override
  void onInit() {
    //try to connecting to socket
    _chatRepository.socketConnected((){
      //if connection successfully listen to it
      _chatRepository.listen().listen((event) {
        rxMessages.add(event);
        update();
      },);
      socketState.value = SocketState.connected;
    });
    _chatRepository.socketConnecting((){socketState.value = SocketState.connecting;});
    _chatRepository.socketConnectionFailed((){socketState.value = SocketState.failed;});
    super.onInit();
  }

  @override
  void dispose() {
    _chatRepository.socketDisconnected((){});
    super.dispose();
  }

  sendMessage(String message){
    _chatRepository.sendMessage(message).then((value) => {
      if(!value){
        Get.showSnackbar(const GetSnackBar(message: "try again",))
      }
    });
  }


}