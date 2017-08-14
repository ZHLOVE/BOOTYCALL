//
//  DiaryTableViewCell.m
//  BootyCall
//
//  Created by rimi on 16/8/20.
//  Copyright © 2016年 dazhongdiy. All rights reserved.
//

#import "DiaryTableViewCell.h"

@interface DiaryTableViewCell()
/**
 *  文本背景图
 */
@property(nonatomic,strong)UIImageView *contentBg;
/**
 *  title
 */
@property(nonatomic,strong)UILabel *titleLabel;
/**
 *  分类
 */
@property(nonatomic,strong)UILabel *classifyLabel;
/**
 *  content
 */
@property(nonatomic,strong)UILabel *contentLabel;
/**
 *背景图
 */
@property(nonatomic,strong)UIView *bgview;
/**
 *  横线
 */
@property(nonatomic,strong)UIView *lineView;





@end

@implementation DiaryTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {


   self  =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView setBackgroundColor:BgColor];
        [self initializeInterface];

    }
    return self;

}

-(void)initializeInterface {
    [self.contentView addSubview:self.bgview];
    [self.contentView addSubview:self.contentBg];
    [self.contentView addSubview:self.titleLabel];
    [self.bgview addSubview:self.classifyLabel];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.lineView];
    [self makeConstraint];

}

-(void)makeConstraint {
    weakSelf();
   
    [self.contentBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).offset(10);
        make.top.equalTo(weakSelf.contentView.mas_top).offset(10);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-10);
//        make.width.and.height.equalTo(weakSelf.bgview.mas_height);
        make.width.equalTo(@50);
        
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentBg.mas_right).offset(15);
        make.top.equalTo(weakSelf.contentBg.mas_top).offset(10);
        make.height.equalTo(weakSelf.contentView.mas_height).multipliedBy(0.2);
        make.width.equalTo(weakSelf.contentView.mas_width).multipliedBy(0.3);
    
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentBg.mas_right).offset(15);
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(10);
        make.height.equalTo(weakSelf.contentView.mas_height).multipliedBy(0.2);
        make.width.equalTo(weakSelf.contentView.mas_width).multipliedBy(0.4);
    }];
  
    [self.classifyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-10);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-10);
        make.height.equalTo(weakSelf.contentView.mas_height).multipliedBy(0.23);
        
    }];
    [self.bgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-10);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-10);
        make.width.equalTo(weakSelf.classifyLabel.mas_width);
        make.height.equalTo(weakSelf.contentView.mas_height).multipliedBy(0.25);
        
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).offset(10);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-10);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(0);
        make.height.equalTo(@0.6);
    
    }];
}

#pragma mark - Getter

- (UIView *)bgview {

    if (_bgview == nil) {
        _bgview = [[UIView alloc]initWithFrame:CGRectZero];
        _bgview.backgroundColor = MainColor;
    }
    return _bgview;

}

- (UIImageView *)contentBg {

    if (_contentBg == nil) {
        
        _contentBg = [[UIImageView alloc]initWithFrame:CGRectZero];
        _contentBg.layer.cornerRadius = 6;
        _contentBg.layer.masksToBounds = YES;
//        _contentBg.backgroundColor = [UIColor redColor];
        
    }
    return _contentBg;

}

-(UILabel *)titleLabel {

    if (_titleLabel == nil) {
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = [UIColor blackColor];
//        _titleLabel.backgroundColor = [UIColor cyanColor];
    }
    return _titleLabel;


}

- (UILabel *)contentLabel {

    if (_contentLabel == nil) {
        
        _contentLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.textColor = [UIColor grayColor];
        
//        _contentLabel.backgroundColor = [UIColor greenColor];
    }
    return _contentLabel;


}
- (UILabel *)classifyLabel {
    if (_classifyLabel == nil) {
        
        _classifyLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _classifyLabel.font = [UIFont systemFontOfSize:13 weight:11];
        _classifyLabel.textAlignment = NSTextAlignmentLeft;
        _classifyLabel.textColor = [UIColor blackColor];
        
    }
    return _classifyLabel;

}
-(UIView *)lineView {
    
    if (!_lineView) {
        _lineView = [[UIView alloc]initWithFrame:CGRectZero];
        _lineView.backgroundColor = [UIColor grayColor];
    }
    return _lineView;
    
}
#pragma mark - Setter
- (void)setModel:(DiaryModel *)model {

    _model = model;
    
    _titleLabel.text = model.title;
    _contentLabel.text = model.content;
    
    if (model.backgroundImage == nil) {
        
    }else{
    
        [_contentBg sd_setImageWithURL:[NSURL URLWithString:model.backgroundImage] placeholderImage:[UIImage imageNamed:@"yue"]];
        
    }
   _classifyLabel.text =  [NSString stringWithFormat:@"#%@",model.classify];
    
}




@end
