//
//  MVerificationView.h
//  BootyCall
//
//  Created by orange on 16/8/14.
//  Copyright © 2016年 dazhongdiy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^acquireCodeBlock)();
typedef void(^nextPageBlock)();


@interface MVerificationView : UIView

/**< 手机号输入*/
@property(nonatomic,strong)UITextField *phoneTF;
/**< 验证码输入*/
@property(nonatomic,strong)UITextField *codeTF;
/**< 获取验证码*/
@property(nonatomic,strong)UIButton *codeBtn;
/**< 下一步*/
@property(nonatomic,strong)UIButton *nextBtn;
/**< 验证码回调*/
@property (nonatomic,copy) acquireCodeBlock acquireCodeBlock;
/**< 下一步回调*/
@property (nonatomic,copy) nextPageBlock nextPageBlock;

/**< 验证码lab*/
@property(nonatomic,strong)UILabel *codelabel;


@end
