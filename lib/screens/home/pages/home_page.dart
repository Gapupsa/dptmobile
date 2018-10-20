import 'dart:async';

import 'package:dptmobile/screens/home/pages/profil_page.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import "package:pull_to_refresh/pull_to_refresh.dart";

class HomePage extends StatefulWidget {

  @override
  HomePageState createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  NetworkImage img1 = new NetworkImage('http://databaseak.kjppgear.co.id/public/sliders/bnr1.jpg');

  NetworkImage img2 = new NetworkImage('http://databaseak.kjppgear.co.id/public/sliders/bnr2.jpg');

  NetworkImage img3 = new NetworkImage('http://databaseak.kjppgear.co.id/public/sliders/bnr3.jpg');

  NetworkImage img4 = new NetworkImage('http://databaseak.kjppgear.co.id/public/sliders/bnr4.jpg');

  NetworkImage img5 = new NetworkImage('http://databaseak.kjppgear.co.id/public/sliders/bnr5.jpg');

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();

  RefreshController _refreshController = new RefreshController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    void _onRefresh(bool up){
      if(up){
        setState((){
          img1 = new NetworkImage('http://databaseak.kjppgear.co.id/public/sliders/bnr1.jpg');
          img2 = new NetworkImage('http://databaseak.kjppgear.co.id/public/sliders/bnr2.jpg');
          img3 = new NetworkImage('http://databaseak.kjppgear.co.id/public/sliders/bnr3.jpg');
          img4 = new NetworkImage('http://databaseak.kjppgear.co.id/public/sliders/bnr4.jpg');
          img5 = new NetworkImage('http://databaseak.kjppgear.co.id/public/sliders/bnr5.jpg');
        });
        //headerIndicator callback
        new Future.delayed(const Duration(milliseconds: 2009))
            .then((val) {
                  _refreshController.sendBack(true, RefreshStatus.completed);
            });
      }
      else{
  
      }
    }

    return SmartRefresher(
      controller: _refreshController,
      key: _refreshIndicatorKey,
      enablePullDown: true,
      enablePullUp: true,
      onRefresh: _onRefresh,
          child: ListView(
        children: <Widget>[
          new Container(
              child: new SizedBox(
                  height: height / 3,
                  width: width,
                  child: new Carousel(
                    boxFit: BoxFit.fill,
                    images: [
                      img1,
                      img2,
                      img3,
                      img4,
                      img5,
                    ],
                    dotSize: 9.0,
                    dotSpacing: 20.0,
                    dotColor: Colors.white,
                    indicatorBgPadding: 5.0,
                    dotBgColor: Colors.red.withOpacity(0.5),
                    borderRadius: false,
                    //moveIndicatorFromBottom: 180.0,
                    noRadiusForIndicator: true,
                    overlayShadow: true,
                    overlayShadowColors: Colors.white,
                    overlayShadowSize: 0.7,
                  ))),
          new Padding(
            padding: const EdgeInsets.only(bottom: 30.0),
          ),
          Column(
            children: <Widget>[
              new Container(
                padding: const EdgeInsets.all(20.0),
                height: height * 0.3,
                width: width * 0.3,
                child: new Center(
                  child: new Hero(
                    tag: "1",
                    child: new Material(
                      borderRadius: BorderRadius.circular(10.0),
                      elevation: 15.0,
                      shadowColor: Colors.red.shade900,
                      child: new InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetailProfil()),
                          );
                        },
                        child: new Image(
                          image: AssetImage("assets/login_background.jpg"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              new Text("Alkausar Kalam, SE. M.SI",
                  style: TextStyle(
                      fontFamily: "RobotoMono",
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold)),
              new Text("Click image for detail information",
                  style: TextStyle(
                      color: Colors.redAccent,
                      fontFamily: "RobotoMono",
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}
