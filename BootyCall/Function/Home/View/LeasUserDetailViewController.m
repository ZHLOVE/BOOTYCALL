//
//  LeasUserDetailViewController.m
//  BootyCall
//
//  Created by rimi on 16/8/17.
//  Copyright © 2016年 dazhongdiy. All rights reserved.
//

#import "LeasUserDetailViewController.h"
#import "CustomModalTransition.h"
#import "RGCardViewLayout.h"
#import "LeasDetailCollectionViewCell.h"
#import "SFoldawayButton.h"


#define TAG          919191
#define CELLID       @"photosCell"
#define LABEL_COLOR  RGB_COLOR(244, 243, 237, 1)
#define TEXT_COLOR   RGB_COLOR(77, 77, 77, 0.8)
#define FONT_COLOR   RGB_COLOR(134, 134, 134, 0.8)
@interface LeasUserDetailViewController () <UIViewControllerTransitioningDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
/**
 *  关闭按钮
 */
@property (nonatomic,strong) UIButton              *closeButton;
/**
 *  头部视图
 */
@property (nonatomic,strong) UIView                *headerView;
/**
 *  标题名字
 */
@property (nonatomic,strong) UILabel               *titleLabel;

@property (nonatomic,strong) UIScrollView          *scrollView;
/**
 *  照片流
 */
@property (nonatomic,strong) UICollectionView      *userPhotos;
@property (nonatomic,strong) UIPageControl         *pageControl;
/**
 *  亲密度
 */
@property (nonatomic,strong) UILabel               *intimacyMeg;
@property (nonatomic,strong) UILabel               *intimacyLabel;
@property (nonatomic,strong) UIView                *allIntimacyView;
@property (nonatomic,strong) UIView                *currentIntimacyView;
@property (nonatomic,strong) UILabel               *intimacyValue;

/**
 *  信息列表
 */
@property (nonatomic,strong) UILabel               *userInfo;
@property (nonatomic,strong) UILabel               *userNameLabel;
@property (nonatomic,strong) UILabel               *userNameText;
@property (nonatomic,strong) UILabel               *userHeighLabel;
@property (nonatomic,strong) UILabel               *userHeighText;
@property (nonatomic,strong) UILabel               *userBirthdayLabel;
@property (nonatomic,strong) UILabel               *userBirthdayText;

/**
 *  身高
 */
@property (nonatomic,strong) NSString              *heightString;
/**
 *  生日
 */
@property (nonatomic,strong) NSString              *birthdayString;
/**
 *  兴趣，爱好
 */
@property (nonatomic,strong) UILabel               *userHobby;
@property (nonatomic,strong) UILabel               *hobbyText;
@property (nonatomic,strong) NSString              *hobbyString;
/**
 *  工作种类
 */
@property (nonatomic,strong) UILabel               *userIndustry;
@property (nonatomic,strong) UILabel               *industryText;
@property (nonatomic,strong) NSString              *industryString;
/**
 *  自我评价
 */
@property (nonatomic,strong) UILabel               *userEvaluation;
/**
 *  性格
 */
@property (nonatomic,strong) UILabel               *userCharacter;
@property (nonatomic,strong) UILabel               *characterText;
@property (nonatomic,strong) NSString              *characterString;
/**
 *  缺点
 */
@property (nonatomic,strong) UILabel               *userInsufficient;
@property (nonatomic,strong) UILabel               *insufficientText;
@property (nonatomic,strong) NSString              *defectString;
/**
 *  相册数组
 */
@property (nonatomic,strong) NSMutableArray        *albumArray;

@end

@implementation LeasUserDetailViewController{
    
    CustomModalTransition *transitionToNextModal;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _albumArray = [[NSMutableArray alloc]init];
        self.numberValues = 1.1;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.automaticallyAdjustsScrollViewInsets  = NO;
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self initializeDataSource];
    
    NSLog(@"对象信息为--%@",_userInfoDic);
}

