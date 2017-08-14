//
//  DiaryViewController.m
//  BootyCall
//
//  Created by rimi on 16/8/20.
//  Copyright © 2016年 dazhongdiy. All rights reserved.
//

#import "DiaryViewController.h"
#import "DiaryTableViewCell.h"
#import "DiaryModel.h"
#import "NSString+base64.h"
#import "QShowDiaryViewController.h"

@interface DiaryViewController ()<UITableViewDelegate,UITableViewDataSource>
/**
 *  日志数组
 */
@property(nonatomic,strong)NSMutableArray *diaryArr;
/**
 *  日志表格
 */
@property(nonatomic,strong)UITableView *diaryTableView;
/**
 *
 */
@property(nonatomic,strong)NSMutableArray *dataSource;
/**
 *  队列
 */
@property(nonatomic,strong)NSOperationQueue *deleteQueue;



@end

@implementation DiaryViewController

-(void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
        


}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.diaryTableView];
    self.diaryArr = @[].mutableCopy;
    self.dataSource = @[].mutableCopy;
    self.deleteQueue = [[NSOperationQueue alloc]init];
    self.title = @"喜在眉宇";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
 
}

-(void)intializeDataSource {

    [self.diaryArr removeAllObjects];
    [self.dataSource removeAllObjects];
    weakSelf();
    
    UserInfo *userInfo = [UserInfo objectWithObjectId:[AVUser currentUser][@"userInfoId"]];
    [userInfo fetchInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        if (!error) {
            
            [weakSelf.dataSource addObjectsFromArray:object[@"diaryInfo"]];
            
            [weakSelf.diaryArr addObjectsFromArray:[DiaryModel changeDataToModel:weakSelf.dataSource]];
            
            
            if (_diaryArr.count == 0) {
                [UIAlertController showAlertWithTitle:@"亲爱的" message:@"你还没写过日志哟"];
            }
            [weakSelf.diaryTableView.mj_header endRefreshing];
            [weakSelf.diaryTableView reloadData];
   
        }
    }];
    
//    [DiaryModel getmodelOfDiaryCompleteHandle:^(NSArray *object, NSError *error) {
//        weakSelf();
//      if (!error) {
//          
//       
//          [weakSelf.diaryArr addObjectsFromArray:object];
//          if (weakSelf.diaryArr.count == 0) {
//              
//              [UIAlertController showAlertWithTitle:@"亲爱的" message:@"暂时没有写日志哟"];
//          }else {
//          
//          dispatch_async(dispatch_get_main_queue(), ^{
//            [self.diaryTableView reloadData]; 
//          });
//
//        }
//          [weakSelf.diaryTableView.mj_header endRefreshing];
//          
//        
//          
//      }else {
//          [UIAlertController showAlertWithTitle:@"提示" message:error.localizedDescription];
////          [UIAlertController showAlertWithTitle:@"提示" message:err];
////          NSLog(@"%@",error.localizedDescription);
//          [weakSelf.diaryTableView.mj_header endRefreshing];
//      
//      }
//     
//  }];

}

#pragma mark - Mehtod 

-(void)deleteDiary {

[MUserRegister upDiaryArrayWithArray:self.dataSource UpCompletion:^(BOOL success, NSError *error) {
   
    if (success) {
        
    }else {
        [UIAlertController showAlertWithTitle:@"温馨提示" message:@"删除失败"];
    
    }
}];

}

-(void)makeRefresh {

     [self intializeDataSource];

}
- (NSString *)textFromBase64String:(NSString *)base64 {
    
    NSData *data = [[NSData alloc]initWithBase64EncodedString:base64 options:0];
    NSString *text = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
//    NSData *data = [[NSData alloc] initWithBase64EncodedString:base64options:0];
//    
//    NSString *text = [[NSString alloc] initWithData:dataencoding:NSUTF8StringEncoding];
    
    
    return text;
    
}




#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.diaryArr.count;
//    return 20;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    DiaryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Qdiarycell" forIndexPath:indexPath];
    DiaryModel *model = self.diaryArr[indexPath.row];
    cell.model = model;
    
    
    
    
    return cell;

}
#pragma mark - tableviewDelegate

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {

return @"删除";

}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [_diaryArr removeObjectAtIndex:indexPath.row];
        [_dataSource removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        NSOperation *operation = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(deleteDiary) object:nil];
        [self.deleteQueue addOperation: operation];
        
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DiaryModel *model = self.diaryArr[indexPath.row];
    
    QShowDiaryViewController *show = [[QShowDiaryViewController alloc]init];
    show.model = model;
    [self.navigationController pushViewController:show animated:YES];
//    [MResponseUserInfo loadContentWithUrl:model.url ContentUrlCompletion:^(BOOL success, NSData *data, NSError *error) {
//       NSLog(@"->>>>>  %@",data);
//    NSDictionary * rtf = [NSDictionary dictionaryWithObject:NSRTFDTextDocumentType forKey:NSDocumentTypeDocumentAttribute];
//        
//        NSAttributedString *str = [[NSAttributedString alloc]initWithData:data options:rtf documentAttributes:nil error:nil];
//        NSLog(@"->>>>>%@",str);
//        
//    }];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //设置Cell的动画效果为3D效果
    //设置sx和sy的初始值为0.1,sz的值为1；
    cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1);
    //x和y的最终值为1
    [UIView animateWithDuration:1 animations:^{
        cell.layer.transform = CATransform3DMakeScale(1, 1, 1);
    }];
}


- (UITableView *)diaryTableView {

    if (_diaryTableView == nil) {
        _diaryTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _diaryTableView.delegate = self;
        _diaryTableView.dataSource = self;
        _diaryTableView.rowHeight = 70;
        _diaryTableView.backgroundColor = BgColor;
        _diaryTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_diaryTableView registerClass:[DiaryTableViewCell class] forCellReuseIdentifier:@"Qdiarycell"];
        
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(makeRefresh)];
        header.automaticallyChangeAlpha = YES;
        [header beginRefreshing];
        self.diaryTableView.mj_header = header;
        
        
    }
    return _diaryTableView;

}








@end
