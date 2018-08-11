import 'dart:async';
import 'dart:io';
import 'package:date_format/date_format.dart';
import 'package:dptmobile/data/database_helper.dart';
import 'package:dptmobile/data/rest_ds.dart';
import 'package:dptmobile/helperWidget/ensureVisibleWhenFocused.dart';
import 'package:dptmobile/models/fixdpt.dart';
import 'package:dptmobile/models/user.dart';
import 'package:dptmobile/screens/home/report_presenter.dart';
import 'package:dptmobile/screens/login/login_screen.dart';
import 'package:dptmobile/utils/download_file.dart';
import 'package:flutter/material.dart';

class ReportPage extends StatefulWidget {
  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage>
    implements ReportScreenContract {
  bool _isLoading = false;
  bool _isLoading1 = false;
  bool _isLoading2 = false;
  bool _isLoadingTotalData = false;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  double width,height;

  BuildContext ctxDialogLoading;
  //total data
  String _totalData, _bontoala, _wajo, _tallo, _utanah, _kepsang;

  FocusNode _focusNodeNik = new FocusNode();
  TextEditingController ctrl1 = new TextEditingController();

  String _nik;

  ReportScreenPresenter _presenter;

  _ReportPageState() {
    _presenter = new ReportScreenPresenter(this);
  }

  List _kecamatans = [
    "BONTOALA",
    "WAJO",
    "TALLO",
    "UJUNG TANAH",
    "KEP.SANGKARRANG"
  ];

  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _currentK;
  BuildContext _ctx;

  RestDatasource api = new RestDatasource();

  @override
  void initState() {
    _dropDownMenuItems = getDropDownMenuItems();
    _currentK = _dropDownMenuItems[0].value;
    super.initState();
  }

  // here we are creating the list needed for the DropDownButton
  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String city in _kecamatans) {
      // here we are creating the drop down menu items, you can customize the item right here
      // but I'll just use a simple text for this
      items.add(new DropdownMenuItem(value: city, child: new Text(city)));
    }
    return items;
  }

  Future _submit() async {
    final form = formKey.currentState;
    var db = new DatabaseHelper();
    User userDB = await db.getUser();
    if (form.validate()) {
      setState(() => _isLoading = true);
      form.save();
      _presenter.checkData(_nik, userDB.token);
    }
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    _ctx = context;
    var searchBtn = Container(
      width: 50.0,
      child: new IconButton(
        icon: new Icon(Icons.search),
        onPressed: _submit,
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
              const SizedBox(height: 10.0),
              new Text("Search by NIK : ",
                  style:
                      TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10.0),
              new Row(
                children: <Widget>[
                  Expanded(
                    child: new EnsureVisibleWhenFocused(
                      focusNode: _focusNodeNik,
                      child: new TextFormField(
                        decoration: const InputDecoration(
                          border: const UnderlineInputBorder(),
                          filled: true,
                          hintText: 'Enter Nik ',
                        ),
                        onSaved: (String value) {
                          _nik = value;
                        },
                        validator: (val) {
                          return val == "" ? "NIK IS REQUIRED'" : null;
                        },
                        controller: ctrl1,
                        focusNode: _focusNodeNik,
                      ),
                    ),
                  ),
                  _isLoading ? new CircularProgressIndicator() : searchBtn,
                ],
              ),
              const SizedBox(height: 24.0),
              new Divider(),
              const SizedBox(height: 24.0),
              new Text("DOWNLOAD BY DISTRICTS :",
                  style: new TextStyle(
                    fontWeight: FontWeight.bold,
                  )),
              new Row(
                children: <Widget>[
                  Expanded(
                    child: new DropdownButton(
                      value: _currentK,
                      items: _dropDownMenuItems,
                      onChanged: changedDropDownItem,
                    ),
                  ),
                  new IconButton(
                    onPressed: () async {
                      var db = new DatabaseHelper();
                      User userDB = await db.getUser();
                      setState(() => _isLoading1 = true);
                      _showDialogIndicator();
                      _presenter.downloadAsKec(userDB.token, _currentK);
                    },
                    icon: new Icon(Icons.file_download),
                  ),
                ],
              ),
              const SizedBox(height: 24.0),
              new Divider(),
              const SizedBox(height: 24.0),
              new Row(
                children: <Widget>[
                  new Text(
                    "TOTAL DATA NUMBER : ",
                    style: new TextStyle(
                        fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  _isLoadingTotalData
                      ? CircularProgressIndicator()
                      : text(_totalData == null ? "0" : _totalData,
                          color: Colors.red, isBool: true),
                ],
              ),
              new Divider(),
              const SizedBox(height: 10.0),
              new Row(
                children: <Widget>[
                  new Text(
                    "TOTAL DATA BY DISTRICTS OF TODAY /  ",
                    style: new TextStyle(
                        fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  text(
                      formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]) +
                          " :",
                      color: Colors.red,
                      isBool: true),
                ],
              ),
              const SizedBox(height: 10.0),
              new Row(
                children: <Widget>[
                  Expanded(
                      child: new Text(
                    "- DISTRICTS OF BONTOALA : ",
                    style: new TextStyle(
                        fontSize: 16.0, fontWeight: FontWeight.bold),
                  )),
                  _isLoadingTotalData
                      ? CircularProgressIndicator()
                      : text(_bontoala == null ? "0" : _bontoala,
                          color: Colors.red, isBool: true),
                ],
              ),
              new Row(
                children: <Widget>[
                  Expanded(
                      child: new Text(
                    "- DISTRICTS OF WAJO : ",
                    style: new TextStyle(
                        fontSize: 16.0, fontWeight: FontWeight.bold),
                  )),
                  _isLoadingTotalData
                      ? CircularProgressIndicator()
                      : text(_wajo == null ? "0" : _wajo,
                          color: Colors.red, isBool: true),
                ],
              ),
              new Row(
                children: <Widget>[
                  Expanded(
                      child: new Text(
                    "- DISTRICTS OF TALLO : ",
                    style: new TextStyle(
                        fontSize: 16.0, fontWeight: FontWeight.bold),
                  )),
                  _isLoadingTotalData
                      ? CircularProgressIndicator()
                      : text(_tallo == null ? "0" : _tallo,
                          color: Colors.red, isBool: true),
                ],
              ),
              new Row(
                children: <Widget>[
                  Expanded(
                      child: new Text(
                    "- DISTRICTS OF U.TANAH : ",
                    style: new TextStyle(
                        fontSize: 16.0, fontWeight: FontWeight.bold),
                  )),
                  _isLoadingTotalData
                      ? CircularProgressIndicator()
                      : text(_utanah == null ? "0" : _utanah,
                          color: Colors.red, isBool: true),
                ],
              ),
              new Row(
                children: <Widget>[
                  Expanded(
                      child: new Text(
                    "- DISTRICTS OF KEP.SANGKARRANG : ",
                    style: new TextStyle(
                        fontSize: 16.0, fontWeight: FontWeight.bold),
                  )),
                  _isLoadingTotalData
                      ? CircularProgressIndicator()
                      : text(_kepsang == null ? "0" : _kepsang,
                          color: Colors.red, isBool: true),
                ],
              ),
              const SizedBox(height: 20.0),
              new Column(
                children: <Widget>[
                  _isLoadingTotalData
                      ? CircularProgressIndicator()
                      : new RaisedButton(
                          elevation: 15.0,
                          color: Colors.redAccent,
                          child: new Text("Refresh",
                              style: new TextStyle(color: Colors.white)),
                          onPressed: () async {
                            setState(() {
                              _isLoadingTotalData = true;
                            });
                            var db = new DatabaseHelper();
                            User u = await db.getUser();
                            _presenter.getTotalData(u.token);
                          },
                        ),
                ],
              ),
              const SizedBox(height: 10.0),
            ],
          ),
        ),
      ),
    );
  }

  void changedDropDownItem(String selectedCity) {
    print("Selected city $selectedCity, we are going to refresh the UI");
    setState(() {
      _currentK = selectedCity;
    });
  }

  @override
  void onError(String errorTxt) {
    // TODO: implement onError
  }

  @override
  Future onSuccess(Map result) async {
    if (result["flag"] == 1) {
      if (result["success"] == null) {
        _showAlert(_nik, null);
      } else {
        FixDpt fx = new FixDpt.map(result['success']);
        _showAlert(_nik, fx);
      }
      setState(() => _isLoading = false);
    } else {
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
      setState(() => _isLoading = false);
    }
    ctrl1.clear();
  }

  @override
  void onSuccessOne(Map result) async {
    if (result['flag'] == 1) {
      ExportData data = new ExportData();
      File hasil = await data.download(result['success'].toString());
      Navigator.of(ctxDialogLoading).pop();
      _showAlert2(hasil.path.toString());
      setState(() => _isLoading1 = false);
      setState(() => _isLoading2 = false);
    } else {
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

  Future<Null> _showAlert(String nik, FixDpt data) async {
    var wg;
    if (data != null) {
      wg = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text('NIK OF : ' + nik + ' already exist.'),
          new Divider(),
          new Text('Name :' + data.name),
          new Text('Address :' + data.alamat),
          new Text('Districts :' + data.kecamatan),
          new Text('Sub-Districts :' + data.kelurahan),
          new Text('Mobile Number :' + data.nohp),
          new Text('PIC :' + data.picname)
        ],
      );
    }

    return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('Info'),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                data != null ? wg : new Text("Data not found..!"),
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

  Future<Null> _showAlert2(String pesan) {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('Info'),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                new Text('Successfully download to : ' + pesan),
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

  Future<Null> _showDialogIndicator() {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        ctxDialogLoading = context;
        return new AlertDialog(
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                _isLoading1
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : null,
                const SizedBox(height: 10.0),
                Center(child: new Text("Please wait...")),
              ],
            ),
          ),
        );
      },
    );
  }

  text(String data,
          {Color color = Colors.black87,
          num size = 14.0,
          EdgeInsetsGeometry padding = EdgeInsets.zero,
          bool isBool = false}) =>
      Padding(
        padding: padding,
        child: SizedBox(
          height: height * 0.016,
          child: FittedBox(
            child: Text(
              data,
              style: TextStyle(
                color: color,
                fontSize: size.toDouble(),
                fontWeight: isBool ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      );

  @override
  Future onSuccessTotal(Map result) async {
    if (result['flag'] == 1) {
      dynamic data = result;
      setState(() {
        _totalData = data['all'].toString();
        _bontoala = data['byBon'].toString();
        _wajo = data['byWajo'].toString();
        _tallo = data['byTallo'].toString();
        _utanah = data['byUT'].toString();
        _kepsang = data['byKS'].toString();
        _isLoadingTotalData = false;
      });
    } else {
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
      setState(() {
        _isLoadingTotalData = false;
      });
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
