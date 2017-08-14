//
//  LeasUserSettingViewController.m
//  BootyCall
//
//  Created by rimi on 16/8/13.
//  Copyright © 2016年 dazhongdiy. All rights reserved.
//

#import "LeasUserSettingViewController.h"
#import "ZYQAssetPickerController.h"
#import "SFlashLabel.h"
#import "SAttributeView.h"
#import "UIView+SFrame.h"
#import "SFoldawayButton.h"
#import "SSelfInfoViewConroller.h"

#define ContentColor  [UIColor whiteColor]
#define TextColor     [UIColor whiteColor]
@interface LeasUserSettingViewController ()<UITextViewDelegate,ZYQAssetPickerControllerDelegate,UINavigationControllerDelegate,SAttributeViewDelegate,UIImagePickerControllerDelegate,UIScrollViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>

{
    UIImagePickerController *_imagePickerController;/**<图片拾取器*/
    CGPoint _lastPosition;
    //用于监听键盘推送的高度
    CGPoint _cureenPositionK;
    //避免点击同时点击身高和兴趣爱好这两个个输入框，因为如果没有关不之前的就造成覆盖
    BOOL    isShowPicker;
    BOOL    isUploading;
    BOOL    isShowKeyBoard;
    
    
    UILabel *_textViewNumL;
    UILabel *_sperTextViewNumL;
    UILabel *_sdisTextViewNumL;
}

@property(nonatomic,strong)UIView                      *editv;
@property(nonatomic,strong)UITextView                  *textView;
@property(nonatomic,strong)UILabel                     *placeholderLabel;
@property(nonatomic,strong)UIButton                    *addPic;
@property(nonatomic,strong)NSMutableArray              *imageArray;
@property(nonatomic,strong)UIView                      *heightPickerBgView;
@property(nonatomic,strong)UIPickerView                *heightPickerView;
@property(nonatomic,strong)UIView                      *hobbyPickeBgrView;
@property(nonatomic,strong)UIPickerView                *hobbyPickerView;
@property(nonatomic,strong)UIToolbar                   *heightToolBar;
@property(nonatomic,strong)UIToolbar                   *hobbyToolBar;
/**
 *  用户设置界面
 */
@property (nonatomic, strong)UIScrollView    *scrollView;
/**
 *  用户头像
 */
@property (nonatomic, strong)UIImageView     *userHeaderImageView;
/**
 *  提示最多输入六张照片
 */
@property (nonatomic, strong)UILabel         *sixLabel;
/**
 *  flashLabel
 */
@property (nonatomic, strong)SFlashLabel     *sflashLabel;

/**attributeViewSG之后的视图的背景视图只要,这样做的目的是在选择图片之后很好的高这个视图的Y值*/
@property (nonatomic, strong)UIView          *bgView;
/**所处行业*/
@property (nonatomic ,strong)SAttributeView  *attributeViewHY;

/**身高*/
@property (nonatomic ,strong)UITextField     *heightTextFiled;

/**兴趣爱好*/
@property (nonatomic ,strong)UILabel         *hobbyLabel;
/**兴趣爱好提示符*/
@property (nonatomic ,strong)UILabel         *habbyPlaceholderLabel;
/**兴趣爱好输入框*/
@property (nonatomic ,strong)UILabel         *hobbyEditField;

/**个性特点标签*/
@property (nonatomic ,strong)UILabel         *spersonalityLabel;
/**个性特点输入框*/
@property (nonatomic, strong)UITextView      *spersonalityTextView;
/**个性特点提示字符输入框*/
@property (nonatomic, strong)UILabel         *spersonalityPlaceholderLabel;

/**缺点标签*/
@property (nonatomic, strong)UILabel         *sdisadvantagesLabel;
/**缺点输入框*/
@property (nonatomic, strong)UITextView      *sdisadvantagesTextView;
/**缺点输入框提示字符输入框*/
@property (nonatomic, strong)UILabel         *sdisadvantagesPlaceholderLabel;

/**
 *  键盘弹起时，在这个View上添加手势用于结束编辑
 */
@property (nonatomic, strong)UIView          *unableView;
/**立即设置头像*/
@property (nonatomic, strong)UILabel         *headLabel;


/**头像的路径*/
@property(nonatomic,strong)NSString          *sheadImageUrl;
@property(nonatomic,strong)NSData            *sheadImageData;
/**个性签名*/
@property(nonatomic,strong)NSString          *signatureStr;
/**个性签名获取下来的*/
@property(nonatomic,strong)NSString          *signatureTempStr;
/**身高*/
@property(nonatomic,strong)NSString          *heightStr;
/**身高获取下来的*/
@property(nonatomic,strong)NSString          *heightTempStr;
/**身高选择后的数据*/
@property(nonatomic,strong)NSString          *tempHeightStr;
/**行业*/
@property(nonatomic,strong)NSString          *industryStr;
/**行业获取下来的*/
@property(nonatomic,strong)NSString          *industryTempStr;
/**个人性格*/
@property(nonatomic,strong)NSString          *characterStr;
/**个人性格获取下来的*/
@property(nonatomic,strong)NSString          *characterTempStr;
/**个人缺点*/
@property(nonatomic,strong)NSString          *traitStr;
/**个人缺点获取下来的*/
@property(nonatomic,strong)NSString          *traitTempStr;
/**兴趣爱好*/
@property(nonatomic,strong)NSMutableArray    *hobbys;
/**兴趣爱好选择后的数据*/
@property(nonatomic,strong)NSString          *tempHobbyStr;
/**获取下来的兴趣爱好*/
@property(nonatomic,strong)NSArray           *hobbyTempSArr;
/**生活照路径*/
@property(nonatomic,strong)NSMutableArray    *imageIndexPathArr;
/**生活照Data数据*/
@property(nonatomic,strong)NSMutableArray    *imageDataArr;
/**头像*/
@property(nonatomic,strong)UIImage           *headImage;



//peackView的数据源
/**身高*/
@property(nonatomic,strong)NSMutableArray    *heightArr;
/**身高详情*/
@property(nonatomic,strong)NSMutableArray    *heightDetailArr;
/**兴趣爱好*/
@property(nonatomic,strong)NSArray           *hobbyArr;
/**兴趣爱好详情*/
@property(nonatomic,strong)NSArray           *hobbyDetailArr;

@end

@implementation LeasUserSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BgColor;
    [self initializeDataSource];
    [self initilalizeInterface];
    self.navigationItem.title = @"查看/编辑";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    //加载菊花
    [self showProgressHUD:self.view hint:@"" hide:@""];
    
}


#pragma mark - ******* Initalize *******

