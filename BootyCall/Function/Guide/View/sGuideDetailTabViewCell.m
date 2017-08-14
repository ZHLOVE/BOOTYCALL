//
//  sGuideDetailTabViewCell.m
//  BootyCall
//
//  Created by mac on 16/8/12.
//  Copyright © 2016年 dazhongdiy. All rights reserved.
//

#import "sGuideDetailTabViewCell.h"
#import "SCustomView.h"

@interface sGuideDetailTabViewCell ()
/**图片*/
@property(nonatomic,strong)UIImageView                      *simageView;
/**标题*/
@property(nonatomic,strong)UILabel                          *stitleLabel;
/**功能描述*/
@property(nonatomic,strong)UILabel                          *sfuncDescriptionL;
/**1*/
@property(nonatomic,strong)UILabel                          *spointOneL;
/**2*/
@property(nonatomic,strong)UILabel                          *spointTwoL;
/**遮罩大小*/
@property(nonatomic,assign)CGRect                           sbounds;

-(void)initializeUserInterface;/**< 初始化用户界面 */
@end

@implementation sGuideDetailTabViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initializeUserInterface];
    }
    return self;
}

-(void)initializeUserInterface{
    [self.contentView addSubview:self.stitleLabel];
    [_stitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(20);
        make.left.equalTo(self.contentView.mas_left).offset(30);
        make.right.equalTo(self.contentView.mas_right).offset(-30);
    }];
    [self.contentView addSubview:self.simageView];
    [_simageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stitleLabel.mas_bottom).offset(20);
        make.left.equalTo(self.contentView.mas_left).offset(30);
        make.right.equalTo(self.contentView.mas_right).offset(-30);
        make.height.equalTo(@200);
    }];
    SCustomView *scutomView = [[SCustomView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 60, 200)];
    [scutomView setWhiteValue:0.2 alphaValue:0.7];
    [_simageView addSubview:scutomView];
    
    [self.contentView addSubview:self.sfuncDescriptionL];
    [_sfuncDescriptionL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_simageView.mas_bottom).offset(20);
        make.right.equalTo(self.contentView.mas_right).offset(-30);
        make.left.equalTo(self.contentView.mas_left).offset(30);
    }];
    
    [self.contentView addSubview:self.spointOneL];
    [_spointOneL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_sfuncDescriptionL.mas_bottom).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-30);
        make.left.equalTo(self.contentView.mas_left).offset(30);
    }];
    
    [self.contentView addSubview:self.spointTwoL];
    [_spointTwoL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_spointOneL.mas_bottom).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-30);
        make.left.equalTo(self.contentView.mas_left).offset(30);
        //make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
    }];
    
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.top.equalTo(_spointTwoL.mas_bottom).offset(5);
        make.right.equalTo(self.contentView.mas_right).offset(-30);
        make.left.equalTo(self.contentView.mas_left).offset(30);
        make.height.equalTo(@1);
        make.top.equalTo(_spointTwoL.mas_bottom);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(0);
    }];
}


-(void)setModels:(NSArray *)models{
    _models = models;
    if ([models[0] length] == 0) {
        [_stitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
    }else{
        _stitleLabel.text = models[0];
    }
    if([models[1] length] == 0){
        [_simageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
    }else {
        _simageView.image = [UIImage imageNamed:models[1]];
    }
    _sfuncDescriptionL.text = models[2];
    _spointOneL.text = models[3];
    _spointTwoL.text = models[4];
}


#pragma mark - ******* Getters *******

-(UILabel *)stitleLabel{
    if (!_stitleLabel) {
        _stitleLabel = ({
            UILabel *label = [[UILabel alloc]init];
            label.numberOfLines = 0;
            label.backgroundColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:25.f];
            label.textColor = MainColor;
            label;
        });
    }
    return _stitleLabel;
}

-(UIImageView *)simageView{
    if (!_simageView) {
        _simageView = ({
            UIImageView *imageView = [[UIImageView alloc]init];
            imageView.backgroundColor = [UIColor whiteColor];
            imageView.layer.cornerRadius = 6.f;
            imageView.layer.masksToBounds = YES;
            imageView;
        });
    }
    return _simageView;
}

-(UILabel *)sfuncDescriptionL{
    if (!_sfuncDescriptionL) {
        _sfuncDescriptionL = ({
            UILabel *label = [[UILabel alloc]init];
            label.numberOfLines = 0;
            label.backgroundColor = [UIColor whiteColor];
            label.textColor = [UIColor blackColor];
            label.font = [UIFont systemFontOfSize:18.f];
            label;
        });
    }
    return _sfuncDescriptionL;
}
-(UILabel *)spointOneL{
    if (!_spointOneL) {
        _spointOneL = ({
            UILabel *label = [[UILabel alloc]init];
            label.numberOfLines = 0;
            label.backgroundColor = [UIColor whiteColor];
            label.textColor = [UIColor lightGrayColor];
            label.font = [UIFont systemFontOfSize:16.f];
            label;
        });
    }
    return _spointOneL;
}
-(UILabel *)spointTwoL{
    if (!_spointTwoL) {
        _spointTwoL = ({
            UILabel *label = [[UILabel alloc]init];
            label.numberOfLines = 0;
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont systemFontOfSize:16.f];
            label.textColor = [UIColor lightGrayColor];
            label;
        });
    }
    return _spointTwoL;
}


@end










