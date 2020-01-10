#import "WallpaperChangerPlugin.h"
#if __has_include(<wallpaper_changer/wallpaper_changer-Swift.h>)
#import <wallpaper_changer/wallpaper_changer-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "wallpaper_changer-Swift.h"
#endif

@implementation WallpaperChangerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftWallpaperChangerPlugin registerWithRegistrar:registrar];
}
@end
