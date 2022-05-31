
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/socket/socket_bloc.dart';
import '../../domain/user/user_bloc.dart';



extension BlocExt on BuildContext{
  sendImJoined(bool createAccount, String userName, String password){
    read<SocketBloc>().userName = userName;
    read<UserBloc>().add(UserLoginEvent(userName, createAccount, password));
  }
}