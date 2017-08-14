//
//  SFriendsViewController.m
//  BootyCall
//
//  Created by mac on 16/8/10.
//  Copyright © 2016年 dazhongdiy. All rights reserved.
//

#import "SFriendsViewController.h"
#import "UIView+SFrame.h"
#import "ColorView.h"
#import "SFoldawayButton.h"
@interface SFriendsViewController ()<UITextViewDelegate,UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,ColorViewDelegate,UITableViewDelegate,UITableViewDataSource>
/**
 *  标题
 */
@property(nonatomic,strong)UITextField *titleTextFile;
/**
 *  content
 */
@property(nonatomic,strong)UITextView *conTentTextView;

/**
 *  分类
 */
@property(nonatomic,strong)UITableView *classifyTableivew;
/**
 *  分类按钮
 */
@property(nonatomic,strong)UIButton *classifyButton;
/**
 *  心情
 */
@property(nonatomic,strong)NSMutableArray  *dataSource;


/**
 *  背景图片
 */
@property(nonatomic,strong)UIImageView *contentBg;



@property(nonatomic,strong)UIView *settingView;

/**
 *  是否设置
 */
@property(nonatomic,assign)BOOL isSetting;
/**
 *  改变颜色还是字体
 */
@property(nonatomic,assign)BOOL isChangeColor;
/**
 *  文字属性
 */
@property(nonatomic,strong)NSMutableAttributedString *attribute;
/**
 *  图片路径
 */
@property(nonatomic,strong)NSString  *imagePath;
/**
 *  图片data
 */
@property(nonatomic,strong)NSData *imageData;

/**
 *  提示
 */
@property(nonatomic,strong)UILabel *tipLabel;
/**
 *  遮罩
 */
@property(nonatomic,strong)UIView *shadowView;
/**
 *  点击手势
 */
@property(nonatomic,strong)UITapGestureRecognizer *tapGes;
/**
 *  关闭按钮
 */
@property(nonatomic,strong)UIButton *closeBtn;
/**
 *  字体小
 */
@property(nonatomic,strong)UIButton *smallFont;
/**
 *  字体中
 */
@property(nonatomic,strong)UIButton *middelFont;
/**
 *  字体大
 */
@property(nonatomic,strong)UIButton *bigFont;
/**
 *  背景
 */
@property(nonatomic,strong)UIButton *imageBtn;
/**
 *  颜色
 */
@property(nonatomic,strong)UIButton *colorBtn;


/**
 *
 */
@property(nonatomic,assign)CGSize keyboardSize;

/**
 *小字体Centerx
 */
@property(nonatomic,assign)CGFloat ScenterX;
/**
 *  中
 */
@property(nonatomic,assign)CGFloat Mcenterx;
/**
 *  大
 */
@property(nonatomic,assign)CGFloat BcenterX;
/**
 *  图片
 */
@property(nonatomic,assign)CGFloat imageCenterX;

/**
 *  颜色按钮
 */
@property(nonatomic,assign)CGFloat colorCenterX;






@end

@implementation SFriendsViewController

//获取布局后的坐标
-(void)viewDidLayoutSubviews {

    
    self.ScenterX = self.smallFont.centerX;
    self.Mcenterx = self.middelFont.centerX;
    self.BcenterX = self.bigFont.centerX;
    self.imageCenterX = self.imageBtn.centerX;
    self.colorCenterX = self.colorBtn.centerX;


}
-(void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    [[UIApplication sharedApplication].keyWindow addSubview:[SFoldawayButton sharSfoldawayButton]];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = MainColor;
    self.navigationItem.title = @"心情物语";
    self.dataSource = @[@"情感",@"杂记",@"生活",@"治愈"].mutableCopy;
    [self initializeInterface];
    
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveItemAction:)];
    saveItem.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = saveItem;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboradShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboradHidden:) name:UIKeyboardWillHideNotification object:nil];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"sback"] style:UIBarButtonItemStylePlain target:self action:@selector(respondsToLeftButtonItem)];
    leftButtonItem.imageInsets = UIEdgeInsetsMake(5, -10, 2, 17);
    self.navigationItem.leftBarButtonItems = @[leftButtonItem];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    
}

