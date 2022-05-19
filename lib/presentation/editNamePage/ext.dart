
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../sharedBloc/socket_bloc.dart';

extension BlocExt on BuildContext{
  sendImJoined(bool createAccount, String userName, String password){
    read<SocketBloc>().add(UserJoinedEvent(createAccount, userName, password));
  }
}