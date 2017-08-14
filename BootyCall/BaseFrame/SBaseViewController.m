//
//  SBaseViewController.m
//  BootyCall
//
//  Created by mac on 16/8/10.
//  Copyright © 2016年 dazhongdiy. All rights reserved.
//

#import "SBaseViewController.h"
#import "SRootViewController.h"
#import "SSubRootViewController.h"
#import "SHomeViewController.h"
#import "SCustomView.h"
#import "AppDelegate.h"
#import "WeiboSDK.h"
#import "WXApi.h"
#import "MBShareApi.h"

@interface SBaseViewController ()

{
    MBProgressHUD *_progressHUD;
    NSString      *shide;
}

@end

@implementation SBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  
}

//Mr ma
- (void)showProgressHUD:(UIView*)view hint:(NSString *)hint hide:(NSString *)hide{
    //创建hud
    _progressHUD = [[MBProgressHUD alloc] initWithView:view];
    _progressHUD.mode = MBProgressHUDModeIndeterminate;
    //设置提示文本
    _progressHUD.labelText = hint;
    //将hud添加到父视图上
    [view addSubview:_progressHUD];
    [view bringSubviewToFront:_progressHUD];
    shide = hide;
    //执行动画
    [_progressHUD show:YES];
}

-(void)removePorgressHud{
    _progressHUD.labelText = shide;
    [_progressHUD hide:YES afterDelay:0.3f];
    
}

/**
 *  微信好友推荐
 */
-(void)shareWechatSession{
    MBShareMessage *message = [MBShareMessage messageWithType: kShareTypeWechatSession];
    message.title = @"拒绝虚与委蛇的世界；拒绝金玉其外的朋友；拒绝道貌岸然的自己；拒绝所有的外贸协会者。用最真实的自己认识最恰当的朋友";
    message.desc = @"";
    message.url = @"https://itunes.apple.com/cn/genre/ios/id36?mt=8";
    message.image = [UIImage imageNamed:@"Mbutton"];
    message.thumbnailImage = message.image;
    [MBShareApi shareMessage: message complete:^(kMBShareState state, NSDictionary *userInfo, NSError *error) {
        switch (state) {
            case kMBShareStateSuccess:
                NSLog(@"分享成功了");
                [self showsHint:@"分享成功了" yOffset:50];
                break;
            case kMBShareStateCancelled:
                NSLog(@"分享取消了 %@", error);
                [self showsHint:@"分享取消了" yOffset:50];
                break;
            case kMBShareStateFailed:
                NSLog(@"分享失败了 %@", error);
                [self showsHint:@"分享失败了" yOffset:50];
                break;
        }
    }];
}
-(void)shareWechatTimeline{
    MBShareMessage *message = [MBShareMessage messageWithType: kShareTypeWechatTimeline];
    message.title = @"拒绝虚与委蛇的世界；拒绝金玉其外的朋友；拒绝道貌岸然的自己；拒绝所有的外贸协会者。用最真实的自己认识最恰当的朋友";
    //message.desc = @"";
    message.url = @"https://itunes.apple.com/cn/genre/ios/id36?mt=8";
    message.image = [UIImage imageNamed: @"1468568782"];
    message.thumbnailImage = message.image;
    [MBShareApi shareMessage: message complete:^(kMBShareState state, NSDictionary *userInfo, NSError *error) {
        switch (state) {
            case kMBShareStateSuccess:
                NSLog(@"分享成功了");
                [self showsHint:@"分享成功了" yOffset:50];
                break;
            case kMBShareStateCancelled:
                NSLog(@"分享取消了 %@", error);
                [self showsHint:@"分享取消了" yOffset:50];
                break;
            case kMBShareStateFailed:
                NSLog(@"分享失败了 %@", error);
                [self showsHint:@"分享失败了" yOffset:50];
                break;
        }
    }];
}



-(SHomeViewController *)getHomeViewController{
     AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    return appDelegate.rootVc.subRootVc.homeVc;
}


-(void)setFuzzyBgImageView:(UIImageView *)bgImageView{
    //创建模糊背景
    /*
    bgImageView.userInteractionEnabled = YES;
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *visualEffect = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
    visualEffect.frame = self.view.bounds;
    [bgImageView addSubview:visualEffect];
    CGFloat alhpa = (CGFloat)(arc4random() % 10 + 1) / 10.0 + 0.7;
    visualEffect.alpha = alhpa;
    [self.view addSubview:bgImageView];
     */
    //创建遮罩
    SCustomView *shadeView = [[SCustomView alloc]initWithFrame:self.view.bounds];
    [shadeView setWhiteValue:0 alphaValue:1.0];
    [self.view addSubview:shadeView];
}


-(void)setViewControllerName:(NSString*)vcName bgColor:(UIColor *)color{
    [self.view setBackgroundColor:color];
    UILabel *vcNameL = ({
        vcNameL = [[UILabel alloc]initWithFrame:self.view.bounds];
        vcNameL.font = [UIFont systemFontOfSize:20.f];
        vcNameL.textColor = [UIColor blackColor];
        vcNameL.textAlignment = NSTextAlignmentCenter;
        vcNameL.text = vcName;
        vcNameL;
    });
    [self.view addSubview:vcNameL];
}


-(void)viewWillAppear:(BOOL)animated{
    //发送通知
    [[NSNotificationCenter defaultCenter]postNotificationName:@"clickBtn" object:nil];
}



@end
