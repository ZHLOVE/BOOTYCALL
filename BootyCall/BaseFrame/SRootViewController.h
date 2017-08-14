//
//  SRootViewController.h
//  BootyCall
//
//  Created by mac on 16/8/9.
//  Copyright © 2016年 dazhongdiy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SSubRootViewController;
@interface SRootViewController : UIViewController
/**根子控制器*/
@property(nonatomic,strong)SSubRootViewController               *subRootVc;
@end
