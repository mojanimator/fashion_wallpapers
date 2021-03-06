import 'package:flutter/material.dart';

import 'ui/myapp.dart';

const EVENTS_KEY = "fetch_events";

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> imageHolderKey = GlobalKey<NavigatorState>();

void main() {
//  WidgetsFlutterBinding.ensureInitialized();
//  SystemChannels.skia
//      .invokeMethod<void>('setResourceCacheMaxBytes', 512 * (1 << 20));
//  SystemChannels.skia
//      .invokeMethod<void>('Skia.setResourceCacheMaxBytes', 512 * (1 << 20));
  runApp(MaterialApp(
    home: MyApp(),
    debugShowCheckedModeBanner: false,
    navigatorKey: navigatorKey,
    initialRoute: "/",
    builder: (BuildContext context, Widget child) {
      return Padding(
        child: child,
        padding: EdgeInsets.only(bottom: 60),
      );
    },
    theme: ThemeData(
//      canvasColor: Colors.transparent,
        ),
  ));
}
