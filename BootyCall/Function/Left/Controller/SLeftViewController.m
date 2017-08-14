
//
//  SLeftViewController.m
//  BootyCall
//
//  Created by mac on 16/8/10.
//  Copyright © 2016年 dazhongdiy. All rights reserved.
//

#import "SLeftViewController.h"
#import "SSetViewController.h"
#import "SGuideViewController.h"
#import "SHomeViewController.h"
#import "SLeftTabViewCell.h"
#import "SLabelView.h"



static NSString *stableViewCellId = @"SLeftViewController-1";

@interface SLeftViewController ()<UITableViewDelegate,UITableViewDataSource>

/**模糊背景*/
@property(nonatomic,strong)UIImageView                      *sfuzzyImageView;
/**头像*/
@property(nonatomic,strong)UIImageView                      *sheadImageView;
/**昵称*/
@property(nonatomic,strong)SLabelView                       *snicknameLabel;
/**点击查看或编辑*/
@property(nonatomic,strong)UILabel                          *scheckOrEditLabel;
/**用于添加点击手势*/
@property(nonatomic,strong)UIView                           *sclickEditView;
/**功能列表*/
@property(nonatomic,strong)UITableView                      *stableView;
/**功能列表数据源*/
@property(nonatomic,strong)NSArray                          *sDataSource;
/**stableView的高度*/
@property(nonatomic,assign)CGFloat                          stableViewHeight;
/**头像*/
@property(nonatomic,strong)UIImage                          *sheadImage;



-(void)initializeDataSource;/**< 初始化数据源 */
-(void)initializeUserInterface;/**< 初始化用户界面 */
@end

@implementation SLeftViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changHeadImageNotification:) name:@"changHeadImage" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changNickNameNotification:) name:@"changNickName" object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeDataSource];
    [self initializeUserInterface];

}

#pragma mark - ******* Initialize *******

-(void)initializeDataSource{
    _sDataSource = @[@[@"hyzdn",@"黑夜中的你"],@[@"xx",@"消息"],@[@"xszd",@"新手指导"],@[@"sz",@"设置"],@[@"fx",@"分享到朋友圈"],@[@"xamyu",@"喜在眉宇"]];
    NSDictionary *myInfo =[[NSUserDefaults standardUserDefaults]objectForKey:@"currentUserInfo"];
    if (myInfo) {
        NSString *nickNameStr = myInfo[@"nickName"];
        //更改昵称标签
        if(nickNameStr.length < 6){
            nickNameStr = [NSString stringWithFormat:@"黑夜中的-%@",nickNameStr];
        }
        self.snicknameLabel.text = nickNameStr;
    }
    [MResponseUserInfo responseCurrentUserInfo:^(BOOL success, NSError *error, NSDictionary *currentUserInfo) {
        if (success) {
            //头像
            NSLog(@"%@",currentUserInfo);
            _sheadImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:currentUserInfo[@"headImageUrl"]]]];
            self.sheadImageView.image = _sheadImage;
            //昵称
            NSString *nickNameStr = currentUserInfo[@"myInfo"][@"nickName"];
            //更改昵称标签
            if(nickNameStr.length < 6){
                nickNameStr = [NSString stringWithFormat:@"黑夜中的-%@",nickNameStr];
            }
            self.snicknameLabel.text = nickNameStr;
        }
    }];


}

-(void)initializeUserInterface{
    //加载子视图
    [self addSubViews];
    //添加子视图约束
    [self masMakeConstraints];
    
}

#pragma mark - ******* Methods *******

-(void)addSubViews{
    //加载模糊背景
    [self setFuzzyBgImageView:self.sfuzzyImageView];
    //加载头像
    [self.view addSubview:self.sheadImageView];
    //加载昵称标签
    [self.view addSubview:self.snicknameLabel];
    //加载点击查看/编辑标签
    [self.view addSubview:self.scheckOrEditLabel];
    //加载查看/编辑点击手势
    [self.view addSubview:self.sclickEditView];
    //加载功能列表
    [self.view addSubview:self.stableView];
}

-(void)masMakeConstraints{
    weakSelf();
    //头像约束
    [_sheadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@100);
        make.height.equalTo(_sheadImageView.mas_width);
        make.top.equalTo(weakSelf.view.mas_top).offset(30);
        make.right.equalTo(weakSelf.view.mas_right).offset(- ((SCREEN_WIDTH / 2.0 + 80) - 100) / 2.0);
    }];
    //昵称约束
    [_snicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(80));
        make.height.equalTo(@30);
        make.right.equalTo(weakSelf.view.mas_right).offset(-((SCREEN_WIDTH / 2.0 + 80) - 80) / 2.0);
        make.top.equalTo(_sheadImageView.mas_bottom).offset(10);
    }];
    //点击查看/编辑约束
    [_scheckOrEditLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(120));
        make.height.equalTo(@24);
        make.right.equalTo(weakSelf.view.mas_right).offset(-((SCREEN_WIDTH / 2.0 + 80) - 120) / 2.0);
        make.top.equalTo(_snicknameLabel.mas_bottom).offset(10);
    }];
    //查看/编辑点击手势约束
    [_sclickEditView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_sheadImageView.mas_top).offset(-5);
        make.width.equalTo(@((SCREEN_WIDTH / 2 + 80) - 120));
        make.right.equalTo(weakSelf.view.mas_right).offset(-60);
        make.bottom.equalTo(_scheckOrEditLabel.mas_bottom).offset(5);
    }];
    //功能列表约束
    [_stableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_scheckOrEditLabel.mas_bottom).offset(25);
        make.width.equalTo(@(SCREEN_WIDTH / 2.0 + 80));
        make.right.equalTo(weakSelf.view.mas_right);
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-20);
    }];
}

