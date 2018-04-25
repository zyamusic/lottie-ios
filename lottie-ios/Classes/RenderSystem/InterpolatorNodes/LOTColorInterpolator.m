//
//  LOTColorInterpolator.m
//  Lottie
//
//  Created by brandon_withrow on 7/13/17.
//  Copyright © 2017 Airbnb. All rights reserved.
//

#import "LOTColorInterpolator.h"
#import "LOTPlatformCompat.h"
#import "UIColor+Expanded.h"
#import "LOTHelpers.h"
#import <malloc/malloc.h>

@implementation LOTColorInterpolator

- (CGColorRef)colorForFrame:(NSNumber *)frame {
    NSDate *start = [NSDate date];
  CGFloat progress = [self progressForFrame:frame];
  UIColor *returnColor;

  if (progress == 0) {
    returnColor = self.leadingKeyframe.colorValue;
  } else if (progress == 1) {
    returnColor = self.trailingKeyframe.colorValue;
  } else {
    returnColor = [UIColor LOT_colorByLerpingFromColor:self.leadingKeyframe.colorValue toColor:self.trailingKeyframe.colorValue amount:progress];
  }
  if (self.hasDelegateOverride) {
      
      NSTimeInterval timeInterval = fabs([start timeIntervalSinceNow]);
      
      NSString *outputStr  = [NSString stringWithFormat:@"%f,LOTColorInterpolator-colorForFrame", timeInterval];
      if (ENABLE_DEBUG_TIMING_LOGGING) {
          printf("%s", [outputStr UTF8String]);
      }
    return [self.delegate colorForFrame:frame.floatValue
                          startKeyframe:self.leadingKeyframe.keyframeTime.floatValue
                            endKeyframe:self.trailingKeyframe.keyframeTime.floatValue
                   interpolatedProgress:progress
                             startColor:self.leadingKeyframe.colorValue.CGColor
                               endColor:self.trailingKeyframe.colorValue.CGColor
                           currentColor:returnColor.CGColor];
  }
    NSTimeInterval timeInterval = fabs([start timeIntervalSinceNow]);
    
    NSString *outputStr  = [NSString stringWithFormat:@"%f,LOTColorInterpolator-colorForFrame", timeInterval];
    if (ENABLE_DEBUG_TIMING_LOGGING) {
        printf("%s", [outputStr UTF8String]);
    }
    if (ENABLE_DEBUG_MEMORY_LOGGING) {
        NSString *className = NSStringFromClass([self class]);
        NSString *outputStr  = [NSString stringWithFormat:@"%zd,%s-colorForFrame\n", malloc_size((__bridge const void *) self), [className UTF8String]];
        printf("%s", [outputStr UTF8String]);
    }
  return returnColor.CGColor;
}

- (void)setValueDelegate:(id<LOTValueDelegate>)delegate {
  NSAssert(([delegate conformsToProtocol:@protocol(LOTColorValueDelegate)]), @"Color Interpolator set with incorrect callback type. Expected LOTColorValueDelegate");
  self.delegate = (id<LOTColorValueDelegate>)delegate;
}

- (BOOL)hasDelegateOverride {
  return self.delegate != nil;
}

@end
