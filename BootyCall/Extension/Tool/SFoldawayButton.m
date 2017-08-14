//
//  SFoldawayButton.m
//  BootyCall
//
//  Created by mac on 16/8/9.
//  Copyright © 2016年 dazhongdiy. All rights reserved.
//

#import "SFoldawayButton.h"
#import "UIView+SFrame.h"
#import "SButton.h"
//半圆的修正系数
#define CORRECTION_CONEDDICIENT SCREEN_WIDTH * 0.13 //35
#define BACK_GAUGE 5

@interface SFoldawayButton ()

/**顶部距离*/
@property(nonatomic,assign)CGFloat                      topDistance;
/**底部距离*/
@property(nonatomic,assign)CGFloat                      bottomDistance;
/**大小*/
@property(nonatomic,assign)CGRect                       rect;
/**按钮标题*/
@property(nonatomic,strong)NSString                     *btnTitle;
/**选择状态后的按钮标题*/
@property(nonatomic,strong)NSString                     *selectTitle;
/**按钮背景颜色*/
@property(nonatomic,strong)UIColor                      *btnColor;
/**按钮背景图片*/
@property(nonatomic,strong)NSString                     *btnImage;
/**选择状态下的背景图片*/
@property(nonatomic,strong)NSString                     *btnSelectImage;
/**按钮背景颜色数组*/
@property(nonatomic,strong)NSArray                      *colors;
/**按钮标题数组*/
@property(nonatomic,strong)NSArray                      *titlesArray;
/**选择状态下的按钮标题数组*/
@property(nonatomic,strong)NSArray                      *selectTitlesAarray;
/**子按钮背景图片数组*/
@property(nonatomic,strong)NSArray                      *subBtnImages;
/**子按钮选择状态下背景图片数组*/
@property(nonatomic,strong)NSArray                      *subBtnSelectImages;
/**子按钮高亮状态下背景图片数组*/
@property(nonatomic,strong)NSArray                      *subBtnHighLightImages;
/**拖动手势*/
@property(nonatomic,strong)UIPanGestureRecognizer       *pan;

@end


static SFoldawayButton *singlton = nil;

@implementation SFoldawayButton

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(instancetype)initWithRect:(CGRect)rect andFoldAwayModel:(SFoldawayModel *)foldAwayModel{
    self = [super initWithFrame:rect];
    //收回圆形按钮
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(clickBtnNotification:) name:@"clickBtn" object:nil];
    _canBeMoved = YES;
    _showWithSpring = YES;
    _topDistance = 0;
    _bottomDistance = 0;
    _colors = foldAwayModel.subBtnColors;
    _btnColor = foldAwayModel.mainBtnColor;
    _btnTitle = foldAwayModel.mainBtnTitle;
    _selectTitle = foldAwayModel.mainBtnSelectTitle;
    _btnImage = foldAwayModel.mainBtnImage;
    _btnSelectImage = foldAwayModel.mainBtnSelectImage;
    _titlesArray = foldAwayModel.subBtnTitles;
    _selectTitlesAarray = foldAwayModel.subBtnSelectTitles;
    _subBtnImages = foldAwayModel.subBtnImages;
    _subBtnSelectImages = foldAwayModel.subBtnSelectImages;
    _subBtnHighLightImages = foldAwayModel.subBtnHighLightImages;
    [self setupLayout];
    return self;
}

- (instancetype)initWithRect:(CGRect)rect mainButtonTitle:(NSString *)title selectTitle:(NSString *)selectTitle mainButtonColor:(UIColor *)color titlesArray:(NSArray *)titlesArray selectTitlesArray:(NSArray *)selectTitlesArray colors:(NSArray *)colors {
    
    self = [super initWithFrame:rect];
    
    self.canBeMoved         = YES;
    self.showWithSpring     = YES;
    self.topDistance        = 0;
    self.bottomDistance     = 0;
    self.colors             = colors;
    self.btnColor           = color;
    self.btnTitle           = title;
    self.selectTitle        = selectTitle;
    self.titlesArray        = titlesArray;
    self.selectTitlesAarray = selectTitlesArray;
    [self setupLayout];
    
    return self;
}

