import 'dart:async';
import 'package:dio/dio.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../../models/base_model.dart';


class UserDataSource {

  final Socket socket;
  final Dio dio;

  UserDataSource(this.dio, this.socket);

  Future<BaseModel> sendLogin(bool createAccount, String userName, String password) async {
    try{
      var response = await dio.post('/login', data: { "username": userName, "password": password, "createAccount": createAccount ? "truee" : "falsee"});
      if (response.statusCode == 200) {
        return BaseModel.fromJson(response.data);
      } else {
        return BaseModel(false, "if you are in (Iran, Syria, Cuba, South Korea) make sure VPN connected");
      }
    }catch(e){
      return BaseModel(false, "if you are in (Iran, Syria, Cuba, South Korea) make sure VPN connected");
    }
  }


  Future<BaseModel> sendUpdateProfile(String userName, String avatar) async {
    try{
      var response = await dio.post('/login', data: { "username": userName, "avatar": avatar});
      if (response.statusCode == 200) {
        return BaseModel.fromJson(response.data);
      } else {
        return BaseModel(false, "if you are in (Iran, Syria, Cuba, South Korea) make sure VPN connected");
      }
    }catch(e){
      return BaseModel(false, "if you are in (Iran, Syria, Cuba, South Korea) make sure VPN connected");
    }
  }


}
