import 'package:flutter/material.dart';
//import 'package:dptmobile/auth.dart';
//import 'package:dptmobile/routes.dart';
import 'package:dptmobile/screens/home/home_screen.dart';
import 'package:dptmobile/screens/login/login_screen.dart';



Future<Null> main() async {
  
  runApp(new LoginApp());
}


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
      routes: {
        '/login':         (BuildContext context) => new LoginScreen(),
        '/home':         (BuildContext context) => new HomeScreen(),
        '/' :          (BuildContext context) => new LoginScreen(),
      },
    );
  }


}