//
//  SSetViewController.m
//  BootyCall
//
//  Created by mac on 16/8/11.
//  Copyright © 2016年 dazhongdiy. All rights reserved.
//

#import "SSetViewController.h"
#import "SSetTabViewCell.h"
#import "SSelfInfoViewConroller.h"
#import "STataViewController.h"
#import "SRemindViewController.h"
#import "GITransition.h"
#import "SFoldawayButton.h"
#import "SZzzLViewController.h"


static NSString *stableViewCellId = @"SSetViewController";

@interface SSetViewController ()<UITableViewDelegate,UITableViewDataSource>

{
    NSString *_snickName;
}

/**列表*/
@property(nonatomic,strong)UITableView                      *stableView;
/**列表数据源*/
@property(nonatomic,strong)NSMutableArray                   *sdataSource;
/**头部视图的标题*/
@property(nonatomic,strong)NSArray                          *sheadViewTitles;

@property(nonatomic,strong)SSetTabViewCell                  *selectedCell;


-(void)initializeDataSource;/**< 初始化数据源 */
-(void)initializeUserInterface;/**< 初始化用户界面 */

@end

@implementation SSetViewController


-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (instancetype)init
{
    self = [super init];
    if (self) {
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
    _sdataSource = [@[]mutableCopy];
     NSDictionary *myInfo =[[NSUserDefaults standardUserDefaults]objectForKey:@"currentUserInfo"];
    if (myInfo) {
        _snickName = myInfo[@"nickName"];
    }
    //异常处理
    else{
        _snickName = @"黑夜中的你";
    }
    NSArray *sdataSource = @[@[@[@"xyzdt",_snickName],@[@"xmzdt",@"心目中的TA"]],
                             @[@[@"clear",[NSString stringWithFormat:@"清理缓存%@-%@%@",SPACING,SPACING,[NSString stringWithFormat:@"%.1fM",[self filePath]]]],@[@"slL",@"省流量模式"]],
                            @[@[@"yshtz",@"新消息提醒"],@[@"zzzn",@"帮助与反馈"]]];
    _sdataSource = [NSMutableArray arrayWithArray:sdataSource];
    _sheadViewTitles = @[@"个人信息设置",@"性能与流量",@"其他"];
    
}

-(void)initializeUserInterface{
    self.navigationItem.title = @"设置";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:nil];
    //加载子视图
    [self addSubViews];
    //[self loadDataSource];
}

#pragma mark - ******* Methods *******

-(void)addSubViews{
    //加载stableView
    [self.view addSubview:self.stableView];
}


//*********************清理缓存********************//
// 显示缓存大小
-( float )filePath
{
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    
    return [ self folderSizeAtPath :cachPath];
    
}
//首先我们计算一下 单个文件的大小

- ( long long ) fileSizeAtPath:( NSString *) filePath{
    
    NSFileManager * manager = [ NSFileManager defaultManager ];
    
    if ([manager fileExistsAtPath :filePath]){
        
        return [[manager attributesOfItemAtPath :filePath error : nil ] fileSize ];
    }
    
    return 0 ;
    
}
//遍历文件夹获得文件夹大小，返回多少 M（提示：你可以在工程界设置（)m）
- ( float ) folderSizeAtPath:( NSString *) folderPath{
    NSFileManager * manager = [ NSFileManager defaultManager ];
    if (![manager fileExistsAtPath :folderPath]) return 0 ;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath :folderPath] objectEnumerator ];
    NSString * fileName;
    long long folderSize = 0 ;
    while ((fileName = [childFilesEnumerator nextObject ]) != nil ){
        NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent :fileName];
        folderSize += [ self fileSizeAtPath :fileAbsolutePath];
    }
    return folderSize/( 1024.0 * 1024.0 );
}
// 清理缓存
- (void)clearFile
{
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    NSArray * files = [[ NSFileManager defaultManager ] subpathsAtPath :cachPath];
    //NSLog ( @"cachpath = %@" , cachPath);
    for ( NSString * p in files) {
        NSError * error = nil ;
        NSString * path = [cachPath stringByAppendingPathComponent :p];
        if ([[ NSFileManager defaultManager ] fileExistsAtPath :path]) {
            [[ NSFileManager defaultManager ] removeItemAtPath :path error :&error];
        }
    }
    [ self performSelectorOnMainThread : @selector (clearCachSuccess) withObject : nil waitUntilDone : YES ];
}