-(void)initializeInterface {
    

    [self.view addSubview:self.titleTextFile];
    [self.view addSubview:self.contentBg];
    [self.contentBg addSubview:self.conTentTextView];
    [self.conTentTextView addSubview:self.tipLabel];
    [self.view addSubview:self.classifyButton];
    [self.view addSubview:self.classifyTableivew];
    [self.shadowView addSubview:self.settingView];

    
    
    
    
    
    [self.settingView addSubview:self.smallFont];
    [self.settingView addSubview:self.middelFont];
    [self.settingView addSubview:self.bigFont];
    [self.settingView addSubview:self.imageBtn];
    [self.settingView addSubview:self.colorBtn];
    [self.settingView addSubview:self.closeBtn];
    
    [self makeConstraint];
    
    
}


-(void)makeConstraint {
    
    weakSelf();
    [self.titleTextFile mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left);
        make.top.equalTo(weakSelf.view.mas_top).offset(64);
        make.width.equalTo(weakSelf.view.mas_width).multipliedBy(0.7);
        make.height.equalTo(@35);
        
    }];
    [self.classifyButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self..mas_top).offset(10);
//        make.bottom.equalTo(self.titleTextFile.mas_bottom).offset(-10);
//        make.right.equalTo(self.titleTextFile.mas_right).offset(-10);
//        make.width.equalTo(self.titleTextFile.mas_width).multipliedBy(0.2);
        
        make.centerY.equalTo(weakSelf.titleTextFile.mas_centerY);
//        make.width.equalTo(self.titleTextFile.mas_width).multipliedBy(0.2);
        make.height.equalTo(@30);
        make.left.equalTo(weakSelf.titleTextFile.mas_right);
        make.right.equalTo(weakSelf.view.mas_right);
        
    }];
    
    
    //
    [self.classifyTableivew mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.classifyButton.mas_bottom);
        make.left.equalTo(weakSelf.classifyButton.mas_left);
        make.height.equalTo(@0);
        make.right.equalTo(weakSelf.view.mas_right);
        
    }];
  
    [self.contentBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.titleTextFile.mas_bottom).offset(0);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
    [self.conTentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentBg.mas_top).offset(0);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        
    }];



    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.conTentTextView.mas_left);
        make.top.equalTo(weakSelf.conTentTextView.mas_top).offset(5);
        make.width.equalTo(weakSelf.conTentTextView.mas_width);
        make.height.equalTo(@20);
    }];
    
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.settingView.mas_right).offset(-5);
        make.top.equalTo(weakSelf.settingView.mas_top).offset(5);
        make.size.equalTo(@40);
    }];
    
    [self.smallFont mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.settingView.mas_left).offset(10);
        make.top.equalTo(weakSelf.settingView.mas_top).offset(5);
        make.size.equalTo(@40);
    }];
    [self.middelFont mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(weakSelf.smallFont.mas_right).offset(20);
        make.top.equalTo(weakSelf.settingView.mas_top).offset(5);
        make.size.equalTo(@40);
    }];
    [self.bigFont mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(weakSelf.middelFont.mas_right).offset(20);
        make.top.equalTo(weakSelf.settingView.mas_top).offset(5);
        make.size.equalTo(@40);
    }];
    [self.imageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bigFont.mas_right).offset(20);
        make.top.equalTo(weakSelf.settingView.mas_top).offset(5);
        make.size.equalTo(@40);
    }];
    [self.colorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.imageBtn.mas_right).offset(20);
        make.top.equalTo(weakSelf.settingView.mas_top).offset(5);
        make.size.equalTo(@40);
    }];
}
#pragma mark - ColorViewDelegate 


- (void)changeContentTextColor:(UIColor *)color {

//    [_attribute addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:slider.value green:self.greenSlider.value blue:self.blueSlider.value alpha:1]} range:NSMakeRange(0, self.conTentTextView.text.length)];

    [_attribute addAttributes:@{NSForegroundColorAttributeName:color} range:NSMakeRange(0, self.conTentTextView.text.length)];
    self.conTentTextView.attributedText = _attribute;



}
#pragma mark - UItextViewDelegate
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView {

    self.tipLabel.hidden = YES;
    
    [self.view addSubview:self.shadowView];
    [self.shadowView addGestureRecognizer:self.tapGes];
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView {
    
    self.attribute = [[NSMutableAttributedString alloc]initWithString:self.conTentTextView.text];
    if (textView.text.length == 0) {
        self.tipLabel.hidden = NO;
    }else {
    self.tipLabel.hidden = YES;
    
    }

}
-(void)textViewDidEndEditing:(UITextView *)textView {


    if (textView.text.length == 0) {
        
        self.tipLabel.hidden = NO;
    }

}


#pragma mark - tableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"classify" forIndexPath:indexPath];
    
    
    cell.textLabel.text= self.dataSource[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    
    return cell;
    
    
    
    
}
#pragma mark - UITableVieDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.classifyButton setTitle:self.dataSource[indexPath.row] forState:UIControlStateNormal];
    //收回tableView
    [UIView animateWithDuration:0.35 animations:^{
        [self.classifyTableivew mas_updateConstraints:^(MASConstraintMaker *make) {
            self.classifyTableivew.height = 0;
        }];
    }];
    self.classifyButton.selected = NO;
    
}




