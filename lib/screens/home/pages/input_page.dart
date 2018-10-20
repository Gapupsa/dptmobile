import 'dart:async';
import 'package:dptmobile/data/database_helper.dart';
import 'package:dptmobile/data/rest_ds.dart';
import 'package:dptmobile/helperWidget/ensureVisibleWhenFocused.dart';
import 'package:dptmobile/models/user.dart';
import 'package:dptmobile/screens/home/input_presenter.dart';
import 'package:dptmobile/screens/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:dptmobile/models/fixdpt.dart';
import 'package:flutter/services.dart';

class InputPage extends StatefulWidget {
  final String kcmt;

  InputPage({this.kcmt});
  @override
  InputPageState createState() => InputPageState(kcmt: kcmt);
}

class InputPageState extends State<InputPage> implements InputScreenContract {
  final String kcmt;

  BuildContext _ctx;
  BuildContext ctxDialog;

  RestDatasource api = new RestDatasource();

  bool _isLoading = false;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  String _userid, _nik, _name, _alamat, _kelurahan, _kecamatan, _nohp, _pic;
  FixDpt _fixDpt;
  User _user;

  FocusNode _focusNodeNik = new FocusNode();
  FocusNode _focusNodeName = new FocusNode();
  FocusNode _focusNodeAlamat = new FocusNode();
  FocusNode _focusNodeKelurahan = new FocusNode();
  FocusNode _focusNodeKecamatan = new FocusNode();
  FocusNode _focusNodeNohp = new FocusNode();
  FocusNode _focusNodePic = new FocusNode();

  TextEditingController ctrl1 = new TextEditingController();
  TextEditingController ctrl2 = new TextEditingController();
  TextEditingController ctrl3 = new TextEditingController();
  TextEditingController ctrl4 = new TextEditingController();
  TextEditingController ctrl5 = new TextEditingController();
  TextEditingController ctrl6 = new TextEditingController();

  InputScreenPresenter _presenter;

  InputPageState({this.kcmt}) {
    _presenter = new InputScreenPresenter(this);
    checkLogin();
  }

  Future checkLogin() async {
    var db = new DatabaseHelper();
    User user = await db.getUser();

    setState(() => _user = user);
  }

  List _kecamatans = [
    "BONTOALA",
    "WAJO",
    "TALLO",
    "UJUNG TANAH",
    "KEP.SANGKARRANG"
  ];

  List _kelurahans = [
    "BARAYYA",
    "BONTOALA",
    "BONTOALA PARANG",
    "BONTOALA TUA",
    "BUNGA EJAYA",
    "GADDONG",
    "LAYANG",
    "MALIMONGAN BARU",
    "PARANG LAYANG",
    "TIMUNGAN LOMPOA",
    "TOMPO BALANG",
    "WAJO BARU",
    "BARRANG CADDI",
    "BARRANG LOMPO",
    "KODINGARENG",
    "BUTUNG",
    "ENDE",
    "MALIMONGAN",
    "MALIMONGAN TUA",
    "MAMPU",
    "MELAYU",
    "MELAYU BARU",
    "PATTUNUANG",
    "CAMBA BERUA",
    "CAMBAYA",
    "GUSUNG",
    "PATTINGALOANG",
    "PATTINGALOANG BARU",
    "TABARINGAN",
    "TAMALABBA",
    "TOTAKA",
    "UJUNG TANAH",
    "BULOA",
    "BUNGA EJA BERU",
    "KALUKUANG",
    "KALUKUBODOA",
    "LAKKANG",
    "LA'LATANG",
    "LEMBO",
    "PANNAMPU",
    "RAPPOJAWA",
    "RAPPOKALLING",
    "SUANGGA",
    "TALLO",
    "TAMMUA",
    "UJUNG PANDANG BARU",
    "WALA-WALAYA"
  ];

  List<DropdownMenuItem<String>> _dropDownMenuItemsKC;
  String _currentKC;
  List<DropdownMenuItem<String>> _dropDownMenuItemsKL;
  String _currentKL;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _dropDownMenuItemsKC = getDropDownMenuItems(1);
    _currentKC = _dropDownMenuItemsKC[0].value;
    _dropDownMenuItemsKL = getDropDownMenuItems(2);
    _currentKL = _dropDownMenuItemsKL[0].value;
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

  List<DropdownMenuItem<String>> getDropDownMenuItems(int index) {
    List<DropdownMenuItem<String>> items = new List();
    if (index == 1) {
      for (String city in _kecamatans) {
        items.add(new DropdownMenuItem(value: city, child: new Text(city)));
      }
    } else {
      for (String city in _kelurahans) {
        items.add(new DropdownMenuItem(value: city, child: new Text(city)));
      }
    }

    return items;
  }

