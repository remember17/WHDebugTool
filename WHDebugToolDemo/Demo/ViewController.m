//
//  ViewController.m
//  Demo
//  https://www.jianshu.com/p/0d94a81a31db
//  Created by 吴浩 on 2018/7/22.
//  Copyright © 2018年 wuhao. All rights reserved.
//  https://github.com/remember17/WHDebugTool

#import "ViewController.h"
#import "WHDebugToolManager.h"

@implementation ViewController

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // DebugToolTypeMemory | DebugToolTypeCPU | DebugToolTypeFPS
    [[WHDebugToolManager sharedInstance] toggleWith:DebugToolTypeMemory | DebugToolTypeCPU | DebugToolTypeFPS];
}

@end
