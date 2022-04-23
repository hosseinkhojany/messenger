import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';
import 'package:telegram_flutter/controller/chat_controller.dart';
import 'package:telegram_flutter/data/config/stream_socket.dart';
import 'package:telegram_flutter/data/datasources/chat_datasource.dart';
import 'package:telegram_flutter/data/repositories/chat_repository.dart';

class AppBindings extends Bindings {
  // Dio _dio() {
  //   final options = BaseOptions(
  //     baseUrl: "",
  //     connectTimeout: 10000,
  //     receiveTimeout: 10000,
  //     sendTimeout: 10000,
  //   );
  //
  //   var dio = Dio(options);
  //   dio.interceptors.add(LoggingInterceptor());
  //   return dio;
  // }

  Socket socket = IO.io(
      'http://localhost:3000',
      OptionBuilder()
          .setTimeout(30 * 1000)
          .setTransports(['websocket'])
          // .setExtraHeaders({'foo': 'bar'})
          .disableAutoConnect()
          .build());

  StreamSocket streamSocket = StreamSocket();

  @override
  void dependencies() {
    initThings();
    initControllers();
  }

  initThings() {}

  initControllers() {
    Get.lazyPut(
      () => ChatController(
        ChatRepository(
          ChatDataSource(
            socket,
            streamSocket,
          ),
        ),
      ),
    );

  }
}
