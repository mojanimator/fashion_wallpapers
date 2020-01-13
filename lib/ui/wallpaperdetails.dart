import 'dart:typed_data';

import 'package:connecting/helper/helper.dart';
import 'package:connecting/helper/variables.dart';
import 'package:connecting/model/wallpaper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';

class WallpaperDetails extends StatefulWidget {
  final Wallpaper wallpaper;

  WallpaperDetails({@required this.wallpaper});

  @override
  _WallpaperDetailsState createState() => _WallpaperDetailsState();
}

class _WallpaperDetailsState extends State<WallpaperDetails> {
//  bool loadFailed = false;
  Uint8List bytes;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("init details");

//    _getWallpaperImage(widget.wallpaper);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    print("didChangeDependencies");

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    print("dispose details");
    super.dispose();
  }

  @override
  void didUpdateWidget(WallpaperDetails oldWidget) {
    // TODO: implement didUpdateWidget
    print('did update');

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Builder(
          // Create an inner BuildContext so that the onPressed methods
          // can refer to the Scaffold with Scaffold.of().
          builder: (BuildContext context) {
        return ListView(
          padding: EdgeInsets.all(10.0),
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Hero(
                    tag: "image${widget.wallpaper.id}",
                    child: TransitionToImage(
//                      color: Colors
//                          .primaries[Random().nextInt(Colors.primaries.length)],
                      enableRefresh: true,

                      image: AdvancedNetworkImage(
                        Variable.STORAGE +
                            "/" +
                            widget.wallpaper.group_id.toString() +
                            "/" +
                            widget.wallpaper.path,

                        printError: false,
                        postProcessing: (Uint8List bytes) {
                          this.bytes = bytes;
//                          print('postProcessing');
//                          print('bytes');
//                          print(bytes);
                          return null;
                        },
                        loadedCallback: () {
//                          print('It works!');
//                          loadFailed = false;
                        },
                        loadFailedCallback: () {
//                          loadFailed = true;
//                          print('Oh, no!');
                        },
                        loadedFromDiskCacheCallback: () {
//                          print('loadedFromDiskCacheCallback');
                        },
//                        preProcessing: (bytes) async {
////                          print('preProcessing');
////                          return bytes;
//                        },

                        loadingProgress: (double progress, _) {
//                          print('Now Loading: $progress');
                        },
                        useDiskCache: true,
                        disableMemoryCache: true,
                        cacheRule: CacheRule(maxAge: const Duration(days: 3)),
                        retryLimit: 1,
                        timeoutDuration: Duration(minutes: 2),
                      ),
                      loadingWidgetBuilder: (_, double progress, __) => Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
//                          child:
                                TransitionToImage(
                                  width: double.infinity,
                                  image: AdvancedNetworkImage(
                                    Variable.STORAGE +
                                        "/" +
                                        widget.wallpaper.group_id.toString() +
                                        "/thumb-" +
                                        widget.wallpaper.path,
                                    postProcessing: (Uint8List bytes) {
                                      return null;
                                    },
                                  ),
                                ),

//                            CircularProgressIndicator(),
                                Container(
                                    padding: EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(.5),
                                        borderRadius:
                                            BorderRadius.circular(100.0)),
                                    margin: EdgeInsets.only(top: 10.0),
                                    child: Text(
                                      (progress * 100).toStringAsFixed(0) + "%",
                                      style: TextStyle(color: Colors.white),
                                    ))
                              ]),
                        ),
                      ),
                      placeholder: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 100.0),
                          ),
//                          Text("No Image Available!",
//                              style: TextStyle(
//                                  color: Colors.red,
//                                  fontWeight: FontWeight.bold)),
                          Center(
                            child: Icon(
                              Icons.refresh,
                              size: 100.0,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      fit: BoxFit.fitWidth,
                    )),
                SizedBox(
                  height: 30.0,
                ),
                OutlineButton(
                  color: Colors.white,
                  textColor: Colors.white,
                  borderSide: BorderSide(color: Colors.white),
                  child: Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                OutlineButton(
                    color: Colors.white,
                    textColor: Colors.white,
                    borderSide: BorderSide(color: Colors.white),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.wallpaper),
                        Text('Set As Wallpaper')
                      ],
                    ),
                    onPressed: () {
                      if (bytes == null)
                        Helper.showMessage(context, "No Image Available !");
                      else
                        Helper.setImageAsWallpaper(
                            context, bytes, widget.wallpaper.path);
                    }),
                OutlineButton(
                    color: Colors.white,
                    textColor: Colors.white,
                    borderSide: BorderSide(color: Colors.white),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.favorite),
                        Text('Add To Favourites')
                      ],
                    ),
                    onPressed: () {
                      if (bytes == null)
                        Helper.showMessage(context, "No Image Available !");
                      else
                        Helper.addWallpaperToFavourites(
                            context, bytes, widget.wallpaper.path);
                    }),
                OutlineButton(
                    color: Colors.white,
                    textColor: Colors.white,
                    borderSide: BorderSide(color: Colors.white),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.share),
                        Text('Share Wallpaper')
                      ],
                    ),
                    onPressed: () {
                      if (bytes == null)
                        Helper.showMessage(context, "No Image Available !");
                      else
                        Helper.shareImage(
                            bytes, widget.wallpaper.path, context);
                    }),
                OutlineButton(
                    color: Colors.white,
                    textColor: Colors.white,
                    borderSide: BorderSide(color: Colors.white),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.file_download),
                        Text('Download Wallpaper')
                      ],
                    ),
                    onPressed: () {
                      if (bytes == null)
                        Helper.showMessage(context, "No Image Available !");
                      else
                        Helper.saveWallpaper(
                            context, bytes, widget.wallpaper.path);
                    }),
              ],
            ),
          ],
        );
      }),
    );
  }

  _getWallpaperImage(Wallpaper w) async {
//    var request = await HttpClient().getUrl(Uri.parse(
//        Variable.STORAGE + "/" + w.group_id.toString() + "/" + w.path));
//    var response = await request.close();
//    bytes = await contextsolidateHttpClientResponseBytes(response);
//
//    assetImage = AssetImage(bytes);
////        headers: {"header": "value"})
//    print('get Image');
//    return assetImage;
  }
}
