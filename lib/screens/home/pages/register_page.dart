import 'dart:async';
import 'package:dptmobile/data/database_helper.dart';
import 'package:dptmobile/data/rest_ds.dart';
import 'package:dptmobile/helperWidget/ensureVisibleWhenFocused.dart';
import 'package:dptmobile/models/user.dart';
import 'package:dptmobile/screens/home/register_presenter.dart';
import 'package:dptmobile/screens/login/login_screen.dart';
import 'package:dptmobile/screens/users/change_password.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new RegisterPageState();
  }
}

class RegisterPageState extends State<RegisterPage>
    implements RegisterScreenContract {
  BuildContext _ctx;

  List _roles = [
    "ADMINISTRATOR",
    "DPT",
    "TPS",
  ];

  List _kecamatans = [
    "BONTOALA",
    "WAJO",
    "TALLO",
    "UJUNG TANAH",
    "KEP.SANGKARRANG"
  ];

  List<DropdownMenuItem<String>> _dropDownMenuItems;
  List<DropdownMenuItem<String>> _dropDownMenuItemsR;
  String _currentK;
  String _currentRole;

  bool _obscureText = true;

  @override
  void initState() {
    _dropDownMenuItems = getDropDownMenuItems(0);
    _currentK = _dropDownMenuItems[0].value;
    _dropDownMenuItemsR = getDropDownMenuItems(1);
    _currentRole = _dropDownMenuItemsR[0].value;

    super.initState();
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems(int i) {
    List<DropdownMenuItem<String>> items = new List();

    if(i == 0){
      for (String city in _kecamatans) {
        items.add(new DropdownMenuItem(value: city, child: new Text(city)));
      }
    }else{
      for (String city in _roles) {
        items.add(new DropdownMenuItem(value: city, child: new Text(city)));
      }
    }

    return items;
  }

  bool _isLoading = false;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  String _name, _email, _password, _kecamatan,_role;
  User _user;

  FocusNode _focusNodeFirstName = new FocusNode();
  FocusNode _focusNodeEmail = new FocusNode();
  FocusNode _focusNodePassword = new FocusNode();
  FocusNode _focusNodeKecamatan = new FocusNode();

  TextEditingController ctrl1 = new TextEditingController();
  TextEditingController ctrl2 = new TextEditingController();
  TextEditingController ctrl3 = new TextEditingController();
  TextEditingController ctrl4 = new TextEditingController();

  RegisterScreenPresenter _presenter;

  RestDatasource api = new RestDatasource();

  RegisterPageState() {
    _presenter = new RegisterScreenPresenter(this);
  }

  Future _submit() async {
    final form = formKey.currentState;
    var db = new DatabaseHelper();
    User userDB = await db.getUser();
    if (form.validate()) {
      setState(() => _isLoading = true);
      form.save();
      User usr = new User(0, _name, _email, _currentRole, userDB.token, _currentK);
      _presenter.sendData(usr, _password);
    }
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    var loginBtn = Container(
      child: new RaisedButton(
        elevation: 15.0,
        textColor: Colors.white,
        onPressed: _submit,
        child: new Text("CREATE USER"),
        color: Colors.primaries[0],
      ),
    );

    return new SafeArea(
      top: false,
      bottom: false,
      child: new Form(
        key: formKey,
        child: new SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              /* const SizedBox(height: 24.0),
                new Center(
                  child: new Text("DAFTARKAN PENGGUNA",style:TextStyle(fontSize:30.0,fontWeight: FontWeight.bold)),
                ), */
              const SizedBox(height: 24.0),
              new EnsureVisibleWhenFocused(
                focusNode: _focusNodeFirstName,
                child: new TextFormField(
                  decoration: const InputDecoration(
                    border: const UnderlineInputBorder(),
                    filled: true,
                    icon: const Icon(Icons.person),
                    hintText: 'Enter your name',
                    labelText: 'Name *',
                  ),
                  onSaved: (String value) {
                    _name = value;
                  },
                  validator: (val) {
                    return val == "" ? "NAME IS REQUIRED" : null;
                  },
                  controller: ctrl1,
                  focusNode: _focusNodeFirstName,
                ),
              ),
              const SizedBox(height: 24.0),
              new EnsureVisibleWhenFocused(
                focusNode: _focusNodeEmail,
                child: new TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    border: const UnderlineInputBorder(),
                    filled: true,
                    icon: const Icon(Icons.email),
                    hintText: 'Enter your email address',
                    labelText: 'Email *',
                  ),
                  onSaved: (String value) {
                    _email = value;
                  },
                  validator: (val) {
                    return val == "" ? "EMAIL IS REQUIRED" : null;
                  },
                  controller: ctrl2,
                  focusNode: _focusNodeEmail,
                ),
              ),
              const SizedBox(height: 24.0),
              new EnsureVisibleWhenFocused(
                focusNode: _focusNodePassword,
                child: Stack(
                  alignment: const Alignment(1.0, 1.0),
                  children: <Widget>[
                    new TextFormField(
                        obscureText: _obscureText,
                        decoration: const InputDecoration(
                          border: const UnderlineInputBorder(),
                          filled: true,
                          icon: const Icon(Icons.vpn_key),
                          hintText: 'Enter your password',
                          labelText: 'Password *',
                        ),
                        onSaved: (String value) {
                          _password = value;
                        },
                        validator: (val) {
                          return val == "" ? "PASSWORD IS REQUIRED" : null;
                        },
                        controller: ctrl3,
                        focusNode: _focusNodePassword),
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
              const SizedBox(height: 24.0),
              new Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                        padding: EdgeInsets.only(left: 40.0),
                        child: new Text("Districts : ")),
                  ),
                  Expanded(
                    flex: 2,
                    child: new DropdownButton(
                      value: _currentK,
                      items: _dropDownMenuItems,
                      onChanged: changedDropDownItem,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24.0),
              new Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                        padding: EdgeInsets.only(left: 40.0),
                        child: new Text("Role : ")),
                  ),
                  Expanded(
                    flex: 2,
                    child: new DropdownButton(
                      value: _currentRole,
                      items: _dropDownMenuItemsR,
                      onChanged: changedDropDownItemR,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24.0),
              new Column(children: <Widget>[
                _isLoading ? new CircularProgressIndicator() : loginBtn,
                const SizedBox(height: 24.0),
                new RaisedButton(
                  elevation: 5.0,
                  onPressed: () async {
                    var db = new DatabaseHelper();
                    _user = await db.getUser();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChangePassword(
                                user: _user,
                              )),
                    );
                  },
                  child: new Text("Change Password"),
                ),
                const SizedBox(height: 10.0),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  void clearForm() {
    ctrl1.clear();
    ctrl2.clear();
    ctrl3.clear();
    ctrl4.clear();
  }

  void changedDropDownItem(String selectedCity) {
    print("Selected city $selectedCity, we are going to refresh the UI");
    setState(() {
      _currentK = selectedCity;
    });
  }
  void changedDropDownItemR(String selectedCity) {
    print("Selected city $selectedCity, we are going to refresh the UI");
    setState(() {
      _currentRole = selectedCity;
    });
  }

  @override
  void onLoginError(String errorTxt) {
    _showDialogInfo(errorTxt);
    setState(() => _isLoading = false);
  }

  @override
  void onLoginSuccess(Map data) async {
    if (data["flag"] == 1) {
      _showDialogInfo("Data have been save");
      clearForm();
      setState(() => _isLoading = false);
    } else {
      _showDialogInfo(data['error'].toString());
      var db = new DatabaseHelper();
      User usr = await db.getUser();
      api.logout(usr.token);
      db.deleteUsers();
      Navigator.pushReplacement(
          _ctx,
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ));
      setState(() => _isLoading = false);
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

  @override
  void onGetSuccess(List<User> result) {
    // TODO: implement onGetSuccess
  }

  @override
  void onSuccessChangePassword(Map result) {
    // TODO: implement onSuccessChangePassword
  }

  @override
  void onActiveSuccess(Map result) {
    // TODO: implement onActiveSuccess
  }
}
