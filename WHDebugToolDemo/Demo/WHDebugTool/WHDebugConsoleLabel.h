//
//  WHDebugConsoleLabel.h
//  WHDebugTool
//
//  Created by wuhao on 2018/7/17.
//  Copyright © 2018年 wuhao. All rights reserved.
//  https://github.com/remember17/WHDebugTool

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, DebugToolLabelType) {
    DebugToolLabelTypeFPS,     
    DebugToolLabelTypeMemory,
    DebugToolLabelTypeCPU
};

@interface WHDebugConsoleLabel : UILabel

- (void)updateLabelWith:(DebugToolLabelType)labelType value:(float)value;

@end
