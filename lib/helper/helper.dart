import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:connecting/helper/variables.dart';
import 'package:connecting/model/wallpaper.dart';
import 'package:connectivity/connectivity.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as IMG;
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallpaper_changer/wallpaper_changer.dart';

class Helper {
  static var client = http.Client();
  static SharedPreferences localStorage;
  static int showAdTimes = 0;
  static Directory directory;

//  static String accessToken;
//  static String refreshToken;
//  static String username;
//  static String name;
//  static String family;
//  static String phoneNumber;
  static int fashionImages;
  SnackBar snackBar;

  static MobileAdTargetingInfo targetingInfo;

  static Map<String, dynamic> appIds;

  static BannerAd bannerAd;

  static void prepare(BuildContext context) async {
    directory = await getExternalStorageDirectory();
    localStorage = await SharedPreferences.getInstance();
    appIds = await loadAppIds(context);
//    var d = await DiskCache();
//    d.maxSizeBytes = 50;
//    d.maxEntries = 5;
//    imageCache.maximumSize = 100;

    initAdmob();
  }

  static Future<SharedPreferences> _getLocalStorage() async {
    localStorage = await SharedPreferences.getInstance();
//    accessToken = localStorage.getString('access_token');
//    refreshToken = localStorage.getString('refresh_token');
//    username = localStorage.getString('username');
//    name = localStorage.getString('name');
//    family = localStorage.getString('family');
//    phoneNumber = localStorage.getString('phone_number');
//    fashionImages = localStorage.getInt('fashion_images');

    return localStorage;
  }

  static Future<bool> hasPermission(
      PermissionGroup p, BuildContext context) async {
    PermissionStatus permission =
        await PermissionHandler().checkPermissionStatus(p);
    if (permission.value != PermissionStatus.granted.value) {
      Map<PermissionGroup, PermissionStatus> permissions =
          await PermissionHandler().requestPermissions([p]);
      if (permissions[PermissionGroup.storage] != PermissionStatus.granted) {
        final snackBar = SnackBar(
          content: Text("Please Allow Storage Permission And Try Again"),
          action: SnackBarAction(
            label: 'Open Settings',
            textColor: Colors.yellow,
            onPressed: () async {
              bool isOpened = await PermissionHandler().openAppSettings();
              Scaffold.of(context).hideCurrentSnackBar();
            },
          ),
        );
        Scaffold.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(snackBar);
        return false;
      } else
        return true;
    } else
      return true;
  }

