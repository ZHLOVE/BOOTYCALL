//
//  MLoginViewController.m
//  BootyCall
//
//  Created by rimi on 16/8/11.
//  Copyright © 2016年 dazhongdiy. All rights reserved.
//

#import "MLoginViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "MButton.h"
#import "MTextField.h"
#import "SRootViewController.h"
#import "MregisterInfoViewController.h"
#import "MForgetPasswordViewController.h"
#import "MRegisterUserInfoViewController.h"


@interface MLoginViewController ()<UITextFieldDelegate,UIGestureRecognizerDelegate>

/**< 账号*/
@property(nonatomic,strong)MTextField *accountView;
/**< 密码*/
@property(nonatomic,strong)MTextField *passwordView;
/**< 登陆*/
@property(nonatomic,strong)MButton *loginBtnView;
/**< 注册*/
@property(nonatomic,strong)MButton *registerBtnView;



@end

@implementation MLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /**< 背景色*/
    [self.view.layer addSublayer: [self backgroundLayer]];
}
#pragma mark - ******* 生命周期 *******
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [AVUser logOut];
    
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:NO completion:^(NSDictionary *info, EMError *error) {
        if (!error) {
            
            
        }
    } onQueue:nil];
    [[NSUserDefaults standardUserDefaults]setObject:@[] forKey:@"imageDataArr"];
    self.navigationController.navigationBarHidden = YES;
    [self setUp];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    /**< 遍历子视图并移除所有*/
    [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
}
/**< 添加控件并约束*/
-(void)setUp{
    weakSelf();
    
    UILabel *titleLabel = ({
        
        UILabel *label = [[UILabel alloc]init];
        label.textColor = [UIColor whiteColor];
        label.text = @"黑夜中的你";
        label.font = [UIFont systemFontOfSize:35.f];
        label.textAlignment = NSTextAlignmentCenter;
        label;
    });
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.centerY.equalTo(weakSelf.view.mas_centerY).multipliedBy(0.5);
        make.height.equalTo(@(50));
    }];
    UILabel *detail = ({
        UILabel *label = [[UILabel alloc]init];
        label.textColor = [UIColor darkGrayColor];
        label.text = @"如果你忘记密码，请点击这里";
        label.font = [UIFont systemFontOfSize:13.f];
        label.textAlignment = NSTextAlignmentCenter;
        label;
    });
    [self.view addSubview:detail];
    [detail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-20);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.height.equalTo(@(20));
    }];
    UIButton *forgetPasswordBtn = ({
        
        UIButton *button = [[UIButton alloc]init];
        button.backgroundColor = [UIColor clearColor];
        [button addTarget:self action:@selector(clickedForgetPasswordBtn:) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [self.view addSubview:forgetPasswordBtn];
    [forgetPasswordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.centerY.equalTo(detail.mas_centerY);
        make.height.equalTo(detail.mas_height);
        make.width.equalTo(detail.mas_width);
    }];
    [self.view addSubview:self.accountView];
    [self.accountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left).offset(50);
        make.right.equalTo(weakSelf.view.mas_right).offset(-50);
        make.centerY.equalTo(weakSelf.view.mas_centerY).offset(-10);
        make.height.equalTo(@(30));
        make.centerX.equalTo(weakSelf.view.mas_centerX);
    }];
    [self.view addSubview:self.passwordView];
    [self.passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left).offset(50);
        make.right.equalTo(weakSelf.view.mas_right).offset(-50);
        make.centerY.equalTo(weakSelf.accountView.mas_centerY).offset(60);
        make.height.equalTo(@(30));
        make.centerX.equalTo(weakSelf.view.mas_centerX);
    }];
    
    [self.view layoutIfNeeded];
    [self.view addSubview:self.loginBtnView];
    [self.view addSubview:self.registerBtnView];
    
    [self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:nil]];
    
    [self registerForKeyboardNotifications];
    
    UITapGestureRecognizer* genture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userInteractionEnabledOff:)];
    genture1.delegate = self;
    genture1.cancelsTouchesInView = NO;
    [self.registerBtnView addGestureRecognizer:genture1];
    UITapGestureRecognizer* genture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userInteractionEnabledOff:)];
    genture2.delegate = self;
    genture2.cancelsTouchesInView = NO;
    [self.loginBtnView addGestureRecognizer:genture2];
}

#pragma mark - ******* Initialize *******



