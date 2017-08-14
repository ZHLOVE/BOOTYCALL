//
//  MUserRegister+UserRegisterInfo.m
//  BootyCall
//
//  Created by rimi on 16/8/12.
//  Copyright © 2016年 dazhongdiy. All rights reserved.
//

#import "MUserRegister+UserRegisterInfo.h"

@implementation MUserRegister (UserRegisterInfo)
/**
 *  上传我的信息
 *
 *  @param imagePath      头像路径
 *  @param albumArray     相册
 *  @param signature      个性签名
 *  @param height         身高
 *  @param industryArray  所处行业
 *  @param characterArray 个人性格
 *  @param defectArray    个人缺点
 *  @param hobbyArray     兴趣爱好
 *  @param completion     回调
 */
+ (void)upDateWithUserHeadImagePath:(NSData *)imagePath AlbumArray:(NSArray *)albumArray Signature:(NSString *)signature Height:(NSString *)height IndustryArray:(NSArray *)industryArray CharacterArray:(NSArray *)characterArray DefectArray:(NSArray *)defectArray HobbyArray:(NSArray *)hobbyArray UpDataCompletion:(UpDataCompletion)completion{
    
    UserInfo *userInfo = [UserInfo objectWithObjectId:[AVUser currentUser][@"userInfoId"]];
    [userInfo fetchInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        if (!error) {
            if (albumArray.count == 0) {
                [self updateWithUserInfo:userInfo HeadImagePath:imagePath Signature:signature Height:height IndustryArray:industryArray CharacterArray:characterArray DefectArray:defectArray HobbyArray:hobbyArray UpDataCompletion:^(BOOL success, NSError *error, UserInfo *userInfo) {
                    if (success) {
                        completion(YES,nil,userInfo);
                    }else{
                        completion(NO,error,nil);
                    }
                }];
                return;
            }
            __block NSMutableArray *imagePathArr = [NSMutableArray array];
            __block NSInteger num = 0;
            [self upUserAlbumWithImagePath:albumArray ImageUpCompletion:^(BOOL success, NSError *error, NSString *imageUrl) {
                if (success) {
                    [imagePathArr addObject:imageUrl];
                    ++ num;
                    if (num == albumArray.count && albumArray.count != 0 ) {
                        if (imagePath == nil || imagePath.length == 0) {
                            userInfo.albumArray = imagePathArr;
                            if (signature.length == 0 && height.length == 0) {
//                                NSDictionary *dict = [NSDictionary dictionary];
                                
                                NSDictionary *basicInfo =  (NSDictionary *)userInfo.myBasicInfo;
                                NSDictionary *myBasicInfo = @{@"signature":basicInfo[@"signature"],@"height":basicInfo[@"height"]};
                                userInfo.myBasicInfo = myBasicInfo;
                            }else if (signature.length == 0 && height.length > 0){
                                NSDictionary *basicInfo =  (NSDictionary *)userInfo.myBasicInfo;
                                NSDictionary *myBasicInfo = @{@"signature":basicInfo[@"signature"],@"height":height};
                                userInfo.myBasicInfo = myBasicInfo;
                            }else if (height.length == 0 && signature.length > 0){
                                NSDictionary *basicInfo =  (NSDictionary *)userInfo.myBasicInfo;
                                NSDictionary *myBasicInfo = @{@"signature":signature,@"height":basicInfo[@"height"]};
                                userInfo.myBasicInfo = myBasicInfo;
                            }else{
                                NSDictionary *myBasicInfo = @{@"signature":signature,@"height":height};
                                userInfo.myBasicInfo = myBasicInfo;
                            }
                            (industryArray == nil)?(userInfo.industryArray =userInfo.industryArray):(userInfo.industryArray = industryArray);
                            (characterArray == nil)?(userInfo.characterArray =userInfo.characterArray):(userInfo.characterArray = characterArray);
                            (defectArray == nil)?(userInfo.defectArray =userInfo.defectArray):(userInfo.defectArray = defectArray);
                            (hobbyArray == nil)?(userInfo.hobbyArray =userInfo.hobbyArray):(userInfo.hobbyArray = hobbyArray);
//                            userInfo.characterArray = characterArray;
//                            userInfo.defectArray = defectArray;
//                            userInfo.hobbyArray = hobbyArray;
                            [userInfo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                if (succeeded) {
                                    completion(YES,nil,userInfo);
                                }else{
                                    
                                    completion(NO,error,nil);
                                }
                            }];
                            return;
                        }
                        AVFile *avatar = [AVFile fileWithName:@"headImage" data:imagePath];
                        [avatar saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            if (succeeded) {
                                NSString *headurlStr = [NSString stringWithFormat:@"%@",avatar.url];
                                userInfo.headImageUrl = headurlStr;
                                userInfo.albumArray = imagePathArr;
//                                NSDictionary *myBasicInfo = @{@"signature":signature,@"height":height};
//                                userInfo.myBasicInfo = myBasicInfo;
//                                userInfo.industryArray = industryArray;
//                                userInfo.characterArray = characterArray;
//                                userInfo.defectArray = defectArray;
//                                userInfo.hobbyArray = hobbyArray;
                                if (signature == nil && height== nil) {
                                    NSDictionary *basicInfo =  (NSDictionary *)userInfo.myBasicInfo;
                                    NSDictionary *myBasicInfo = @{@"signature":basicInfo[@"signature"],@"height":basicInfo[@"height"]};
                                    userInfo.myBasicInfo = myBasicInfo;
                                }else if (signature == nil && height.length > 0){
                                    NSDictionary *basicInfo =  (NSDictionary *)userInfo.myBasicInfo;
                                    NSDictionary *myBasicInfo = @{@"signature":basicInfo[@"signature"],@"height":height};
                                    userInfo.myBasicInfo = myBasicInfo;
                                }else if (height == nil&& signature.length > 0){
                                    NSDictionary *basicInfo =  (NSDictionary *)userInfo.myBasicInfo;
                                    NSDictionary *myBasicInfo = @{@"signature":signature,@"height":basicInfo[@"height"]};
                                    userInfo.myBasicInfo = myBasicInfo;
                                }else{
                                    NSDictionary *myBasicInfo = @{@"signature":signature,@"height":height};
                                    userInfo.myBasicInfo = myBasicInfo;
                                }
                                (industryArray == nil)?(userInfo.industryArray =userInfo.industryArray):(userInfo.industryArray = industryArray);
                                (characterArray == nil)?(userInfo.characterArray =userInfo.characterArray):(userInfo.characterArray = characterArray);
                                (defectArray == nil)?(userInfo.defectArray =userInfo.defectArray):(userInfo.defectArray = defectArray);
                                (hobbyArray == nil)?(userInfo.hobbyArray =userInfo.hobbyArray):(userInfo.hobbyArray = hobbyArray);
                                [userInfo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                    if (succeeded) {
                                        completion(YES,nil,userInfo);
                                    }else{
                                        
                                        completion(NO,error,nil);
                                    }
                                }];
                            }else{
                                completion(NO,error,nil);
                            }
                        }];
                        
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

+ (void)updateWithUserInfo:(UserInfo *)userInfo HeadImagePath:(NSData *)imagePath Signature:(NSString *)signature Height:(NSString *)height IndustryArray:(NSArray *)industryArray CharacterArray:(NSArray *)characterArray DefectArray:(NSArray *)defectArray HobbyArray:(NSArray *)hobbyArray UpDataCompletion:(UpDataCompletion)completion{
    if (imagePath == nil || imagePath.length == 0) {
        [self upOtherDateWithUserInfo:userInfo Signature:signature Height:height IndustryArray:industryArray CharacterArray:characterArray DefectArray:defectArray HobbyArray:hobbyArray UpDataCompletion:^(BOOL success, NSError *error, UserInfo *userInfo) {
            if (success) {
                completion(YES,nil,userInfo);
            }else{
                completion(NO,error,nil);
            }
        }];
        return;
    }
    AVFile *avatar = [AVFile fileWithName:@"headImage" data:imagePath];
    [avatar saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSString *headurlStr = [NSString stringWithFormat:@"%@",avatar.url];
            userInfo.headImageUrl = headurlStr;
//            [userInfo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//                if (succeeded) {
                    //userInfo.headImageUrl = headurlStr;
//                    NSDictionary *myBasicInfo = @{@"signature":signature,@"height":height};
//                    userInfo.myBasicInfo = myBasicInfo;
//                    userInfo.industryArray = industryArray;
//                    userInfo.characterArray = characterArray;
//                    userInfo.defectArray = defectArray;
//                    userInfo.hobbyArray = hobbyArray;
            if (signature.length == 0 && height.length == 0) {
                NSDictionary *basicInfo =  (NSDictionary *)userInfo.myBasicInfo;
                NSDictionary *myBasicInfo = @{@"signature":basicInfo[@"signature"],@"height":basicInfo[@"height"]};
                userInfo.myBasicInfo = myBasicInfo;
            }else if (signature.length == 0 && height.length > 0){
                NSDictionary *basicInfo =  (NSDictionary *)userInfo.myBasicInfo;
                NSDictionary *myBasicInfo = @{@"signature":basicInfo[@"signature"],@"height":height};
                userInfo.myBasicInfo = myBasicInfo;
            }else if (height.length == 0 && signature.length > 0){
                NSDictionary *basicInfo =  (NSDictionary *)userInfo.myBasicInfo;
                NSDictionary *myBasicInfo = @{@"signature":signature,@"height":basicInfo[@"height"]};
                userInfo.myBasicInfo = myBasicInfo;
            }else{
                NSDictionary *myBasicInfo = @{@"signature":signature,@"height":height};
                userInfo.myBasicInfo = myBasicInfo;
            }
            (industryArray == nil)?(userInfo.industryArray =userInfo.industryArray):(userInfo.industryArray = industryArray);
            (characterArray == nil)?(userInfo.characterArray =userInfo.characterArray):(userInfo.characterArray = characterArray);
            (defectArray == nil)?(userInfo.defectArray =userInfo.defectArray):(userInfo.defectArray = defectArray);
            (hobbyArray == nil)?(userInfo.hobbyArray =userInfo.hobbyArray):(userInfo.hobbyArray = hobbyArray);
                    [userInfo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (succeeded) {
                            completion(YES,nil,userInfo);
                        }else{
                            completion(NO,error,nil);
                        }
                    }];
                }else{
                    completion(NO,error,nil);
                }
            }];
//        }else{
//            completion(NO,error,nil);
//        }
//    }];
}

+ (void)upOtherDateWithUserInfo:(UserInfo *)userInfo Signature:(NSString *)signature Height:(NSString *)height IndustryArray:(NSArray *)industryArray CharacterArray:(NSArray *)characterArray DefectArray:(NSArray *)defectArray HobbyArray:(NSArray *)hobbyArray UpDataCompletion:(UpDataCompletion)completion{
    
    
    
//    [userInfo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        if (succeeded) {
//            NSDictionary *myBasicInfo = @{@"signature":signature,@"height":height};
//            userInfo.myBasicInfo = myBasicInfo;
//            userInfo.industryArray = industryArray;
//            userInfo.characterArray = characterArray;
//            userInfo.defectArray = defectArray;
//            userInfo.hobbyArray = hobbyArray;
    if (signature.length == 0 && height.length == 0) {
        NSDictionary *basicInfo =  (NSDictionary *)userInfo.myBasicInfo;
        NSDictionary *myBasicInfo = @{@"signature":basicInfo[@"signature"],@"height":basicInfo[@"height"]};
        userInfo.myBasicInfo = myBasicInfo;
    }else if (signature.length == 0 && height.length > 0){
        NSDictionary *basicInfo =  (NSDictionary *)userInfo.myBasicInfo;
        NSDictionary *myBasicInfo = @{@"signature":basicInfo[@"signature"],@"height":height};
        userInfo.myBasicInfo = myBasicInfo;
    }else if (height.length == 0 && signature.length > 0){
        NSDictionary *basicInfo =  (NSDictionary *)userInfo.myBasicInfo;
        NSDictionary *myBasicInfo = @{@"signature":signature,@"height":basicInfo[@"height"]};
        userInfo.myBasicInfo = myBasicInfo;
    }else{
        NSDictionary *myBasicInfo = @{@"signature":signature,@"height":height};
        userInfo.myBasicInfo = myBasicInfo;
    }
    (industryArray == nil)?(userInfo.industryArray =userInfo.industryArray):(userInfo.industryArray = industryArray);
    (characterArray == nil)?(userInfo.characterArray =userInfo.characterArray):(userInfo.characterArray = characterArray);
    (defectArray == nil)?(userInfo.defectArray =userInfo.defectArray):(userInfo.defectArray = defectArray);
    (hobbyArray == nil)?(userInfo.hobbyArray =userInfo.hobbyArray):(userInfo.hobbyArray = hobbyArray);
            [userInfo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    completion(YES,nil,userInfo);
                }else{
                    completion(NO,error,nil);
                }
            }];
