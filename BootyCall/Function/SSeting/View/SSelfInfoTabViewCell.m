//
//  SSelfInfoTabViewCell.m
//  BootyCall
//
//  Created by mac on 16/8/13.
//  Copyright © 2016年 dazhongdiy. All rights reserved.
//

#import "SSelfInfoTabViewCell.h"

@interface SSelfInfoTabViewCell ()

/**功能图标*/
@property(nonatomic,strong)UILabel                          *stextLabel;


-(void)initializeUserInterface;/**< 初始化用户界面 */

@end

@implementation SSelfInfoTabViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initializeUserInterface];
    }
    return self;
}

-(void)initializeUserInterface{
    
    [self.contentView addSubview:self.stextLabel];
    [_stextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@100);
        make.left.equalTo(self.contentView.mas_left).offset(20);
        make.height.equalTo(@32);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];

    [self.contentView addSubview:self.sinfoTextF];
    [_sinfoTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-20);
        make.left.equalTo(_stextLabel.mas_right).offset(10);
        make.height.equalTo(@32);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
}


#pragma mark - ******* Setters *******

-(void)setModels:(NSArray *)models{
    _models = models;
    _stextLabel.text = models[0];
    _sinfoTextF.text = models[1];
}


#pragma mark - ******* Getters *******

-(UILabel *)stextLabel{
    if (!_stextLabel) {
        _stextLabel = ({
            UILabel *label = [[UILabel alloc]init];
            label.numberOfLines = 1;
            label.backgroundColor = [UIColor clearColor];
            //label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor blackColor];
            label.font = [UIFont systemFontOfSize:16.f];
            label;
        });
    }
    return _stextLabel;
}

-(UITextField *)sinfoTextF{
    if (!_sinfoTextF) {
        _sinfoTextF = ({
            UITextField *textField = [[UITextField alloc]init];
            textField.backgroundColor = [UIColor clearColor];
            textField.textAlignment = NSTextAlignmentRight;
            textField.font = [UIFont systemFontOfSize:14.f];
            textField.textColor = [UIColor grayColor];
            textField.userInteractionEnabled = NO;
            textField;
        });
    }
    return _sinfoTextF;
}


@end
