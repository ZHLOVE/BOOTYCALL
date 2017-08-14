//
//  QPairTableViewCell.h
//  BootyCall
//
//  Created by rimi on 16/8/13.
//  Copyright © 2016年 dazhongdiy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QPairModel.h"

@protocol QPairTableViewCellDelegate <NSObject>

-(void)clickDetailInfoButtonEvent:(NSString *)userInfoId username:(NSString *)username;


@end


@interface QPairTableViewCell : UITableViewCell

/**
 *  搜索结果模型
 */
@property(nonatomic,strong)QPairModel *model;

/**
 *  delegate
 */
@property(nonatomic,weak)id<QPairTableViewCellDelegate>  delegate;






@end
