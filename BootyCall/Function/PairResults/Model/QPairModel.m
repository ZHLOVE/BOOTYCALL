//
//  QPairModel.m
//  BootyCall
//
//  Created by rimi on 16/8/13.
//  Copyright © 2016年 dazhongdiy. All rights reserved.
//

#import "QPairModel.h"
#import "MResponseUserInfo.h"
@implementation QPairModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {


}
- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}
+(void)getPairModelArrayByGender:(NSString *)gender Kilometers:(CGFloat)Kilometer comlete:(PairBlock)complete {


  __block  NSArray *userInfo = @[];
  [MResponseUserInfo responseNearUserInfoWithGender:gender Kilometers:Kilometer ResponseCompletion:^(BOOL success, NSError *error, NSArray *Users) {

      
   userInfo =  [self changeDicToPairModelArray:Users];
      complete(userInfo);
      
  }];


}

+(NSMutableArray *)changeDicToPairModelArray:(NSArray *)datasource{

    NSMutableArray *result = @[].mutableCopy;
    for (NSInteger i = 0; i<datasource.count; i++) {
        QPairModel *model = [[QPairModel alloc]init];
        NSDictionary *dic = datasource[i];
        [model setValue:dic[@"gender"] forKey:@"gender"];
        [model setValue:dic[@"headImageUrl"] forKey:@"headImageUrl"];
        [model setValue:dic[@"signature"] forKey:@"signature"];
        [model setValue:dic[@"userId"] forKey:@"userId"];
        [model setValue:dic[@"name"] forKey:@"name"];
        [result addObject:model];
    }
    return result;

}

@end
