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
    theme: ThemeData(
      canvasColor: Colors.transparent,
    ),
  ));
//  Workmanager.registerOneOffTask(
//    "2",
//    "simpleDelayedTask",
//    initialDelay: Duration(seconds: 0),
//    existingWorkPolicy: ExistingWorkPolicy.replace,
//    constraints: Constraints(
//        networkType: NetworkType.not_required,
//        requiresBatteryNotLow: false,
//        requiresCharging: false,
//        requiresDeviceIdle: false,
//        requiresStorageNotLow: false),
//  );
}