- (void)clearCachSuccess
{
    _sdataSource[1] = @[@[@"clear",[NSString stringWithFormat:@"清理缓存%@-%@%@",SPACING,SPACING,[NSString stringWithFormat:@"%.1fM",[self filePath]]]],@[@"slL",@"省流量模式"]];
    /*
    NSIndexPath *index=[NSIndexPath indexPathForRow:0 inSection:1];//刷新指定行
    [self.stableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:index,nil] withRowAnimation:UITableViewRowAnimationNone];
     */
    [self.stableView reloadData];
}

#pragma mark - ******* Events *******

-(void)changNickNameNotification:(NSNotification*)sender{
    if (!sender.object ) {
        return;
    }
    _sdataSource[0] = @[@[@"xyzdt",sender.object],@[@"xmzdt",@"心目中的TA"]];

    [self.stableView reloadData];
}

/**r
 *  列表上清除按钮的点击事件
 *
 *  @param sender 清除按钮
 */

-(void)respondsToClearBtn:(UISwitch *)sender{
    if(sender.on){
        [self showsHint:@"开启成功" yOffset:-SCREEN_HEIGHT * 0.5];//256
    }
}
/**
 *  列表的响应事件
 *
 *  @param indexPath indexPath
 */
-(void)respondingToTheCorrespondingRowsAndSecitons:(NSIndexPath *)indexPath{
    //清理缓存
    if (indexPath.section == 1 && indexPath.row == 0) {
        [self clearFile];
        [self showsHint:@"清除成功" yOffset:-SCREEN_HEIGHT * 0.5];//256
    }
    //昵称
    else if(indexPath.section == 0 && indexPath.row == 0){
        [self.navigationController pushViewController:[SSelfInfoViewConroller new] animated:YES];
    }
    //心目中的他（她）
    else if(indexPath.section == 0 && indexPath.row == 1){
        [self.navigationController pushViewController:[STataViewController new] animated:YES];
    }
    //新消息提醒
    else if(indexPath.section == 2 && indexPath.row == 0){
         [self.navigationController pushViewController:[SRemindViewController new] animated:YES];
    }
    //帮助与反馈
    else if(indexPath.section == 2 && indexPath.row == 1){
        //隐藏window上的按钮
        [[SFoldawayButton sharSfoldawayButton] removeFromSuperview];
        GITransition *transitionManager = [[GITransition alloc] init];
        self.transitioningDelegate = transitionManager;
        SZzzLViewController *vc  = [[SZzzLViewController alloc]init];
        vc.transitioningDelegate = transitionManager;
        vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
        vc.transitionManager = transitionManager;
        [self presentViewController:vc animated:YES completion:nil];
    }

}
- (CGRect)buttonFrame{
    return CGRectMake((414 - 100) / 2.0, self.view.frame.size.height / 2, 100, 100);
}

/**
 *  底部退出按钮得点击事件
 *
 *  @param sender 退出按钮
 */
-(void)respondsToExitButton:(UIButton *)sender{
    [AVUser logOut];
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:NO completion:^(NSDictionary *info, EMError *error) {
        if (!error) {
            NSLog(@"退出成功");
        }
    } onQueue:nil];
    
    [[NSUserDefaults standardUserDefaults]setObject:@[] forKey:@"imageDataArr"];
    
    //环信登出
    MLoginViewController *loginVC = [[MLoginViewController alloc]init];
    [self presentViewController:loginVC animated:YES completion:^{
        MLoginViewController *loginVC = [[MLoginViewController alloc]init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginVC];
        nav.navigationBarHidden = YES;
        [UIApplication sharedApplication].keyWindow.rootViewController = nav;
    }];
}