#pragma mark - Method
-(void)respondsToLeftButtonItem{
    //发送通知到
    [[NSNotificationCenter defaultCenter]postNotificationName:@"showingCurrenController" object:@"0"];
}
-(void)insertBacnkGroundImage :(UIButton *)sender {

    [self.conTentTextView resignFirstResponder];
    [self.titleTextFile resignFirstResponder];
    
    [UIAlertController showAlertWithTitle:@"提示" message:@"添加或删除背景图" actionsMsg:@[@"删除",@"确定"] buttonActions:^(NSInteger index) {
        if (index==0) {
            
            self.contentBg.image = nil;
            
        }else {
            [self addHeadImage];
        }
    }];
   


}

-(void)changeFont:(UIButton *)sender {

    if (sender.tag == 1000) {
        [_attribute addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]} range:NSMakeRange(0, self.conTentTextView.text.length)];
        self.conTentTextView.attributedText = _attribute;
        
    }else if (sender.tag == 10001){
 
        [_attribute addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} range:NSMakeRange(0, self.conTentTextView.text.length)];
        self.conTentTextView.attributedText = _attribute;
    
    }else {
 
    
        [_attribute addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]} range:NSMakeRange(0, self.conTentTextView.text.length)];
        self.conTentTextView.attributedText = _attribute;
    }

    
}


-(void)showColorView :(UIButton *)sender {
    sender.selected = !sender.selected;
    sender.userInteractionEnabled = NO;
    if (sender.selected) {
        [ColorView shareColorView].bounds = CGRectMake(0, 0, 300, 200);
        [ColorView shareColorView].center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds)-50);
        [ColorView shareColorView].delegate = self;
        [self.shadowView addSubview:[ColorView shareColorView]];
        [ColorView shareColorView].transform = CGAffineTransformMakeScale(0.1, 0.1);
        
        [UIView animateWithDuration:0.5 animations:^{
        [ColorView shareColorView].transform = CGAffineTransformMakeScale(1, 1);
        } completion:^(BOOL finished) {
            sender.userInteractionEnabled=  YES;
            
        }];

    }else {
        [UIView animateWithDuration:1 animations:^{
            [ColorView shareColorView].transform =CGAffineTransformMakeScale(0.1, 0.1);
            
            
        } completion:^(BOOL finished) {
            [[ColorView shareColorView] removeFromSuperview];
            [self.shadowView removeFromSuperview];
            sender.userInteractionEnabled = YES;
        }];
    
        
        
        
    }
    
}
-(void)showSettingTool:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    if (sender.selected) {
        [UIView animateWithDuration:0.5 animations:^{
            
                _imageBtn.x = SCREEN_WIDTH-40;
                _smallFont.x =SCREEN_WIDTH -40;
                _middelFont.x =SCREEN_WIDTH -40;
                _bigFont.x = SCREEN_WIDTH -40;
                _colorBtn.x = SCREEN_WIDTH -40;
            
        }];
    }else {
        
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            
            _imageBtn.x =self.imageCenterX;
            _smallFont.x = self.ScenterX;
            _middelFont.x =self.Mcenterx;
            _bigFont.x =self.BcenterX;
            _colorBtn.x = self.colorCenterX;
            
        } completion:nil];
    
        
    }
    
}

