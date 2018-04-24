//
//  LOTMask.m
//  LottieAnimator
//
//  Created by Brandon Withrow on 12/14/15.
//  Copyright © 2015 Brandon Withrow. All rights reserved.
//

#import "LOTMask.h"
#import "CGGeometry+LOTAdditions.h"
#import <malloc/malloc.h>
#import "LOTHelpers.h"

@implementation LOTMask

- (instancetype)initWithJSON:(NSDictionary *)jsonDictionary {
  self = [super init];
  if (self) {
    [self _mapFromJSON:jsonDictionary];
  }
    if (ENABLE_DEBUG_MEMORY_LOGGING) {
        NSString *className = NSStringFromClass([self class]);
        NSString *outputStr  = [NSString stringWithFormat:@"%zd,%s-initWithJSON\n", malloc_size((__bridge const void *) self), [className UTF8String]];
        printf("%s", [outputStr UTF8String]);
    }
  return self;
}

- (void)_mapFromJSON:(NSDictionary *)jsonDictionary {
  NSNumber *closed = jsonDictionary[@"cl"];
  _closed = closed.boolValue;
  
  NSNumber *inverted = jsonDictionary[@"inv"];
  _inverted = inverted.boolValue;
  
  NSString *mode = jsonDictionary[@"mode"];
  if ([mode isEqualToString:@"a"]) {
    _maskMode = LOTMaskModeAdd;
  } else if ([mode isEqualToString:@"s"]) {
    _maskMode = LOTMaskModeSubtract;
  } else if ([mode isEqualToString:@"i"]) {
    _maskMode = LOTMaskModeIntersect;
  } else {
    _maskMode = LOTMaskModeUnknown;
  }
  
  NSDictionary *maskshape = jsonDictionary[@"pt"];
  if (maskshape) {
    _maskPath = [[LOTKeyframeGroup alloc] initWithData:maskshape];
  }
  
  NSDictionary *opacity = jsonDictionary[@"o"];
  if (opacity) {
    _opacity = [[LOTKeyframeGroup alloc] initWithData:opacity];
    [_opacity remapKeyframesWithBlock:^CGFloat(CGFloat inValue) {
      return LOT_RemapValue(inValue, 0, 100, 0, 1);
    }];
  }
  
  NSDictionary *expansion = jsonDictionary[@"x"];
  if (expansion) {
    _expansion = [[LOTKeyframeGroup alloc] initWithData:expansion];
  }
    if (ENABLE_DEBUG_MEMORY_LOGGING) {
        NSString *className = NSStringFromClass([self class]);
        NSString *outputStr  = [NSString stringWithFormat:@"%zd,%s-_mapFromJSON\n", malloc_size((__bridge const void *) self), [className UTF8String]];
        printf("%s", [outputStr UTF8String]);
    }
}

@end
