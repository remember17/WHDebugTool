//
//  WHDebugMemoryMonitor.m
//  Demo
//
//  Created by wuhao on 2018/7/26.
//  Copyright © 2018年 wuhao. All rights reserved.
//  https://github.com/remember17/WHDebugTool

#import "WHDebugMemoryMonitor.h"
#import <mach/mach.h>

@implementation WHDebugMemoryMonitor

WHSingletonM()

- (float)getValue {
    task_basic_info_data_t taskInfo;
    mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
    kern_return_t kernReturn = task_info(mach_task_self(),
                                         TASK_BASIC_INFO,
                                         (task_info_t)&taskInfo,
                                         &infoCount);
    if (kernReturn != KERN_SUCCESS) { return NSNotFound; }
    return taskInfo.resident_size/1024.0/1024.0;
}

@end
