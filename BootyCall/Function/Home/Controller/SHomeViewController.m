//
//  SHomeViewController.m
//  BootyCall
//
//  Created by mac on 16/8/10.
//  Copyright © 2016年 dazhongdiy. All rights reserved.
//

#import "SHomeViewController.h"
#import "SRootViewController.h"
#import "SSubRootViewController.h"
#import "LeasDraggableContainer.h"
#import "LeasCustomView.h"
#import "SSetViewController.h"
#import "SGuideViewController.h"
#import "LeasUserSettingViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "MResponseUserInfo.h"
#import "SCustomSingleton.h"
#import "LeasUserDetailViewController.h"
#import "GITransition.h"
#import "SFoldawayButton.h"
#import "DiaryViewController.h"


@interface SHomeViewController ()<LeasDraggableContainerDataSource,LeasDraggableContainerDelegate,CLLocationManagerDelegate>
{
    BOOL _isSuccess;
    BOOL _isRepeat;
}
/**
 *  用户照片模型
 */
@property (nonatomic,strong) LeasDraggableContainer *container;

@property (nonatomic,strong) NSMutableArray   *userImageDataSoures;

@property (nonatomic,strong) UIButton  *dislikeButton;

@property (nonatomic,strong) UIButton  *likeButton;

@property (nonatomic,strong) UIButton  *refreshButton;
/**
 *  搜索动画图片
 */
@property (nonatomic,strong) UIView  *searchView;
/**
 *  动画光圈
 */
@property (nonatomic,strong) UIView  *circleView;
/**
 *  动画定时器
 */
@property (nonatomic,strong) NSTimer *timer;
/**
 *  定位计时器
 */
@property (nonatomic,strong) NSTimer  *locationTimer;
/**
 *  用户头像
 */
@property (nonatomic,strong) UIImageView *userHeaderImageView;
/**
 *  提示文本
 */
@property (nonatomic,strong) UILabel  *promptLabel;
/**
 *  推荐按钮
 */
@property (nonatomic,strong) UIButton *recommendedButton;
/**
 *  定位
 */
@property (nonatomic,strong) CLLocationManager *locationManager;
/**
 *  获取最后位置 经纬度结构体
 */
@property (nonatomic,strong) CLLocation *currentLocation;
/**
 *  用户选择对象数组
 */
@property (nonatomic,strong) NSMutableArray  *userValues;
/**
 *  用户不喜欢数组
 */
@property (nonatomic,strong) NSMutableArray  *userDislikeValues;
/**
 *  选择条件
 */
@property (nonatomic,strong) NSMutableDictionary  *seletedDic;
@property (nonatomic,assign) NSInteger  distance;
@property (nonatomic,strong) NSString  *objectGender;
@property (nonatomic,strong) NSString  *myGender;

@property (nonatomic,assign) BOOL   isAction;

@property (nonatomic,strong) LeasUserDetailViewController  *userDetailVC;
/**
 *  异步队列
 */
@property(nonatomic,strong)NSOperationQueue     *queue;

/**
 *  点击获取ID
 */
@property(nonatomic,strong)NSString *objectId;



@end

@implementation SHomeViewController{
    
    GITransition *transitionManager;
    
}

- (void) dealloc{
    [self removeObserver:self forKeyPath:@"likeImageView"];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(jumpNextViewControllerNotification:) name:@"nextViewController" object:nil];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self startimer];
}

- (void) viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [self stoptimer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //    初始化异步线程队列
    self.queue = [[NSOperationQueue alloc]init];
    [self setViewControllerName:@"" bgColor:BgColor];
    [self initializeInterface];
    //[self addCurrentInfornmation];
    [self afterInitializeLocation];
    
}


- (void)startimer{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(searchAnmition:) userInfo:nil repeats:YES];
    }
    if (!_locationTimer) {
        _locationTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(repeatlocation:) userInfo:nil repeats:YES];
    }
}

-(void)stoptimer{
    [_timer invalidate];
    [_locationTimer invalidate];
    self.locationTimer = nil;
    self.timer = nil;
    
}

- (void) repeatlocation:(NSTimer *) timer{
    
    if (_isRepeat == YES) {
        _isRepeat = NO;
        [self afterInitializeLocation];
    }
    
}

