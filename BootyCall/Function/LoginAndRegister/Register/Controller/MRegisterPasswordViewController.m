//
//  MRegisterPasswordViewController.m
//  BootyCall
//
//  Created by orange on 16/8/14.
//  Copyright © 2016年 dazhongdiy. All rights reserved.
//

#import "MRegisterPasswordViewController.h"
#import "MSettingPasswordView.h"
#import "MRegisterUserInfoViewController.h"

@interface MRegisterPasswordViewController ()

/**< 设置密码view*/
@property(nonatomic,strong)MSettingPasswordView *settingPasswordV;

@end

@implementation MRegisterPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initializeDataSource];
    [self initializeInterface];
}

#pragma mark - ******* Initialize *******
//初始化数据源
- (void)initializeDataSource{
    
}
//初始化界面
- (void)initializeInterface{
    self.title = @"注册2/3";
    weakSelf();
    self.navigationController.navigationBar.tintColor = [UIColor grayColor];
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       
       NSForegroundColorAttributeName:MainColor}];
    
    self.navigationController.navigationBarHidden = NO;
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
    [self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc]initWithTitle:@"上一步" style:UIBarButtonItemStylePlain target:self action:nil]];
    [self.view addSubview:self.settingPasswordV];
    [self.settingPasswordV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(75);
        make.width.equalTo(weakSelf.view.mas_width);
        make.height.equalTo(weakSelf.view.mas_height).offset(-75);
    }];
}
#pragma mark - ******* Methods *******

/**< 在控件 将要显示时使其恢复原样*/
- (void)viewWillAppear:(BOOL)animated{

    self.settingPasswordV.nextBtn.enabled = YES;
    self.settingPasswordV.nextBtn.backgroundColor = MainColor;
}


#pragma mark - ******* Events *******
/**< 下一页*/
- (void)nextPage{
    weakSelf();
    if (self.settingPasswordV.passwordTF.text.length == 0 || self.settingPasswordV.passwordTF.text.length < 6 || self.settingPasswordV.passwordTF.text.length > 6) {
        [UIAlertController showAlertWithTitle:@"温馨提示" message:@"请输入正确的验证码" target:weakSelf];
        weakSelf.settingPasswordV.nextBtn.enabled = YES;
        
        
        weakSelf.settingPasswordV.nextBtn.backgroundColor = MainColor;
        
    }else{
        self.settingPasswordV.nextBtn.enabled = NO;
        self.settingPasswordV.nextBtn.backgroundColor = [UIColor grayColor];
        [self showProgressHUD:self.view hint:nil hide:nil];
        [MUserRegister registerWithSmsCode:self.settingPasswordV.passwordTF.text LoginCompletion:^(BOOL success, NSError *error) {
            if (success) {
                [weakSelf removePorgressHud];
                MRegisterUserInfoViewController *passwordVc = [[MRegisterUserInfoViewController alloc]init];
                [weakSelf.navigationController pushViewController:passwordVc animated:YES];
            }else{
                [weakSelf removePorgressHud];
                
                switch (error.code) {
                    case 1:
                        [UIAlertController showAlertWithTitle:@"温馨提示" message:@"参数错误" target:weakSelf];
                        break;
                        
                    case 214:
                        [UIAlertController showAlertWithTitle:@"温馨提示" message:@"手机号码已经被注册" target:weakSelf];
                        break;
                    case 601:
                        [UIAlertController showAlertWithTitle:@"温馨提示" message:@"发送短信过于频繁" target:weakSelf];
                        break;
                    case 124:
                        [UIAlertController showAlertWithTitle:@"温馨提示" message:@"请求超时" target:weakSelf];
                        break;
                    case 201:
                        [UIAlertController showAlertWithTitle:@"温馨提示" message:@"没有提供密码，或者密码为空" target:weakSelf];
                        break;
                    case 602:
                        [UIAlertController showAlertWithTitle:@"温馨提示" message:@"发送短信验证码失败" target:weakSelf];
                        break;
                    case 603:
                        [UIAlertController showAlertWithTitle:@"温馨提示" message:@"无效的短信验证码" target:weakSelf];
                        break;
                    case 212:
                        [UIAlertController showAlertWithTitle:@"温馨提示" message:@"请提供手机号码" target:weakSelf];
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
                weakSelf.settingPasswordV.nextBtn.enabled = YES;
                weakSelf.settingPasswordV.nextBtn.backgroundColor = MainColor;
            }
        }];
    }
   
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.settingPasswordV.passwordTF resignFirstResponder];
    
    
}

#pragma mark - ******* Delegate *******



#pragma mark - ******* Getters *******

- (MSettingPasswordView *)settingPasswordV{
    
    if (!_settingPasswordV) {
        _settingPasswordV = ({
            weakSelf();
            MSettingPasswordView *view = [[MSettingPasswordView alloc]init];
            view.nextPageBlock = ^{
                [weakSelf nextPage];
            };
            view;
        });
    }
    return _settingPasswordV;
}


@end
