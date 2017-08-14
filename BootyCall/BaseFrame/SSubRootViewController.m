//
//  SSubRootViewController.m
//  BootyCall
//
//  Created by mac on 16/8/10.
//  Copyright © 2016年 dazhongdiy. All rights reserved.
//

#import "SSubRootViewController.h"
#import "ConversationListController.h"
#import "SFriendsViewController.h"
#import "SHomeViewController.h"
#import "SPairViewController.h"
#import "SShareViewController.h"

@interface SSubRootViewController ()

{
    NSInteger _lastIndex;
}

/**聊天界面*/
@property(nonatomic,strong)ConversationListController           *chatVc;
/**朋友圈界面*/
@property(nonatomic,strong)SFriendsViewController               *friendsVc;
/**配对界面*/
@property(nonatomic,strong)SPairViewController                  *pairVc;
/**分享界面*/
@property(nonatomic,strong)SShareViewController                 *shareVc;
/**获取到按钮点击的控制器*/
@property(nonatomic,strong)UIViewController                     *showingVc;
/**推送动画*/
@property(nonatomic,strong)UIView                               *animationView;

-(void)initializeDataSource;/**< 初始化数据源 */
-(void)initializeUserInterface;/**< 初始化用户界面 */
@end

@implementation SSubRootViewController

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showingCurrenController:) name:@"showingCurrenController" object:nil];
        _homeVc = [[SHomeViewController alloc]init];
        _chatVc = [[ConversationListController alloc]init];
        _friendsVc = [[SFriendsViewController alloc]init];
        _pairVc = [[SPairViewController alloc]init];
        _shareVc = [[SShareViewController alloc]init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self initializeDataSource];
    [self initializeUserInterface];
    


}

-(void)initializeDataSource{
    _lastIndex = 0;
    [self addChildViewController:[[UINavigationController alloc] initWithRootViewController:_homeVc]];
    [self addChildViewController:[[UINavigationController alloc] initWithRootViewController:_chatVc]];
    [self addChildViewController:[[UINavigationController alloc] initWithRootViewController:_friendsVc]];
    [self addChildViewController:[[UINavigationController alloc] initWithRootViewController:_pairVc]];
    [self addChildViewController:[[UINavigationController alloc] initWithRootViewController:_shareVc]];
}

-(void)initializeUserInterface{
    //推送动画
    UIView *view = [[UIView alloc]init];
    view.frame = self.view.frame;
    [self.view addSubview:view];
    self.animationView = view;
    //设置首页为当前控制器
    self.showingVc = self.childViewControllers[0];
    self.showingVc.view.frame = self.animationView.bounds;
    [self.animationView addSubview:self.showingVc.view];
}


-(void)showingCurrenController:(NSNotification*)sender{
    
    NSInteger index = [sender.object integerValue];
    if (_lastIndex == index) {
        //提示
        return;
    }
    NSInteger showingVcindex = [self.childViewControllers indexOfObject:self.showingVc];
    _lastIndex = index;
    [self.showingVc.view removeFromSuperview];
    self.showingVc = self.childViewControllers[index];
    self.showingVc.view.frame = self.animationView.frame;
    [self.animationView addSubview:self.showingVc.view];
    
    CATransition *animation = [CATransition animation];
    animation.duration = 0.35;
    animation.type =  kCATransitionPush;
    animation.subtype = showingVcindex > index ? kCATransitionFromLeft:kCATransitionFromRight;
    [self.animationView.layer addAnimation:animation forKey:@"animationView"];
    
    
}





@end