- (void) afterInitializeLocation{
     weakSelf();
    [UIView animateWithDuration:1 animations:^{
        _searchView.alpha = _promptLabel.alpha = _recommendedButton.alpha = 1;
        weakSelf.container.alpha = _likeButton.alpha = _dislikeButton.alpha = _refreshButton.alpha = 0;
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf initializeLocation];
        });
    }];
}

- (void) addCurrentInfornmation{
    __weak typeof(self) weakSelf = self;
    [MResponseUserInfo responseCurrentUserInfo:^(BOOL success, NSError *error, NSDictionary *currentUserInfo) {
        if (success) {
            _myGender = currentUserInfo[@"myInfo"][@"gender"];
            [weakSelf initializeDataSource];
        }
    }];
}

- (void) initializeDataSource{
    __weak typeof(self) weakself = self;
    _userImageDataSoures = [NSMutableArray array];
    _userValues = [[NSMutableArray alloc]init];
    _seletedDic = [[NSMutableDictionary alloc]init];
    _seletedDic = [[NSUserDefaults standardUserDefaults]objectForKey:@"screeningDict"];
    if (_seletedDic.count == 0) {
        _distance = 100000000;
    }else{
       NSString *distanceString = _seletedDic[@"distance"];
        _distance = [distanceString floatValue];
        if (_distance == 0) {
            _distance = 1000000000;
        }
    }
    if (_myGender != nil) {
        if ([_myGender  isEqual: @"1"]) {
            _objectGender = @"0";
        }else{
            _objectGender = @"1";
        }
    }
    //NSLog(@"---请求参数:::::--->>>>>>>%@,%ld",_objectGender,_distance);
    //NSLog(@"------>>>>>>>准备进网络加载数据的方法了。");
    [MResponseUserInfo responseNearUserInfoWithGender:_objectGender Kilometers:_distance ResponseCompletion:^(BOOL success, NSError *error, NSArray *Users) {
        NSLog(@"-----成功状态-->>>>%d",success);
        NSLog(@"-----附近人数--->>>%ld",Users.count);
        if (success && Users.count > 0) {
            [_userValues addObjectsFromArray:Users];
            for (int i = 0; i < Users.count; i ++) {
                NSString *headImageUrl = Users[i][@"headImageUrl"];
                NSMutableDictionary *userInfo = Users[i][@"myInfo"];
                NSMutableDictionary *myBasicInfo = Users[i][@"myBasicInfo"];
                NSMutableDictionary *dic = @{@"image" : [NSString stringWithFormat:@"%@",headImageUrl],
                                      @"name" : [NSString stringWithFormat:@"%@",userInfo[@"nickName"]]
                                      ,@"age":[weakself getUserAgeWithBirthday:userInfo[@"birthday"]],
                                             @"signature":[NSString stringWithFormat:@"%@",myBasicInfo[@"signature"]],
                                             @"gender":[NSString stringWithFormat:@"%@",userInfo[@"gender"]],
                                             @"distance":[weakself getDistanceWithMyLocation:Users[i][@"geoPoint"] otherLocation:_currentLocation]}.mutableCopy;
                if ([[dic objectForKey:@"image"] isEqual:@"(null)"] || ![[dic allKeys] containsObject:@"image"] || [[dic objectForKey:@"image"] isKindOfClass:[NSNull class]] || [dic objectForKey:@"image"] == nil ) {
                    // == 加载替代图片
                }
                if ([[dic objectForKey:@"nickName"] isEqual:@"(null)"] || ![[dic allKeys] containsObject:@"nickName"] || [[dic objectForKey:@"nickName"] isKindOfClass:[NSNull class]] || [dic objectForKey:@"nickName"] == nil ) {
                    [dic setObject:@"(系统:)匿名" forKey:@"nickName"];
                }
                
                if ([[dic objectForKey:@"signature"] isEqual:@"(null)"] || ![[dic allKeys] containsObject:@"signature"] || [[dic objectForKey:@"signature"] isKindOfClass:[NSNull class]] || [dic objectForKey:@"signature"] == nil ) {
                     [dic setObject:@"(系统:)他很神秘，什么都没有留下" forKey:@"signature"];
                }
                if ([[dic objectForKey:@"gender"]  isEqual: @"1"]) {
                    [dic setObject:@"girl" forKey:@"gender"];
                }else{
                    [dic setObject:@"boy" forKey:@"gender"];
                }
                NSLog(@"。。。定位为%@,--对象定位%@",_currentLocation,Users[i][@"geoPoint"]);
                [_userImageDataSoures addObject:dic];
                weakSelf();
                [UIView animateWithDuration:0.5 animations:^{
                    _searchView.alpha = _promptLabel.alpha = _recommendedButton.alpha = 0;
                    weakSelf.container.alpha = _likeButton.alpha = _dislikeButton.alpha = _refreshButton.alpha = 1;
                    //[self refreshAction];
                    [weakSelf.container reloadData];
                    _isSuccess = NO;
                    _isRepeat = NO;
                }];
            }
        }else{
            //NSLog(@"——————————》》》没有进方法");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                UIAlertController *nullUserAlertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"附近没有更多的人了....推荐一下好友吧." preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    _isRepeat = YES;
                    _isSuccess = NO;
                }];
                UIAlertAction *caleceAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                    [weakself shareWechatSession];
                    
                }];
                [nullUserAlertController addAction:sureAction];
                [nullUserAlertController addAction:caleceAction];
                [weakself presentViewController:nullUserAlertController animated:YES completion:nil];
            });
        }
    }];
}

