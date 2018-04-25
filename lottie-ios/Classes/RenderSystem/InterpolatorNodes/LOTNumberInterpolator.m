//
//  LOTNumberInterpolator.m
//  Lottie
//
//  Created by brandon_withrow on 7/11/17.
//  Copyright © 2017 Airbnb. All rights reserved.
//

#import "LOTNumberInterpolator.h"
#import "CGGeometry+LOTAdditions.h"
#import "LOTHelpers.h"
#import <malloc/malloc.h>

@implementation LOTNumberInterpolator

- (CGFloat)floatValueForFrame:(NSNumber *)frame {
    NSDate *start = [NSDate date];
  CGFloat progress = [self progressForFrame:frame];
  CGFloat returnValue;
  if (progress == 0) {
    returnValue = self.leadingKeyframe.floatValue;
  } else if (progress == 1) {
    returnValue = self.trailingKeyframe.floatValue;
  } else {
    returnValue = LOT_RemapValue(progress, 0, 1, self.leadingKeyframe.floatValue, self.trailingKeyframe.floatValue);
  }
  if (self.hasDelegateOverride) {
      
      NSTimeInterval timeInterval = fabs([start timeIntervalSinceNow]);
      
      NSString *outputStr  = [NSString stringWithFormat:@"%f,LOTNumberInterpolator-floatValueForFrame", timeInterval];
      if (ENABLE_DEBUG_TIMING_LOGGING) {
          printf("%s", [outputStr UTF8String]);
      }
    return [self.delegate floatValueForFrame:frame.floatValue
                               startKeyframe:self.leadingKeyframe.keyframeTime.floatValue
                                 endKeyframe:self.trailingKeyframe.keyframeTime.floatValue
                        interpolatedProgress:progress
                                  startValue:self.leadingKeyframe.floatValue
                                    endValue:self.trailingKeyframe.floatValue
                                currentValue:returnValue];
  }
    NSTimeInterval timeInterval = fabs([start timeIntervalSinceNow]);
    
    NSString *outputStr  = [NSString stringWithFormat:@"%f,LOTNumberInterpolator-floatValueForFrame", timeInterval];
    if (ENABLE_DEBUG_TIMING_LOGGING) {
        printf("%s", [outputStr UTF8String]);
    }
    if (ENABLE_DEBUG_MEMORY_LOGGING) {
        NSString *className = NSStringFromClass([self class]);
        NSString *outputStr  = [NSString stringWithFormat:@"%zd,%s-floatValueForFrame\n", malloc_size((__bridge const void *) self), [className UTF8String]];
        printf("%s", [outputStr UTF8String]);
    }
  return returnValue;
}

- (BOOL)hasDelegateOverride {
  return self.delegate != nil;
}

- (void)setValueDelegate:(id<LOTValueDelegate> _Nonnull)delegate {
  NSAssert(([delegate conformsToProtocol:@protocol(LOTNumberValueDelegate)]), @"Number Interpolator set with incorrect callback type. Expected LOTNumberValueDelegate");
  self.delegate = (id<LOTNumberValueDelegate>)delegate;
}

@end
