//
//  SAttributeView.h
//  BootyCall
//
//  Created by mac on 16/8/14.
//  Copyright © 2016年 dazhongdiy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SAttributeView;

@protocol SAttributeViewDelegate<NSObject>
@optional
-(void)sAttribute_View:(SAttributeView *)view didClickBtn:(UIButton *)btn;

@end

@interface SAttributeView : UIView

@property(nonatomic,assign)id <SAttributeViewDelegate>sAttribute_delegate;
/**
 *  返回一个创建好的属性视图,并且带有标题.创建好之后必须设置视图的Y值.
 *
 *  @param texts 属性数组
 *
 *  @return attributeView
 */
+ (SAttributeView *)attributeViewWithTitle:(NSString *)title titleFont:(UIFont *)font attributeTexts:(NSArray *)texts viewWidth:(CGFloat)viewWidth btnBgColor:(UIColor*)color;

@end
