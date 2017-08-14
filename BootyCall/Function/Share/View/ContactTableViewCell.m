//
//  ContactTableViewCell.m
//  BootyCall
//
//  Created by rimi on 16/8/26.
//  Copyright © 2016年 dazhongdiy. All rights reserved.
//

#import "ContactTableViewCell.h"


@interface ContactTableViewCell()

/**
 *  头像
 */
@property(nonatomic,strong)UIImageView *headImage;
/**
 *  昵称
 */
@property(nonatomic,strong)UILabel *nameLabel;
/**
 *  分割线
 */
@property(nonatomic,strong)UIView *lineView;





@end

@implementation ContactTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        
        [self initalizeInterface];
        
    }

    return self;
}

-(void)initalizeInterface {

    [self.contentView addSubview:self.headImage];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.lineView];
    [self makeConstarint];


}
-(void)makeConstarint {
    weakSelf();
  [self.headImage mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(weakSelf.contentView.mas_left).offset(10);
      make.top.equalTo(weakSelf.contentView.mas_top).offset(10);
      make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-10);
      make.width.equalTo(@50);
  }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.headImage.mas_right).offset(10);
        make.top.equalTo(weakSelf.contentView.mas_top).offset(10);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-0);
        
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).offset(10);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-10);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-5);
        make.height.equalTo(@0.6);
    }];

}


#pragma mark - Setter 
-(void)setModel:(ContactModel *)model {

    _model = model;
    [_headImage sd_setImageWithURL:[NSURL URLWithString:model.headImageUrl]];
    _nameLabel.text = model.name;

}

#pragma mark - Getter

-(UIImageView *)headImage {


    if (_headImage == nil) {
        
        _headImage = [[UIImageView alloc]initWithFrame:CGRectZero];
        _headImage.layer.cornerRadius = 6;
        _headImage.layer.masksToBounds =  YES;
     
    }
    return _headImage;

}

-(UILabel *)nameLabel {

    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.font = [UIFont systemFontOfSize:16];

    }
    return _nameLabel;

}

-(UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc]initWithFrame:CGRectZero];
        _lineView.backgroundColor = BgColor;
    }
    return _lineView;
}

@end
