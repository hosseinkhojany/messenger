import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../../../core/data/repositories/user_repository.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _repository;

  UserBloc(this._repository) : super(InitialState()) {
    on<UserEvent>((event, emit) async {
      switch (event.runtimeType) {
        case UpdateProfileEvent:
          emit(UserProfileState());
          break;
      }
    });
  }
}