- (void) initializeDataSource{
    //注册键盘通知
    [self registerForKeyboardNotifications];
    _imageArray = [@[]mutableCopy];
    _imageIndexPathArr = [@[]mutableCopy];
    _imageDataArr = [@[]mutableCopy];
    _hobbys = [@[]mutableCopy];
    
    //赋初值
    _sheadImageUrl = @"";
    _signatureStr = @"";//@"未编辑";
    _industryStr = @"";//@"保密";
    _heightStr = @"";//@"保密";
    _characterStr = _traitStr =  @"";//@"未编辑";
    
    //pickerView数据
    _heightArr = [@[]mutableCopy];
    _heightDetailArr = [@[]mutableCopy];
    for (int index = 149; index <= 192; index ++) {
        if(index == 149){
            [_heightArr addObject:@"150以下"];
            [_heightDetailArr addObject:@[@""]];
        }else if(index == 191){
            [_heightArr addObject:@"190以上"];
            [_heightDetailArr addObject:@[@""]];
        }else if(index == 192){
            [_heightArr addObject:@"保密"];
            [_heightDetailArr addObject:@[@""]];
            
        }else{
            [_heightArr addObject:[NSString stringWithFormat:@"%d",index]];
            [_heightDetailArr addObject:@[@"cm"]];
        }
    }
    _hobbyArr = @[@"运动",@"音乐",@"食物",@"电影"];
    _hobbyDetailArr = @[[YUNDONG componentsSeparatedByString:@" "],[YINYUE componentsSeparatedByString:@" "],[SHIWU componentsSeparatedByString:@" "],[DIANYING componentsSeparatedByString:@" "]];
    //获取头像
    _sheadImageData = [[NSUserDefaults standardUserDefaults]objectForKey:@"sheadImageData"];
    _headImage = [UIImage imageWithData:_sheadImageData];
    if(_sheadImageData == nil || _headImage == nil){
        _headImage = [UIImage imageNamed:@"sadd"];
    }
    
    //获取生活照
    [MResponseUserInfo responseCurrentUserInfo:^(BOOL success, NSError *error, NSDictionary *currentUserInfo) {
        if (success) {
            NSLog(@"%@----",currentUserInfo);
            _signatureTempStr = currentUserInfo[@"myBasicInfo"][@"signature"];
            if (!_signatureTempStr) {
                _signatureTempStr = @"暂无描述";
            }
            _signatureStr = _signatureTempStr;
            _heightTempStr = currentUserInfo[@"myBasicInfo"][@"height"];
            if (!_heightTempStr) {
                _heightTempStr = @"保密";
            }
            _heightStr = _heightTempStr;
            _industryTempStr = [currentUserInfo[@"industryArray"]lastObject];
            if (!_industryTempStr) {
                _industryTempStr = @"保密";
            }
            _industryStr = _industryTempStr;
            _hobbyTempSArr = currentUserInfo[@"hobbyArray"];
            _characterTempStr = [currentUserInfo[@"characterArray"]lastObject];
            if (!_characterTempStr) {
                _characterTempStr = @"暂无描述";
            }
            _traitTempStr = [currentUserInfo[@"defectArray"]lastObject];
            if (!_traitTempStr) {
                _traitTempStr = @"暂无描述";
            }
            _traitStr = _traitTempStr;
            // 生活照
            NSArray *albumArray = currentUserInfo[@"albumArray"];
            [albumArray enumerateObjectsUsingBlock:^(NSString*  _Nonnull url, NSUInteger idx, BOOL * _Nonnull stop) {
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
                [_imageDataArr addObject:data];
                [_imageArray addObject:[UIImage imageWithData:data]];
            }];
            //生活照布局
            dispatch_async(dispatch_get_main_queue(), ^{
                [self nineGrid];
            });
            [self removePorgressHud];
        }else{
            [self removePorgressHud];
            [UIAlertController showAlertWithTitle:@"温馨提示" message:@"请检查你的网络是否连接正常" target:self];
        }
    }];
    
   
}

- (void)initilalizeInterface{
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.scrollView.backgroundColor = BgColor;
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    //添加子视图
    [self addSubViews];
    //关键在于最后一个控件的y
    self.scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(_editv.frame) + CGRectGetMaxY(self.sdisadvantagesTextView.frame) + 80);
    UIBarButtonItem *rightButtonItem = ({
        rightButtonItem = [[UIBarButtonItem alloc]initWithTitle:[NSString stringWithFormat:@"上传%@",SPACING] style:UIBarButtonItemStylePlain target:self action:@selector(respondsRightButtonItem:)];
        rightButtonItem.imageInsets = UIEdgeInsetsMake(12, 0, 12, 24);
        rightButtonItem;

    });
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    _imagePickerController = [[UIImagePickerController alloc]init];
    _imagePickerController.delegate = self;

}

#pragma mark - ******* Methods *******

