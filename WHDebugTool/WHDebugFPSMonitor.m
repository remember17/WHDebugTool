//
//  WHDebugFPSMonitor.m
//  Demo
//
//  Created by wuhao on 2018/7/26.
//  Copyright © 2018年 wuhao. All rights reserved.
//  https://github.com/remember17/WHDebugTool

#import "WHDebugFPSMonitor.h"

@interface WHDebugFPSMonitor()

@property (nonatomic, strong) CADisplayLink *displayLink;

@property (nonatomic, assign) NSTimeInterval lastTimestamp;

@property (nonatomic, assign) NSInteger performTimes;

@end

@implementation WHDebugFPSMonitor

WHSingletonM()

- (void)startMonitoring {
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkTicks:)];
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)displayLinkTicks:(CADisplayLink *)link {
    if (_lastTimestamp == 0) {
        _lastTimestamp = link.timestamp;
        return;
    }
    _performTimes ++;
    NSTimeInterval interval = link.timestamp - _lastTimestamp;
    if (interval < 1) { return; }
    _lastTimestamp = link.timestamp;
    float fps = _performTimes / interval;
    _performTimes = 0;
    if (self.valueBlock) {
        self.valueBlock(fps);
    }
}

- (void)stopMonitoring {
    [_displayLink invalidate];
}

@end