#pragma mark - ******* Methods *******
/**< 按钮触摸手势（用来关闭交互）*/
- (void)userInteractionEnabledOff:(UITapGestureRecognizer *)gesture{
    self.view.userInteractionEnabled = NO;
}
/**< 开始编辑时关闭button父视图的交互*/
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    self.loginBtnView.userInteractionEnabled = NO;
    self.registerBtnView.userInteractionEnabled = NO;
    
    return YES;
}
/**< 点击return后视图frame归位*/
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [UIView animateWithDuration:0.35 animations:^{
        self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:nil];
    
    return YES;
    
}
/**< 注册键盘隐藏显示通知*/
- (void) registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
//    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
}
/**< 键盘显示通知*/
- (void) keyboardWasShown:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = CGSizeMake([value CGRectValue].size.width, [value CGRectValue].size.height - 100);

    [UIView animateWithDuration:0.1 animations:^{
        self.view.frame = CGRectMake(0, -keyboardSize.height, SCREEN_WIDTH, SCREEN_HEIGHT);
        [self.accountView updateConstraints];
        [self.passwordView updateConstraints];
        [self.loginBtnView updateConstraints];
        [self.registerBtnView updateConstraints];
    } completion:nil];
}
/**< 键盘隐藏通知*/
- (void) keyboardWasHidden:(NSNotification *) notif
{
   // NSDictionary *info = [notif userInfo];
   // NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    //CGSize keyboardSize = CGSizeMake([value CGRectValue].size.width, [value CGRectValue].size.height - 100);
    self.loginBtnView.userInteractionEnabled = YES;
    self.registerBtnView.userInteractionEnabled = YES;
    [UIView animateWithDuration:0.35 animations:^{
        self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        
    } completion:nil];
}

/**< touch事件，收起键盘*/
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.accountView.textField resignFirstResponder];
    [self.passwordView.textField resignFirstResponder];

}


#pragma mark - ******* Events *******
/**< 登录block事件，在执行完按钮的动画后会被调用*/
- (void)signIn{

    [self.accountView.textField resignFirstResponder];
    [self.passwordView.textField resignFirstResponder];
    if (self.passwordView.textField.text.length > 16) {
        [UIAlertController showAlertWithTitle:@"温馨提示" message:@"密码输入错误(6-12位)!" target:self];
        self.loginBtnView.btnTitle = @"登  陆";
        self.view.userInteractionEnabled = YES;
        return;
    }
    weakSelf();
    [MUserRegister loginWithMobilePhoneNumber:self.accountView.textField.text PassWord:self.passwordView.textField.text LoginCompletion:^(BOOL success, AVUser *user, NSError *error) {
        if (success) {
            AVUser *user = [AVUser currentUser];
            
            [MResponseUserInfo responseCurrentUserInfo:^(BOOL success, NSError *error, NSDictionary *currentUserInfo) {
                if (success) {
                    //当前用户的个人信息
                    NSDictionary *dict = currentUserInfo[@"myInfo"];
                    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"currentUserInfo"];
                    //当前用户头像的data数据
                    NSData *headData = [NSData dataWithContentsOfURL:[NSURL URLWithString:currentUserInfo[@"headImageUrl"]]];
                    [[NSUserDefaults standardUserDefaults]setObject:headData forKey:@"sheadImageData"];
//                    NSLog(@"%@ - %@",dict,headData);
                    /*
                    //当前用户的生活照
                    NSMutableArray *imageData = [@[]mutableCopy];
                    if ([currentUserInfo[@"albumArray"] count] != 0) {
                        NSArray *albumArr = currentUserInfo[@"albumArray"];
                        [albumArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            [imageData addObject:[NSData dataWithContentsOfURL:[NSURL URLWithString:obj]]];
                        }];
                    }
                    [[NSUserDefaults standardUserDefaults]setObject:imageData forKey:@"imageDataArr"];
                     */
                    
                }
            }];
            BOOL isAutoLogin = [[EaseMob sharedInstance].chatManager isAutoLoginEnabled];
            if (!isAutoLogin) {
                [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:user[@"userInfoId"] password:@"huanxinUser" completion:^(NSDictionary *loginInfo, EMError *error) {
                    if (!error) {
                        [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
                        [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
                    }else{
                        weakSelf.loginBtnView.isSignInSuccess = NO;
                        [weakSelf.loginBtnView removeAllAnimation];
                        [UIAlertController showAlertWithTitle:@"温馨提示" message:@"环信登陆不成功" target:self];
                        }
                    
                } onQueue:nil];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                
            
            NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"sheadImageData"];
            if (data == nil || [[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding] isKindOfClass:[NSNull class]]) {
                self.loginBtnView.isSignInSuccess = NO;
                self.loginBtnView.btnTitle = @"登  陆";
                [weakSelf performSelector:@selector(pushToregisterPage) withObject:nil afterDelay:0.1];
                
                //return ;
            }else{
                weakSelf.view.userInteractionEnabled = YES;
                weakSelf.loginBtnView.isSignInSuccess = YES;
                [weakSelf.loginBtnView removeAllAnimation];
                SRootViewController *nextVC = [[SRootViewController alloc]init];
                [weakSelf presentViewController:nextVC animated:YES completion:nil];
            }
            });
        }else{
           weakSelf.view.userInteractionEnabled = YES;
            weakSelf.loginBtnView.isSignInSuccess = NO;
            [weakSelf.loginBtnView removeAllAnimation];
            switch (error.code) {
                case 1:
                    [UIAlertController showAlertWithTitle:@"温馨提示" message:@"参数错误" target:weakSelf];
                    break;
                case 211:
                    [UIAlertController showAlertWithTitle:@"温馨提示" message:@"找不到用户" target:weakSelf];
                    break;
                case 200:
                    [UIAlertController showAlertWithTitle:@"温馨提示" message:@"没有提供用户名，或者用户名为空" target:weakSelf];
                    break;
                case 124:
                    [UIAlertController showAlertWithTitle:@"温馨提示" message:@"请求超时" target:weakSelf];
                    break;
                case 201:
                    [UIAlertController showAlertWithTitle:@"温馨提示" message:@"没有提供密码，或者密码为空" target:weakSelf];
                    break;
                case 210:
                    [UIAlertController showAlertWithTitle:@"温馨提示" message:@"用户名和密码不匹配" target:weakSelf];
                    break;
                case 502:
                    [UIAlertController showAlertWithTitle:@"温馨提示" message:@"服务器维护中" target:weakSelf];
                    break;
                case 215:
                    [UIAlertController showAlertWithTitle:@"温馨提示" message:@"未验证的手机号码" target:weakSelf];
                    break;
                case 218:
                    [UIAlertController showAlertWithTitle:@"温馨提示" message:@"无效的密码，不允许空白密码" target:weakSelf];
                    break;
                case 217:
                    [UIAlertController showAlertWithTitle:@"温馨提示" message:@"无效的用户名，不允许空白用户名" target:weakSelf];
                    break;
                default:
                    [UIAlertController showAlertWithTitle:@"温馨提示" message:error.localizedDescription target:weakSelf];
                    break;
            }
        }
    }];
    self.loginBtnView.btnTitle = @"登  陆";
}
/**< 注册block回调事件，在注册按钮动画执行完之后执行*/
- (void)signUp{
    /**< 延迟2秒（等待动画）*/
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.registerBtnView.isSignInSuccess = NO;
        self.registerBtnView.btnTitle = @"注  册";
        
        [self performSelector:@selector(nextPage) withObject:nil afterDelay:0.1];
//    });
}
- (void)nextPage{
    [self.registerBtnView removeAllAnimation];
    self.view.userInteractionEnabled = YES;
    MregisterInfoViewController *registerVc = [[MregisterInfoViewController alloc]init];
    [self.navigationController pushViewController:registerVc animated:YES];
}
- (void)pushToregisterPage{
    [self.loginBtnView removeAllAnimation];
    self.view.userInteractionEnabled = YES;
    MRegisterUserInfoViewController *userInfoVc = [[MRegisterUserInfoViewController alloc]init];
    [self.navigationController pushViewController:userInfoVc animated:YES];



}
/**< 忘记密码*/
- (void)clickedForgetPasswordBtn:(UIButton *)sender{
    MForgetPasswordViewController *forgetPage = [[MForgetPasswordViewController alloc]init];
    [self presentViewController:forgetPage animated:YES completion:nil];

}


