//
//  WHDebugFPSMonitor.h
//  WHDebugTool
//
//  Created by wuhao on 2018/7/17.
//  Copyright © 2018年 wuhao. All rights reserved.
//  https://github.com/remember17/WHDebugTool

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^FPSBlock)(float fps);

@interface WHDebugFPSMonitor : NSObject

+ (instancetype)sharedInstance;

- (void)startMonitoring;

- (void)stopMonitoring;

@property (nonatomic, copy) FPSBlock fpsBlock;

@end
