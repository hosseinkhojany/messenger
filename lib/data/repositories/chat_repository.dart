
import 'package:telegram_flutter/data/datasources/chat_datasource.dart';

class ChatRepository{

  final ChatDataSource _chatDataSource;
  ChatRepository(this._chatDataSource);

  Stream<String> listen() => _chatDataSource.listen();
  void socketConnected(Function action) => _chatDataSource.connectToSocket(action);
  void socketConnecting(Function action) => _chatDataSource.socketConnecting(action);
  void socketConnectionFailed(Function action) => _chatDataSource.socketConnectionFailed(action);
  void socketDisconnected(Function action) => _chatDataSource.disposeAll(action);
  Future<bool> sendMessage(String message) => _chatDataSource.sendMessage(message);

}