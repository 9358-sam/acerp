import 'package:acerp/common.dart' show AcBlue;
import 'package:acerp/modules/authentication/authentication.dart';
import 'package:acerp/modules/login/login.dart';
import 'package:acerp/modules/stf_profile/stf_profile.dart'
    show StfProfileBloc, StaffHomeScreen;
import 'package:acerp/repositories/repository.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'modules/stf_attendance/stf_attendance.dart' show StfAttendanceBloc;
import 'modules/stf_leave/stf_leave_provider.dart';
import 'modules/stf_punching/stf_punching.dart' show StfPunchingBloc;
import 'modules/stf_swap/stf_swap_bloc.dart';
import 'modules/stf_timetable/stf_timetable.dart' show StfTimetableBloc;


//const URL_prod = 'KEEP YOUR PRODUCTION URL';


// USE ANY ONE OF URL PROD OR DEV.


//const URL_dev = 'KEEP YOUR DEVELOPMENT URL';


const URL = URL_prod;

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print('$bloc:::$transition');
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    print('$bloc:::$error');
  }
}

class RepoProvider extends InheritedWidget {
  final UserRepository userRepository;
  final StaffRepository staffRepository;

  RepoProvider({
    Key key,
    @required this.userRepository,
    @required this.staffRepository,
    @required Widget child,
  }) : super(key: key, child: child);

  RepoProvider of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(RepoProvider) as RepoProvider;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
}

void main() {
//  BlocSupervisor().delegate = SimpleBlocDelegate();
  return runApp(MyApp(
    userRepository: UserRepository(url: URL),
    staffRepository: StaffRepository(url: URL),
  ));
}

class MyApp extends StatefulWidget {
  final UserRepository userRepository;
  final StaffRepository staffRepository;

  MyApp(
      {Key key, @required this.userRepository, @required this.staffRepository})
      : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AuthenticationBloc _authenticationBloc;
  LoginBloc _loginBloc;
  StfProfileBloc _stfProfileBloc;
  StfTimetableBloc _stfTimetableBloc;
  StfAttendanceBloc _stfAttendanceBloc;
  StfPunchingBloc _stfPunchingBloc;
  StfSwapBloc _stfSwapBloc;

  UserRepository get _userRepository => widget.userRepository;

  StaffRepository get _staffRepository => widget.staffRepository;

  @override
  void initState() {
    super.initState();
    _authenticationBloc = AuthenticationBloc(
      userRepository: _userRepository,
    );
    _loginBloc = LoginBloc(
      userRepository: _userRepository,
      authenticationBloc: _authenticationBloc,
    );
    _stfProfileBloc = StfProfileBloc(
      userRepository: _userRepository,
      staffRepository: _staffRepository,
    );
    _stfTimetableBloc = StfTimetableBloc(
      userRepository: _userRepository,
      staffRepository: _staffRepository,
    );
    _stfAttendanceBloc = StfAttendanceBloc(
      userRepository: _userRepository,
      staffRepository: _staffRepository,
    );
    _stfPunchingBloc = StfPunchingBloc(
      userRepository: _userRepository,
      staffRepository: _staffRepository,
    );
    _stfSwapBloc = StfSwapBloc(
      userRepository: _userRepository,
      stfRepository: _staffRepository,
    );
    _authenticationBloc.dispatch(AppStarted());
  }

  @override
  void dispose() {
    super.dispose();
    _authenticationBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepoProvider(
      staffRepository: _staffRepository,
      userRepository: _userRepository,
      child: BlocProviderTree(
        blocProviders: [
          BlocProvider<LoginBloc>(
            bloc: _loginBloc,
          ),
          BlocProvider<AuthenticationBloc>(
            bloc: _authenticationBloc,
          ),
          BlocProvider<StfProfileBloc>(
            bloc: _stfProfileBloc,
          ),
          BlocProvider<StfTimetableBloc>(
            bloc: _stfTimetableBloc,
          ),
          BlocProvider<StfAttendanceBloc>(
            bloc: _stfAttendanceBloc,
          ),
          BlocProvider<StfPunchingBloc>(
            bloc: _stfPunchingBloc,
          ),
          BlocProvider<StfSwapBloc>(
            bloc: _stfSwapBloc,
          )
        ],
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider<StfLeaveProvider>(
              builder: (BuildContext context) => StfLeaveProvider(_staffRepository, _userRepository),
            )
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
                accentColor: Colors.orange,
                primaryColor: AcBlue,
                scaffoldBackgroundColor: Color(0xFFf2f3f8),
                fontFamily: 'SFPro'),
            home: BlocBuilder(
              bloc: _authenticationBloc,
              // ignore: missing_return
              builder: (BuildContext context, AuthenticationState state) {
                print('STATE =>> $state');
                if (state is AuthenticationUninitialized)
                  return Scaffold(
                    body: Center(
                      child: Image.asset(
                       // 'KEEP IMAGE HERE',
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                if (state is AuthenticationUnauthenticated)
                  return LoginScreen(
                    loginBloc: LoginBloc(
                      userRepository: _userRepository,
                      authenticationBloc: _authenticationBloc,
                    ),
                  );
                if (state is AuthenticationAuthenticated)
                  return StaffHomeScreen();
                if (state is AuthenticationLoading)
                  return Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
              },
            ),
          ),
        ),
      ),
    );
  }
}
