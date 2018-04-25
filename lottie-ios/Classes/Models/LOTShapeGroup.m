//
//  LOTShape.m
//  LottieAnimator
//
//  Created by Brandon Withrow on 12/14/15.
//  Copyright © 2015 Brandon Withrow. All rights reserved.
//

#import "LOTShapeGroup.h"
#import "LOTShapeFill.h"
#import "LOTShapePath.h"
#import "LOTShapeCircle.h"
#import "LOTShapeStroke.h"
#import "LOTShapeTransform.h"
#import "LOTShapeRectangle.h"
#import "LOTShapeTrimPath.h"
#import "LOTShapeGradientFill.h"
#import "LOTShapeStar.h"
#import "LOTShapeRepeater.h"
#import <malloc/malloc.h>
#import "LOTHelpers.h"

@implementation LOTShapeGroup

- (instancetype)initWithJSON:(NSDictionary *)jsonDictionary {
  self = [super init];
  if (self) {
    [self _mapFromJSON:jsonDictionary];
  }
    if (ENABLE_DEBUG_MEMORY_LOGGING) {
        NSString *className = NSStringFromClass([self class]);
        NSString *outputStr  = [NSString stringWithFormat:@"%zd,%s-initWithJSON\n", malloc_size((__bridge const void *) self), [className UTF8String]];
        printf("%s,%s", [outputStr UTF8String],[self.keyname UTF8String]);
    }
  return self;
}

- (void)_mapFromJSON:(NSDictionary *)jsonDictionary {
  
  if (jsonDictionary[@"nm"] ) {
    _keyname = [jsonDictionary[@"nm"] copy];
  }
  
  NSArray *itemsJSON = jsonDictionary[@"it"];
  NSMutableArray *items = [NSMutableArray array];
  for (NSDictionary *itemJSON in itemsJSON) {
    id newItem = [LOTShapeGroup shapeItemWithJSON:itemJSON];
    if (newItem) {
      [items addObject:newItem];
    }
  }
  _items = items;
}

