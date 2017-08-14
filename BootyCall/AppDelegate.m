//
//  AppDelegate.m
//  BootyCall
//
//  Created by mac on 16/8/8.
//  Copyright © 2016年 dazhongdiy. All rights reserved.
//

#import "AppDelegate.h"
#import "SRootViewController.h"
#import "WeiboSDK.h"
#import "WXApi.h"
#import "MBShareApi.h"

static NSString *appId = @"GBOxOI6HdiRvKEuHa68Jn3OU-gzGzoHsz";
static NSString *appKey = @"ma5sBRNnq8e98SyW3wgtPIlU";


@interface AppDelegate ()<EMChatManagerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    _window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [_window setBackgroundColor:[UIColor whiteColor]];
    [_window makeKeyAndVisible];
    [UserInfo registerSubclass];
    [AVOSCloud setApplicationId:appId clientKey:appKey];
    [AVOSCloud setLastModifyEnabled:YES];
    //微信分享
    [MBShareApi registerAppKeys: @{@"Weibo": @"", @"Wechat": @"wxe29dce886dd73b1a"}];
    //    链接环信

    [[EaseMob sharedInstance] registerSDKWithAppKey:@"qinsunbo#demotwo" apnsCertName:nil];
    [[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    if ([AVUser currentUser]) {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"sheadImageData"];
        if (data == nil || [[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding] isKindOfClass:[NSNull class]]) {
            [AVUser logOut];
            
            [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:NO completion:^(NSDictionary *info, EMError *error) {
                if (!error) {
                }
            } onQueue:nil];
            
            MLoginViewController *loginVC = [[MLoginViewController alloc]init];
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginVC];
            nav.navigationBarHidden = YES;
            _window.rootViewController = nav;
            
        }else{
            if ([[EaseMob sharedInstance].chatManager isAutoLoginEnabled]) {
                NSLog(@"自动登录");
                
            }else {
                NSLog(@"不自动登录");
                [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:[AVUser currentUser][@"userInfoId"] password:@"huanxinUser" completion:^(NSDictionary *loginInfo, EMError *error) {
                    if (!error) {
                        [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
                        
                    }else {
                        NSLog(@"dlegeta 环信不登陆成功");
                    }
                } onQueue:nil];
        }
            _rootVc = [[SRootViewController alloc]init];
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:_rootVc];
            nav.navigationBarHidden = YES;
            _window.rootViewController = nav;
        
    }
        
    }else{
        MLoginViewController *loginVC = [[MLoginViewController alloc]init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginVC];
        nav.navigationBarHidden = YES;
        _window.rootViewController = nav;
    }
    return YES;
}

- (void)didLoginFromOtherDevice {
    
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:NO completion:^(NSDictionary *info, EMError *error) {
        if (!error) {
            NSLog(@"退出成功");
        }
    } onQueue:nil];

    [UIAlertController showAlertWithTitle:@"温馨提示" message:@"该账号在其他设备登陆" buttonAction:^{
        [AVUser logOut];
        
        [[NSUserDefaults standardUserDefaults]setObject:@[] forKey:@"imageDataArr"];
//        返回登陆页 +++++++
        MLoginViewController *loginVC = [[MLoginViewController alloc]init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginVC];
        nav.navigationBarHidden = YES;
        _window.rootViewController = nav;
       
    }];
//点击事件

}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