- (void)locationDataSource{
    //== 上传最新位置
    [MResponseUserInfo uploadLocationWithLocation:_currentLocation Completion:^(BOOL success, NSError *error) {

        weakSelf();

        if (_currentLocation != nil) {
            //NSLog(@"-------------->>>>>>>%d",success);
            if (success) {
                //== 通知刷新界面
                [weakSelf addCurrentInfornmation];
            }else {
                //== 定位不成功
                UIAlertController *alerController = [UIAlertController alertControllerWithTitle:@"定位失败" message:@"请检测网络连接是否正常" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    _isRepeat = YES;
                    _isSuccess = NO;
//                    NSLog(@"=====点击了按钮");
                }];
                [alerController addAction:sureAction];
                [weakSelf presentViewController:alerController animated:YES completion:nil];
            }
        }
    }];
}

- (void) initializeLocation{
    if([CLLocationManager locationServicesEnabled] &&
       ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)) {
            _locationManager = [[CLLocationManager alloc] init];
            // 获得用户定位权限
            [_locationManager requestWhenInUseAuthorization];
            _locationManager.delegate = self;
            //定位精确度（不管怎么设置都会多次调用协议）
            _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [_locationManager startUpdatingLocation];
        //====
        //[self locationDataSource];
    }else {
        //提示用户无法进行定位操作
        //NSLog(@"提示用户无法进行定位操作");
        UIAlertController *alerController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请在设置→隐私→开启定位服务才能查找附近人" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            _isRepeat = YES;
        }];
        [alerController addAction:sureAction];
        [self presentViewController:alerController animated:YES completion:nil];
    }
}

