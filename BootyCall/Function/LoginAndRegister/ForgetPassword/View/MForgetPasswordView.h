//
//  MForgetPasswordView.h
//  BootyCall
//
//  Created by rimi on 16/8/18.
//  Copyright © 2016年 dazhongdiy. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^acquireCodeBlock)();
typedef void(^finishBlock)();
typedef void(^backBlock)();
@interface MForgetPasswordView : UIView


/**< 手机号输入*/
@property(nonatomic,strong)UITextField *phoneTF;
/**< 验证码输入*/
@property(nonatomic,strong)UITextField *codeTF;
/**< 密码输入*/
@property(nonatomic,strong)UITextField *passwordTF;
/**< 获取验证码*/
@property(nonatomic,strong)UIButton *codeBtn;
/**< 完成*/
@property(nonatomic,strong)UIButton *finishBtn;
/**< 返回*/
@property(nonatomic,strong)UIButton *backBtn;
/**< 验证码回调*/
@property (nonatomic,copy) acquireCodeBlock acquireCodeBlock;
/**< 完成事件回调*/
@property (nonatomic,copy) finishBlock finishBlock;
/**< 返回回调*/
@property(nonatomic,copy) backBlock backBlock;



@end
