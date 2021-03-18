#import "FlutterPluginGalleryPlugin.h"
#if __has_include(<flutter_plugin_gallery/flutter_plugin_gallery-Swift.h>)
#import <flutter_plugin_gallery/flutter_plugin_gallery-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_plugin_gallery-Swift.h"
#endif

@implementation FlutterPluginGalleryPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterPluginGalleryPlugin registerWithRegistrar:registrar];
}
@end