- (void) initializeInterface{
    weakSelf();
    self.container = [[LeasDraggableContainer alloc] initWithFrame:CGRectMake(0, 64, LGWidth, LGWidth) style:LeasDraggableStyleUpOverlay];
    self.container.delegate = self;
    self.container.dataSource = self;
    self.container.alpha = 0;
    self.container.backgroundColor = BgColor;
    [self.view addSubview:self.container];
    _likeButton = ({
        UIButton  *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
        button.layer.borderWidth = 2;
        button.alpha = 0;
        button.imageEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15);
        button.layer.cornerRadius = 0.1*SCREEN_WIDTH;
        button.clipsToBounds = YES;
        button.layer.borderColor = MainColor.CGColor;
        [button addTarget:self action:@selector(clickEventWithButton:) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [self.view addSubview:_likeButton];
    [_likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.view).offset(-50);
        make.top.equalTo(weakSelf.container.mas_bottom).offset(10);
        make.width.equalTo(@(0.2*SCREEN_WIDTH));
        make.height.equalTo(@(0.2*SCREEN_WIDTH));
    }];
    _refreshButton = ({
        UIButton  *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
        button.layer.borderWidth = 2;
        button.alpha = 0;
        button.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        button.layer.cornerRadius = 0.05*SCREEN_WIDTH;
        button.clipsToBounds = YES;
        button.layer.borderColor = RGB_COLOR(179, 179, 179, 1).CGColor;
        [button addTarget:self action:@selector(clickEventWithButton:) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [self.view addSubview:_refreshButton];
    [_refreshButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(0.1*SCREEN_WIDTH));
        make.height.equalTo(@(0.1*SCREEN_WIDTH));
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.centerY.equalTo(_likeButton.mas_centerY);
    }];
    _dislikeButton = ({
        UIButton  *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"dislike"] forState:UIControlStateNormal];
        button.layer.borderWidth = 2;
        button.alpha = 0;
        button.imageEdgeInsets = UIEdgeInsetsMake(17, 15, 17, 15);
        button.layer.cornerRadius = 0.1*SCREEN_WIDTH;
        button.clipsToBounds = YES;
        button.layer.borderColor = RGB_COLOR(179, 179, 179, 1).CGColor;
        [button addTarget:self action:@selector(clickEventWithButton:) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [self.view addSubview:_dislikeButton];
    [_dislikeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view).offset(50);
        make.top.equalTo(weakSelf.container.mas_bottom).offset(10);
        make.width.equalTo(@(0.2*SCREEN_WIDTH));
        make.height.equalTo(@(0.2*SCREEN_WIDTH));
    }];
    _searchView = ({
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 64, LGWidth, LGWidth)];
        view.layer.cornerRadius = (SCREEN_WIDTH*0.8)/2;
        view.clipsToBounds = YES;
        view.alpha = 1;
        view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"button"]];
        view;
    });
    [self.view addSubview:_searchView];
    [_searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(64+SCREEN_HEIGHT*0.05);
        make.left.equalTo(weakSelf.view.mas_left).offset(SCREEN_WIDTH*0.1);
        make.width.equalTo(@(SCREEN_WIDTH*0.8));
        make.height.equalTo(_searchView.mas_width);
    }];
    _userHeaderImageView = ({
        UIImageView  *imageView = [[UIImageView alloc]init];
        [imageView setImage:[UIImage imageNamed:@"Mbutton"]];
        imageView.layer.cornerRadius = 25;
        imageView.clipsToBounds = YES;
        imageView;
    });
    [_searchView addSubview:_userHeaderImageView];
    [_userHeaderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@50);
        make.height.equalTo(@50);
        make.centerX.equalTo(_searchView.mas_centerX);
        make.centerY.equalTo(_searchView.mas_centerY);
    }];
    _promptLabel = [[UILabel alloc]init];
    _promptLabel.text = @"黑夜中的你在哪里...";
    _promptLabel.textColor = [UIColor blackColor];
    _promptLabel.alpha = 1;
    _promptLabel.shadowOffset = CGSizeMake(10, 10);
    _promptLabel.textAlignment = NSTextAlignmentCenter;
    _promptLabel.font = [UIFont systemFontOfSize:18];
    //_promptLabel.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:_promptLabel];
    [_promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@200);
        make.height.equalTo(@30);
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(_searchView.mas_bottom).offset(SCREEN_HEIGHT*0.05);
    }];
    _recommendedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _recommendedButton.backgroundColor = MainColor;
    _recommendedButton.alpha = 1;
    [_recommendedButton setTitle:@"⦿ 推荐给身边的好友" forState:UIControlStateNormal];
    [_recommendedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _recommendedButton.layer.cornerRadius = 3;
    _recommendedButton.clipsToBounds = YES;
    [_recommendedButton addTarget:self action:@selector(clickEventWithRecommendedButton:) forControlEvents:UIControlEventTouchUpInside];
    _recommendedButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:_recommendedButton];
    [_recommendedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@150);
        make.height.equalTo(@40);
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(_promptLabel.mas_bottom).offset(SCREEN_HEIGHT*0.05);
    }];
    
    //Mr shen
    self.navigationItem.title = @"黑夜中的你";
    self.navigationController.navigationBar.barTintColor = MainColor;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:nil];
    
    UIBarButtonItem *leftButtonItem = ({
        leftButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Left"] style:UIBarButtonItemStylePlain target:self action:@selector(respondsNavLeftButton:)];
        leftButtonItem.imageInsets = UIEdgeInsetsMake(12, 0, 12, 24);
        leftButtonItem;
    });
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
}

#pragma mark -- Action
/**
 *  侧边栏发过来的通知
 *  Mr shen
 *  @param sender
 */
