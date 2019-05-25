//
//  WHDebugToolManager.h
//  WHDebugTool
//  https://www.jianshu.com/p/0d94a81a31db
//  Created by wuhao on 2018/7/17.
//  Copyright © 2018年 wuhao. All rights reserved.
//  https://github.com/remember17/WHDebugTool

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, DebugToolType) {
    DebugToolTypeFPS    = 1 << 0,
    DebugToolTypeCPU    = 1 << 1,
    DebugToolTypeMemory = 1 << 2,
    DebugToolTypeAll    = (DebugToolTypeFPS | DebugToolTypeCPU | DebugToolTypeMemory)
};

@interface WHDebugToolManager : NSObject

/** switch on/off */
+ (void)toggleWith:(DebugToolType)type;

+ (void)showWith:(DebugToolType)type;

+ (void)hide;


































+ (instancetype)sharedInstance;

- (void)toggleWith:(DebugToolType)type;

- (void)showWith:(DebugToolType)type;

- (void)hide;

@end
