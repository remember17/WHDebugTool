//
//  WHDebugMonitor.m
//  Demo
//
//  Created by wuhao on 2018/7/26.
//  Copyright © 2018年 wuhao. All rights reserved.
//  https://github.com/remember17/WHDebugTool

#import "WHDebugMonitor.h"

@implementation WHDebugMonitor {
    NSTimer *_timer;
}

WHSingletonM()

- (void)startMonitoring {
    [self stopMonitoring];
    _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(updateValue) userInfo:nil repeats:YES];
    [_timer fire];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)updateValue {
    if (self.valueBlock) {
        self.valueBlock([self getValue]);
    }
}

- (float)getValue {
    return 0.0;
}

- (void)stopMonitoring {
    [_timer invalidate];
    _timer = nil;
}

@end