-(void)jumpNextViewControllerNotification:(NSNotification*)sender{
    int index = (int)[sender.object integerValue];
    switch (index) {
        case 0:{
            //查看及编辑
            //LeasUserSettingViewController *vc = [LeasUserSettingViewController shareLeasUserSettingViewController];
            LeasUserSettingViewController *vc = [LeasUserSettingViewController new];
            [self.navigationController pushViewController:vc animated:YES];
            }
            break;
        case 2:
            //新手指导
            [self.navigationController pushViewController:[[SGuideViewController alloc] init] animated:YES];
            break;
        case 3:
            //设置
            [self.navigationController pushViewController:[[SSetViewController alloc] init] animated:YES];
            
            break;
        case 5:
            //日志
            [self.navigationController pushViewController:[[DiaryViewController alloc]init] animated:YES];
            
            break;
            
        default:
            break;
    }
}



/**
 *  导航条上左侧按钮的监听事件
 *  Mr shen
 *  @param sender
 */
-(void)respondsNavLeftButton:(UIBarButtonItem *)sender{
    //发送通知到根控制器打开侧边栏
    [[NSNotificationCenter defaultCenter]postNotificationName:@"openLeftSide" object:nil];
}

- (void) clickEventWithButton:(UIControl *) sender{
    if (_isAction == YES) {
        return;
    }
    _isAction = YES;
    [self selectAnimationWithButton:sender];
    if (sender == _likeButton) {
        [self.container removeFormDirection:LeasDraggableDirectionRight];
    }else if (sender == _dislikeButton){
        [self.container removeFormDirection:LeasDraggableDirectionLeft];
    }else if (sender == _refreshButton){
        [self afterInitializeLocation];
        
    }
    //== 增加用户体验，提留0.5秒看看彼此
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _isAction = NO;
    });
}

- (void) clickEventWithRecommendedButton:(UIControl *) sender{
    
    //==== 推荐好友
    [self shareWechatSession];
}

- (NSString *) getDistanceWithMyLocation:(AVGeoPoint *) myGeoPoint otherLocation:(CLLocation *) otherLocation {
    // 计算距离
    AVGeoPoint *otherPoint = [AVGeoPoint geoPointWithLocation:otherLocation];
   double kilometer = [myGeoPoint distanceInKilometersTo:otherPoint];
    NSString *metersString = [NSString stringWithFormat:@"%.0f",kilometer*1000];
    return metersString;
}

/**  
 *  计算年龄
 *
 *  @param birthday 出生年月
 *
 *  @return 年龄
 */
- (NSString *) getUserAgeWithBirthday:(NSString *) birthday{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *birthDay = [dateFormatter dateFromString:birthday];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    NSDate *currentDate = [dateFormatter dateFromString:currentDateStr];
    NSTimeInterval time=[currentDate timeIntervalSinceDate:birthDay];
    NSInteger age = ((NSInteger)time)/(3600*24*365);
    NSString *ageString = [NSString stringWithFormat:@"%ld",(long)age];
    return ageString;
}

/**
 *  选择对象，按钮动画效果
 *
 *  @param object 对象
 */
- (void) selectAnimationWithButton:(UIView *) object{
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:200 options:UIViewAnimationOptionCurveEaseOut animations:^{
        object.transform = CGAffineTransformMakeScale(1.25, 1.25);
        [UIView animateWithDuration:0.5 animations:^{
            object.transform = CGAffineTransformMakeScale(1, 1);
        }];
    } completion:^(BOOL finished) {
        
    }];
}

/**
 *  搜索动画
 */
- (void) searchAnmition:(NSTimer *) timer{
    //弱引用
    __weak typeof(UIView *) circleView  = _circleView;
    _circleView = ({
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        view.backgroundColor = [UIColor clearColor];
        view.layer.borderWidth = 2;
        view.layer.borderColor = [UIColor grayColor].CGColor;
        view.layer.cornerRadius = 25;
        view.clipsToBounds = YES;
        view;
    });
    [_searchView addSubview:_circleView];
    [_circleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@50);
        make.height.equalTo(@50);
        make.centerX.equalTo(_searchView.mas_centerX);
        make.centerY.equalTo(_searchView.mas_centerY);
    }];
    [UIView animateWithDuration:10 animations:^{
        circleView.transform = CGAffineTransformMakeScale(10, 10);
        circleView.alpha = 0;
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [circleView removeFromSuperview];
        });
    }];
    
}

