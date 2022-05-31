
import '../datasources/remote/user_datasource.dart';
import '../models/base_model.dart';

class UserRepository{

  final UserDataSource _chatDataSource;
  UserRepository(this._chatDataSource);

  Future<BaseModel> login(bool createAccount, String userName, String password) async => _chatDataSource.sendLogin(createAccount, userName, password);
  Future<BaseModel> updateProfile(String userName, String avatar) async => _chatDataSource.sendUpdateProfile(userName, avatar);

}