// Mr Liao
#pragma mark - ******* UITextFieldDelegate *******


#pragma mark - ******* Delegate *******




#pragma mark - ******* Getters *******

-(CAGradientLayer *)backgroundLayer{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.view.bounds;
    gradientLayer.colors = @[(__bridge id)MainColor.CGColor,(__bridge id)[UIColor grayColor].CGColor];
    gradientLayer.startPoint = CGPointMake(0.5, 0);
    gradientLayer.endPoint = CGPointMake(0.5, 1);
    gradientLayer.locations = @[@0.5,@1];
    return gradientLayer;
}

- (MTextField *)accountView{
    
    if (!_accountView) {
        _accountView = ({
            MTextField *view = [[MTextField alloc]init];
            view.textField.delegate = self;
            //view.center = CGPointMake(self.view.center.x, 350);
            view.ly_placeholder = @"手机号";
            
            view.placeholderSelectStateColor = [UIColor blackColor];
            view.tag = 0;
            view.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            view.textField.keyboardType = UIKeyboardTypeNumberPad;
            view;
        });
    }
    return _accountView;
}

- (MTextField *)passwordView{
    
    if (!_passwordView) {
        _passwordView = ({
            
            MTextField *view = [[MTextField alloc]init];
            //view.center = CGPointMake(self.view.center.x, self.accountView.center.y+60);
            view.textField.delegate = self;
            view.ly_placeholder = @"密码";
            view.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            view.placeholderSelectStateColor = [UIColor blackColor];
            view.textField.secureTextEntry = YES;
            view.tag = 1;
            view;
        });
    }
    return _passwordView;
}

- (MButton *)loginBtnView{
    
    if (!_loginBtnView) {
        _loginBtnView = ({
            weakSelf();
            MButton *View = [[MButton alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
            View.center = CGPointMake(self.view.center.x, self.passwordView.center.y+60);
            [View.button setTitle:@"登  陆" forState:UIControlStateNormal];
            View.translateBlock = ^{
                [weakSelf signIn];
            };
            View;
        });
    }
    return _loginBtnView;
}

- (MButton *)registerBtnView{
    
    if (!_registerBtnView) {
        _registerBtnView = ({
            weakSelf();
            MButton *View = [[MButton alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
            View.center = CGPointMake(self.view.center.x, self.passwordView.center.y+110);
            [View.button setTitle:@"注  册" forState:UIControlStateNormal];
            View.translateBlock = ^{
                
                [weakSelf signUp];
            };
            View;
            
        });
    }
    return _registerBtnView;
}

@end