- (void) initializeDataSource{
    __weak typeof(self) weakSelf = self;
    if (self.userID != nil) {
        NSLog(@"聊天对象ID%@",self.userID);
        [MResponseUserInfo responseUserInfoWithId:self.userID ResponseUserCompletion:^(BOOL success, NSError *error, NSDictionary *currentUserInfo) {
            if (success) {
                //NSLog(@"聊天对象的字典%@",currentUserInfo);
                _userInfoDic = currentUserInfo;

                if ([[_userInfoDic allKeys] containsObject:@"albumArray"] && [_userInfoDic[@"albumArray"] count] > 0) {
                    _albumArray = _userInfoDic[@"albumArray"];
                }else{
                    [_albumArray addObject:@"Mbutton"];
                }
                [weakSelf initializeInterface];
            }
        }];
    }else{
        if ([[_userInfoDic allKeys] containsObject:@"albumArray"] && [_userInfoDic[@"albumArray"] count] > 0) {
            _albumArray = _userInfoDic[@"albumArray"];
        }else{
            [_albumArray addObject:@"Mbutton"];
        }
        
        [self initializeInterface];
    }
    
    
    if (self.numberValues >= 100) {
        self.numberValues = 99;
    }
    if (self.numberValues < 10.0) {
        self.numberValues = 1;
    }
}

