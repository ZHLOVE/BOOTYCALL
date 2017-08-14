//
//  SFoldawayModel.m
//  BootyCall
//
//  Created by mac on 16/8/9.
//  Copyright © 2016年 dazhongdiy. All rights reserved.
//

#import "SFoldawayModel.h"

@implementation SFoldawayModel


- (instancetype)initWithMainBtnTitle:(NSString*)title selectTitle:(NSString*)selectTitle backColor:(UIColor *)color image:(NSString*)image selectImage:(NSString*)selectImage
{
    self = [super init];
        _mainBtnTitle = title;
        _mainBtnSelectTitle = selectTitle;
        _mainBtnColor = color;
        _mainBtnImage = image;
        _mainBtnSelectImage = selectImage;
    return self;
}

- (instancetype)initWithMainBtnTitle:(NSString *)title selectTitle:(NSString*)selectTitle backColor:(UIColor*)color
{
    return [self initWithMainBtnTitle:title selectTitle:selectTitle backColor:color image:nil selectImage:nil];
}

- (instancetype)initWithMainBtnTitle:(NSString *)title selectTitle:(NSString*)selectTitle image:(NSString*)image selectImage:(NSString*)selectImage
{
    return [self initWithMainBtnTitle:title selectTitle:selectTitle backColor:nil image:image selectImage:selectImage];
}


@end
