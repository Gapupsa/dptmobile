import 'dart:async';
import 'dart:io';
import 'package:dptmobile/data/database_helper.dart';
import 'package:dptmobile/data/rest_ds.dart';
import 'package:dptmobile/helperWidget/ensureVisibleWhenFocused.dart';
import 'package:dptmobile/models/user.dart';
import 'package:dptmobile/screens/home/input_presenter.dart';
import 'package:dptmobile/screens/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:dptmobile/models/tps.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as Img;
import 'dart:math' as Math;

import 'package:path_provider/path_provider.dart';

class InputPageTps extends StatefulWidget {
  final String kcmt;

  InputPageTps({this.kcmt});
  @override
  InputPageTpsState createState() => InputPageTpsState(kcmt: kcmt);
}

class InputPageTpsState extends State<InputPageTps> implements InputScreenContract {
  final String kcmt;

  File _image;

  Future getImage() async {
    var imageFile = await ImagePicker.pickImage(source: ImageSource.camera);

    
    final tempDir =await getTemporaryDirectory();
    final path = tempDir.path;

    int rand= new Math.Random().nextInt(100000);
    //_showDialogIndicator();
    Img.Image image= Img.decodeImage(imageFile.readAsBytesSync());
    Img.Image smallerImg = Img.copyResize(image, 500);

    var compressImg= new File("$path/image_$rand.jpg")
    ..writeAsBytesSync(Img.encodeJpg(smallerImg, quality: 85));


    setState(() {
        _image = compressImg;
    });
    //Navigator.of(ctxDialogLoading).pop();
  }

  BuildContext _ctx;
  BuildContext ctxDialog;
  BuildContext ctxDialogLoading;

  RestDatasource api = new RestDatasource();

  bool _isLoading = false;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  String _userid,_kelurahan, _kecamatan, _vote, _pic;
  Tps _fixDpt;
  User _user;

  FocusNode _focusNodeNohp = new FocusNode();

  TextEditingController ctrl6 = new TextEditingController();

  InputScreenPresenter _presenter;

  InputPageTpsState({this.kcmt}) {
    _presenter = new InputScreenPresenter(this);
    checkLogin();
  }

  Future checkLogin() async {
    var db = new DatabaseHelper();
    User user = await db.getUser();

    setState(() => _user = user);
  }

List _tps = [
  "TPS1",
  "TPS2",
  "TPS3",
  "TPS4",
  "TPS5",
  "TPS6",
  "TPS7",
  "TPS8",
  "TPS9",
  "TPS10",
  "TPS11",
  "TPS12",
  "TPS13",
  "TPS14",
  "TPS15",
  "TPS16",
  "TPS16",
  "TPS18",
  "TPS19",
  "TPS20",
  "TPS21",
  "TPS22",
  "TPS5",
  "TPS23",
  "TPS24",
  "TPS25",
  "TPS26",
  "TPS27",
  "TPS28",
  "TPS29",
  "TPS30",
  "TPS31",
  "TPS32",
  "TPS33",
  "TPS34",
  "TPS35",
  "TPS36",
  "TPS37",
  "TPS38",
  "TPS39",
  "TPS40",
  "TPS41",
  "TPS42",
  "TPS43",
  "TPS44",
  "TPS45",
  "TPS46",
  "TPS47",
  "TPS48",
  "TPS49",
  "TPS50"
];

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
  List<DropdownMenuItem<String>> _dropDownMenuItemsTPS;
  String _currentTPS;

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
    _dropDownMenuItemsTPS = getDropDownMenuItems(3);
    _currentTPS = _dropDownMenuItemsTPS[0].value;
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
    } else if(index == 2) {
      for (String city in _kelurahans) {
        items.add(new DropdownMenuItem(value: city, child: new Text(city)));
      }
    }else{
      for (String city in _tps) {
        items.add(new DropdownMenuItem(value: city, child: new Text(city)));
      }
    }

    return items;
  }

  void _submit() {
    //_showDialogIndicator();
    if(_image == null){
      //Navigator.of(ctxDialogLoading).pop();
      _showDialogInfo('Choose file image to upload');
      return;
    }

    final form = formKey.currentState;

    if (form.validate()) {
      setState(() => _isLoading = true);
      form.save();
      _userid = _user.id.toString();
      _fixDpt = new Tps(
          _currentKC, _currentKL,_currentTPS, _vote, _image);
      _presenter.sendDataTps(_fixDpt, _user.token);
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
                new Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                          padding: EdgeInsets.only(left: 40.0),
                          child: new Text("TPS : ")),
                    ),
                    Expanded(
                      flex: 2,
                      child: new DropdownButton(
                        value: _currentTPS,
                        items: _dropDownMenuItemsTPS,
                        onChanged: changedDropDownItemTPS,
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
                        hintText: 'Enter Number of Votes',
                        labelText: 'Votes *',
                      ),
                      onSaved: (String value) {
                        _vote = value;
                      },
                      validator: (val) {
                        return val == "" ? "Number of votes IS REQUIRED" : null;
                      },
                      controller: ctrl6,
                      focusNode: _focusNodeNohp),
                ),
                const SizedBox(height: 24.0),
                new Center(
                  child: _image == null
                      ? new Text('Upload reference picture.')
                      : new Image.file(_image),
                ),
                new Center(
                  child: IconButton(
                    icon: Icon(Icons.camera_alt),
                    color: Colors.blue,
                    onPressed: () async{
                      await getImage();
                    },
                  ),
                ),
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
    ctrl6.clear();
  }

  void changedDropDownItemKL(String selectedCity) {
    setState(() {
      _currentKL = selectedCity;
    });
  }

  void changedDropDownItemTPS(String selectedCity) {
    setState(() {
      _currentTPS = selectedCity;
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
                _isLoading
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

  @override
  void onLoginError(String errorTxt) {
    _showDialogInfo(errorTxt);
    setState(() => _isLoading = false);
  }

  @override
  void onLoginSuccess(Map data) async {
    if (data["flag"] == 1) {
      //Navigator.of(ctxDialogLoading).pop();
      _showDialogInfo("Successfully to record");
      clearForm();
      setState(() {
        _isLoading = false;
        _image = null;
      } );
    } else if(data["flag"] == 2) {
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
    }else{
      //Navigator.of(ctxDialogLoading).pop();
      _showDialogInfo(data['error'].toString());
      setState(() => _isLoading = false);
    }
  }
}
