import 'package:dptmobile/data/database_helper.dart';
import 'package:dptmobile/data/rest_ds.dart';
import 'package:dptmobile/models/user.dart';
import 'package:dptmobile/screens/home/pages/home_page.dart';
import 'package:dptmobile/screens/home/pages/input_page.dart';
import 'package:dptmobile/screens/login/login_screen.dart';
import 'package:flutter/material.dart';

class HomeScreenUser extends StatefulWidget {
  final User user;

  HomeScreenUser({this.user});
  @override
  _HomeScreenUserState createState() => _HomeScreenUserState(user: user);
}

class _HomeScreenUserState extends State<HomeScreenUser>
    with SingleTickerProviderStateMixin {
  final User user;

   RestDatasource api = new RestDatasource();

  _HomeScreenUserState({this.user});
  TabController _controller;

  @override
  void initState() {
    _controller = new TabController(vsync: this, length: 2);
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
            Tab(icon: Icon(Icons.home)),
            Tab(icon: Icon(Icons.input))
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
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
              accountEmail: new Text(
                user.email,
                style: TextStyle(color: Colors.black),
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
                    Colors.indigo[800],
                    Colors.indigo[700],
                    Colors.indigo[600],
                    Colors.indigo[400],
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
        children: <Widget>[new HomePage(), new InputPage()],
      ),
    );
  }
}
