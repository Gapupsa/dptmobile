import 'package:flutter/material.dart';
import 'package:dptmobile/auth.dart';
import 'package:dptmobile/routes.dart';

void main() => runApp(new LoginApp());

class LoginApp extends StatelessWidget {

  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'My Login App',
      theme: new ThemeData(
        fontFamily: 'Raleway',
        primarySwatch: Colors.red,
      ),
      routes: routes,
    );
  }


}