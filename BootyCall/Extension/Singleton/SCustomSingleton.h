//
//  SCustomSingleton.h
//  BootyCall
//
//  Created by mac on 16/8/11.
//  Copyright © 2016年 dazhongdiy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCustomSingleton : NSObject

/**子控制器的下标*/
@property(nonatomic,assign)NSInteger                      index;
@property(nonatomic,assign)BOOL                           isOpenGuideVc;

// Mr  liao
@property(nonatomic,strong)NSMutableArray  *selectedUsersArray;
/**
 *  Q 聊天数
 */
@property(nonatomic,assign)NSInteger chatCount;

+(instancetype)defaultCustomSingleton;
@end
