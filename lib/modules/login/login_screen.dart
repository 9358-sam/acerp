import 'dart:ui';

import 'package:acerp/common.dart';
import 'package:acerp/modules/login/login.dart';
import 'package:acerp/widgets/animations.dart';
import 'package:acerp/widgets/custom_alert_dialog.dart'
    show CustomAlertDialog, ErrorDialog;

import 'package:acerp/widgets/ensure_visible.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends StatefulWidget {
  final isTemporary;

  final LoginBloc loginBloc;

  LoginScreen({@required this.loginBloc, this.isTemporary = false}) ;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 411, height: 832)..init(context);
    return Scaffold(
      body: BlocBuilder<LoginEvent, LoginState>(
        bloc: BlocProvider.of<LoginBloc>(context),
        builder: (BuildContext context, LoginState state) {
          if (state is LoginFailure) {
            _onWidgetDidBuild(
              () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => CustomAlertDialog(
                        title: Text('Login Error'),
                        content: Text('${state.error}'),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('CLOSE'),
                            onPressed: () {
                              BlocProvider.of<LoginBloc>(context).dispatch(LoginReset());
                              Navigator.pop(context);
                            },
                          )
                        ],
                      ),
                );
              },
            );
          }
          return Scaffold(
            backgroundColor: AcBlue,
            body: SingleChildScrollView(
              child: SizedBox(
                child: Column(
                  children: <Widget>[
                    Container(
                      height: ScreenUtil.getInstance().setHeight(288),
                      color: Colors.white,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Image.asset('assets/acit.png',
                                    width:
                                        ScreenUtil.getInstance().setWidth(120),
                                    height: ScreenUtil.getInstance()
                                        .setHeight(120)),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  'ACHARYA\nINSTITUTES',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize:
                                          ScreenUtil.getInstance().setSp(38),
                                      fontWeight: FontWeight.w300),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.orange,
                      height: 14,
                    ),
                    Container(
                      color: AcBlue,
                      child: Container(
                        child: FLoginForm(
                          loginBloc: widget.loginBloc,
                          onLogin: _onLoginPressed,
                          state: state,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
    var x = 1;
  }

  void _onLoginPressed(String id, String password, Role role) {
    BlocProvider.of<LoginBloc>(context).dispatch(
      LoginButtonPressed(
        id: id,
        password: password,
        role: role,
      ),
    );
  }

  void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }
}

class FLoginForm extends StatefulWidget {
  final LoginBloc loginBloc;
  final void Function(String, String, Role) onLogin;
  final LoginState state;

  FLoginForm(
      {@required this.loginBloc, @required this.onLogin, @required this.state});

  @override
  _FLoginFormState createState() => _FLoginFormState();
}

class _FLoginFormState extends State<FLoginForm> {
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _idController = TextEditingController();

  FocusNode _focusNodeUsername;
  FocusNode _focusNodePassword;

  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _focusNodeUsername = FocusNode();
    _focusNodePassword = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    _focusNodeUsername.dispose();
    _focusNodePassword.dispose();
  }

  void _onPasswordSubmitted(_) {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    widget.onLogin(
      _idController.text.trim(),
      _passwordController.text,
      Role.STAFF,
    );
  }

  Widget _buildForgotPassword() => Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 20.0, top: 10.0),
        child: new Container(
          alignment: Alignment.center,
          height: 60.0,
          child: FlatButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => ErrorDialog(
                      title: 'Oops!',
                      buttonTitle: 'OK',
                      error: 'Contact the ERP team to reset your password',
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
              );
            },
            child: new Text(
              "Forgot Password?",
              style: new TextStyle(
                fontSize: 17.0,
                color: Colors.orange,
              ),
            ),
          ),
        ),
      );

  Widget _buildUsernameField() => EnsureVisibleWhenFocused(
        focusNode: _focusNodeUsername,
        child: new TextField(
          focusNode: _focusNodeUsername,
          controller: _idController,
          onSubmitted: (_) {
            FocusScope.of(context).requestFocus(_focusNodePassword);
          },
          decoration: new InputDecoration(
            labelText: 'Username',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      );

  Widget _buildPasswordField() => EnsureVisibleWhenFocused(
        focusNode: _focusNodePassword,
        child: new TextField(
          focusNode: _focusNodePassword,
          controller: _passwordController,
          obscureText: !_isPasswordVisible,
          onSubmitted: _onPasswordSubmitted,
          decoration: new InputDecoration(
            labelText: 'Password',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginEvent, LoginState>(
      bloc: BlocProvider.of<LoginBloc>(context),
      builder: (BuildContext context, LoginState state) {
        print("SDSDSDSDD => $state");
        return Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: ScreenUtil.getInstance().setHeight(61.53)),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'STAFF LOGIN',
                              style: TextStyle(
                                  fontSize: ScreenUtil.getInstance().setSp(25),
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          child: _buildUsernameField(),
                        ),
                      ),
                      new SizedBox(
                        height: 15.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 0.0),
                        child: _buildPasswordField(),
                      ),
                      Flexible(
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, right: 5.0, top: 10.0),
                                child: new Container(
                                  alignment: Alignment.center,
                                  height: 60.0,
                                  decoration: new BoxDecoration(
                                    color: AcBlue,
                                    borderRadius:
                                        new BorderRadius.circular(9.0),
                                  ),
                                  child: Material(
                                    elevation: 10,
                                    clipBehavior: Clip.antiAlias,
                                    borderRadius: BorderRadius.circular(9.0),
                                    color: AcBlue,
                                    child: InkWell(
                                      onTap: () {
                                        SystemChannels.textInput
                                            .invokeMethod('TextInput.hide');
                                        widget.onLogin(
                                          _idController.text.trim(),
                                          _passwordController.text,
                                          Role.STAFF,
                                        );
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 60.0,
                                        child: new Text(
                                          "Login",
                                          style: new TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(child: _buildForgotPassword()),
                          ],
                        ),
                      ),
//              Flexible(
//                fit: FlexFit.loose,
//                child: Center(
//                  child: widget.state is LoginLoading
//                      ? CircularProgressIndicator()
//                      : Container(),
//                ),
//              ),
                    ],
                  ),
                ),
              ),
            ),
            BlocBuilder<LoginEvent, LoginState>(
                bloc: BlocProvider.of<LoginBloc>(context),
                builder: (BuildContext context, LoginState state) {
                  print("SDSDSDSDD => $state");
                  return Visibility(
                    visible: BlocProvider.of<LoginBloc>(context).currentState is LoginLoading,
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaY: 10.0,
                        sigmaX: 10.0,
                      ),
                      child: FadeIn(
                        opacity: 0.1,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
//                color: Colors.grey.shade200.withOpacity(0.1),
                          color: Colors.red,
                        ),
                      ),
                    ),
                  );
                }),
            Visibility(
              visible:  BlocProvider.of<LoginBloc>(context).currentState is LoginLoading ,
              child: FadeIn(
                opacity: 1.0,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            CircularProgressIndicator(),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                "Loggin You In",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black54),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
