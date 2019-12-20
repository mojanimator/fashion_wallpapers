import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:connecting/helper/variables.dart';
import 'package:connecting/model/wallpaper.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker_saver/image_picker_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Helper {
  static var client = http.Client();
  static SharedPreferences localStorage;

  static String accessToken;
  static String refreshToken;
  static String username;
  static String name;
  static String family;
  static String phoneNumber;
  SnackBar snackBar;

  static Future<SharedPreferences> getLocalStorage() async {
    localStorage = await SharedPreferences.getInstance();
    accessToken = localStorage.getString('access_token');
    refreshToken = localStorage.getString('refresh_token');
    username = localStorage.getString('username');
    name = localStorage.getString('name');
    family = localStorage.getString('family');
    phoneNumber = localStorage.getString('phone_number');
    return localStorage;
  }

/*
  static login(context, username, password) {
    return client.post(Variable.LOGIN, headers: {
      'Accept': 'application/json',
      // 'Authorization': 'Bearer ' + accessToken
    }, body: {
      'username': username,
      'password': password,
    }).then((http.Response response) {
      print('then');

      var parsedJson = json.decode(response.body);
      if (parsedJson['access_token'] != null) {
        localStorage.setString('access_token', parsedJson['access_token']);
      }
      if (parsedJson['refresh_token'] != null) {
        localStorage.setString('refresh_token', parsedJson['refresh_token']);
      }
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyApp()),
      );
    }).catchError((e) {
      print(json.decode(e.message));
      print(e);
      _showMessage(context, json.decode(e.message));
    });
  }
*/
  /*static logout(context) {
    return client.post(Variable.LOGOUT, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + accessToken
    }, body: {}).then((http.Response response) {
      // print(response.body);

      var parsedJson = json.decode(response.body);
      print('logout');
      print(response.body);
      //status 400=user not found
      //status 200=successfull logout
      if (parsedJson['status'] != null &&
              (parsedJson['status'] == 200 || parsedJson['status'] == 400) ||
          (parsedJson['message'] != null &&
              parsedJson['message'].contains('Unauthenticated'))) {
        localStorage.setString('access_token', null);
        localStorage.setString('refresh_token', null);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else {
        _showMessage(context, 'خطایی رخ داد  ');
      }
    }).catchError((e) {
      _showMessage(context, json.decode(e.message));
      print(json.decode(e.message));
      print(e);
    });
  }
*/
  static Future<List<Wallpaper>> getWallpapers(context, params) async {
    try {
      Uri uri = Uri.parse(Variable.LINK_WALLPAPERS);
      final newURI = uri.replace(queryParameters: params);
      print(newURI);

      // if (accessToken != '')
      return client.get(
        newURI,
        headers: {"Content-Type": "application/json"},
      ).then((http.Response response) async {
        // print(response.body);
        var parsedJson = json.decode(response.body);
        List<Wallpaper> wallpapers = List<Wallpaper>();
        Variable.TOTAL_WALLPAPERS = parsedJson["total"];
        for (final tmp in parsedJson["data"]) {
          Wallpaper w = Wallpaper.fromJson(tmp);
          // print(w);

          wallpapers.add(w);
        }
        return wallpapers;
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<void> setImageAsWallpaper(
      BuildContext context, String group_id, String path) async {
    try {
      final directory = await getExternalStorageDirectory();
      final myImagePath = '${directory.path}/Fashion_Wallpapers';
      var filePath;

      if (!File("$myImagePath/$path").existsSync()) {
        if (!Directory(myImagePath).existsSync())
          await new Directory(myImagePath).create();
        var request = await HttpClient()
            .getUrl(Uri.parse(Variable.STORAGE + "/" + group_id + "/" + path));
        var response = await request.close();
        Uint8List bytes = await consolidateHttpClientResponseBytes(response);
        var file = new File("$myImagePath/$path")..writeAsBytesSync(bytes);
        filePath = file.path;
      } else {
        filePath = "$myImagePath/$path";
      }
//
//      print(filePath);
//      var filePath = await ImagePickerSaver.saveFile(
//          title: 'Fashion Wallpapers', fileData: bytes);
//      print(filePath);
      //set as wallpaper

      final int result = await Variable.platform
          .invokeMethod('getWallpaper', {"text": filePath});
//      print(result);
      if (result != -1)
        _showMessage(context, "Saved As Wallpaper Successfully !");
    } on PlatformException catch (e) {
      Navigator.pop(context);
    } catch (e) {
      print('error: $e');
    }
  }

  static Future<void> saveWallpaper(
      BuildContext context, String group_id, String path) async {
    try {
      final directory = await getExternalStorageDirectory();
      final myImagePath = '${directory.path}/Fashion_Wallpapers';

      if (!File("$myImagePath/$path").existsSync()) {
        if (!Directory(myImagePath).existsSync())
          await new Directory(myImagePath).create();
        var request = await HttpClient()
            .getUrl(Uri.parse(Variable.STORAGE + "/" + group_id + "/" + path));
        var response = await request.close();
        Uint8List bytes = await consolidateHttpClientResponseBytes(response);
        var file = new File("$myImagePath/$path")..writeAsBytesSync(bytes);
      }
      _showMessage(
          context, "  Wallpaper Saved To $myImagePath/$path Successfully !");
    } on PlatformException catch (e) {
      Navigator.pop(context);
    } catch (e) {
      print('error: $e');
    }
  }

  static Future<void> shareImageFromUrl(String group_id, String path) async {
    try {
      var request = await HttpClient()
          .getUrl(Uri.parse(Variable.STORAGE + "/" + group_id + "/" + path));
      var response = await request.close();
      Uint8List bytes = await consolidateHttpClientResponseBytes(response);
      await Share.file('Fashion Wallpapers', path, bytes, 'image/*');
    } catch (e) {
      print('error: $e');
    }
  }

  static void _onImageSaveButtonPressed(String path) async {
    print("_onImageSaveButtonPressed");
    var response = await http
        .get('http://upload.art.ifeng.com/2017/0425/1493105660290.jpg');

    debugPrint(response.statusCode.toString());

    var filePath =
        await ImagePickerSaver.saveFile(fileData: response.bodyBytes);

    // final ByteData bytes = await rootBundle.load(filePath);
    // await Share.file(
    //   'Share Wallpaper',
    //   path,
    //   bytes.buffer.asUint8List(),
    //   'image/png',
    // );

    var savedFile = File.fromUri(Uri.file(filePath));
    // setState(() {
    //   _imageFile = Future<File>.sync(() => savedFile);
    // });
  }

  Future<void> _shareImage(String path) async {
    try {
      final ByteData bytes = await rootBundle.load('assets/image1.png');
      await Share.file(
        'Share Wallpaper',
        path,
        bytes.buffer.asUint8List(),
        'image/png',
      );
    } catch (e) {
      print('error: $e');
    }
  }

  static List<Wallpaper> parsedWallpapers(String data) {
    final parsed = json.decode(data).cast<Map<String, dynamic>>();
    return parsed.map<Wallpaper>((json) => Wallpaper.fromJson(json)).toList();
  }

  static void _showMessage(context, message) {
    final snackBar = SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: 'x',
        textColor: Colors.yellow,
        onPressed: () {
          Scaffold.of(context).hideCurrentSnackBar();
        },
      ),
    );
    Scaffold.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
