import 'package:dptmobile/screens/home/pages/profil_page.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return ListView(
      children: <Widget>[
        new Container(
            child: new SizedBox(
                height: height / 3,
                width: width,
                child: new Carousel(
                  boxFit: BoxFit.fill,
                  images: [
                    new AssetImage("assets/bnr1.jpg"),
                    new AssetImage("assets/bnr2.jpg"),
                    new AssetImage("assets/bnr3.jpg"),
                    new AssetImage("assets/bnr4.jpg"),
                    new AssetImage("assets/bnr5.jpg"),
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
    );
  }
}
