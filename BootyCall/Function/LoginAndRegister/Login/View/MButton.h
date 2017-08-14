//
//  MButton.h
//  BootyCall
//
//  Created by rimi on 16/8/12.
//  Copyright © 2016年 dazhongdiy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^finishBlock)();

@interface MButton : UIView

@property (nonatomic,copy) finishBlock translateBlock;

@property (nonatomic,strong) UIButton *button;
@property(nonatomic,assign)BOOL isSignInSuccess;
/**< 登录标题*/
@property(nonatomic,copy)NSString *btnTitle;
/**< 按钮状态*/
@property(nonatomic,assign)BOOL isEnabled;

-(void)removeAllAnimation;

@end
