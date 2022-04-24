import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../config/stream_socket.dart';

class ChatDataSource {
  final Socket socket;
  final StreamSocket streamSocket;

  ChatDataSource(this.socket, this.streamSocket);

  Stream<String> listen() {
    socket.on('chat message', (data) {
      debugPrint("fromServer:" + data);
      streamSocket.addResponse.call(data);
    });
    return streamSocket.getResponse;
  }

  Future<bool> sendMessage(message) {
    try {
      socket.emit("chat message", message);
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
