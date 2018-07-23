//
//  WHDebugToolManager.m
//  WHDebugTool
//
//  Created by wuhao on 2018/7/17.
//  Copyright © 2018年 wuhao. All rights reserved.
//  https://github.com/remember17/WHDebugTool

#import "WHDebugToolManager.h"
#import "WHDebugFPSMonitor.h"
#import "WHDebugCPUMemoryMonitor.h"
#import "WHDebugConsoleLabel.h"

#define kDebugIsiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDebugScreenWidth [UIScreen mainScreen].bounds.size.width
#define kDebugLabelWidth 70
#define kDebugLabelHeight 20
#define KDebugMargin 20

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
        [self hideWith:type];
    } else {
        [self showWith:type];
    }
}

- (void)showWith:(DebugToolType)type {
    [self deinitWindow];
    [self setDebugWindow];
    
    if (type & DebugToolTypeMemory ||
        type & DebugToolTypeCPU) {
        [[WHDebugCPUMemoryMonitor sharedInstance] startMonitoring];
    }
    
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

- (void)hideWith:(DebugToolType)type {
    if (type & DebugToolTypeFPS) {
        [self hideFPS];
    }
    
    if (type & DebugToolTypeMemory) {
        [self hideMemory];
    }
    
    if (type & DebugToolTypeCPU) {
        [self hideCPU];
    }
}

#pragma mark - Window

- (void)setDebugWindow {
    CGFloat debugWindowY = kDebugIsiPhoneX ? 30 : 0;
    self.debugWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, debugWindowY, kDebugScreenWidth, kDebugLabelHeight)];
    self.debugWindow.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    self.debugWindow.windowLevel = UIWindowLevelAlert;
    self.debugWindow.rootViewController = [UIViewController new];
    self.debugWindow.hidden = NO;
}

#pragma mark - Show

- (void)showFPS {
    [[WHDebugFPSMonitor sharedInstance] startMonitoring];
    [WHDebugFPSMonitor sharedInstance].fpsBlock = ^(float fps) {
        [self.fpsLabel updateLabelWith:DebugToolLabelTypeFPS value:fps];
    };
    [self.debugWindow addSubview:self.fpsLabel];
    [UIView animateWithDuration:0.3 animations:^{
        self.fpsLabel.frame = CGRectMake(kDebugScreenWidth - kDebugLabelWidth - KDebugMargin, 0, kDebugLabelWidth, kDebugLabelHeight);
    }completion:^(BOOL finished) {
        self.isShowing = YES;
    }];
}

- (void)showMemory {
    [WHDebugCPUMemoryMonitor sharedInstance].memeryBlock = ^(float memory) {
        [self.memoryLabel updateLabelWith:DebugToolLabelTypeMemory value:memory];
    };
    [self.debugWindow addSubview:self.memoryLabel];
    [UIView animateWithDuration:0.3 animations:^{
        self.memoryLabel.frame = CGRectMake(KDebugMargin, 0, kDebugLabelWidth, kDebugLabelHeight);
    }completion:^(BOOL finished) {
        self.isShowing = YES;
    }];
}

- (void)showCPU {
    [WHDebugCPUMemoryMonitor sharedInstance].cpuBlock = ^(float cpu) {
        [self.cpuLabel updateLabelWith:DebugToolLabelTypeCPU value:cpu];
    };
    [self.debugWindow addSubview:self.cpuLabel];
    [UIView animateWithDuration:0.3 animations:^{
        self.cpuLabel.frame = CGRectMake((kDebugScreenWidth - kDebugLabelWidth) / 2, 0, kDebugLabelWidth, kDebugLabelHeight);
    }completion:^(BOOL finished) {
        self.isShowing = YES;
    }];
}

#pragma mark - Hide

- (void)hideFPS {
    [UIView animateWithDuration:0.3 animations:^{
        [[WHDebugFPSMonitor sharedInstance] stopMonitoring];
        self.fpsLabel.frame = CGRectMake(kDebugScreenWidth + kDebugLabelWidth, 0, kDebugLabelWidth, kDebugLabelHeight);
    }completion:^(BOOL finished) {
        [self.fpsLabel removeFromSuperview];
        self.fpsLabel = nil;
        [self deinitWindow];
    }];
}

- (void)hideMemory {
    [UIView animateWithDuration:0.3 animations:^{
        [[WHDebugCPUMemoryMonitor sharedInstance] stopMonitoring];
        self.memoryLabel.frame = CGRectMake(-kDebugLabelWidth, 0, kDebugLabelWidth, kDebugLabelHeight);
    }completion:^(BOOL finished) {
        [self.memoryLabel removeFromSuperview];
        self.memoryLabel = nil;
        [self deinitWindow];
    }];
}

- (void)hideCPU {
    [UIView animateWithDuration:0.3 animations:^{
        [[WHDebugCPUMemoryMonitor sharedInstance] stopMonitoring];
        self.cpuLabel.frame = CGRectMake((kDebugScreenWidth - kDebugLabelWidth) / 2, -kDebugLabelHeight, kDebugLabelWidth, kDebugLabelHeight);
    }completion:^(BOOL finished) {
        [self.cpuLabel removeFromSuperview];
        self.cpuLabel = nil;
        [self deinitWindow];
    }];
}

- (void)deinitWindow {
    self.debugWindow = nil;
    self.isShowing = NO;
}

#pragma mark - Label

- (WHDebugConsoleLabel *)memoryLabel {
    if (!_memoryLabel) {
        _memoryLabel = [[WHDebugConsoleLabel alloc] initWithFrame:CGRectMake(-kDebugLabelWidth, 0, kDebugLabelWidth, kDebugLabelHeight)];
    }
    return _memoryLabel;
}

-(WHDebugConsoleLabel *)cpuLabel {
    if (!_cpuLabel) {
        _cpuLabel = [[WHDebugConsoleLabel alloc] initWithFrame:CGRectMake((kDebugScreenWidth - kDebugLabelWidth) / 2, -kDebugLabelHeight, kDebugLabelWidth, kDebugLabelHeight)];
    }
    return _cpuLabel;
}

- (WHDebugConsoleLabel *)fpsLabel {
    if (!_fpsLabel) {
        _fpsLabel = [[WHDebugConsoleLabel alloc] initWithFrame:CGRectMake(kDebugScreenWidth + kDebugLabelWidth, 0, kDebugLabelWidth, kDebugLabelHeight)];
    }
    return _fpsLabel;
}

@end