//        }else{
//            completion(NO,error,nil);
//        }
//    }];
}
/**
 *  注册上传资料
 *
 *  @param imagePath  头像路径
 *  @param nickName   昵称
 *  @param birthday   生日
 *  @param gender     性别
 *  @param completion 回调
 */
+ (void)upUserRegisterInfoWithImagePath:(NSData *)imagePath NickName:(NSString *)nickName Birthday:(NSString *)birthday Gender:(NSString *)gender                                 Age:(NSString *)age UpDataCompletion:(UpDataCompletion)completion{
    
    UserInfo *userInfo = [UserInfo objectWithObjectId:[AVUser currentUser][@"userInfoId"]];
    [userInfo fetchInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        if (!error) {
            if (imagePath == nil || imagePath.length == 0) {
                NSDictionary *myInfo = @{@"nickName":nickName,@"birthday":birthday,@"gender":gender,@"age":age};
                userInfo.myInfo = myInfo;
                userInfo.myBasicInfo = @{@"signature":@"暂无描述",@"height":@"保密"};
                [userInfo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        completion(YES,nil,userInfo);
                    }else{
                        completion(NO,error,nil);
                    }
                }];
                return;
            }
            AVFile *avatar = [AVFile fileWithName:@"headImage" data:imagePath];
            [avatar saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    NSString *urlStr = [NSString stringWithFormat:@"%@",avatar.url];
                    userInfo.headImageUrl = urlStr;
                    NSDictionary *myInfo = @{@"nickName":nickName,@"birthday":birthday,@"gender":gender};
                    userInfo.myInfo = myInfo;
                    [userInfo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (succeeded) {
                            completion(YES,nil,userInfo);
                        }else{
                            completion(NO,error,nil);
                        }
                    }];
                }
            }];
        }else{
            completion(NO,error,nil);
        }
    }];
    
}

