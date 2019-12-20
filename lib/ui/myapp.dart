import 'package:connecting/helper/WallpaperBloc.dart';
import 'package:connecting/helper/helper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'homepage.dart';

//@immutable
//class AppState {
//  final command;
//
//  AppState(this.command);
//}
//
//enum Actions { Refresh }
//
//AppState commander(AppState prev, action) {
//  if (action == Actions.Refresh) {
////    print(Variable.COMMAND_REFRESH_SCHOOLS);
//    return AppState(Variable.COMMAND_REFRESH_SCHOOLS);
//  }
//  return prev;
//}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  WallpaperBloc _bloc;

//  Future<void> a = Helper.getToken();
//  final store = Store(commander,
//      initialState: AppState(Variable.COMMAND_REFRESH_SCHOOLS));

  SharedPreferences localStorage;

  @override
  void initState() {
    print('init my app');
    Helper.getLocalStorage();
    super.initState();

    _bloc = WallpaperBloc();
  }

//  var schoolsBuilder = Helper.createRows();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            //TODO:
          },
        ),
        title: Text("Fashion Wallpapers"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              //TODO:
            },
          )
        ],
      ),
      body: BlocProvider<WallpaperBloc>(
        bloc: _bloc,
        child: HomePage(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.refresh,
        ),
        onPressed: () async {
//            List<School> a = await Helper.getSchools();
//            bloc.sink.add(await Future.delayed(const Duration(seconds: 3)));
          // bloc.sink.add(
          // await Helper.getSchools(appContext, Variable.schoolParams));
        },
      ),
    );
  }
}
