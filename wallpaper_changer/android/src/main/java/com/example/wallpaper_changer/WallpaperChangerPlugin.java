package com.example.wallpaper_changer;

import android.app.WallpaperManager;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Build;

import java.io.IOException;

import androidx.annotation.NonNull;
import io.flutter.Log;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * WallpaperChangerPlugin
 */
public class WallpaperChangerPlugin implements FlutterPlugin {

    private Context context;


    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {

        final MethodChannel channel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "wallpaper_changer");
        context = flutterPluginBinding.getApplicationContext();
//        channel.setMethodCallHandler(new WallpaperChangerPlugin());
        channel.setMethodCallHandler(new MethodChannel.MethodCallHandler() {
            @Override
            public void onMethodCall(MethodCall call, MethodChannel.Result result) {

                if (call.method.equals("getWallpaper")) {
                    String file = call.argument("text");
                    int res;
                    WallpaperManager myWallpaperManager = WallpaperManager.getInstance(context);
                    Bitmap bitmap = BitmapFactory.decodeFile(file);
                    try {
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N)
                            myWallpaperManager.setBitmap(bitmap,
                                    null, true, WallpaperManager.FLAG_SYSTEM);
                        else {
                            myWallpaperManager.setBitmap(bitmap);
                        }
                        res = 1;
                    } catch (IOException e) {
                        e.printStackTrace();
                        res = -1;
                    }
                    if (res != -1) {
                        result.success(res);
                    } else {
                        result.error("UNAVAILABLE", "changeWallpaperService", null);
                        Log.d("fashion", "UNAVAILABLE");
                    }
                } else {
                    result.notImplemented();
                    Log.d("fashion", "notImplemented");
                }
            }
        });
    }

    // This static function is optional and equivalent to onAttachedToEngine. It supports the old
    // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
    // plugin registration via this function while apps migrate to use the new Android APIs
    // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
    //
    // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
    // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
    // depending on the user's project. onAttachedToEngine or registerWith must both be defined
    // in the same class.
    public void registerWith(Registrar registrar) {

        final MethodChannel channel = new MethodChannel(registrar.messenger(), "wallpaper_changer");
        context = registrar.context();
//        channel.setMethodCallHandler(new WallpaperChangerPlugin());
        channel.setMethodCallHandler(new MethodChannel.MethodCallHandler() {
            @Override
            public void onMethodCall(MethodCall call, MethodChannel.Result result) {

                if (call.method.equals("getWallpaper")) {
                    String file = call.argument("text");
                    int res;
                    WallpaperManager myWallpaperManager = WallpaperManager.getInstance(context);
                    Bitmap bitmap = BitmapFactory.decodeFile(file);
                    try {
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N)
                            myWallpaperManager.setBitmap(bitmap,
                                    null, true, WallpaperManager.FLAG_SYSTEM);
                        else {
                            myWallpaperManager.setBitmap(bitmap);
                        }
                        res = 1;
                    } catch (IOException e) {
                        e.printStackTrace();
                        res = -1;
                    }
                    if (res != -1) {
                        result.success(res);
                    } else {
                        result.error("UNAVAILABLE", "changeWallpaperService", null);
                        Log.d("fashion", "UNAVAILABLE");
                    }
                } else {
                    result.notImplemented();
                    Log.d("fashion", "notImplemented");
                }
            }
        });
    }

//    @Override
//    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
//
//    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {

    }
}