- (void) initializeInterface{
    __weak typeof(self) weakSelf = self;
    self.view.backgroundColor = BgColor;
    self.transitioningDelegate = self.transitionManager;
    transitionToNextModal = [[CustomModalTransition alloc] init];
    _headerView = ({
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = MainColor;
        view;
    });
    [self.view addSubview:_headerView];
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(0);
        make.left.equalTo(weakSelf.view.mas_left).offset(0);
        make.width.equalTo(weakSelf.view.mas_width);
        make.height.equalTo(@64);
    }];
    _titleLabel = ({
        UILabel *label = [[UILabel alloc]init];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont boldSystemFontOfSize:16.f];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [NSString stringWithFormat:@"\t%@\t",_userInfoDic[@"myInfo"][@"nickName"]];
        label;
    });
    [_headerView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_headerView.mas_centerX);
        make.centerY.equalTo(_headerView.mas_centerY).offset(10);
    }];
    _scrollView = ({
        UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        scrollView.contentSize = CGSizeMake(0,SCREEN_HEIGHT*1.7);
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView;
    });
    [self.view addSubview:_scrollView];
    _closeButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickEvent:) forControlEvents:UIControlEventTouchUpInside];
        button.imageEdgeInsets = UIEdgeInsetsMake(24, 24, 10, 10);
        button.alpha = 0.7f;
        button;
    });
    [self.view addSubview:_closeButton];
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.view.mas_right).offset(0);
        make.top.equalTo(weakSelf.view.mas_top).offset(0);
        make.width.equalTo(@64);
        make.height.equalTo(@64);
    }];
    RGCardViewLayout *layout = [[RGCardViewLayout alloc]init];
    _userPhotos = ({
        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        collectionView.pagingEnabled = YES;
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.backgroundColor = BgColor;
        [collectionView registerClass:[LeasDetailCollectionViewCell class] forCellWithReuseIdentifier:CELLID];
        collectionView;
    });
    [_scrollView addSubview:_userPhotos];
    [_userPhotos mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_scrollView.mas_top).offset(15);
        make.left.equalTo(weakSelf.view.mas_left).offset(0);
        make.right.equalTo(weakSelf.view.mas_right).offset(0);
        make.height.equalTo(@(SCREEN_WIDTH));
    }];
    _pageControl = ({
        UIPageControl  *pageControl = [[UIPageControl alloc] init];
        pageControl.tintColor = [UIColor grayColor];
        pageControl.currentPage = 0;
        if (_albumArray.count > 1) {
            pageControl.numberOfPages = _albumArray.count;
        }else{
            pageControl.hidden = YES;
        }
        pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        pageControl;
    });
    [_scrollView addSubview:_pageControl];
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@30);
        make.height.equalTo(@30);
        make.centerX.equalTo(_userPhotos.mas_centerX);
        make.bottom.equalTo(_userPhotos.mas_bottom).offset(-10);
    }];
    _intimacyMeg = ({
        UILabel *label = [[UILabel alloc]init];
        label.backgroundColor = MainColor;
        label.textColor = [UIColor whiteColor];
        label.layer.cornerRadius = 4;
        label.clipsToBounds = YES;
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentLeft;
        label.text = @"想看清楚照片吗?唯一的办法就是和TA成为好友,通过多交流来提高亲密度哦!";
        label.numberOfLines = 0;
        label;
    });
    [_scrollView addSubview:_intimacyMeg];
    [_intimacyMeg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.top.equalTo(_userPhotos.mas_bottom).offset(20);
        make.width.equalTo(@(SCREEN_WIDTH-40));
    }];
    _intimacyLabel = ({
        UILabel *label = [[UILabel alloc]init];
        label.backgroundColor = LABEL_COLOR;
        label.textColor = TEXT_COLOR;
        label.layer.cornerRadius = 4;
        label.clipsToBounds = YES;
        label.font = [UIFont systemFontOfSize:16];
        label.textAlignment = NSTextAlignmentLeft;
        label.text = [NSString stringWithFormat:@"亲密度:"];
        label;
    });
    [_scrollView addSubview:_intimacyLabel];
    [_intimacyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.top.equalTo(_intimacyMeg.mas_bottom).offset(20);
        //make.height.equalTo(@30);
    }];
    _intimacyValue = ({
        UILabel *label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = TEXT_COLOR;
        label.font = [UIFont systemFontOfSize:10];
        label.textAlignment = NSTextAlignmentLeft;
        label.text = [NSString stringWithFormat:@"%.0f/100",self.numberValues];
        label;
    });
    [_scrollView addSubview:_intimacyValue];
    [_intimacyValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_intimacyLabel.mas_bottom).offset(0);
        make.right.equalTo(weakSelf.view.mas_right).offset(-20);
        //make.height.equalTo(@30);
    }];
    _allIntimacyView = ({
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor lightGrayColor];
        view;
    });
    [_scrollView addSubview:_allIntimacyView];
    [_allIntimacyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_intimacyLabel.mas_bottom).offset(0);
        make.left.equalTo(_intimacyLabel.mas_right).offset(5);
        make.right.equalTo(_intimacyValue.mas_left).offset(-5);
        make.height.equalTo(@20);
    }];
    [_allIntimacyView layoutIfNeeded];
    _currentIntimacyView = ({
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor orangeColor];
        view;
    });
    [_allIntimacyView addSubview:_currentIntimacyView];
    [_currentIntimacyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_intimacyLabel.mas_bottom).offset(0);
        make.left.equalTo(_allIntimacyView.mas_left).offset(0);
        make.height.equalTo(@20);
        make.width.equalTo(@(_allIntimacyView.bounds.size.width*self.numberValues/100));
    }];
    _userInfo = ({
        UILabel *label = [[UILabel alloc]init];
        //label.backgroundColor = LABEL_COLOR;
        label.textColor = TEXT_COLOR;
        label.font = [UIFont systemFontOfSize:16];
        label.textAlignment = NSTextAlignmentLeft;
        label.text = [NSString stringWithFormat:@"\t个人信息:"];
        label;
    });
    [_scrollView addSubview:_userInfo];
    [_userInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_intimacyLabel.mas_bottom).offset(20);
        make.left.equalTo(_scrollView.mas_left).offset(10);
        make.width.equalTo(@(SCREEN_WIDTH-20));
        make.height.equalTo(@40);
    }];
    _userNameLabel = ({
        UILabel *label = [[UILabel alloc]init];
        label.backgroundColor = MainColor;
        label.textColor = [UIColor whiteColor];
        label.layer.cornerRadius = 3.0;
        label.clipsToBounds =  YES;
        label.font = [UIFont systemFontOfSize:16];
        label.textAlignment = NSTextAlignmentLeft;
        label.text = [NSString stringWithFormat:@"\t昵称:\t"];
        label;
    });
    [_scrollView addSubview:_userNameLabel];
    [_userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_userInfo.mas_bottom).offset(20);
        make.left.equalTo(_scrollView.mas_left).offset(20);
    }];
    _userNameText = ({
        UILabel *label = [[UILabel alloc]init];
        //label.backgroundColor = MainColor;
        label.textColor = TEXT_COLOR;
        label.layer.cornerRadius = 3.0;
        label.clipsToBounds =  YES;
        label.font = [UIFont systemFontOfSize:15];
        label.textAlignment = NSTextAlignmentLeft;
        label.text = [NSString stringWithFormat:@"\t%@\t",_userInfoDic[@"myInfo"][@"nickName"]];
        label;
    });
    [_scrollView addSubview:_userNameText];
    [_userNameText mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.top.equalTo(_userInfo.mas_bottom).offset(20);
        make.left.equalTo(_userNameLabel.mas_right).offset(15);
        make.bottom.equalTo(_userNameLabel.mas_bottom).offset(0);
    }];
    _userHeighLabel = ({
        UILabel *label = [[UILabel alloc]init];
        label.backgroundColor = MainColor;
        label.textColor = [UIColor whiteColor];
        label.layer.cornerRadius = 3.0;
        label.clipsToBounds =  YES;
        label.font = [UIFont systemFontOfSize:16];
        label.textAlignment = NSTextAlignmentLeft;
        label.text = [NSString stringWithFormat:@"\t身高:\t"];
        label;
    });
    [_scrollView addSubview:_userHeighLabel];
    [_userHeighLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_userNameLabel.mas_bottom).offset(10);
        make.left.equalTo(_scrollView.mas_left).offset(20);
    }];
    _userHeighText = ({
        UILabel *label = [[UILabel alloc]init];
        //label.backgroundColor = MainColor;
        label.textColor = TEXT_COLOR;
        label.layer.cornerRadius = 3.0;
        label.clipsToBounds =  YES;
        label.font = [UIFont systemFontOfSize:15];
        label.textAlignment = NSTextAlignmentLeft;
        if (!_userInfoDic[@"myBasicInfo"][@"height"] || _userInfoDic[@"myBasicInfo"][@"height"] == nil || _userInfoDic[@"myBasicInfo"][@"height"] == NULL || [_userInfoDic[@"myBasicInfo"][@"height"] isKindOfClass:[NSNull class]]) {
            label.text = @"\t保密";
            
        }else{
           label.text = [NSString stringWithFormat:@"\t%@\t",_userInfoDic[@"myBasicInfo"][@"height"]];
        }
        label;
    });
    [_scrollView addSubview:_userHeighText];
    [_userHeighText mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.top.equalTo(_userNameLabel.mas_bottom).offset(10);
        make.left.equalTo(_userHeighLabel.mas_right).offset(15);
        make.bottom.equalTo(_userHeighLabel.mas_bottom).offset(0);
    }];
    _userBirthdayLabel = ({
        UILabel *label = [[UILabel alloc]init];
        label.backgroundColor = MainColor;
        label.textColor = [UIColor whiteColor];
        label.layer.cornerRadius = 3.0;
        label.clipsToBounds =  YES;
        label.font = [UIFont systemFontOfSize:16];
        label.textAlignment = NSTextAlignmentLeft;
        label.text = [NSString stringWithFormat:@"\t生日:\t"];
        label;
    });
    [_scrollView addSubview:_userBirthdayLabel];
    [_userBirthdayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_userHeighLabel.mas_bottom).offset(10);
        make.left.equalTo(_scrollView.mas_left).offset(20);
    }];
    _userBirthdayText = ({
        UILabel *label = [[UILabel alloc]init];
        //label.backgroundColor = MainColor;
        label.textColor = TEXT_COLOR;
        label.layer.cornerRadius = 3.0;
        label.clipsToBounds =  YES;
        label.font = [UIFont systemFontOfSize:15];
        label.textAlignment = NSTextAlignmentLeft;
        if (_userInfoDic[@"myInfo"][@"birthday"] != nil) {
            _birthdayString = [_userInfoDic[@"myInfo"][@"birthday"]  substringFromIndex:5];
        }else{
            _birthdayString = @"保密";
        }
        label.text = [NSString stringWithFormat:@"\t%@\t",_birthdayString];
        label;
    });
    [_scrollView addSubview:_userBirthdayText];
    [_userBirthdayText mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.top.equalTo(_userHeighLabel.mas_bottom).offset(10);
        make.left.equalTo(_userBirthdayLabel.mas_right).offset(15);
        make.bottom.equalTo(_userBirthdayLabel.mas_bottom).offset(0);
    }];
    _userHobby = ({
        UILabel *label = [[UILabel alloc]init];
        //label.backgroundColor = LABEL_COLOR;
        label.textColor = TEXT_COLOR;
        label.font = [UIFont systemFontOfSize:16];
        label.textAlignment = NSTextAlignmentLeft;
        label.text = @"\t兴趣爱好:";
        label;
    });
    [_scrollView addSubview:_userHobby];
    [_userHobby mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_userBirthdayLabel.mas_bottom).offset(20);
        make.left.equalTo(_scrollView.mas_left).offset(10);
        make.width.equalTo(@(SCREEN_WIDTH-20));
        make.height.equalTo(@40);
    }];
    _hobbyText = ({
        UILabel *label = [[UILabel alloc]init];
        //label.backgroundColor = LABEL_COLOR;
        label.textColor = FONT_COLOR;
        label.font = [UIFont systemFontOfSize:16];
        label.textAlignment = NSTextAlignmentLeft;
        NSArray  *hobbyArray = [[NSArray alloc] init];
        _hobbyString = [[NSMutableString alloc]init];
        NSLog(@"排序后的数组:%@",hobbyArray);
        hobbyArray = [_userInfoDic[@"hobbyArray"] sortedArrayUsingSelector:@selector(compare:)];
        if (hobbyArray.count > 0) {
            for (int index = 0; index < hobbyArray.count; index ++) {
                _hobbyString = [_hobbyString stringByAppendingFormat:@"⊙%@\t",hobbyArray[index]];
            }
        }else{
            _hobbyString = @"暂未描述";
        }
        label.text = _hobbyString;
        label.numberOfLines  = 0;
        label;
    });
    [_scrollView addSubview:_hobbyText];
    [_hobbyText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_userHobby.mas_bottom).offset(10);
        make.left.equalTo(_scrollView.mas_left).offset(20);
        make.width.equalTo(@(SCREEN_WIDTH-20));
    }];
    _userIndustry = ({
        UILabel *label = [[UILabel alloc]init];
        //label.backgroundColor = LABEL_COLOR;
        label.textColor = TEXT_COLOR;
        label.font = [UIFont systemFontOfSize:16];
        label.textAlignment = NSTextAlignmentLeft;
        label.text = @"\t工作性质:";
        label;
    });
    [_scrollView addSubview:_userIndustry];
    [_userIndustry mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_hobbyText.mas_bottom).offset(20);
        make.left.equalTo(_scrollView.mas_left).offset(10);
        make.width.equalTo(@(SCREEN_WIDTH-20));
        make.height.equalTo(@40);
    }];
    _industryText = ({
        UILabel *label = [[UILabel alloc]init];
        //label.backgroundColor = LABEL_COLOR;
        label.textColor = FONT_COLOR;
        label.font = [UIFont systemFontOfSize:16];
        label.textAlignment = NSTextAlignmentLeft;
        NSMutableArray *indusArray = [_userInfoDic[@"industryArray"] mutableCopy];
        _industryString = [[NSMutableString alloc]init];
        if (indusArray.count > 0) {
            for (int index = 0; index < indusArray.count; index ++) {
                _industryString = [_industryString stringByAppendingFormat:@"%@\t",indusArray[index]];
            }
        }else{
            _industryString = @"暂未描述";
        }
        label.text = _industryString;
        label.numberOfLines  = 0;
        label;
    });
    [_scrollView addSubview:_industryText];
    [_industryText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_userIndustry.mas_bottom).offset(10);
        make.left.equalTo(_scrollView.mas_left).offset(20);
        make.width.equalTo(@(SCREEN_WIDTH-20));
    }];
    _userEvaluation = ({
        UILabel *label = [[UILabel alloc]init];
        //label.backgroundColor = LABEL_COLOR;
        label.textColor = TEXT_COLOR;
        label.font = [UIFont systemFontOfSize:16];
        label.textAlignment = NSTextAlignmentLeft;
        label.text = @"\t自我评价:";
        label;
    });
    [_scrollView addSubview:_userEvaluation];
    [_userEvaluation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_industryText.mas_bottom).offset(20);
        make.left.equalTo(_scrollView.mas_left).offset(10);
        make.width.equalTo(@(SCREEN_WIDTH-20));
        make.height.equalTo(@40);
    }];
    _userCharacter = ({
        UILabel *label = [[UILabel alloc]init];
        label.backgroundColor = MainColor;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:16];
        label.layer.cornerRadius = 2;
        label.clipsToBounds = YES;
        label.textAlignment = NSTextAlignmentLeft;
        label.text = [NSString stringWithFormat:@"%@",@"\t性格:\t"];
        label;
    });
    [_scrollView addSubview:_userCharacter];
    [_userCharacter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_userEvaluation.mas_bottom).offset(10);
        make.left.equalTo(_scrollView.mas_left).offset(20);
    }];
    _characterText = ({
        UILabel *label = [[UILabel alloc]init];
        //label.backgroundColor = LABEL_COLOR;
        label.textColor = FONT_COLOR;
        label.font = [UIFont systemFontOfSize:16];
        label.textAlignment = NSTextAlignmentLeft;
        NSMutableArray *characterArray = [_userInfoDic[@"characterArray"] mutableCopy];
        if (characterArray.count > 0) {
            _characterString = [[NSMutableString alloc]init];
            for (int index = 0; index < characterArray.count; index ++) {
                _characterString = [_characterString stringByAppendingFormat:@"%@\t",characterArray[index]];
            }
            label.text = _characterString;
        }else{
            label.text = @"暂未描述";
        }
        label.numberOfLines  = 0;
        label;
    });
    [_scrollView addSubview:_characterText];
    [_characterText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_userCharacter.mas_bottom).offset(5);
        make.left.equalTo(_scrollView.mas_left).offset(25);
        make.right.equalTo(weakSelf.view.mas_right).offset(-10);
    }];
    _userInsufficient = ({
        UILabel *label = [[UILabel alloc]init];
        label.backgroundColor = MainColor;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:16];
        label.layer.cornerRadius = 2;
        label.clipsToBounds = YES;
        label.textAlignment = NSTextAlignmentLeft;
        label.text = @"\t缺点:\t";
        label;
    });
    [_scrollView addSubview:_userInsufficient];
    [_userInsufficient mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_characterText.mas_bottom).offset(10);
        make.left.equalTo(_scrollView.mas_left).offset(20);
    }];
    _insufficientText = ({
        UILabel *label = [[UILabel alloc]init];
        //label.backgroundColor = LABEL_COLOR;
        label.textColor = FONT_COLOR;
        label.font = [UIFont systemFontOfSize:16];
        label.textAlignment = NSTextAlignmentLeft;
        NSMutableArray *defectArray = [_userInfoDic[@"defectArray"] mutableCopy];
        if (defectArray.count > 0) {
            _defectString = [[NSMutableString alloc]init];
            for (int index = 0; index < defectArray.count; index ++) {
                _defectString = [_defectString stringByAppendingFormat:@"%@\t",defectArray[index]];
            }
            label.text = _defectString;
        }else{
            label.text = @"暂未描述";
        }
        
        label.numberOfLines  = 0;
        label;
    });
    [_scrollView addSubview:_insufficientText];
    [_insufficientText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_userInsufficient.mas_bottom).offset(5);
        make.left.equalTo(_scrollView.mas_left).offset(25);
        make.right.equalTo(weakSelf.view.mas_right).offset(-10);
    }];
    [self.view layoutIfNeeded];
}

