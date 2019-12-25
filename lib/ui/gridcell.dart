import 'package:connecting/helper/variables.dart';
import 'package:connecting/model/wallpaper.dart';
import 'package:flutter/material.dart';

class WallpaperCell extends StatelessWidget {
  const WallpaperCell(this.wallpaper);

  @required
  final Wallpaper wallpaper;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      color: Colors.black /*MyTheme.COLOR['blue']*/,
      child: Padding(
        padding: EdgeInsets.all(2.0),
        child: Container(
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Flexible(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Hero(
                      tag: "image${wallpaper.id}",
                      child: Container(
                        constraints:
                            BoxConstraints.tightFor(height: double.infinity),
                        child: Stack(
                          children: <Widget>[
                            Center(child: CircularProgressIndicator()),
                            FadeInImage.assetNetwork(
                              placeholder: "images/no-image.jpg",
                              image: _getWallpaperImage(wallpaper),
                              fit: BoxFit.fitWidth,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ],
                        ),
                      )),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  wallpaper.size.toString() + ' Kb',
                  maxLines: 1,
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
              )
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
