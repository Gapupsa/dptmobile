import 'package:dptmobile/data/database_helper.dart';
import 'package:dptmobile/data/rest_ds.dart';
import 'package:dptmobile/models/user.dart';
import 'package:dptmobile/screens/home/pages/home_page.dart';
import 'package:dptmobile/screens/home/pages/input_page.dart';
import 'package:dptmobile/screens/home/pages/register_page.dart';
import 'package:dptmobile/screens/home/pages/report_page.dart';
import 'package:dptmobile/screens/login/login_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final User user;

  HomeScreen({this.user});

  @override
  _HomeScreenState createState() => _HomeScreenState(user: user);
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final User user;

  RestDatasource api = new RestDatasource();

  _HomeScreenState({this.user});
  TabController _controller;

  @override
  void initState() {
    _controller = new TabController(vsync: this, length: 4);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        elevation: .5,
        backgroundColor: Colors.red,
        title: new Text("DPT-Mobile"),
        bottom: TabBar(
          controller: _controller,
          tabs: <Widget>[
            Tab(
              icon: Icon(Icons.home),
              text: "HOME",
            ),
            Tab(icon: Icon(Icons.input), text: "INPUT"),
            Tab(icon: Icon(Icons.receipt), text: "VIEW"),
            Tab(icon: Icon(Icons.account_circle), text: "USER"),
          ],
        ),
      ),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: new Text(
                user.username,
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              accountEmail: new Text(
                user.email,
                style: TextStyle(color: Colors.white),
              ),
              currentAccountPicture: new CircleAvatar(
                backgroundImage: new AssetImage("assets/login_background.jpg"),
              ),
              decoration: new BoxDecoration(
                gradient: new LinearGradient(
                  begin: Alignment.topRight, // new
                  end: Alignment.bottomLeft,
                  stops: [0.1, 0.5, 0.7, 0.9],
                  colors: [
                    Colors.red[800],
                    Colors.red[700],
                    Colors.red[600],
                    Colors.red[400],
                  ],
                ),
              ),
            ),
            new ListTile(
              onTap: () async {
                var db = new DatabaseHelper();
                User usr = await db.getUser();
                api.logout(usr.token);
                int result = await db.deleteUsers();
                if (result == 1) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                }
              },
              title: new Text("EXIT ->"),
              trailing: new Icon(Icons.exit_to_app, color: Colors.redAccent),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _controller,
        children: <Widget>[
          new HomePage(),
          new InputPage(
            kcmt: user.kecamatan,
          ),
          //new AddData(),
          new ReportPage(),
          new RegisterPage(),
        ],
      ),
    );
  }
}
