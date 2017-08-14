//
//  SCUserProfileEntity.m
//  HXDEMO
//
//  Created by 沈冲 on 16/3/10.
//  Copyright © 2016年 shenchong. All rights reserved.
//

#import "SCUserProfileEntity.h"

@implementation SCUserProfileEntity

+ (void)saveUserProfileWithUsername:(NSString *)username forNickName:(NSString *)nickName avatarURLPath:(NSString *)avatarURLPath{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //设置保存的头像和昵称的key，加上环信ID字段标识
    NSString *nickNameKey = [NSString stringWithFormat:@"username_%@",username];
    NSString *avatarURLPathKey = [NSString stringWithFormat:@"avatarURLPath_%@",username];
    
    [defaults setObject:nickName forKey:nickNameKey];
    [defaults setObject:avatarURLPath forKey:avatarURLPathKey];
    [defaults synchronize];
    
    NSLog(@"NSHomeDirectory()------------------%@",NSHomeDirectory());

}

+ (NSString *)getNickNameWithUsername:(NSString*)username{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *nickNameKey = [NSString stringWithFormat:@"username_%@",username];
    
    return [defaults objectForKey:nickNameKey];
}

+ (NSString *)getavatarURLPathWithUsername:(NSString*)username{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *avatarURLPathKey = [NSString stringWithFormat:@"avatarURLPath_%@",username];
    
    return [defaults objectForKey:avatarURLPathKey];
}

+ (void)removeUserProfileWithUsername:(NSString *)username{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *nickNameKey = [NSString stringWithFormat:@"username_%@",username];
    NSString *avatarURLPathKey = [NSString stringWithFormat:@"avatarURLPath_%@",username];
    
    [defaults removeObjectForKey:nickNameKey];
    [defaults removeObjectForKey:avatarURLPathKey];
    [defaults synchronize];
}

@end