  static Future<bool> isNetworkConnected() async {
//    print("isNetworkConnected");
    var connectivityResult = await (Connectivity().checkConnectivity());

    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
      } else if (result == ConnectivityResult.wifi ||
          result == ConnectivityResult.mobile) {
        initAdmob();
      }
    });
    return connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi;
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
  static Future<int> checkAndSetUpdates() async {
    try {
      // if (accessToken != '')
      if (localStorage == null) await _getLocalStorage();
      int localFashionImages = localStorage.getInt('fashion_images') ?? 0;
      return client.get(
        Variable.CHECK_UPDATE + "?app=fashion",
        headers: {"Content-Type": "application/json"},
      ).then((http.Response response) async {
        fashionImages = int.parse(response.body);
//        print(localFashionImages.toString() + "," + fashionImages.toString());
        if (localFashionImages == 0 || localFashionImages > fashionImages) {
          localStorage.setInt('fashion_images', fashionImages);
          return -1; //first time that app starts not show notification
        } else if (fashionImages > localFashionImages) {
          //updated!
          localStorage.setInt('fashion_images', fashionImages);
          return fashionImages;
        }
        return -1;
      }, onError: (e) {
        return -1;
      });
    } catch (e) {
//      showMessage(context, e.toString());
      print("error in my helper  $e.toString()");
      return -1;
//      throw Exception(e.toString());
    }
  }

  static Future<List<Wallpaper>> getWallpapers(context, params) async {
    try {
      Uri uri = Uri.parse(Variable.LINK_WALLPAPERS);
      final newURI = uri.replace(queryParameters: params);
//      print(newURI);

      // if (accessToken != '')
      return client.get(
        newURI,
        headers: {"Content-Type": "application/json"},
      ).then((http.Response response) async {
        List<Wallpaper> wallpapers = List<Wallpaper>();
        if (response.statusCode != 200) return null;
        var parsedJson = json.decode(response.body);
        Variable.TOTAL_WALLPAPERS[params['group_id']] = parsedJson["total"];
        for (final tmp in parsedJson["data"]) {
          Wallpaper w = Wallpaper.fromJson(tmp);
          // print(w);

          wallpapers.add(w);
        }
        return wallpapers;
      }, onError: (e) {
        showMessage(context, "Check Your Internet Connection And Try Again !");

        return null;
      });
    } catch (e) {
      showMessage(context, "Check Your Internet Connection And Try Again !");
      return null;
    }
  }

  static Future<String> getWallpaperFromThumb(String name) async {
    directory ??= await getExternalStorageDirectory();
    return '${directory.path}/Fashion_Wallpapers/Favourites/$name';
  }

  static Future<void> changeWallpaper(Directory directory) async {
    localStorage ??= await SharedPreferences.getInstance();

    int current = localStorage.getInt('current_wallpaper_index');
    if (current == null) {
      current = -1;
      localStorage.setInt('current_wallpaper_index', -1);
    } else {
      try {
        final myImagePath = '${directory.path}/Fashion_Wallpapers/Favourites';

        if (Directory(myImagePath).existsSync()) {
          List<FileSystemEntity> files = Directory(myImagePath)
              .listSync(recursive: false, followLinks: false);

          if (current + 1 < files.length) {
            localStorage.setInt('current_wallpaper_index', current + 1);
          } else {
            current = -1;
            localStorage.setInt('current_wallpaper_index', -1);
          }
//          print("file path" + files[current + 1].path);

          /*final int result =*/
          await Variable.platform
              .invokeMethod('getWallpaper', {"text": files[current + 1].path});

//          print(result);
        } else {
//          print("not exist $myImagePath");
        }
      } catch (e) {
//        print("errorrr" + e.toString());
      }
    }
  }

  static Future<List<String>> getFavouriteWallpapers(int page) async {
    try {
      List<String> files = List<String>();

      int range = 15;
      final myImagePath = '${directory.path}/Fashion_Wallpapers/Favourites/th';
      if (Directory(myImagePath).existsSync()) {
        for (File file in Directory(myImagePath)
            .listSync(recursive: false, followLinks: false)) {
          files.insert(0, file.path);
        }
      }

      Variable.TOTAL_WALLPAPERS['5'] = files.length;

      int totalPages = (files.length / range).ceil();
      if (page > totalPages) return [];
      if (files.length < page * range)
//        if (files.length <
//          range * (page - 1) + (range - 1))
        return files.sublist(range * (page - 1));
      return files.sublist(range * (page - 1), range * (page - 1) + range);
    } on Exception catch (e) {
      print('error: $e');
      return null;
    }
  }

  static Future<void> addWallpaperToFavourites(
      BuildContext context, Uint8List bytes, String path) async {
    try {
      final directory = await getExternalStorageDirectory();
      final myImagePath = '${directory.path}/Fashion_Wallpapers/Favourites';

//      if (!File("$myImagePath/$path").existsSync()) {
      if (!Directory('${directory.path}/Fashion_Wallpapers').existsSync())
        await new Directory('${directory.path}/Fashion_Wallpapers').create();
      if (!Directory(myImagePath).existsSync())
        await new Directory(myImagePath).create();

//      }
      var file = new File("$myImagePath/tmp-$path")..writeAsBytesSync(bytes);
//        filePath = file.path;
//      print(filePath);
      File croppedFile = await ImageCropper.cropImage(
          sourcePath: file.path,
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.device,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],
          androidUiSettings: AndroidUiSettings(
              showCropGrid: true,
              toolbarTitle: 'Crop Image',
              toolbarColor: Colors.black,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.device,
              lockAspectRatio: true),
          iosUiSettings: IOSUiSettings(
            minimumAspectRatio: 1.0,
          ));
      if (croppedFile != null) {
        /*final newFile =*/ await croppedFile.copy("$myImagePath/$path");

//create thumb
        final bytes = await croppedFile.readAsBytes();
        IMG.Image thumbnail = IMG.copyResize(IMG.decodeImage(bytes),
            width: 200, interpolation: IMG.Interpolation.average);

        if (!Directory("$myImagePath/th").existsSync())
          await new Directory("$myImagePath/th").create();
        new File("$myImagePath/th/$path")
          ..writeAsBytesSync(IMG.encodePng(thumbnail));

        await croppedFile.delete();
        showMessage(context, "Added To Best  Successfully !");
//        imageCache.clear();
      }
      await file.delete();
//      else
//        showMessage(context, "Cancelled");
    } on PlatformException catch (e) {
      showMessage(context, e.message);
//      print('error: $e');
//      Navigator.pop(context);
    } catch (e) {
      showMessage(context, e.toString());

//      print('error: $e');
    }
  }

  static Future<void> setImageAsWallpaper(
      BuildContext context, Uint8List bytes, String path) async {
    try {
      final myImagePath = '${directory.path}/Fashion_Wallpapers';
      var filePath;

      if (!File("$myImagePath/$path").existsSync()) {
        if (!Directory(myImagePath).existsSync())
          await new Directory(myImagePath).create();
//        var request = await HttpClient()
//            .getUrl(Uri.parse(Variable.STORAGE + "/" + group_id + "/" + path));
//        var response = await request.close();
//        Uint8List bytes = await consolidateHttpClientResponseBytes(response);

        var file = new File("$myImagePath/$path")..writeAsBytesSync(bytes);
        filePath = file.path;
      } else {
        filePath = "$myImagePath/$path";
      }
//      print(filePath);
//      MediaQueryData queryData;

      File croppedFile = await ImageCropper.cropImage(
//          aspectRatio: CropAspectRatio(
//              ratioX: queryData.size.width, ratioY: queryData.size.height),
          sourcePath: filePath,
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.device,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],
          androidUiSettings: AndroidUiSettings(
              showCropGrid: true,
              toolbarTitle: 'Crop Image',
              toolbarColor: Colors.black,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.device,
              lockAspectRatio: true),
          iosUiSettings: IOSUiSettings(
            minimumAspectRatio: 1.0,
          ));

//      print(filePath);
//      var filePath = await ImagePickerSaver.saveFile(
//          title: 'Fashion Wallpapers', fileData: bytes);
//      print(filePath);
//set as wallpaper

//      final int result = await Variable.platform
//          .invokeMethod('getWallpaper', {"text": croppedFile.path});
      int result = await WallpaperChanger.change(croppedFile.path);
//      print(result);
      if (result != -1)
        showMessage(context, "Saved As Wallpaper Successfully !");
    } on PlatformException catch (e) {
      showMessage(context, e.message);
//      print('error: $e');
//      Navigator.pop(context);
    } catch (e) {
//      showMessage(context,"cancelled");
//
//      print('error: $e');
    }
  }

  static Future<void> saveWallpaper(
      BuildContext context, Uint8List bytes, String path) async {
    try {
      final myImagePath = '${directory.path}/Fashion_Wallpapers';

      if (!File("$myImagePath/$path").existsSync()) {
        if (!Directory(myImagePath).existsSync())
          await new Directory(myImagePath).create();
//        var request = await HttpClient()
//            .getUrl(Uri.parse(Variable.STORAGE + "/" + group_id + "/" + path));
//        var response = await request.close();
//        Uint8List bytes = await consolidateHttpClientResponseBytes(response);
/*var file = */
        new File("$myImagePath/$path")..writeAsBytesSync(bytes);
      }
      showMessage(
          context, "  Wallpaper Saved To $myImagePath/$path Successfully !");
    } on PlatformException catch (e) {
      Navigator.pop(context);
    } catch (e) {
//      print('error: $e');
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
//      print('error: $e');
    }
  }

