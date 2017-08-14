//
//  UIScrollView+StwitterCover.h
//  BootyCall
//
//  Created by mac on 16/8/12.
//  Copyright © 2016年 dazhongdiy. All rights reserved.
//

#import <UIKit/UIKit.h>
#define CHTwitterCoverViewHeight SCREEN_HEIGHT * 0.25


@interface STwitterCoverView: UIImageView
@property (nonatomic, strong) UIScrollView *scrollView;
- (id)initWithFrame:(CGRect)frame andContentTopView:(UIView*)view;
@end


@interface UIScrollView (StwitterCover)
@property(nonatomic,strong)STwitterCoverView *twitterCoverView;
- (void)addTwitterCoverWithImage:(UIImage*)image;
- (void)addTwitterCoverWithImage:(UIImage*)image withTopView:(UIView*)topView;
- (void)removeTwitterCoverView;

@end


@interface UIImage (Blur)
-(UIImage *)boxblurImageWithBlur:(CGFloat)blur;

@end
