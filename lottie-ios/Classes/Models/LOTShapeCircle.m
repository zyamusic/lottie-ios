//
//  LOTShapeCircle.m
//  LottieAnimator
//
//  Created by Brandon Withrow on 12/15/15.
//  Copyright © 2015 Brandon Withrow. All rights reserved.
//

#import "LOTShapeCircle.h"
#import <malloc/malloc.h>
#import "LOTHelpers.h"

@implementation LOTShapeCircle

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
  
  NSDictionary *position = jsonDictionary[@"p"];
  if (position) {
    _position = [[LOTKeyframeGroup alloc] initWithData:position];
  }
  
  NSDictionary *size= jsonDictionary[@"s"];
  if (size) {
    _size = [[LOTKeyframeGroup alloc] initWithData:size];
  }
  NSNumber *reversed = jsonDictionary[@"d"];
  _reversed = (reversed.integerValue == 3);
    if (ENABLE_DEBUG_MEMORY_LOGGING) {
        NSString *className = NSStringFromClass([self class]);
        NSString *outputStr  = [NSString stringWithFormat:@"%zd,LOTBaseModelInit,%s\n", malloc_size((__bridge const void *) self), [className UTF8String]];
        printf("%s", [outputStr UTF8String]);
    }
}

@end
