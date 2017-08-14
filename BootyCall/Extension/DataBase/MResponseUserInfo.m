//
//  MResponseUserInfo.m
//  BootyCall
//
//  Created by rimi on 16/8/12.
//  Copyright © 2016年 dazhongdiy. All rights reserved.
//

#import "MResponseUserInfo.h"

@implementation MResponseUserInfo
/**
 *  返回用户个人信息
 *
 *  @param completion 回调
 */
+ (void)responseCurrentUserInfo:(ResponseUserCompletion)completion{
    AVQuery *query = [UserInfo query];
    [query whereKey:@"objectId" equalTo:[AVUser currentUser][@"userInfoId"]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if ((objects.count == 0) || (objects == nil)) {
                NSDictionary *myInfo = @{@"nickName":@"黑夜中的你",@"birthday":@"",@"gender":@"0",@"age":@""};
                completion(YES,nil,@{@"myInfo":myInfo});
                return ;
            }else{
                NSDictionary *dict = objects[0];
                completion(YES,nil,dict);
            }
        }else{
            completion(NO,error,nil);
        }
    }];
}
/**
 *  返回个人信息
 *
 *  @param userInfoId 用户id
 *  @param completion 回调
 */
+ (void)responseUserInfoWithId:(NSString *)userInfoId ResponseUserCompletion:(ResponseUserCompletion)completion{
    AVQuery *query = [UserInfo query];
    [query whereKey:@"objectId" equalTo:userInfoId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSDictionary *dict = objects[0];
            completion(YES,nil,dict);
        }else{
            completion(NO,error,nil);
        }
    }];
}
/**
 *  返回附近的人
 *
 *  @param gender     性别 - "0/1/2"
 *  @param kilometers 范围 - "Km"
 *  @param completion 回调
 */
+ (void)responseNearUserInfoWithGender:(NSString *)gender Kilometers:(double)kilometers ResponseCompletion:(ResponseCompletion)completion{
    
    UserInfo *userInfo = [UserInfo objectWithObjectId:[AVUser currentUser][@"userInfoId"]];
    [userInfo fetchInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        if (!error) {
            AVQuery *query = [UserInfo query];
            [query whereKey:@"geoPoint"  nearGeoPoint:userInfo.geoPoint withinKilometers:kilometers];
            
            //[query selectKeys:@[@"title", @"content"]];
            NSMutableArray *users = [NSMutableArray array];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    
                    if (gender != nil) {
                        for (NSInteger index = 0; index < objects.count; index ++) {
                            if ([objects[index][@"myInfo"][@"gender"] isEqualToString:gender]) {
                                [users addObject:objects[index]];
                            }
                        }
                        completion(YES,nil,users);
                    }else{
                        completion(YES,nil,objects);
                    }
                }else{
                    completion(NO,error,nil);
                }
            }];
        }else{
            completion(NO,error,nil);
        }
    }];
}
/**
 *  更新位置
 *
 *  @param location   经纬度
 
 *  @param completion 回调
 */
+ (void)uploadLocationWithLocation:(CLLocation *)location Completion:(Completion)completion{
    UserInfo *userInfo = [UserInfo objectWithObjectId:[AVUser currentUser][@"userInfoId"]];
    [userInfo fetchInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        if (!error) {
            userInfo.geoPoint = [AVGeoPoint geoPointWithLocation:location];
            //userInfo.geoPoint = (AVGeoPoint *) location;
            [userInfo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    completion(YES,nil);
                }else{
                    completion(NO,error);
                }
            }];
        }else{
            completion(NO,error);

        }
    }];
    
}
/**
 *  返回头像url
 *
 *  @param completion 回调
 */
+ (void)loadHeadImageUrlCompletion:(HeadImageCompletion)completion{
    UserInfo *userInfo = [UserInfo objectWithObjectId:[AVUser currentUser][@"userInfoId"]];
    [userInfo fetchInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        if (!error) {
            completion(YES,object[@"headImageUrl"],object[@"myInfo"][@"nickName"],nil);
        }else{
            completion (NO,nil,nil,error);
        }
    }];
}
/**
 *  返回文件data数据
 *
 *  @param contentUrl 文件url
 *  @param completion 回调
 */
+ (void)loadContentWithUrl:(NSString *)contentUrl ContentUrlCompletion:(ContentUrlCompletion)completion{
    AVFile *content = [AVFile fileWithURL:contentUrl];
    [content getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            completion(YES,data,nil);
        }else{
            completion(NO,nil,error);
        }
    }];
}

+ (void)loadPairPersonArray:(PairPersonLoadCompletion)completion{
    AVQuery *query = [UserInfo query];
    [query whereKey:@"objectId" equalTo:[AVUser currentUser][@"userInfoId"]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSDictionary *dict = objects[0];
            NSArray *pairArr = [NSArray arrayWithArray:dict[@"pairSuccessArray"]];
            completion(YES,nil,pairArr);
            
        }else{
            completion(NO,error,nil);
        }
    }];
}






@end
