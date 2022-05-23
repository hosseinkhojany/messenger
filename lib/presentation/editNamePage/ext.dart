
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../sharedBloc/socket/socket_bloc.dart';


extension BlocExt on BuildContext{
  sendImJoined(bool createAccount, String userName, String password){
    read<SocketBloc>().userName = userName;
    read<SocketBloc>().add(UserJoinedEvent(userName, createAccount: createAccount,password: password));
  }
}