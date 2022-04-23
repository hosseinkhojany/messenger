import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../config/stream_socket.dart';

class ChatDataSource {
  final Socket socket;
  final StreamSocket streamSocket;

  ChatDataSource(this.socket, this.streamSocket);

  Stream<String> listen() {
    socket.onConnect((_) {
      print('connected');
      socket.emit('msg', 'test');
    });
    socket.on('chat message', (data) {
      debugPrint("fromServer:" + data);
      streamSocket.addResponse.call(data);
    });
    socket.onDisconnect((_) => print('disconnect'));
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
}
