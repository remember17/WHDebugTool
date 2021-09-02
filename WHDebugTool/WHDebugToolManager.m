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

static inline UIWindow* debugTool_currentWindow() {
    UIWindow* window = nil;
    if (@available(iOS 13.0, *)) {
        for (UIWindowScene* windowScene in [UIApplication sharedApplication].connectedScenes) {
            if (windowScene.activationState == UISceneActivationStateForegroundActive) {
                window = windowScene.windows.firstObject;
                break;
            }
        }
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        window = [UIApplication sharedApplication].keyWindow;
#pragma clang diagnostic pop
    }
    return window;
}

#define kDebugScreenWidth [UIScreen mainScreen].bounds.size.width
#define KDebugCurrentWindow (debugTool_currentWindow())

static inline BOOL debugTool_iPhoneX() {
    BOOL result = NO;
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {
        return result;
    }
    if (@available(iOS 11.0, *)) {
        if (KDebugCurrentWindow.safeAreaInsets.bottom > 0.0) {
            result = YES;
        }
    }
    return result;
}

static NSInteger const kDebugLabelWidth = 70;
static NSInteger const kDebugLabelHeight = 20;
static NSInteger const KDebugMargin = 20;

@interface WHDebugToolManager()
@property (nonatomic, assign) BOOL isShowing;
@property (nonatomic, strong) UIWindow *debugWindow;
@property (nonatomic, strong) WHDebugConsoleLabel *memoryLabel;
@property (nonatomic, strong) WHDebugConsoleLabel *fpsLabel;
@property (nonatomic, strong) WHDebugConsoleLabel *cpuLabel;
@property (nonatomic, assign) DebugToolType type;
@end

@implementation WHDebugToolManager

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

static id _instance;
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    return self;
}

- (void)deviceOrientationChange:(NSNotification *)noti {
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation == UIInterfaceOrientationUnknown ) {
        return;
    }
    CGFloat debugWindowY = debugTool_iPhoneX() ? 30 : 0;
    self.debugWindow.frame = CGRectMake(0, debugWindowY, UIScreen.mainScreen.bounds.size.width, kDebugLabelHeight);
    [self showWith:self.type];
}

#pragma mark - Class function

+ (void)toggleWith:(DebugToolType)type {
    [[self sharedInstance] toggleWith:type];
}

+ (void)showWith:(DebugToolType)type {
    [[self sharedInstance] showWith:type];
}

+ (void)hide {
    [[self sharedInstance] hide];
}

#pragma mark - Show with type

- (void)toggleWith:(DebugToolType)type {
    self.type = type;
    if (self.isShowing) {
        [self hide];
    } else {
        [self showWith:type];
    }
}

- (void)showWith:(DebugToolType)type {
    self.type = type;
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
    CGFloat debugWindowY = debugTool_iPhoneX() ? 30 : 0;
    self.debugWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, debugWindowY, kDebugScreenWidth, kDebugLabelHeight)];
    self.debugWindow.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    self.debugWindow.windowLevel = UIWindowLevelAlert;
    self.debugWindow.rootViewController = [WHDebugTempVC new];
    self.debugWindow.hidden = NO;
    [KDebugCurrentWindow addSubview:self.debugWindow];
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
    CGFloat y = debugTool_iPhoneX() ? 10 : 20;
    if (consoleLabel == self.cpuLabel) {
        consoleLabelFrame = CGRectMake((kDebugScreenWidth - kDebugLabelWidth) / 2, y, kDebugLabelWidth, kDebugLabelHeight);
    } else if (consoleLabel == self.fpsLabel) {
        consoleLabelFrame = CGRectMake(kDebugScreenWidth - kDebugLabelWidth - KDebugMargin, y, kDebugLabelWidth, kDebugLabelHeight);
    } else {
        consoleLabelFrame = CGRectMake(KDebugMargin, y, kDebugLabelWidth, kDebugLabelHeight);
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
        self.cpuLabel.frame = CGRectMake((kDebugScreenWidth - kDebugLabelWidth) / 2, -kDebugLabelHeight, kDebugLabelWidth, kDebugLabelHeight);
        self.memoryLabel.frame = CGRectMake(-kDebugLabelWidth, 0, kDebugLabelWidth, kDebugLabelHeight);
        self.fpsLabel.frame = CGRectMake(kDebugScreenWidth + kDebugLabelWidth, 0, kDebugLabelWidth, kDebugLabelHeight);
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
