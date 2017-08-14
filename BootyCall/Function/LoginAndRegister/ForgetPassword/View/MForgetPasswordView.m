//
//  MForgetPasswordView.m
//  BootyCall
//
//  Created by rimi on 16/8/18.
//  Copyright © 2016年 dazhongdiy. All rights reserved.
//

#import "MForgetPasswordView.h"

@interface MForgetPasswordView ()

/**< 白色背景*/
@property(nonatomic,strong)UIView *whiteBgView;


@end

@implementation MForgetPasswordView


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initializeInterface];
    }
    return self;
}


#pragma mark - ******* <#Initialize#> *******

//初始化界面
- (void)initializeInterface{
    self.backgroundColor = [UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
    [self setControlFrame];
}

#pragma mark - ******* <#Methods#> *******

- (void)setControlFrame{
    /**< 提示*/
    UILabel *point = ({
        UILabel *label=[[UILabel alloc]init];
        label.text=@"请输入:";
        label.textColor=[UIColor grayColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.font=[UIFont systemFontOfSize:14];
        label.backgroundColor = [UIColor clearColor];
        label;
    });
    [self addSubview:point];
    [point mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left).offset(30);
        make.right.equalTo(self.mas_right).offset(-30);
        make.height.equalTo(@(30));
    }];
    
    _whiteBgView = ({
        
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = 10;
        view;
    });
    [self addSubview:_whiteBgView];
    [_whiteBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(point.mas_bottom).offset(5);
        make.left.equalTo(self.mas_left).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
        make.height.equalTo(@(150));
    }];
    
    UILabel *phonelabel=({
        
        UILabel *label = [[UILabel alloc]init];
        label.text=@"手机号";
        label.textColor=[UIColor blackColor];
        label.textAlignment=NSTextAlignmentLeft;
        label.font=[UIFont systemFontOfSize:14];
        label;
    });
    [_whiteBgView addSubview:phonelabel];
    [phonelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_whiteBgView.mas_top).offset(12);
        make.left.equalTo(_whiteBgView.mas_left).offset(20);
        make.width.equalTo(@(50));
        make.height.equalTo(@(25));
        
    }];
    
    UILabel *passwordLabel=({
        
        UILabel *label = [[UILabel alloc]init];
        label.text=@"密码";
        label.textColor=[UIColor blackColor];
        label.textAlignment=NSTextAlignmentLeft;
        label.font=[UIFont systemFontOfSize:14];
        label;
    });
    [_whiteBgView addSubview:passwordLabel];
    [passwordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phonelabel.mas_bottom).offset(25);
        make.left.equalTo(_whiteBgView.mas_left).offset(20);
        make.width.equalTo(@(50));
        make.height.equalTo(@(25));
        
    }];
    
    UILabel *codeLab=({
        
        UILabel *label = [[UILabel alloc]init];
        label.text=@"验证码";
        label.textColor=[UIColor blackColor];
        label.textAlignment=NSTextAlignmentLeft;
        label.font=[UIFont systemFontOfSize:14];
        label;
    });
    [_whiteBgView addSubview:codeLab];
    [codeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(passwordLabel.mas_bottom).offset(25);
        make.left.equalTo(_whiteBgView.mas_left).offset(20);
        make.width.equalTo(@(50));
        make.height.equalTo(@(25));
        
    }];
    
    [_whiteBgView addSubview:self.phoneTF];
    [self.phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(phonelabel.mas_centerY);
        make.height.equalTo(@(30));
        make.left.equalTo(phonelabel.mas_right).offset(25);
        make.right.equalTo(_whiteBgView.mas_right).offset(-10);
    }];
    
    UIView *lineView1 = ({
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor grayColor];
        view;
    });
    [_whiteBgView addSubview:lineView1];
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneTF.mas_bottom).offset(5);
        make.centerX.equalTo(_whiteBgView.mas_centerX);
        make.width.equalTo(_whiteBgView.mas_width).offset(-40);
        make.height.equalTo(@(1));
    }];
    [_whiteBgView addSubview:self.codeBtn];
    [self.codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_whiteBgView.mas_right).offset(-20);
        make.width.equalTo(@(80));
        make.height.equalTo(@(30));
        make.centerY.equalTo(passwordLabel.mas_centerY);
    }];
    [_whiteBgView addSubview:self.passwordTF];
    [self.passwordTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(passwordLabel.mas_centerY);
        make.height.equalTo(@(30));
        make.left.equalTo(phonelabel.mas_right).offset(25);
        make.right.equalTo(self.codeBtn.mas_left);
    }];
    
    
    UIView *lineView2 = ({
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor grayColor];
        view;
    });
    [_whiteBgView addSubview:lineView2];
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(passwordLabel.mas_bottom).offset(5);
        make.width.equalTo(_whiteBgView.mas_width).offset(-40);
        make.centerX.equalTo(_whiteBgView.mas_centerX);
        make.height.equalTo(@(1));
    }];
    
    [_whiteBgView addSubview:self.codeTF];
    [self.codeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(codeLab.mas_centerY);
        make.height.equalTo(@(30));
        make.left.equalTo(codeLab.mas_right).offset(25);
        make.right.equalTo(_whiteBgView.mas_right).offset(-10);
    }];
    
    [self addSubview:self.finishBtn];
    [self.finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_whiteBgView.mas_bottom).offset(25);
        make.left.equalTo(self.mas_left).offset(50);
        make.right.equalTo(self.mas_right).offset(-50);
        make.height.equalTo(@(40));
    }];
    
    [self addSubview:self.backBtn];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.finishBtn.mas_bottom).offset(10);
        make.left.equalTo(self.mas_left).offset(50);
        make.right.equalTo(self.mas_right).offset(-50);
        make.height.equalTo(@(40));
    }];
    
}