-(void)keyboradShow:(NSNotification *)notification {

    NSDictionary *info = [notification userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
     _keyboardSize = CGSizeMake([value CGRectValue].size.width, [value CGRectValue].size.height);
    

    [UIView animateWithDuration:1 animations:^{
      self.settingView.center = CGPointMake(CGRectGetMidX(self.view.bounds), SCREEN_HEIGHT - _keyboardSize.height-30);
        
    }];
    
    

}
-(void)keyboradHidden:(NSNotificationCenter *)notification {


 [UIView animateWithDuration:1 animations:^{
     self.settingView.center = CGPointMake(CGRectGetMidX(self.view.bounds), SCREEN_HEIGHT+30);
     
 }];

}

-(void)TapGesAction:(UITapGestureRecognizer *)tap {
    
    
   
    [self.conTentTextView resignFirstResponder];
    
   [UIView animateWithDuration:1 animations:^{
       [ColorView shareColorView].transform =CGAffineTransformMakeScale(0.1, 0.1);
       
       
   } completion:^(BOOL finished) {
         [[ColorView shareColorView] removeFromSuperview];
          [self.shadowView removeFromSuperview];
   }];
    
    
  
 
//    [UIView animateWithDuration:1 animations:^{
//        self.shadowView.transform = CGAffineTransformMakeScale(0.1, 0.1);
//    } completion:^(BOOL finished) {
//      
//        
//    }];

    
}

-(void)classifyBtnAction:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    //self.classifyTableivew.hidden = !sender.selected;
    if (sender.selected) {
        [UIView animateWithDuration:0.35 animations:^{
            [self.classifyTableivew mas_updateConstraints:^(MASConstraintMaker *make) {
                self.classifyTableivew.height = 120;
            }];
        }];
    }else{
        [UIView animateWithDuration:0.35 animations:^{
            [self.classifyTableivew mas_updateConstraints:^(MASConstraintMaker *make) {
                self.classifyTableivew.height = 0;
            }];
        }];
    }
   
}

-(void)saveItemAction:(UIBarButtonItem *)sender {

    
    if (self.titleTextFile.text.length ==0) {
        [UIAlertController showAlertWithTitle:@"提示" message:@"请输入标题"];
    }else if (self.conTentTextView.text.length == 0){
        
        
        [UIAlertController showAlertWithTitle:@"提示" message:@"请输入正文"];
        
    }else if ([self.classifyButton.titleLabel.text isEqualToString:@"选择分类"]) {
        
        [UIAlertController showAlertWithTitle:@"提示" message:@"请选择分类"];
        
    }else {
        
        [self showProgressHUD:self.view hint:@"正在上传" hide:@"上传结束"];
        [self.conTentTextView resignFirstResponder];
        NSDate *date = [NSDate date];
        NSDateFormatter *formmater = [[NSDateFormatter alloc]init];
        [formmater setDateFormat:@"yyyy-MM-dd"];
        NSString *dataString = [formmater stringFromDate:date];
        NSLog(@"%@",dataString);
        
        //把用户编辑的文本转换成NSData
        NSFileManager *fileM = [NSFileManager defaultManager];
        
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *savepath = [path stringByAppendingString:@"/content.rtfd"];
        
        NSAttributedString * str = self.conTentTextView.attributedText;
        NSDictionary * rtf = [NSDictionary dictionaryWithObject:NSRTFDTextDocumentType forKey:NSDocumentTypeDocumentAttribute];
        NSData * data = [str dataFromRange:NSMakeRange(0, str.length) documentAttributes:rtf error:nil];
        
        BOOL success =   [fileM createFileAtPath:savepath contents:data attributes:rtf];
        
        AVFile *file = [AVFile fileWithName:@"contentAttibute" contentsAtPath:savepath];
        [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            weakSelf();
            if (success) {
                
                [MUserRegister upDiaryInfoWithImagePath:weakSelf.imageData Title:weakSelf.titleTextFile.text Classify:weakSelf.classifyButton.titleLabel.text Content:weakSelf.conTentTextView.text url:file.url date:dataString UpDataCompletion:^(BOOL success, NSError *error, UserInfo *userInfo) {
                    if (success) {
                        [weakSelf removePorgressHud];
                        weakSelf.titleTextFile.text =@"";
                        weakSelf.conTentTextView.text = @"";
                        weakSelf.contentBg.image = nil;
                        
                    }else {
                        [UIAlertController showAlertWithTitle:@"温馨提示" message:@"上传失败,请重新上传"];
                        [weakSelf removePorgressHud];
                    }
                }];
                
            }else {
                [UIAlertController showAlertWithTitle:@"温馨提示" message:error.localizedDescription];
        
                [weakSelf removePorgressHud];
            }
            
        }];
        
        
        
    }
    
}