//  static void _onImageSaveButtonPressed(String path) async {
//    print("_onImageSaveButtonPressed");
//    var response = await http
//        .get('http://upload.art.ifeng.com/2017/0425/1493105660290.jpg');
//
//    debugPrint(response.statusCode.toString());
//
//    var filePath =
//        await ImagePickerSaver.saveFile(fileData: response.bodyBytes);
//
//    // final ByteData bytes = await rootBundle.load(filePath);
//    // await Share.file(
//    //   'Share Wallpaper',
//    //   path,
//    //   bytes.buffer.asUint8List(),
//    //   'image/png',
//    // );
//
//    var savedFile = File.fromUri(Uri.file(filePath));
//    // setState(() {
//    //   _imageFile = Future<File>.sync(() => savedFile);
//    // });
//  }

  static shareImage(Uint8List bytes, String path, BuildContext context) async {
    try {
      await Share.file('Fashion Wallpapers', path, bytes, 'image/*',
          text: "Fashion Wallpapers");
    } catch (e) {
//      print('error: $e');
      showMessage(context, e);
    }
  }

  static List<Wallpaper> parsedWallpapers(String data) {
    final parsed = json.decode(data).cast<Map<String, dynamic>>();
    return parsed.map<Wallpaper>((json) => Wallpaper.fromJson(json)).toList();
  }

  static void showMessage(context, message) {
    if (context == null) return;
    final snackBar = SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: 'X',
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

  static BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: appIds["BANNER_UNIT_TEST"].toString(),
      size: AdSize.fullBanner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
//        print("BannerAd event $event");
      },
    );
  }

  static InterstitialAd createInterstitialAd() {
    return InterstitialAd(
      adUnitId: appIds["INTERSTITIAL_UNIT_TEST"].toString(),
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
//        print("InterstitialAd event $event");
      },
    );
  }

  static void initAdmob() async {
    FirebaseAdMob.instance
        .initialize(appId: appIds["APP_ID"].toString())
        .then((onValue) {
      targetingInfo = MobileAdTargetingInfo(
        keywords: <String>['fashion', 'women', 'children', 'cloth'],
        contentUrl: 'https://flutter.io',
//    birthday: DateTime.now(),
//        childDirected: false,
//    designedForFamilies: false,
//    gender: MobileAdGender.unknown,
        // or MobileAdGender.female, MobileAdGender.unknown
        // Android emulators are considered test devices
        testDevices: <String>[],
      );

      RewardedVideoAd.instance.load(
          adUnitId: appIds["REWARDED_UNIT_TEST"].toString(),
          targetingInfo: targetingInfo);

      bannerAd = createBannerAd();
      bannerAd
        ..load()
        ..show(
          anchorOffset: 0.0,
          horizontalCenterOffset: 0.0,
          anchorType: AnchorType.bottom,
        );
    });
  }

  static void loadRewardedVideo() {
    RewardedVideoAd.instance
        .load(
            adUnitId: appIds["REWARDED_UNIT_TEST"].toString(),
            targetingInfo: targetingInfo)
        .then((onValue) {});
  }

  static void showRewardedVideo() {
    RewardedVideoAd.instance.show().then((onValue) {}, onError: (e) {
      loadRewardedVideo();
    });
  }

  static bool isFavourite(String path) {
    final myImagePath = '${directory.path}/Fashion_Wallpapers/Favourites';

    if (Directory(myImagePath).existsSync() &&
        File(myImagePath + "/$path").existsSync()) return true;

    return false;
  }

  static Future<Map<String, dynamic>> loadAppIds(BuildContext context) async {
    String data = await DefaultAssetBundle.of(context).loadString("ids.json");
    return json.decode(data);
  }
}
