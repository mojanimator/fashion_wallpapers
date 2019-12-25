package com.example.wallpaper_fashion;

import android.Manifest;
import android.app.WallpaperManager;
import android.content.ComponentName;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.StrictMode;
import android.provider.MediaStore;
import android.view.Display;
import android.widget.Toast;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.List;

import io.flutter.Log;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "wallpaper";
    String file;
    WallpaperManager myWallpaperManager;
    Display metrics;


//    @Override
//    protected void onCreate(Bundle savedInstanceState) {
//        super.onCreate(savedInstanceState);
//        GeneratedPluginRegistrant.registerWith(this);
//    }


    @Override
    public void configureFlutterEngine(/*@NonNull*/ FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);

        myWallpaperManager = WallpaperManager.getInstance(getApplicationContext());
        metrics = getWindowManager().getDefaultDisplay();
        new MethodChannel(flutterEngine.getDartExecutor(), CHANNEL)
                .setMethodCallHandler((call, result) -> {
                    if (call.method.equals("getWallpaper")) {
                        if (!requestPermission())
                            result.error("Permissions Not Granted!", "setwallpaper", null);
                        file = call.argument("text");
//                        doCrop(Uri.fromFile(new File(file)));
                        int batteryLevel =
                                setAsWallpaper(file);

                        if (batteryLevel != -1) {
                            result.success(batteryLevel);
                        } else {
                            result.error("UNAVAILABLE", "setwallpaper", null);
                        }
                    } else {
                        result.notImplemented();
                    }


                });

    }

    private boolean requestPermission() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            getActivity().requestPermissions(new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE}, 1);

            if (checkSelfPermission(android.Manifest.permission.WRITE_EXTERNAL_STORAGE)
                    == PackageManager.PERMISSION_GRANTED
                    && checkSelfPermission(android.Manifest.permission.SET_WALLPAPER)
                    == PackageManager.PERMISSION_GRANTED
            ) return true;

            else if (checkSelfPermission(android.Manifest.permission.WRITE_EXTERNAL_STORAGE)
                    != PackageManager.PERMISSION_GRANTED) {
                getActivity().requestPermissions(new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE}, 1);
                return false;
            } else if (checkSelfPermission(android.Manifest.permission.SET_WALLPAPER)
                    != PackageManager.PERMISSION_GRANTED) {
                getActivity().requestPermissions(new String[]{Manifest.permission.SET_WALLPAPER}, 1);
                return false;
            } else {
                return false;
            }
        } else { //permission is automatically granted on sdk<23 upon installation
            return true;
        }
    }

