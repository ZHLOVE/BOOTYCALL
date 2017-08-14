//
//  DiaryModel.h
//  BootyCall
//
//  Created by rimi on 16/8/20.
//  Copyright © 2016年 dazhongdiy. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^ComoleteHandle)(NSArray *object,NSError *error);

@interface DiaryModel : NSObject


/**
 *  分类
 */
@property(nonatomic,strong)NSString *classify;
/**
 *  标题
 */
@property(nonatomic,strong)NSString *title;
/**
 *  文本
 */
@property(nonatomic,strong)NSString *content;
/**
 *  文本属性
 */
@property(nonatomic,strong)NSDictionary *attribute;
/**
 *  背景图
 */
@property(nonatomic,strong)NSString *backgroundImage;
/**
 *  文件url
 */
@property(nonatomic,strong)NSString *url;
/**
 *  上传时间
 */
@property(nonatomic,strong)NSString *date;





+(void)getmodelOfDiaryCompleteHandle:(ComoleteHandle)completehandle;
+(NSMutableArray *)changeDataToModel:(NSArray *)dataSource ;

@end
