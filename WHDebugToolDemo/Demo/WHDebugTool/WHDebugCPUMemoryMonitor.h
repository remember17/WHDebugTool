//
//  WHDebugCPUMemoryMonitor.h
//  WHDebugTool
//
//  Created by wuhao on 2018/7/17.
//  Copyright © 2018年 wuhao. All rights reserved.
//  https://github.com/remember17/WHDebugTool

#import <Foundation/Foundation.h>

typedef void(^MemoryBlock)(float memory);

typedef void(^CPUBlock)(float cpu);

@interface WHDebugCPUMemoryMonitor : NSObject

+ (instancetype)sharedInstance;

- (void)startMonitoring;

- (void)stopMonitoring;

@property (nonatomic, copy) MemoryBlock memeryBlock;

@property (nonatomic, copy) CPUBlock cpuBlock;

@end
