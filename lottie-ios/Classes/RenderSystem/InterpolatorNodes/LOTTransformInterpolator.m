//
//  LOTTransformInterpolator.m
//  Lottie
//
//  Created by brandon_withrow on 7/18/17.
//  Copyright © 2017 Airbnb. All rights reserved.
//

#import "LOTTransformInterpolator.h"
#import "LOTHelpers.h"
#import <malloc/malloc.h>

// TODO BW Perf update, Cache transform

@implementation LOTTransformInterpolator {
  LOTPointInterpolator *_positionInterpolator;
  LOTPointInterpolator *_anchorInterpolator;
  LOTSizeInterpolator *_scaleInterpolator;
  LOTNumberInterpolator *_rotationInterpolator;
  LOTNumberInterpolator *_positionXInterpolator;
  LOTNumberInterpolator *_positionYInterpolator;
}

+ (instancetype)transformForLayer:(LOTLayer *)layer {
    NSDate *start = [NSDate date];
  LOTTransformInterpolator *interpolator = nil;
  if (layer.position) {
    interpolator = [[LOTTransformInterpolator alloc] initWithPosition:layer.position.keyframes
                                                             rotation:layer.rotation.keyframes
                                                               anchor:layer.anchor.keyframes
                                                                scale:layer.scale.keyframes];
  } else {
    interpolator = [[LOTTransformInterpolator alloc] initWithPositionX:layer.positionX.keyframes
                                                             positionY:layer.positionY.keyframes
                                                              rotation:layer.rotation.keyframes
                                                                anchor:layer.anchor.keyframes
                                                                 scale:layer.scale.keyframes];
  }
  interpolator.parentKeyName = [layer.layerName copy];
    
    NSTimeInterval timeInterval = fabs([start timeIntervalSinceNow]);
    
    NSString *outputStr  = [NSString stringWithFormat:@"%f,LOTTransformInterpolator-transformForLayer", timeInterval];
    if (ENABLE_DEBUG_TIMING_LOGGING) {
        printf("%s,%s\n", [outputStr UTF8String],[layer.layerName UTF8String]);
    }
  return interpolator;
}

- (instancetype)initWithPosition:(NSArray <LOTKeyframe *> *)position
                        rotation:(NSArray <LOTKeyframe *> *)rotation
                          anchor:(NSArray <LOTKeyframe *> *)anchor
                           scale:(NSArray <LOTKeyframe *> *)scale {
  self = [super init];
  if (self) {
    [self initializeWithPositionX:nil positionY:nil position:position rotation:rotation anchor:anchor scale:scale];
  }
    if (ENABLE_DEBUG_MEMORY_LOGGING) {
        NSString *className = NSStringFromClass([self class]);
        NSString *outputStr  = [NSString stringWithFormat:@"%zd,%s-initWithPosition\n", malloc_size((__bridge const void *) self), [className UTF8String]];
        printf("%s,%s\n", [outputStr UTF8String],[self.parentKeyName UTF8String]);
    }
  return self;
}

- (instancetype)initWithPositionX:(NSArray <LOTKeyframe *> *)positionX
                        positionY:(NSArray <LOTKeyframe *> *)positionY
                         rotation:(NSArray <LOTKeyframe *> *)rotation
                           anchor:(NSArray <LOTKeyframe *> *)anchor
                            scale:(NSArray <LOTKeyframe *> *)scale {
  self = [super init];
  if (self) {
    [self initializeWithPositionX:positionX positionY:positionY position:nil rotation:rotation anchor:anchor scale:scale];
  }
    if (ENABLE_DEBUG_MEMORY_LOGGING) {
        NSString *className = NSStringFromClass([self class]);
        NSString *outputStr  = [NSString stringWithFormat:@"%zd,%s-initWithPositionY\n", malloc_size((__bridge const void *) self), [className UTF8String]];
        printf("%s\n", [outputStr UTF8String]);
    }
  return self;
}


