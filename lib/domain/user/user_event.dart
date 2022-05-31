part of 'user_bloc.dart';

@immutable
abstract class UserEvent {}

class UserUpdateProfileEvent extends UserEvent{}
class UserLoginEvent extends UserEvent{
  final String userName;
  final String password;
  final bool createAccount;
  UserLoginEvent(this.userName, this.createAccount, this.password);
}