//
//  LOTShapeFill.m
//  LottieAnimator
//
//  Created by Brandon Withrow on 12/15/15.
//  Copyright © 2015 Brandon Withrow. All rights reserved.
//

#import "LOTShapeFill.h"
#import "CGGeometry+LOTAdditions.h"
#import <malloc/malloc.h>
#import "LOTHelpers.h"

@implementation LOTShapeFill

- (instancetype)initWithJSON:(NSDictionary *)jsonDictionary {
  self = [super init];
  if (self) {
    [self _mapFromJSON:jsonDictionary];
  }
    if (ENABLE_DEBUG_MEMORY_LOGGING) {
        NSString *className = NSStringFromClass([self class]);
        NSString *outputStr  = [NSString stringWithFormat:@"%zd,LOTBaseModelInit,%s\n", malloc_size((__bridge const void *) self), [className UTF8String]];
        printf("%s", [outputStr UTF8String]);
    }
  return self;
}

- (void)_mapFromJSON:(NSDictionary *)jsonDictionary {
  
  if (jsonDictionary[@"nm"] ) {
    _keyname = [jsonDictionary[@"nm"] copy];
  }
  
  NSDictionary *color = jsonDictionary[@"c"];
  if (color) {
    _color = [[LOTKeyframeGroup alloc] initWithData:color];
  }
  
  NSDictionary *opacity = jsonDictionary[@"o"];
  if (opacity) {
    _opacity = [[LOTKeyframeGroup alloc] initWithData:opacity];
    [_opacity remapKeyframesWithBlock:^CGFloat(CGFloat inValue) {
      return LOT_RemapValue(inValue, 0, 100, 0, 1);
    }];
  }
  
  NSNumber *evenOdd = jsonDictionary[@"r"];
  if (evenOdd.integerValue == 2) {
    _evenOddFillRule = YES;
  } else {
    _evenOddFillRule = NO;
  }
  
  NSNumber *fillEnabled = jsonDictionary[@"fillEnabled"];
  _fillEnabled = fillEnabled.boolValue;
    if (ENABLE_DEBUG_MEMORY_LOGGING) {
        NSString *className = NSStringFromClass([self class]);
        NSString *outputStr  = [NSString stringWithFormat:@"%zd,LOTBaseModelInit,%s\n", malloc_size((__bridge const void *) self), [className UTF8String]];
        printf("%s", [outputStr UTF8String]);
    }
}

@end
