import 'dart:async';

import 'package:connecting/helper/WallpaperBloc.dart';
import 'package:connecting/helper/helper.dart';
import 'package:connecting/helper/variables.dart';
import 'package:connecting/model/wallpaper.dart';
import 'package:connecting/ui/gridcell.dart';
import 'package:connecting/ui/wallpaperdetails.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with WidgetsBindingObserver, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  // StreamController<int> streamController = StreamController<int>();
  List<Wallpaper> wallpapers = List<Wallpaper>();

  WallpaperBloc _bloc;

  ScrollController _scrollController = ScrollController();

  _HomePageState();

  bool loading = true;

  @override
  void initState() {
    print("init");
    _bloc = BlocProvider.of<WallpaperBloc>(context);
    //   WidgetsBinding.instance.addObserver(this);
    SchedulerBinding.instance.addPostFrameCallback((_) => _refreshData(1));
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print('scroll');
        _refreshData(int.parse(Variable.params['page']) + 1);
      }
    });
    //   Helper.getLocalStorage();
    super.initState();
  }

//  @override
//  void didUpdateWidget(HomePage oldWidget) async {
//    // TODO: implement didUpdateWidget
////    if (widget.wallpapers != oldWidget.wallpapers) {
//
////    }
//    super.didUpdateWidget(oldWidget);
////    _bloc.dispose();
//    print('update');
//  }

  @override
  void dispose() {
    print("dispose page 1");
    _scrollController.dispose();
    // streamController.close();
    super.dispose();
//    _bloc.dispose();
    // this.bloc.dispose();
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   print(state);
  //   if (state == AppLifecycleState.resumed) {
  //     //do your stuff
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    super.build(context);
//    final WallpaperBloc _bloc = BlocProvider.of<WallpaperBloc>(context);
    return FutureBuilder<bool>(
      future: Helper.isNetworkConnected(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Center(child: CircularProgressIndicator());

          case ConnectionState.done:
            if (snapshot.hasData && snapshot.data == false) {
              return Center(
                child: RaisedButton(
                  color: Colors.transparent,
                  onPressed: () async {
                    if (await Helper.isNetworkConnected()) _refreshData(1);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Connection Failed! \n Please Check Your Network Connection',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                      Icon(
                        Icons.refresh,
                        color: Colors.white,
//                      size: 10.0,
                      )
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasData && snapshot.data == true) {
              return StreamBuilder<List<Wallpaper>>(
                stream: _bloc.stream,
                builder: (BuildContext context,
                    AsyncSnapshot<List<Wallpaper>> snapshot) {
//          print(bloc.stream);

                  print(snapshot.connectionState);

                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return new Text(Variable.DISCONNECTED);
                    case ConnectionState.waiting:
                      return new Center(child: CircularProgressIndicator());
                    case ConnectionState.done:
                      return new Text('done');
                    case ConnectionState.active:
//            print(snapshot.data);
                      if (snapshot.hasError) {
                        return new Text(
                          // Variable.ERROR[Variable.DISCONNECTED],
                          '${snapshot.error}',
                          style: TextStyle(fontSize: 24.0, color: Colors.black),
                        );
                      } else if (!snapshot.hasData) {
                        return Container(
                            child: Center(
                                child: Text(
                          "Loading...",
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

                        return RefreshIndicator(
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                  flex: 20,
                                  child: GridView.builder(
                                    controller: _scrollController,
                                    itemCount: wallpapers.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      // if (index ==
                                      //         wallpapers
                                      //             .length /*&&
                                      //     Variable.TOTAL_WALLPAPERS > wallpapers.length*/
                                      //     ) return CupertinoActivityIndicator();
                                      return _grid(context, wallpapers[index]);
                                    },
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
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
                            ),
                            onRefresh: () {
                              return _refreshData(1);
                            });
                      }

                      break;
                    default:
                      return Text('');
                  }
                } //return to page 1
                ,
              );
            } else {
              return Text('');
            }
            break;
          default:
            return Text('');
        }
      },
    );
  }

  Widget _grid(BuildContext context, Wallpaper wallpaper) {
    return GestureDetector(
      child: GridTile(
        child: WallpaperCell(wallpaper),
      ),
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          fullscreenDialog: true,
          maintainState: false,
          builder: (BuildContext context) => WallpaperDetails(
                wallpaper: wallpaper,
              ))),
      onLongPress: () {},
    );
  }

  Future<void> _refreshData(int page) async {
    if (!await Helper.isNetworkConnected()) return;
    // print(wallpapers.length.toString() +'|'+  Variable.TOTAL_WALLPAPERS.toString());
    if (page == 1) wallpapers.clear();
    if (Variable.TOTAL_WALLPAPERS['1'] > 0 &&
        wallpapers.length >= Variable.TOTAL_WALLPAPERS['1']) return;
    print('refresh');

    Variable.params['page'] = page.toString();
    setState(() {
      loading = true;
    });
    _bloc.sink.add(await Helper.getWallpapers(context, Variable.params));
    setState(() {
      loading = false;
    });
  }
}