//    @Override
//    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
//        super.onActivityResult(requestCode, resultCode, data);
//        try {
//            if (requestCode == 1) {
//                if (data != null) {
//                    Bundle extras = data.getExtras();
//                    assert extras != null;
//                    Bitmap bitmap = extras.getParcelable("data");
////                Bitmap myBitmap = BitmapFactory.decodeFile(path);
//                    myWallpaperManager.setBitmap(bitmap);
//                }
//            } else {
//
//                Display metrics = getWindowManager().getDefaultDisplay();
//                int height = metrics.getHeight();
//                int width = metrics.getWidth();
//                Bitmap bitmap = BitmapFactory.decodeFile(data.getStringExtra("path"));
//                myWallpaperManager.suggestDesiredDimensions(width, height);
//                myWallpaperManager.setBitmap(bitmap);
//            }
//        } catch (IOException e) {
//            e.printStackTrace();
//
//        }
//
//    }

    ;


    protected int setAsWallpaper(String path) {

        try {
//            WallpaperManager myWallpaperManager = WallpaperManager.getInstance(getApplicationContext());
//            Display metrics = getWindowManager().getDefaultDisplay();
//            Toast.makeText(getApplicationContext(), "Saved As Wallpaper Successfully !", Toast.LENGTH_SHORT).show();
//            int height = metrics.getHeight();
//            int width = metrics.getWidth();
            Bitmap bitmap = BitmapFactory.decodeFile(path);
//            myWallpaperManager.suggestDesiredDimensions(width, height);
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N)
                myWallpaperManager.setBitmap(scaleDownLargeImageWithAspectRatio(bitmap), null, true, WallpaperManager.FLAG_SYSTEM);
            else
                myWallpaperManager.setBitmap(scaleDownLargeImageWithAspectRatio(bitmap));


//            Toast.makeText(getApplicationContext(), "a" + width, Toast.LENGTH_SHORT).show();
//            myWallpaperManager.setBitmap(bitmap);

//            Bitmap photo = new Bitmap(path);
//            Intent cropIntent = new Intent("com.android.camera.action.CROP");
//            cropIntent.putExtra("path", path);
//            cropIntent.setDataAndType(Uri.fromFile(new File(path))
//                    , "image/*");
//            startActivity(cropIntent);

//            Bitmap myBitmap = BitmapFactory.decodeFile(path);
//            Bitmap bitmap = Bitmap.createScaledBitmap(myBitmap, width, height, true);
//            myWallpaperManager.setBitmap(scaleDownLargeImageWithAspectRatio(myBitmap),null,true, WallpaperManager.FLAG_LOCK);
//            myWallpaperManager.suggestDesiredDimensions(width, height);
//            myWallpaperManager.setBitmap(myBitmap);
            return 1;
        } catch (Exception e) {
            Toast.makeText(getApplicationContext(), e.getMessage(), Toast.LENGTH_SHORT).show();
            return -1;
        }
    }

    Bitmap scaleDownLargeImageWithAspectRatio(Bitmap image) {
        int imaheVerticalAspectRatio, imageHorizontalAspectRatio;
        float bestFitScalingFactor = 0;
        float percesionValue = (float) 0.2;

        //getAspect Ratio of Image
        int imageHeight = (int) (Math.ceil((double) image.getHeight() / 100) * 100);
        int imageWidth = (int) (Math.ceil((double) image.getWidth() / 100) * 100);
        int GCD = BigInteger.valueOf(imageHeight).gcd(BigInteger.valueOf(imageWidth)).intValue();
        imaheVerticalAspectRatio = imageHeight / GCD;
        imageHorizontalAspectRatio = imageWidth / GCD;
        Log.i("scaleDownLargeImageWIthAspectRatio", "Image Dimensions(W:H): " + imageWidth + ":" + imageHeight);
        Log.i("scaleDownLargeImageWIthAspectRatio", "Image AspectRatio(W:H): " + imageHorizontalAspectRatio + ":" + imaheVerticalAspectRatio);

        //getContainer Dimensions
        int displayWidth = getWindowManager().getDefaultDisplay().getWidth();
        int displayHeight = getWindowManager().getDefaultDisplay().getHeight();
        //I wanted to show the image to fit the entire device, as a best case. So my ccontainer dimensions were displayWidth & displayHeight. For your case, you will need to fetch container dimensions at run time or you can pass static values to these two parameters

        int leftMargin = 0;
        int rightMargin = 0;
        int topMargin = 0;
        int bottomMargin = 0;
        int containerWidth = displayWidth - (leftMargin + rightMargin);
        int containerHeight = displayHeight - (topMargin + bottomMargin);
        Log.i("scaleDownLargeImageWIthAspectRatio", "Container dimensions(W:H): " + containerWidth + ":" + containerHeight);

        //iterate to get bestFitScaleFactor per constraints
        while ((imageHorizontalAspectRatio * bestFitScalingFactor <= containerWidth) &&
                (imaheVerticalAspectRatio * bestFitScalingFactor <= containerHeight)) {
            bestFitScalingFactor += percesionValue;
        }

        //return bestFit bitmap
        int bestFitHeight = (int) (imaheVerticalAspectRatio * bestFitScalingFactor);
        int bestFitWidth = (int) (imageHorizontalAspectRatio * bestFitScalingFactor);
        Log.i("scaleDownLargeImageWIthAspectRatio", "bestFitScalingFactor: " + bestFitScalingFactor);
        Log.i("scaleDownLargeImageWIthAspectRatio", "bestFitOutPutDimesions(W:H): " + bestFitWidth + ":" + bestFitHeight);
        image = Bitmap.createScaledBitmap(image, bestFitWidth, bestFitHeight, true);

        //Position the bitmap centre of the container
        int leftPadding = (containerWidth - image.getWidth()) / 2;
        int topPadding = (containerHeight - image.getHeight()) / 2;
        Bitmap backDrop = Bitmap.createBitmap(containerWidth, containerHeight, Bitmap.Config.RGB_565);
        Canvas can = new Canvas(backDrop);
        can.drawBitmap(image, leftPadding, topPadding, null);

        return backDrop;
    }

    private void doCrop(Uri mImageCaptureUri) {
        final ArrayList<CropOption> cropOptions = new ArrayList<CropOption>();
        /**
         * Open image crop app by starting an intent
         * ‘com.android.camera.action.CROP‘.
         */
        Intent intent = new Intent("com.android.camera.action.CROP");
        intent.setType("image/*");


        /**
         * Check if there is image cropper app installed.
         */

        List<ResolveInfo> list = getPackageManager().queryIntentActivities(intent, 0);
        int size = list.size();

        /**
         * If there is no image cropper app, display warning message
         */
        if (size == 0) {
            Toast.makeText(this, "Can not find image crop app", Toast.LENGTH_SHORT).show();

        } else {
            /**
             * Specify the image path, crop dimension and scale
             */
            final String IMAGE_FILE_LOCATION = "file:///sdcard/temp.jpg";//temp file
            Uri tmpUri = Uri.parse(IMAGE_FILE_LOCATION);//The Uri to store the big bitmap
            intent.setData(mImageCaptureUri);

//            intent.putExtra("outputX", 200);
//            intent.putExtra("outputY", 200);
//            intent.putExtra("aspectX", 1);
//            intent.putExtra("aspectY", 1);
//            intent.putExtra("scale", true);
            intent.putExtra("return-data", true);
//            intent.putExtra(MediaStore.EXTRA_OUTPUT, tmpUri);
            Intent i = new Intent(intent);
            ResolveInfo res = list.get(0);
            i.setComponent(new ComponentName(res.activityInfo.packageName, res.activityInfo.name));
            try {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.GINGERBREAD) {
                    StrictMode.VmPolicy.Builder builder = new StrictMode.VmPolicy.Builder();
                    StrictMode.setVmPolicy(builder.build());
                }
                startActivityForResult(i, 2);

            } catch (Exception e) {
                Toast.makeText(this, e.getMessage(), Toast.LENGTH_LONG).show();

            }

        }
    }

    public class CropOption {
        public CharSequence title;
        public Drawable icon;
        public Intent appIntent;
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        if (requestCode == 2) {
            if (data != null) {
                // get the returned data
                // get the cropped bitmap
                try {
                    Bundle extras = data.getExtras();
                    Toast.makeText(this, data.toString(), Toast.LENGTH_LONG).show();

                    Bitmap selectedBitmap = MediaStore.Images.Media.getBitmap(getContentResolver(), extras.getParcelable("data"));
                    myWallpaperManager.setBitmap(scaleDownLargeImageWithAspectRatio(selectedBitmap));
                } catch (Exception e) {
                    Toast.makeText(this, e.getMessage(), Toast.LENGTH_LONG).show();

                }

            }
        }
    }
//    public class CropOptionAdapter extends ArrayAdapter<CropOption> {
//        private ArrayList<CropOption> mOptions;
//        private LayoutInflater mInflater;
//
//        CropOptionAdapter(Context context, ArrayList<CropOption> options) {
////            super(context);
//            mOptions = options;
//            mInflater = LayoutInflater.from(context);
//        }
//
//    }
}