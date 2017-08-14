//
//  ColorView.m
//  BootyCall
//
//  Created by rimi on 16/8/25.
//  Copyright © 2016年 dazhongdiy. All rights reserved.
//

#import "ColorView.h"
#define COLORBUTTONW 30
#define COLORBUTTONH 30
#define BUTTON_TAG 2000


@interface ColorView ()
/**
 *  红色
 */
@property(nonatomic,strong)NSArray *red;
/**
 *  绿色
 */
@property(nonatomic,strong)NSArray *green;
/**
 *  蓝色
 */
@property(nonatomic,strong)NSArray *blue;



@end
@implementation ColorView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initalizeInterface];
    }
    return self;
}




+(ColorView *)shareColorView {

    static ColorView *colorView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        colorView = [[ColorView alloc]initWithFrame:CGRectZero];
    });
    return colorView;
}


-(void)initalizeInterface {
    
   _red = @[@"1",@"0",@"1",@"1",@"0.501",@"0.270",@"0.234",@"0.180",@"0.310",@"0.073",@"0.015",@"0.105"];
   _green = @[@"0.025",@"0",@"0.997",@"0.584",@"1",@"1",@"1",@"1",@"0.685",@"0.399",@"0.148",@"0.004"];
   _blue = @[@"0.008",@"0.000",@"0.052",@"0.717",@"0.213",@"0.566",@"0.114",@"0.423",@"1",@"1",@"1",@"1"];
    NSMutableArray *colorArr = @[].mutableCopy;
    for (NSInteger i =0; i<12; i++) {
        UIColor *color = [UIColor colorWithRed:[_red[i] floatValue] green:[_green[i] floatValue] blue:[_blue[i] floatValue] alpha:1];
        
        [colorArr addObject:color];
    }
    
    
    for (NSInteger i=0; i<12; i++) {
        UIButton *colorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        colorBtn.frame = CGRectMake(i%4 *(COLORBUTTONW +10)+75, i/4*(COLORBUTTONH +10), COLORBUTTONW, COLORBUTTONH);
        colorBtn.layer.cornerRadius =15;
        colorBtn.layer.masksToBounds =YES;
        colorBtn.layer.shadowOffset =  CGSizeMake(1, 1);
        colorBtn.layer.shadowOpacity = 0.8;
        colorBtn.backgroundColor = colorArr[i];
        colorBtn.layer.shadowColor = [colorArr[i] CGColor];
        colorBtn.tag = BUTTON_TAG +i;
        [colorBtn addTarget:self action:@selector(colorBtnAction:) forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:colorBtn];
    }
   

}

-(void)colorBtnAction:(UIButton *)sender {

    
    if (_delegate && [_delegate respondsToSelector:@selector(changeContentTextColor:)]) {
        NSInteger index = sender.tag - BUTTON_TAG;
      UIColor *color = [UIColor colorWithRed:[_red[index] floatValue] green:[_green[index] floatValue] blue:[_blue[index] floatValue] alpha:1];
        [_delegate changeContentTextColor:color];
    }

}


@end