/**
 *  上传图片
 *
 *  @param imagePathArray 相册
 *  @param completion     回调
 */
+ (void)upUserAlbumWithImagePath:(NSArray *)imagePathArray ImageUpCompletion:(ImageUpCompletion)completion{
    if (imagePathArray == nil || imagePathArray.count == 0) {
        completion(YES,nil,nil);
        
        return;
    }
    for (NSInteger index = 0; index < imagePathArray.count; index ++) {
        //NSLog(@"image-------------------%@",imagePathArray[index]);
        //AVFile *avatar = [AVFile fileWithName:@"album" contentsAtPath:imagePathArray[index]];
        AVFile *avatar = [AVFile fileWithName:@"album" data:imagePathArray[index]];
        [avatar saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSString *urlStr = [NSString stringWithFormat:@"%@",avatar.url];
                //NSLog(@"url============%@",urlStr);
                completion(YES,nil,urlStr);

            }else{
               // NSLog(@"失败%@",error);
                completion(NO,error,nil);
            }
        }];
    }
}


+ (void)upDiaryInfoWithImagePath:(NSData *)imagePath Title:(NSString *)title Classify:(NSString *)classify Content:(NSString *)content url:(NSString *)url date:(NSString *)update UpDataCompletion:(UpDataCompletion)completion{
    
    UserInfo *userInfo = [UserInfo objectWithObjectId:[AVUser currentUser][@"userInfoId"]];
    
    [userInfo fetchInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        
        if (!error) {
            if (imagePath.length == 0 || imagePath == nil) {
                NSMutableArray *diaryInfoArray = [NSMutableArray array];
                if (userInfo.diaryInfo.count != 0) {
                    
                    for (NSInteger index = 0; index < userInfo.diaryInfo.count; index ++) {
                        [diaryInfoArray addObject:userInfo.diaryInfo[index]];
                        
                    }
                    
                }
                NSDictionary *diaryInfo = @{@"backgroundImage":@"",@"title":title,@"classify":classify,@"content":content,@"url":url,@"date":update};
                [diaryInfoArray addObject:diaryInfo];
                userInfo.diaryInfo = diaryInfoArray;
                [userInfo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        completion(YES,nil,userInfo);
                        
                    }else{
                        completion(NO,error,nil);
                    }
                }];
                return;
            }
            
            
            AVFile *avatar = [AVFile fileWithName:@"diaryImage" data:imagePath];
            [avatar saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    NSMutableArray *diaryInfoArray = [NSMutableArray array];
                    
                    if (userInfo.diaryInfo.count != 0) {
                        for (NSInteger index = 0; index < userInfo.diaryInfo.count; index ++) {
                            [diaryInfoArray addObject:userInfo.diaryInfo[index]];
                        }
                    }
                    
                    NSString *urlStr = [NSString stringWithFormat:@"%@",avatar.url];
                    NSDictionary *diaryInfo = @{@"backgroundImage":urlStr,@"title":title,@"classify":classify,@"content":content,@"url":url,@"date":update};
                    [diaryInfoArray addObject:diaryInfo];
                    userInfo.diaryInfo = diaryInfoArray;
                    
                    [userInfo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (succeeded) {
                            
                            completion(YES,nil,userInfo);
                            
                        }else{
                            
                            
                            completion(NO,error,nil);
                            
                        }
                    }];
                }else{
                    
                    completion(NO,error,nil);
                }
            }];
        }else {
            completion(NO,error,nil);
            //NSLog(@"->>>> %@",error.localizedDescription);
        
        }
        
    }];
    
    
    
}
/**
 *  上传个人资料
 *
 *  @param gender     性别
 *  @param nickName   昵称
 *  @param birthday   生日
 *  @param completion 回调
 */
