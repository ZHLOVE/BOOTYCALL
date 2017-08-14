//
//  SGuideViewController.m
//  BootyCall
//
//  Created by mac on 16/8/11.
//  Copyright © 2016年 dazhongdiy. All rights reserved.
//

#import "SGuideViewController.h"
#import "UIScrollView+StwitterCover.h"
#import "SBaseViewController.h"
#import "SGuideDetailViewController.h"


static NSString *stableViewCellId = @"SLeftViewController-1";

@interface SGuideViewController ()<UITableViewDelegate,UITableViewDataSource>

{
    UIView *topView;
}

/**列表*/
@property(nonatomic,strong)UITableView                      *stableView;
/**列表数据源*/
@property(nonatomic,strong)NSArray                          *sdataSource;

-(void)initializeDataSource;/**< 初始化数据源 */
-(void)initializeUserInterface;/**< 初始化用户界面 */


@end


@implementation SGuideViewController

- (void)dealloc
{
    [self.stableView removeTwitterCoverView];
}

- (id)initWithTopView:(UIView*)view
{
    self = [super init];
    if (self) {
        topView = view;
        
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
    _sdataSource = @[[NSString stringWithFormat:@"%@怎么使用？",APPNAME],@"怎样实现附近搜索？",@"该APP到底有何用处？",@"怎么修改个人资料?",@"怎样让别人了解我，我要怎样才能获取到对方信息？",@"聊天没人理，是怎么回事？",@"各个页面的详细介绍"];
}

-(void)initializeUserInterface{
    self.navigationItem.title = @"新手指导";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    //加载子视图
    [self addSubViews];
    
}




#pragma mark - ******* Methods *******

-(void)addSubViews{
    //加载列表视图
    [self.view addSubview:self.stableView];
    //加载列表的头部视图
    [self.stableView addTwitterCoverWithImage:[UIImage imageNamed:@"cover"] withTopView:topView];
    //去除topView的高度，使其tableView的cell贴紧显示
    self.stableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CHTwitterCoverViewHeight + topView.bounds.size.height)];
}



#pragma mark - ******* <#Events#> *******



#pragma mark - ******* Delegate *******

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sdataSource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:stableViewCellId];
    if (indexPath.row %2 == 0) {
        cell.textLabel.text = [NSString stringWithFormat:@"⦿%@%@",SPACING,_sdataSource[indexPath.row]];
    }else{
        cell.textLabel.text = _sdataSource[indexPath.row];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SGuideDetailViewController *vc = [[SGuideDetailViewController alloc]init];
    vc.index = indexPath.row;
    vc.stitleStr = _sdataSource[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - ******* Getters *******

-(UITableView *)stableView{
    if (!_stableView) {
        _stableView = ({
            UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
            tableView.delegate = self;
            tableView.dataSource = self;
            tableView.rowHeight = 70.f;
            tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 15);
            tableView.separatorColor = [UIColor grayColor];
            [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:stableViewCellId];
            tableView;
        });
    }
    return _stableView;
}




@end
