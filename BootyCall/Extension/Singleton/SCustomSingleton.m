//
//  SCustomSingleton.m
//  BootyCall
//
//  Created by mac on 16/8/11.
//  Copyright © 2016年 dazhongdiy. All rights reserved.
//

#import "SCustomSingleton.h"

@implementation SCustomSingleton

static SCustomSingleton *singlton = nil;
+(instancetype)defaultCustomSingleton
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singlton = [[self alloc]init];
        //赋初值
        singlton.index = 0;
        singlton.isOpenGuideVc = YES;
        singlton.selectedUsersArray = [[NSMutableArray alloc]init];
    });
    return singlton;
}

@end
