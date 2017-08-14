//
//  MSettingPasswordView.m
//  BootyCall
//
//  Created by orange on 16/8/14.
//  Copyright © 2016年 dazhongdiy. All rights reserved.
//

#import "MSettingPasswordView.h"

@interface MSettingPasswordView ()

/**< 白色背景*/
@property(nonatomic,strong)UIView *whiteBgView;



@end

@implementation MSettingPasswordView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initializeInterface];
    }
    return self;
}

#pragma mark - ******* Initialize *******
//初始化界面
- (void)initializeInterface{
    self.backgroundColor = [UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
    [self setControlFrame];
    
    
}

#pragma mark - ******* Methods *******
- (void)setControlFrame{
    weakSelf();
    /**< 提示*/
    _point = ({
        UILabel *label=[[UILabel alloc]init];
        label.text=@"请输入您要设置的密码";
        label.textColor=[UIColor grayColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.font=[UIFont systemFontOfSize:13];
        label.backgroundColor = [UIColor clearColor];
        label;
    });
    [self addSubview:_point];
    [_point mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top);
        make.left.equalTo(weakSelf.mas_left).offset(30);
        make.right.equalTo(weakSelf.mas_right).offset(-30);
        make.height.equalTo(@(30));
    }];
    _whiteBgView = ({
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = 6.0f;
        view;
    });
    [self addSubview:_whiteBgView];
    [_whiteBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_point.mas_bottom).offset(5);
        make.left.equalTo(weakSelf.mas_left).offset(10);
        make.right.equalTo(weakSelf.mas_right).offset(-10);
        make.height.equalTo(@(50));
    }];
    _passwordlabel=({
        UILabel *label = [[UILabel alloc]init];
        label.text=@"验证码";
        label.textColor=[UIColor blackColor];
        label.textAlignment=NSTextAlignmentLeft;
        label.font=[UIFont systemFontOfSize:14];
        label;
    });
    [_whiteBgView addSubview:_passwordlabel];
    [_passwordlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_whiteBgView.mas_top).offset(12);
        make.left.equalTo(_whiteBgView.mas_left).offset(20);
        make.width.equalTo(@(50));
        make.height.equalTo(@(25));
        
    }];
    [_whiteBgView addSubview:self.passwordTF];
    [self.passwordTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_passwordlabel.mas_centerY);
        make.height.equalTo(@(30));
        make.left.equalTo(_passwordlabel.mas_right).offset(25);
        make.right.equalTo(_whiteBgView.mas_right).offset(-10);
    }];
    [self addSubview:self.nextBtn];
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_whiteBgView.mas_bottom).offset(50);
        make.left.equalTo(weakSelf.mas_left).offset(50);
        make.right.equalTo(weakSelf.mas_right).offset(-50);
        make.height.equalTo(@(40));
    }];
}

#pragma mark - ******* Events *******
- (void)clickedNextBtn:(UIButton *)sender{
    
    if (self.nextPageBlock) {
        self.nextPageBlock();
    }
    
    
}
#pragma mark - ******* Delegate *******



#pragma mark - ******* Getters *******

- (UITextField *)passwordTF{
    
    if (!_passwordTF) {
        _passwordTF = ({
            UITextField *textField = [[UITextField alloc]init];
            textField.font= [UIFont systemFontOfSize:14];
            
            textField.textColor = [UIColor grayColor];
            
            textField.borderStyle = UITextBorderStyleNone;
            
            textField.placeholder= @"验证码";
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
         
            textField.keyboardType = UIKeyboardTypeNumberPad;
            textField;
        });
    }
    return _passwordTF;
}

- (UIButton *)nextBtn{
    
    if (!_nextBtn) {
        _nextBtn = ({
            
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:@"下一步" forState:UIControlStateNormal];
            button.titleLabel.textColor = [UIColor blackColor];
            button.titleLabel.font = [UIFont systemFontOfSize:17];
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            [button addTarget:self action:@selector(clickedNextBtn:) forControlEvents:UIControlEventTouchUpInside];
            button.layer.cornerRadius = 6.0f;
            button.backgroundColor = MainColor;
            button;
        });
    }
    return _nextBtn;
}
@end
