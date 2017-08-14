//
//  MUserInfoView.h
//  BootyCall
//
//  Created by orange on 16/8/14.
//  Copyright © 2016年 dazhongdiy. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^UserInfoComplete)();
typedef void(^GenderInfoComplete)(NSString *gender);
typedef void(^AddImageResponed)();
typedef void(^ProtocolResponed)();

@interface MUserInfoView : UIView
/**< 昵称*/
@property(nonatomic,strong)UITextField *nameTF;
/**< 生日*/
@property(nonatomic,strong)UITextField *birthdayTF;
/**< 完成回调事件*/
@property(nonatomic,copy)UserInfoComplete userInfoComplete;
/**< 性别选择回调事件*/
@property(nonatomic,copy)GenderInfoComplete genderInfoComplete;
/**< 选择头像回调事件*/
@property(nonatomic,copy)AddImageResponed addImageResponed;
/**< 用户协议*/
@property(nonatomic,copy)ProtocolResponed protocolResponed;
/**< 头像*/
@property(nonatomic,strong)UIButton *headImageBtn;
/**< 完成*/
@property(nonatomic,strong)UIButton *completeBtn;
@end
