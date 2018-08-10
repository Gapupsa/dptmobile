import 'dart:async';
import 'dart:ui';

import 'package:dptmobile/screens/home/home_screen.dart';
import 'package:dptmobile/screens/home/home_screen_user.dart';
import 'package:flutter/material.dart';
import 'package:dptmobile/auth.dart';
import 'package:dptmobile/data/database_helper.dart';
import 'package:dptmobile/models/user.dart';
import 'package:dptmobile/screens/login/login_screen_presenter.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen>
    implements LoginScreenContract, AuthStateListener {
  BuildContext _ctx;

  bool _isLoading = false;
  bool _obscureText = true;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  String _username, _password;
  User _user;

  LoginScreenPresenter _presenter;

  LoginScreenState() {
    _presenter = new LoginScreenPresenter(this);
    var authStateProvider = new AuthStateProvider();
    authStateProvider.subscribe(this);
    //checkLogin();
  }

  Future checkLogin() async {
    var db = new DatabaseHelper();
    bool user = await db.isLoggedIn();
    if (user) {
      Navigator.push(
        _ctx,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
  }

  void _submit() {
    final form = formKey.currentState;

    if (form.validate()) {
      setState(() => _isLoading = true);
      form.save();
      _presenter.doLogin(_username, _password);
    }
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }

  @override
  onAuthStateChanged(AuthState state) async {
    var db = new DatabaseHelper();
    User usr = await db.getUser();
    if (state == AuthState.LOGGED_IN) {
      if (usr.tipe == "0") {
        Navigator.pushReplacement(
          _ctx,
          MaterialPageRoute(
              builder: (context) => HomeScreen(
                    user: usr,
                  )),
        );
      } else {
        Navigator.pushReplacement(
          _ctx,
          MaterialPageRoute(
              builder: (context) => HomeScreenUser(
                    user: usr,
                  )),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    var loginBtn = new RaisedButton(
      onPressed: _submit,
      child: new Text("LOGIN"),
      color: Colors.primaries[0],
    );
    var loginForm = new Column(
      children: <Widget>[
        new Text(
          "DPT-MOBILE-APP",
          textScaleFactor: 2.0,
        ),
        new Form(
          key: formKey,
          child: new Column(
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new TextFormField(
                  onSaved: (val) => _username = val,
                  decoration: new InputDecoration(
                    labelText: "Email",
                    icon: const Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: const Icon(Icons.email)),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Stack(
                  alignment: const Alignment(1.0, 1.0),
                  children: <Widget>[
                    new TextFormField(
                      obscureText: _obscureText,
                      onSaved: (val) => _password = val,
                      decoration: new InputDecoration(
                        labelText: "Password",
                        icon: const Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: const Icon(Icons.lock)),
                      ),
                    ),
                    new IconButton(
                      icon: new Icon(Icons.remove_red_eye),
                      onPressed: () {
                        setState(() {
                          _obscureText
                              ? _obscureText = false
                              : _obscureText = true;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        _isLoading ? new CircularProgressIndicator() : loginBtn
      ],
      crossAxisAlignment: CrossAxisAlignment.center,
    );

    return new Scaffold(
      appBar: null,
      key: scaffoldKey,
      body: Container(
        child: new Center(
          child: new ClipRect(
            child: new BackdropFilter(
              filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: new Container(
                child: loginForm,
                height: 300.0,
                width: 300.0,
                decoration: new BoxDecoration(
                    color: Colors.grey.shade200.withOpacity(0.5)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void onLoginError(String errorTxt) {
    _showSnackBar(errorTxt);
    setState(() => _isLoading = false);
  }

  @override
  void onLoginSuccess(Map data) async {
    if (data['flag'] == 1) {
        _user = User.map(data['0']['user']);
        _showSnackBar("Login Success");
        setState(() => _isLoading = false);

        var db = new DatabaseHelper();
        await db.saveUser(_user);
        var authStateProvider = new AuthStateProvider();
        authStateProvider.notify(AuthState.LOGGED_IN);
    } else {
      _showSnackBar(data['error'].toString());
      setState(() => _isLoading = false);
    }
  }
}
