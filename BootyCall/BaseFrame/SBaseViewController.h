//
//  SBaseViewController.h
//  BootyCall
//
//  Created by mac on 16/8/10.
//  Copyright © 2016年 dazhongdiy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLabelView.h"
@class SHomeViewController;
@interface SBaseViewController : UIViewController

/**返回按钮*/
@property(nonatomic,strong)UIButton                      *returnBtn;
/**滚动显示Label*/
@property(nonatomic,strong)SLabelView                    *rollLabel;


/**
 *  微信朋友圈分享
 */
-(void)shareWechatTimeline;
/**
 *  微信好友推荐
 */
-(void)shareWechatSession;
/**
 *  获取主页控制器
 *
 *  @return 主页控制器
 */
-(SHomeViewController *)getHomeViewController;
/**
 *  设置模糊背景
 *
 *  @param bgImageView 背景图片
 */
-(void)setFuzzyBgImageView:(UIImageView *)bgImageView;
/**
 *  设置控制器的名称
 *
 *  @param vcName 名称
 *  @param color  背景颜色
 */
-(void)setViewControllerName:(NSString*)vcName bgColor:(UIColor *)color;


//Mr ma
- (void)showProgressHUD:(UIView*)view hint:(NSString *)hint hide:(NSString *)hide;
- (void)removePorgressHud;

@end
