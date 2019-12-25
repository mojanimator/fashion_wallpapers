import 'package:connecting/helper/helper.dart';
import 'package:connecting/helper/variables.dart';
import 'package:connecting/model/wallpaper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WallpaperDetails extends StatefulWidget {
  final Wallpaper wallpaper;

  WallpaperDetails({@required this.wallpaper});

  @override
  _WallpaperDetailsState createState() => _WallpaperDetailsState();
}

class _WallpaperDetailsState extends State<WallpaperDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  child: Stack(
                    children: <Widget>[
                      Image.asset("images/no-image.gif"),
                      FadeInImage.assetNetwork(
                        placeholder: "images/no-image.jpg",
                        image: _getWallpaperImage(widget.wallpaper),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                OutlineButton(
                  child: Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                OutlineButton(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.wallpaper),
                      Text('Set As Wallpaper')
                    ],
                  ),
                  onPressed: () => Helper.setImageAsWallpaper(
                      context,
                      widget.wallpaper.group_id.toString(),
                      widget.wallpaper.path),
                ),
                OutlineButton(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.share),
                      Text('Share Wallpaper')
                    ],
                  ),
                  onPressed: () => Helper.shareImageFromUrl(
                      widget.wallpaper.group_id.toString(),
                      widget.wallpaper.path),
                ),
                OutlineButton(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.file_download),
                      Text('Download Wallpaper')
                    ],
                  ),
                  onPressed: () => Helper.saveWallpaper(
                      context,
                      widget.wallpaper.group_id.toString(),
                      widget.wallpaper.path),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }

  _getWallpaperImage(Wallpaper w) {
    if (w.path != null) {
      // print(docs[0]['path']);
      return Variable.STORAGE + '/' + w.group_id.toString() + '/' + w.path;
    } else {
      return Variable.DOMAIN + 'img/school-no.png';
    }
  }
}
