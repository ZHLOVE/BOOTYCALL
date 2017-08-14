//
//  SZzzLViewController.m
//  BootyCall
//
//  Created by mac on 16/8/18.
//  Copyright © 2016年 dazhongdiy. All rights reserved.
//

#import "VerticalTextLabel.h"

@implementation VerticalTextLabel


- (void)drawRect:(CGRect)rect {
    // Drawing code
    // 视图的宽高
    float view_height = self.frame.size.height;
    float view_width = self.frame.size.width;
    
    // 每个字的起始会在点
    float start_x = 0;
    float start_y = 0;
    // 每个字体的宽高
    float width = self.font.pointSize;
    float height = self.font.pointSize + 5;
    // 每个字体的坐标
    float x;
    float y;
    
    start_x = view_width - width;
    // 每列的最大字数
    NSInteger charNumber = floor(view_height / height);
    
    NSInteger containerNumber = floor(view_width / height);
    // 绘制的字体
    NSString *drawStr = self.text;
    // 需要绘制的总列数
    NSInteger lineNumber = ceil([drawStr length] / charNumber);
    
    if (lineNumber >= containerNumber) {
        NSRange range;
        range.location = 0;
        range.length = containerNumber * charNumber - 1;
        drawStr = [drawStr substringWithRange:range];
        drawStr = [drawStr stringByAppendingFormat:@"..."];
    }
    
    for (int i = 0; i < [drawStr length]; i ++) {
        x = start_x - floor(i / charNumber) * width;
        y = start_y + (i % charNumber) * height;
        CGRect aframe = CGRectMake(x, y, width, height);
        NSRange range;
        range.length = 1;
        range.location = i;
        NSString *str = [drawStr substringWithRange:range];
        //        [str drawInRect:aframe withFont:self.font];
        [str drawInRect:aframe withAttributes:@{NSFontAttributeName:self.font}];
    }
}

@end
