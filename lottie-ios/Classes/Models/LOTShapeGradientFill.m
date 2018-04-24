//
//  LOTShapeGradientFill.m
//  Lottie
//
//  Created by brandon_withrow on 7/26/17.
//  Copyright © 2017 Airbnb. All rights reserved.
//

#import "LOTShapeGradientFill.h"
#import "CGGeometry+LOTAdditions.h"
#import <malloc/malloc.h>
#import "LOTHelpers.h"

@implementation LOTShapeGradientFill

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
  
  NSNumber *type = jsonDictionary[@"t"];
  
  if (type.integerValue != 1) {
    _type = LOTGradientTypeRadial;
  } else {
    _type = LOTGradientTypeLinear;
  }
  
  NSDictionary *start = jsonDictionary[@"s"];
  if (start) {
    _startPoint = [[LOTKeyframeGroup alloc] initWithData:start];
  }
  
  NSDictionary *end = jsonDictionary[@"e"];
  if (end) {
    _endPoint = [[LOTKeyframeGroup alloc] initWithData:end];
  }
  
  NSDictionary *gradient = jsonDictionary[@"g"];
  if (gradient) {
    NSDictionary *unwrappedGradient = gradient[@"k"];
    _numberOfColors = gradient[@"p"];
    _gradient = [[LOTKeyframeGroup alloc] initWithData:unwrappedGradient];
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
    if (ENABLE_DEBUG_MEMORY_LOGGING) {
        NSString *className = NSStringFromClass([self class]);
        NSString *outputStr  = [NSString stringWithFormat:@"%zd,LOTBaseModelInit,%s\n", malloc_size((__bridge const void *) self), [className UTF8String]];
        printf("%s", [outputStr UTF8String]);
    }
}
@end