#pragma mark - ******* UITableViewDelegate,UITableViewDataSource *******

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _sdataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_sdataSource[section] count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SSetTabViewCell *cell = [tableView dequeueReusableCellWithIdentifier:stableViewCellId];
    cell.models = _sdataSource[indexPath.section][indexPath.row];
    if (indexPath.row == 1 && indexPath.section == 1) {
        UISwitch *clearBtn = [[UISwitch alloc] initWithFrame:CGRectZero];
        clearBtn.onTintColor = MainColor;
        [clearBtn addTarget:self action:@selector(respondsToClearBtn:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = clearBtn;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else if(indexPath.row == 0 && indexPath.section == 1){
        cell.accessoryType = UITableViewCellAccessoryNone;
    }else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    _selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    //响应对应的行和列
    [self respondingToTheCorrespondingRowsAndSecitons:indexPath];
    _selectedCell.selected = NO;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50.f;
}

//构建HeaderInSection视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"Header"];
    if (!view) {
        view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        view.backgroundColor = RGB_COLOR(235, 240, 242, 1.0);
    }
    UILabel *sclassL = [[UILabel alloc]initWithFrame:CGRectMake(20, 15, SCREEN_WIDTH - 20, 30)];
    sclassL.backgroundColor = [UIColor clearColor];
    sclassL.textColor = [UIColor grayColor];
    sclassL.font = [UIFont systemFontOfSize:13.f];
    sclassL.text = _sheadViewTitles[section];
    [view addSubview:sclassL];
    return view;
}
#pragma mark - ******* Getters *******

-(UITableView *)stableView{
    if (!_stableView) {
        _stableView = ({
            UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
            tableView.backgroundColor = [UIColor whiteColor];
            tableView.delegate = self;
            tableView.dataSource = self;
            tableView.rowHeight = SCREEN_HEIGHT * 0.1; //55
            tableView.separatorColor = [UIColor grayColor];
            
            [tableView registerClass:[SSetTabViewCell class] forCellReuseIdentifier:stableViewCellId];
            tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 15);
            UIView *footerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
            footerview.backgroundColor = RGB_COLOR(235, 240, 242, 1.0);
            //分割线
            UIView *dividerView = [[UIView alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 10, 0.5)];
            dividerView.backgroundColor = [UIColor grayColor];
    
            //退出按钮
            UIButton *exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
            exitButton.backgroundColor = [UIColor clearColor];
            [exitButton addTarget:self action:@selector(respondsToExitButton:) forControlEvents:UIControlEventTouchUpInside];
            exitButton.frame = CGRectMake(50, 30, SCREEN_WIDTH - 100, 44);
            exitButton.layer.cornerRadius = 6.f;
            exitButton.layer.masksToBounds = YES;
            exitButton.layer.borderColor = MainColor.CGColor;
            exitButton.layer.borderWidth = 1.f;
            [exitButton setTitle:@"退出登录" forState:UIControlStateNormal];
            [exitButton setTitleColor:MainColor forState:UIControlStateNormal];
            [footerview addSubview:exitButton];
            //版本标签
            UILabel *versionLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(exitButton.frame) + 20, SCREEN_WIDTH, 30)];
            versionLabel.text = [NSString stringWithFormat:@"版本1.0"];
            versionLabel.textColor = [UIColor grayColor];
            versionLabel.backgroundColor = [UIColor clearColor];
            versionLabel.textAlignment = NSTextAlignmentCenter;
            versionLabel.font = [UIFont systemFontOfSize:12.f];
            [footerview addSubview:versionLabel];
            tableView.tableFooterView = footerview;
            tableView;
        });
    }
    return _stableView;
}




@end
