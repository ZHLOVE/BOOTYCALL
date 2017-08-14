//
//  LeasDetailCollectionViewCell.m
//  BootyCall
//
//  Created by rimi on 16/8/18.
//  Copyright © 2016年 dazhongdiy. All rights reserved.
//

#import "LeasDetailCollectionViewCell.h"

@implementation LeasDetailCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeInterface];
    }
    return self;
}

- (void) initializeInterface{
    self.photosImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
    self.photosImageView.backgroundColor = [UIColor whiteColor];
    self.photosImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:self.photosImageView];
    /**
     *  毛玻璃效果，待处理.
     */
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        self.visualEffect = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
        self.visualEffect.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
       [self.photosImageView addSubview:self.visualEffect];
        //self.visualEffect.alpha = 0.95;

}

@end
