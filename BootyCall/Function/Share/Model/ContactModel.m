//
//  ContactModel.m
//  BootyCall
//
//  Created by rimi on 16/8/26.
//  Copyright © 2016年 dazhongdiy. All rights reserved.
//

#import "ContactModel.h"

@implementation ContactModel


-(void)setValue:(id)value forUndefinedKey:(NSString *)key {


}

+(void)getModelOfContactCompletehandle:(ContactBlock)completehandle {
    [MResponseUserInfo  loadPairPersonArray:^(BOOL success, NSError *error, NSArray *pairPersonArr) {
        NSMutableArray *result = @[].mutableCopy;
        
        result = [self changeArrayToModel:pairPersonArr];
        completehandle(result);
        
        
    }];



}

+(NSMutableArray *)changeArrayToModel:(NSArray *)data {
    NSMutableArray *dataSource = @[].mutableCopy;
    
    for (NSInteger i =0; i<data.count; i++) {
        
        NSDictionary *dic = data[i];
        ContactModel *model = [[ContactModel alloc]init];
        [model setValuesForKeysWithDictionary:dic];
        [dataSource addObject:model];
        
    }
    return dataSource;



}



@end
