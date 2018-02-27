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
@property (nonatomic, weak) CALayer *minuteLayer;
@property (nonatomic, weak) CALayer *hourLayer;
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
    
    // 创建分针
    [self createMinute];
    
    // 创建时针
    [self createhour];
    
    // 获取初始角度
    [self getCurrentTime];
}

// 创建时针
- (void)createhour {
    CALayer *hourLayer = [CALayer layer];
    hourLayer.backgroundColor = [UIColor greenColor].CGColor;
    hourLayer.frame = CGRectMake(0, 0, 1, 60);
    hourLayer.position = CGPointMake(self.bounds.size.width*0.5, self.bounds.size.height*0.5);
    hourLayer.anchorPoint = CGPointMake(0.5, 0.75);
    
    [self.layer addSublayer:hourLayer];
    self.hourLayer  = hourLayer;
}

// 创建分针
- (void)createMinute {
    CALayer *minuteLayer = [CALayer layer];
    minuteLayer.backgroundColor = [UIColor blackColor].CGColor;
    minuteLayer.frame = CGRectMake(0, 0, 2, 70);
    minuteLayer.position = CGPointMake(self.bounds.size.width*0.5, self.bounds.size.height*0.5);
    minuteLayer.anchorPoint = CGPointMake(0.5, 0.75);
    
    [self.layer addSublayer:minuteLayer];
    self.minuteLayer  = minuteLayer;
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

// 此方法为定时器调用方法, 每秒钟调用60次--->精度高
- (void)refresh {
    
    CGFloat angle = M_PI *2 / 60 / 60;
    
    self.secondLayer.transform = CATransform3DRotate(self.secondLayer.transform, angle, 0, 0, 1);
    self.minuteLayer.transform = CATransform3DRotate(self.minuteLayer.transform, angle / 60, 0, 0, 1);
    self.hourLayer.transform = CATransform3DRotate(self.hourLayer.transform, angle / 60 / 12, 0, 0, 1);
}

// 获取初始角度
- (void)getCurrentTime {
    
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSInteger second = [calender component:NSCalendarUnitSecond fromDate:[NSDate date]];
    NSInteger minute = [calender component:NSCalendarUnitMinute fromDate:[NSDate date]];
    NSInteger hour = [calender component:NSCalendarUnitHour fromDate:[NSDate date]];
    
    NSLog(@"%zd--%zd---%zd", second, minute, hour);
    
    // 表盘每一格的角度         angle*second为秒针初始角度
    CGFloat angle = M_PI *2 / 60;
    self.secondLayer.transform = CATransform3DRotate(self.secondLayer.transform, angle*second, 0, 0, 1);
    
    // 分针初始角度   秒针每走一圈, 分针走一小格 ---> 思路就是将一小格再分成60份, 秒针走的每一小格就是分针走的每一小份
    // 其中: 分针总的角度 需要加上 秒针 已经走的角度, 总共走一格的多少份
    CGFloat angleMin = angle / 60 * second + angle * minute;
    self.minuteLayer.transform = CATransform3DRotate(self.minuteLayer.transform, angleMin, 0, 0, 1);
    
    // 与分针类似, 唯一不同的是每一小时是五格, 时针是将每一小格分成12份
    // hour求出的是24小时制的时间
    CGFloat angleHour = angle / 12 * minute + (hour - 12) * (M_PI * 2 / 12);
    self.hourLayer.transform = CATransform3DRotate(self.hourLayer.transform, angleHour, 0, 0, 1);
}

- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
}

@end