-(void)addSubViews{
    //加载头像
    [self.scrollView addSubview:self.userHeaderImageView];
    //加载sflashLabel
    [self.scrollView addSubview:self.sflashLabel];
    // 评论 + 照片
    _editv = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.sflashLabel.frame) + 20, SCREEN_WIDTH - 15*2, 0)];
    _editv.backgroundColor = [UIColor whiteColor];
    _editv.layer.cornerRadius = 3.f;
    _editv.layer.masksToBounds = YES;
    [self.scrollView addSubview:_editv];
    //个性签名 UITextView
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(15, 10, CGRectGetWidth(_editv.frame)- 15 * 2, 60)];
    _textView.backgroundColor = BgColor;
    _textView.layer.cornerRadius = 3.f;
    _textView.layer.masksToBounds = YES;
    _textView.delegate = self;
    _textViewNumL = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(_editv.frame)- 15 * 2 - 40, 50, 40, 10)];
    _textViewNumL.backgroundColor = [UIColor clearColor];
    _textViewNumL.text = @"1/40";
    _textViewNumL.font = [UIFont systemFontOfSize:10];
    _textViewNumL.textColor = [UIColor grayColor];
    _textViewNumL.textAlignment = NSTextAlignmentRight;
    [_textView addSubview:_textViewNumL];
    [_editv addSubview:_textView];
    
    _sixLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(_textView.frame) + 5, SCREEN_WIDTH, 20)];
    _sixLabel.text = @"添加照片,最多六张哦";
    _sixLabel.font = [UIFont systemFontOfSize:13.0];
    _sixLabel.textColor = [UIColor colorWithWhite:0.4 alpha:0.6];
    [_editv addSubview:_sixLabel];
    //提示字符
    _placeholderLabel = [[UILabel alloc] init];
    _placeholderLabel.frame =CGRectMake(5, 5, CGRectGetWidth(_editv.frame)- 15 * 2, 20);
    _placeholderLabel.text = @"来段个性签名,让更多的人了解你!(最多40字)";
    _placeholderLabel.textColor = [UIColor lightGrayColor];
    _placeholderLabel.font = [UIFont systemFontOfSize:13.0];
    _placeholderLabel.enabled = NO; // lable必须设置为不可用
    _placeholderLabel.backgroundColor = [UIColor clearColor];
    [_textView addSubview:_placeholderLabel];
    
    //+pic
    _addPic = [UIButton buttonWithType:UIButtonTypeCustom];
    _addPic.frame = CGRectMake(15, CGRectGetMaxY(_sixLabel.frame) + 5, 60, 60);
    [_addPic setImage:[UIImage imageNamed:@"sadd"] forState:UIControlStateNormal];
    [_addPic addTarget:self action:@selector(addPicEvent) forControlEvents:UIControlEventTouchUpInside];
    _addPic.layer.cornerRadius = 6;
    _addPic.layer.masksToBounds = YES;
    _addPic.backgroundColor = MainColor;
    [_editv addSubview:_addPic];
    _editv.frame = CGRectMake(15, CGRectGetMaxY(self.sflashLabel.frame) + 10, SCREEN_WIDTH - 15 * 2, CGRectGetMaxY(_addPic.frame)+10);
    [self.scrollView addSubview:self.bgView];
    //创建账户信息控件
    UIView *clickSelfInfoBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 73)];
    clickSelfInfoBgView.backgroundColor = [UIColor clearColor];
    //添加手势
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(respondsToSelgInfoAction:)];
    [clickSelfInfoBgView addGestureRecognizer:tapGestureRecognizer];
    UILabel *accountLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 12, SCREEN_WIDTH, 44)];
    accountLabel.text = [NSString stringWithFormat:@"%@账户信息",SPACING];
    accountLabel.font = [UIFont systemFontOfSize:16.f];
    accountLabel.textColor = [UIColor blackColor];
    accountLabel.backgroundColor = [UIColor whiteColor];
    [self.bgView addSubview:accountLabel];
    UILabel *accountInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, 24)];
    accountInfoLabel.font = [UIFont systemFontOfSize:14.f];
    accountInfoLabel.backgroundColor = [UIColor whiteColor];
    accountInfoLabel.textColor = [UIColor grayColor];
    accountInfoLabel.text = [NSString stringWithFormat:@"%@编辑电话，姓名，等",SPACING];
    [self.bgView addSubview:accountInfoLabel];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 30, 30, 15, 15)];
    imageView.image = [UIImage imageNamed:@"right"];
    [self.bgView addSubview:imageView];
    [self.bgView addSubview:clickSelfInfoBgView];
    
    // 创建行业属性视图
    NSArray *hyData = [SCHY componentsSeparatedByString:@" "];
    SAttributeView *attributeViewHY  = [SAttributeView attributeViewWithTitle:[NSString stringWithFormat:@"%@所处行业：",SPACING] titleFont:[UIFont systemFontOfSize:16.f] attributeTexts:hyData viewWidth:SCREEN_WIDTH btnBgColor:BgColor];
    self.attributeViewHY= attributeViewHY;
    attributeViewHY.y = CGRectGetMaxY(accountInfoLabel.frame);
    [self.bgView addSubview:self.attributeViewHY];
    // 设置代理
    attributeViewHY.sAttribute_delegate = self;
    
    //身高标签
    UILabel *heightLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(attributeViewHY.frame), 60, 44)];
    heightLabel.textColor = [UIColor colorWithWhite:0.4 alpha:0.6];
    heightLabel.font = [UIFont systemFontOfSize:16];
    heightLabel.text = @"身高：";
    [_bgView addSubview:heightLabel];
    _heightTextFiled = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(heightLabel.frame), CGRectGetMaxY(attributeViewHY.frame) + 5, SCREEN_WIDTH - 14 - CGRectGetMaxX(heightLabel.frame), 34)];
    _heightTextFiled.font = [UIFont systemFontOfSize:13.f];
    _heightTextFiled.layer.cornerRadius = 3.f;
    _heightTextFiled.backgroundColor = [UIColor whiteColor];
    _heightTextFiled.layer.masksToBounds = YES;
    _heightTextFiled.placeholder = @"请编辑你的身高！";
    _heightTextFiled.delegate = self;
    [_bgView addSubview:_heightTextFiled];
    
    //兴趣爱好标签
    _hobbyLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(heightLabel.frame) + 10, SCREEN_WIDTH, 20)];
    _hobbyLabel.text = @"兴趣爱好：";
    _hobbyLabel.font = [UIFont systemFontOfSize:16.0];
    _hobbyLabel.textColor = [UIColor colorWithWhite:0.4 alpha:0.6];
    [_bgView addSubview:_hobbyLabel];
    //兴趣爱好编辑框
    _hobbyEditField = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_hobbyLabel.frame) + 10, SCREEN_WIDTH- 15 * 2, 80)];
    _hobbyEditField.backgroundColor = [UIColor whiteColor];
    _hobbyEditField.layer.cornerRadius = 3.f;
    _hobbyEditField.layer.masksToBounds = YES;
    _hobbyEditField.font = [UIFont systemFontOfSize:13.f];
    _hobbyEditField.numberOfLines = 0;
    //_hobbyTextField.placeholder = @"兴趣爱好可以多选哦！";
    [_bgView addSubview:_hobbyEditField];
    //兴趣爱好提示符
    _habbyPlaceholderLabel = [[UILabel alloc] init];
    _habbyPlaceholderLabel.frame = CGRectMake(5,5, SCREEN_WIDTH - 35, 20);
    _habbyPlaceholderLabel.text = @"兴趣爱好可以多选哦！";
    _habbyPlaceholderLabel.textColor = RGB_COLOR(242, 241, 245, 0.2);
    _habbyPlaceholderLabel.font = [UIFont systemFontOfSize:13.0];
    _habbyPlaceholderLabel.enabled = NO; // lable必须设置为不可用
    _habbyPlaceholderLabel.backgroundColor = [UIColor clearColor];
    [_hobbyEditField addSubview:_habbyPlaceholderLabel];
    //添加手势
    UIView *hobbyEditView = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_hobbyLabel.frame) + 10,SCREEN_WIDTH- 15 * 2, 60)];
    hobbyEditView.backgroundColor = [UIColor clearColor];
    [_bgView addSubview:hobbyEditView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(respondsToHobbyLabel:)];
    [hobbyEditView addGestureRecognizer:tap];
    
    //个人性格标签
    _spersonalityLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(_hobbyEditField.frame) + 10, SCREEN_WIDTH, 20)];
    _spersonalityLabel.text = @"个人性格：";
    _spersonalityLabel.font = [UIFont systemFontOfSize:16.0];
    _spersonalityLabel.textColor = [UIColor colorWithWhite:0.4 alpha:0.6];
    [_bgView addSubview:_spersonalityLabel];
    //个人性格编辑框
    _spersonalityTextView = [[UITextView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_spersonalityLabel.frame) + 10, SCREEN_WIDTH- 15 * 2, 60)];
    _spersonalityTextView.backgroundColor = [UIColor whiteColor];
    _spersonalityTextView.layer.cornerRadius = 3.f;
    _spersonalityTextView.layer.masksToBounds = YES;
    _spersonalityTextView.delegate = self;
    _sperTextViewNumL = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH- 15 * 2 - 50, 50, 50, 10)];
    _sperTextViewNumL.backgroundColor = [UIColor clearColor];
    _sperTextViewNumL.text = @"1/120";
    _sperTextViewNumL.font = [UIFont systemFontOfSize:10];
    _sperTextViewNumL.textColor = [UIColor grayColor];
    _sperTextViewNumL.textAlignment = NSTextAlignmentRight;
    [_spersonalityTextView addSubview:_sperTextViewNumL];
    [_bgView addSubview:_spersonalityTextView];
    //个人性格编辑框的提示字符
    _spersonalityPlaceholderLabel = [[UILabel alloc] init];
    _spersonalityPlaceholderLabel.frame = CGRectMake(5,5, SCREEN_WIDTH - 35, 20);
    _spersonalityPlaceholderLabel.text = @"来段个人性格描述,让更多的人了解你!(限120字)";
    _spersonalityPlaceholderLabel.textColor = [UIColor colorWithWhite:0.4 alpha:0.6];
    _spersonalityPlaceholderLabel.font = [UIFont systemFontOfSize:13.0];
    _spersonalityPlaceholderLabel.enabled = NO; // lable必须设置为不可用
    _spersonalityPlaceholderLabel.backgroundColor = [UIColor clearColor];
    [_spersonalityTextView addSubview:_spersonalityPlaceholderLabel];
    
    //个人缺点标签
    _sdisadvantagesLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(_spersonalityTextView.frame) + 10, SCREEN_WIDTH - 15 * 2, 20)];
    _sdisadvantagesLabel.text = @"个人缺点：";
    _sdisadvantagesLabel.font = [UIFont systemFontOfSize:16.0];
    _sdisadvantagesLabel.textColor = [UIColor colorWithWhite:0.4 alpha:0.6];
    [_bgView addSubview:_sdisadvantagesLabel];
    //个人缺点编辑框
    _sdisadvantagesTextView = [[UITextView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_sdisadvantagesLabel.frame) + 10, SCREEN_WIDTH - 15 * 2, 60)];
    _sdisadvantagesTextView.backgroundColor = [UIColor whiteColor];
    _sdisadvantagesTextView.layer.cornerRadius = 3.f;
    _sdisadvantagesTextView.layer.masksToBounds = YES;
    _sdisadvantagesTextView.delegate = self;
    _sdisTextViewNumL = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH- 15 * 2 - 50, 50, 50, 10)];
    _sdisTextViewNumL.backgroundColor = [UIColor clearColor];
    _sdisTextViewNumL.text = @"1/80";
    _sdisTextViewNumL.font = [UIFont systemFontOfSize:10];
    _sdisTextViewNumL.textColor = [UIColor grayColor];
    _sdisTextViewNumL.textAlignment = NSTextAlignmentRight;
    [_sdisadvantagesTextView addSubview:_sdisTextViewNumL];
    [_bgView addSubview:_sdisadvantagesTextView];
    //个人缺点提示字符
    _sdisadvantagesPlaceholderLabel = [[UILabel alloc] init];
    _sdisadvantagesPlaceholderLabel.frame = CGRectMake(5, 5, SCREEN_WIDTH - 35, 20);
    _sdisadvantagesPlaceholderLabel.text = @"来段个人缺点描述吧,让更多的人了解你!(限80字)";
    _sdisadvantagesPlaceholderLabel.textColor = [UIColor colorWithWhite:0.4 alpha:0.6];
    _sdisadvantagesPlaceholderLabel.font = [UIFont systemFontOfSize:13.0];
    _sdisadvantagesPlaceholderLabel.enabled = NO; // lable必须设置为不可用
    _sdisadvantagesPlaceholderLabel.backgroundColor = [UIColor clearColor];
    [_sdisadvantagesTextView addSubview:_sdisadvantagesPlaceholderLabel];
    
}

