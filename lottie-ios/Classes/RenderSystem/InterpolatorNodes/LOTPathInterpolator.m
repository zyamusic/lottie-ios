//
//  LOTPathInterpolator.m
//  Lottie
//
//  Created by brandon_withrow on 7/13/17.
//  Copyright © 2017 Airbnb. All rights reserved.
//

#import "LOTPathInterpolator.h"
#import "CGGeometry+LOTAdditions.h"
#import "LOTHelpers.h"
#import <malloc/malloc.h>

@implementation LOTPathInterpolator

- (LOTBezierPath *)pathForFrame:(NSNumber *)frame cacheLengths:(BOOL)cacheLengths {
    NSDate *start = [NSDate date];
  CGFloat progress = [self progressForFrame:frame];
  if (self.hasDelegateOverride) {
    CGPathRef callBackPath = [self.delegate pathForFrame:frame.floatValue
                                           startKeyframe:self.leadingKeyframe.keyframeTime.floatValue
                                             endKeyframe:self.trailingKeyframe.keyframeTime.floatValue
                                    interpolatedProgress:progress];
      
      NSTimeInterval timeInterval = fabs([start timeIntervalSinceNow]);
      
      NSString *outputStr  = [NSString stringWithFormat:@"%f,LOTPathInterpolator-pathForFrame\n", timeInterval];
      if (ENABLE_DEBUG_TIMING_LOGGING) {
          printf("%s", [outputStr UTF8String]);
      }
      if (ENABLE_DEBUG_MEMORY_LOGGING) {
          NSString *className = NSStringFromClass([self class]);
          NSString *outputStr  = [NSString stringWithFormat:@"%zd,%s-pathForFrame\n", malloc_size((__bridge const void *) self), [className UTF8String]];
          printf("%s", [outputStr UTF8String]);
      }
    return [LOTBezierPath pathWithCGPath:callBackPath];
  }

  LOTBezierPath *returnPath = [[LOTBezierPath alloc] init];
  returnPath.cacheLengths = cacheLengths;
  LOTBezierData *leadingData = self.leadingKeyframe.pathData;
  LOTBezierData *trailingData = self.trailingKeyframe.pathData;
  NSInteger vertexCount = leadingData ? leadingData.count : trailingData.count;
  BOOL closePath = leadingData ? leadingData.closed : trailingData.closed;
  CGPoint cp1 = CGPointMake(0, 0);
  CGPoint cp2, p1, cp3 = CGPointZero;
  CGPoint startPoint = CGPointMake(0, 0);
  CGPoint startInTangent = CGPointMake(0, 0);
  for (int i = 0; i < vertexCount; i++) {
    if (progress == 0) {
      cp2 = [leadingData inTangentAtIndex:i];
      p1 = [leadingData vertexAtIndex:i];
      cp3 = [leadingData outTangentAtIndex:i];
    } else if (progress == 1) {
      cp2 = [trailingData inTangentAtIndex:i];
      p1 = [trailingData vertexAtIndex:i];
      cp3 = [trailingData outTangentAtIndex:i];
    } else {
      cp2 = LOT_PointInLine([leadingData inTangentAtIndex:i],
                            [trailingData inTangentAtIndex:i],
                            progress);
      p1 = LOT_PointInLine([leadingData vertexAtIndex:i],
                           [trailingData vertexAtIndex:i],
                           progress);
      cp3 = LOT_PointInLine([leadingData outTangentAtIndex:i],
                            [trailingData outTangentAtIndex:i],
                            progress);
    }
    if (i == 0) {
      startPoint = p1;
      startInTangent = cp2;
      [returnPath LOT_moveToPoint:p1];
    } else {
      [returnPath LOT_addCurveToPoint:p1 controlPoint1:cp1 controlPoint2:cp2];
    }
    cp1 = cp3;
  }
  
  if (closePath) {
    [returnPath LOT_addCurveToPoint:startPoint controlPoint1:cp3 controlPoint2:startInTangent];
    [returnPath LOT_closePath];
  }
    NSTimeInterval timeInterval = fabs([start timeIntervalSinceNow]);
    
    NSString *outputStr  = [NSString stringWithFormat:@"%f,LOTPathInterpolator-pathForFrame\n", timeInterval];
    if (ENABLE_DEBUG_TIMING_LOGGING) {
        printf("%s", [outputStr UTF8String]);
    }
  return returnPath;
}

- (void)setValueDelegate:(id<LOTValueDelegate>)delegate {
  NSAssert(([delegate conformsToProtocol:@protocol(LOTPathValueDelegate)]), @"Path Interpolator set with incorrect callback type. Expected LOTPathValueDelegate");
  self.delegate = (id<LOTPathValueDelegate>)delegate;
}

- (BOOL)hasDelegateOverride {
  return self.delegate != nil;
}

@end
