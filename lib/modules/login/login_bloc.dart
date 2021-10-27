import 'dart:io';

import 'package:acerp/common.dart';
import 'package:acerp/modules/authentication/authentication.dart';
import 'package:acerp/modules/login/login.dart';

import 'package:acerp/repositories/user_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository userRepository;
  final AuthenticationBloc authenticationBloc;

  LoginBloc({@required this.userRepository, @required this.authenticationBloc});

  @override
  LoginState get initialState => LoginInit();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginButtonPressed) {
      yield LoginLoading();
      try {
        String token = await userRepository.authenticate(
          username: event.id,
          password: event.password,
          role: event.role,
        );
        authenticationBloc.dispatch(LoggedIn(token: token));
        yield LoginInit();
      } catch (error) {
        if (error is SocketException)
          yield LoginFailure(error: 'Network Error. Check your connection');
        else yield LoginFailure(error: error);
      }
    }
    if (event is LoginReset) {
      yield LoginInit();
    }
  }
}
