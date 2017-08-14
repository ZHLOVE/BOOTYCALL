//
//  LeasCustomView.m
//  BootyCall
//
//  Created by dazhongdiy on 16/8/11.
//  Copyright © 2016年 dazhongdiy. All rights reserved.
//

#import "LeasCustomView.h"
#import "UIImageView+WebCache.h"



@interface LeasCustomView ()

@property (strong, nonatomic) UIImageView *imageView;
/**
 *  名字
 */
@property (strong, nonatomic) UILabel     *titleLabel;
/**
 *  年龄
 */
@property (strong, nonatomic) UILabel     *agaLabel;
/**
 *  签名
 */
@property (strong, nonatomic) UILabel     *signatureLabel;
@property (nonatomic,strong)  UILabel     *distanceLabel;



@end

@implementation LeasCustomView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self loadComponent];
    }
    return self;
}

- (void)loadComponent {
    self.backgroundColor = RGB_COLOR(218, 211, 197, 1);
    self.layer.borderColor = MainColor.CGColor;
    self.layer.borderWidth = 1;
    self.imageView = [[UIImageView alloc] init];
    self.titleLabel = [[UILabel alloc] init];
    self.agaLabel = [[UILabel alloc]init];
    self.signatureLabel = [[UILabel alloc]init];
    self.distanceLabel = [[UILabel alloc]init];
    
    self.titleLabel.backgroundColor = BgColor;
    self.agaLabel.backgroundColor = BgColor;
//    self.signatureLabel.backgroundColor = [UIColor orangeColor];
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.imageView.layer setMasksToBounds:YES];
    
    self.titleLabel.textColor = [UIColor grayColor];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    //===
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.layer.cornerRadius = 2;
    self.titleLabel.clipsToBounds = YES;
    self.agaLabel.textColor = [UIColor grayColor];
    self.agaLabel.textAlignment = NSTextAlignmentLeft;
    self.agaLabel.font = [UIFont systemFontOfSize:15];
    self.agaLabel.layer.cornerRadius = 2;
    self.agaLabel.clipsToBounds = YES;
    self.signatureLabel.textColor = [UIColor grayColor];
    self.signatureLabel.textAlignment = NSTextAlignmentLeft;
    self.signatureLabel.font = [UIFont systemFontOfSize:14];
    self.signatureLabel.numberOfLines = 2;
    self.distanceLabel.textColor = RGB_COLOR(134, 134, 134, 0.5);
    self.distanceLabel.textAlignment = NSTextAlignmentLeft;
    self.distanceLabel.font = [UIFont systemFontOfSize:12];
    //self.distanceLabel.text = @"♡10km";
    
    [self addSubview:self.imageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.agaLabel];
    [self addSubview:self.signatureLabel];
    [self addSubview:self.distanceLabel];
    
    self.backgroundColor = [UIColor colorWithRed:0.951 green:0.951 blue:0.951 alpha:1.00];
}

- (void)leas_layoutSubviews {
    __weak typeof(self) weakSelf = self;
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).offset(0);
        make.top.equalTo(weakSelf.mas_top).offset(0);
        make.width.equalTo(weakSelf.mas_width);
        make.height.equalTo(@(weakSelf.frame.size.width-64));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).offset(2);
        make.top.equalTo(weakSelf.imageView.mas_bottom).offset(2);
        //make.width.equalTo(@150);
        make.height.equalTo(@20);
    }];
    [self.signatureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.agaLabel.mas_bottom).offset(0);
        make.left.equalTo(weakSelf.mas_left).offset(2);
        make.height.equalTo(@44);
        make.width.equalTo(@(weakSelf.frame.size.width-20));
    }];
    [self.distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.titleLabel.mas_right).offset(5);
        make.bottom.equalTo(weakSelf.titleLabel.mas_bottom).offset(0);
        make.height.equalTo(@20);
    }];
    [self.agaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.imageView.mas_bottom).offset(2);
        make.left.equalTo(weakSelf.distanceLabel.mas_right).offset(30);
        //make.width.equalTo(@100);
        make.height.equalTo(@20);
    }];
    self.maskView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 64);
}

- (void)installData:(NSDictionary *)element {
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:element[@"image"]]];
    self.titleLabel.text = [NSString stringWithFormat:@"%@",element[@"name"]];
    self.agaLabel.text = [NSString stringWithFormat:@"%@,%@",element[@"age"],element[@"gender"]];
    self.signatureLabel.text = [NSString stringWithFormat:@"个性签名:%@",element[@"signature"]];
    self.distanceLabel.text = [NSString stringWithFormat:@"♡\t%@m",element[@"distance"]];
}



@end
