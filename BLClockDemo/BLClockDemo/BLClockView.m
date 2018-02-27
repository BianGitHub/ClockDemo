//
//  BLClockView.m
//  BLClockDemo
//
//  Created by 边雷 on 2018/2/27.
//  Copyright © 2018年 Mac-b. All rights reserved.
//

#import "BLClockView.h"

@interface BLClockView ()

@property (nonatomic, weak) CALayer *secondLayer;
@property (nonatomic, weak) CADisplayLink *link;

@end

@implementation BLClockView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}

// 当视图加载到window时调用
// 只要自己的window发生改变就会调用下面的方法-----pop控制器时会调用一次
// 此处也可以在initwithframe中开启定时器
// 注意pop时, 定时器需要销毁
- (void)willMoveToWindow:(UIWindow *)newWindow {
    [super willMoveToWindow:newWindow];
    
    // 根据pop调用一次原理, 当window消失时销毁定时器
    if (newWindow == nil) {
        [_link invalidate];
        _link = nil;
        return;
    }
    
    // NSTimer精度稍微比CADisplayLink低一些
    // CADisplayLink与屏幕的刷新率是一样的 60次/s   所以调用刷新方法时需要除以60
    //    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refreshSecond) userInfo:nil repeats:YES];
    
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(refresh)];
    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    _link = link;
}

#pragma mark - setUI
- (void)setUI {
    
    self.layer.contents = (__bridge id)[UIImage imageNamed:@"clock"].CGImage;
    // 防止图片拉伸
    self.layer.contentsGravity = kCAGravityResizeAspect;

    // 创建秒针
    [self createSecond];
    
    // 获取初始角度
    [self getCurrentTime];
}

// 创建秒针
- (void)createSecond {
    CALayer *secondLayer = [CALayer layer];
    secondLayer.backgroundColor = [UIColor redColor].CGColor;
    secondLayer.frame = CGRectMake(0, 0, 1, 75);
    secondLayer.position = CGPointMake(self.bounds.size.width*0.5, self.bounds.size.height*0.5);
    secondLayer.anchorPoint = CGPointMake(0.5, 0.75);
    
    [self.layer addSublayer:secondLayer];
    self.secondLayer  = secondLayer;
}

- (void)refresh {
    
    CGFloat angle = M_PI *2 / 60 / 60;
    
    self.secondLayer.transform = CATransform3DRotate(self.secondLayer.transform, angle, 0, 0, 1);
}

// 获取初始角度
- (void)getCurrentTime {
    
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSInteger second = [calender component:NSCalendarUnitSecond fromDate:[NSDate date]];
    
    CGFloat angle = M_PI *2 / 60;
    self.secondLayer.transform = CATransform3DRotate(self.secondLayer.transform, angle*second, 0, 0, 1);
}

- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
}

@end