- (void)addHeadImage{
    UIAlertController *alertControler = [UIAlertController alertControllerWithTitle:@"选择方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //防止循环引用
    __weak typeof(self) weakSelf = self;
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[SFoldawayButton sharSfoldawayButton] removeFromSuperview];
        [weakSelf selectAlbum];
        
    }];
    UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[SFoldawayButton sharSfoldawayButton] removeFromSuperview];
        [weakSelf takePhoto];
    }];
    
    [alertControler addAction:cancelAction];
    [alertControler addAction:albumAction];
    [alertControler addAction:takePhotoAction];
    [self presentViewController:alertControler animated:YES completion:nil];
}
//相册选择
- (void)selectAlbum {
    //UIImagePickerController调用相册
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    //设置代理记住是UINavigationControllerDelegate,UIImagePickerControllerDelegate两个不同的协议
    imagePicker.delegate = self;
    //资源类型(来自相片库，相机，相册)
    imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    //编辑图片//压缩
    imagePicker.allowsEditing = YES;
    // [self presentViewController:imagePicker animated:YES completion:nil];
    [self presentViewController:imagePicker animated:YES completion:^{
        self.tabBarController.tabBar.hidden = YES;
    }];
}
//拍照
- (void)takePhoto {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [UIAlertController showAlertWithTitle:nil message:@"设备不可用" target:self];
        return;
    }
    //UIImagePickerController调用相册
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    //设置代理记住是UINavigationControllerDelegate,UIImagePickerControllerDelegate两个不同的协议
    imagePicker.delegate = self;
    //资源类型(来自相片库，相机，相册)
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    //编辑图片//压缩
    imagePicker.allowsEditing = YES;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
    /**< UIPickerView*/
    /**< UIDatePicker*/
    
}


//保存图片
- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    NSData* imageData = UIImageJPEGRepresentation(tempImage, 0.5);
    NSString* documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* imagePath = [documentPath stringByAppendingPathComponent:imageName];
    
    //保存到 document
    [imageData writeToFile:imagePath atomically:NO];
    self.imagePath = imagePath;
    self.imageData = imageData;
//
    
    
    //[self.albumArray removeAllObjects];
    //    [self.albumArray addObject:imagePath];
}


#pragma mark - ******* Delegate *******

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    self.contentBg.image = info[@"UIImagePickerControllerEditedImage"];
    self.conTentTextView.backgroundColor = [UIColor clearColor];
    [self saveImage:info[@"UIImagePickerControllerEditedImage"] WithName:@"userImage"];
    //处理完毕，回到信息页面
    [picker dismissViewControllerAnimated:YES completion:nil];
}




#pragma mark - Getter

-(UITextField *)titleTextFile {
    
    if (_titleTextFile == nil) {
        
        _titleTextFile = [[UITextField alloc]initWithFrame:CGRectZero];
        _titleTextFile.delegate = self;
        _titleTextFile.placeholder = @"请输入标题";
        _titleTextFile.backgroundColor = [UIColor colorWithWhite:0.967 alpha:1.000];
//        _titleTextFile.borderStyle = UITextBorderStyleRoundedRect;
        _titleTextFile.font = [UIFont fontWithName:@"Arial" size:16.0f];
        //        _titleTextFile.clearButtonMode = UITextFieldViewModeAlways;
        
        
        
    }
    return _titleTextFile;    
    
}

- (UITextView *)conTentTextView {
    if (_conTentTextView == nil) {
        
        _conTentTextView = [[UITextView alloc]initWithFrame:CGRectZero];
        _conTentTextView.font = [UIFont systemFontOfSize:15];
        _conTentTextView.delegate = self;
        _conTentTextView.userInteractionEnabled = YES;
        _conTentTextView.backgroundColor = [UIColor clearColor];
        
    }
    return _conTentTextView;
}


- (UITableView *)classifyTableivew {
    
    if (_classifyTableivew == nil) {
        _classifyTableivew = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _classifyTableivew .delegate = self;
        _classifyTableivew.dataSource =self;
        _classifyTableivew.rowHeight = 30;
        _classifyTableivew.layer.borderWidth = 1;
        _classifyTableivew.layer.borderColor = [UIColor colorWithWhite:0.783 alpha:1.000].CGColor;
        [_classifyTableivew registerClass:[UITableViewCell class] forCellReuseIdentifier:@"classify"];
        _classifyTableivew.backgroundColor = [UIColor redColor];
        //_classifyTableivew.hidden = YES;
        _classifyTableivew.scrollEnabled = NO;
        _classifyTableivew.layer.cornerRadius = 6;
        _classifyTableivew.layer.masksToBounds = YES;
    }
    return _classifyTableivew;
    
    
}

