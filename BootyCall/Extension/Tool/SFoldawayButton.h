//
//  SFoldawayButton.h
//  BootyCall
//
//  Created by mac on 16/8/9.
//  Copyright © 2016年 dazhongdiy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFoldawayModel.h"
@class  SButton;

typedef void(^clickSubButtonBack)(int index, NSString * title, BOOL select);

typedef NS_ENUM(NSInteger, ShowType) {
    
    showTypeOfLine = 1,
    showTypeOfCircle
};

typedef NS_ENUM(NSInteger, LineShowDirection){
    
    lineShowDirectionLeft = 1,
    lineShowDirectionRight,
    lineShowDirectionUp,
    lineShowDirectionDown
};

typedef NS_ENUM(NSInteger, CircleShowDirection){
    
    circleShowDirectionLeft = 1,
    circleShowDirectionRight,
    circleShowDirectionUp,
    circleShowDirectionDown,
    circleShowDirectionRightDown,
    circleShowDirectionRightUp,
    circleShowDirectionLeftUp,
    circleShowDirectionLeftDown
};



@interface SFoldawayButton : UIView

/**能否拖拽，默认为Yes*/
@property(nonatomic,assign)BOOL                          canBeMoved;
/**显示在父视图正中*/
@property(nonatomic,assign)BOOL                          showSuperViewCenter;
/**显示类型*/
@property(nonatomic,assign)ShowType                      showType;
/**直线显示方向*/
@property(nonatomic,assign)LineShowDirection             lineShowDirection;
/**圆形型显示方向*/
@property(nonatomic,assign)CircleShowDirection           circleShowDirection;
/**散开按钮和主按钮之间的距离*/
@property(nonatomic,assign)CGFloat                       disperseDistance;
/**自动显示方向,如要设置距离，必须在自动之前设置*/
@property(nonatomic,assign)BOOL                          automaticShowDirection;
/**是否添加弹簧效果，默认为YES*/
@property(nonatomic,assign)BOOL                          showWithSpring;
/**按钮点击*/
@property(nonatomic,copy)clickSubButtonBack              clickSubButtonBack;
/**主按钮*/
@property(nonatomic,strong)UIButton                     *mainBtn;
/**封面按钮*/
@property(nonatomic,strong)UIButton                     *coverBtn;
/**按钮数组*/
@property(nonatomic,strong)NSArray<SButton*>           *btnsArray;

/**
 *  构造方法
 *
 *  @param rect          rect
 *  @param foldAwayModel SFoldAwayModel模型
 *
 *  @return
 */
- (instancetype)initWithRect:(CGRect)rect andFoldAwayModel:(SFoldawayModel *)foldAwayModel;
/**
 *  构造方法
 *
 *  @param rect        rect
 *  @param title       按钮名
 *  @param color       按钮颜色
 *  @param titlesArray 展示按钮名数组
 *  @param colors      展示按钮颜色数组
 *
 *  @return
 */
- (instancetype)initWithRect:(CGRect)rect mainButtonTitle:(NSString *)title mainButtonColor:(UIColor *)color titlesArray:(NSArray *)titlesArray colors:(NSArray *)colors;
/**
 *  构造方法
 *
 *  @param rect        rect
 *  @param title       按钮名
 *  @param selectTitle 选择后按钮名
 *  @param color       按钮颜色
 *  @param titlesArray 展示按钮名数组
 *  @param colors      展示按钮颜色数组
 *
 *  @return
 */
- (instancetype)initWithRect:(CGRect)rect mainButtonTitle:(NSString *)title selectTitle:(NSString *)selectTitle mainButtonColor:(UIColor *)color titlesArray:(NSArray *)titlesArray colors:(NSArray *)colors;
/**
 *  构造方法
 *
 *  @param rect              rect
 *  @param title             按钮名
 *  @param selectTitle       选择后按钮名
 *  @param color             按钮颜色
 *  @param titlesArray       展示按钮名数组
 *  @param selectTitlesArray 展示按钮选择后显示名数组
 *  @param colors            展示按钮颜色数组
 *
 *  @return
 */
- (instancetype)initWithRect:(CGRect)rect mainButtonTitle:(NSString *)title selectTitle:(NSString *)selectTitle mainButtonColor:(UIColor *)color titlesArray:(NSArray *)titlesArray selectTitlesArray:(NSArray *)selectTitlesArray colors:(NSArray *)colors;
/**
 *  默认显示在Window上
 */
- (void)show;

/**
 *  指定视图显示
 *
 *  @param view 指定的视图
 */
- (void)showInView:(UIView *)view;

/**
 *  指定视图显示,并且指出是否有NavigationBar、TabBar
 *
 *  @param view              指定的视图
 *  @param haveNavigationBar 是否包含NavigationBar
 *  @param haveTabBar        是否包含TabBar
 */
- (void)showInView:(UIView *)view navigationBar:(BOOL)haveNavigationBar tabBar:(BOOL)haveTabBar;

/**
 *  移除
 */
- (void)remove;



+(instancetype)sharSfoldawayButton;
@end


