- (instancetype)initWithRect:(CGRect)rect mainButtonTitle:(NSString *)title selectTitle:(NSString *)selectTitle mainButtonColor:(UIColor *)color titlesArray:(NSArray *)titlesArray colors:(NSArray *)colors {
    
    return [self initWithRect:rect mainButtonTitle:title selectTitle:selectTitle mainButtonColor:color titlesArray:titlesArray selectTitlesArray:nil colors:colors];
}

- (instancetype)initWithRect:(CGRect)rect mainButtonTitle:(NSString *)title mainButtonColor:(UIColor *)color titlesArray:(NSArray *)titlesArray colors:(NSArray *)colors {
    
    return [self initWithRect:rect mainButtonTitle:title selectTitle:nil mainButtonColor:color titlesArray:titlesArray colors:colors];
}

/**
 *  显示在window上
 */
-(void)show{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    if (self.automaticShowDirection) {
        [self automaticChangeShowDirection];
    }
}

/**
 *  显示在指定视图上
 *
 *  @param view 视图
 */
-(void)showInView:(UIView *)view{
    [view addSubview:self];
    if (self.automaticShowDirection) {
        [self automaticChangeShowDirection];
    }
}

/**
 *  在有导航栏或者标签栏的情况下，避免该按钮附在导航栏或标签栏上
 *
 *  @param view              视图
 *  @param haveNavigationBar 是否存在导航栏
 *  @param haveTabBar        是否存在标签栏
 */

-(void)showInView:(UIView *)view navigationBar:(BOOL)haveNavigationBar tabBar:(BOOL)haveTabBar{
    self.topDistance = haveNavigationBar ? 64 : 0;
    self.bottomDistance = haveTabBar ? 49 : 0;
    [view addSubview:self];
    if (self.automaticShowDirection) {
        [self automaticChangeShowDirection];
    }
}


-(void)remove{
    [self removeFromSuperview];
}


#pragma mark - ******* Setters/Getters *******

- (void)setCanBeMoved:(BOOL)canBeMoved {
    
    _canBeMoved = canBeMoved;
    [self removeGestureRecognizer:self.pan];
    self.pan = nil;
}

- (CGFloat)disperseDistance {
    
    return _disperseDistance == 0 ? self.width + 30 : _disperseDistance;
}

#pragma mark - ******* UI *******

