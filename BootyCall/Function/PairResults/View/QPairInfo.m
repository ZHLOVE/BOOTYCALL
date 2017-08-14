//
//  QPairInfo.m
//  BootyCall
//
//  Created by rimi on 16/8/16.
//  Copyright © 2016年 dazhongdiy. All rights reserved.
//

#import "QPairInfo.h"


@interface QPairInfo ()

/**
 *  namelabel
 */
@property(nonatomic,strong)UILabel  *nameLabel;
/**
 *  infolabel
 */
@property(nonatomic,strong)UILabel *infoLabel;
/**
 *  兴趣
 */
@property(nonatomic,strong)UILabel *interestLabel;
/**
 *  头像
 */
@property(nonatomic,strong)UIImageView *avatorImage;
/**
 *  背景
 */
@property(nonatomic,strong)UIImageView *bgImageView;
/**
 *  聊天按钮
 */
@property(nonatomic,strong)UIButton *chatBtn;




@end

@implementation QPairInfo


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeInterface];
    }
    return self;
}

-(void)initializeInterface{
 
    [self addSubview:self.bgImageView];
    [self.bgImageView addSubview:self.nameLabel];
    [self.bgImageView addSubview:self.infoLabel];
    [self.bgImageView addSubview:self.interestLabel];
    [self.bgImageView addSubview:self.chatBtn];
    [self.bgImageView addSubview:self.avatorImage];
    [self makeConstraint];
    



}

#pragma mark - Mehtod

-(void)makeConstraint {

    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgImageView.mas_left).offset(10);
        make.top.equalTo(self.bgImageView.mas_top).offset(10);
        make.height.equalTo(self.bgImageView.mas_height).multipliedBy(0.3);
        make.width.equalTo(self.bgImageView.mas_width).multipliedBy(0.5);
    }];
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.bgImageView.mas_left).offset(10);
        make.centerY.equalTo(self.bgImageView.mas_centerY);
        make.height.equalTo(self.bgImageView.mas_height).multipliedBy(0.3);
        make.width.equalTo(self.bgImageView.mas_width).multipliedBy(0.4);
    }];
    [self.interestLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgImageView.mas_left).offset(10);
        make.bottom.equalTo(self.bgImageView.mas_bottom).offset(-10);
        make.height.equalTo(self.bgImageView.mas_height).multipliedBy(0.3);
        make.width.equalTo(self.bgImageView.mas_width).multipliedBy(0.5);
    }];
    [self.avatorImage mas_makeConstraints:^(MASConstraintMaker *make) {
    
        make.right.equalTo(self.bgImageView.mas_right).offset(-10);
        make.top.equalTo(self.bgImageView.mas_top).offset(10);
        make.height.and.width.equalTo(self.bgImageView.mas_height).multipliedBy(0.4);
        
    }];
    [self.chatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgImageView.mas_right).offset(-5);
        make.bottom.equalTo(self.bgImageView.mas_bottom).offset(-10);
        make.height.equalTo(self.bgImageView.mas_height).multipliedBy(0.3);
        make.width.equalTo(self.bgImageView.mas_width).multipliedBy(0.2);
        
    }];
    
    
    

}

-(void)chatButtonAction:(UIButton *)sender {


    [[NSNotificationCenter defaultCenter]postNotificationName:@"QPairchat" object:nil userInfo:@{@"userId":self.model.userId,@"name":self.model.name}];
  


}

#pragma mark - GETTER
-(UILabel *)nameLabel {
    if (_nameLabel == nil) {
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _nameLabel.text = @"昵称:";
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont systemFontOfSize:15];
        
    }
    return _nameLabel;

}

-(UILabel *)infoLabel {

    if (_infoLabel == nil) {
        
        _infoLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _infoLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _infoLabel.text = @"信息:";
        _infoLabel.textColor = [UIColor whiteColor];
        _infoLabel.font = [UIFont systemFontOfSize:15];
    }


    return _infoLabel;
}

-(UILabel *)interestLabel {

    if (_interestLabel == nil) {
        
        _interestLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _interestLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _interestLabel.text = @"个性签名:";
        _interestLabel.textColor = [UIColor whiteColor];
        _interestLabel.font = [UIFont systemFontOfSize:15];
    }
    
    
    return _interestLabel;

}


-(UIImageView *)avatorImage {
    if (_avatorImage == nil) {
        
        _avatorImage = [[UIImageView alloc]initWithFrame:CGRectZero];
        _avatorImage.layer.cornerRadius = 6;
        _avatorImage.layer.masksToBounds = YES;
    }
    return _avatorImage;

   

}

-(UIImageView *)bgImageView {
    
    
    if (_bgImageView == nil) {
        _bgImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        //        _bgImageView.backgroundColor = [UIColor redColor];
        _bgImageView.userInteractionEnabled = YES;
    }
    return _bgImageView;
    
}
-(UIButton *)chatBtn {


    if (_chatBtn == nil) {
      _chatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
       _chatBtn.backgroundColor = [UIColor clearColor];
      [_chatBtn setTitle:@"聊天呗" forState:UIControlStateNormal];
      _chatBtn.titleLabel.font = [UIFont systemFontOfSize:20 weight:12];
        _chatBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [_chatBtn addTarget:self action:@selector(chatButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }

    return _chatBtn;
}
#pragma mark - SETTER
-(void)setModel:(QPairModel *)model {
    _model = model;

     _nameLabel.text = @"昵称:";
    if (model.headImageUrl == nil) {
        self.avatorImage.image = [UIImage imageNamed:@"yue"];
    }else {
        [self.avatorImage sd_setImageWithURL:[NSURL URLWithString:model.headImageUrl]  placeholderImage:[UIImage imageNamed:@"yue"]];
    }
    
    self.nameLabel.text =  [NSString stringWithFormat:@"%@%@",self.nameLabel.text,model.name];
    if ([model.gender isEqualToString:@"1"]) {
      self.infoLabel.text =  [NSString stringWithFormat:@"性别:%@",@"女"];
    }else {
    
    self.infoLabel.text =  [NSString stringWithFormat:@"性别:%@",@"男"];
    }
    self.interestLabel.text =  [NSString stringWithFormat:@"%@%@",self.interestLabel.text, model.signature];


}

@end
