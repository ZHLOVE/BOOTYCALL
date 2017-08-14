//
//  UIAlertController+SQExtension.h
//  自定义封装提示框
//
//  Created by mac on 16/7/4.
//  Copyright © 2016年 rimi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (SQExtension)


//尤工长

+(void)showAlertWithTitle:(NSString *)title message:(NSString *)message;

/**
 *  自定义弹出框（带确定按钮，不带点击事件）
 *
 *  @param title   标题
 *  @param message 提示信息
 */
+(void)showAlertWithTitle:(NSString *)title message:(NSString *)message target:(UIViewController *)target;
/**
 *  自定义弹出框（带确定按钮，带点击事件）
 *
 *  @param title        标题
 *  @param message      提示信息
 *  @param buttonAction 点击事件的回调
 */
+(void)showAlertWithTitle:(NSString *)title message:(NSString *)message buttonAction:(void(^)())buttonAction;
/**
 *  自定义弹出框（带多个按钮，带点击事件）
 *
 *  @param title        标题
 *  @param message      提示信息
 *  @param actionMsg    按钮标题s
 *  @param buttonAction 点击事件的回调
 */
+(void)showAlertWithTitle:(NSString *)title message:(NSString *) message actionsMsg:(NSArray *)actionMsg buttonActions:(void(^)(NSInteger index))buttonAction;


@end
