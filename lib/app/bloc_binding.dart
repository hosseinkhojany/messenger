import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';
import 'package:telegram_flutter/core/data/config/stream_socket.dart';
import 'package:telegram_flutter/core/data/datasources/remote/chat_datasource.dart';
import 'package:telegram_flutter/core/data/datasources/remote/user_datasource.dart';
import 'package:telegram_flutter/core/data/repositories/chat_repository.dart';
import 'package:telegram_flutter/core/data/repositories/user_repository.dart';
import 'package:telegram_flutter/presentation/sharedBloc/user/user_bloc.dart';

import '../core/data/config/logging_interceptor.dart';
import '../presentation/sharedBloc/socket/socket_bloc.dart';

class AppBindingsBloc extends StatelessWidget {
  final Widget child;
  late Dio dio;

  void _dio() {
    final options = BaseOptions(
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Authorization': 'Bearer abcdxyz',
        'Content-Type': 'application/json',
        "Access-Control-Allow-Credentials": true, 
        "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
        "Access-Control-Allow-Methods": "POST, OPTIONS"
      },
      baseUrl: "https://commander009.herokuapp.com",
      // baseUrl: "http://localhost:3000",
      connectTimeout: 10000,
      receiveTimeout: 10000,
      sendTimeout: 10000,
    );

    var dios = Dio(options);
    dios.interceptors.add(LoggingInterceptor());
    dio = dios;
  }

  Socket socket = IO.io(
      'https://commander009.herokuapp.com/',
      // "http://localhost:3000",
      OptionBuilder()
          .setTimeout(30 * 1000)
          .setTransports(['websocket'])
          // .setExtraHeaders({'foo': 'bar'})
          .disableAutoConnect()
          .build());

  StreamSocket streamSocket = StreamSocket();

  AppBindingsBloc({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _dio();
    UserRepository userRepository = UserRepository(UserDataSource(dio, socket));
    return MultiBlocProvider(providers: [
      BlocProvider(
        create: (context) {
          return SocketBloc(ChatRepository(ChatDataSource(dio, socket, streamSocket)), userRepository);
        },
      ),
      BlocProvider(
        create: (context) {
          return UserBloc(userRepository);
        },
      ),
    ], child: child);
  }
}
