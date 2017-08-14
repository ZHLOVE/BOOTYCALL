//
//  MregisterInfoViewController.m
//  BootyCall
//
//  Created by orange on 16/8/14.
//  Copyright © 2016年 dazhongdiy. All rights reserved.
//

#import "MregisterInfoViewController.h"
#import "MVerificationView.h"
#import "MRegisterPasswordViewController.h"

@interface MregisterInfoViewController ()<UITextFieldDelegate>

/**< 设置密码view*/
@property(nonatomic,strong)MVerificationView *verificationView;

@end

@implementation MregisterInfoViewController

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
    self.title = @"注册1/3";
    weakSelf();
    self.navigationController.navigationBar.tintColor = [UIColor grayColor];
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       
       NSForegroundColorAttributeName:MainColor}];
    
    self.navigationController.navigationBarHidden = NO;
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
    [self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc]initWithTitle:@"上一步" style:UIBarButtonItemStylePlain target:self action:nil]];
    [self.view addSubview:self.verificationView];
    [self.verificationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(75);
        make.width.equalTo(weakSelf.view.mas_width);
        make.height.equalTo(weakSelf.view.mas_height).offset(-75);
    }];
    
}
#pragma mark - ******* Methods *******
/**< 在页面将要显示时使控件恢复原样*/
- (void)viewWillAppear:(BOOL)animated{
    //self.verificationView.nextBtn.enabled = YES;
    //self.verificationView.nextBtn.backgroundColor = MainColor;
    //self.verificationView.codeBtn.enabled = YES;
    //self.verificationView.codeBtn.titleLabel.textColor = MainColor;
    //[self.verificationView.codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    
}



#pragma mark - ******* Events *******
/**< 发送验证码*/
- (void)acquireCode{
//    self.verificationView.codeBtn.enabled = NO;
    weakSelf();
    if (self.verificationView.codeTF.text.length < 6 || self.verificationView.codeTF.text.length > 12) {
        
        [UIAlertController showAlertWithTitle:@"温馨提示" message:@"密码需要大于6位小于12位" target:self];
        
//        self.verificationView.codeBtn.titleLabel.textColor = MainColor;
//        self.verificationView.codeBtn.enabled = YES;
    }if (self.verificationView.phoneTF.text.length < 11 || self.verificationView.phoneTF.text.length > 11) {
        [UIAlertController showAlertWithTitle:@"温馨提示" message:@"请输入真实的手机号码" target:self];
//        self.verificationView.codeBtn.titleLabel.textColor = MainColor;
//        self.verificationView.codeBtn.enabled = YES;
        
    }else{
        //[self showProgressHUD:self.view hint:nil hide:nil];
        [self showHint:@"发送中" yOffset:-(SCREEN_HEIGHT/4)];
        
        [self.verificationView.codeTF resignFirstResponder];
        
        [MUserRegister registerWithMobilePhoneNumber:self.verificationView.phoneTF.text Password:self.verificationView.codeTF.text RigisterCompletion:^(BOOL success, AVUser *user, NSError *error) {
            if (success) {
                
                 [weakSelf removePorgressHud];
                [self nextPage];
//                self.verificationView.codeBtn.enabled = YES;
//                [weakSelf.verificationView.codeBtn setTitle:@"发送成功" forState:UIControlStateNormal];
//                weakSelf.verificationView.codeBtn.titleLabel.textColor = [UIColor grayColor];
//                weakSelf.verificationView.nextBtn.enabled = YES;
//                weakSelf.verificationView.nextBtn.backgroundColor = MainColor;
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
                    case 212:
                        [UIAlertController showAlertWithTitle:@"温馨提示" message:@"请提供手机号码" target:weakSelf];
                        break;
                    case 127:
                        [UIAlertController showAlertWithTitle:@"温馨提示" message:@"手机号码无效" target:weakSelf];
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
//                [weakSelf.verificationView.codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
//                weakSelf.verificationView.codeBtn.enabled = YES;
//                weakSelf.verificationView.codeBtn.titleLabel.textColor = MainColor;
                
            }
        }];
    }
}
- (void)nextPage{
  
    //self.verificationView.nextBtn.backgroundColor = [UIColor lightGrayColor];
    MRegisterPasswordViewController *passwordVc = [[MRegisterPasswordViewController alloc]init];
    [self.navigationController pushViewController:passwordVc animated:YES];

}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.verificationView.phoneTF resignFirstResponder];
    [self.verificationView.codeTF resignFirstResponder];
    
}

#pragma mark - ******* Delegate *******



#pragma mark - ******* Getters *******

- (MVerificationView *)verificationView{
    
    if (!_verificationView) {
        _verificationView = ({
            weakSelf();
            MVerificationView *view = [[MVerificationView alloc]init];
            view.phoneTF.delegate = self;
            view.codeTF.delegate = self;
//            view.acquireCodeBlock = ^{
//                [weakSelf acquireCode];
//            };
            view.nextPageBlock = ^{
                [weakSelf acquireCode];
                //[weakSelf nextPage];
            };
            view;
        });
    }
    return _verificationView;
}



@end
