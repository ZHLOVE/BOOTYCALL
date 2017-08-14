//
//  SLabelView.h
//  BootyCall
//
//  Created by mac on 16/8/10.
//  Copyright © 2016年 dazhongdiy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLabelView : UIView

/**< 外面调用是设置UILabel参数 */
@property(nonatomic, copy) NSString      *text;//显示文字
@property(nonatomic, strong) UIColor     *textColor;//文字颜色
@property(nonatomic, strong) UIFont      *font;//字体大小
@property(nonatomic, assign) CGFloat     speed;//滚动速率

- (void)addAnimation;

@end
