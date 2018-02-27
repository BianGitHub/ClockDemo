//
//  BLClockView.m
//  BLClockDemo
//
//  Created by 边雷 on 2018/2/27.
//  Copyright © 2018年 Mac-b. All rights reserved.
//

#import "BLClockView.h"

@implementation BLClockView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}

#pragma mark - setUI
- (void)setUI {
    
    self.layer.contents = (__bridge id)[UIImage imageNamed:@"clock"].CGImage;
    // 防止图片拉伸
    self.layer.contentsGravity = kCAGravityResizeAspect;

}

@end
