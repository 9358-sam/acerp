import 'package:acerp/modules/authentication/authentication_event.dart';
import 'package:acerp/modules/authentication/authentication_state.dart';
import 'package:acerp/repositories/user_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  UserRepository userRepository;

  AuthenticationBloc({@required this.userRepository});

  @override
  AuthenticationState get initialState => AuthenticationUninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    if (event is AppStarted) {
      final bool hasToken = await userRepository.hasToken();
      if (hasToken) {
//        yield AuthenticationAuthenticated();
        // Check if timeStamp timeout has occurred
        try {
          const int logoutThreshold = 12 * 60 * 60;
          DateTime lastLogin = await userRepository.getTimeStamp();
          DateTime now = DateTime.now();
          Duration timeDifference = now.difference(lastLogin);
          print(timeDifference.inSeconds);
          //TODO Remove this condition
          if(timeDifference.inSeconds > logoutThreshold) {
//          if(false) {
            await userRepository.deleteToken();
            yield AuthenticationUnauthenticated();
          }
          else {
            yield AuthenticationAuthenticated();
          }
        } catch (e) {
          // TODO Flip the state
//          yield AuthenticationAuthenticated();
          yield AuthenticationUnauthenticated();
          print(e);
        }
      } else
        yield AuthenticationUnauthenticated();
    }

    if (event is LoggedIn) {
      yield AuthenticationLoading();
      await userRepository.persistToken(event.token);
      await userRepository.setTimeStamp();
      yield AuthenticationAuthenticated();
    }

    if (event is LoggedOut) {
      yield AuthenticationLoading();
      await userRepository.deleteToken();
      yield AuthenticationUnauthenticated();
    }
  }
}
