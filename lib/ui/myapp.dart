import 'dart:io';

import 'package:app_review/app_review.dart';
import 'package:connecting/extra/MyTab.dart';
import 'package:connecting/extra/aboutus.dart';
import 'package:connecting/helper/WallpaperBloc.dart';
import 'package:connecting/helper/helper.dart';
import 'package:connecting/main.dart';
import 'package:connecting/ui/tabfavourites.dart';
import 'package:connecting/ui/tabfour.dart';
import 'package:connecting/ui/tabthree.dart';
import 'package:connecting/ui/tabtwo.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallpaper_changer/wallpaper_changer.dart';
import 'package:workmanager/workmanager.dart';

import 'homepage.dart';

const CHECK_UPDATE = "checkUpdate";
const CHANGE_WALLPAPER = "changeWallpaper";

void callbackDispatcher() {
  Workmanager.executeTask((task, inputData) async {
    switch (task) {
      case CHECK_UPDATE:
        var res = await Helper.checkAndSetUpdates();

        /* if (res != -1)*/
        showNotification();
        break;
      case CHANGE_WALLPAPER:
//        await Helper.changeWallpaper(await getExternalStorageDirectory());
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        int timerHours = localStorage.getInt('timer_hours') ?? 0;
        int remainedService = localStorage.getInt('remained_service') ?? 0;
        if (timerHours == 0) Workmanager.cancelByTag("changeWallpaper");

        if (timerHours == 1 && remainedService <= 0) {
          //service finished
          localStorage.setInt('timer_hours', 0);
          break;
        } else if (timerHours == 1)
          localStorage.setInt('remained_service', remainedService - 1);
        int current = localStorage.getInt('current_wallpaper_index');
        if (current == null) {
          current = -1;
          localStorage.setInt('current_wallpaper_index', -1);
        }
        Directory directory = await getExternalStorageDirectory();
        final myImagePath = '${directory.path}/Fashion_Wallpapers/Favourites';
        if (Directory(myImagePath).existsSync()) {
          List<FileSystemEntity> files = Directory(myImagePath)
              .listSync(recursive: false, followLinks: false);

          if (current + 1 < files.length) {
            localStorage.setInt('current_wallpaper_index', current + 1);
          } else {
            current = -1;
            localStorage.setInt('current_wallpaper_index', -1);
          }

          await WallpaperChanger.change(files[current + 1].path);
        } else {
          print("not exist $myImagePath");
        }

        break;
    }
    //simpleTask will be emitted here.
    return Future.value(true);
  });
}

showNotification() async {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  var initializationSettingsAndroid =
      new AndroidInitializationSettings('ic_launcher');
  var initializationSettingsIOS = IOSInitializationSettings(
//        onDidReceiveLocalNotification: onDidReceiveLocalNotification
      );
  var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    navigatorKey.currentState.pushNamed("/");
  });
  var androidPlatformChannelSpecifics = AndroidNotificationDetails('0',
      'Updates Channel', 'Shows Notification When New Wallpapers Are Available',
      importance: Importance.Default,
      priority: Priority.Default,
      ticker: 'ticker',
      icon: "notification",
      channelShowBadge: true,
      largeIcon: "mipmap/ic_launcher",
      largeIconBitmapSource: BitmapSource.Drawable);
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(0, 'Fashion Wallpapers',
      'New Wallpapers Are Available!', platformChannelSpecifics,
      payload: '');
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  WallpaperBloc _bloc;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

//  BannerAd _bannerAd;

  MobileAdTargetingInfo targetingInfo;
  bool isCollapsed = true;
  double screenWidth, screenHeight;
  final Duration duration = const Duration(milliseconds: 200);
  AnimationController _controller;
  Animation<double> _scaleAnimation;
  Animation<double> _menuScaleAnimation;
  Animation<Offset> _slideAnimation;

  @override
  void initState() {
//    print('init my app');
    _bloc = WallpaperBloc();
    Helper.prepare(context);

//    showBannerAd();
    Helper.checkAndSetUpdates();
    initServices();
    initAnimations();
    initAppReview();
    super.initState();
  }

  initAppReview() {
    if (Platform.isIOS) {
      AppReview.requestReview.then((onValue) {
//        print(onValue);
      });
    }
    AppReview.getAppID.then((onValue) {
      setState(() {
//        appID = "com.aparat.filimo";
      });
//      print("App ID" + appID);
    });
  }

  initAnimations() {
    _controller = AnimationController(vsync: this, duration: duration);
    _scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(_controller);
    _menuScaleAnimation =
        Tween<double>(begin: 0.5, end: 1).animate(_controller);
    _slideAnimation = Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0))
        .animate(_controller);
  }

