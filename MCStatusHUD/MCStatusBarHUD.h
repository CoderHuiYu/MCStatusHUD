//
//  MCStatusBarHUD.h
//  Lynx
//
//  Created by 余辉 on 2018/7/26.
//  Copyright © 2018年 沙丕明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCStatusBarHUD : NSObject
/**
 * 显示普通信息
 * @param msg       文字
 * @param image     图片
 */
+ (void)showMessage:(NSString *)msg image:(UIImage *)image;
/**
 * 显示普通信息
 */
+ (void)showMessage:(NSString *)msg;
/**
 * 显示成功信息
 */
+ (void)showSuccess:(NSString *)msg;
/**
 * 显示失败信息
 */
+ (void)showError:(NSString *)msg;
/**
 * 显示正在处理的信息
 */
+ (void)showLoading:(NSString *)msg;
/**
 * 隐藏
 */
+ (void)hide;

@end
