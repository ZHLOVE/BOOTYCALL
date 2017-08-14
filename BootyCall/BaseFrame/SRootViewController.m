//
//  SRootViewController.m
//  BootyCall
//
//  Created by mac on 16/8/9.
//  Copyright © 2016年 dazhongdiy. All rights reserved.
//

#import "SRootViewController.h"
#import "SLeftViewController.h"
#import "SSubRootViewController.h"
#import "SCustomView.h"
#import "SFoldawayButton.h"
#import "SLabelView.h"

@interface SRootViewController ()<UIViewControllerTransitioningDelegate>

/**左抽屉*/
@property(nonatomic,strong)SLeftViewController                  *leftVc;
/**遮罩*/
@property(nonatomic,strong)SCustomView                          *shadView;
/**按钮*/
@property(nonatomic,strong)SFoldawayButton                      *foldawayBtn;
/**<#nature#>*/
@property(nonatomic,strong)SLabelView                           *nickName;

-(void)initializeDataSource;/**< 初始化数据源 */
-(void)initializeUserInterface;/**< 初始化用户界面 */

@end

@implementation SRootViewController

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.transitioningDelegate = self;
        
        //避免重复初始化
        
        if (!_leftVc) {
            _subRootVc = [[SSubRootViewController alloc]init];
            _leftVc = [[SLeftViewController alloc]init];
            self.leftVc.view.center = CGPointMake( - SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2);
        }
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(openLeftSideNotification:) name:@"openLeftSide" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(closeLeftSideNotification:) name:@"closeLeftSide" object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initializeDataSource];
    [self initializeUserInterface];
}
#pragma mark - ******* Initialize *******

-(void)initializeDataSource{
    
}

-(void)initializeUserInterface{

    weakSelf();
    self.foldawayBtn = [SFoldawayButton sharSfoldawayButton];
    self.foldawayBtn.showType = showTypeOfCircle;
    self.foldawayBtn.automaticShowDirection = YES;
    self.foldawayBtn.disperseDistance = SCREEN_WIDTH * 0.36; //140
    [self.foldawayBtn showInView:[UIApplication sharedApplication].keyWindow navigationBar:YES tabBar:NO];
    self.foldawayBtn.alpha = 0.f;
    [UIView animateWithDuration:0.55 animations:^{
        weakSelf.foldawayBtn.alpha = 1.f;
    }];
    self.foldawayBtn.clickSubButtonBack = ^(int index, NSString *title, BOOL select){
        [weakSelf respondsToSubButton:index];
    };
    //跟控制器添加子控制器
    [self addChildViewController:_subRootVc];
    self.shadView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.shadView];
    [self addChildViewController:self.leftVc];


    
}

#pragma mark - ******* Methods *******
/**
 *  侧边栏发送过来的通知，用于关闭侧边栏
 *
 *  @param sender
 */
-(void)closeLeftSideNotification:(NSNotification*)sender{
    [self closeLeftSide];
}
/**
 *  主页发送过来的通知，用于打开侧边栏
 *
 *  @param sender
 */
-(void)openLeftSideNotification:(NSNotification*)sender{
    [self openLeftSide];
}
/**
 *  重写添加子控制器的方法
 *
 *  @param childController 子控制器
 */
-(void)addChildViewController:(UIViewController *)childController{
    
    [super addChildViewController:childController];
    [self.view addSubview:childController.view];
    [childController didMoveToParentViewController:self];
}
/**
 *  打开抽屉
 */
-(void)openLeftSide{
    weakSelf();
    [UIView animateWithDuration:0.35 animations:^{
        weakSelf.leftVc.view.center = CGPointMake(80, SCREEN_HEIGHT / 2.0);
        weakSelf.shadView.alpha = 0.6;
    }];
    //为了在折叠按钮展开的时候，不再让它响应，这里发送通知到SFoldawayButton这个类，将其收回
    [[NSNotificationCenter defaultCenter]postNotificationName:@"clickBtn" object:nil];
    [self.foldawayBtn.btnsArray enumerateObjectsUsingBlock:^(SButton * _Nonnull button, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = (UIButton*)button;
        btn.userInteractionEnabled = NO;
    }];
    self.foldawayBtn.mainBtn.userInteractionEnabled = NO;
    self.foldawayBtn.coverBtn.userInteractionEnabled = NO;
}
/**
 *  关闭抽屉
 */
-(void)closeLeftSide{
    weakSelf();
    [UIView animateWithDuration:0.35 animations:^{
        weakSelf.leftVc.view.center = CGPointMake( - SCREEN_WIDTH / 2.0, SCREEN_HEIGHT / 2.0);
        weakSelf.shadView.alpha = 0;
    }];
    //关闭按钮交互
    self.foldawayBtn.mainBtn.userInteractionEnabled = YES;
    self.foldawayBtn.coverBtn.userInteractionEnabled = YES;
    [self.foldawayBtn.btnsArray enumerateObjectsUsingBlock:^(SButton * _Nonnull button, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = (UIButton*)button;
        btn.userInteractionEnabled = YES;
    }];
}

/**
 *  动画
 *  Mr ma
 *  @param presented
 *  @param presenting
 *  @param source
 *
 *  @return
 */
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return [MLoginTransition transitionWithTransitionType:XWPresentOneTransitionTypePresent];
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return [MLoginTransition transitionWithTransitionType:XWPresentOneTransitionTypeDismiss];
}


#pragma mark - ******* Events *******
/**
 *  根据按钮的下标获取当前控制器
 *
 *  @param index 按钮脚标
 */
-(void)respondsToSubButton:(int)index{
    //显示当前控制器
    [[NSNotificationCenter defaultCenter]postNotificationName:@"showingCurrenController" object:[NSString stringWithFormat:@"%d",index] userInfo:@{@"btn":self.foldawayBtn.btnsArray[index]}];
}
/**
 *  单击遮罩关闭抽屉
 *
 *  @param gesture 单击手势
 */
-(void)respondsToCloseTapGesture:(UIGestureRecognizer*)gesture{
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [self closeLeftSide];
    }
}


#pragma mark - ******* Getters *******
-(SCustomView *)shadView{
    if (!_shadView) {
        _shadView = [[SCustomView alloc]initWithFrame:self.view.bounds];
        [_shadView setWhiteValue:0.1 alphaValue:0.9];
        _shadView.alpha = 0;
        UITapGestureRecognizer *closeTapLeftGeture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(respondsToCloseTapGesture:)];
        [_shadView addGestureRecognizer:closeTapLeftGeture];
    }
    return _shadView;
}





@end
