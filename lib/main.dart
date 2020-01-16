import 'package:flutter/material.dart';

import 'ui/myapp.dart';

String APP_ID = "ca-app-pub-5658699902837706~8685176551";
String BANNER_UNIT_TEST = "ca-app-pub-5658699902837706/5739449013";
String INTERESTIAL_UNIT_TEST = "ca-app-pub-5658699902837706/2053971983";
String REWARDED_UNIT_TEST = "ca-app-pub-5658699902837706/5731710159";
String NATIVE_ADVANCED_UNIT_TEST = "ca-app-pub-5658699902837706/1852174893";
const EVENTS_KEY = "fetch_events";

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(MaterialApp(
    home: MyApp(),
    debugShowCheckedModeBanner: false,
    navigatorKey: navigatorKey,
    initialRoute: "/",
    builder: (BuildContext context, Widget child) {
      return Padding(
        child: child,
        padding: EdgeInsets.only(bottom: 60.0),
      );
    },
    theme: ThemeData(
//      canvasColor: Colors.transparent,
        ),
  ));
}
