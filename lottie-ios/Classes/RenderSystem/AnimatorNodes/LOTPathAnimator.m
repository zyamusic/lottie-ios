//
//  LOTPathAnimator.m
//  Pods
//
//  Created by brandon_withrow on 6/27/17.
//
//

#import "LOTPathAnimator.h"
#import "LOTPathInterpolator.h"
#import "LOTHelpers.h"
#import <malloc/malloc.h>

@implementation LOTPathAnimator {
  LOTShapePath *_pathConent;
  LOTPathInterpolator *_interpolator;
}

- (instancetype _Nonnull)initWithInputNode:(LOTAnimatorNode *_Nullable)inputNode
                                  shapePath:(LOTShapePath *_Nonnull)shapePath {
  self = [super initWithInputNode:inputNode keyName:shapePath.keyname];
  if (self) {
    _pathConent = shapePath;
    _interpolator = [[LOTPathInterpolator alloc] initWithKeyframes:_pathConent.shapePath.keyframes];
  }
    if (ENABLE_DEBUG_MEMORY_LOGGING) {
        NSString *className = NSStringFromClass([self class]);
        NSString *outputStr  = [NSString stringWithFormat:@"%zd,%s-initWithInputNode\n", malloc_size((__bridge const void *) self), [className UTF8String]];
        printf("%s", [outputStr UTF8String]);
    }
  return self;
}

- (NSDictionary *)valueInterpolators {
  return @{@"Path" : _interpolator};
}

- (BOOL)needsUpdateForFrame:(NSNumber *)frame {
  return [_interpolator hasUpdateForFrame:frame];
}

- (void)performLocalUpdate {
    NSDate *start = [NSDate date];
  self.localPath = [_interpolator pathForFrame:self.currentFrame cacheLengths:self.pathShouldCacheLengths];
    
    NSTimeInterval timeInterval = fabs([start timeIntervalSinceNow]);
    
    NSString *outputStr  = [NSString stringWithFormat:@"%f,LOTPathAnimator-performLocalUpdate\n", timeInterval];
    if (ENABLE_DEBUG_TIMING_LOGGING) {
        printf("%s", [outputStr UTF8String]);
    }
}

@end
