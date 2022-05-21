import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:telegram_flutter/core/data/models/login_response.dart';

import '../../config/stream_socket.dart';
import '../../models/message.dart';

class ChatDataSource {

  final Socket socket;
  final StreamSocket streamSocket;
  final Dio dio;

  ChatDataSource(this.dio, this.socket, this.streamSocket);

  Stream<MessageModel> listen() {
    socket.on('new message', (data) {
      debugPrint("new message:$data");
      streamSocket.addResponse.call(Message.fromJson(data));
    });
    socket.on('user joined', (data) {
      debugPrint("user joined:$data");
      streamSocket.addResponse.call(UserJoined.fromJson(data));
    });
    socket.on('typing', (data) {
      debugPrint("typing:$data");
      streamSocket.addResponse.call(UserTyping.fromJson(data));
    });
    socket.on('stop typing', (data) {
      debugPrint("stop typing:$data");
      streamSocket.addResponse.call(UserTypingStop.fromJson(data));
    });
    socket.on('user left', (data) {
      debugPrint("user left:$data");
      streamSocket.addResponse.call(UserLeft.fromJson(data));
    });
    return streamSocket.getResponse;
  }

  Future<bool> sendMessage(String message) {
    try {
      debugPrint("ME:$message");
      socket.emit("new message", message);
      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  }

  Future<bool> sendJoin(String userName) {
    try {
      debugPrint("ME:$userName");
      socket.emit("add user", userName);
      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  }

  Future<LoginResponse> sendLogin(bool createAccount, String userName, String password) async {
    try{
      var response = await dio.post('/login', data: { "username": userName, "password": password, "createAccount": createAccount ? "truee" : "falsee"});
      if (response.statusCode == 200) {
        return LoginResponse.fromJson(response.data);
      } else {
        return LoginResponse(false, "if you are in (Iran, Syria, Cuba, South Korea) make sure VPN connected");
      }
    }catch(e){
      return LoginResponse(false, "if you are in (Iran, Syria, Cuba, South Korea) make sure VPN connected");
    }
  }

  Future<bool> sendLeft() {
    try {
      debugPrint("ME: Disconnect");
      socket.emit("disconnect");
      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  }

  Future<bool> sendTyping() {
    try {
      debugPrint("ME: Typing");
      socket.emit("typing");
      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  }

  Future<bool> sendTypingStop() {
    try {
      debugPrint("ME: Stop typing");
      socket.emit("stop typing");
      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  }

  void disposeAll(Function action){
    socket.onDisconnect((_) {
      debugPrint('onDisconnect');
      action.call();
    });
    socket.disconnect();
    socket.dispose();
    streamSocket.dispose();
  }

  void connectToSocket(Function action){
    socket.onConnect((_) {
      debugPrint('onConnect');
      action.call();
    });
    socket.connect();
  }

  void socketConnecting(Function action){
    socket.onConnecting((_) {
      debugPrint('onConnecting');
      action.call();
    });
  }

  socketConnectionFailed(Function action) {
    socket.onConnectError((_) {
      debugPrint('onConnectError');
      action.call();
    });
    socket.onConnectTimeout((_) {
      debugPrint('onConnectTimeout');
      action.call();
    });
  }

}
