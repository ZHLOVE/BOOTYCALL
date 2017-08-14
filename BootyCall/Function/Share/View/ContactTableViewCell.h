//
//  ContactTableViewCell.h
//  BootyCall
//
//  Created by rimi on 16/8/26.
//  Copyright © 2016年 dazhongdiy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactModel.h"
@interface ContactTableViewCell : UITableViewCell

/**
 *  联系人模型
 */
@property(nonatomic,strong)ContactModel *model;


@end
