//
//  LOTShapeTrimPath.m
//  LottieAnimator
//
//  Created by brandon_withrow on 7/26/16.
//  Copyright © 2016 Brandon Withrow. All rights reserved.
//

#import "LOTShapeTrimPath.h"
#import <malloc/malloc.h>
#import "LOTHelpers.h"

@implementation LOTShapeTrimPath

- (instancetype)initWithJSON:(NSDictionary *)jsonDictionary {
  self = [super init];
  if (self) {
    [self _mapFromJSON:jsonDictionary];
  }
    if (ENABLE_DEBUG_MEMORY_LOGGING) {
        NSString *className = NSStringFromClass([self class]);
        NSString *outputStr  = [NSString stringWithFormat:@"%zd,%s-initWithJSON\n", malloc_size((__bridge const void *) self), [className UTF8String]];
        printf("%s,%s\n", [outputStr UTF8String],[self.keyname UTF8String]);
    }
  return self;
}

- (void)_mapFromJSON:(NSDictionary *)jsonDictionary {
  
  if (jsonDictionary[@"nm"] ) {
    _keyname = [jsonDictionary[@"nm"] copy];
  }
  
  NSDictionary *start = jsonDictionary[@"s"];
  if (start) {
    _start = [[LOTKeyframeGroup alloc] initWithData:start];
  }
  
  NSDictionary *end = jsonDictionary[@"e"];
  if (end) {
    _end = [[LOTKeyframeGroup alloc] initWithData:end];
  }
  
  NSDictionary *offset = jsonDictionary[@"o"];
  if (offset) {
    _offset = [[LOTKeyframeGroup alloc] initWithData:offset];
  }
    if (ENABLE_DEBUG_MEMORY_LOGGING) {
        NSString *className = NSStringFromClass([self class]);
        NSString *outputStr  = [NSString stringWithFormat:@"%zd,%s-_mapFromJSON\n", malloc_size((__bridge const void *) self), [className UTF8String]];
        printf("%s,%s\n", [outputStr UTF8String],[self.keyname UTF8String]);
    }
}

@end
