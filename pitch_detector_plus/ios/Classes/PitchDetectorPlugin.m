#import "PitchDetectorPlugin.h"
#if __has_include(<pitch_detector/pitch_detector-Swift.h>)
#import <pitch_detector/pitch_detector-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "pitch_detector-Swift.h"
#endif

@implementation PitchDetectorPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftPitchDetectorPlugin registerWithRegistrar:registrar];
}
@end