-(void)setupLayout{
    self.alpha = 1.0;
    if (self.canBeMoved) {
        _pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
        [self addGestureRecognizer:self.pan];
    }
    UIButton *coverBtn = ({
        coverBtn = [[UIButton alloc]initWithFrame:self.bounds];
        coverBtn.backgroundColor = [UIColor clearColor];
        [coverBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [coverBtn addTarget:self action:@selector(clickCoverBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:coverBtn];
        self.coverBtn = coverBtn;
        coverBtn;
    });
    
    UIButton *btn = ({
        btn = [[UIButton alloc]initWithFrame:self.bounds];
        [btn setTitle:self.btnTitle forState:UIControlStateNormal];
        [btn setTitle:self.selectTitle forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:self.btnImage] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:self.btnSelectImage] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.cornerRadius = self.bounds.size.height / 2.0;
        btn.layer.masksToBounds = YES;
        btn.layer.borderColor = MainColor.CGColor;
        btn.layer.borderWidth = 2.f;
        [self addSubview:btn];
        self.mainBtn = btn;
        btn;
    });
    
    self.colors = [self checkedWithArray:self.colors];
    self.subBtnImages = [self checkedWithArray:self.subBtnImages];
    self.subBtnSelectImages = [self checkedWithArray:self.subBtnSelectImages];
    
    NSInteger count = self.titlesArray.count > 0 ? self.titlesArray.count :self.subBtnImages.count;
    
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:self.titlesArray.count];
    
    for (int i = 0; i < count; i ++) {
        SButton *subBtn = ({
            subBtn = [[SButton alloc]initWithFrame:CGRectMake(2, 2, self.bounds.size.width - 4, self.bounds.size.height - 4)];
            subBtn.backgroundColor = self.colors[i];
            [subBtn setBackgroundImage:[UIImage imageNamed:self.subBtnImages[i]] forState:UIControlStateNormal];
            subBtn.titleLabel.font = [UIFont systemFontOfSize:13.f weight:0.5];//[UIFont boldSystemFontOfSize:13.f];
            [subBtn setBackgroundImage:[UIImage imageNamed:self.subBtnSelectImages[i]] forState:UIControlStateSelected];
            [subBtn setBackgroundImage:[UIImage imageNamed:self.subBtnHighLightImages[i]] forState:UIControlStateHighlighted];
            [subBtn setTitle:self.titlesArray[i] forState:UIControlStateNormal];
            [subBtn setTitle:self.selectTitlesAarray[i] forState:UIControlStateSelected];
            [subBtn addTarget:self action:@selector(clickSubBtn:) forControlEvents:UIControlEventTouchUpInside];
            [subBtn setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
            subBtn.layer.borderWidth = 2.f;
            subBtn.layer.borderColor = MainColor.CGColor;
            subBtn.layer.cornerRadius = subBtn.height * 0.5;
            subBtn.layer.masksToBounds = YES;
            if (i == 2) {
                subBtn.titleLabel.font = [UIFont systemFontOfSize:10.f weight:0.5];
            }
            subBtn.index = i;
            [self insertSubview:subBtn belowSubview:btn];
            subBtn;
        });
        [tempArray addObject:subBtn];
    }
    self.btnsArray = tempArray.copy;
}
/**
 *  自动算出按钮的方向
 */

-(void)automaticChangeShowDirection{
    
    CGFloat halfWidth = self.superview.width * 0.5;
    CGFloat halfHeight = self.superview.height * 0.5;
    
    if (self.centerX > halfWidth && self.centerY < halfHeight) {
        self.circleShowDirection = self.centerY - self.topDistance >= self.disperseDistance ? circleShowDirectionLeft : circleShowDirectionLeftDown;
        self.lineShowDirection = self.centerX < halfHeight * 2 - self.centerY ? lineShowDirectionDown : lineShowDirectionLeft;
    }
    else if (self.centerX > halfWidth && self.centerY > halfHeight) {
        self.circleShowDirection = (2 * halfHeight - self.centerY - self.bottomDistance) > self.disperseDistance ? circleShowDirectionLeft : circleShowDirectionLeftUp;
        self.lineShowDirection = self.centerX < self.centerY ? lineShowDirectionUp : lineShowDirectionLeft;
    }
    else if (self.centerX < halfWidth && self.centerY > halfHeight) {
        self.circleShowDirection = (2 * halfHeight - self.centerY - self.bottomDistance) > self.disperseDistance ? circleShowDirectionRight : circleShowDirectionRightUp;
        self.lineShowDirection = halfWidth * 2 - self.centerX < self.centerY ? lineShowDirectionUp : lineShowDirectionRight;
    }
    else if ((self.centerX < halfWidth && self.centerY < halfHeight)) {
        self.circleShowDirection = self.centerY - self.topDistance > self.disperseDistance ? circleShowDirectionRight: circleShowDirectionRightDown;
        self.lineShowDirection = halfWidth * 2 - self.centerX < halfHeight * 2 - self.centerY ? lineShowDirectionDown : lineShowDirectionRight;
    }

}


-(NSArray*)checkedWithArray:(NSArray*)array{
    if (self.titlesArray.count) {
        if (array.count == 0) {
            return nil;
        }else if(array.count == 1){
            NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:self.titlesArray.count];
            for (int i = 0; i < self.titlesArray.count; i ++) {
                [arrayM addObject:self.titlesArray.firstObject];
            }
            return [arrayM copy];
        }else{
            NSAssert(self.titlesArray.count == array.count, @"数组中值不一一对应");
            return array;
        }
    }else{
        NSAssert(self.subBtnImages.count == self.subBtnSelectImages.count, @"数组中值不一一对应");
        return array;
    }
}



#pragma mark - ******* Events *******

-(void)clickBtnNotification:(NSNotification*)sender{
    if (self.mainBtn.selected) {
        
        [self clickBtn:self.mainBtn];
    }
}

- (void)clickCoverBtn:(UIButton *)btn {
    
    if (self.mainBtn.selected) {
        
        [self clickBtn:self.mainBtn];
    }
}

/**
 *  点击主按钮
 */
