//
//  WHDebugMonitor.h
//  Demo
//
//  Created by wuhao on 2018/7/26.
//  Copyright © 2018年 wuhao. All rights reserved.
//  https://github.com/remember17/WHDebugTool

#define WHSingletonH() +(instancetype)sharedInstance;
#define WHSingletonM() static id _instance;\
+ (instancetype)sharedInstance {\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
        _instance = [[self alloc] init];\
    });\
    return _instance;\
}

#import <Foundation/Foundation.h>

typedef void(^UpdateValueBlock)(float value);

@interface WHDebugMonitor : NSObject

WHSingletonH()

- (void)startMonitoring;

- (void)stopMonitoring;

@property (nonatomic, copy) UpdateValueBlock valueBlock;

@end