-(void)selectPhotoAlbum{
    //1.获取媒体支持格式
    NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    _imagePickerController.mediaTypes = @[mediaTypes[0]];
    //5.其他配置
    //allowsEditing是否允许编辑，如果值为no，选择照片之后就不会进入编辑界面
    _imagePickerController.allowsEditing = YES;
    //6.推送
    [self presentViewController:_imagePickerController animated:YES completion:nil];
}

-(void)takingPhoto{
    //1.获取媒体支持格式
    NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    //2.判断是否支持需要设置的sourceType
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        //3. 设置sourcetype
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        _imagePickerController.mediaTypes = @[mediaTypes[0]];
        //5.其他配置
        //allowsEditing是否允许编辑，如果值为no，选择照片之后就不会进入编辑界面
        _imagePickerController.allowsEditing = YES;
        //5.1设置相机模式
        _imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        //5.2设置摄像头:前置／后置
        _imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        //5.3设置闪光效果
        _imagePickerController.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
        //6.推送
        [self presentViewController:_imagePickerController animated:YES completion:nil];
        
    }else
    {
        [UIAlertController showAlertWithTitle:@"温馨提示" message:@"设备不支持对应的sourcetype类型！" target:self];
    }

}
/**
 *  渐渐显示立即设置头像，让聊天更有范儿
 */
-(void)showHeadLabel{
    [UIView animateWithDuration:0.70 animations:^{
        self.headLabel.alpha = 1.0;
    }];
}

/**
 *  慢慢消失立即设置头像，让聊天更有范儿
 */
-(void)removeHeadLabel{
    [UIView animateWithDuration:0.70 animations:^{
        self.headLabel.alpha = 0.0;
    }];
}

/**
 * 点击高度编辑框的自定义键盘
 */

-(void)showHeightPackerView{
    [self.view addSubview:self.unableView];
    [self.view addSubview:self.heightPickerBgView];
    weakSelf();
    [UIView animateWithDuration:0.55 animations:^{
        weakSelf.heightPickerBgView.frame = CGRectMake(0, SCREEN_HEIGHT - 150, SCREEN_WIDTH, 150);
    }];
}

-(void)removeHeightPackerView{
    weakSelf();
    isShowPicker = NO;
    [UIView animateWithDuration:0.55 animations:^{
        weakSelf.heightPickerBgView.frame = CGRectMake(0, SCREEN_HEIGHT + 200, SCREEN_WIDTH, 150);
    }completion:^(BOOL finished) {
        [self.unableView removeFromSuperview];
        self.unableView = nil;
    }];
}

-(void)showHobbyPackerView{
    [self.view addSubview:self.unableView];
    [self.view addSubview:self.hobbyPickeBgrView];
    weakSelf();
    [UIView animateWithDuration:0.55 animations:^{
        weakSelf.hobbyPickeBgrView.frame = CGRectMake(0, SCREEN_HEIGHT - 150, SCREEN_WIDTH, 150);
    }];
}

-(void)removeHabbyPackerView{
    weakSelf();
    isShowPicker = NO;
    [UIView animateWithDuration:0.55 animations:^{
        weakSelf.hobbyPickeBgrView.frame = CGRectMake(0, SCREEN_HEIGHT + 200, SCREEN_WIDTH, 150);
    }completion:^(BOOL finished) {
        [self.unableView removeFromSuperview];
        self.unableView = nil;
    }];
}


#pragma mark - ******* Events *******

