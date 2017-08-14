//
//  MSettingPasswordView.h
//  BootyCall
//
//  Created by orange on 16/8/14.
//  Copyright © 2016年 dazhongdiy. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^nextPageBlock)();
@interface MSettingPasswordView : UIView


/**< 密码输入*/
@property(nonatomic,strong)UITextField *passwordTF;
/**< 下一步回调*/
@property (nonatomic,copy) nextPageBlock nextPageBlock;
/**< 下一步*/
@property(nonatomic,strong)UIButton *nextBtn;
/**< 提示*/
@property(nonatomic,strong)UILabel *point;
/**< 验证码lab*/
@property(nonatomic,strong)UILabel *passwordlabel;


@end
