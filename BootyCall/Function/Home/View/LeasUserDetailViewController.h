//
//  LeasUserDetailViewController.h
//  BootyCall
//
//  Created by rimi on 16/8/17.
//  Copyright © 2016年 dazhongdiy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GITransition.h"

@interface LeasUserDetailViewController : UIViewController

@property (strong, nonatomic) GITransition        *transitionManager;
/**
 *  对象信息
 */
@property (nonatomic,strong) NSDictionary         *userInfoDic;

@property (nonatomic,assign) CGFloat              numberValues;
/**
 *  用户ID
 */
@property (nonatomic,strong) NSString             *userID;

@end
