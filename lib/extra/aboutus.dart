import 'dart:ui';

import 'package:connecting/helper/variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

Size size;

class AboutUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 10.0,
        backgroundColor: Colors.black,
        title: Text("Fashion Wallpapers"),
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Stack(children: [
            ClipPath(
              clipper: MyClipper(),
              child: Container(
                color: Colors.lightBlue,
                width: double.infinity,
                height: size.height / 2,
              ),
            ),
            ClipPath(
              clipper: MyClipper(),
              child: Container(
                color: Colors.blueAccent,
                width: double.infinity,
                height: size.height / 3,
              ),
            ),
            ClipPath(
              clipper: MyClipper(),
              child: Container(
                color: Colors.blue[800],
                width: double.infinity,
                height: size.height / 5,
              ),
            ),
          ]),
          Container(
            transform: Matrix4.translationValues(0.0, -size.height / 3.5, 0.0),
            child: Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                Card(
                  margin: EdgeInsets.only(
                      left: size.width / 6, right: size.width / 6, top: 0),
                  child: Padding(
                    padding: EdgeInsets.only(top: size.width / 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              FloatingActionButton(
                                backgroundColor: Colors.red,
                                heroTag: "email",
                                onPressed: () async {
                                  if (await canLaunch(
                                      "mailto:varta.studio@gmail.com?subject=Fashion Wallpapers")) {
                                    await launch(
                                        "mailto:varta.studio@gmail.com?subject=Fashion Wallpapers");
                                  } else {
                                    await launch("http://gmail.com");
                                  }
                                },
                                mini: true,
                                child: Icon(Icons.mail_outline),
                              ),
                              FloatingActionButton(
                                backgroundColor: Colors.pink,
                                heroTag: "instagram",
                                onPressed: () async {
                                  if (await canLaunch(
                                      "https://instagram.com/_u/vartastudio")) {
                                    await launch(
                                        "https://instagram.com/_u/vartastudio");
                                  } else {
                                    await launch(
                                        "https://instagram.com/vartastudio");
                                  }
                                },
                                mini: true,
                                child: Icon(FontAwesomeIcons.instagram),
                              ),
                              FloatingActionButton(
                                heroTag: "telegram",
                                onPressed: () async {
                                  if (await canLaunch(
                                      "https://telegram.me/vartastudio")) {
                                    await launch(
                                        "https://telegram.me/vartastudio");
                                  } else {
                                    await launch(
                                        "http://instagram.me/vartastudio");
                                  }
                                },
                                mini: true,
                                child: Icon(FontAwesomeIcons.telegramPlane),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              FloatingActionButton(
                                backgroundColor: Colors.green,
                                heroTag: "whatsapp",
                                onPressed: () async {
                                  if (await canLaunch(
                                      "whatsapp://send?phone=${Variable.PHONE}")) {
                                    await launch(
                                        "whatsapp://send?phone=${Variable.PHONE}");
                                  } else {
                                    await launch(
                                        "http://wa.me/${Variable.PHONE}");
                                  }
                                },
                                mini: true,
                                child: Icon(
                                  FontAwesomeIcons.whatsapp,
                                ),
                              ),
                              FloatingActionButton(
                                backgroundColor: Colors.blueAccent,
                                heroTag: "facebook",
                                onPressed: () async {
                                  if (await canLaunch(
                                      "fb://page/vartastudio")) {
                                    await launch("fb://page/vartastudio");
                                  } else {
                                    await launch(
                                        "https://facebook.com/vartastudio");
                                  }
                                },
                                mini: true,
                                child: Icon(
                                  FontAwesomeIcons.facebookF,
                                ),
                              ),
                              FloatingActionButton(
                                backgroundColor: Colors.blueAccent,
                                heroTag: "twitter",
                                onPressed: () async {
                                  if (await canLaunch(
                                      "https://twitter.com/vartastudio")) {
                                    await launch(
                                        "https://twitter.com/vartastudio");
                                  } else {
                                    await launch(
                                        "https://twitter.com/vartastudio");
                                  }
                                },
                                mini: true,
                                child: Icon(
                                  FontAwesomeIcons.twitter,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Created With "),
                            Icon(
                              Icons.favorite,
                              color: Colors.red,
                            ),
                            Text(" By: "),
                            Text(
                              "Varta Studio ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage("images/varta-logo.png"),
                    ),
                    borderRadius: BorderRadius.all(new Radius.circular(100.0)),
                    border: new Border.all(
                      color: Colors.blue,
                      width: 2.0,
                    ),
                  ),
                  height: size.width / 5,
                  width: size.width / 5,
                  transform:
                      Matrix4.translationValues(0.0, -size.width / 10, 0.0),
                ),
              ],
            ),
          ),
//              ClipPath(
//                clipper: MyClipperBottom(),
//                child: Container(
//                  color: Colors.blue[800],
//                  width: double.infinity,
//                  height: size.height / 4,
//                ),
//              ),
        ],
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
//    path.lineTo(size.width / 2, size.height / 3);
//    path.lineTo(size.width, size.height);
    path.quadraticBezierTo(size.width / 4, size.height / 2, size.width / 2,
        size.height - (size.height / 4));
    path.quadraticBezierTo(size.width - (size.width / 4), size.height,
        size.width, size.height - (size.height / 4));
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return null;
  }
}

class MyClipperBottom extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
//    path.lineTo(size.width / 2, size.height / 3);
//    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.quadraticBezierTo(
        size.width / 2, (size.height / 2), 0, (size.height / 2));
//    path.quadraticBezierTo(
//        size.width - (size.width / 4),
//        size.height - (size.height / 4),
//        size.width,
//        size.height - (size.height / 4));

//    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return null;
  }
}
