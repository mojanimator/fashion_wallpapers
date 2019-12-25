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

class TabTwo extends StatefulWidget {
  @override
  _TabTwoState createState() => _TabTwoState();
}

class _TabTwoState extends State<TabTwo>
    with WidgetsBindingObserver, AutomaticKeepAliveClientMixin {
  // StreamController<int> streamController = StreamController<int>();
  List<Wallpaper> wallpapers = List<Wallpaper>();

  WallpaperBloc _bloc;

  ScrollController _scrollController = ScrollController();

  _TabTwoState();

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

        _refreshData(int.parse(Variable.params2['page']) + 1);
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
    print("dispose page 2");
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
//    final WallpaperBloc _bloc = BlocProvider.of<WallpaperBloc>(context);
    return StreamBuilder<List<Wallpaper>>(
      stream: _bloc.stream,
      builder: (BuildContext context, AsyncSnapshot<List<Wallpaper>> snapshot) {
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
            if (snapshot.hasError) {
              return new Text(
                // Variable.ERROR[Variable.DISCONNECTED],
                '${snapshot.error}',
                style: TextStyle(fontSize: 24.0, color: Colors.black),
              );
            } else if (!snapshot.hasData) {
              return Container(child: Center(child: Text("Loading...")));
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
                          flex: 1,
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
  }

  Widget _grid(BuildContext context, Wallpaper wallpaper) {
    return GestureDetector(
      child: GridTile(
        child: WallpaperCell(wallpaper),
      ),
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          fullscreenDialog: true,
//          maintainState: true,
          builder: (BuildContext context) => WallpaperDetails(
                wallpaper: wallpaper,
              ))),
      onLongPress: () {},
    );
  }

  Future<void> _refreshData(int page) async {
    print('refresh');
    // print(wallpapers.length.toString() +'|'+  Variable.TOTAL_WALLPAPERS.toString());
    if (Variable.TOTAL_WALLPAPERS['2'] > 0 &&
        wallpapers.length >= Variable.TOTAL_WALLPAPERS['2']) return;
    if (page == 1) wallpapers.clear();

    Variable.params2['page'] = page.toString();
    setState(() {
      loading = true;
    });
    _bloc.sink.add(await Helper.getWallpapers(context, Variable.params2));
    setState(() {
      loading = false;
    });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
