//
//  SFoldawayModel.h
//  BootyCall
//
//  Created by mac on 16/8/9.
//  Copyright © 2016年 dazhongdiy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SFoldawayModel : NSObject

/**主按钮名称*/
@property(nonatomic,copy)NSString                      *mainBtnTitle;
/**主按钮选择名称*/
@property(nonatomic,copy)NSString                      *mainBtnSelectTitle;
/**主按钮背景图片*/
@property(nonatomic,copy)NSString                      *mainBtnImage;
/**主按钮选择背景图片*/
@property(nonatomic,copy)NSString                      *mainBtnSelectImage;
/**主按钮背景颜色*/
@property(nonatomic,strong)UIColor                     *mainBtnColor;
/**子按钮名数组*/
@property (nonatomic, strong) NSArray                  *subBtnTitles;
/**子按钮名数组*/
@property(nonatomic,strong)NSArray                     *subBtnSelectTitles;
/**子按钮背景颜色*/
@property(nonatomic,strong)NSArray                     *subBtnColors;
/**子按钮背景图片*/
@property(nonatomic,strong)NSArray                     *subBtnImages;
/**子按钮选择背景图片*/
@property(nonatomic,strong)NSArray                     *subBtnSelectImages;
/**子按钮高亮背景图片*/
@property(nonatomic,strong)NSArray                     *subBtnHighLightImages;

/**
 *   设置按钮属性
 *
 *  @param title       标题
 *  @param selectTitle 选择状态的标题
 *  @param color       背景颜色
 *  @param image       正常状态下的图片
 *  @param selectImage 选择状态下的图片
 *
 *  @return SFoldawayModel对象
 */
- (instancetype)initWithMainBtnTitle:(NSString*)title selectTitle:(NSString*)selectTitle backColor:(UIColor *)color image:(NSString*)image selectImage:(NSString*)selectImage;

- (instancetype)initWithMainBtnTitle:(NSString *)title selectTitle:(NSString*)selectTitle backColor:(UIColor*)color;

- (instancetype)initWithMainBtnTitle:(NSString *)title selectTitle:(NSString*)selectTitle image:(NSString*)image selectImage:(NSString*)selectImage;
@end
