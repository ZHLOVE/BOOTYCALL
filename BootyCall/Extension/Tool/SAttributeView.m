//
//  SAttributeView.m
//  BootyCall
//
//  Created by mac on 16/8/14.
//  Copyright © 2016年 dazhongdiy. All rights reserved.
//

#import "SAttributeView.h"
#import "UIView+SFrame.h"

#define margin 10

@interface SAttributeView ()

/**
 *  布尔值用来第一次点击的时候记录下btn的背景颜色，并将其赋给_btnOldColor,_lastBtn用于记录上一次被点击的按钮，每点击一次时需要更改上一按钮的背景颜色，从而实现单选的功能
 */
{
    BOOL     _isFirstClick;
    UIColor  *_btnOldColor;
    UIButton *_lastBtn;
}

@property (nonatomic ,weak) UIButton *btn;

@end

@implementation SAttributeView

/**
 *  返回一个创建好的属性视图,并且带有标题.创建好之后必须设置视图的Y值.
 *
 *  @param texts 属性数组
 *
 *  @param viewWidth 视图宽度
 *
 *  @return attributeView
 */
+ (SAttributeView *)attributeViewWithTitle:(NSString *)title titleFont:(UIFont *)font attributeTexts:(NSArray *)texts viewWidth:(CGFloat)viewWidth btnBgColor:(UIColor*)color{
    int count = 0;
    float btnW = 0;
    SAttributeView *view = [[SAttributeView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    label.text = title;
    label.font = font;
    label.textColor = [UIColor grayColor];
    label.backgroundColor = BgColor;
    //CGSize size = [label.text sizeWithAttributes:@{NSFontAttributeName:font}];
    //label.frame = (CGRect){{10,10},size};
    [view addSubview:label];
    for (int i = 0; i<texts.count; i++) {
        UIButton *btn = [[UIButton alloc]init];
        btn.tag = i;
        [btn addTarget:view action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        NSString *str = texts[i];
        [btn setTitle:str forState:UIControlStateNormal];
        CGSize strsize = [str sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:13]}];
        
        btn.width = strsize.width + margin;
        btn.height = strsize.height+ margin;
        
        if (i == 0) {
            btn.x = margin;
            btnW += CGRectGetMaxX(btn.frame);
        }
        else{
            btnW += CGRectGetMaxX(btn.frame)+margin;
            if (btnW > viewWidth) {
                count++;
                btn.x = margin;
                btnW = CGRectGetMaxX(btn.frame);
            }
            else{
                
                btn.x += btnW - btn.width;
                
            }
        }
        btn.backgroundColor = color;
        btn.userInteractionEnabled = YES;
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        btn.y += count * (btn.height + margin) + margin + label.height +0;
        
        btn.layer.cornerRadius = 3.f;//btn.height * 0.5;
        btn.clipsToBounds = YES;
        btn.tag = i;
        [view addSubview:btn];
        if (i == texts.count - 1) {
            view.height = CGRectGetMaxY(btn.frame) + 10;
            view.x = 0;
            view.width = viewWidth;
        }
    }
    return view;
}

- (void)btnClick:(UIButton *)sender{
    
    if (!_isFirstClick) {
        _btnOldColor = sender.backgroundColor;
        _isFirstClick = YES;
    }
    _lastBtn.backgroundColor = _btnOldColor;
    
    if (![self.btn isEqual:sender]) {
        self.btn.selected = NO;
        sender.backgroundColor = MainColor;
        sender.selected = YES;
    }else if([self.btn isEqual:sender]){
        if (sender.selected == YES) {
            sender.selected = NO;
        }else{
            sender.backgroundColor = MainColor;
            sender.selected = YES;
        }
    }else{
    }
    if ([self.sAttribute_delegate respondsToSelector:@selector(sAttribute_View:didClickBtn:)] ) {
        [self.sAttribute_delegate sAttribute_View:self didClickBtn:sender];
    }
    self.btn = sender;
    _lastBtn = sender;
    
}


@end
