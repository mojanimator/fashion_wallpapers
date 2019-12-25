import 'package:connecting/helper/variables.dart';
import 'package:connecting/model/wallpaper.dart';
import 'package:flutter/material.dart';

class WallpaperCell extends StatelessWidget {
  const WallpaperCell(this.wallpaper);

  @required
  final Wallpaper wallpaper;

  @override
  Widget build(BuildContext context) {
    return GridView.extent(
      maxCrossAxisExtent: 150.0,
      mainAxisSpacing: 8.0,
      crossAxisSpacing: 8.0,
      padding: EdgeInsets.all(3.0),
      children: <Widget>[
        Container(
          color: Colors.black,
          constraints: BoxConstraints.tightFor(height: double.infinity),
          child: FadeInImage.assetNetwork(
            placeholder: "images/no-image.jpg",
            image: _getWallpaperImage(wallpaper),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        )
      ],
    );
  }

  String _getWallpaperImage(Wallpaper w) {
    if (w.path != null) {
      // print(docs[0]['path']);
      return Variable.STORAGE +
          '/' +
          w.group_id.toString() +
          '/thumb-' +
          w.path;
    } else {
      return Variable.DOMAIN + 'img/school-no.png';
    }
  }
}

//List<Widget> _buildGridTiles(numberOfImage) {
//  List<Container> containers =
//      List<Container>.generate(numberOfImage, (int index) {
//    final ImageName = index < 9
//        ? 'images/image0${index + 1}.jpg'
//        : 'images/image${index + 1}.jpg';
//    return Container(
//      child: FadeInImage.assetNetwork(
//          placeholder: "images/no-image.jpg",
//          image: _getWallpaperImage(wallpaper),
//          fit: BoxFit.fill),
//    );
//  });
//  return containers;
//}
