#import <Foundation/Foundation.h>
#import "React/RCTViewManager.h"

@interface RCT_EXTERN_MODULE(DanceViewManager, RCTViewManager)
RCT_EXTERN_METHOD(addNodeViaManager:(nonnull NSNumber *)node)
RCT_EXTERN_METHOD(incrementBoxPickerViaManager:(nonnull NSNumber *)node)
@end