-(void)respondsToHobbyKeyBoardClearItem:(UIButton *)sender{
     isShowPicker = NO;
    [self removeHabbyPackerView];
    [_hobbys removeAllObjects];
    _hobbyEditField.text = @"";
    _habbyPlaceholderLabel.text = @"兴趣爱好可以多选哦！";
}

/**
 *  兴趣爱好
 *
 *  @param gesture
 */
-(void)respondsToHobbyLabel:(UITapGestureRecognizer*)gesture{
    if (!isShowPicker) {
        [self showHobbyPackerView];
        isShowPicker = YES;
    }
}
/**
 *  高度键盘上的确定按钮
 *
 *  @param sender
 */
-(void)respondsToHeightKeyBoardSureItem:(UIButton *)sender{
    isShowPicker = NO;
    _heightStr = _tempHeightStr;
    self.heightTextFiled.text = _heightStr;
    [self removeHeightPackerView];
    if (_tempHeightStr.length == 0 || [_tempHobbyStr isKindOfClass:[NSNull class]] || _tempHeightStr == nil) {
        _tempHeightStr = @"";
    }
    
}

-(void)respondsToHobbyKeyBoardSureItem:(UIButton *)sender{
    isShowPicker = NO;
    [self removeHabbyPackerView];
    //异常处理
    if (_tempHobbyStr.length == 0 || [_tempHobbyStr isKindOfClass:[NSNull class]] || _tempHobbyStr == nil) {
        _tempHobbyStr = @"";
    }
    [_hobbys addObject:_tempHobbyStr];
    //数组去重
    NSMutableDictionary *dict = [@{}mutableCopy];
    [_hobbys enumerateObjectsUsingBlock:^(NSString*  _Nonnull object, NSUInteger idx, BOOL * _Nonnull stop) {
        [dict setObject:object forKey:object];
    }];
    [_hobbys removeAllObjects];
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull object, BOOL * _Nonnull stop) {
        [_hobbys addObject:object];
    }];
    NSMutableString *str = [NSMutableString string];
    [_hobbys enumerateObjectsUsingBlock:^(NSString*  _Nonnull object, NSUInteger idx, BOOL * _Nonnull stop) {
        if (object.length == 0) {
            [_hobbys removeObject:@""];
        }
        [str appendString:[NSString stringWithFormat:@"%@%@",object,SPACING]];
    }];
    _hobbyEditField.text = str;
    if (_tempHobbyStr.length == 0) {
         _habbyPlaceholderLabel.text = @"兴趣爱好可以多选哦！";
    }else{
         _habbyPlaceholderLabel.text = @"";
    }
}

/**
 *  账户信息的点击事件
 *
 *  @param gesture
 */
-(void)respondsToSelgInfoAction:(UITapGestureRecognizer*)gesture{
      [self.navigationController pushViewController:[SSelfInfoViewConroller new] animated:YES];
}

/**
 *  头像的点击事件
 *
 *  @param gesture 手势
 */
-(void)respondsToUserHeaderImageView:(UITapGestureRecognizer*)gesture{
    
    //访问相册
    UIAlertController *alerController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请选择" preferredStyle:UIAlertControllerStyleActionSheet];
    [alerController addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //移除window上的主按钮
        [[SFoldawayButton sharSfoldawayButton] removeFromSuperview];
        //相册
        [self selectPhotoAlbum];
        
    }]];
    [alerController addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //移除window上的主按钮
        [[SFoldawayButton sharSfoldawayButton] removeFromSuperview];
        //拍照
        [self takingPhoto];
        
    }]];
    [alerController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    //推送
    [self presentViewController:alerController animated:YES completion:nil];
}

/**
 *  键盘推出的时候为了在空白处点击能够收回键盘
 *
 *  @param gesture 手势
 */

-(void)respondsToUnableView:(UITapGestureRecognizer*)gesture{
    [self.textView resignFirstResponder];
    [self.spersonalityTextView resignFirstResponder];
    [self.sdisadvantagesTextView resignFirstResponder];
    [self removeHabbyPackerView];
    [self removeHeightPackerView];
}
/**
 *  导航条上右侧按钮的点击事件
 *
 *  @param sender 按钮
 */
-(void)respondsRightButtonItem:(UIBarButtonItem *)sender{
    if (isUploading) {
        return;
    }
    isUploading = YES;
    
    [self.textView resignFirstResponder];
    [self.spersonalityTextView resignFirstResponder];
    [self.sdisadvantagesTextView resignFirstResponder];

    if(_imageDataArr.count == 0 || _imageDataArr == nil){
        [UIAlertController showAlertWithTitle:@"温馨提示" message:@"你还没有上传图片哦！" target:self];
        isUploading = NO;
        return;
    }
    //NSLog(@"---------%@",_industryStr);
    NSLog(@"中转字符 %@,-%@,%@,%@,%@,%@",_signatureTempStr,_heightTempStr,_industryTempStr,_hobbyTempSArr,_characterTempStr,_traitTempStr);
    //上传数据
    if (_signatureStr.length == 0 || [_signatureStr isKindOfClass:[NSNull class]]) {
        _signatureStr = _signatureTempStr;
    }
    if (_heightStr.length == 0 || [_heightStr isKindOfClass:[NSNull class]]) {
        _heightStr = _heightTempStr;
    }
    if (_industryStr.length == 0 || [_industryStr isKindOfClass:[NSNull class]]) {
        _industryStr = _industryTempStr;
    }
    if (_characterStr.length == 0 || [_characterStr isKindOfClass:[NSNull class]]) {
        _characterStr = _characterTempStr;
    }
    if (_traitStr.length == 0 || [_traitStr isKindOfClass:[NSNull class]]) {
        _traitStr = _traitTempStr;
    }
    if (_hobbys.count == 0 || [_hobbys isKindOfClass:[NSNull class]]){
        //_hobbys = [_hobbyTempSArr mutableCopy];
        _hobbys = [NSMutableArray arrayWithArray:_hobbyTempSArr];
    }
    NSLog(@"实际值 = %@ - %@  - %@ - %@ - %@ - %@ ",_signatureStr,_heightStr,_industryStr,_hobbys,_characterStr,_traitStr);
    
    [self showProgressHUD:self.view hint:@"正在上传" hide:@"上传完毕"];
       [MUserRegister  upDateWithUserHeadImagePath:_sheadImageData AlbumArray:_imageDataArr Signature:_signatureStr Height:_heightStr IndustryArray:@[_industryStr] CharacterArray:@[_characterStr] DefectArray:@[_traitStr] HobbyArray:_hobbys UpDataCompletion:^(BOOL success, NSError *error, UserInfo *userInfo) {
        if (success) {
            NSLog(@"-----------上传成功了");
            //因为侧边栏永远存在，为了更改上传后的的头像，这里需要发送通知到侧边栏
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changHeadImage" object:_headImage];
            //覆盖原来的头像
            [[NSUserDefaults standardUserDefaults]setObject:_sheadImageData forKey:@"sheadImageData"];
            [self removePorgressHud];
        }else{
            [self removePorgressHud];
            [self showsHint:@"上传失败"];
            isUploading = NO;
            return ;
        }
        //清空数组
        //[_imageArray removeAllObjects];
        //[_imageDataArr removeAllObjects];
        isUploading = NO;
    }];
    
}

