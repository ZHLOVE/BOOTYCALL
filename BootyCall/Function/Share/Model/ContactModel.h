//
//  ContactModel.h
//  BootyCall
//
//  Created by rimi on 16/8/26.
//  Copyright © 2016年 dazhongdiy. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^ContactBlock)(NSArray *array);

@interface ContactModel : NSObject

/**
 *  性别
 */
@property(nonatomic,strong)NSString  *gender;
/**
 *  头像
 */
@property(nonatomic,strong)NSString *headImageUrl;
/**
 *  签名
 */
@property(nonatomic,strong)NSString *signature;
/**
 *  Id
 */
@property(nonatomic,strong)NSString  *userId;
/**
 *  姓名
 */
@property(nonatomic,strong)NSString *name;

+(void)getModelOfContactCompletehandle:(ContactBlock)completehandle;

+(NSMutableArray *)changeArrayToModel:(NSArray *)data ;



@end
