// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:flutter_clean_architecture/core/common/entities/user.dart';
import 'package:flutter_clean_architecture/core/usecase/usecase.dart';
import 'package:flutter_clean_architecture/features/auth/domain/usecases/current_user.dart';
import 'package:flutter_clean_architecture/features/auth/domain/usecases/user_login.dart';
import 'package:flutter_clean_architecture/features/auth/domain/usecases/user_sigh_up.dart';

// import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserLogin _userLogin;
  final CurrentUser _currentUser;
  final AppUserCubit _appUserCubit;
  AuthBloc({
    required UserSignUp userSignUp,
    required UserLogin userLogin,
    required CurrentUser currentUser,
    required AppUserCubit appUserCubit,
  })  : _userSignUp = userSignUp,
        _userLogin = userLogin,
        _currentUser = currentUser,
        _appUserCubit = appUserCubit,
        super(AuthInitial()) {
    on<AuthEvent>((_, emit) => emit(AuthLoading()));
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthLogin>(_onAuthLogin);
    on<AuthIsUserLoggedIn>(_isUserLoggedIn);
  }

  //function to get auth user session
  void _isUserLoggedIn(
    AuthIsUserLoggedIn event,
    Emitter<AuthState> emmit,
  ) async {
    final result = await _currentUser(NoParams());
    result.fold(
        (l) => emit(
              AuthFailure(l.message),
            ),
        (r) => _emitAuthSuccess(r, emmit));
  }

  //function of signup
  void _onAuthSignUp(
    AuthSignUp event,
    Emitter<AuthState> emit,
  ) async {
    debugPrint(
        "User ifno  in bloc ${event.name}, ${event.email} ${event.password}");
    final res = await _userSignUp(
      UserSignUpParams(
        name: event.name,
        email: event.email,
        password: event.password,
      ),
    );
    res.fold((failure) => emit(AuthFailure(failure.message)),
        (user) => _emitAuthSuccess(user, emit));
  }

  //function of login
  void _onAuthLogin(
    AuthLogin event,
    Emitter<AuthState> emit,
  ) async {
    debugPrint("User ifno  in bloc  ${event.email} ${event.password}");
    final res = await _userLogin(
      UserLoginParams(
        email: event.email,
        password: event.password,
      ),
    );
    debugPrint("respons form backend ----${AuthFailure(res.toString())}");
    res.fold(
        (l) => emit(AuthFailure(l.message)), (r) => _emitAuthSuccess(r, emit));
  }

  //
  void _emitAuthSuccess(
    User user,
    Emitter<AuthState> emit,
  ) {
    _appUserCubit.updateUser(user);
    emit(AuthSuccess(user));
  }
}
