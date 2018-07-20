//
//  WHDebugConsoleLabel.h
//  WHDebugTool
//
//  Created by wuhao on 2018/7/17.
//  Copyright © 2018年 wuhao. All rights reserved.
//  https://github.com/remember17/WHDebugTool

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, DebugToolLabelType) {
    DebugToolLabelTypeFPS,      // FPS
    DebugToolLabelTypeMemory,   // 内存
    DebugToolLabelTypeCPU       // CPU
};

@interface WHDebugConsoleLabel : UILabel

/**
 更新label内容
 
 @param labelType 监测类型
 @param value FPS/内存 值
 */
- (void)updateLabelWith:(DebugToolLabelType)labelType value:(float)value;

@end
