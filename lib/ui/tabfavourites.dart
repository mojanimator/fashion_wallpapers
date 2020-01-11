import 'dart:async';
import 'dart:io';

import 'package:connecting/helper/FavBloc.dart';
import 'package:connecting/helper/helper.dart';
import 'package:connecting/helper/variables.dart';
import 'package:connecting/ui/favgridcell.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

class TabFavourites extends StatefulWidget {
  @override
  _TabFavouritesState createState() => _TabFavouritesState();
}

class _TabFavouritesState extends State<TabFavourites>
    with WidgetsBindingObserver, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  // StreamController<int> streamController = StreamController<int>();
  List<String> wallpapers = List<String>();

  ScrollController _scrollController = ScrollController();
  FavBloc _bloc;
  int _timerHours = 0;
  SharedPreferences localStorage;

  _TabFavouritesState();

  bool loading = true;

  void setTimerRadioButton() async {
    localStorage = await SharedPreferences.getInstance();
    int timer = localStorage.getInt('timer_hours');
    if (timer == null || timer == 0) {
      _timerHours = 0;
    } else
      _timerHours = timer;
  }

  @override
  void initState() {
    print("init fav");
    _bloc ??= FavBloc();
    setTimerRadioButton();
    //   WidgetsBinding.instance.addObserver(this);
    SchedulerBinding.instance.addPostFrameCallback((_) => _refreshData(1));
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print('scroll');
        _refreshData(int.parse(Variable.params5['page']) + 1);
      }
    });
    super.initState();
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
    super.build(context);
//    final WallpaperBloc _bloc = BlocProvider.of<WallpaperBloc>(context);
    return Scaffold(
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
              context: context,
              builder: (BuildContext context) {
                return StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
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
                                _timerHours = 1;
                                setTimer(_timerHours);
                              });
                            },
                            title: const Text('Every Hour'),
                            leading: Radio(
                              value: 1,
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
                      ));
                });
              });
        },
      ),
      body: RefreshIndicator(
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
                return new Center(child: CircularProgressIndicator());
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
                              crossAxisCount: /* (orientation==Orientation.portrait)?2:*/ 3),
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
            final int result = await Variable.platform
                .invokeMethod('getWallpaper', {"text": wallpaper});
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
    print(timerHours);
    localStorage.setInt('timer_hours', timerHours);
    if (timerHours == 0)
      Workmanager.cancelByTag("changeWallpaper");
    else
      Workmanager.registerPeriodicTask(
        "fashionWallpapers.changeWallpaper", //name
        "changeWallpaper", //task name
        tag: "changeWallpaper",
        existingWorkPolicy: ExistingWorkPolicy.replace,
        initialDelay: Duration(seconds: 11),
        constraints: Constraints(
            networkType: NetworkType.not_required,
            requiresBatteryNotLow: false,
            requiresCharging: false,
            requiresDeviceIdle: false,
            requiresStorageNotLow: false),
        frequency: Duration(hours: timerHours),
      );
  }
}
