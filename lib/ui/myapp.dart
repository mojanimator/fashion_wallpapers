import 'package:connecting/helper/WallpaperBloc.dart';
import 'package:connecting/helper/helper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'homepage.dart';
import 'tabfour.dart';
import 'tabthree.dart';
import 'tabtwo.dart';

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
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        drawer: Drawer(
          child: Column(
            children: <Widget>[
              ListTile(
                  title: Text("Page One"),
                  trailing: Icon(
                    Icons.arrow_upward,
                    color: Colors.white,
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed("/a");
                  }),
              ListTile(
                title: Text("Page Two"),
                trailing: Icon(
                  Icons.arrow_downward,
                  color: Colors.white,
                ),
                onTap: () {
//
                },
              ),
              Divider(),
              ListTile(
                title: Text("Close"),
                trailing: Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                onTap: () => Navigator.of(context).pop(CloseButton),
              ),
              ListTile(
                title: Text("about as"),
                trailing: Icon(
                  Icons.extension,
                  color: Colors.white,
                ),
              ),
              ListTile(
                title: Text("Login"),
                trailing: Icon(
                  Icons.supervised_user_circle,
                  color: Colors.white,
                ),
//                onTap: () =>
//                    Navigator.push(context,
//                        MaterialPageRoute(builder: (context) => Login())),
              ),
              Expanded(
                child: Align(
                  alignment: FractionalOffset.bottomRight,
                  child: MaterialButton(
                    child: Icon(
                      Icons.settings,
                      size: 45.0,
                    ),
                    onPressed: () {},
                  ),
                ),
              ),
            ],
          ),
        ),
        appBar: AppBar(
            backgroundColor: Colors.black,
//              leading: IconButton(
//                icon: Icon(Icons.menu),
//                onPressed: () {
//                  //TODO:
//                },
//              ),
            title: Text("Fashion Wallpapers"),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  //TODO:
                },
              )
            ],
            bottom: TabBar(tabs: [
              Tab(
                child: Container(
                    child: CircleAvatar(
//                            radius: 30.0,
                        backgroundImage: AssetImage("images/1.jpg")),
                    padding: EdgeInsets.all(3.0), // borde width
                    decoration: new BoxDecoration(
                      color: const Color(0xFFFFFFFF), // border color
                      shape: BoxShape.circle,
                    )),
              ),
              Tab(
                child: Container(
                    child: CircleAvatar(
//                            radius: 30.0,
                        backgroundImage: AssetImage("images/2.jpg")),
                    padding: const EdgeInsets.all(3.0), // borde width
                    decoration: new BoxDecoration(
                      color: const Color(0xFFFFFFFF), // border color
                      shape: BoxShape.circle,
                    )),
              ),
              Tab(
                child: Container(
                    child: CircleAvatar(
//                            radius: 30.0,
                        backgroundImage: AssetImage("images/3.jpg")),
                    padding: const EdgeInsets.all(3.0), // borde width
                    decoration: new BoxDecoration(
                      color: const Color(0xFFFFFFFF), // border color
                      shape: BoxShape.circle,
                    )),
              ),
              Tab(
                child: Container(
                    child: CircleAvatar(
//                            radius: 30.0,
                        backgroundImage: AssetImage("images/4.jpg")),
                    padding: const EdgeInsets.all(3.0), // borde width
                    decoration: new BoxDecoration(
                      color: const Color(0xFFFFFFFF), // border color
                      shape: BoxShape.circle,
                    )),
              ),

//                      Tab(
//                        child: Container(
//                            decoration: BoxDecoration(
//                                shape: BoxShape.circle,
//                                image: DecorationImage(
//                                    fit: BoxFit.fill,
//                                    image: AssetImage("images/01.jpg")))),
//                      )
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
              ],
            )),

//                  TabTwo(),
//                  TabThree(),
//                  TabFour(),
      ),
//      floatingActionButton: FloatingActionButton(
//        child: Icon(
//          Icons.refresh,
//        ),
//        onPressed: () async {
////            List<School> a = await Helper.getSchools();
////            bloc.sink.add(await Future.delayed(const Duration(seconds: 3)));
//          // bloc.sink.add(
//          // await Helper.getSchools(appContext, Variable.schoolParams));
//        },
//      ),
    );
  }
}
