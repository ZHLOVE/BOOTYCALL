
//
//  QShowDiaryViewController.m
//  BootyCall
//
//  Created by rimi on 16/8/22.
//  Copyright © 2016年 dazhongdiy. All rights reserved.
//

#import "QShowDiaryViewController.h"

@interface QShowDiaryViewController ()

/**
 *  titile
 */
@property(nonatomic,strong)UILabel *titleLabel;
/**
 *  content
 */
@property(nonatomic,strong)UITextView *contentView;
/**
 *  上传时间
 */
@property(nonatomic,strong)UILabel *timeLabel;
/**
 *  背景
 */
@property(nonatomic,strong)UIImageView *contentBg;


@end

@implementation QShowDiaryViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setValueForProperty];
    self.title = self.model.title;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeInterface];
    
}
-(void)initializeInterface {
    
//    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.timeLabel];
    [self.view addSubview:self.contentBg];
    [self.contentBg addSubview:self.contentView];

    [self makeConstraint];

}

-(void)makeConstraint {
    weakSelf();
//    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.top.equalTo(weakSelf.view.mas_top).offset(64);
//        make.left.equalTo(weakSelf.view.mas_left);
//        make.width.equalTo(weakSelf.view.mas_width);
//        make.height.equalTo(@40);
//        
//    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(weakSelf.titleLabel.mas_bottom);
//        make.left.equalTo(weakSelf.view.mas_left);
//        make.width.equalTo(weakSelf.view.mas_width);
//        make.height.equalTo(@40);
        make.top.equalTo(weakSelf.view.mas_top).offset(64);
        make.left.equalTo(weakSelf.view.mas_left);
        make.width.equalTo(weakSelf.view.mas_width);
        make.height.equalTo(@40);
    }];
    
    
    
    [self.contentBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.timeLabel.mas_bottom);
        make.left.equalTo(weakSelf.view.mas_left);
        make.width.equalTo(weakSelf.view.mas_width);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
    }];
    [self.contentView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.contentBg.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
        
    }];
    
}

-(void)setValueForProperty {

    _timeLabel.text = _model.date;
    _titleLabel.text = _model.title;
    //    解析富文本
    
    [MResponseUserInfo loadContentWithUrl:_model.url ContentUrlCompletion:^(BOOL success, NSData *data, NSError *error) {
        NSDictionary * rtf = [NSDictionary dictionaryWithObject:NSRTFDTextDocumentType forKey:NSDocumentTypeDocumentAttribute];
        NSAttributedString *attribute = [[NSAttributedString alloc]initWithData:data options:rtf documentAttributes:nil error:nil];
        
        _contentView.attributedText = attribute;
    }];
    if (_model.backgroundImage != nil ) {
        
        [self.contentBg sd_setImageWithURL:[NSURL URLWithString:_model.backgroundImage]];
        self.contentView.backgroundColor = [UIColor clearColor];
    }

}

#pragma mark - Getter


-(UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont systemFontOfSize:15 weight:11];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UITextView *)contentView {

    if (_contentView == nil) {
        _contentView = [[UITextView alloc]initWithFrame:CGRectZero];
        _contentView.font = [UIFont systemFontOfSize:15 weight:11];
      
    }
    return _contentView;

}
-(UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _timeLabel.font = [UIFont systemFontOfSize:11 weight:11];
        _timeLabel.textColor = [UIColor colorWithWhite:0.430 alpha:1.000];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
     
    }
    return _timeLabel;
}
-(UIImageView *)contentBg {
    
    if (_contentBg == nil) {
        _contentBg = [[UIImageView alloc]initWithFrame:CGRectZero];
        _contentBg.backgroundColor = [UIColor whiteColor];
        _contentBg.userInteractionEnabled = YES;
        
    }
    return _contentBg;

}

@end
