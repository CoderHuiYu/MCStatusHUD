//
//  MCStatusBarHUD.m
//  Lynx
//
//  Created by 余辉 on 2018/7/26.
//  Copyright © 2018年 沙丕明. All rights reserved.
//

#import "MCStatusBarHUD.h"
#define MCMessageFont [UIFont systemFontOfSize:14]

/** 消息的出现时间 */
static CGFloat const MCMessageShowDuration = 1;
/** 消息的停留时间 */
static CGFloat const MCMessageDuration = 2;
/** 消息显示\隐藏的动画时间 */
static CGFloat const MCAnimationDuration = 1.0;

@implementation MCStatusBarHUD
/** 全局的窗口 */
static UIWindow *window_;
/** 定时器 */
static NSTimer *timer_;
/**
 * 显示窗口
 */
+ (void)showWindow
{
    // frame数据
    CGFloat windowH = 60;
    CGRect frame = CGRectMake(0, - windowH, [UIScreen mainScreen].bounds.size.width, windowH);
    
    // 显示窗口
    window_.hidden = YES;
    window_ = [[UIWindow alloc] init];
    window_.backgroundColor = [UIColor clearColor];
    window_.windowLevel = UIWindowLevelAlert;
    window_.frame = frame;
    window_.hidden = NO;
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(hideQuickly)];
    [window_ addGestureRecognizer:panGesture];
    // 动画
    frame.origin.y = 7;
    if (IPHONEX) {
        frame.origin.y = 40;
    }
    [UIView animateWithDuration:MCMessageShowDuration animations:^{
        window_.frame = frame;
    }];
}

/**
 * 显示普通信息
 * @param msg       文字
 * @param image     图片
 */
+ (void)showMessage:(NSString *)msg image:(UIImage *)image
{
    // 停止定时器
    [timer_ invalidate];
    
    // 显示窗口
    [self showWindow];
    CGFloat h = 60;
    CGFloat gap = 8;
    UIImageView *bgview = [[UIImageView alloc]initWithFrame:CGRectMake(gap-5, 0, WIDTH - 2 *gap+10, h+10)];
    bgview.layer.cornerRadius = 13;
    bgview.layer.masksToBounds = YES;
    bgview.image =[UIImage imageNamed:@"tipNewMessageBg"];
    
    UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tipNewMessage"]];
    imgView.frame = CGRectMake(22+5, (h-27)/2, 34, 27);
    [bgview addSubview:imgView];
    
    // 添加按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(CGRectGetMaxX(imgView.frame)+10, (h-30)/2, WIDTH - CGRectGetMaxX(imgView.frame)-10-15, 30);
    [button setTitle:msg forState:UIControlStateNormal];
    button.titleLabel.font = MCMessageFont;
    button.titleLabel.textAlignment = NSTextAlignmentLeft;
    
    [button setTitleColor:COLOR_WITH_HEX(0x666666, 1) forState:UIControlStateNormal];
    if (image) { // 如果有图片
        [button setImage:image forState:UIControlStateNormal];
    }
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 1, 0, 0);
    [bgview addSubview:button];
    [window_ addSubview:bgview];
    
    // 定时器
    timer_ = [NSTimer scheduledTimerWithTimeInterval:MCMessageDuration target:self selector:@selector(hide) userInfo:nil repeats:NO];
}

/**
 * 显示普通信息
 */
+ (void)showMessage:(NSString *)msg
{
    [self showMessage:msg image:nil];
}

/**
 * 显示成功信息
 */
+ (void)showSuccess:(NSString *)msg
{
    NSLog(@"%@", NSTemporaryDirectory());
    [self showMessage:msg image:[UIImage imageNamed:@"MCStatusBarHUD.bundle/success"]];
}

/**
 * 显示失败信息
 */
+ (void)showError:(NSString *)msg
{
    [self showMessage:msg image:[UIImage imageNamed:@"MCStatusBarHUD.bundle/error"]];
}

/**
 * 显示正在处理的信息
 */
+ (void)showLoading:(NSString *)msg
{
    // 停止定时器
    [timer_ invalidate];
    timer_ = nil;
    
    // 显示窗口
    [self showWindow];
    
    // 添加文字
    UILabel *label = [[UILabel alloc] init];
    label.font = MCMessageFont;
    label.frame = window_.bounds;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = msg;
    label.textColor = [UIColor whiteColor];
    [window_ addSubview:label];
    
    // 添加圈圈
    UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [loadingView startAnimating];
    // 文字宽度
    CGFloat msgW = [msg sizeWithAttributes:@{NSFontAttributeName : MCMessageFont}].width;
    CGFloat centerX = (window_.frame.size.width - msgW) * 0.5 - 20;
    CGFloat centerY = window_.frame.size.height * 0.5;
    loadingView.center = CGPointMake(centerX, centerY);
    [window_ addSubview:loadingView];
}

/**
 * 隐藏
 */
+ (void)hide
{
    [UIView animateWithDuration:MCAnimationDuration animations:^{
        CGRect frame = window_.frame;
        frame.origin.y =  - frame.size.height;
        window_.frame = frame;
    } completion:^(BOOL finished) {
        window_ = nil;
        timer_ = nil;
    }];
}

+ (void)hideQuickly{
    window_ = nil;
    timer_ = nil;
}

@end
