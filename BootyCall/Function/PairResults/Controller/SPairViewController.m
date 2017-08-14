//
//  SPairViewController.m
//  BootyCall
//
//  Created by mac on 16/8/10.
//  Copyright © 2016年 dazhongdiy. All rights reserved.
//

#import "SPairViewController.h"
#import "QPairTableViewCell.h"
#import "MJRefresh.h"
#import "ChatViewController.h"
#import "QPairModel.h"
#import "XHRadarView.h"
#import  "QPairInfo.h"
#import "SCustomSingleton.h"

#define PAIRCELLINDEN @"pairCell"

@interface SPairViewController ()<XHRadarViewDataSource,XHRadarViewDelegate>


@property (nonatomic, strong) XHRadarView *radarView;
/**
 *  显示表格视图
 */
@property(nonatomic,strong)UITableView *PairTableView;
/**
 *  搜索结果数据源
 */
@property(nonatomic,strong)NSMutableArray  *searchResultDataSource;


@property (nonatomic, strong) NSMutableArray *pointsArray;
/**
 *  半径
 */
@property(nonatomic,assign)NSInteger  radiu;
/**
 *  头像大小
 */
@property(nonatomic,assign)NSInteger avatorRadiu;
/**
 *  简介视图
 */
@property(nonatomic,strong)QPairInfo *pairInfo;



@end

@implementation SPairViewController


-(void)viewDidDisappear:(BOOL)animated {

    [super viewDidDisappear:animated];
    [self.searchResultDataSource removeAllObjects];


}
-(void)dealloc {

 [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
  
    [self initializeDataSource];
    self.pairInfo.hidden = YES;
    _radarView.labelText = @"正在寻找...";
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
//    注册监听
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(doAction) name:UIApplicationWillEnterForegroundNotification object:nil];
    // Do any additional setup after loading the view, typically from a nib.
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"sback"] style:UIBarButtonItemStylePlain target:self action:@selector(respondsToLeftButtonItem)];
    leftButtonItem.imageInsets = UIEdgeInsetsMake(5, -10, 2, 17);
    self.navigationItem.leftBarButtonItems = @[leftButtonItem];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.navigationBar.barTintColor = MainColor;
    
    self.searchResultDataSource = @[].mutableCopy;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(puushToChatViewController:) name:@"QPairchat" object:nil];
    self.pointsArray = @[].mutableCopy;
    
    
    
        self.radiu = SCREEN_WIDTH/2 -10;
    self.avatorRadiu = SCREEN_WIDTH/16;
    self.title = @"配对";
 
    
    
    XHRadarView *radarView = [[XHRadarView alloc] initWithFrame:self.view.bounds];
    
    radarView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    radarView.dataSource = self;
    radarView.delegate = self;
    radarView.radius = self.radiu;
    radarView.backgroundColor = [UIColor colorWithRed:0.251 green:0.329 blue:0.490 alpha:1];
    radarView.backgroundImage = [UIImage imageNamed:@"radar_background.jpg"];
    radarView.labelText = @"正在寻找...";
    [self.view addSubview:radarView];
    _radarView = radarView;
  
    
    
    
    UIImageView *avatarView = [[UIImageView alloc] init];
    avatarView.center = self.radarView.center;
    avatarView.bounds = CGRectMake(0, 0, self.avatorRadiu*2, self.avatorRadiu*2);
    avatarView.layer.cornerRadius = self.avatorRadiu;
    avatarView.layer.masksToBounds = YES;
 
   

    [_radarView addSubview:avatarView];
    [_radarView bringSubviewToFront:avatarView];
    /**
     添加详细视图
     
     
     */
    [self.radarView addSubview:self.pairInfo];
    [self makeConstraint];
    
//    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            [self initializeDataSource];
//        });
    
    
    
    [MResponseUserInfo loadHeadImageUrlCompletion:^(BOOL success, NSString *headImageUrl, NSString *nickName, NSError *error) {
        if (success) {
            [avatarView sd_setImageWithURL:[NSURL URLWithString:headImageUrl]];
        }else{
            
        }
        
    }];
    
   }


-(void)makeConstraint {

    [self.pairInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.top.equalTo(self.view.mas_centerY).offset(self.radiu+10);
        
    }];
}


#pragma mark - Action

