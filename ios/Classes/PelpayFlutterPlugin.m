#import "PelpayFlutterPlugin.h"
#if __has_include(<pelpay_flutter/pelpay_flutter-Swift.h>)
#import <pelpay_flutter/pelpay_flutter-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "pelpay_flutter-Swift.h"
#endif

@implementation PelpayFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftPelpayFlutterPlugin registerWithRegistrar:registrar];
}
@end
