import 'dart:async';

import 'package:connecting/extra/loaders.dart';
import 'package:connecting/helper/WallpaperBloc.dart';
import 'package:connecting/helper/helper.dart';
import 'package:connecting/helper/variables.dart';
import 'package:connecting/model/wallpaper.dart';
import 'package:connecting/ui/gridcell.dart';
import 'package:connecting/ui/wallpaperdetails.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class TabThree extends StatefulWidget {
  @override
  _TabThreeState createState() => _TabThreeState();
}

class _TabThreeState extends State<TabThree>
    with WidgetsBindingObserver, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => false;

  // StreamController<int> streamController = StreamController<int>();
  List<Wallpaper> wallpapers = List<Wallpaper>();

  WallpaperBloc _bloc;

  ScrollController _scrollController = ScrollController();

  _TabThreeState();

  bool loading = true;

  @override
  void initState() {
//    print("init 3");
//    _bloc = BlocProvider.of<WallpaperBloc>(context);
    _bloc ??= WallpaperBloc();
    //   WidgetsBinding.instance.addObserver(this);
    SchedulerBinding.instance.addPostFrameCallback((_) => _refreshData(1));
    _scrollController.addListener(() async {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (await Helper.isNetworkConnected())
          _refreshData(int.parse(Variable.params3['page']) + 1);
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
//    print("dispose page 3");
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
    return RefreshIndicator(
      backgroundColor: Colors.white,
      onRefresh: () => _refreshData(1),
      child: StreamBuilder<List<Wallpaper>>(
        stream: _bloc.stream,
        builder:
            (BuildContext context, AsyncSnapshot<List<Wallpaper>> snapshot) {
//          print(bloc.stream);

          print(snapshot.connectionState);

          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return new Text(Variable.DISCONNECTED);
            case ConnectionState.waiting:
              return new Center(child: Loader());
            case ConnectionState.done:
              return new Text('done');
            case ConnectionState.active:
//            print(snapshot.data);
              if (snapshot.hasError || !snapshot.hasData) {
                return Container(
                    child: Center(
                        child: IconButton(
                  padding: EdgeInsets.all(10.0),
                  iconSize: MediaQuery.of(context).size.width / 6,
                  icon: Icon(
                    Icons.refresh,
                    color: Colors.white70,
                  ),
                  onPressed: () {
                    _refreshData(1);
                  },
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
                      child: CupertinoActivityIndicator(),
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
    // print(wallpapers.length.toString() +'|'+  Variable.TOTAL_WALLPAPERS.toString());
    if (page == 1) wallpapers.clear();
    if (Variable.TOTAL_WALLPAPERS['3'] > 0 &&
        wallpapers.length >= Variable.TOTAL_WALLPAPERS['3']) return;
//    print('refresh');

    Variable.params3['page'] = page.toString();
    if (mounted)
      setState(() {
        loading = true;
      });
    else
      loading = true;
    _bloc.sink.add(await Helper.getWallpapers(context, Variable.params3));
    if (mounted)
      setState(() {
        loading = false;
      });
    else
      loading = false;
  }
}
