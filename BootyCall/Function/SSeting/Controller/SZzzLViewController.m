//
//  SZzzLViewController.m
//  BootyCall
//
//  Created by mac on 16/8/18.
//  Copyright © 2016年 dazhongdiy. All rights reserved.
//

#import "SZzzLViewController.h"
#import "CustomModalTransition.h"
#import "SFoldawayButton.h"
#import "VerticalTextLabel.h"
@interface SZzzLViewController ()<UITextViewDelegate>
{
    CustomModalTransition *transitionToNextModal;
    UITextView            *_textView;
    UIView                *_navView;
    NSString              *_textContent;
    
}
@end

@implementation SZzzLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeDataSource];
    [self initializeUserInterface];
    
}

#pragma mark - ******* Initialize *******

-(void)initializeDataSource{
    self.transitioningDelegate = self.transitionManager;
    transitionToNextModal = [[CustomModalTransition alloc] init];
    _textContent = HAFB_TEXT;
    
}

-(void)initializeUserInterface{
    //仿导航条视图
    _navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    _navView.backgroundColor = MainColor;
    [self.view addSubview:_navView];
    
    VerticalTextLabel *lable = [[VerticalTextLabel alloc]initWithFrame:CGRectMake(15, 30, 30, 200)];
    lable.font = [UIFont boldSystemFontOfSize:18.f];
    lable.text = @"帮助与反馈";
    lable.backgroundColor =[UIColor clearColor];
    [self.view addSubview:lable];

    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancel setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(clickCancel:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancel];
    [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@44);
        make.height.equalTo(cancel.mas_width);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.centerY.equalTo(self.view.mas_centerY).offset(10);
    }];
    //弹出使用协议
    _textView = [[UITextView alloc]init];
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.font = [UIFont systemFontOfSize:13.f];
    _textView.textColor = [UIColor lightGrayColor];
    _textView.text = _textContent;
    _textView.layer.borderColor = MainColor.CGColor;
    _textView.layer.borderWidth = 1.f;
    _textView.layer.cornerRadius = 3.f;
    _textView.layer.masksToBounds = YES;
    _textView.editable = YES;
    _textView.delegate = self;
    [self.view addSubview:_textView];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(64);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.bottom.equalTo(self.view.mas_bottom).offset(-10);
        make.top.equalTo(_navView.mas_bottom).offset(10);
    
    }];

}



#pragma mark - ******* For Presen Modally mode (simple transition) *******


- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                   presentingController:(UIViewController *)presenting
                                                                       sourceController:(UIViewController *)source {
    return transitionToNextModal;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed  {
    return transitionToNextModal;
}


#pragma mark - ******* delegate *******

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return NO;
}




#pragma mark - ******* Events *******

-(void)clickCancel:(UIButton*)sender{
    [[UIApplication sharedApplication].keyWindow addSubview:[SFoldawayButton sharSfoldawayButton]];
    self.transitionManager.closeVCNow = YES;
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

@end