  void _submit() {
    final form = formKey.currentState;

    if (form.validate()) {
      setState(() => _isLoading = true);
      form.save();
      _userid = _user.id.toString();
      _fixDpt = new FixDpt(
          _userid, _nik, _name, _alamat, _currentKC, _currentKL, _nohp, _pic);
      _presenter.sendData(_fixDpt, _user.token);
    }
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    _ctx = context;
    var loginBtn = Container(
      child: new RaisedButton(
        textColor: Colors.white,
        onPressed: _submit,
        child: new Text("Save"),
        color: Colors.primaries[0],
      ),
    );

    return new ConstrainedBox(
      constraints: BoxConstraints(maxHeight: height, maxWidth: width),
      child: Container(
        height: height,
        width: width,
        child: new Form(
          key: formKey,
          child: new SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal:15.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 24.0),
                new EnsureVisibleWhenFocused(
                  focusNode: _focusNodeNik,
                  child: new TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      filled: true,
                      icon: const Icon(Icons.credit_card),
                      hintText: 'Enter your NIK',
                      labelText: 'Nik *',
                    ),
                    onSaved: (String value) {
                      _nik = value;
                    },
                    validator: (val) {
                      if(val.length < 16 || val.length > 16){
                        return "NIK IS 16 DIGITS";
                      }else if(val == ""){
                        return "NIK IS REQUIRED";
                      }else{
                        return null;
                      }
                    },
                    controller: ctrl1,
                    focusNode: _focusNodeNik,
                  ),
                ),
                const SizedBox(height: 24.0),
                new EnsureVisibleWhenFocused(
                  focusNode: _focusNodeName,
                  child: new TextFormField(
                    decoration: const InputDecoration(
                      filled: true,
                      icon: const Icon(Icons.person),
                      hintText: 'Enter your Name',
                      labelText: 'Name *',
                    ),
                    onSaved: (String value) {
                      _name = value;
                    },
                    validator: (val) {
                      return val == "" ? "NAME IS REQUIRED" : null;
                    },
                    controller: ctrl2,
                    focusNode: _focusNodeName,
                  ),
                ),
                const SizedBox(height: 24.0),
                new EnsureVisibleWhenFocused(
                  focusNode: _focusNodeAlamat,
                  child: new TextFormField(
                      decoration: const InputDecoration(
                        filled: true,
                        icon: const Icon(Icons.streetview),
                        hintText: 'Enter your address',
                        labelText: 'Address *',
                      ),
                      onSaved: (String value) {
                        _alamat = value;
                      },
                      validator: (val) {
                        return val == "" ? "ADDRESS IS REQUIRED" : null;
                      },
                      controller: ctrl3,
                      focusNode: _focusNodeAlamat),
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
                        value: _currentKC,
                        items: _dropDownMenuItemsKC,
                        onChanged: changedDropDownItemKC,
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
                          child: new Text("Sub-Districts : ")),
                    ),
                    Expanded(
                      flex: 2,
                      child: new DropdownButton(
                        value: _currentKL,
                        items: _dropDownMenuItemsKL,
                        onChanged: changedDropDownItemKL,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24.0),
                new EnsureVisibleWhenFocused(
                  focusNode: _focusNodeNohp,
                  child: new TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        filled: true,
                        icon: const Icon(Icons.phone_android),
                        hintText: 'Enter your mobile phone number',
                        labelText: 'Mobile Number *',
                      ),
                      onSaved: (String value) {
                        _nohp = value;
                      },
                      validator: (val) {
                        return val == "" ? "MOBILE NUMBER IS REQUIRED" : null;
                      },
                      controller: ctrl5,
                      focusNode: _focusNodeNohp),
                ),
                const SizedBox(height: 24.0),
                new EnsureVisibleWhenFocused(
                  focusNode: _focusNodePic,
                  child: new TextFormField(
                      decoration: const InputDecoration(
                        filled: true,
                        icon: const Icon(Icons.person),
                        hintText: 'Enter your name of Person In Charge',
                        labelText: 'PIC *',
                      ),
                      onSaved: (String value) {
                        _pic = value;
                      },
                      validator: (val) {
                        return val == "" ? "PIC IS REQUIRED" : null;
                      },
                      controller: ctrl6,
                      focusNode: _focusNodePic),
                ),
                const SizedBox(height: 24.0),
                new Column(children: <Widget>[
                  _isLoading ? new CircularProgressIndicator() : loginBtn,
                ]),
                const SizedBox(height: 24.0),
              ],
            ),
            //const SizedBox(height: 24.0),
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
    ctrl5.clear();
    ctrl6.clear();
  }

  void changedDropDownItemKL(String selectedCity) {
    setState(() {
      _currentKL = selectedCity;
    });
  }

  void changedDropDownItemKC(String selectedCity) {
    setState(() {
      _currentKC = selectedCity;
    });
  }

  Future<Null> _showDialogInfo(String message) {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        ctxDialog = context;
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
  void onLoginError(String errorTxt) {
    _showDialogInfo(errorTxt);
    setState(() => _isLoading = false);
  }

  @override
  void onLoginSuccess(Map data) async {
    if (data["flag"] == 1) {
      _showDialogInfo("Successfully to record");
      clearForm();
      setState(() => _isLoading = false);
    } else {
      _showDialogInfo(data['error'].toString());
      setState(() => _isLoading = false);
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
}