/**
 *  添加照片的点击事件
 */
- (void)addPicEvent
{
    
    if (_imageArray.count >= 6) {
        NSLog(@"最多只能上传6张图片");
        
    } else {
        [self selectPictures];
    }
}

/**
 *  选择照片
 */
- (void)selectPictures
{
    //移除window上的主按钮
    [[SFoldawayButton sharSfoldawayButton] removeFromSuperview];
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
    picker.maximumNumberOfSelection = 6 -_imageArray.count;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups = NO;
    picker.delegate = self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings)
                              {
                                  if ([[(ALAsset *)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo])
                                  {
                                      NSTimeInterval duration = [[(ALAsset *)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
                                      
                                      return duration >= 5;
                                  } else {
                                      return YES;
                                  }
                              }];
    
    [self presentViewController:picker animated:YES completion:NULL];
}


/**
 *  9宫格图片布局
 */
- (void)nineGrid
{
    for (UIImageView *imgv in _editv.subviews)
    {
        if ([imgv isKindOfClass:[UIImageView class]]) {
            [imgv removeFromSuperview];
        }
    }
    
    CGFloat width = 60;
    CGFloat widthSpace = (SCREEN_WIDTH - 15 * 4 - 60 * 4) / 3.0;
    CGFloat heightSpace = 10;
    
    
    NSInteger count = _imageArray.count;
    _imageArray.count > 6 ? (count = 6) : (count = _imageArray.count);
    
    for (int i = 0; i < count; i++)
    {
        UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(15 + (width+widthSpace) * (i % 4), (i / 4)*(width+heightSpace) + CGRectGetMaxY(_sixLabel.frame) + 5, width, width)];
        imgv.image = _imageArray[i];
        imgv.contentMode = UIViewContentModeScaleAspectFill;
        imgv.layer.masksToBounds = YES;
        imgv.layer.cornerRadius = 3.f;
        imgv.userInteractionEnabled = YES;
        [_editv addSubview:imgv];
        
        UIButton *delete = [UIButton buttonWithType:UIButtonTypeCustom];
        delete.frame = CGRectMake(width-30, 0, 30, 30);
        delete.imageEdgeInsets = UIEdgeInsetsMake(0, 12, 12, 0);
        //delete.layer.cornerRadius = 8.f;
        //delete.layer.masksToBounds = YES;
        [delete setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        [delete addTarget:self action:@selector(deleteEvent:) forControlEvents:UIControlEventTouchUpInside];
        delete.tag = 10+i;
        [imgv addSubview:delete];
        
        if (i == _imageArray.count - 1)
        {
            if (_imageArray.count % 4 == 0) {
                _addPic.frame = CGRectMake(15, CGRectGetMaxY(imgv.frame) + heightSpace, 60, 60);
            } else {
                _addPic.frame = CGRectMake(CGRectGetMaxX(imgv.frame) + widthSpace, CGRectGetMinY(imgv.frame), 60, 60);
            }
            _editv.frame = CGRectMake(15, CGRectGetMaxY(self.sflashLabel.frame) + 10, SCREEN_WIDTH-15*2, CGRectGetMaxY(_addPic.frame)+10);
            self.bgView.frame = CGRectMake(0, CGRectGetMaxY(_editv.frame), SCREEN_WIDTH, 1000);
        }
    }
    if (count == 6) {
        _addPic.alpha = 0;
    }
}
/**
 *  删除照片
 *
 *  @param sender 删除按钮
 */
- (void)deleteEvent:(UIButton *)sender
{
    _addPic.alpha = 1.0;
    UIButton *btn = (UIButton *)sender;
    [_imageArray removeObjectAtIndex:btn.tag-10];
    [_imageDataArr removeObjectAtIndex:btn.tag - 10];
    
    [self nineGrid];
    
    if (_imageArray.count == 0)
    {
        _addPic.frame = CGRectMake(15, CGRectGetMaxY(_sixLabel.frame) + 5, 60, 60);
        _editv.frame = CGRectMake(15, CGRectGetMaxY(self.sflashLabel.frame) + 10, SCREEN_WIDTH-15*2, CGRectGetMaxY(_addPic.frame)+10);
        self.bgView.frame = CGRectMake(0, CGRectGetMaxY(_editv.frame), SCREEN_WIDTH, 1000);
    }
}

/**
 *  自定义属性视图的上button得点击事件
 *
 *  @param view 属性视图
 *  @param btn  按钮
 */
- (void)sAttribute_View:(SAttributeView *)view didClickBtn:(UIButton *)btn{
    // 判断, 根据点击不同的attributeView上的标签, 执行不同的代码
    NSString *title = btn.titleLabel.text;
    if (!btn.selected) {
        title = @"";
    }
    if ([view isEqual:self.attributeViewHY]) {
        _industryStr = title;
    }

}

#pragma mark - ******* KeyboardNotifications *******

-(void)registerForKeyboardNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillApper:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidApper:)name :UIKeyboardWillHideNotification object:nil];
    
}

