import 'dart:async';

import 'package:dptmobile/data/database_helper.dart';
import 'package:dptmobile/data/rest_ds.dart';
import 'package:dptmobile/models/user.dart';
import 'package:dptmobile/screens/home/register_presenter.dart';
import 'package:dptmobile/screens/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChangePassword extends StatefulWidget {
  final User user;
  ChangePassword({this.user});

  @override
  _ChangePasswordState createState() => _ChangePasswordState(user: user);
}

class _ChangePasswordState extends State<ChangePassword>
    implements RegisterScreenContract {
  final User user;

  RestDatasource api = new RestDatasource();
  BuildContext ctxDialog;
  BuildContext ctxDialog2;
  BuildContext _ctx;

  bool _obscureText = true;
  List<User> _users;
  bool _isLoadingGrid = false;
  bool _isLoadingChange = false;
  RegisterScreenPresenter _presenter;
  TextEditingController ct = new TextEditingController();

  _ChangePasswordState({this.user}) {
    _presenter = new RegisterScreenPresenter(this);
  }

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _isLoadingGrid = true;

    _presenter.loadUsers(user.token);

    super.initState();
  }

  @override
  dispose() {
    super.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: new AppBar(
        title: new Text("Change Password"),
        elevation: 5.0,
      ),
      body: _isLoadingGrid
          ? Center(child: CircularProgressIndicator())
          : new ConstrainedBox(
              constraints: BoxConstraints(maxHeight: height, maxWidth: width),
              child: new Column(
                children: <Widget>[
                  const SizedBox(height: 24.0),
                  new Center(
                    child: new Text("Choose an user to change the password",
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold)),
                  ),
                  new Divider(),
                  Expanded(
                    child: new ListView.builder(
                      itemCount: _users == null ? 0 : _users.length,
                      itemBuilder: (BuildContext context, int index) {
                        final int i = index ~/ 2;
                        final User user = _users[index];
                        /* if (index.isOdd) {
                     return new Divider();
                  } */
                        return new ListTile(
                          onLongPress: ()async {
                            var db = new DatabaseHelper();
                            User lUser = await db.getUser();
                            _showActiveUserDialogAction(lUser.token,user.id.toString());
                          },
                          trailing: new IconButton(
                            tooltip: "Click for editing",
                            iconSize: 30.0,
                            color: Colors.redAccent,
                            key: Key(index.toString()),
                            onPressed: () {
                              _showInputDialog(user);
                            },
                            icon: Icon(Icons.edit),
                          ),
                          leading: new Material(
                              color: Colors.lightBlueAccent,
                              borderRadius: BorderRadius.circular(10.0),
                              elevation: 5.0,
                              shadowColor: Colors.red.shade900,
                              child: new Text(
                                user.username.substring(0, 1),
                                style: TextStyle(
                                    fontSize: 40.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white70),
                              )),
                          title: new Text(user.username.toUpperCase(),
                              style:
                                  new TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: new RichText(
                            text: new TextSpan(children: [
                              new TextSpan(
                                  text: user.email + "\n",
                                  style: new TextStyle(color: Colors.black)),
                              new TextSpan(
                                  text: user.kecamatan,
                                  style: new TextStyle(color: Colors.green))
                            ]),
                          ),
                          isThreeLine: true,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Future<Null> _showAlert(String pesan) {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('Info'),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                new Divider(),
                new Text(pesan),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<Null> _showInputDialog(User userNew) {
    
    String _changePasswordText;
    final formKey = new GlobalKey<FormState>();

    return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        _ctx = context;
        ctxDialog = context;
        return new AlertDialog(
          title: new Text('Input Change Password'),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                new Divider(),
                new Stack(
                  alignment: const Alignment(1.0, 1.0),
                  children: <Widget>[
                    new Form(
                      key: formKey,
                      child: new Column(
                        children: <Widget>[
                          new Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new Stack(
                              alignment: const Alignment(1.0, 1.0),
                              children: <Widget>[
                                new TextFormField(
                                  controller: ct,
                                  obscureText: _obscureText,
                                  onSaved: (val) => _changePasswordText = val,
                                  decoration: new InputDecoration(
                                    labelText: "Change password here",
                                    icon: const Padding(
                                        padding:
                                            const EdgeInsets.only(top: 15.0),
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
                  ],
                )
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('Cancel'),
              onPressed: () {
                if (!_isLoadingChange) {
                  Navigator.of(context).pop();
                }
              },
            ),
            _isLoadingChange
                ? CircularProgressIndicator()
                : new FlatButton(
                    child: new Text('Change'),
                    onPressed: () async {
                      final form = formKey.currentState;
                      var db = new DatabaseHelper();
                      User us = await db.getUser();

                      if (form.validate()) {
                        setState(() => _isLoadingChange = true);
                        form.save();
                        _presenter.changePassword(us.token,
                            _changePasswordText, userNew.id.toString());
                            
                      }
                    },
                  ),
          ],
        );
      },
    );
  }

  Future<Null> _showActiveUserDialogAction(String token,String id) {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        ctxDialog2 = context;
        return new AlertDialog(
          title: new Text('Choose Action For User'),
          content: new SingleChildScrollView(
            child: new Column(
              children: <Widget>[
                new RaisedButton(
                  onPressed: (){
                    _presenter.changeActiveUser(token, id, "1");
                  },
                  color: Colors.redAccent,
                  elevation: 5.0,
                  child: new Text("Activate",style: new TextStyle(color: Colors.white),),
                ),
                const SizedBox(height: 24.0),
                new RaisedButton(
                  onPressed: (){
                    _presenter.changeActiveUser(token, id, "0");
                  },
                  color: Colors.redAccent,
                  elevation: 5.0,
                  child: new Text("Deactivate",style: new TextStyle(color: Colors.white),),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Future onGetSuccess(List<User> result) async {
    if(result != null){
      setState(() {
        _users = result;
        _isLoadingGrid = false;
      });
    }else{
      _showDialogInfo("Your account is not activated. Please contact administrator.");
      var db = new DatabaseHelper();
      User usr = await db.getUser();
      api.logout(usr.token);
      db.deleteUsers();
      Navigator.pushReplacement(
          _ctx,
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ));
      
    }
  }

  @override
  void onLoginError(String errorTxt) {
    // TODO: implement onLoginError
  }

  @override
  void onLoginSuccess(Map result) {
    // TODO: implement onLoginSuccess
  }

  @override
  Future onSuccessChangePassword(Map result) async {
    if (result["flag"] == 1) {
      ct.clear();
      Navigator.of(ctxDialog).pop();
      setState(() => _isLoadingChange = false);
      _showAlert("Successfully changed");
      
    } else if(result["flag"] == 2) {
      ct.clear();
      Navigator.of(ctxDialog).pop();
      setState(() => _isLoadingChange = false);
      _showAlert(result['error']);
    }else {
      _showDialogInfo(result['error'].toString());
      var db = new DatabaseHelper();
      User usr = await db.getUser();
      api.logout(usr.token);
      db.deleteUsers();
      Navigator.pushReplacement(
          _ctx,
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ));
    }
  }

  @override
  Future onActiveSuccess(Map result) async {
    if (result["flag"] == 1) {
      _showAlert("User has been " + result['success'].toString());
    }else {
       _showDialogInfo(result['error'].toString());
      var db = new DatabaseHelper();
      User usr = await db.getUser();
      api.logout(usr.token);
      db.deleteUsers();
      Navigator.pushReplacement(
          _ctx,
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ));
    }
  }

  Future<Null> _showDialogInfo(String message) {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
            content: new SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[
                  Center(child: new Text(message)),
                ],
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ]);
      },
    );
  }
}
