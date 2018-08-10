import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_permissions/simple_permissions.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => new _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  String _platformVersion = 'Unknown';
  Permission permission;

  @override
  initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await SimplePermissions.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text("Setting Storage Permissions"),
          elevation: 5.0,
          backgroundColor: Colors.red,
        ),
        body: new Center(
          child: new Column(children: <Widget>[
            new Text('Running on: $_platformVersion\n'),
            new DropdownButton(
                items: _getDropDownItems(),
                value: permission,
                onChanged: onDropDownChanged),
            new RaisedButton(
                elevation: 5.0,
                color: Colors.redAccent,
                padding: EdgeInsets.only(bottom: 10.0),
                onPressed: checkPermission,
                child: new Text("Check permission")),
            new RaisedButton(
                elevation: 5.0,
                color: Colors.redAccent,
                padding: EdgeInsets.only(bottom: 10.0),
                onPressed: requestPermission,
                child: new Text("Request permission")),
            new RaisedButton(
                elevation: 5.0,
                color: Colors.redAccent,
                padding: EdgeInsets.only(bottom: 10.0),
                onPressed: getPermissionStatus,
                child: new Text("Get permission status")),
            new RaisedButton(
                elevation: 5.0,
                color: Colors.redAccent,
                padding: EdgeInsets.only(bottom: 10.0),
                onPressed: SimplePermissions.openSettings,
                child: new Text("Open settings"))
          ]),
        ),
      ),
    );
  }

  onDropDownChanged(Permission permission) {
    setState(() => this.permission = permission);
    print(permission);
  }

  requestPermission() async {
    bool res = await SimplePermissions.requestPermission(permission);
    print("permission request result is " + res.toString());
  }

  checkPermission() async {
    bool res = await SimplePermissions.checkPermission(permission);
    print("permission is " + res.toString());
  }

  getPermissionStatus() async {
    final res = await SimplePermissions.getPermissionStatus(permission);
    print("permission status is " + res.toString());
  }

  List<DropdownMenuItem<Permission>> _getDropDownItems() {
    List<DropdownMenuItem<Permission>> items = new List();
    Permission.values.forEach((permission) {
      var item = new DropdownMenuItem(
          child: new Text(getPermissionString(permission)), value: permission);
      items.add(item);
    });
    return items;
  }
}
