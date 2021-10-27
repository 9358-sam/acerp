import 'package:acerp/common.dart';
import 'package:meta/meta.dart';

abstract class LoginEvent {}

class LoginButtonPressed extends LoginEvent {
  final String id, password;
  final Role role;

  LoginButtonPressed({
    @required this.id,
    @required this.password,
    @required this.role,
  });
}

class LoginReset extends LoginEvent {}
