//
//  SCustomView.m
//  MAMA框架OC
//
//  Created by mac on 16/7/7.
//  Copyright © 2016年 dazhongdiy. All rights reserved.
//

#import "SCustomView.h"

@implementation SCustomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
    }
    return self;
}
-(void)setWhiteValue:(CGFloat)whiteValue alphaValue:(CGFloat)alphaValue{
    self.backgroundColor = [UIColor colorWithWhite:whiteValue alpha:alphaValue];
}


@end
