//
//  MUserInfoView.m
//  BootyCall
//
//  Created by orange on 16/8/14.
//  Copyright © 2016年 dazhongdiy. All rights reserved.
//

#import "MUserInfoView.h"
#import "SRootViewController.h"


#define ContentColor  [UIColor whiteColor]
#define TextColor     [UIColor whiteColor]

@interface MUserInfoView ()<UITextFieldDelegate>


/**< 信息背景View*/
@property(nonatomic,strong)UIView *infoBackgroundView;

// 时间选择器
@property (nonatomic, strong) UIDatePicker *datePicker;
/**< 性别选择--男*/
@property(nonatomic,strong)UIButton *genderBoy;
/**< 性别选择--女*/
@property(nonatomic,strong)UIButton *genderGirl;
/**< 分段控制器*/
@property(nonatomic,strong)UISegmentedControl *genderSegmented;





@end

@implementation MUserInfoView


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
    weakSelf();
    self.backgroundColor = [UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
    _infoBackgroundView = ({
        
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor whiteColor];
        view.userInteractionEnabled = YES;
        view;
    });
    [self addSubview:_infoBackgroundView];
    [_infoBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top);
        make.left.equalTo(weakSelf.mas_left);
        make.right.equalTo(weakSelf.mas_right);
        make.height.equalTo(@(80));
    }];
    [self addSubview:self.headImageBtn];
    [self.headImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).offset(5);
        make.bottom.equalTo(_infoBackgroundView.mas_bottom).offset(-10);
        make.width.equalTo(@(80));
        make.height.equalTo(@(80));
    }];
    [self.headImageBtn setImage:[UIImage imageNamed:@"sadd.png"] forState:UIControlStateNormal];
    [_infoBackgroundView addSubview:self.nameTF];
    [self.nameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.headImageBtn.mas_right).offset(10);
        make.right.equalTo(_infoBackgroundView.mas_right);
        make.height.equalTo(@(20));
        make.top.equalTo(_infoBackgroundView.mas_top).offset(10);
    }];
    [_infoBackgroundView addSubview:self.birthdayTF];
    [self.birthdayTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.headImageBtn.mas_right).offset(10);
        make.right.equalTo(_infoBackgroundView.mas_right);
        make.height.equalTo(@(20));
        make.bottom.equalTo(_infoBackgroundView.mas_bottom).offset(-10);
    }];
    UIView *lineView = ({
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor grayColor];
        view;
    });
    [_infoBackgroundView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.headImageBtn.mas_right).offset(10);
        make.right.equalTo(_infoBackgroundView.mas_right);
        make.height.equalTo(@(0.6));
        make.centerY.equalTo(_infoBackgroundView.mas_centerY);
    }];
    UILabel *promotLab = ({
        
        UILabel *label = [[UILabel alloc]init];
        label.text = @"性别:";
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:16.f];
        label;
    });
    [self addSubview:promotLab];
    [promotLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_infoBackgroundView.mas_bottom).offset(80);
        make.left.equalTo(weakSelf.mas_left).offset(5);
        make.height.equalTo(@(30));
    }];
    _genderSegmented = ({
        UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:@[@"男",@"女"]];
        segmentedControl.selectedSegmentIndex = 0;
        [segmentedControl addTarget:self action:@selector(segmentedAction:) forControlEvents:UIControlEventValueChanged];
        segmentedControl.tintColor = MainColor;
        //segmentedControl.layer.borderWidth = 0.6;
        segmentedControl;
        
    });
    
    [self addSubview:_genderSegmented];
    [_genderSegmented mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).offset(5);
        make.right.equalTo(weakSelf.mas_right).offset(-5);
        //make.width.equalTo(@60);
        make.top.equalTo(promotLab.mas_bottom).offset(5);
        make.height.equalTo(@(28));
    }];
    UILabel *accordLab = ({
        UILabel *label = [[UILabel alloc]init];
        label.text = @"注册成为会员即为同意以下";
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:15];
        label;
    });
    [self addSubview:accordLab];
    [accordLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).offset(5);
        make.top.equalTo(_genderSegmented.mas_bottom).offset(15);
        make.height.equalTo(@(18));
    }];
    UIButton *accordBtn = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor clearColor];
        NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"用户协议"]];
        NSRange contentRange = {0,[content length]};
        [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
        [button setTitle:@"《用户协议》" forState:UIControlStateNormal];
        button.titleLabel.attributedText = content;
        [button setTitleColor:MainColor forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button addTarget:self action:@selector(clickedaccordBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        button;
    });
    [self addSubview:accordBtn];
    [accordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(accordLab.mas_centerY);
        make.left.equalTo(accordLab.mas_right);
        make.height.equalTo(accordLab.mas_height);
    }];
    
    _completeBtn = ({
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"完成" forState:UIControlStateNormal];
        button.titleLabel.textColor = [UIColor blackColor];
        button.titleLabel.font = [UIFont systemFontOfSize:17];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button addTarget:self action:@selector(clickedcompleteBtn:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.cornerRadius = 6.0f;
        button.backgroundColor = MainColor;
        button;
    });
    [self addSubview:_completeBtn];
    [_completeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(accordBtn.mas_bottom).offset(50);
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.left.equalTo(weakSelf.mas_left).offset(50);
        make.right.equalTo(weakSelf.mas_right).offset(-50);
        make.height.equalTo(@(40));
    }];
    
    
}

