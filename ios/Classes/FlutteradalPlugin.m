#import "FlutteradalPlugin.h"
#import <flutteradal/flutteradal-Swift.h>

@implementation FlutteradalPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutteradalPlugin registerWithRegistrar:registrar];
}
@end
