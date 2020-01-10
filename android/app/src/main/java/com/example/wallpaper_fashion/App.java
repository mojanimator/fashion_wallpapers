package com.example.wallpaper_fashion;

import android.app.WallpaperManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Build;

import java.io.IOException;

import io.flutter.Log;
import io.flutter.app.FlutterApplication;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

/**
 * Created by Mojtaba Rajabi on 04/01/2020.
 */
public class App extends FlutterApplication implements FlutterPlugin, MethodChannel.MethodCallHandler {

    static MethodChannel methodChannel;
    private static final String CHANNEL = "change_wallpaper";
    private static WallpaperManager myWallpaperManager;

    @Override
    public void onCreate() {
        super.onCreate();
//        WorkmanagerPlugin.setPluginRegistrantCallback(this);

    }

    @Override
    public void onAttachedToEngine(FlutterPluginBinding flutterPluginBinding) {
        final MethodChannel channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "changeWallpaperService");
        channel.setMethodCallHandler(new WallpaperChanger());
    }

    public static void registerWith(PluginRegistry.Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "changeWallpaperService");
        channel.setMethodCallHandler(new WallpaperChanger());
    }


    @Override
    public void onDetachedFromEngine(FlutterPluginBinding flutterPluginBinding) {

    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        if (call.method.equals("getWallpaper")) {
            String file = call.argument("text");
            int res;

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
}

