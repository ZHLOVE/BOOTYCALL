//
//  SFlashLabel.h
//  BootyCall
//
//  Created by mac on 16/8/16.
//  Copyright © 2016年 dazhongdiy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFlashLabel : UILabel

@property (nonatomic, retain) UIColor *spotlightColor;

- (void)startAnimating;

- (void)stopAnimating;
@end
