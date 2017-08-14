//
//  MForgetPasswordViewController.m
//  BootyCall
//
//  Created by rimi on 16/8/18.
//  Copyright © 2016年 dazhongdiy. All rights reserved.
//

#import "MForgetPasswordViewController.h"

#import "MForgetPasswordView.h"

@interface MForgetPasswordViewController ()

/**< 忘记密码页面*/
@property(nonatomic,strong)MForgetPasswordView *forgetPasswordView;

@end

@implementation MForgetPasswordViewController

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
    weakSelf();
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
    [self.view addSubview:self.forgetPasswordView];
    [self.forgetPasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(44);
        make.width.equalTo(weakSelf.view.mas_width);
        make.height.equalTo(weakSelf.view.mas_height).offset(-75);
    }];
    
}
#pragma mark - ******* Methods *******

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.forgetPasswordView.phoneTF resignFirstResponder];
    [self.forgetPasswordView.passwordTF resignFirstResponder];
    [self.forgetPasswordView.codeTF resignFirstResponder];

}



#pragma mark - ******* <#Events#> *******
- (void)acquireCode{
    weakSelf();
        self.forgetPasswordView.codeBtn.enabled = NO;
        [self showProgressHUD:self.view hint:nil hide:nil];
        [MUserRegister resetPassWordWithMobilePhone:self.forgetPasswordView.phoneTF.text RigisterCompletion:^(BOOL success, NSError *error) {
            if (success) {
                [weakSelf removePorgressHud];
                [weakSelf.forgetPasswordView.codeBtn setTitle:@"发送成功" forState:UIControlStateNormal];
            }else{
                [weakSelf removePorgressHud];
                switch (error.code) {
                    case 213:
                        [UIAlertController showAlertWithTitle:@"提示" message:@"手机号码对应的用户不存在" target:weakSelf];
                        break;
                    case 212:
                        [UIAlertController showAlertWithTitle:@"提示" message:@"请提供手机号码" target:weakSelf];
                        break;
                    default:
                        [UIAlertController showAlertWithTitle:@"提示" message:error.localizedDescription target:weakSelf];
                        break;
                }
                NSLog(@"%d",error.code);
                weakSelf.forgetPasswordView.codeBtn.enabled = YES;
            }
        }];
}

- (void)submitSuccessed{
    weakSelf();
    self.forgetPasswordView.finishBtn.enabled = NO;
    [self showProgressHUD:self.view hint:nil hide:nil];
    if (self.forgetPasswordView.passwordTF.text.length < 6) {
        [UIAlertController showAlertWithTitle:nil message:@"密码需要大于6位" target:self];
        self.forgetPasswordView.finishBtn.enabled = NO;
        [self removePorgressHud];
        return;
    }
    [MUserRegister resetPassWordWithSmsCode:self.forgetPasswordView.codeTF.text NewPassWord:self.forgetPasswordView.passwordTF.text RigisterCompletion:^(BOOL success, NSError *error) {
        if (success) {
            [weakSelf removePorgressHud];
            weakSelf.forgetPasswordView.finishBtn.enabled = YES;
            [weakSelf.forgetPasswordView.phoneTF resignFirstResponder];
            [weakSelf.forgetPasswordView.passwordTF resignFirstResponder];
            [weakSelf.forgetPasswordView.codeTF resignFirstResponder];
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
           
        }else{
            [weakSelf removePorgressHud];
            NSLog(@"%ld",error.code);
            switch (error.code) {
                case 1:
                    [UIAlertController showAlertWithTitle:@"提示" message:@"参数错误" target:weakSelf];
                    break;
                case 601:
                    [UIAlertController showAlertWithTitle:@"提示" message:@"发送短信过于频繁" target:weakSelf];
                    break;
                case 124:
                    [UIAlertController showAlertWithTitle:@"提示" message:@"请求超时" target:weakSelf];
                    break;
                case 201:
                    [UIAlertController showAlertWithTitle:@"提示" message:@"没有提供密码，或者密码为空" target:weakSelf];
                    break;
                case 602:
                    [UIAlertController showAlertWithTitle:@"提示" message:@"发送短信验证码失败" target:weakSelf];
                    break;
                case 212:
                    [UIAlertController showAlertWithTitle:@"提示" message:@"请提供手机号码" target:weakSelf];
                    break;
                default:
                    [UIAlertController showAlertWithTitle:@"提示" message:error.localizedDescription target:weakSelf];
                    break;
            }
            weakSelf.forgetPasswordView.finishBtn.enabled = YES;
        }
    }];
}

- (void)backToLogin{
    [self.forgetPasswordView.phoneTF resignFirstResponder];
    [self.forgetPasswordView.passwordTF resignFirstResponder];
    [self.forgetPasswordView.codeTF resignFirstResponder];
     [self dismissViewControllerAnimated:YES completion:nil];

}

#pragma mark - ******* <#Delegate#> *******



#pragma mark - ******* <#Getters#> *******

- (MForgetPasswordView *)forgetPasswordView{
    
    if (!_forgetPasswordView) {
        _forgetPasswordView = ({
            weakSelf();
            MForgetPasswordView *view = [[MForgetPasswordView alloc]init];
            view.acquireCodeBlock = ^{
                
                [weakSelf acquireCode];
            };
            view.finishBlock = ^{
                [weakSelf submitSuccessed];
            };
            view.backBlock = ^{
                
                [weakSelf backToLogin];
                
            };
            view;
        });
    }
    return _forgetPasswordView;
}

@end
