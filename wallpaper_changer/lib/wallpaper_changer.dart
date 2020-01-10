import 'dart:async';

import 'package:flutter/services.dart';

class WallpaperChanger {
  static const MethodChannel _channel =
      const MethodChannel('wallpaper_changer');

  static Future<int> change(String path) async {
    final int res = await _channel.invokeMethod('getWallpaper', {"text": path});
    return res;
  }
}
