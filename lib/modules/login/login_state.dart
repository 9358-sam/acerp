import 'package:meta/meta.dart';

abstract class LoginState {}

class LoginLoading extends LoginState {}

class LoginFailure extends LoginState {
  final error;

  LoginFailure({@required this.error});
}

class LoginInit extends LoginState {}
class LoginComplete extends LoginState {}
