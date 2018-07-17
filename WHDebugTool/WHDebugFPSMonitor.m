//
//  WHDebugFPSMonitor.m
//  WHDebugTool
//
//  Created by wuhao on 2018/7/17.
//  Copyright © 2018年 wuhao. All rights reserved.
//

#import "WHDebugFPSMonitor.h"

@interface WHDebugFPSMonitor()

@property (nonatomic, strong) CADisplayLink *displayLink;

@property (nonatomic, assign) NSTimeInterval lastTimestamp;

@property (nonatomic, assign) NSInteger performTimes;

@end

@implementation WHDebugFPSMonitor

static id _instance;
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (void)startMonitoring {
    [self setDisplayLink];
}

- (void)setDisplayLink {
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkTicks:)];
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)displayLinkTicks:(CADisplayLink *)link {
    _performTimes ++;
    if (_lastTimestamp == 0) {
        _lastTimestamp = link.timestamp;
        return;
    }
    NSTimeInterval interval = link.timestamp - _lastTimestamp;
    if (interval >= 1) {
        float fps = _performTimes / interval;
        _performTimes = 0;
        _lastTimestamp = link.timestamp;
        if (self.fpsBlock) {
            self.fpsBlock(fps);
        }
    }
}

- (void)stopMonitoring {
    [_displayLink invalidate];
}

- (void)dealloc {
    [self stopMonitoring];
}

@end
