//
//  MResponseUserInfo.h
//  BootyCall
//
//  Created by rimi on 16/8/12.
//  Copyright © 2016年 dazhongdiy. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^ResponseUserCompletion)(BOOL success,NSError *error,NSDictionary *currentUserInfo);
typedef void(^ResponseCompletion)(BOOL success,NSError *error,NSArray *Users);
typedef void(^Completion)(BOOL success,NSError *error);
typedef void(^HeadImageCompletion)(BOOL success,NSString *headImageUrl,NSString *nickName,NSError *error);
typedef void(^ContentUrlCompletion)(BOOL success,NSData *data,NSError *error);
typedef void(^PairPersonLoadCompletion)(BOOL success,NSError *error,NSArray *pairPersonArr);

@interface MResponseUserInfo : NSObject
/**
 *  返回用户个人信息
 *
 *  @param completion 回调
 */
+ (void)responseCurrentUserInfo:(ResponseUserCompletion)completion;


/**
 *  返回个人信息
 *
 *  @param userInfoId 用户id
 *  @param completion 回调
 */
+ (void)responseUserInfoWithId:(NSString *)userInfoId
        ResponseUserCompletion:(ResponseUserCompletion)completion;


/**
 *  返回附近的人
 *
 *  @param gender     性别 - "0/1/2"
 *  @param kilometers 范围 - "Km"
 *  @param completion 回调
 */
+ (void)responseNearUserInfoWithGender:(NSString *)gender
                            Kilometers:(double)kilometers
                    ResponseCompletion:(ResponseCompletion)completion;


/**
 *  更新位置
 *
 *  @param location   经纬度
 
 *  @param completion 回调
 */
+ (void)uploadLocationWithLocation:(CLLocation *)location
                        Completion:(Completion)completion;
/**
 *  返回头像url
 *
 *  @param completion 回调
 */
+ (void)loadHeadImageUrlCompletion:(HeadImageCompletion)completion;
/**
 *  返回文件data数据
 *
 *  @param contentUrl 文件url
 *  @param completion 回调
 */
+ (void)loadContentWithUrl:(NSString *)contentUrl
      ContentUrlCompletion:(ContentUrlCompletion)completion;

/**
 *  获取配对的人列表
 *
 *  @param completion 回调
 */
+ (void)loadPairPersonArray:(PairPersonLoadCompletion)completion;

@end
