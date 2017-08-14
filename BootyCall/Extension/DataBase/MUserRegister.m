//
//  MUserRegister.m
//  项目三--服务器
//
//  Created by dazhongdiy on 16/8/9.
//  Copyright © 2016年 orange. All rights reserved.
//

#import "MUserRegister.h"

@implementation MUserRegister


+ (void)registerWithMobilePhoneNumber:(NSString *)mobilePhoneNum Password:(NSString *)userPassword RigisterCompletion:(RigisterCompletion)completion{
    
    UserInfo *userInfo = [[UserInfo alloc]init];
    [userInfo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
         
            
            [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:userInfo.objectId password:@"huanxinUser" withCompletion:^(NSString *username, NSString *password, EMError *error) {
                if (!error) {
                    AVUser *user = [AVUser user];
                    user.username = mobilePhoneNum;
                    user.password =  userPassword;
                    user.mobilePhoneNumber = mobilePhoneNum;
                    [user setObject:userInfo.objectId forKey:@"userInfoId"];
                    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (succeeded) {
                            [AVUser logInWithUsernameInBackground:mobilePhoneNum password:userPassword block:^(AVUser *user, NSError *error) {
                                if (!error) {
                                        completion(YES,user,nil);
  
                                }
                                else {
                                    completion(NO,nil,error);
                                    
                                }
 
                            }];
                            
                        }else{
                            completion(NO,nil,error);
                        }
                    }];
                }else{
                    //NSLog(@"环信注册未成功");
                    completion(NO,nil,nil);
                }
            } onQueue:nil];
       
            
        }else{
            completion(NO,nil,error);
        }
    }];
    
    
}
+ (void)registerWithSmsCode:(NSString *)smsCode LoginCompletion:(LoginCompletion)completion{
    [AVUser verifyMobilePhone:smsCode withBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            completion(YES,nil);
        }else{
            completion(NO,error);
        }
    }];
    
}

+ (void)loginWithMobilePhoneNumber:(NSString *)mobilePhoneNum PassWord:(NSString *)passWord LoginCompletion:(RigisterCompletion)completion{
    
    [AVUser logInWithUsernameInBackground:mobilePhoneNum  password:passWord block:^(AVUser *user, NSError *error) {
        if (!error) {
            
            
            BOOL isAutoLogin = [[EaseMob sharedInstance].chatManager isAutoLoginEnabled];
            if (!isAutoLogin) {
               
                [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:[AVUser currentUser][@"userInfoId"] password:@"huanxinUser" completion:^(NSDictionary *loginInfo, EMError *error) {
                    if (!error) {
                    NSLog(@"登陆成功");
                    }else {
                                                                      
                    NSLog(@"登陆不成功");
                   completion(NO,nil,nil);
                   return ;
                   }
                } onQueue:nil];
            }

            completion(YES,user,nil);
        }else{
            completion(NO,nil,error);
        }
    }];
}

+ (void)resetPassWordWithMobilePhone:(NSString *)mobilePhoneNum RigisterCompletion:(LoginCompletion)completion{
    [AVUser requestPasswordResetWithPhoneNumber:mobilePhoneNum block:^(BOOL succeeded, NSError *error) {
            if (!error) {
                completion(YES,nil);
            }else{
                completion(NO,error);
            }
    }];
}

+ (void)resetPassWordWithSmsCode:(NSString *)smsCode NewPassWord:(NSString *)newPassWord RigisterCompletion:(LoginCompletion)completion{
    [AVUser resetPasswordWithSmsCode:smsCode newPassword:newPassWord block:^(BOOL succeeded, NSError *error) {
        if (!error) {
            completion(YES,nil);
        }else{
            completion(NO,error);
        }
    }];
}




@end