- (void)clickBtn:(UIButton *)btn {
    weakSelf();
    btn.selected = !btn.selected;
    
    if (btn.selected) {
        btn.transform = CGAffineTransformMakeRotation(M_PI / 4);
        self.rect = self.frame;
        if (self.pan) {
            [self removeGestureRecognizer:self.pan];
        }
        
        [UIView animateWithDuration:1 delay:0.0 usingSpringWithDamping:self.showWithSpring ?  0.6 : 1.0 initialSpringVelocity:self.showWithSpring ? 10 : 0 options:UIViewAnimationOptionCurveLinear animations:^{
            
            self.alpha = 1.0;
            
            if (weakSelf.showSuperViewCenter) {
                
                weakSelf.center = self.superview.center;
                CGFloat angle = 2 * M_PI / weakSelf.btnsArray.count;
                for (int i = 0; i < weakSelf.btnsArray.count; i++) {
                    SButton *btn = weakSelf.btnsArray[i];
                    btn.center = CGPointMake(self.mainBtn.centerX + cos(angle * i) * (weakSelf.width + weakSelf.disperseDistance), self.mainBtn.centerY + sin(angle * i) * (weakSelf.height + weakSelf.disperseDistance));
                }
            }
            else {
                
                if (weakSelf.showType == showTypeOfLine) {
                    
                    [weakSelf lineShowButton];
                }
                else {
                    [weakSelf circleShowButton];
                }
            }
        } completion:^(BOOL finished) {
            
            weakSelf.coverBtn.size = CGSizeZero;
            weakSelf.coverBtn.origin = CGPointMake(-weakSelf.origin.x, -weakSelf.origin.y);
        }];
    }
    else {
        btn.transform = CGAffineTransformMakeRotation(M_PI / -2);
        if (weakSelf.pan) {
            
            [weakSelf addGestureRecognizer:weakSelf.pan];
        }
        
        [UIView animateWithDuration:0.35 animations:^{
            
            weakSelf.alpha = 1.0;
            weakSelf.frame = weakSelf.rect;
            weakSelf.coverBtn.size = weakSelf.size;
            weakSelf.coverBtn.center = weakSelf.mainBtn.center;
            
            for (SButton *btn in weakSelf.btnsArray) {
                btn.center = weakSelf.mainBtn.center;
            }
        }];
    }
}

- (void)circleShowButton {
    
    CGFloat angle = M_PI / (self.btnsArray.count - 1);
    
    for (int i = 0; i < self.btnsArray.count; i++) {
        
        SButton *btn = self.btnsArray[i];
        
        switch (self.circleShowDirection) {
            //靠左
            case circleShowDirectionLeft:
                btn.center = CGPointMake(self.mainBtn.centerX + BACK_GAUGE - sin(angle * i) * (self.disperseDistance - CORRECTION_CONEDDICIENT), self.mainBtn.centerY - cos(angle * i) * (self.disperseDistance - CORRECTION_CONEDDICIENT));
                break;
            case circleShowDirectionRight:
                btn.center = CGPointMake(self.mainBtn.centerX - BACK_GAUGE + sin(angle * i) * (self.disperseDistance - CORRECTION_CONEDDICIENT), self.mainBtn.centerY + cos(angle * i) * (self.disperseDistance - CORRECTION_CONEDDICIENT));
                break;
            case circleShowDirectionUp:
            {
                self.centerX = self.superview.centerX;
                btn.center = CGPointMake(self.mainBtn.centerX + sin(angle * i + M_PI_2) * (self.disperseDistance - CORRECTION_CONEDDICIENT), self.mainBtn.centerY + cos(angle * i + M_PI_2) * (self.disperseDistance - CORRECTION_CONEDDICIENT));
            }
                break;
            case circleShowDirectionDown:
            {
                self.centerX = self.superview.centerX;
                btn.center = CGPointMake(self.mainBtn.centerX + sin(angle * i - M_PI_2) * (self.disperseDistance - CORRECTION_CONEDDICIENT), self.mainBtn.centerY + cos(angle * i - M_PI_2) * (self.disperseDistance - CORRECTION_CONEDDICIENT));
            }
                break;
            case circleShowDirectionRightDown:
            {
                angle = M_PI_2 / (self.btnsArray.count - 1);
                btn.center = CGPointMake(self.mainBtn.centerX + sin(angle * i) * self.disperseDistance, self.mainBtn.centerY + cos(angle * i) * self.disperseDistance);
            }
                break;
            case circleShowDirectionRightUp:
            {
                angle = M_PI_2 / (self.btnsArray.count - 1);
                btn.center = CGPointMake(self.mainBtn.centerX + sin(angle * i + M_PI_2) * self.disperseDistance, self.mainBtn.centerY + cos(angle * i + M_PI_2) * self.disperseDistance);
            }
                break;
            case circleShowDirectionLeftUp:
            {
                angle = M_PI_2 / (self.btnsArray.count - 1);
                btn.center = CGPointMake(self.mainBtn.centerX - sin(angle * i) * self.disperseDistance, self.mainBtn.centerY - cos(angle * i) * + self.disperseDistance);
            }
                break;
            case circleShowDirectionLeftDown:
            {
                angle = M_PI_2 / (self.btnsArray.count - 1);
                btn.center = CGPointMake(self.mainBtn.centerX - sin(angle * i + M_PI_2) * self.disperseDistance, self.mainBtn.centerY - cos(angle * i + M_PI_2) * self.disperseDistance);
            }
                break;
            default:
                break;
        }
    }
}

