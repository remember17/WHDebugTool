//
//  ViewController.m
//  WHDebugToolDemo
//
//  Created by 吴浩 on 2021/3/31.
//

#import "ViewController.h"
#import <WHDebugToolManager.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [WHDebugToolManager toggleWith:DebugToolTypeAll];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [WHDebugToolManager toggleWith:DebugToolTypeAll];
}

@end
