//
//  SGuideDetailViewController.h
//  BootyCall
//
//  Created by mac on 16/8/12.
//  Copyright © 2016年 dazhongdiy. All rights reserved.
//

#import "SBaseViewController.h"

@interface SGuideDetailViewController : SBaseViewController

/**根据index来判读上一页点击的是哪一行，因为每一行对应的详情内容都是不一样的*/
@property(nonatomic,assign)NSInteger                      index;
/**标题*/
@property(nonatomic,strong)NSString                       *stitleStr;
@end
