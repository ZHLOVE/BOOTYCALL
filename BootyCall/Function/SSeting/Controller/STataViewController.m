//
//  STataViewController.m
//  BootyCall
//
//  Created by mac on 16/8/14.
//  Copyright © 2016年 dazhongdiy. All rights reserved.
//

#import "STataViewController.h"
#import "SAttributeView.h"
#import "UIView+SFrame.h"



@interface STataViewController ()<SAttributeViewDelegate>

{
    NSString *JLStr;
    NSString *HYStr;
    NSString *screeningStr;
    BOOL     isScreening;
}


/**背景视图*/
@property (nonatomic ,weak  )UIScrollView    *scrollView;
/**距离*/
@property (nonatomic ,strong)SAttributeView  *attributeViewJL;
/**行业*/
@property (nonatomic ,strong)SAttributeView  *attributeViewHY;
/**筛选结果标签*/
@property (nonatomic ,strong)UILabel         *screeningLabel;
/**筛选结果*/
@property (nonatomic ,strong)NSMutableArray  *screeningDict;


-(void)initializeDataSource;/**< 初始化数据源 */
-(void)initializeUserInterface;/**< 初始化用户界面 */

@end

@implementation STataViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeDataSource];
    [self initializeUserInterface];
    
}

#pragma mark - ******* Initialize *******

-(void)initializeDataSource{
    _screeningDict = [@{}mutableCopy];
    JLStr = @"";
    HYStr = @"";
    [_screeningDict setValue:JLStr forKey:@"industry"];
    [_screeningDict setValue:JLStr forKey:@"distance"];
}


-(void)initializeUserInterface{
    [self.navigationItem setTitle:@"心目中的他(她)"];
    [self addSubView];

    
    UIBarButtonItem *rightButtonItem = ({
        rightButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(respondsToRightButtonItem:)];
        rightButtonItem.imageInsets = UIEdgeInsetsMake(8, 16, 8, 0);
        rightButtonItem;
    });
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
}

#pragma mark - ******* Methods *******
-(void)addSubView{
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    scrollView.backgroundColor = BgColor;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    // 创建距离属性视图
    NSArray *dataJl = [JL componentsSeparatedByString:@" "];
    SAttributeView *attributeViewJL  = [SAttributeView attributeViewWithTitle:[NSString stringWithFormat:@"%@距离我？",SPACING] titleFont:[UIFont systemFontOfSize:16.f] attributeTexts:dataJl viewWidth:SCREEN_WIDTH btnBgColor:BgColor];
    self.attributeViewJL= attributeViewJL;
    attributeViewJL.y = 0;
    [scrollView addSubview:self.attributeViewJL];
    // 设置代理
    attributeViewJL.sAttribute_delegate = self;
    
    // 创建行业属性视图
    NSArray *dataHY = [SCHY componentsSeparatedByString:@" "];
    SAttributeView *attributeViewHY  = [SAttributeView attributeViewWithTitle:[NSString stringWithFormat:@"%@所处行业？",SPACING] titleFont:[UIFont systemFontOfSize:16.f] attributeTexts:dataHY viewWidth:SCREEN_WIDTH btnBgColor:BgColor];
    self.attributeViewHY= attributeViewHY;
    attributeViewHY.y = CGRectGetMaxY(self.attributeViewJL.frame);
    [scrollView addSubview:self.attributeViewHY];
    // 设置代理
    attributeViewHY.sAttribute_delegate = self;
    // 筛选结果
    UILabel *sxLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.attributeViewHY.frame), SCREEN_WIDTH, 40)];
    sxLabel.backgroundColor = BgColor;
    sxLabel.font = [UIFont systemFontOfSize:16.f];
    sxLabel.text = [NSString stringWithFormat:@"%@我的筛选条件是：",SPACING];
    sxLabel.textColor = [UIColor grayColor];
    [scrollView addSubview:sxLabel];
    
    _screeningLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(sxLabel.frame), SCREEN_WIDTH - 24, 64)];
    _screeningLabel.backgroundColor = [UIColor whiteColor];
    _screeningLabel.layer.cornerRadius = 3.f;
    _screeningLabel.layer.masksToBounds = YES;
    _screeningLabel.numberOfLines = 0;
    _screeningLabel.textColor = [UIColor blackColor];
    _screeningLabel.font = [UIFont systemFontOfSize:14.f];
    [scrollView addSubview:_screeningLabel];
    scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(_screeningLabel.frame) + 50);
    
    
}

#pragma mark - ******* Events *******

-(void)respondsToRightButtonItem:(UIBarButtonItem*)sender{
    if (isScreening) {
        return;
    }
    isScreening = YES;
    if ((JLStr.length == 0) && (HYStr.length == 0)) {
        [UIAlertController showAlertWithTitle:@"温馨提示" message:@"请选择你要筛选的条件!" target:self];
        isScreening = NO;
        return;
    }
    [self showProgressHUD:self.view hint:@"正在筛选" hide:@"筛选完成"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removePorgressHud];
        isScreening = NO;
    });
    [UIView animateWithDuration:0.35 animations:^{
        self.scrollView.contentOffset = CGPointMake(0, -64);
    }];
    self.scrollView.scrollsToTop = YES;
    [[NSUserDefaults standardUserDefaults]setObject:_screeningDict forKey:@"screeningDict"];
}


#pragma mark - ******* delegate *******

/**
 *  自定义属性视图的上button得点击事件
 *
 *  @param view 属性视图
 *  @param btn  按钮
 */
- (void)sAttribute_View:(SAttributeView *)view didClickBtn:(UIButton *)btn{
    // 判断, 根据点击不同的attributeView上的标签, 执行不同的代码
    NSString *title = btn.titleLabel.text;
    if (!btn.selected) {
        title = @"";
    }
    if([view isEqual:self.attributeViewJL]){
        JLStr = title;
        [_screeningDict setValue:JLStr forKey:@"distance"];
    }else if([view isEqual:self.attributeViewHY]){
        HYStr = title;
        [_screeningDict setValue:HYStr forKey:@"industry"];
    }
    //配置筛选结果
    if (JLStr.length != 0) {
        screeningStr = [NSString stringWithFormat:@"距离我：%@%@",JLStr,SPACING];
    }
    if(HYStr.length != 0){
        screeningStr = [NSString stringWithFormat:@"所处行业：%@%@",HYStr,SPACING];
    }
    if ((JLStr.length != 0) && (HYStr.length != 0) ){
       screeningStr = [NSString stringWithFormat:@"距离我：%@%@ 所处行业：%@",JLStr,SPACING,HYStr];
    }
    _screeningLabel.text = screeningStr;
    
}


@end
