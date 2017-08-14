//
//  QPairModel.h
//  BootyCall
//
//  Created by rimi on 16/8/13.
//  Copyright © 2016年 dazhongdiy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^PairBlock)(NSArray *array);

@interface QPairModel : NSObject

/**
 *  兴趣爱好
 */
@property(nonatomic,strong)NSString   *signature;
/**
 *  用户信息
 */
@property(nonatomic,strong)NSString   *name;
/**
 *  图片
 */
@property(nonatomic,strong)NSString *headImageUrl;

/**
 *  用户ID
 */
@property(nonatomic,strong)NSString  *userId;
/**
 *  性别
 */
@property(nonatomic,strong)NSString *gender;




/**
 *  搜索结果数组
 */
@property(nonatomic,strong)NSMutableArray *QPairDatasource;

+(void)getPairModelArrayByGender:(NSString *)gender Kilometers:(CGFloat)Kilometer comlete:(PairBlock)complete;

+(NSMutableArray *)changeDicToPairModelArray:(NSArray *)datasource;


@end
