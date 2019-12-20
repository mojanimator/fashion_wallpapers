import 'package:flutter/services.dart';

class Variable {
  static String DOMAIN =
      /* "https://qr-image-creator.com/wallpapers"*/ "http://10.0.3.2:8000";
  static String APIDOMAIN = "${DOMAIN}/api";

  static String LINK_WALLPAPERS = "${APIDOMAIN}/doc/search";
  static String LINK_GROUPS = "${APIDOMAIN}/doc/groups";

  static String STORAGE = "${DOMAIN}/storage";

  static String LOGIN = "${APIDOMAIN}/login";
  static String LOGOUT = "${APIDOMAIN}/logout";

  static String COMMAND_REFRESH_SCHOOLS = "REFRESH_SCHOOLS";
  static String DISCONNECTED = "Please Check Internet Connection!";

  static Map<String, dynamic> params = {'page': '1', 'group_id': '1'};
  static int TOTAL_WALLPAPERS = 0;
  static const platform = const MethodChannel('wallpaper');
  static Map<String, String> ERROR = {
    "DISCONNECTED": "اتصال برقرار نیست",
  };
}

enum Commands { RefreshWallpapers }
