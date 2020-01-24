import 'dart:async';
import 'dart:io';

import 'package:connecting/extra/loaders.dart';
import 'package:connecting/helper/FavBloc.dart';
import 'package:connecting/helper/helper.dart';
import 'package:connecting/helper/variables.dart';
import 'package:connecting/ui/favgridcell.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallpaper_changer/wallpaper_changer.dart';
import 'package:workmanager/workmanager.dart';

class TabFavourites extends StatefulWidget {
  @override
  _TabFavouritesState createState() => _TabFavouritesState();
}

class _TabFavouritesState extends State<TabFavourites>
    with WidgetsBindingObserver {
  // StreamController<int> streamController = StreamController<int>();
  List<String> wallpapers = List<String>();

  ScrollController _scrollController = ScrollController();
  FavBloc _bloc;
  int _timerHours = 0;
  SharedPreferences localStorage;

  var key = GlobalKey();

  _TabFavouritesState();

  bool lockedAdService = false;
  BuildContext rootContext;
  bool loading = true;
  String adStatus = "";
  int remainedService;

  void setTimerRadioButton() async {
    Helper.localStorage = await SharedPreferences.getInstance();
    int timer = Helper.localStorage.getInt('timer_hours') ?? 0;
    remainedService = Helper.localStorage.getInt('remained_service') ?? 0;
    print(remainedService);
    if (timer == 0) {
      _timerHours = 0;
    } else
      _timerHours = timer;
  }

  @override
  void initState() {
    print("init fav");

    _bloc ??= FavBloc();

    setTimerRadioButton();
    imageCache.clear();
    //   WidgetsBinding.instance.addObserver(this);
    SchedulerBinding.instance.addPostFrameCallback((_) => _refreshData(1));
    _scrollController.addListener(() async {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (await Helper.isNetworkConnected())
          _refreshData(int.parse(Variable.params5['page']) + 1);
      }
    });
    super.initState();
  }

  @override
  void didUpdateWidget(TabFavourites oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    print("dispose page fav");
    _scrollController.dispose();
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
//    super.build(context);
//    final WallpaperBloc _bloc = BlocProvider.of<WallpaperBloc>(context);

    return Scaffold(
      key: key,
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.timer),
        onPressed: () async {
          if (!await Helper.hasPermission(PermissionGroup.storage, context)) {
            return;
          }
          if (wallpapers.length == 0) {
            Helper.showMessage(
                context, "First Select Some Images As Favourites");
            return;
          }

          showModalBottomSheet(
              backgroundColor: Colors.transparent,
              context: context,
              builder: (BuildContext context) {
                return StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                  void setRewardedAd() async {
                    localStorage ??= await SharedPreferences.getInstance();
                    //have service yet
                    if (localStorage.getInt("remained_service") != null &&
                        localStorage.getInt("remained_service") >= 1) {
                      lockedAdService = true;
                      return;
                    }
                    RewardedVideoAd.instance.listener =
                        (RewardedVideoAdEvent event,
                            {String rewardType, int rewardAmount}) {
                      if (event == RewardedVideoAdEvent.rewarded) {
                        localStorage.setInt('timer_hours', 1);
                        localStorage.setInt('remained_service', 48);
                        setState(() {
                          _timerHours = 1;
                          remainedService = 48;
                        });
                        setTimer(1);
                        Helper.loadRewardedVideo();
                        adStatus = "loading";
                        print("Reward " + rewardAmount.toString());
                      } else if (event == RewardedVideoAdEvent.failedToLoad) {
                        if (adStatus == "") {
                          adStatus = "failed";
                          _showDialog(context);
                        } else
                          adStatus = "failed";
//                        _showDialog(context);
//                        Helper.loadRewardedVideo();
                        print("RewardedVideoAdEvent.failedToLoad");
                      } else if (event == RewardedVideoAdEvent.loaded) {
                        adStatus = "loaded";
                        print("RewardedVideoAdEvent.loaded");
                      } else if (event == RewardedVideoAdEvent.completed) {
                        adStatus = "loading";
                        Helper.loadRewardedVideo();
                        print("RewardedVideoAdEvent.completed");
                      } else if (event == RewardedVideoAdEvent.closed) {
                        adStatus = "loading";
                        Helper.loadRewardedVideo();
                        print("RewardedVideoAdEvent.closed");
                      }
                    };
                  }

                  setRewardedAd();
                  setState(() {
                    remainedService = remainedService;
                  });
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.only(topRight: Radius.circular(50.0)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(top: 5.0),
                            child: Text(
                              "Auto Change Background",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                        ListTile(
                          onTap: () {
                            setState(() {
                              _timerHours = 0;
                              setTimer(_timerHours);
                            });
                          },
                          title: const Text('Off'),
                          leading: Radio(
                            value: 0,
                            groupValue: _timerHours,
                            onChanged: (value) {
                              setState(() {
                                _timerHours = value;
                                setTimer(_timerHours);
                              });
                            },
                          ),
                        ),
                        ListTile(
                          onTap: () {
                            setState(() {
                              if (lockedAdService) {
                                _timerHours = 1;
                                setTimer(_timerHours);
                              } else
                                _showDialog(context);
                            });
                          },
                          title: Row(
                            children: <Widget>[
                              const Text('Every Hour'),
                              Text(
                                "    $remainedService",
                                maxLines: 1,
                                overflow: TextOverflow.fade,
                                style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          leading: Radio(
                            value: 1,
                            groupValue: _timerHours,
                            onChanged: (value) {
                              setState(() {
                                if (lockedAdService) {
                                  _timerHours = 1;
                                  setTimer(_timerHours);
                                } else
                                  _showDialog(context);
                              });
                            },
                          ),
                        ),
                        ListTile(
                          onTap: () {
                            setState(() {
                              _timerHours = 24;
                              setTimer(_timerHours);
                            });
                          },
                          title: const Text('Every Day'),
                          leading: Radio(
                            value: 24,
                            groupValue: _timerHours,
                            onChanged: (value) {
                              setState(() {
                                _timerHours = value;
                                setTimer(_timerHours);
                              });
                            },
                          ),
                        ),
                        ListTile(
                          onTap: () {
                            setState(() {
                              _timerHours = 168;
                              setTimer(_timerHours);
                            });
                          },
                          title: const Text('Every Week'),
                          leading: Radio(
                            value: 168 /*24 * 7*/,
                            groupValue: _timerHours,
                            onChanged: (value) {
                              setState(() {
                                _timerHours = value;
                                setTimer(_timerHours);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                });
              });
        },
      ),
      body: RefreshIndicator(
        backgroundColor: Colors.white,
        onRefresh: () async {
          _refreshData(1);
        },
        child: StreamBuilder<List<String>>(
          stream: _bloc.stream,
          builder:
              (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
//          print(bloc.stream);

            print(snapshot.connectionState);
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return new Text(Variable.DISCONNECTED);
              case ConnectionState.waiting:
                return new Center(child: Loader());
              case ConnectionState.done:
                return new Text(
                  'No Images!',
                  style: TextStyle(fontSize: 24.0, color: Colors.white),
                );
              case ConnectionState.active:
//            print(snapshot.data);
                if (snapshot.hasError) {
                  return new Text(
                    // Variable.ERROR[Variable.DISCONNECTED],
                    '${snapshot.error}',
                    style: TextStyle(fontSize: 24.0, color: Colors.white),
                  );
                } else if (!snapshot.hasData) {
                  return Container(
                      child: Center(
                          child: Text(
                    "No Images!",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )));
                } else {
                  // streamController.sink.add(snapshot.data.length);
                  // if(snapshot.data.length==0) return;R
                  //  print(snapshot.data[0].id);
                  wallpapers.addAll(snapshot.data);
                  snapshot.data.clear();
//              print(wallpapers.length);

                  return Column(
                    children: <Widget>[
                      Expanded(
                        flex: 20,
                        child: GridView.builder(
                          controller: _scrollController,
                          itemCount: wallpapers.length,
                          itemBuilder: (BuildContext context, int index) {
                            // if (index ==
                            //         wallpapers
                            //             .length /*&&
                            //     Variable.TOTAL_WALLPAPERS > wallpapers.length*/
                            //     ) return CupertinoActivityIndicator();
                            return _grid(context, wallpapers[index]);
                          },
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: /* (orientation==Orientation.portrait)?2:*/ 3,
                              childAspectRatio: .8),
                        ),
                      ),
                      Visibility(
                        visible: loading,
                        child: Expanded(
                          flex: 5,
                          child: CupertinoActivityIndicator(),
                        ),
                      )
                    ],
                  );
                }

                break;
              default:
                return Text('');
            }
          } //return to page 1
          ,
        ),
      ),
    );
  }

  Widget _grid(BuildContext context, String wallpaper) {
    return PopupMenuButton(
      padding: EdgeInsets.all(1.0),
      child: GridTile(
        child: FavCell(wallpaper),
      ),
      onSelected: (value) async {
        print(value);
        switch (value) {
          case 0:
            final int result = await WallpaperChanger.change(wallpaper);
//      print(result);
            if (result != -1)
              Helper.showMessage(context, "Set As Wallpaper Successfully !");
            break;
          case 1:
            if (File(wallpaper).existsSync()) {
              File(wallpaper).delete();
              _refreshData(1);
            }
            break;
        }
      },
      itemBuilder: (BuildContext context) {
        return <PopupMenuItem<int>>[
          PopupMenuItem(
            value: 0,
            child: Text('Set As Wallpaper'),
          ),
          PopupMenuItem(
            value: 1,
            child: Text('Delete'),
          ),
        ];
      },
    );
  }

  Future<void> _refreshData(int page) async {
    print('refresh');

    // print(wallpapers.length.toString() +'|'+  Variable.TOTAL_WALLPAPERS.toString());

    if (page == 1) wallpapers.clear();

    Variable.params5['page'] = page.toString();
    setState(() {
      loading = true;
    });
    _bloc.sink.add(await Helper.getFavouriteWallpapers(page));

    setState(() {
      loading = false;
    });
  }

  void setTimer(int timerHours) {
//    print(timerHours);
    localStorage.setInt('timer_hours', timerHours);
    if (timerHours == 0)
      Workmanager.cancelByTag("changeWallpaper");
    else
      Workmanager.registerPeriodicTask(
        "fashionWallpapers.changeWallpaper", //name
        "changeWallpaper", //task name
        tag: "changeWallpaper",
        existingWorkPolicy: ExistingWorkPolicy.keep,
        initialDelay: Duration(seconds: 0),
        constraints: Constraints(
            networkType: NetworkType.not_required,
            requiresBatteryNotLow: false,
            requiresCharging: false,
            requiresDeviceIdle: false,
            requiresStorageNotLow: false),
        frequency: Duration(hours: timerHours),
      );
  }

  void _showDialog(BuildContext context) {
    if (adStatus == "failed") {
      showDialog(
          context: context,
          child: AlertDialog(
            title: const Text(""),
            content: const Text(
              "No Video Available Now. Please Try Later",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ));
      adStatus = "loading";
      Helper.loadRewardedVideo();
    } else if (adStatus == "loading") {
      showDialog(
          context: context,
          child: AlertDialog(
            title: const Text(""),
            content: const Text(
              "No Video Available Now. Please Try Later",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ));

      Helper.loadRewardedVideo();
    } else
      showDialog(
          context: context,
          child: AlertDialog(
            title: const Text(""),
            content: Text(
              "Play Video For 48 Hours Activation!",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            actions: <Widget>[
              FlatButton.icon(
                  onPressed: () {
                    Navigator.pop(context, null);
                    Helper.showRewardedVideo();
                  },
                  icon: Icon(Icons.play_arrow),
                  label: Text("Play")),
              FlatButton.icon(
                  onPressed: () => Navigator.pop(context, null),
                  icon: Icon(
                    Icons.cancel,
                    color: Colors.red,
                  ),
                  label: Text(
                    "Cancel",
                    style: TextStyle(color: Colors.red),
                  )),
            ],
          ));
  }
}
