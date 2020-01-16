package com.example.wallpaper_fashion;

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
//    private static final String CHANNEL = "change_wallpaper";
//    private String file;
//    private static WallpaperManager myWallpaperManager;
//    private Display metrics;


//    @Override
//    protected void onCreate(Bundle savedInstanceState) {
//        super.onCreate(savedInstanceState);
//        configureFlutterEngine(this.getFlutterEngine());
//
//        myWallpaperManager = WallpaperManager.getInstance(getApplicationContext());
//        metrics = getWindowManager().getDefaultDisplay();
//
//        methodChannel = new MethodChannel(this.getFlutterEngine().getDartExecutor(), CHANNEL);
//        methodChannel
//                .setMethodCallHandler((call, result) -> {
//                    Toast.makeText(getApplicationContext(), call.method,
//                            Toast.LENGTH_SHORT).show();
//                    Log.d("fashion", call.method);
//                    if (call.method.equals("getWallpaper")) {
////                        if (!requestPermission())
////                            result.error("Permissions Not Granted!", "setwallpaper", null);
//                        file = call.argument("text");
//                        //                        doCrop(Uri.fromFile(new File(file)));
//                        int batteryLevel = setAsWallpaper(file);
//
//                        if (batteryLevel != -1) {
//                            result.success(batteryLevel);
//                        } else {
//                            result.error("UNAVAILABLE", "setwallpaper", null);
//                        }
//                    } else {
//                        result.notImplemented();
//                    }
//
//                });
//    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);

//        myWallpaperManager = WallpaperManager.getInstance(getApplicationContext());
//        metrics = getWindowManager().getDefaultDisplay();
//        MethodChannel methodChannel = new MethodChannel(flutterEngine.getDartExecutor(), CHANNEL);
//        methodChannel
//                .setMethodCallHandler((call, result) -> {
//                    if (call.method.equals("getWallpaper")) {
////                        if (!requestPermission())
////                            result.error("Permissions Not Granted!", "setwallpaper", null);
//                        file = call.argument("text");
//                        int batteryLevel;
//
//                        Bitmap bitmap = BitmapFactory.decodeFile(file);
//                        try {
//                            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N)
//                                myWallpaperManager.setBitmap(bitmap,
//                                        null, true, WallpaperManager.FLAG_SYSTEM);
//                            else {
//
//                                myWallpaperManager.setBitmap(bitmap);
//                            }
//                            batteryLevel = 1;
//                        } catch (IOException e) {
//                            e.printStackTrace();
//                            batteryLevel = -1;
//                        }
//
//                        if (batteryLevel != -1) {
//                            result.success(batteryLevel);
//                        } else {
//                            result.error("UNAVAILABLE", "setwallpaper", null);
//                            Log.d("fashion", "UNAVAILABLE");
//                        }
//                    } else {
//                        result.notImplemented();
//                        Log.d("fashion", "notImplemented");
//                    }
//
//                });
    }

//    private boolean requestPermission() {
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
//            this.requestPermissions(
//                    new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE}, 1);
//
//            if (checkSelfPermission(
//                    Manifest.permission.WRITE_EXTERNAL_STORAGE) ==
//                    PackageManager.PERMISSION_GRANTED &&
//                    checkSelfPermission(Manifest.permission.SET_WALLPAPER) ==
//                            PackageManager.PERMISSION_GRANTED)
//                return true;
//
//            else if (checkSelfPermission(
//                    Manifest.permission.WRITE_EXTERNAL_STORAGE) !=
//                    PackageManager.PERMISSION_GRANTED) {
//                this.requestPermissions(
//                        new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE}, 1);
//                return false;
//            } else if (checkSelfPermission(
//                    Manifest.permission.SET_WALLPAPER) !=
//                    PackageManager.PERMISSION_GRANTED) {
//                this.requestPermissions(
//                        new String[]{Manifest.permission.SET_WALLPAPER}, 1);
//                return false;
//            } else {
//                return false;
//            }
//        } else { // permission is automatically granted on sdk<23 upon installation
//            return true;
//        }
//    }


