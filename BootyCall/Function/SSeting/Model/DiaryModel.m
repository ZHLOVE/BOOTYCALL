//
//  DiaryModel.m
//  BootyCall
//
//  Created by rimi on 16/8/20.
//  Copyright © 2016年 dazhongdiy. All rights reserved.
//

#import "DiaryModel.h"

@implementation DiaryModel


-(void)setValue:(id)value forUndefinedKey:(NSString *)key {



}

+ (void)getmodelOfDiaryCompleteHandle:(ComoleteHandle)completehandle {

 
    UserInfo *userInfo = [UserInfo objectWithObjectId:[AVUser currentUser][@"userInfoId"]];
    [userInfo fetchInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        if (!error) {
      
//            NSLog(@"%@",object);
            completehandle([self changeDataToModel:object[@"diaryInfo"]],nil);
            
     
        }else {
            completehandle(nil,error);
        
        }
    }];
    

}


+(NSMutableArray *)changeDataToModel:(NSArray *)dataSource {

    NSMutableArray *modelArr = @[].mutableCopy;
    
    for (NSInteger i = 0; i< dataSource.count; i++) {
        DiaryModel *model = [[DiaryModel alloc]init];
        NSDictionary *dic = dataSource[i];
        [model setValuesForKeysWithDictionary:dic];
        [modelArr addObject:model];
    }
    return modelArr;
    

}
@end