#pragma mark -- Action

- (void)clickEvent:(UIControl *)sender {
    if (sender == _closeButton) {
        // 添加window上的主按钮
        [[UIApplication sharedApplication].keyWindow addSubview:[SFoldawayButton sharSfoldawayButton]];
        self.transitionManager.closeVCNow = YES;
        [self dismissViewControllerAnimated:YES completion:^{
            /**
             *  避免信息循环引用交叉，移除视图
             */
            [self.view removeFromSuperview];
        }];
    }
}

#pragma mark -- UICollectionViewDelegate,UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return _albumArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    LeasDetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELLID forIndexPath:indexPath];
    cell.tag = TAG;
    cell.backgroundColor = [UIColor whiteColor];
    cell.layer.cornerRadius = 5;
    cell.clipsToBounds = YES;
    cell.layer.borderWidth = 1;
    cell.layer.borderColor = [UIColor lightGrayColor].CGColor;
    //cell.contentView.alpha = _numberValues/10.0;
    cell.visualEffect.alpha = (1 - _numberValues/100);
    //cell.visualEffect.alpha = 0;
    //cell.alpha = 1;
    //cell.visualEffect.alpha = 0.1;
    [self configureCell:cell withIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(LeasDetailCollectionViewCell *)cell withIndexPath:(NSIndexPath *)indexPath
{
    UIView  *subview = [cell.contentView viewWithTag:TAG];
    [subview removeFromSuperview];
    /**
     *  在异步线程加载。提高效率
     */
    [cell.photosImageView sd_setImageWithURL:[NSURL URLWithString:_albumArray[indexPath.section]] placeholderImage:[UIImage imageNamed:@"radar_background.jpg"]];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger  numberOfPage = round(_userPhotos.contentOffset.x / SCREEN_WIDTH);
    
    _pageControl.currentPage = numberOfPage;

}
#pragma For Presen Modally mode (simple transition)
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                   presentingController:(UIViewController *)presenting
                                                                       sourceController:(UIViewController *)source {
    return transitionToNextModal;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed  {
    return transitionToNextModal;
}



@end