//    static int setAsWallpaper(String path) {
//
//        try {
//            //            WallpaperManager myWallpaperManager =
//            //            WallpaperManager.getInstance(getApplicationContext());
//            //            Display metrics = getWindowManager().getDefaultDisplay();
//            //            Toast.makeText(getApplicationContext(), "Saved As Wallpaper
//            //            Successfully !", Toast.LENGTH_SHORT).show(); int height =
//            //            metrics.getHeight(); int width = metrics.getWidth();
////            Toast.makeText(getApplicationContext(), path, Toast.LENGTH_SHORT)
////                    .show();
//            Bitmap bitmap = BitmapFactory.decodeFile(path);
//            //            myWallpaperManager.suggestDesiredDimensions(width, height);
//            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N)
//                myWallpaperManager.setBitmap(bitmap/*scaleDownLargeImageWithAspectRatio(bitmap)*/,
//                        null, true, WallpaperManager.FLAG_SYSTEM);
//            else
//                myWallpaperManager.setBitmap(bitmap
//                        /*scaleDownLargeImageWithAspectRatio(bitmap)*/);
//
//            //            Toast.makeText(getApplicationContext(), "a" + width,
//            //            Toast.LENGTH_SHORT).show();
//            //            myWallpaperManager.setBitmap(bitmap);
//
//            //            Bitmap photo = new Bitmap(path);
//            //            Intent cropIntent = new
//            //            Intent("com.android.camera.action.CROP");
//            //            cropIntent.putExtra("path", path);
//            //            cropIntent.setDataAndType(Uri.fromFile(new File(path))
//            //                    , "image/*");
//            //            startActivity(cropIntent);
//
//            //            Bitmap myBitmap = BitmapFactory.decodeFile(path);
//            //            Bitmap bitmap = Bitmap.createScaledBitmap(myBitmap, width,
//            //            height, true);
//            //            myWallpaperManager.setBitmap(scaleDownLargeImageWithAspectRatio(myBitmap),null,true,
//            //            WallpaperManager.FLAG_LOCK);
//            //            myWallpaperManager.suggestDesiredDimensions(width, height);
//            //            myWallpaperManager.setBitmap(myBitmap);
//            return 1;
//        } catch (Exception e) {
////            Toast
////                    .makeText(getApplicationContext(), e.getMessage(), Toast.LENGTH_SHORT)
////                    .show();
//            return -1;
//        }
//    }

//    static Bitmap scaleDownLargeImageWithAspectRatio(Bitmap image) {
//        int imaheVerticalAspectRatio, imageHorizontalAspectRatio;
//        float bestFitScalingFactor = 0;
//        float percesionValue = (float) 0.2;
//
//        // getAspect Ratio of Image
//        int imageHeight = (int) (Math.ceil((double) image.getHeight() / 100) * 100);
//        int imageWidth = (int) (Math.ceil((double) image.getWidth() / 100) * 100);
//        int GCD = BigInteger.valueOf(imageHeight)
//                .gcd(BigInteger.valueOf(imageWidth))
//                .intValue();
//        imaheVerticalAspectRatio = imageHeight / GCD;
//        imageHorizontalAspectRatio = imageWidth / GCD;
//        Log.i("scaleDownLargeImageWIthAspectRatio",
//                "Image Dimensions(W:H): " + imageWidth + ":" + imageHeight);
//        Log.i("scaleDownLargeImageWIthAspectRatio",
//                "Image AspectRatio(W:H): " + imageHorizontalAspectRatio + ":" +
//                        imaheVerticalAspectRatio);
//
//        // getContainer Dimensions
//        int displayWidth = getWindowManager().getDefaultDisplay().getWidth();
//        int displayHeight = getWindowManager().getDefaultDisplay().getHeight();
//        // I wanted to show the image to fit the entire device, as a best case. So
//        // my ccontainer dimensions were displayWidth & displayHeight. For your case,
//        // you will need to fetch container dimensions at run time or you can pass
//        // static values to these two parameters
//
//        int leftMargin = 0;
//        int rightMargin = 0;
//        int topMargin = 0;
//        int bottomMargin = 0;
//        int containerWidth = displayWidth - (leftMargin + rightMargin);
//        int containerHeight = displayHeight - (topMargin + bottomMargin);
//        Log.i("scaleDownLargeImageWIthAspectRatio",
//                "Container dimensions(W:H): " + containerWidth + ":" +
//                        containerHeight);
//
//        // iterate to get bestFitScaleFactor per constraints
//        while (
//                (imageHorizontalAspectRatio * bestFitScalingFactor <= containerWidth) &&
//                        (imaheVerticalAspectRatio * bestFitScalingFactor <= containerHeight)) {
//            bestFitScalingFactor += percesionValue;
//        }
//
//        // return bestFit bitmap
//        int bestFitHeight = (int) (imaheVerticalAspectRatio * bestFitScalingFactor);
//        int bestFitWidth = (int) (imageHorizontalAspectRatio * bestFitScalingFactor);
//        Log.i("scaleDownLargeImageWIthAspectRatio",
//                "bestFitScalingFactor: " + bestFitScalingFactor);
//        Log.i("scaleDownLargeImageWIthAspectRatio",
//                "bestFitOutPutDimesions(W:H): " + bestFitWidth + ":" + bestFitHeight);
//        image = Bitmap.createScaledBitmap(image, bestFitWidth, bestFitHeight, true);
//
//        // Position the bitmap centre of the container
//        int leftPadding = (containerWidth - image.getWidth()) / 2;
//        int topPadding = (containerHeight - image.getHeight()) / 2;
//        Bitmap backDrop = Bitmap.createBitmap(containerWidth, containerHeight,
//                Bitmap.Config.RGB_565);
//        Canvas can = new Canvas(backDrop);
//        can.drawBitmap(image, leftPadding, topPadding, null);
//
//        return backDrop;
//    }


}