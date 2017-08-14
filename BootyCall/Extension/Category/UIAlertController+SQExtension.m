//
//  UIAlertController+SQExtension.m
//  自定义封装提示框
//
//  Created by mac on 16/7/4.
//  Copyright © 2016年 rimi. All rights reserved.
//

#import "UIAlertController+SQExtension.h"

@implementation UIAlertController (SQExtension)


+(void)showAlertWithTitle:(NSString *)title message:(NSString *)message{
    
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:title ? title : @"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alertVc addAction:sureAction];
    [[self keyPresentingViewController] presentViewController:alertVc animated:YES completion:nil];
}

+(void)showAlertWithTitle:(NSString *)title message:(NSString *)message target:(UIViewController *)target{
    
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:title ? title : @"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alertVc addAction:sureAction];
    //[[self keyPresentingViewController] presentViewController:alertVc animated:YES completion:nil];
    [target presentViewController:alertVc animated:YES completion:nil];
}

+(void)showAlertWithTitle:(NSString *)title message:(NSString *)message buttonAction:(void (^)())buttonAction{
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:title ? title : @"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (buttonAction) {
            buttonAction();
        }
    }];
    [alertVc addAction:sureAction];
    [[self keyPresentingViewController] presentViewController:alertVc animated:YES completion:nil];
}

+(void)showAlertWithTitle:(NSString *)title message:(NSString *)message actionsMsg:(NSArray *)actionMsg buttonActions:(void (^)(NSInteger))buttonAction{
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:title ? title : @"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [actionMsg enumerateObjectsUsingBlock:^(NSString*  _Nonnull actionMsgStr, NSUInteger index, BOOL * _Nonnull stop) {
            UIAlertAction *actions = [UIAlertAction actionWithTitle:actionMsgStr style:index handler:^(UIAlertAction * _Nonnull action) {
                if (index == 1) {
                    if (buttonAction) {
                        buttonAction(index);
                    }
                }else {
                    buttonAction(index);
                
                }
               
            }];
            [alertVc addAction:actions];
    }];
    
    [[self keyPresentingViewController] presentViewController:alertVc animated:YES completion:nil];
}

/**
 *  获取当前控制器
 *
 *  @return 当前控制器
 */

+ (UIViewController*)keyPresentingViewController{
    UIViewController *rootVc = [[UIApplication sharedApplication] keyWindow].rootViewController;
    UIViewController *presentVc = rootVc;
    while (presentVc.presentedViewController) {
        presentVc = presentVc.presentedViewController;
    }
    return presentVc;
}



@end
