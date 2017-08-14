//
//  SShareViewController.m
//  BootyCall
//
//  Created by mac on 16/8/10.
//  Copyright © 2016年 dazhongdiy. All rights reserved.
//

#import "SShareViewController.h"
#import "BMChineseSort.h"
#import "ContactModel.h"
#import "ContactTableViewCell.h"
#import "ChatViewController.h"
@interface SShareViewController ()<UITableViewDelegate,UITableViewDataSource>
/**
 *   联系人表格视图
 */
@property(nonatomic,strong)UITableView *tableView;
/**
 *  练习人数组
 */
@property(nonatomic,strong)NSMutableArray *contactArray;
/**
 *  右侧索引数组
 */
@property(nonatomic,strong)NSMutableArray *rightIndex;
/**
 *  排序结果 数组
 */
@property(nonatomic,strong)NSMutableArray *sortResultArray;
/**
 *  删除队列
 */
@property(nonatomic,strong)NSOperationQueue *deleteQueue;
/**
 *  请求数组
 */
@property(nonatomic,strong)NSMutableArray *requestArr;
/**
 *  model
 */
@property(nonatomic,strong)ContactModel *deleteModel;






@end

@implementation SShareViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(initalizeDataSource)];
    header.automaticallyChangeAlpha = YES;
    [header beginRefreshing];
    self.tableView.mj_header = header;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeInterface];
    self.deleteQueue  = [[NSOperationQueue alloc]init];
//    [self initalizeDataSource];

}
- (void) initializeInterface{
    self.view.backgroundColor = BgColor;
    self.navigationItem.title = @"联系人";
    self.navigationController.navigationBar.barTintColor = MainColor;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:nil];
    
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"sback"] style:UIBarButtonItemStylePlain target:self action:@selector(respondsToLeftButtonItem)];
    leftButtonItem.imageInsets = UIEdgeInsetsMake(5, -10, 2, 17);
    self.navigationItem.leftBarButtonItems = @[leftButtonItem];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    [self.view addSubview:self.tableView];
    
}


-(void)initalizeDataSource {
    weakSelf();
    self.contactArray = @[].mutableCopy;
    self.sortResultArray = @[].mutableCopy;
    self.rightIndex = @[].mutableCopy;
    self.requestArr = @[].mutableCopy;
    [MResponseUserInfo  loadPairPersonArray:^(BOOL success, NSError *error, NSArray *pairPersonArr) {
        if (success) {
            if (pairPersonArr.count == 0) {
                [UIAlertController showAlertWithTitle:@"亲" message:@"还没有好友哟~~~~"];
                [weakSelf.tableView.mj_header endRefreshing];
            }else {
            [weakSelf.requestArr addObjectsFromArray:pairPersonArr];
            [weakSelf.contactArray addObjectsFromArray:[ContactModel changeArrayToModel:pairPersonArr]];
            weakSelf.rightIndex = [BMChineseSort IndexWithArray:weakSelf.contactArray Key:@"name"];
            weakSelf.sortResultArray = [BMChineseSort sortObjectArray:weakSelf.contactArray Key:@"name"];
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView reloadData];
            }
        }else {
            [UIAlertController showAlertWithTitle:@"提示" message:@"请求数据失败"];
            [weakSelf.tableView.mj_header endRefreshing];
        
        }
        
    }];
    
//    [ContactModel getModelOfContactCompletehandle:^(NSArray *array) {
//        [weakSelf.contactArray addObjectsFromArray:array];
//        weakSelf.rightIndex = [BMChineseSort IndexWithArray:weakSelf.contactArray Key:@"name"];
//        weakSelf.sortResultArray = [BMChineseSort sortObjectArray:weakSelf.contactArray Key:@"name"];
//        [weakSelf.tableView.mj_header endRefreshing];
//        [weakSelf.tableView reloadData];
//    }];
}
#pragma mark - Method
-(void)respondsToLeftButtonItem{
    //发送通知到
    [[NSNotificationCenter defaultCenter]postNotificationName:@"showingCurrenController" object:@"0"];
}

-(void)deleteContact {
    weakSelf();
    for (NSInteger i = 0; i<self.requestArr.count; i++) {
        NSDictionary *dic = self.requestArr[i];
        if ([dic[@"name"] isEqualToString:self.deleteModel.name]) {
            [self.requestArr removeObjectAtIndex:i];
            break;
        }
    }
    
    [MUserRegister upPairArrayWithNewPairArray:self.requestArr UpCompletion:^(BOOL success, NSError *error) {
        if (success) {
            
        }else {
            [UIAlertController showAlertWithTitle:@"提示" message:@"删除失败"];
            [weakSelf.tableView reloadData];
        
        }
    }];


}


#pragma mark - UITableViewDateSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    

    return [self.sortResultArray[section] count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.rightIndex.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contactcell" forIndexPath:indexPath];
    ContactModel *model = self.sortResultArray[indexPath.section][indexPath.row];
    
    cell.model = model; 
    return cell;
}
#pragma mark - UITableViewDelegate

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {

return @"删除";
    
    
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        self.sortResultArray removeObjectAtIndex:indexPath.se
        NSMutableArray *delete = [self.sortResultArray[indexPath.section] mutableCopy];
        [delete removeObjectAtIndex:indexPath.row];
        self.deleteModel = self.sortResultArray[indexPath.section][indexPath.row];
        
        if (delete.count ==0) {
            
            [self.rightIndex removeObjectAtIndex:indexPath.section];
             [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        }else {
            [self.sortResultArray replaceObjectAtIndex:indexPath.section withObject:delete];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        
        
        NSOperation *deleteOparation = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(deleteContact) object:nil];
        [self.deleteQueue addOperation:deleteOparation];
        
    }

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    ContactTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    ContactModel *model = self.sortResultArray[indexPath.section][indexPath.row];
    ChatViewController *chat = [[ChatViewController alloc]initWithConversationChatter:model.userId conversationType:eConversationTypeChat];
    chat.title = model.name;
    [self.navigationController pushViewController:chat animated:YES];
    
}
//显示右侧索引
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {

    return self.rightIndex;
}
//显示头部视图
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    return self.rightIndex[section];
}
//点击索引
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {

    return index;
}
#pragma mark - Getter
- (UITableView *)tableView {

    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.rowHeight = 70;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[ContactTableViewCell class] forCellReuseIdentifier:@"contactcell"];
        
    }
    return _tableView;
    
}


@end
