//
//  WHDebugToolManager.m
//  WHDebugTool
//
//  Created by wuhao on 2018/7/17.
//  Copyright © 2018年 wuhao. All rights reserved.
//  https://github.com/remember17/WHDebugTool

#import "WHDebugToolManager.h"
#import "WHDebugFPSMonitor.h"
#import "WHDebugCpuMonitor.h"
#import "WHDebugMemoryMonitor.h"
#import "WHDebugConsoleLabel.h"
#import "WHDebugTempVC.h"

#define kDebugIsiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDebugScreenWidth [UIScreen mainScreen].bounds.size.width
#define kDebugLabelWidth 70
#define kDebugLabelHeight 20
#define KDebugMargin 20
#define kMemoryOriginFrame CGRectMake(-kDebugLabelWidth, 0, kDebugLabelWidth, kDebugLabelHeight)
#define kFpsOriginFrame CGRectMake(kDebugScreenWidth + kDebugLabelWidth, 0, kDebugLabelWidth, kDebugLabelHeight)
#define kCpuOriginFrame CGRectMake((kDebugScreenWidth - kDebugLabelWidth) / 2, -kDebugLabelHeight, kDebugLabelWidth, kDebugLabelHeight)

@interface WHDebugToolManager()

@property (nonatomic, strong) WHDebugConsoleLabel *memoryLabel;

@property (nonatomic, strong) WHDebugConsoleLabel *fpsLabel;

@property (nonatomic, strong) WHDebugConsoleLabel *cpuLabel;

@property (nonatomic, assign) BOOL isShowing;

@property(nonatomic, strong) UIWindow *debugWindow;

@end

@implementation WHDebugToolManager

static id _instance;
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

#pragma mark - Show with type

- (void)toggleWith:(DebugToolType)type {
    if (self.isShowing) {
        [self hide];
    } else {
        [self showWith:type];
    }
}

- (void)showWith:(DebugToolType)type {
    [self clearUp];
    [self setDebugWindow];
    
    if (type & DebugToolTypeFPS) {
        [self showFPS];
    }
    
    if (type & DebugToolTypeMemory) {
        [self showMemory];
    }
    
    if (type & DebugToolTypeCPU) {
        [self showCPU];
    }
}

#pragma mark - Window

- (void)setDebugWindow {
    CGFloat debugWindowY = kDebugIsiPhoneX ? 30 : 0;
    self.debugWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, debugWindowY, kDebugScreenWidth, kDebugLabelHeight)];
    self.debugWindow.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    self.debugWindow.windowLevel = UIWindowLevelAlert;
    self.debugWindow.rootViewController = [WHDebugTempVC new];
    self.debugWindow.hidden = NO;
}

#pragma mark - Show

- (void)showFPS {
    [[WHDebugFPSMonitor sharedInstance] startMonitoring];
    [WHDebugFPSMonitor sharedInstance].valueBlock = ^(float value) {
        [self.fpsLabel updateLabelWith:DebugToolLabelTypeFPS value:value];
    };
    [self show:self.fpsLabel];
}

- (void)showMemory {
    [[WHDebugMemoryMonitor sharedInstance] startMonitoring];
    [WHDebugMemoryMonitor sharedInstance].valueBlock = ^(float value) {
        [self.memoryLabel updateLabelWith:DebugToolLabelTypeMemory value:value];
    };
    [self show:self.memoryLabel];
}

- (void)showCPU {
    [[WHDebugCpuMonitor sharedInstance] startMonitoring];
    [WHDebugCpuMonitor sharedInstance].valueBlock = ^(float value) {
        [self.cpuLabel updateLabelWith:DebugToolLabelTypeCPU value:value];
    };
    [self show:self.cpuLabel];
}

- (void)show:(WHDebugConsoleLabel *)consoleLabel {
    [self.debugWindow addSubview:consoleLabel];
    CGRect consoleLabelFrame = CGRectZero;
    if (consoleLabel == self.cpuLabel) {
        consoleLabelFrame = CGRectMake((kDebugScreenWidth - kDebugLabelWidth) / 2, 0, kDebugLabelWidth, kDebugLabelHeight);
    } else if (consoleLabel == self.fpsLabel) {
        consoleLabelFrame = CGRectMake(kDebugScreenWidth - kDebugLabelWidth - KDebugMargin, 0, kDebugLabelWidth, kDebugLabelHeight);
    } else {
        consoleLabelFrame = CGRectMake(KDebugMargin, 0, kDebugLabelWidth, kDebugLabelHeight);
    }
    [UIView animateWithDuration:0.3 animations:^{
        consoleLabel.frame = consoleLabelFrame;
    }completion:^(BOOL finished) {
        self.isShowing = YES;
    }];
}

#pragma mark - Hide

- (void)hide {
    [UIView animateWithDuration:0.3 animations:^{
        self.cpuLabel.frame = kCpuOriginFrame;
        self.memoryLabel.frame = kMemoryOriginFrame;
        self.fpsLabel.frame = kFpsOriginFrame;
    }completion:^(BOOL finished) {
        [self clearUp];
    }];
}

#pragma mark - Clear

- (void)clearUp {
    [[WHDebugFPSMonitor sharedInstance] stopMonitoring];
    [[WHDebugMemoryMonitor sharedInstance] stopMonitoring];
    [[WHDebugCpuMonitor sharedInstance] stopMonitoring];
    [self.fpsLabel removeFromSuperview];
    [self.memoryLabel removeFromSuperview];
    [self.cpuLabel removeFromSuperview];
    self.debugWindow.hidden = YES;
    self.fpsLabel = nil;
    self.memoryLabel = nil;
    self.cpuLabel = nil;
    self.debugWindow = nil;
    self.isShowing = NO;
}

#pragma mark - Label

- (WHDebugConsoleLabel *)memoryLabel {
    if (!_memoryLabel) {
        _memoryLabel = [[WHDebugConsoleLabel alloc] initWithFrame:kMemoryOriginFrame];
    }
    return _memoryLabel;
}

-(WHDebugConsoleLabel *)cpuLabel {
    if (!_cpuLabel) {
        _cpuLabel = [[WHDebugConsoleLabel alloc] initWithFrame:kCpuOriginFrame];
    }
    return _cpuLabel;
}

- (WHDebugConsoleLabel *)fpsLabel {
    if (!_fpsLabel) {
        _fpsLabel = [[WHDebugConsoleLabel alloc] initWithFrame:kFpsOriginFrame];
    }
    return _fpsLabel;
}

@end
