import '../datasources/remote/chat_datasource.dart';
import '../models/message.dart';

class ChatRepository{


  List<BaseMessageModel> messages = [];
  List<BaseMessageModel> history_messages = [];

  void addMessage(BaseMessageModel message){
    List<BaseMessageModel> result = [];
    result.add(message);
    result.addAll(messages);
    messages = result;
  }

  void addHistoryMessages(List<BaseMessageModel> message){
    messages.addAll(message);
  }

  final ChatDataSource _chatDataSource;
  ChatRepository(this._chatDataSource);

  Stream<BaseMessageModel> listen() => _chatDataSource.listen();
  void socketConnected(Function action) => _chatDataSource.connectToSocket(action);
  void socketConnecting(Function action) => _chatDataSource.socketConnecting(action);
  void socketConnectionFailed(Function action) => _chatDataSource.socketConnectionFailed(action);
  void socketDisconnected(Function action) => _chatDataSource.disposeAll(action);
  Future<bool> sendMessage(String message, String messageType) => _chatDataSource.sendMessage(message, messageType);
  Future<bool> sendImJoined(String userName) => _chatDataSource.sendJoin(userName);
  Future<bool> sendImLeft() => _chatDataSource.sendLeft();
  Future<bool> sendImTyping() => _chatDataSource.sendTyping();
  Future<bool> sendImTypingStop() => _chatDataSource.sendTypingStop();
  Future<List<BaseMessageModel>?> getHistory(int page) => _chatDataSource.getHistory(page);
  Future<String?> downloadImage(String id) async => await _chatDataSource.downloadImage(id);
  Future<bool> uploadImage(String base64Image) async => await _chatDataSource.uploadImage(base64Image);

}