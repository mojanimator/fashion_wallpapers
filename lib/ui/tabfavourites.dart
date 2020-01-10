import 'dart:async';
import 'dart:io';

import 'package:connecting/helper/FavBloc.dart';
import 'package:connecting/helper/helper.dart';
import 'package:connecting/helper/variables.dart';
import 'package:connecting/ui/favgridcell.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class TabFavourites extends StatefulWidget {
  @override
  _TabFavouritesState createState() => _TabFavouritesState();
}

class _TabFavouritesState extends State<TabFavourites>
    with WidgetsBindingObserver, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => false;

  // StreamController<int> streamController = StreamController<int>();
  List<String> wallpapers = List<String>();

  ScrollController _scrollController = ScrollController();
  FavBloc _bloc;

  _TabFavouritesState();

  bool loading = true;

  @override
  void initState() {
    print("init");
    _bloc ??= FavBloc();
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
    return RefreshIndicator(
      onRefresh: () async {
        _refreshData(1);
      },
      child: StreamBuilder<List<String>>(
        stream: _bloc.stream,
        builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
//          print(bloc.stream);

          print(snapshot.connectionState);
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return new Text(Variable.DISCONNECTED);
            case ConnectionState.waiting:
              return new Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              return new Text('No Images!');
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
}
