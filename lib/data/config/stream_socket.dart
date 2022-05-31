
import 'dart:async';

import '../models/message.dart';

class StreamSocket{
  final _socketResponse= StreamController<BaseMessageModel>();

  void Function(BaseMessageModel) get addResponse => _socketResponse.sink.add;

  Stream<BaseMessageModel> get getResponse => _socketResponse.stream;

  void dispose(){
    _socketResponse.close();
  }
}