
import 'package:telegram_flutter/data/datasources/chat_datasource.dart';

class ChatRepository{

  final ChatDataSource _chatDataSource;
  ChatRepository(this._chatDataSource);

  Stream<String> listen() => _chatDataSource.listen();
  void socketConnect() => _chatDataSource.socket.connect();
  void socketDisconnect() => _chatDataSource.socket.disconnect();
  Future<bool> sendMessage(String message) => _chatDataSource.sendMessage(message);

}