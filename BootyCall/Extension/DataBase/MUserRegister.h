//
//  MUserRegister.h
//  项目三--服务器
//
//  Created by dazhongdiy on 16/8/9.
//  Copyright © 2016年 orange. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud/AVOSCloud.h>



typedef void(^RigisterCompletion)(BOOL success,AVUser *user,NSError *error);
typedef void(^LoginCompletion)(BOOL success, NSError *error);
@interface MUserRegister : NSObject


/**
*  手机号验证码登陆或注册第一步：发送验证码
*
*  @param mobilePhoneNum 手机号
*  @param password       密码
*  @param completion     回调
*/
+ (void)registerWithMobilePhoneNumber:(NSString *)mobilePhoneNum
                             Password:(NSString *)userPassword
                   RigisterCompletion:(RigisterCompletion)completion;

/**
 *  手机号验证码登陆或注册第二步：输入验证码验证手机
 *
 *  @param smsCode        验证码
 */
+ (void)registerWithSmsCode:(NSString *)smsCode
                   LoginCompletion:(LoginCompletion)completion;

/**
 *  手机号和密码登陆
 *
 *  @param mobilePhoneNum 手机号
 *  @param passWord       密码
 */
+ (void)loginWithMobilePhoneNumber:(NSString *)mobilePhoneNum
                          PassWord:(NSString *)passWord
                LoginCompletion:(RigisterCompletion)completion;


/*-----------------------------------------------------*/

/**
 *  手机号重置密码第一步：发送短信
 *
 *  @param mobilePhoneNum 手机号
 */
+ (void)resetPassWordWithMobilePhone:(NSString *)mobilePhoneNum
                  RigisterCompletion:(LoginCompletion)completion;

/**
 *  手机号重置密码第二步:输入新密码和验证码
 *
 *  @param smsCode     验证码
 *  @param newPassWord 新密码
 */
+ (void)resetPassWordWithSmsCode:(NSString *)smsCode
                     NewPassWord:(NSString *)newPassWord
              RigisterCompletion:(LoginCompletion)completion;













@end