-(UIButton *)classifyButton {
    
    if (_classifyButton == nil) {
        
        _classifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_classifyButton setTitle:@"选择分类" forState:UIControlStateNormal];
        _classifyButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _classifyButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
//        _classifyButton.titleLabel.layer.borderWidth = 1;
//        _classifyButton.titleLabel.layer.borderColor = [UIColor grayColor].CGColor;
        [_classifyButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_classifyButton setImage:[UIImage imageNamed:@"zhankai"] forState:UIControlStateNormal];
        [_classifyButton setImage:[UIImage imageNamed:@"shouqi"] forState:UIControlStateSelected];
        _classifyButton.imageEdgeInsets = UIEdgeInsetsMake(0, 125, -3, 0);
        _classifyButton.contentEdgeInsets = UIEdgeInsetsMake(0, -50, 0, 10);
        [_classifyButton addTarget:self action:@selector(classifyBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _classifyButton;
    
}



- (UIImageView *)contentBg {
    
    if (_contentBg == nil) {
        _contentBg = [[UIImageView alloc]initWithFrame:CGRectZero];
        _contentBg.userInteractionEnabled = YES;
        _contentBg.contentMode = UIViewContentModeScaleAspectFill;
//        _contentBg.backgroundColor = [UIColor redColor];    
    }
    return _contentBg;
    
}

-(UIView *)settingView {
    
    
    if (_settingView == nil) {
        
        _settingView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 50)];
//        _settingView.backgroundColor = [UIColor cyanColor];
        _settingView.backgroundColor = [UIColor clearColor];
        _settingView.hidden = NO;
        
    }
    return _settingView;
    
}



-(UILabel *)tipLabel {
    if (_tipLabel == nil) {
        _tipLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _tipLabel.text = @"请输入正文";
        _tipLabel.textColor = [UIColor grayColor];
        _tipLabel.font = [UIFont systemFontOfSize:15];
        
    }
    return _tipLabel;

}
- (UIView *)shadowView {

    if (_shadowView == nil) {
        
        _shadowView = [[UIView alloc]initWithFrame:self.view.bounds];
        _shadowView.backgroundColor = [UIColor clearColor];
    }
    return _shadowView;

}
-(UITapGestureRecognizer *)tapGes {

    if (_tapGes == nil) {
        _tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapGesAction:)];
        
    }
    return _tapGes;

}

-(UIButton *)closeBtn {

    if (_closeBtn == nil) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"关闭_main"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(showSettingTool:) forControlEvents:UIControlEventTouchUpInside];
        _closeBtn.backgroundColor = [UIColor whiteColor];
    }
    return _closeBtn;

}
- (UIButton *)smallFont {

    if (_smallFont == nil) {
        
        _smallFont = [UIButton buttonWithType:UIButtonTypeCustom];
        [_smallFont setImage:[UIImage imageNamed:@"font_25_main"] forState:UIControlStateNormal];
        [_smallFont addTarget:self action:@selector(changeFont:) forControlEvents:UIControlEventTouchUpInside];
        _smallFont.tag = 1000;
    }
    return _smallFont;

}
-(UIButton *)middelFont {

    if (_middelFont  == nil) {
        
        _middelFont = [UIButton buttonWithType: UIButtonTypeCustom];
        [_middelFont setImage:[UIImage imageNamed:@"font_32_main"] forState:UIControlStateNormal];
       [ _middelFont addTarget:self action:@selector(changeFont:) forControlEvents:UIControlEventTouchUpInside];
        _middelFont.tag = 10001;
    }

    return _middelFont;
}
-(UIButton *)bigFont {
    if (_bigFont == nil) {
        _bigFont = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bigFont setImage:[UIImage imageNamed:@"font_64_main"] forState:UIControlStateNormal];
        [_bigFont addTarget:self action:@selector(changeFont:) forControlEvents:UIControlEventTouchUpInside];
        _bigFont.tag = 10002;
        
        
    }
    return _bigFont;

}
- (UIButton *)imageBtn {
    if (_imageBtn == nil) {
    
        _imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_imageBtn setImage:[UIImage imageNamed:@"photo_main"] forState:UIControlStateNormal];
        [_imageBtn addTarget:self action:@selector(insertBacnkGroundImage:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _imageBtn;

}
- (UIButton *)colorBtn {

    if (_colorBtn == nil) {
        _colorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_colorBtn setImage:[UIImage imageNamed:@"color_main"] forState:UIControlStateNormal];
        [_colorBtn addTarget:self action:@selector(showColorView:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _colorBtn;

}


@end