#pragma mark -- CCDraggableContainer DataSource

- (LeasDraggableCardView *)draggableContainer:(LeasDraggableContainer *)draggableContainer viewForIndex:(NSInteger)index {
    
    LeasCustomView *cardView = [[LeasCustomView alloc] initWithFrame:draggableContainer.bounds];
    [cardView installData:[_userImageDataSoures objectAtIndex:index]];
    return cardView;
}

- (NSInteger)numberOfIndexs {
    return _userImageDataSoures.count;
}

#pragma mark - CCDraggableContainer Delegate

- (void)draggableContainer:(LeasDraggableContainer *)draggableContainer draggableDirection:(LeasDraggableDirection)draggableDirection widthRatio:(CGFloat)widthRatio heightRatio:(CGFloat)heightRatio {
    
        CGFloat scale = 1 + ((kBoundaryRatio > fabs(widthRatio) ? fabs(widthRatio) : kBoundaryRatio)) / 4;
        if (draggableDirection == LeasDraggableDirectionLeft) {
            self.dislikeButton.transform = CGAffineTransformMakeScale(scale, scale);
        }
        if (draggableDirection == LeasDraggableDirectionRight) {
            self.likeButton.transform = CGAffineTransformMakeScale(scale, scale);
        }
}

- (void)draggableContainer:(LeasDraggableContainer *)draggableContainer cardView:(LeasDraggableCardView *)cardView didSelectIndex:(NSInteger)didSelectIndex {
    

    //关闭window上的主按钮
    [[SFoldawayButton sharSfoldawayButton] removeFromSuperview];
    transitionManager = [[GITransition alloc] init];
    self.transitioningDelegate = transitionManager;
    
    _userDetailVC = [[LeasUserDetailViewController alloc]init];
    _userDetailVC.transitioningDelegate = transitionManager;
    _userDetailVC.modalPresentationStyle = UIModalPresentationCustom;
    _userDetailVC.transitionManager = transitionManager;
    // 拿到对象的信息字典
    _userDetailVC.userInfoDic = _userValues[didSelectIndex];

    [self presentViewController:_userDetailVC animated:YES completion:nil];
}

- (void)selectedCardView:(LeasDraggableCardView *) cardView draggableDirection:(LeasDraggableDirection)draggableDirection didSelectIndex:(NSInteger)didSelectIndex {
    if (draggableDirection == LeasDraggableDirectionLeft ) {
//        NSLog(@"不喜欢%ld",(long)didSelectIndex);
        //===
    }if (draggableDirection == LeasDraggableDirectionRight) {
        //NSLog(@"喜欢%ld",didSelectIndex);
        //检测数组是否包含某个元素。如果没有加载都数组中
        if (![[SCustomSingleton  defaultCustomSingleton].selectedUsersArray containsObject:_userValues[didSelectIndex]]) {
//            [[SCustomSingleton  defaultCustomSingleton].selectedUsersArray  addObject:_userValues[didSelectIndex]];
            
            NSOperation *operation = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(pairFridend) object:nil];
            
            [self.queue addOperation:operation];
            UserInfo *user = [[UserInfo alloc]init];
            user = _userValues[didSelectIndex];
            self.objectId = user.objectId;
            
            
        }
    }
 
}

// 当图片翻完之后调用方法
- (void)draggableContainer:(LeasDraggableContainer *)draggableContainer finishedDraggableLastCard:(BOOL)finishedDraggableLastCard {
    [self afterInitializeLocation];
}

-(void)pairFridend {

    
 [MUserRegister upLikePersonIdWithObjectId:self.objectId LikePersonUpCompletion:^(BOOL success, NSError *error, NSArray *pairArray) {
     [SCustomSingleton  defaultCustomSingleton].selectedUsersArray = pairArray.mutableCopy;

 }];
    
}

#pragma mark -- CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
    //停止更新
    [manager stopUpdatingLocation];
    _currentLocation = [locations lastObject];

    if (_isSuccess == NO) {
        _isSuccess = YES;
        [self locationDataSource];
        
    }
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    //发送通知
    [[NSNotificationCenter defaultCenter]postNotificationName:@"clickBtn" object:nil];
    
}

@end
