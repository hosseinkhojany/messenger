import 'package:telegram_flutter/core/data/datasources/remote/user_datasource.dart';
import 'package:telegram_flutter/core/data/models/base_model.dart';


class UserRepository{

  final UserDataSource _chatDataSource;
  UserRepository(this._chatDataSource);

  Future<BaseModel> login(bool createAccount, String userName, String password) async => _chatDataSource.sendLogin(createAccount, userName, password);
  Future<BaseModel> updateProfile(String userName, String avatar) async => _chatDataSource.sendUpdateProfile(userName, avatar);

}