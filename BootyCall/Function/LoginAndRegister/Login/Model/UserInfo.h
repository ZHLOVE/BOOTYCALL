//
//  UserInfo.h
//
//  Created by rimi on 16/8/10.
//  Copyright © 2016年 orange. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UserInfo : AVObject<AVSubclassing>


/**< 头像*/
//@property(nonatomic,copy)NSString *HeadImageUrl;
/**< 相册*/
//@property(nonatomic,strong)NSArray *albumArray;
/**< 我的信息*/
//@property(nonatomic,strong)NSObject *myInfo;
/**< 我的位置*/
//@property(nonatomic,assign)AVGeoPoint *geoPoint;


/**< 头像*/
@property(nonatomic,copy)NSString *headImageUrl;
/**< 相册*/
@property(nonatomic,strong)NSArray *albumArray;
/**< 基本资料*/
@property(nonatomic,strong)NSObject *myBasicInfo;
/**< 我的信息*/
@property(nonatomic,strong)NSObject *myInfo;
/**< 我的行业*/
@property(nonatomic,strong)NSArray *industryArray;
/**< 个人性格*/
@property(nonatomic,strong)NSArray *characterArray;
/**< 个人缺点*/
@property(nonatomic,strong)NSArray *defectArray;
/**< 兴趣爱好*/
@property(nonatomic,strong)NSArray *hobbyArray;
/**< 我的位置*/
@property(nonatomic,assign)AVGeoPoint *geoPoint;
/**< 日记背景*/
@property(nonatomic,strong)NSArray *diaryInfo;
/**< 喜欢用户数组*/
@property(nonatomic,strong)NSArray *likePersonArray;
/**< 配对成功数组*/
@property(nonatomic,strong)NSArray *pairSuccessArray;
/**< 讨厌的人数组*/
@property(nonatomic,strong)NSArray *hatePersonArray;





@end
