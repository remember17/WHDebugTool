//
//  WHDebugToolManager.h
//  WHDebugTool
//
//  Created by wuhao on 2018/7/17.
//  Copyright © 2018年 wuhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, DebugToolType) {
    DebugToolTypeAll = 0,   // FPS & Memory & CPU
    DebugToolTypeFPS,       // FPS
    DebugToolTypeMemory,    // Memory
    DebugToolTypeCPU,       // CPU
    DebugToolTypeFPSMemory, // FPS & Memory
    DebugToolTypeFPSCPU,    // FPS & CPU
    DebugToolTypeCPUMemory, // Memory & CPU
};

@interface WHDebugToolManager : NSObject

+ (instancetype)sharedInstance;

/**
 开关
 @param type 显示类型
 */
- (void)toggleWith:(DebugToolType)type;

- (void)showWith:(DebugToolType)type;

- (void)hideWith:(DebugToolType)type;

@end