- (void)initializeWithPositionX:(NSArray <LOTKeyframe *> *)positionX
                      positionY:(NSArray <LOTKeyframe *> *)positionY
                       position:(NSArray <LOTKeyframe *> *)position
                       rotation:(NSArray <LOTKeyframe *> *)rotation
                         anchor:(NSArray <LOTKeyframe *> *)anchor
                          scale:(NSArray <LOTKeyframe *> *)scale {
  
  if (position) {
    _positionInterpolator = [[LOTPointInterpolator alloc] initWithKeyframes:position];
  }
  if (positionY) {
    _positionYInterpolator = [[LOTNumberInterpolator alloc] initWithKeyframes:positionY];
  }
  if (positionX) {
    _positionXInterpolator = [[LOTNumberInterpolator alloc] initWithKeyframes:positionX];
  }
  _anchorInterpolator = [[LOTPointInterpolator alloc] initWithKeyframes:anchor];
  _scaleInterpolator = [[LOTSizeInterpolator alloc] initWithKeyframes:scale];
  _rotationInterpolator = [[LOTNumberInterpolator alloc] initWithKeyframes:rotation];
}

- (BOOL)hasUpdateForFrame:(NSNumber *)frame {
  BOOL inputUpdate = _inputNode ? [_inputNode hasUpdateForFrame:frame] : NO;
  if (inputUpdate) {
    return inputUpdate;
  }
  if (_positionInterpolator) {
    return ([_positionInterpolator hasUpdateForFrame:frame] ||
            [_anchorInterpolator hasUpdateForFrame:frame] ||
            [_scaleInterpolator hasUpdateForFrame:frame] ||
            [_rotationInterpolator hasUpdateForFrame:frame]);
  }
  return ([_positionXInterpolator hasUpdateForFrame:frame] ||
          [_positionYInterpolator hasUpdateForFrame:frame] ||
          [_anchorInterpolator hasUpdateForFrame:frame] ||
          [_scaleInterpolator hasUpdateForFrame:frame] ||
          [_rotationInterpolator hasUpdateForFrame:frame]);
}

- (CATransform3D)transformForFrame:(NSNumber *)frame {
    NSDate *start = [NSDate date];
  CATransform3D baseXform = CATransform3DIdentity;
  if (_inputNode) {
    baseXform = [_inputNode transformForFrame:frame];
  }
  CGPoint position = CGPointZero;
  if (_positionInterpolator) {
    position = [_positionInterpolator pointValueForFrame:frame];
  }
  if (_positionXInterpolator &&
      _positionYInterpolator) {
    position.x = [_positionXInterpolator floatValueForFrame:frame];
    position.y = [_positionYInterpolator floatValueForFrame:frame];
  }
  CGPoint anchor = [_anchorInterpolator pointValueForFrame:frame];
  CGSize scale = [_scaleInterpolator sizeValueForFrame:frame];
  CGFloat rotation = [_rotationInterpolator floatValueForFrame:frame];
  CATransform3D translateXform = CATransform3DTranslate(baseXform, position.x, position.y, 0);
  CATransform3D rotateXform = CATransform3DRotate(translateXform, rotation, 0, 0, 1);
  CATransform3D scaleXform = CATransform3DScale(rotateXform, scale.width, scale.height, 1);
  CATransform3D anchorXform = CATransform3DTranslate(scaleXform, -1 * anchor.x, -1 * anchor.y, 0);
    
    NSTimeInterval timeInterval = fabs([start timeIntervalSinceNow]);
    
    NSString *outputStr  = [NSString stringWithFormat:@"%f,LOTTransformInterpolator-transformForFrame", timeInterval];
    if (ENABLE_DEBUG_TIMING_LOGGING) {
        printf("%s\n", [outputStr UTF8String]);
    }
    if (ENABLE_DEBUG_MEMORY_LOGGING) {
        NSString *className = NSStringFromClass([self class]);
        NSString *outputStr  = [NSString stringWithFormat:@"%zd,%s-initializeWithPositionX\n", malloc_size((__bridge const void *) self), [className UTF8String]];
        printf("%s\n", [outputStr UTF8String]);
    }
  return anchorXform;
}

@end
