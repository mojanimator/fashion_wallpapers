import 'dart:io';

import 'package:connecting/helper/variables.dart';
import 'package:connecting/model/wallpaper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FavCell extends StatefulWidget {
  const FavCell(this.wallpaper);

  @required
  final String wallpaper;

  @override
  _FavCellState createState() => _FavCellState();
}

class _FavCellState extends State<FavCell> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1)),
      color: Colors.black /*MyTheme.COLOR['blue']*/,
      child: Padding(
        padding: EdgeInsets.all(0.0),
        child: Container(
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
//            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Flexible(
                child: Container(
                    width: double.infinity,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(2.0)),
                    child: Image.file(
                      File(widget.wallpaper),
                      fit: BoxFit.cover,
                      key: Key("1"),
                    )),
//                        Image.memory(File(widget.wallpaper).readAsBytesSync())),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getWallpaperImage(Wallpaper w) {
    if (w.path != null) {
      // print(docs[0]['path']);
      return Variable.STORAGE +
          '/' +
          w.group_id.toString() +
          '/thumb-' +
//          '/' +
          w.path;
    } else {
      return Variable.DOMAIN + 'img/school-no.png';
    }
  }
}
