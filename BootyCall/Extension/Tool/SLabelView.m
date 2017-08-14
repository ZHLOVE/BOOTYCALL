//
//  SLabelView.m
//  BootyCall
//
//  Created by mac on 16/8/10.
//  Copyright © 2016年 dazhongdiy. All rights reserved.
//

#import "SLabelView.h"

@interface SLabelView ()

@property(nonatomic, strong) UILabel    *contentLabel;//定义一个全局的UILabel
@property(nonatomic, assign) BOOL       animationBreak;//定义一个BOOL用于判断

@end
@implementation SLabelView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.contentLabel];
        
    }
    return self;
}
#pragma mark - ******* Setters *******
//给内容view的layer添加一个mask层, 并且设置其范围为整个view的bounds, 这样就让超出view的内容不会显示出来
//重写frame的setter方法
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    CAShapeLayer* maskLayer = [CAShapeLayer layer];
    maskLayer.path = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    self.layer.mask = maskLayer;
}
//重写Text的setter方法
- (void)setText:(NSString *)text
{
    self.contentLabel.text = text;
    
    [self.contentLabel sizeToFit];
    
}
//重写font的setter方法
- (void)setFont:(UIFont *)font
{
    self.contentLabel.font = font;
    
    [self.contentLabel sizeToFit];
    
    CGRect frame = self.frame;
    
    if (frame.size.height < font.lineHeight) {//判断自定义视图高度是否小于文字高度
        //文字高度赋值给自定义视图的高度
        frame.size.height = font.lineHeight;
        self.frame = frame;
    }
    
    
}
//重写textColor的setter方法
- (void)setTextColor:(UIColor *)textColor
{
    self.contentLabel.textColor = textColor;
}

-(void)willMoveToSuperview:(UIView *)newSuperview{
    weakSelf();
    [super willMoveToSuperview:newSuperview];
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQueue, ^{
        [weakSelf addAnimation];
    });
}



#pragma mark - ******* Events *******

- (void)addAnimation
{
    //先判断UILabel的Text是否超过它的长度
    if (self.frame.size.width >= self.contentLabel.frame.size.width) {
        return;
    }
    //移除label的layer上的所以动画
    [self.contentLabel.layer removeAllAnimations];
    //计算label的宽度与自定义view宽度差值
    CGFloat space = self.contentLabel.frame.size.width - self.frame.size.width;
    //初始化一个CAKeyframeAnimation对象
    CAKeyframeAnimation* keyFrame = [CAKeyframeAnimation animation];
    //设置向那个方向移动
    keyFrame.keyPath = @"transform.translation.x";
    //关键帧”(keyframe)。动画对象会在指定的时间(duration)内，依次显示values数组中的每一个关键帧
    keyFrame.values = @[@(0), @(-space), @(0)];
    //循环次数
    keyFrame.repeatCount = NSIntegerMax;
    //设置动画时间
    keyFrame.duration = self.speed * self.contentLabel.text.length;
    //设置运动的速度匀加，减，速
    keyFrame.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut], [CAMediaTimingFunction functionWithControlPoints:0 :0 :0.5 :0.5]];
    //设置代理
    keyFrame.delegate = self;
    
    [self.contentLabel.layer addAnimation:keyFrame forKey:nil];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    self.animationBreak = !flag;
    [self addAnimation];
}

#pragma mark - ******* Getters *******
- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        [_contentLabel sizeToFit];
        _contentLabel.backgroundColor = [UIColor clearColor];
    }
    return _contentLabel;
}



@end
