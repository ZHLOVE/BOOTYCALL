//
//  SHelpViewController.m
//  BootyCall
//
//  Created by mac on 16/8/18.
//  Copyright © 2016年 dazhongdiy. All rights reserved.
//

#import "SHelpViewController.h"
#import "CustomModalTransition.h"
#import "GITransition.h"
#import "SFoldawayButton.h"

@interface SHelpViewController ()<UITextViewDelegate>

{
    CustomModalTransition *transitionToNextModal;
    UITextView            *_textView;
    UIView                *_navView;
    NSString              *_textContent;

}


-(void)initializeDataSource;/**< 初始化数据源 */
-(void)initializeUserInterface;/**< 初始化用户界面 */
@end

@implementation SHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeDataSource];
    [self initializeUserInterface];
    
}

#pragma mark - ******* Initialize *******

-(void)initializeDataSource{
    self.transitioningDelegate = self.transitionManager;
    transitionToNextModal = [[CustomModalTransition alloc] init];
    _textContent = BZYFK_TEXT;
    
}

-(void)initializeUserInterface{
    //仿导航条视图
    _navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 84)];
    _navView.backgroundColor = MainColor;
    [self.view addSubview:_navView];
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"用户协议";
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:18.f];
    [_navView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_navView.mas_left).offset(20);
        make.height.equalTo(@30);
        make.bottom.equalTo(_navView.mas_bottom).offset(-17);
        make.width.equalTo(@200);
    }];
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancel setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(clickCancel:) forControlEvents:UIControlEventTouchUpInside];
    //cancel.imageEdgeInsets = UIEdgeInsetsMake(20, 20, 20, 20);
    [_navView addSubview:cancel];
    [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@44);
        make.height.equalTo(cancel.mas_width);
        make.right.equalTo(self.view.mas_right).offset(-20);
        //make.centerX.equalTo(_navView.mas_centerX);
        make.centerY.equalTo(_navView.mas_centerY).offset(10);
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
    _textView.delegate = self;
    _textView.editable = YES;
    [self.view addSubview:_textView];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.bottom.equalTo(self.view.mas_bottom).offset(-10);
        make.top.equalTo(_navView.mas_bottom).offset(10);
    }];


}

#pragma mark - ***** delegate ********

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    //[textView resignFirstResponder];
    return NO;
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




#pragma mark - ******* Events *******

-(void)clickCancel:(UIButton*)sender{
    self.transitionManager.closeVCNow = YES;
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_textView resignFirstResponder];
}




@end
