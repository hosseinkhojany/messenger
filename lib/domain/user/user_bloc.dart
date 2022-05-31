import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../data/datasources/local/sharedStore.dart';
import '../../data/models/message.dart';
import '../../data/repositories/chat_repository.dart';
import '../../data/repositories/user_repository.dart';
import '../../presentation/globalWidgets/app_snackbar.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _userRepository;
  final ChatRepository _chatRepository;


  UserBloc(this._userRepository, this._chatRepository) : super(InitialState()) {
    on<UserEvent>((event, emit) async {
      switch (event.runtimeType) {
        case UserUpdateProfileEvent:
          emit(UserProfileState());
          break;
        case UserLoginEvent:
          await login((event as UserLoginEvent).createAccount, event.userName, event.password, emit);
          break;
      }
    });
  }

  bool isSignedIn = false;
  bool loginLoading = false;

  login(bool createAccount, String userName, String password, Emitter<UserState> emit) async {
    if(!isSignedIn && !loginLoading){
      loginLoading = true;
      emit(UserLoginState(false, true));
      await _userRepository.login(createAccount, userName, password).then((response) async {
        if (response.success) {
          UserJoinedModel inProcessMessage = UserJoinedModel(userName: userName, my: true);
          await _chatRepository.sendImJoined(userName).then((value) {
            if (!value) {
              AppSnackBar.show("if you are in (Iran, Syria, Cuba, South Korea) make sure VPN connected");
              emit(UserLoginState(false, false));
              isSignedIn = false;
              loginLoading = false;
            } else {
              AppSnackBar.show(response.message);
              _chatRepository.addMessage(inProcessMessage);
              emit(UserLoginState(true, false));
              isSignedIn = true;
              loginLoading = false;
            }
          });
        } else {
          AppSnackBar.show(response.message);
          emit(UserLoginState(false, false));
          SharedStore.setUserName(userName);
          isSignedIn = false;
          loginLoading = false;
        }
      });
    }
  }

}
