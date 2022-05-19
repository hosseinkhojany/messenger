

import 'package:telegram_flutter/core/data/datasources/remote/chat_datasource.dart';
import 'package:telegram_flutter/core/data/models/login_response.dart';

import '../models/message.dart';

class ChatRepository{

  final ChatDataSource _chatDataSource;
  ChatRepository(this._chatDataSource);

  Stream<MessageModel> listen() => _chatDataSource.listen();
  void socketConnected(Function action) => _chatDataSource.connectToSocket(action);
  void socketConnecting(Function action) => _chatDataSource.socketConnecting(action);
  void socketConnectionFailed(Function action) => _chatDataSource.socketConnectionFailed(action);
  void socketDisconnected(Function action) => _chatDataSource.disposeAll(action);
  Future<bool> sendMessage(String message) => _chatDataSource.sendMessage(message);
  Future<bool> sendImJoined(String userName) => _chatDataSource.sendJoin(userName);
  Future<bool> sendImLeft() => _chatDataSource.sendLeft();
  Future<bool> sendImTyping() => _chatDataSource.sendTyping();
  Future<bool> sendImTypingStop() => _chatDataSource.sendTypingStop();
  Future<LoginResponse> login(bool createAccount, String userName, String password) async => _chatDataSource.sendLogin(createAccount, userName, password);

}