-(void)keyboardWillApper:(NSNotification*)sender{
    if (isShowKeyBoard) {
        return;
    }
    isShowKeyBoard = YES;
    NSDictionary *info = [sender userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    __block CGSize keyboardSize = [value CGRectValue].size;
    [self.view addSubview:self.unableView];
    [UIView animateWithDuration:0.35 animations:^{
        //重新新约束
        weakSelf();
        if (_cureenPositionK.y < 30) {
            keyboardSize = CGSizeMake(0, 100);
        }else if(_cureenPositionK.y >= 30 && _cureenPositionK.y < 110)
        {
            keyboardSize = CGSizeMake(0, 0);
        }
        weakSelf.view.origin = CGPointMake(weakSelf.view.origin.x, weakSelf.view.origin.y - keyboardSize.height);
    }];
}

-(void)keyboardDidApper:(NSNotification*)sender{
    isShowKeyBoard = NO;
    NSDictionary *info = [sender userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    __block CGSize keyboardSize = [value CGRectValue].size;
    //重新新约束
    [UIView animateWithDuration:0.75 animations:^{
        weakSelf();
        _unableView.alpha = 0;
        if (_cureenPositionK.y < 30) {
            keyboardSize = CGSizeMake(0, 100);
        }else if(_cureenPositionK.y >= 30 && _cureenPositionK.y < 110)
        {
             keyboardSize = CGSizeMake(0, 0);
        }
        weakSelf.view.origin = CGPointMake(weakSelf.view.origin.x, weakSelf.view.origin.y + keyboardSize.height);
    }completion:^(BOOL finished) {
        [self.unableView removeFromSuperview];
        self.unableView = nil;
    }];
}


#pragma mark - ******* delegate *******

- (void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                   {
                       for (int i=0; i<assets.count; i++)
                       {
                           ALAsset *asset = assets[i];
                           UIImage *tempImg = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
                           
                           
                           [_imageArray addObject:tempImg];
                           //NSData *imageData = UIImagePNGRepresentation(tempImg);
                           NSData *imageData = UIImageJPEGRepresentation(tempImg,0.2);
                           /*
                           NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                           NSString *imagePath = [documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"shenhuozhao%@",[self getRandomString]]];
                           //保存到document
                           [imageData writeToFile:imagePath atomically:NO];
                           [_imageIndexPathArr addObject:imagePath];
                            */
                           [_imageDataArr addObject:imageData];
                           dispatch_async(dispatch_get_main_queue(), ^{
                               [self nineGrid];
                           });
                       }
                   });
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView == _textView) {
        if (_textView.text.length == 0) {
            _placeholderLabel.text = @"来段个性签名,让更多的人了解你!(最多40字)";
        } else {
            _placeholderLabel.text = @"";
            if (textView.text.length > 40) {
                return;
            }
            _textViewNumL.text = [NSString stringWithFormat:@"%ld/40",textView.text.length];
            
        }
    }else if(textView == _spersonalityTextView) {
        if (_spersonalityTextView.text.length == 0) {
            _spersonalityPlaceholderLabel.text = @"来段个人性格描述,让更多的人了解你!(限120字)";
        } else {
            _spersonalityPlaceholderLabel.text = @"";
            if (textView.text.length > 120) {
                return;
            }
            _sperTextViewNumL.text = [NSString stringWithFormat:@"%ld/120",textView.text.length];
        }
    }else if(textView == _sdisadvantagesTextView){
        if (_sdisadvantagesTextView.text.length == 0) {
            _sdisadvantagesPlaceholderLabel.text = @"来段缺点描述,让更多的人了解你!(限80字)";
        } else {
            _sdisadvantagesPlaceholderLabel.text = @"";
            if (textView.text.length > 80) {
                return;
            }
            _sdisTextViewNumL.text = [NSString stringWithFormat:@"%ld/80",textView.text.length];
        }
    }
    
}


-(void)textViewDidEndEditing:(UITextView *)textView{
    if (textView == _textView) {
        if (textView.text.length > 40) {
            [UIAlertController showAlertWithTitle:@"温馨提示" message:@"你编辑的信息超过40个字符了" target:self];
            _signatureStr = @"";
        }else{
            _signatureStr = textView.text;
        }
    }
    
    if (textView == _spersonalityTextView) {
        if (textView.text.length > 120) {
            _characterStr = @"";
            [UIAlertController showAlertWithTitle:@"温馨提示" message:@"你编辑的信息超过120个字符了" target:self];
        }else{
            _characterStr =  textView.text;
        }
    }
    
    if (textView == _sdisadvantagesTextView) {
        if (textView.text.length > 80) {
            [UIAlertController showAlertWithTitle:@"温馨提示" message:@"你编辑的信息超过80个字符了" target:self];
            _traitStr = @"";
        }else{
            _traitStr =  textView.text;
        }
    }
}


-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == self.heightTextFiled) {
        [textField resignFirstResponder];
        if(!isShowPicker){
            [self showHeightPackerView];
            isShowPicker = YES;
        }
    }
}


//用户点击选择按钮会触发
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    _headImage = info[UIImagePickerControllerEditedImage];
    self.userHeaderImageView.image = _headImage;
    
    //NSData *imageData = UIImagePNGRepresentation(info[UIImagePickerControllerEditedImage]);
    _sheadImageData = UIImageJPEGRepresentation(info[UIImagePickerControllerEditedImage], 0.2);
    //消失图片拾取器
    [self dismissViewControllerAnimated:YES completion:nil];
}
//用户点击取消按钮会触发
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //消失图片拾取器
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //NSLog(@"%f------",scrollView.contentOffset.y);
    if (scrollView != self.scrollView) {
        return;
    }
    CGPoint currenPosition = scrollView.contentOffset;
    _cureenPositionK = currenPosition;
    if (currenPosition.y < 0) {
        [self showHeadLabel];
        return;
    }
    if ((currenPosition.y - _lastPosition.y > 10)) {
        [self removeHeadLabel];
        _lastPosition = currenPosition;
    }else if (_lastPosition.y - currenPosition.y > 10) {
        [self showHeadLabel];
        _lastPosition = currenPosition;
    }
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView != self.scrollView) {
        return;
    }
    CGPoint currenPosition = scrollView.contentOffset;
    if (currenPosition.y == 0 || currenPosition.y == scrollView.contentSize.height - SCREEN_HEIGHT) {
        [self showHeadLabel];
    }
}


#pragma mark - ******* PickerView的数据源方法 *******

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    //身高选择器
    if (pickerView == _heightPickerView) {
        switch (component) {
            case 0:
                return  1;
                break;
            case 1:{
                return [_heightArr count];
            }
            case 2:{
                NSInteger pickerViewIndexPath = [pickerView selectedRowInComponent:1];
                return [_heightDetailArr[pickerViewIndexPath] count];
            }
                break;
            default:
                break;
        }
        return 0;
    }
    //兴趣爱好选择器
    else{
        switch (component) {
            case 0:
                return  1;
                break;
            case 1:{
                return [_hobbyArr count];
            }
            case 2:{
                NSInteger pickerViewIndexPath = [pickerView selectedRowInComponent:1];
                return [_hobbyDetailArr[pickerViewIndexPath] count];
            }
                break;
            default:
                break;
        }
        return 0;
    }
}

#pragma mark - ******* PickerView的代理方法 *******

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    //身高选择器
    if (pickerView == _heightPickerView) {
        switch (component) {
            case 0:
            {
                return @"我的身高";
            }
                break;
            case 1:
            {
                
                return _heightArr[row];
            }
                break;
            case 2:
            {
                NSInteger pickerViewIndexPath = [pickerView selectedRowInComponent:1];
                return _heightDetailArr[pickerViewIndexPath][row];
            }
                break;
                
            default:
                break;
        }
         return nil;
    }
    //兴趣爱好选择器
    else{
        switch (component) {
            case 0:
            {
                return @"兴趣爱好";
            }
                break;
            case 1:
            {
                return _hobbyArr[row];
            }
                break;
            case 2:
            {
                NSInteger pickerViewIndexPath = [pickerView selectedRowInComponent:1];
                return _hobbyDetailArr[pickerViewIndexPath][row];
            }
                break;
                
            default:
                break;
        }
         return nil;
    }
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    //身高选择器
    if(pickerView == _heightPickerView){
        switch (component) {
            case 0:
            {
                [pickerView reloadComponent:1];
                [pickerView selectRow:0 inComponent:1 animated:YES];
                
                [pickerView reloadComponent:2];
                [pickerView selectRow:0 inComponent:2 animated:YES];
            }
                break;
            case 1:
            {
                [pickerView reloadComponent:2];
                [pickerView selectRow:0 inComponent:2 animated:YES];
                NSInteger currentRow = [pickerView selectedRowInComponent:1];
                NSString *str = @"";
                if ([_heightDetailArr[row] containsObject:@"cm"]) {
                    str = @"cm";
                }
                _tempHeightStr = [NSString stringWithFormat:@"%@ %@",_heightArr[currentRow],str];
            }

        }
    }
    //兴趣爱好选择器
    else{
        switch (component) {
            case 0:
            {
                [pickerView reloadComponent:1];
                [pickerView selectRow:0 inComponent:1 animated:YES];
                
                [pickerView reloadComponent:2];
                [pickerView selectRow:0 inComponent:2 animated:YES];
            }
                break;
            case 1:
            {
                [pickerView reloadComponent:2];
                [pickerView selectRow:0 inComponent:2 animated:YES];
            }
            case 2:{
                NSInteger currentRow = [pickerView selectedRowInComponent:1];
                _tempHobbyStr = [NSString stringWithFormat:@"%@: %@",_hobbyArr[currentRow] ,_hobbyDetailArr[currentRow][row]];
            }
        }
    }
}