-(void)doAction{

    [self.radarView scan];

}

-(void)respondsToLeftButtonItem{
    //发送通知到subRootVc
    [[NSNotificationCenter defaultCenter]postNotificationName:@"showingCurrenController" object:@"0"];
}


-(void)puushToChatViewController:(NSNotification *)notification {
    
   
    NSString *userId = notification.userInfo[@"userId"];
    NSString *name = notification.userInfo[@"name"];

    ChatViewController *chatVC = [[ChatViewController alloc]initWithConversationChatter:userId conversationType:eConversationTypeChat];
    chatVC.title = name;
    [self.navigationController pushViewController:chatVC animated:YES];
    
    
}


-(void)initializeDataSource {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self.radarView scan];
    });
    [self.searchResultDataSource addObjectsFromArray:[QPairModel changeDicToPairModelArray:[SCustomSingleton defaultCustomSingleton].selectedUsersArray]];
    [self createUserPoint];
    [self startUpdatingRadar];
  
    
    
}


-(void)createUserPoint {
   //目标点位置
    NSArray *count = @[@"-1",@"1"];
    
    
    for (NSInteger i = 0; i<self.searchResultDataSource.count; i++) {
        NSMutableArray *point = [NSMutableArray array];
        for (NSInteger i = 0; i<2; i++) {
            NSInteger index = (arc4random()%(self.radiu - self.avatorRadiu)) +self.avatorRadiu+10;
            NSInteger one = [count[arc4random()%2] integerValue];
            NSInteger Pone = index *one;
            [point addObject:[NSNumber numberWithInteger:Pone]];
        }
    
        [_pointsArray addObject:point];
//    NSLog(@"--------------=-=-=-=-%@",_pointsArray);
    
    }
    

}


-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    [self.radarView scan];
}

- (void)startUpdatingRadar {
    typeof(self) __weak weakSelf = self;
    NSInteger time = self.searchResultDataSource.count *1;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.radarView.labelText = [NSString stringWithFormat:@"你中有我，共有%lu个TA", weakSelf.searchResultDataSource.count];
        [weakSelf.radarView show];
    });
}
#pragma mark - XHRadarViewDataSource
- (NSInteger)numberOfSectionsInRadarView:(XHRadarView *)radarView {
    return 4;
}
- (NSInteger)numberOfPointsInRadarView:(XHRadarView *)radarView {
    return [self.searchResultDataSource count];
}
- (UIView *)radarView:(XHRadarView *)radarView viewForIndex:(NSUInteger)index {
      NSInteger aaa = 0;
    NSLog(@"index    %ld",aaa++);
    UIView *pointView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
//    pointView.backgroundColor  = [UIColor redColor];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    imageView.layer.cornerRadius = 35/2.0;
    imageView.layer.masksToBounds = YES;
    QPairModel *model= self.searchResultDataSource[index];
    [imageView sd_setImageWithURL:[NSURL URLWithString:model.headImageUrl]];
    [pointView addSubview:imageView];
    return pointView;
}
- (CGPoint)radarView:(XHRadarView *)radarView positionForIndex:(NSUInteger)index {
    NSArray *point = [self.pointsArray objectAtIndex:index];
    return CGPointMake([point[0] floatValue], [point[1] floatValue]);
}

#pragma mark - XHRadarViewDelegate

- (void)radarView:(XHRadarView *)radarView didSelectItemAtIndex:(NSUInteger)index {
    NSLog(@"didSelectItemAtIndex:%lu", (unsigned long)index);
    self.pairInfo.hidden = NO;
    QPairModel *model = self.searchResultDataSource[index];
    self.pairInfo.model = model;
//    NSString *userInfoId = model.objectId;
//    ChatViewController *chat = [[ChatViewController alloc]initWithConversationChatter:userInfoId conversationType:eConversationTypeChat];
//    [self.navigationController pushViewController:chat animated:YES];
//    
}




#pragma mark - Getter
- (QPairInfo *)pairInfo {

    if (_pairInfo == nil) {
        
        _pairInfo = [[QPairInfo alloc]initWithFrame:CGRectZero];
        _pairInfo .backgroundColor = [UIColor clearColor];
        _pairInfo.hidden = YES;
        
    }
    return _pairInfo;
}



@end
