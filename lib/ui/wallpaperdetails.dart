import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:connecting/extra/MyPainter.dart';
import 'package:connecting/extra/loaders.dart';
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

class _WallpaperDetailsState extends State<WallpaperDetails>
    with AutomaticKeepAliveClientMixin {
  int MEGABYTE = 1024 * 1024;

  TransitionToImage transition;

  AdvancedNetworkImage advancedNetworkImage;
  Image thumbImage;

  CustomPaint myPaint = CustomPaint(
    painter: MyPainter(),
    willChange: true,
    size: Size(0, 0),
  );

  @override
  bool get wantKeepAlive => false;

//  bool loadFailed = false;
  Uint8List bytes;
  InterstitialAd _interstitialAd;

  bool loaded = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("init details");
    bytes = null;
    setTimerForAd();

    thumbImage = Image.network(Variable.STORAGE +
        "/" +
        widget.wallpaper.group_id.toString() +
        "/thumb-" +
        widget.wallpaper.path);

    advancedNetworkImage = AdvancedNetworkImage(
      Variable.STORAGE +
          "/" +
          widget.wallpaper.group_id.toString() +
          "/" +
          widget.wallpaper.path,
      useDiskCache: true,
      disableMemoryCache: true,
      printError: true,
      postProcessing: (Uint8List bytes) async {
        if (this.bytes == null)
          setState(() {
            this.bytes = bytes;
          });
//        print('postProcessing');
//                          print('bytes');
//                          print(bytes);

        return bytes;
      },
      loadedCallback: () {
//        print('image loadedCallback');
//                          loadFailed = false;
      },
      loadFailedCallback: () {
//                          loadFailed = true;
//        print('Oh, no!');
      },
      loadedFromDiskCacheCallback: () {
//        print('loadedFromDiskCacheCallback');
      },
      retryLimit: 1,
      timeoutDuration: Duration(seconds: 30),
      cacheRule: CacheRule(
          maxAge: const Duration(days: 3),
          storeDirectory: StoreDirectoryType.temporary),
    );

    precacheImage(advancedNetworkImage, context);

//    print(
//        "Total physical memory   : ${SysInfo.getTotalPhysicalMemory() ~/ MEGABYTE} MB");
//    print(
//        "Free physical memory    : ${SysInfo.getFreePhysicalMemory() ~/ MEGABYTE} MB");
//    print(
//        "Total virtual memory    : ${SysInfo.getTotalVirtualMemory() ~/ MEGABYTE} MB");

//    print(
//        "Virtual memory size     : ${SysInfo.getVirtualMemorySize() ~/ MEGABYTE} MB");
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
  void dispose() async {
    _interstitialAd?.dispose();
    super.dispose();
    print("details dispose");

//    WallpaperChanger.clearMemory();
//    myPaint.painter.paint(canvas, size);
//    DrawCircle c = DrawCircle();
    Canvas c = Canvas(PictureRecorder());
    Paint p = Paint();

    c.drawCircle(Offset.zero, 0, p);
    c.restore();
    c.drawCircle(Offset.zero, 0, p);

//    c.drawImage(, Offset.zero, p);
//    c.paint(canvas, size);
//    print(
//        "Free virtual memory     : ${SysInfo.getFreeVirtualMemory() ~/ MEGABYTE} MB");
//    print(DiskCache().currentEntries);
//    print(DiskCache().maxSizeBytes / 1024 / 1024);
//    print(await DiskCache().cacheSize() / 1024 / 1024);
//    if (imageCache.currentSize > 5) imageCache.clear();
//    print(imageCache.currentSize);
  }

  @override
  Widget build(BuildContext context) {
    print("build");
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Builder(builder: (BuildContext context) {
//        print("build");
        return Stack(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(10.0),
              child: Stack(
                children: <Widget>[
                  Hero(
                      tag: "image${widget.wallpaper.id}",
                      child: //
                          TransitionToImage(
                        duration: Duration(seconds: 0),
                        forceRebuildWidget: false,
                        longPressForceRefresh: true,
                        disableMemoryCacheIfFailed: true,
                        disableMemoryCache: true,
                        loadedCallback: () async {
                          if (mounted)
                            setState(() {
                              loaded = true;
                            });

                          print("TransitionToImage loadedCallback");
                        },
                        enableRefresh: true,
                        image: advancedNetworkImage,
                        loadingWidgetBuilder: (_, double progress, __) {
                          return Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              thumbImage,
                              Visibility(
                                child: /*Loader(),*/
                                    Container(
                                  alignment: Alignment.center,
                                  height: MediaQuery.of(context).size.width / 5,
                                  width: MediaQuery.of(context).size.width / 5,
                                  padding: EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(.8),
                                      borderRadius:
                                          BorderRadius.circular(100.0)),
                                  child: Text(
                                    (progress * 100).toStringAsFixed(0) + "%",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                visible: progress > 0.1,
                              ),
                              Visibility(
                                child: /*Loader(),*/
                                    Container(
                                        alignment: Alignment.center,
                                        height:
                                            MediaQuery.of(context).size.width /
                                                5,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                5,
                                        padding: EdgeInsets.all(10.0),
                                        decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(.8),
                                            borderRadius:
                                                BorderRadius.circular(100.0)),
                                        child: Loader()),
                                visible: progress <= 0.1,
                              ),
                            ],
                          );
                        },
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
                  Visibility(
                    visible: loaded,
                    child: Positioned(
                      bottom: 0,
                      left: 0,
                      child: Container(
//                            width: MediaQuery.of(context).size.width,
//                            padding: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1.0),
                          color: Colors.blue,
                        ),
                        child: Text(
                          widget.wallpaper.link,
                          maxLines: 1,
                          softWrap: true,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: loaded,
              child: Positioned(
                  bottom: 48,
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
                                onTap: () async {
//                                print();
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
            ),
          ],
        );
      }),
    );
  }
}