#pragma mark - ******* Getters *******

-(UIView *)heightPickerBgView{
    if (!_heightPickerBgView) {
        _heightPickerBgView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT + 200, SCREEN_WIDTH, 150)];
        _heightPickerBgView.backgroundColor = BgColor;
        [_heightPickerBgView addSubview:self.heightPickerView];
        // 确定按钮
        UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        sureButton.frame = CGRectMake(SCREEN_WIDTH - 72, 4, 60, 28);
        [sureButton setTitle:@"确 定" forState:UIControlStateNormal];
        sureButton.layer.borderWidth = 1.f;
        sureButton.layer.borderColor = MainColor.CGColor;
        sureButton.layer.cornerRadius = 3.f;
        sureButton.layer.masksToBounds = YES;
        [sureButton setTitleColor:MainColor forState:UIControlStateNormal];
        [sureButton addTarget:self action:@selector(respondsToHeightKeyBoardSureItem:) forControlEvents:UIControlEventTouchUpInside];
        [_heightPickerBgView addSubview:sureButton];
    }
    return _heightPickerBgView;
}

-(UIPickerView*)heightPickerView{
    if (!_heightPickerView) {
        _heightPickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 150 - 114, SCREEN_WIDTH, 114)];
        _heightPickerView.backgroundColor = [UIColor whiteColor];
        _heightPickerView.dataSource = self;
        _heightPickerView.delegate = self;
    }
    return _heightPickerView;
}

-(UIView *)hobbyPickeBgrView{
    if (!_hobbyPickeBgrView) {
        _hobbyPickeBgrView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT + 200, SCREEN_WIDTH, 150)];
        _hobbyPickeBgrView.backgroundColor = BgColor;
        [_hobbyPickeBgrView addSubview:self.hobbyPickerView];
        // 确定按钮
        UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        sureButton.frame = CGRectMake(SCREEN_WIDTH - 72, 4, 60, 28);
        [sureButton setTitle:@"确 定" forState:UIControlStateNormal];
        sureButton.layer.borderWidth = 1.f;
        sureButton.layer.borderColor = MainColor.CGColor;
        sureButton.layer.cornerRadius = 3.f;
        sureButton.layer.masksToBounds = YES;
        [sureButton setTitleColor:MainColor forState:UIControlStateNormal];
        [sureButton addTarget:self action:@selector(respondsToHobbyKeyBoardSureItem:) forControlEvents:UIControlEventTouchUpInside];
        [_hobbyPickeBgrView addSubview:sureButton];
        // 清空按钮
        UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
        clearButton.frame = CGRectMake(12, 4, 60, 28);
        [clearButton setTitle:@"清 空" forState:UIControlStateNormal];
        clearButton.layer.borderWidth = 1.f;
        clearButton.layer.borderColor = MainColor.CGColor;
        clearButton.layer.cornerRadius = 3.f;
        clearButton.layer.masksToBounds = YES;
        [clearButton setTitleColor:MainColor forState:UIControlStateNormal];
        [clearButton addTarget:self action:@selector(respondsToHobbyKeyBoardClearItem:) forControlEvents:UIControlEventTouchUpInside];
        [_hobbyPickeBgrView addSubview:clearButton];
    }
    return _hobbyPickeBgrView;
}


-(UIPickerView*)hobbyPickerView{
    if (!_hobbyPickerView) {
        _hobbyPickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 150 -114, SCREEN_WIDTH,114)];
        _hobbyPickerView.backgroundColor = [UIColor whiteColor];
        _hobbyPickerView.dataSource = self;
        _hobbyPickerView.delegate = self;
    }
    return _hobbyPickerView;
}

-(UIImageView *)userHeaderImageView{
    if (!_userHeaderImageView) {
        _userHeaderImageView = ({
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 30)];
            label.backgroundColor = MainColor;
            label.text = @"立即编辑个人信息，让聊天更有范儿";
            label.font = [UIFont systemFontOfSize:14.f];
            label.textColor = [UIColor grayColor];
            label.textAlignment = NSTextAlignmentCenter;
            [self.view addSubview:label];
            _headLabel = label;
            UIImageView  *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
            imageView.center = CGPointMake(self.scrollView.center.x, 75);
            imageView.layer.cornerRadius = 40.f;
            imageView.clipsToBounds = YES;
            imageView.image = [UIImage imageNamed:@"tupianzwu"];
            imageView.userInteractionEnabled = YES;
            imageView.image = _headImage;
            //添加手势
            UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(respondsToUserHeaderImageView:)];
            [imageView addGestureRecognizer:tapGestureRecognizer];
            imageView;
        });
    }
    return _userHeaderImageView;
}

-(SFlashLabel *)sflashLabel{
    if (!_sflashLabel) {
        _sflashLabel = ({
            SFlashLabel *label = [[SFlashLabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.userHeaderImageView.frame) + 20, SCREEN_WIDTH, 20)];
            [label setText:@"用最真实的自己遇见最适合的TA"];
            [label setFont:[UIFont systemFontOfSize:18]];
            [label setTextColor:[UIColor grayColor]];
            [label setSpotlightColor:MainColor];
            [label setContentMode:UIViewContentModeTop];
            [label startAnimating];
            label;
        });
    }
    return _sflashLabel;
}

-(UIView *)bgView{
    if (!_bgView) {
        _bgView.userInteractionEnabled = YES;
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_editv.frame) + 10, SCREEN_WIDTH,1000)];
        _bgView.backgroundColor = BgColor;
    }
    return _bgView;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication].keyWindow addSubview:[SFoldawayButton sharSfoldawayButton]];
}


-(UIView *)unableView{
    if (!_unableView) {
        _unableView = [[UIView alloc]initWithFrame:self.view.frame];
        _unableView.backgroundColor = RGB_COLOR(255, 255, 255, 0);
        _unableView.alpha = 1.0;
        //_unableView.alpha = 1.0;
        //添加手势
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(respondsToUnableView:)];
        [_unableView addGestureRecognizer:tapGestureRecognizer];

    }
    return _unableView;
}


@end