+ (id)shapeItemWithJSON:(NSDictionary *)itemJSON {
  NSString *type = itemJSON[@"ty"];
  if ([type isEqualToString:@"gr"]) {
    LOTShapeGroup *group = [[LOTShapeGroup alloc] initWithJSON:itemJSON];
      if (ENABLE_DEBUG_MEMORY_LOGGING) {
          NSString *className = NSStringFromClass([self class]);
          NSString *outputStr  = [NSString stringWithFormat:@"%zd,%s-shapeItemWithJSON-shapeGroup\n", malloc_size((__bridge const void *) self), [className UTF8String]];
          printf("%s", [outputStr UTF8String]);
      }
    return group;
  } else if ([type isEqualToString:@"st"]) {
    LOTShapeStroke *stroke = [[LOTShapeStroke alloc] initWithJSON:itemJSON];
      if (ENABLE_DEBUG_MEMORY_LOGGING) {
          NSString *className = NSStringFromClass([self class]);
          NSString *outputStr  = [NSString stringWithFormat:@"%zd,%s-shapeItemWithJSON-shapeStroke\n", malloc_size((__bridge const void *) self), [className UTF8String]];
          printf("%s", [outputStr UTF8String]);
      }
    return stroke;
  } else if ([type isEqualToString:@"fl"]) {
    LOTShapeFill *fill = [[LOTShapeFill alloc] initWithJSON:itemJSON];
      if (ENABLE_DEBUG_MEMORY_LOGGING) {
          NSString *className = NSStringFromClass([self class]);
          NSString *outputStr  = [NSString stringWithFormat:@"%zd,%s-shapeItemWithJSON-shapeFill\n", malloc_size((__bridge const void *) self), [className UTF8String]];
          printf("%s", [outputStr UTF8String]);
      }
    return fill;
  } else if ([type isEqualToString:@"tr"]) {
    LOTShapeTransform *transform = [[LOTShapeTransform alloc] initWithJSON:itemJSON];
      if (ENABLE_DEBUG_MEMORY_LOGGING) {
          NSString *className = NSStringFromClass([self class]);
          NSString *outputStr  = [NSString stringWithFormat:@"%zd,%s-shapeItemWithJSON-shapeTransform\n", malloc_size((__bridge const void *) self), [className UTF8String]];
          printf("%s", [outputStr UTF8String]);
      }
    return transform;
  } else if ([type isEqualToString:@"sh"]) {
    LOTShapePath *path = [[LOTShapePath alloc] initWithJSON:itemJSON];
      if (ENABLE_DEBUG_MEMORY_LOGGING) {
          NSString *className = NSStringFromClass([self class]);
          NSString *outputStr  = [NSString stringWithFormat:@"%zd,%s-shapeItemWithJSON-shapePath\n", malloc_size((__bridge const void *) self), [className UTF8String]];
          printf("%s", [outputStr UTF8String]);
      }
    return path;
  } else if ([type isEqualToString:@"el"]) {
    LOTShapeCircle *circle = [[LOTShapeCircle alloc] initWithJSON:itemJSON];
      if (ENABLE_DEBUG_MEMORY_LOGGING) {
          NSString *className = NSStringFromClass([self class]);
          NSString *outputStr  = [NSString stringWithFormat:@"%zd,%s-shapeItemWithJSON-shapeCircle\n", malloc_size((__bridge const void *) self), [className UTF8String]];
          printf("%s", [outputStr UTF8String]);
      }
    return circle;
  } else if ([type isEqualToString:@"rc"]) {
    LOTShapeRectangle *rectangle = [[LOTShapeRectangle alloc] initWithJSON:itemJSON];
      if (ENABLE_DEBUG_MEMORY_LOGGING) {
          NSString *className = NSStringFromClass([self class]);
          NSString *outputStr  = [NSString stringWithFormat:@"%zd,%s-shapeItemWithJSON-shapeRectangle\n", malloc_size((__bridge const void *) self), [className UTF8String]];
          printf("%s", [outputStr UTF8String]);
      }
    return rectangle;
  } else if ([type isEqualToString:@"tm"]) {
    LOTShapeTrimPath *trim = [[LOTShapeTrimPath alloc] initWithJSON:itemJSON];
      if (ENABLE_DEBUG_MEMORY_LOGGING) {
          NSString *className = NSStringFromClass([self class]);
          NSString *outputStr  = [NSString stringWithFormat:@"%zd,%s-shapeItemWithJSON-shapeTrimPath\n", malloc_size((__bridge const void *) self), [className UTF8String]];
          printf("%s", [outputStr UTF8String]);
      }
    return trim;
  } else  if ([type isEqualToString:@"gs"]) {
    NSLog(@"%s: Warning: gradient strokes are not supported", __PRETTY_FUNCTION__);
  } else  if ([type isEqualToString:@"gf"]) {
    LOTShapeGradientFill *gradientFill = [[LOTShapeGradientFill alloc] initWithJSON:itemJSON];
      if (ENABLE_DEBUG_MEMORY_LOGGING) {
          NSString *className = NSStringFromClass([self class]);
          NSString *outputStr  = [NSString stringWithFormat:@"%zd,%s-shapeItemWithJSON-shapeGradientFill\n", malloc_size((__bridge const void *) self), [className UTF8String]];
          printf("%s", [outputStr UTF8String]);
      }
    return gradientFill;
  } else if ([type isEqualToString:@"sr"]) {
    LOTShapeStar *star = [[LOTShapeStar alloc] initWithJSON:itemJSON];
      if (ENABLE_DEBUG_MEMORY_LOGGING) {
          NSString *className = NSStringFromClass([self class]);
          NSString *outputStr  = [NSString stringWithFormat:@"%zd,%s-shapeItemWithJSON-shapeStar\n", malloc_size((__bridge const void *) self), [className UTF8String]];
          printf("%s", [outputStr UTF8String]);
      }
    return star;
  } else if ([type isEqualToString:@"mm"]) {
    NSString *name = itemJSON[@"nm"];
    NSLog(@"%s: Warning: merge shape is not supported. name: %@", __PRETTY_FUNCTION__, name);
  } else if ([type isEqualToString:@"rp"]) {
    LOTShapeRepeater *repeater = [[LOTShapeRepeater alloc] initWithJSON:itemJSON];
      if (ENABLE_DEBUG_MEMORY_LOGGING) {
          NSString *className = NSStringFromClass([self class]);
          NSString *outputStr  = [NSString stringWithFormat:@"%zd,%s-shapeItemWithJSON-shapeRepeater\n", malloc_size((__bridge const void *) self), [className UTF8String]];
          printf("%s", [outputStr UTF8String]);
      }
    return repeater;
  } else {
    NSString *name = itemJSON[@"nm"];
    NSLog(@"%s: Unsupported shape: %@ name: %@", __PRETTY_FUNCTION__, type, name);
  }
  
  return nil;
}

- (NSString *)description {
    NSMutableString *text = [[super description] mutableCopy];
    [text appendFormat:@" items: %@", self.items];
    return text;
}

@end