#pragma mark - ******* Methods *******
- (void)selectedDatePicker {
    
    // 获得当前选择的时间
    NSDate *currentDate = self.datePicker.date;
    // 转换成字符串
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd";
    NSString *currentDateStr = [formatter stringFromDate:currentDate];
    
    // 赋值
    self.birthdayTF.text = currentDateStr;
}




#pragma mark - ******* Events *******

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.birthdayTF resignFirstResponder];
    [self.nameTF resignFirstResponder];

}

- (void)clickedaccordBtn:(UIButton *)sender{
    if (self.protocolResponed) {
        self.protocolResponed();
    }
}
- (void)clickedcompleteBtn:(UIButton *)sender{
    
    if (self.userInfoComplete) {
        self.userInfoComplete();
    }
}

- (void)clickedToAddHeadImage:(UIButton *)sender{
    
    if (self.addImageResponed) {
        self.addImageResponed();
    }

}


#pragma mark - ******* Delegate *******


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (textField == self.birthdayTF) {
        textField.inputView = self.datePicker;
    }
    return YES;
}

- (void) segmentedAction:(UISegmentedControl *)sender{
    
    if (self.genderInfoComplete) {
        if (sender.selectedSegmentIndex == 0) {
            
            sender.tintColor = MainColor;
            
            
        }else{
            sender.tintColor = MainColor;
            
        }
        self.genderInfoComplete([NSString stringWithFormat:@"%ld",(long)sender.selectedSegmentIndex]);
    }
}


#pragma mark - ******* Getters *******


- (UIButton *)headImageBtn{
    
    if (!_headImageBtn) {
        _headImageBtn = ({
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.backgroundColor = [UIColor lightGrayColor];
            [button addTarget:self action:@selector(clickedToAddHeadImage:) forControlEvents:UIControlEventTouchUpInside];
            //button.imageEdgeInsets = UIEdgeInsetsMake(2, 2, 2, 2);
            button;
        });
    }
    return _headImageBtn;
}

- (UITextField *)nameTF{
    
    if (!_nameTF) {
        _nameTF = ({
            
            UITextField *textField = [[UITextField alloc]init];
            textField.font= [UIFont systemFontOfSize:18];
            textField.textColor = [UIColor grayColor];
            textField.borderStyle = UITextBorderStyleNone;
            textField.placeholder= @"昵称";
            textField;
        });
    }
    return _nameTF;
}

- (UITextField *)birthdayTF{
    
    if (!_birthdayTF) {
        _birthdayTF = ({
            UITextField *textField = [[UITextField alloc]init];
            textField.font= [UIFont systemFontOfSize:18];
            textField.textColor = [UIColor grayColor];
            textField.borderStyle = UITextBorderStyleNone;
            textField.delegate = self;
            textField.placeholder= @"生日";
            
            textField;
            
            
        });
    }
    return _birthdayTF;


}

- (UIDatePicker *)datePicker {
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] init];
       
        // 设置时区
        _datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
        // 设置显示模式
        _datePicker.datePickerMode = UIDatePickerModeDate;
        // 设置最小时间和最大时间
        NSTimeInterval maginTime = 60 * 365 * 24 * 60 * 60 ;
        _datePicker.maximumDate = [[NSDate alloc]init];
        _datePicker.minimumDate = [NSDate dateWithTimeIntervalSince1970:-maginTime];
//        _datePicker.maximumDate = [[NSDate];
        // 设置最小时间间隔 (必须能被60整除)
        _datePicker.minuteInterval = 15;
        // 添加监听方法
        [_datePicker addTarget:self action:@selector(selectedDatePicker) forControlEvents:UIControlEventValueChanged];
    }
    return _datePicker;
}



@end
