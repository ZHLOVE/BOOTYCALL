//
//  SRemindViewController.m
//  BootyCall
//
//  Created by mac on 16/8/24.
//  Copyright © 2016年 dazhongdiy. All rights reserved.
//

#import "SRemindViewController.h"

static NSString *cellId = @"SRemindViewController";

@interface SRemindViewController ()<UITableViewDelegate,UITableViewDataSource>


/**列表*/
@property(nonatomic,strong)UITableView                      *stableView;
/**列表内容*/
@property(nonatomic,strong)NSArray                          *sdataSource;

/**声音与振动状态*/
@property(nonatomic,strong)NSMutableDictionary              *dict;

-(void)initializeDataSource;/**< 初始化数据源 */
-(void)initializeUserInterface;/**< 初始化用户界面 */

@end

@implementation SRemindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeDataSource];
    [self initializeUserInterface];
}

#pragma mark - ******* Initialize *******

-(void)initializeDataSource{
    _sdataSource = @[@"声音",@"振动"];
    _dict = [@{}mutableCopy];
}

-(void)initializeUserInterface{
    self.navigationItem.title = @"新消息提醒";
    [self.view addSubview:self.stableView];
}

#pragma mark - ******* Events *******

-(void)respondsToSoundBtn:(UISwitch*)sender{
    [_dict setObject:[NSString stringWithFormat:@"%d",sender.on] forKey:@"soundStatus"];
    [[NSUserDefaults standardUserDefaults] setObject:_dict forKey:@"msgRemind"];
}

-(void)respondsToJarBtn:(UISwitch*)sender{
    [_dict setObject:[NSString stringWithFormat:@"%d",sender.on] forKey:@"jarStatus"];
    [[NSUserDefaults standardUserDefaults] setObject:_dict forKey:@"msgRemind"];

}



#pragma mark - ******* Delegate *******

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _sdataSource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    cell.textLabel.text = _sdataSource[indexPath.row];
    if (indexPath.row == 0) {
        UISwitch *soundBtn = [[UISwitch alloc] initWithFrame:CGRectZero];
        soundBtn.onTintColor = MainColor;
        [soundBtn addTarget:self action:@selector(respondsToSoundBtn:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = soundBtn;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else if(indexPath.row == 1){
        UISwitch *jarBtn = [[UISwitch alloc] initWithFrame:CGRectZero];
        jarBtn.onTintColor = MainColor;
        [jarBtn addTarget:self action:@selector(respondsToJarBtn:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = jarBtn;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

#pragma mark - ******* Getters *******


-(UITableView *)stableView{
    if (!_stableView) {
        _stableView = ({
            UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
            tableView.backgroundColor = [UIColor whiteColor];
            tableView.delegate = self;
            tableView.dataSource = self;
            [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellId];
            tableView.rowHeight = 50; //55
            tableView.separatorColor = [UIColor grayColor];
            tableView.bounces = NO;
            tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 15);
            UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 164)];
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH , 0.6)];
            lineView.backgroundColor = [UIColor grayColor];
            [footerView addSubview:lineView];
            footerView.backgroundColor = [UIColor whiteColor];
            tableView.tableFooterView = footerView;
            tableView;
        });
    }
    return _stableView;
}


@end
