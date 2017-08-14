//
//  MUserRegister+UserRegisterInfo.h
//  BootyCall
//
//  Created by rimi on 16/8/12.
//  Copyright © 2016年 dazhongdiy. All rights reserved.
//

#import "MUserRegister.h"


typedef void (^UpDataCompletion)(BOOL success,NSError *error,UserInfo *userInfo);
typedef void (^ImageUpCompletion)(BOOL success,NSError *error,NSString *imageUrl);
typedef void(^LikePersonUpCompletion)(BOOL success,NSError *error,NSArray *pairArray);
typedef void(^UpCompletion)(BOOL success,NSError *error);

@interface MUserRegister (UserRegisterInfo)
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
+ (void)upDateWithUserHeadImagePath:(NSData *)imagePath
                         AlbumArray:(NSArray *)albumArray
                          Signature:(NSString *)signature
                             Height:(NSString *)height
                      IndustryArray:(NSArray *)industryArray
                     CharacterArray:(NSArray *)characterArray
                        DefectArray:(NSArray *)defectArray
                         HobbyArray:(NSArray *)hobbyArray
                   UpDataCompletion:(UpDataCompletion)completion;



/**
 *  注册上传资料
 *
 *  @param imagePath  头像路径
 *  @param nickName   昵称
 *  @param birthday   生日
 *  @param gender     性别
 *  @param completion 回调
 */
+ (void)upUserRegisterInfoWithImagePath:(NSData *)imagePath
                               NickName:(NSString *)nickName
                               Birthday:(NSString *)birthday
                                 Gender:(NSString *)gender
                                    Age:(NSString *)age
                       UpDataCompletion:(UpDataCompletion)completion;

/**
 *  上传头像
 *
 *  @param imagePathArray 相册
 *  @param completion     回调
 */

+ (void)upUserAlbumWithImagePath:(NSArray *)imagePathArray
                     ImageUpCompletion:(ImageUpCompletion)completion;

/**
 *  上传个人资料
 *
 *  @param gender     性别
 *  @param nickName   昵称
 *  @param birthday   生日
 *  @param completion 回调
 */
+ (void)upUserInfoWithGenter:(NSString *)gender
                    NickName:(NSString *)nickName
                    Birthday:(NSString *)birthday
            UpDataCompletion:(UpDataCompletion)completion;



/**
 *  上传日志信息
 *
 *  @param imagePath  背景图
 *  @param title      标题
 *  @param classify   类别
 *  @param content    正文
 *  @param url        配置
 *  @param update     时间
 *  @param completion 回调
 */
+ (void)upDiaryInfoWithImagePath:(NSData *)imagePath Title:(NSString *)title Classify:(NSString *)classify Content:(NSString *)content url:(NSString *)url date:(NSString *)update UpDataCompletion:(UpDataCompletion)completion;

/**
 *  配对
 *
 *  @param personObjectId 配对人id
 *  @param completion     回调
 */
+ (void)upLikePersonIdWithObjectId:(NSString *)personObjectId
            LikePersonUpCompletion:(LikePersonUpCompletion)completion;


/**
 *  返回日志列表
 *
 *  @param diaryArray   日志
 *  @param upCompletion 回调
 */
+ (void)upDiaryArrayWithArray:(NSArray *)diaryArray
                 UpCompletion:(UpCompletion)upCompletion;

/**
 *  更新配对列表啊
 *
 *  @param newPairArray 新的配对数组
 *  @param completion   <#completion description#>
 */
+ (void)upPairArrayWithNewPairArray:(NSArray *)newPairArray
                       UpCompletion:(UpCompletion)completion;








@end
