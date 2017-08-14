//
//  SSetTabViewCell.m
//  BootyCall
//
//  Created by mac on 16/8/13.
//  Copyright © 2016年 dazhongdiy. All rights reserved.
//

#import "SSetTabViewCell.h"

@interface SSetTabViewCell ()

/**功能图标*/
@property(nonatomic,strong)UIImageView                      *siconImageView;
/**功能标签*/
@property(nonatomic,strong)UILabel                          *sfunctionL;

-(void)initializeUserInterface;/**< 初始化用户界面 */

@end

@implementation SSetTabViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initializeUserInterface];
    }
    return self;
}

-(void)initializeUserInterface{
    [self.contentView addSubview:self.siconImageView];
    [_siconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(20);
        make.width.equalTo(@24);
        make.height.equalTo(_siconImageView.mas_width);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    [self.contentView addSubview:self.sfunctionL];
    [_sfunctionL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.left.equalTo(_siconImageView.mas_right).offset(20);
        make.height.equalTo(@32);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
}


#pragma mark - ******* Setters *******

-(void)setModels:(NSArray *)models{
    _models = models;
    _siconImageView.image = [UIImage imageNamed:models[0]];
    _sfunctionL.text = models[1];
}


#pragma mark - ******* Getters *******


-(UIImageView *)siconImageView{
    if (!_siconImageView) {
        _siconImageView = ({
            UIImageView *imageView = [[UIImageView alloc]init];
            imageView.backgroundColor = [UIColor clearColor];
            imageView;
        });
    }
    return _siconImageView;
}

-(UILabel *)sfunctionL{
    if (!_sfunctionL) {
        _sfunctionL = ({
            UILabel *label = [[UILabel alloc]init];
            label.numberOfLines = 1;
            label.backgroundColor = [UIColor clearColor];
            //label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor blackColor];
            label.font = [UIFont systemFontOfSize:16.f];
            label;
        });
    }
    return _sfunctionL;
}


@end