#pragma mark - ******* <#Events#> *******

- (void)clickedCodeBtn:(UIButton *)sender{
    
    if (self.acquireCodeBlock) {
        self.acquireCodeBlock();
    }
    
    
}
- (void)clickedFinishBtn:(UIButton *)sender{
    
    if (self.finishBlock) {
        self.finishBlock();
    }
}
- (void)clickedBackBtn:(UIButton *)sender{
    
    if (self.backBlock) {
        self.backBlock();
    }
    
}

#pragma mark - ******* <#Delegate#> *******



#pragma mark - ******* <#Getters#> *******

- (UITextField *)phoneTF{
    
    if (!_phoneTF) {
        _phoneTF = ({
            
            UITextField *textField = [[UITextField alloc]init];
            textField.font= [UIFont systemFontOfSize:14];
            
            textField.textColor = [UIColor grayColor];
            textField.borderStyle = UITextBorderStyleNone;
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            textField.keyboardType = UIKeyboardTypeNumberPad;
            textField.placeholder= @"11位手机号";
            textField;
        });
    }
    return _phoneTF;
}

- (UITextField *)passwordTF{
    
    if (!_passwordTF) {
        _passwordTF = ({
            UITextField *textField = [[UITextField alloc]init];
            textField.font= [UIFont systemFontOfSize:14];
            textField.textColor = [UIColor grayColor];
            textField.borderStyle = UITextBorderStyleNone;
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            textField.secureTextEntry = YES;
            textField.placeholder= @"6-16位密码";
            
            textField;
        });
    }
    return _passwordTF;
    
}


- (UITextField *)codeTF{
    
    if (!_codeTF) {
        _codeTF = ({
            UITextField *textField = [[UITextField alloc]init];
            textField.font= [UIFont systemFontOfSize:14];
            
            textField.textColor = [UIColor grayColor];
            textField.borderStyle = UITextBorderStyleNone;
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            textField.keyboardType = UIKeyboardTypeNumberPad;
            textField.placeholder= @"6位验证码";
            textField;
        });
    }
    return _codeTF;
}



- (UIButton *)codeBtn{
    
    if (!_codeBtn) {
        _codeBtn = ({
            
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:@"获取验证码" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithRed:248/255.0f green:144/255.0f blue:34/255.0f alpha:1] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:13];
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            [button addTarget:self action:@selector(clickedCodeBtn:) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _codeBtn;
}



- (UIButton *)finishBtn{
    
    
    if (!_finishBtn) {
        _finishBtn = ({
            
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:@"完  成" forState:UIControlStateNormal];
            button.titleLabel.textColor = [UIColor blackColor];
            button.titleLabel.font = [UIFont systemFontOfSize:17];
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            [button addTarget:self action:@selector(clickedFinishBtn:) forControlEvents:UIControlEventTouchUpInside];
            button.layer.cornerRadius = 5.0f;
            button.backgroundColor = MainColor;
            button;
        });
    }
    return _finishBtn;
}

- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = ({
            
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:@"返  回" forState:UIControlStateNormal];
            button.titleLabel.textColor = [UIColor blackColor];
            button.titleLabel.font = [UIFont systemFontOfSize:17];
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            [button addTarget:self action:@selector(clickedBackBtn:) forControlEvents:UIControlEventTouchUpInside];
            button.layer.cornerRadius = 5.0f;
            button.backgroundColor = MainColor;
            button;
        });
    }
    return _backBtn;
    
}



@end