+ (void)upUserInfoWithGenter:(NSString *)gender NickName:(NSString *)nickName Birthday:(NSString *)birthday UpDataCompletion:(UpDataCompletion)completion{
    UserInfo *userInfo = [UserInfo objectWithObjectId:[AVUser currentUser][@"userInfoId"]];
    [userInfo fetchInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        if (!error) {
            NSDictionary *myInfo = @{@"nickName":nickName,@"birthday":birthday,@"gender":gender};
            userInfo.myInfo = myInfo;
            [userInfo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    completion(YES,nil,userInfo);
                }else{
                    completion(NO,error,nil);
                }
            }];
        }else{
        completion(NO,error,nil);
        }
    }];
    
}

+ (NSString *)jsonStringWithParameters:(id)parameters {
    if (parameters == nil) {
        return @"";
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}


+ (void)upLikePersonIdWithObjectId:(NSString *)personObjectId LikePersonUpCompletion:(LikePersonUpCompletion)completion{
    UserInfo *userInfo = [UserInfo objectWithObjectId:personObjectId];

    [userInfo fetchInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        if (!error) {
            UserInfo *currentUserInfo = [UserInfo objectWithObjectId:[AVUser currentUser][@"userInfoId"]];
            [currentUserInfo fetchInBackgroundWithBlock:^(AVObject *object, NSError *error) {
                if (!error) {
                    if ([userInfo.likePersonArray containsObject:[AVUser currentUser][@"userInfoId"] ]) {

                        completion(YES,nil,currentUserInfo.pairSuccessArray);
                        return;
                    }
                    /**< 喜欢的人数组*/
                    NSMutableArray *likeArray = [NSMutableArray array];
                    if (userInfo.likePersonArray.count != 0) {
                        for (NSInteger index = 0; index < userInfo.likePersonArray.count; index ++) {
                            
                            [likeArray addObject:userInfo.likePersonArray[index]];
                        }
                    }
                    [likeArray addObject:[AVUser currentUser][@"userInfoId"]];
                    userInfo.likePersonArray = likeArray;
                    
                    [userInfo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (succeeded) {
                            //配对成功
                            if ([currentUserInfo.likePersonArray containsObject:personObjectId]) {
                                /**< 对象配对的人数组*/
                                NSDictionary *pairDict = @{@"userId":currentUserInfo.objectId,@"name":currentUserInfo[@"myInfo"][@"nickName"],@"gender":currentUserInfo[@"myInfo"][@"gender"],@"headImageUrl":currentUserInfo.headImageUrl,@"signature":currentUserInfo[@"myBasicInfo"][@"signature"]};
                                NSMutableArray *pairArray = [NSMutableArray array];
                                if (userInfo.pairSuccessArray.count != 0) {
                                    for (NSInteger index = 0; index < userInfo.pairSuccessArray.count; index ++) {
                                        [pairArray addObject:userInfo.pairSuccessArray[index]];
                                        
                                    }
                                }
                                [pairArray addObject:pairDict];
                                userInfo.pairSuccessArray = pairArray;
                                [userInfo save];
                                /**< 当前用户配对的人数组*/
                                NSDictionary *currentPairDict = @{@"userId":userInfo.objectId,@"name":userInfo[@"myInfo"][@"nickName"],@"gender":userInfo[@"myInfo"][@"gender"],@"headImageUrl":userInfo.headImageUrl,@"signature":userInfo[@"myBasicInfo"][@"signature"]};
                                NSMutableArray *currentPairArray = [NSMutableArray array];
                                if (currentUserInfo.pairSuccessArray.count != 0) {
                                    for (NSInteger index = 0; index < currentUserInfo.pairSuccessArray.count; index ++) {
                                        [currentPairArray addObject:currentUserInfo.pairSuccessArray[index]];
                                    }
                                    
                                }
                                [currentPairArray addObject:currentPairDict];
                                currentUserInfo.pairSuccessArray = currentPairArray;
                                [currentUserInfo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                    if (succeeded) {
                                        
                                        completion(YES,nil,currentUserInfo.pairSuccessArray);
                                        
                                    }else{
                                        
                                        completion(NO,error,nil);
                                        
                                    }
                                }];
                            }
                        }else{
                            completion(NO,error,nil);
                            
                        }
                        
                    }];
                }else{
                completion(NO,error,nil);
                
                }
            }];
        }else{
        completion(NO,error,nil);
        }
    }];
    
    
    

}


+ (void)upDiaryArrayWithArray:(NSArray *)diaryArray UpCompletion:(UpCompletion)upCompletion{
    UserInfo *currentUserInfo = [UserInfo objectWithObjectId:[AVUser currentUser][@"userInfoId"]];
    [currentUserInfo fetchInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        if (!error) {
            currentUserInfo.diaryInfo = diaryArray;
            [currentUserInfo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    upCompletion(YES,nil);
                }else{
                    upCompletion(NO,error);
                }
            }];
        }else{
        upCompletion(NO,error);
        }
    }];
    
}

+ (void)upPairArrayWithNewPairArray:(NSArray *)newPairArray UpCompletion:(UpCompletion)completion{
    UserInfo *currentUserInfo = [UserInfo objectWithObjectId:[AVUser currentUser][@"userInfoId"]];
    [currentUserInfo fetchInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        if (!error) {
            currentUserInfo.pairSuccessArray = newPairArray;
            [currentUserInfo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
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



@end
