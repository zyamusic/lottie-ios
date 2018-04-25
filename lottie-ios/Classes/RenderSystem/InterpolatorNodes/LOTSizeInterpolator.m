//
//  LOTSizeInterpolator.m
//  Lottie
//
//  Created by brandon_withrow on 7/13/17.
//  Copyright © 2017 Airbnb. All rights reserved.
//

#import "LOTPlatformCompat.h"
#import "LOTSizeInterpolator.h"
#import "CGGeometry+LOTAdditions.h"
#import "LOTHelpers.h"
#import <malloc/malloc.h>


@implementation LOTSizeInterpolator

- (CGSize)sizeValueForFrame:(NSNumber *)frame {
    NSDate *start = [NSDate date];
  CGFloat progress = [self progressForFrame:frame];
  CGSize returnSize;
  if (progress == 0) {
    returnSize = self.leadingKeyframe.sizeValue;
  }else if (progress == 1) {
    returnSize = self.trailingKeyframe.sizeValue;
  } else {
    returnSize = CGSizeMake(LOT_RemapValue(progress, 0, 1, self.leadingKeyframe.sizeValue.width, self.trailingKeyframe.sizeValue.width),
                            LOT_RemapValue(progress, 0, 1, self.leadingKeyframe.sizeValue.height, self.trailingKeyframe.sizeValue.height));
  }
  if (self.hasDelegateOverride) {
      
      NSTimeInterval timeInterval = fabs([start timeIntervalSinceNow]);
      
      NSString *outputStr  = [NSString stringWithFormat:@"%f,LOTSizeInterpolator-sizeValueForFrame", timeInterval];
      if (ENABLE_DEBUG_TIMING_LOGGING) {
          printf("%s\n", [outputStr UTF8String]);
      }
    return [self.delegate sizeForFrame:frame.floatValue
                         startKeyframe:self.leadingKeyframe.keyframeTime.floatValue
                           endKeyframe:self.trailingKeyframe.keyframeTime.floatValue
                  interpolatedProgress:progress startSize:self.leadingKeyframe.sizeValue
                               endSize:self.trailingKeyframe.sizeValue
                           currentSize:returnSize];
  }
    
    NSTimeInterval timeInterval = fabs([start timeIntervalSinceNow]);
    
    NSString *outputStr  = [NSString stringWithFormat:@"%f,LOTSizeInterpolator-sizeValueForFrame", timeInterval];
    if (ENABLE_DEBUG_TIMING_LOGGING) {
        printf("%s\n", [outputStr UTF8String]);
    }
    if (ENABLE_DEBUG_MEMORY_LOGGING) {
        NSString *className = NSStringFromClass([self class]);
        NSString *outputStr  = [NSString stringWithFormat:@"%zd,%s-sizeForValueFrame\n", malloc_size((__bridge const void *) self), [className UTF8String]];
        printf("%s\n", [outputStr UTF8String]);
    }
  return returnSize;
}

- (BOOL)hasDelegateOverride {
  return self.delegate != nil;
}

- (void)setValueDelegate:(id<LOTValueDelegate>)delegate {
  NSAssert(([delegate conformsToProtocol:@protocol(LOTSizeValueDelegate)]), @"Size Interpolator set with incorrect callback type. Expected LOTSizeValueDelegate");
  self.delegate = (id<LOTSizeValueDelegate>)delegate;
}

@end
