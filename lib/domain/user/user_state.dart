part of 'user_bloc.dart';

@immutable
abstract class UserState {}

class InitialState extends UserState {}
class UserProfileState extends UserState {}
class UserLoginState extends UserState {
  bool success;
  bool loading;
  UserLoginState(this.success, this.loading);
}
