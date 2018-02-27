//
//  ViewController.m
//  BLClockDemo
//
//  Created by 边雷 on 2018/2/27.
//  Copyright © 2018年 Mac-b. All rights reserved.
//

#import "ViewController.h"
#import "BLClockView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    BLClockView *clockV = [[BLClockView alloc] initWithFrame:CGRectMake(100, 200, 150, 150)];
    [self.view addSubview:clockV];
}


@end