//  showBannerAd() {
//    Helper.bannerAd ??= Helper.createBannerAd();
//    Helper.bannerAd
//      ..load()
//      ..show(
//        anchorOffset: 0.0,
//        horizontalCenterOffset: 0.0,
//        anchorType: AnchorType.bottom,
//      );
//  }

  @override
  void dispose() {
    // TODO: implement dispose
    Helper.bannerAd?.dispose();
    _controller?.dispose();
//    print("dispose myapp");
    super.dispose();
  }

  initServices() {
    Workmanager.initialize(
      callbackDispatcher, // The top level function, aka callbackDispatcher
//      isInDebugMode:
//          true, // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
    );
    //Android only (see below)
    Workmanager.registerPeriodicTask(
      "fashionWallpapers.checkUpdate", //name
      CHECK_UPDATE, //task name
      existingWorkPolicy: ExistingWorkPolicy.replace,
      initialDelay: Duration(hours: 72),
      constraints: Constraints(
          networkType: NetworkType.connected,
          requiresBatteryNotLow: false,
          requiresCharging: false,
          requiresDeviceIdle: false,
          requiresStorageNotLow: false),
      frequency: Duration(hours: 24),
    );
  }

//  var schoolsBuilder = Helper.createRows();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;

    return Stack(children: <Widget>[
      menu(context),
      AnimatedPositioned(
        duration: duration,
        top: 0,
        bottom: 0,
        left: isCollapsed ? 0 : 0.25 * screenWidth,
        right: isCollapsed ? 0 : -0.3 * screenWidth,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: DefaultTabController(
            length: 5,
            child: Scaffold(
              appBar: AppBar(
                  backgroundColor: Colors.black,
                  leading: IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () {
                      setState(() {
                        if (isCollapsed)
                          _controller.forward();
                        else
                          _controller.reverse();
                        isCollapsed = !isCollapsed;
                      });
                    },
                  ),
                  title: Text("Fashion Wallpapers"),
                  bottom: TabBar(tabs: [
                    MyTab(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                                child: CircleAvatar(
//                        radius: 30.0,
                                    backgroundImage:
                                        AssetImage("images/1.jpg")),

                                // borde width
                                decoration: new BoxDecoration(
                                  color: const Color(0xFFFFFFFF),
                                  // border color
                                  shape: BoxShape.circle,
                                )),
                            Text(
                              "Woman",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    MyTab(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                                child: CircleAvatar(
//                        radius: 30.0,
                                    backgroundImage:
                                        AssetImage("images/2.jpg")),

                                // borde width
                                decoration: new BoxDecoration(
                                  color: const Color(0xFFFFFFFF),
                                  // border color
                                  shape: BoxShape.circle,
                                )),
                            Text(
                              "Man",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    MyTab(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                                child: CircleAvatar(
//                        radius: 30.0,
                                    backgroundImage:
                                        AssetImage("images/3.jpg")),

                                // borde width
                                decoration: new BoxDecoration(
                                  color: const Color(0xFFFFFFFF),
                                  // border color
                                  shape: BoxShape.circle,
                                )),
                            Text(
                              "Child",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    MyTab(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                                child: CircleAvatar(
//                        radius: 30.0,
                                    backgroundImage:
                                        AssetImage("images/4.jpg")),

                                // borde width
                                decoration: new BoxDecoration(
                                  color: const Color(0xFFFFFFFF),
                                  // border color
                                  shape: BoxShape.circle,
                                )),
                            Text(
                              "Home",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    MyTab(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                                child: CircleAvatar(
//                        radius: 30.0,
                                    backgroundImage:
                                        AssetImage("images/5.jpg")),

                                // borde width
                                decoration: new BoxDecoration(
                                  color: const Color(0xFFFFFFFF),
                                  // border color
                                  shape: BoxShape.circle,
                                )),
                            Text(
                              "Best",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ])),
              backgroundColor: Colors.black,
              body: BlocProvider<WallpaperBloc>(
                  bloc: _bloc,
                  child: TabBarView(
                    children: <Widget>[
                      HomePage(),
                      TabTwo(),
                      TabThree(),
                      TabFour(),
                      TabFavourites(),
                    ],
                  )),
            ),
          ),
        ),
      ),
    ]);
  }

  Widget menu(context) {
    return SlideTransition(
      position: _slideAnimation,
      child: ScaleTransition(
        scale: _menuScaleAnimation,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            setState(() {
              if (isCollapsed)
                _controller.forward();
              else
                _controller.reverse();
              isCollapsed = !isCollapsed;
            });
          },
          child: Stack(children: [
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment(1, 3),
                      colors: [Colors.blueGrey, Colors.blue, Colors.blueGrey])),
            ),
            Container(
              width: 0.3 * screenWidth,
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                      width: 0.3 * screenWidth,
                      child: Image(
                        fit: BoxFit.scaleDown,
                        image: AssetImage("images/icon.png"),
                      )),
                  FlatButton(
                    splashColor: Colors.white,
                    color: Colors.black,
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          fullscreenDialog: true,
                          builder: (BuildContext context) => AboutUs()));
                    },
                    child:
                        Text("About Us", style: TextStyle(color: Colors.white)),
                  ),
                  FlatButton(
                    splashColor: Colors.white,
                    color: Colors.black,
                    onPressed: () {
                      AppReview.requestReview.then((onValue) {
                        setState(() {
//                          output = onValue;
                        });
//                        print(onValue);
                      });
                    },
                    child:
                        Text("Rate App", style: TextStyle(color: Colors.white)),
                  ),
                  FlatButton(
                    splashColor: Colors.white,
                    color: Colors.black,
                    onPressed: () {
                      SystemChannels.platform
                          .invokeMethod<void>('SystemNavigator.pop');
                    },
                    child: Text("Exit", style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
