import 'dart:async';
import 'dart:typed_data';

import 'package:connecting/helper/helper.dart';
import 'package:connecting/helper/variables.dart';
import 'package:connecting/model/wallpaper.dart';
import 'package:firebase_admob/firebase_admob.dart';
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
  InterstitialAd _interstitialAd;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    print("init details");
    setTimerForAd();
//    _getWallpaperImage(widget.wallpaper);
  }

  void setTimerForAd() async {
    Helper.showAdTimes++;
    if (Helper.showAdTimes % 5 == 0 && await Helper.isNetworkConnected()) {
      Timer(Duration(seconds: 5), () {
        if (bytes == null) {
          _interstitialAd?.dispose();
          _interstitialAd = Helper.createInterstitialAd()..load();
          _interstitialAd?.show();
        }
      });
    }
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Builder(
          // Create an inner BuildContext so that the onPressed methods
          // can refer to the Scaffold with Scaffold.of().
          builder: (BuildContext context) {
        return Stack(
          children: <Widget>[
            ListView(
              padding: EdgeInsets.only(
                  left: 10.0, right: 10.0, top: 10.0, bottom: 88.0),
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Hero(
                        tag: "image${widget.wallpaper.id}",
                        child: TransitionToImage(
                          duration: Duration(seconds: 0),
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
                            cacheRule:
                                CacheRule(maxAge: const Duration(days: 3)),
                            retryLimit: 1,
                            timeoutDuration: Duration(minutes: 2),
                          ),

                          loadingWidgetBuilder: (_, double progress, __) =>
                              Center(
                            child:
                                Stack(alignment: Alignment.center, children: <
                                    Widget>[
//                          child:
                              TransitionToImage(
                                key: Key("1"),
                                duration: Duration(seconds: 0),
                                width: double.infinity,
                                image: AdvancedNetworkImage(
                                    Variable.STORAGE +
                                        "/" +
                                        widget.wallpaper.group_id.toString() +
                                        "/thumb-" +
                                        widget.wallpaper.path,
                                    postProcessing: (Uint8List bytes) {
                                  return null;
                                }, disableMemoryCache: false),
                              ),

//                            CircularProgressIndicator(),
                              Container(
                                  alignment: Alignment.center,
                                  height: MediaQuery.of(context).size.width / 5,
                                  width: MediaQuery.of(context).size.width / 5,
                                  padding: EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(.8),
                                      borderRadius:
                                          BorderRadius.circular(100.0)),
                                  margin: EdgeInsets.only(top: 10.0),
                                  child: Text(
                                    (progress * 100).toStringAsFixed(0) + "%",
                                    style: TextStyle(color: Colors.white),
                                  )),
                            ]),
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
                  ],
                ),
              ],
            ),
            Positioned(
                bottom: 0,
                child: Container(
                  color: Colors.black26.withOpacity(0.5),
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Material(
                          color: Colors.transparent,
                          child: Ink(
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.white, width: 2.0),
                              color: Colors.black,
                              shape: BoxShape.circle,
                            ),
                            child: InkWell(
                              //This keeps the splash effect within the circle
                              borderRadius: BorderRadius.circular(1000.0),
                              //Something large to ensure a circle
                              onTap: () => Navigator.of(context).pop(),
                              child: Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )),
                      Material(
                          color: Colors.transparent,
                          child: Ink(
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.white, width: 2.0),
                              color: Colors.black,
                              shape: BoxShape.circle,
                            ),
                            child: InkWell(
                              //This keeps the splash effect within the circle
                              borderRadius: BorderRadius.circular(1000.0),
                              //Something large to ensure a circle
                              onTap: () {
                                if (bytes == null)
                                  Helper.showMessage(
                                      context, "No Image Available !");
                                else
                                  Helper.setImageAsWallpaper(
                                      context, bytes, widget.wallpaper.path);
                              },
                              child: Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Icon(
                                  Icons.wallpaper,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )),
                      Material(
                          color: Colors.transparent,
                          child: Ink(
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.white, width: 2.0),
                              color: Colors.black,
                              shape: BoxShape.circle,
                            ),
                            child: InkWell(
                              //This keeps the splash effect within the circle
                              borderRadius: BorderRadius.circular(1000.0),
                              //Something large to ensure a circle
                              onTap: () {
                                if (bytes == null)
                                  Helper.showMessage(
                                      context, "No Image Available !");
                                else
                                  Helper.addWallpaperToFavourites(
                                      context, bytes, widget.wallpaper.path);
                              },
                              child: Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Icon(
                                  Icons.favorite,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )),
                      Material(
                          color: Colors.transparent,
                          child: Ink(
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.white, width: 2.0),
                              color: Colors.black,
                              shape: BoxShape.circle,
                            ),
                            child: InkWell(
                              //This keeps the splash effect within the circle
                              borderRadius: BorderRadius.circular(1000.0),
                              //Something large to ensure a circle
                              onTap: () {
                                if (bytes == null)
                                  Helper.showMessage(
                                      context, "No Image Available !");
                                else
                                  Helper.shareImage(
                                      bytes, widget.wallpaper.path, context);
                              },
                              child: Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Icon(
                                  Icons.share,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )),
                    ],
                  ),
                )),
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