/**
 *  条跳转到对应的控制器
 *
 *  @param index 被选中的cell的图标
 */

-(void)sjumpToNextViewController:(int)sindex{
    //首先需要将侧边栏收回
    //if(sindex != 4){
        [[NSNotificationCenter defaultCenter]postNotificationName:@"closeLeftSide" object:self.snicknameLabel];
    //}
    //如果点击到的是"黑夜中的你"，"消息" 跳转到对应的并且已经存在的控制器
    if (sindex == 0 || sindex == 1) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"showingCurrenController" object:[NSString stringWithFormat:@"%d",sindex]];
    }else{
        //找homeVc跳转控制器
        [[NSNotificationCenter defaultCenter]postNotificationName:@"nextViewController" object:[NSString stringWithFormat:@"%d",sindex]userInfo:nil];
    }
    if(sindex == 4){
        [self shareWechatTimeline];
    }
}





#pragma mark - ******* Events *******
/**
 *  单击手势
 *
 *  @param gesture
 */
-(void)respondsToSclickEditView:(UIGestureRecognizer*)gesture{
    if (gesture.state == UIGestureRecognizerStateEnded) {
        //首先需要将侧边栏收回
        [[NSNotificationCenter defaultCenter]postNotificationName:@"closeLeftSide" object:self.snicknameLabel];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"nextViewController" object:[NSString stringWithFormat:@"%d",0]];
    }
}

-(void)viewDidLayoutSubviews{
    _stableViewHeight = self.stableView.bounds.size.height;
}
/**
 *  个人信息编辑页发送过来的通知，改变头像
 *
 *  @param sender
 */
-(void)changHeadImageNotification:(NSNotification*)sender{
    self.sheadImageView.image = sender.object;
    self.sfuzzyImageView.image = sender.object;
}

/**
 *  个人信息修改页发过来的通知，改变昵称
 *
 *  @param sender
 */
-(void)changNickNameNotification:(NSNotification *)sender{
    
    NSString *nickNameStr = sender.object;
    //更改昵称标签
    if(nickNameStr.length < 6){
        nickNameStr = [NSString stringWithFormat:@"黑夜中的-%@",nickNameStr];
    }
    self.snicknameLabel.text = nickNameStr;
}



#pragma mark - ******* UITableViewDelegate,UITableViewDataSource *******

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _sDataSource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SLeftTabViewCell *cell = [tableView dequeueReusableCellWithIdentifier:stableViewCellId forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row % 2 == 0) {
        cell.backgroundColor = RGB_COLOR(43, 55, 70, 0.4);
    }
    cell.models = _sDataSource[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self sjumpToNextViewController:(int)indexPath.row];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _stableViewHeight / [_sDataSource count];
}



#pragma mark - ******* Getters *******

-(UITableView *)stableView{
    if (!_stableView) {
        _stableView = ({
            UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
            tableView.backgroundColor = [UIColor clearColor];
            tableView.delegate = self;
            tableView.dataSource = self;
            tableView.separatorColor = [UIColor clearColor];
            tableView.bounces = NO;
            [tableView registerClass:[SLeftTabViewCell class] forCellReuseIdentifier:stableViewCellId];
            tableView;
        });
    }
    return _stableView;
}

-(UIView *)sclickEditView{
    if (!_sclickEditView) {
        _sclickEditView = ({
            UIView *view = [[UIView alloc]init];
            view.backgroundColor = [UIColor clearColor];
            UITapGestureRecognizer *closeTapLeftGeture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(respondsToSclickEditView:)];
            [view addGestureRecognizer:closeTapLeftGeture];
            view;
        });
    }
    return _sclickEditView;
}

-(UILabel *)scheckOrEditLabel{
    if (!_scheckOrEditLabel) {
        _scheckOrEditLabel = ({
            UILabel *label = [[UILabel alloc]init];
            label.numberOfLines = 1.f;
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:16.f];
            label.text = [NSString stringWithFormat:@"⦿点击查看/编辑"];
            label.layer.cornerRadius = 3.f;
            label.layer.masksToBounds = YES;
            label.textAlignment = NSTextAlignmentCenter;
            label.backgroundColor = MainColor;
            label;
        });
    }
    return _scheckOrEditLabel;

}

-(SLabelView *)snicknameLabel{
    if (!_snicknameLabel) {
        _snicknameLabel = ({
            SLabelView *label = [[SLabelView alloc]initWithFrame:CGRectMake(0,0,80,30)];
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:18.f];
            label.text = @"黑夜中的XXXXXX黑夜中的";
            label.speed = 2.0f;
            label.backgroundColor = [UIColor clearColor];
            [self.view addSubview:label];
            label;
        });
   }
    return _snicknameLabel;
}

-(UIImageView *)sheadImageView{
    if (!_sheadImageView) {
        _sheadImageView = ({
            UIImageView *imageView = [[UIImageView alloc]init];
            imageView.userInteractionEnabled = YES;
            imageView.layer.cornerRadius = 50.f;
            imageView.layer.masksToBounds = YES;
            imageView.layer.borderColor = MainColor.CGColor;
            imageView.image =_sheadImage;
            imageView.layer.borderWidth = 1.f;
            imageView;
        });
    }
    return _sheadImageView;
}

-(UIImageView *)sfuzzyImageView{
    if (!_sfuzzyImageView) {
        _sfuzzyImageView = ({
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.view.frame];
            imageView.userInteractionEnabled = YES;
            imageView.image = _sheadImage;
            imageView;
        });
    }
    return _sfuzzyImageView;
}







@end











