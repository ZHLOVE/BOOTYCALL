//
//  QPairTableViewCell.m
//  BootyCall
//
//  Created by rimi on 16/8/13.
//  Copyright © 2016年 dazhongdiy. All rights reserved.
//

#import "QPairTableViewCell.h"
#import <UIImageView+WebCache.h>
#import "MResponseUserInfo.h"

@interface QPairTableViewCell ()
/**
 *  头像
 */
@property(nonatomic,strong)UIImageView *AvatarImageView;

/**
 *  nameLabel
 */
@property(nonatomic,strong)UILabel *nameLabel;
/**
 *  infoLabel
 */
@property(nonatomic,strong)UILabel *infoLabel;
/**
 *  个性签名
 */
@property(nonatomic,strong)UILabel *personnLabel;

/**
 *  detailInfoBtn
 */
@property(nonatomic,strong)UIButton *detailInfoBtn;
/**
 *  背景
 */
@property(nonatomic,strong)UIImageView *bgImageView;




@end

@implementation QPairTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {


    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initializeInterface];
        
    }
    return self;

}

-(void)initializeInterface {
    [self.contentView addSubview:self.bgImageView];
    [self.bgImageView addSubview:self.nameLabel];
    [self.bgImageView addSubview:self.AvatarImageView];
    [self.bgImageView addSubview:self.infoLabel];
    [self.bgImageView addSubview:self.personnLabel];
    [self.bgImageView addSubview:self.detailInfoBtn];
    [self makeConstraint];


}
-(void)makeConstraint {

  [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(self.contentView.mas_left);
      make.top.equalTo(self.contentView.mas_top);
      make.bottom.equalTo(self.contentView.mas_bottom);
      make.right.equalTo(self.contentView.mas_right);
    
  }];
    
    [self.AvatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.bgImageView.mas_left).offset(10);
        make.top.equalTo(self.bgImageView.mas_top).offset(10);
        make.bottom.equalTo(self.bgImageView.mas_bottom).offset(-10);
        make.width.equalTo(self.AvatarImageView.mas_height);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.AvatarImageView.mas_right).offset(10);
        make.top.equalTo(self.bgImageView.mas_top).offset(10);
        make.height.equalTo(self.contentView).multipliedBy(0.25);
        make.width.equalTo(self.contentView).multipliedBy(0.25);
        
    }];
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.AvatarImageView.mas_right).offset(10);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
        make.height.equalTo(self.contentView).multipliedBy(0.25);
        make.width.equalTo(self.contentView).multipliedBy(0.25);
    }];
    [self.personnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.AvatarImageView.mas_right).offset(10);
        make.top.equalTo(self.infoLabel.mas_bottom).offset(5);
        make.height.equalTo(self.contentView).multipliedBy(0.25);
        make.width.equalTo(self.contentView).multipliedBy(0.25);
        
    }];
    
    [self.detailInfoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.bgImageView.mas_right).offset(-20);
        make.centerY.equalTo(self.bgImageView.mas_centerY);
        make.height.equalTo(self.contentView).multipliedBy(0.3);
        make.width.equalTo(self.contentView).multipliedBy(0.25);
    }];


}


#pragma mark - Method 

-(void)DetailInfoButtonAction:(UIButton *)sender {

    if (_delegate && [_delegate respondsToSelector:@selector(clickDetailInfoButtonEvent:username:)]) {
        
        [_delegate clickDetailInfoButtonEvent:self.model.userId username:@"123"];
    }

}

#pragma mark - Getter
- (UIImageView *)AvatarImageView {

    if (_AvatarImageView == nil) {
        
        _AvatarImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
//        _AvatarImageView.backgroundColor = [UIColor purpleColor];
        
        _AvatarImageView.layer.cornerRadius = 6;
        _AvatarImageView.layer.masksToBounds = YES;
        
    }
    return _AvatarImageView;


}
-(UILabel *)nameLabel {


    if (_nameLabel == nil) {
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _nameLabel.font = [UIFont systemFontOfSize:16 weight:15];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.text = @"12312312312";
//        _nameLabel.backgroundColor = [UIColor blueColor];
        
    }

    return _nameLabel;
    
}


-(UILabel *)infoLabel {


    if (_infoLabel== nil) {
        
        _infoLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _infoLabel.font = [UIFont systemFontOfSize:14];
        _infoLabel.textColor = [UIColor grayColor];
//        _infoLabel.backgroundColor = [UIColor yellowColor];
        _infoLabel.text = @"sdfkjasjdfg";
        
        
    }
    
    return _infoLabel;

}

-(UILabel *)personnLabel {

    if (_personnLabel== nil) {
        
        _personnLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _personnLabel.font = [UIFont systemFontOfSize:14];
        _personnLabel.textColor = [UIColor blackColor];
//        _personnLabel.backgroundColor = [UIColor greenColor];
        _personnLabel.text = @"askdfuclasjdoa";
        
    }
    
    return _personnLabel;

}

- (UIButton *)detailInfoBtn {

    if (_detailInfoBtn == nil) {
        
        _detailInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _detailInfoBtn.backgroundColor = [UIColor cyanColor];
        [_detailInfoBtn setTitle:@"聊天呗" forState:UIControlStateNormal];
        _detailInfoBtn.titleLabel.font = [UIFont systemFontOfSize:20 weight:12];
        _detailInfoBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_detailInfoBtn addTarget:self action:@selector(DetailInfoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }

    return _detailInfoBtn;

}


-(UIImageView *)bgImageView {


    if (_bgImageView == nil) {
        _bgImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
//        _bgImageView.backgroundColor = [UIColor redColor];
        _bgImageView.userInteractionEnabled = YES;
    }
    return _bgImageView;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

-(void)setModel:(QPairModel *)model {

    _model = model;
 
//    AVFile *file = model.albumArray[0];
    if (model.headImageUrl == nil ) {
        self.AvatarImageView.image = [UIImage imageNamed:@"yue"];
    }else {
        [self.AvatarImageView sd_setImageWithURL:[NSURL URLWithString:model.headImageUrl ] placeholderImage:[UIImage imageNamed:@"yue"]];
    }
    
     self.nameLabel.text = model.name;
    self.infoLabel.text = [NSString stringWithFormat:@"gender:%@",model.gender];
    self.personnLabel.text = model.userId;
 
//    [self.AvatarImageView sd_setImageWithURL:[NSURL URLWithString:file.url]];
//    NSLog(@"file %@",file);
//    self.nameLabel.text = model.myInfo[@"name"];
    
   
    

}


@end