- (void)lineShowButton {
    
    for (int i = 0; i < self.btnsArray.count; i++) {
        
        SButton *btn = self.btnsArray[i];
        
        switch (self.lineShowDirection) {
                
            case lineShowDirectionLeft:
                btn.centerX = self.mainBtn.centerX - self.disperseDistance * (i + 1);
                break;
            case lineShowDirectionRight:
                btn.centerX = self.mainBtn.centerX + self.disperseDistance * (i + 1);
                break;
            case lineShowDirectionUp:
                btn.centerY = self.mainBtn.centerY - self.disperseDistance * (i + 1);
                break;
            case lineShowDirectionDown:
                btn.centerY = self.mainBtn.centerY + self.disperseDistance * (i + 1);
                break;
            default:
                break;
        }
    }
}

- (void)clickSubBtn:(SButton *)btn {
    
    if (self.subBtnSelectImages.count > 0 || self.selectTitlesAarray.count > 0) {
        
        for (SButton *button in self.btnsArray) {
            button.selected = btn == button ? button.selected : NO;
        }
        btn.selected = !btn.selected;
    }
    
    if (self.clickSubButtonBack) {
        self.clickSubButtonBack(btn.index, btn.titleLabel.text, btn.selected);
    }
}

/**
 *  拖拽
 */
- (void)pan:(UIGestureRecognizer *)gesture {
    weakSelf();
    CGPoint point = [gesture locationInView:self.superview];
    
    self.center = point;
    
    if (gesture.state == UIGestureRecognizerStateChanged) {}
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
       __block CGRect rect = self.frame;

        if (self.centerX >= SCREEN_WIDTH * 0.5) {
            rect.origin.x = SCREEN_WIDTH - self.width - 1;
        }else if(self.centerX < self.width * 0.5 || self.centerX < SCREEN_WIDTH * 0.5){
            rect.origin.x = 0;
        }

        if (self.y < self.topDistance) {
            rect.origin.y = self.topDistance;
        }else if (self.y > SCREEN_HEIGHT - self.height - self.bottomDistance) {
            rect.origin.y = SCREEN_HEIGHT - self.height - self.bottomDistance - 1;
        }
        [UIView animateWithDuration:0.45 animations:^{
             weakSelf.frame = rect;
        }];
       
        if (weakSelf.automaticShowDirection) {
            [weakSelf automaticChangeShowDirection];
        }
    }
}

/**
 *  超出部分点击事件
 */
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    UIView *view = [super hitTest:point withEvent:event];
    if (view == nil) {
        
        for (UIView *v in self.subviews) {
            
            CGPoint tempoint = [v convertPoint:point fromView:self];
            if (CGRectContainsPoint(v.bounds, tempoint))
            {
                view = v;
            }
        }
    }
    return view;
}



+(instancetype)sharSfoldawayButton{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SFoldawayModel *model = [[SFoldawayModel alloc]initWithMainBtnTitle:nil selectTitle:nil image:@"tabar" selectImage:nil];
        model.subBtnTitles = @[@"黑夜", @"消息", @"心情物语", @"配对", @"联系人"];
        model.subBtnImages = @[@"button",@"button",@"button",@"button",@"button"];
        CGFloat foldawayBtn_W = SCREEN_WIDTH * 0.14;
        singlton = [[SFoldawayButton alloc] initWithRect:CGRectMake(SCREEN_WIDTH - foldawayBtn_W - 1, SCREEN_HEIGHT - foldawayBtn_W - 1, foldawayBtn_W, foldawayBtn_W) andFoldAwayModel:model];
    });
    return singlton;
}


@end






















