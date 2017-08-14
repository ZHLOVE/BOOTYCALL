//
//  MRegisterUserInfoViewController.m
//  BootyCall
//
//  Created by orange on 16/8/14.
//  Copyright © 2016年 dazhongdiy. All rights reserved.
//

#import "MRegisterUserInfoViewController.h"
#import "MUserInfoView.h"
#import "SRootViewController.h"
#import "GITransition.h"
#import "SHelpViewController.h"

@interface MRegisterUserInfoViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
/**< 用户信息view*/
@property(nonatomic,strong)MUserInfoView *userInfoView;
/**< 头像*/
@property(nonatomic,copy)NSData *headImagePath;
/**< 信息*/
@property(nonatomic,strong)NSMutableDictionary *myInfoDic;
/**< 性别*/
@property(nonatomic,copy)NSString *gender;

@end

@implementation MRegisterUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeDataSource];
    [self initializeInterface];
    
}
#pragma mark - ******* <#Initialize#> *******
//初始化数据源
- (void)initializeDataSource{
    
    _myInfoDic = @{}.mutableCopy;
    _gender = @"0";
    
}
//初始化界面

- (void)initializeInterface{
    
    self.title = @"注册3/3";
    self.navigationController.navigationBar.tintColor = [UIColor grayColor];
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       
       NSForegroundColorAttributeName:MainColor}];
    
    self.navigationController.navigationBarHidden = NO;
    self.view.backgroundColor = BgColor;
    [self setControlFrame];
    
    
}
#pragma mark - ******* Methods *******
/**< 设置控件的frame*/
- (void)setControlFrame{
    weakSelf();
    [self.view addSubview:self.userInfoView];
    [self.userInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view.mas_width);
        make.height.equalTo(weakSelf.view.mas_height).offset(-100);
        make.top.equalTo(weakSelf.view.mas_top).offset(100);
    }];
}
/**< 在将要显示的时候使控件恢复原样*/
- (void)viewWillAppear:(BOOL)animated{
    self.userInfoView.completeBtn.enabled = YES;
    self.userInfoView.completeBtn.backgroundColor = MainColor;

}

#pragma mark - ******* Events *******
/**< 查看协议点击回调事件*/
- (void)clickedPrptocolBtn{
    [self.userInfoView.nameTF resignFirstResponder];
    [self.userInfoView.birthdayTF resignFirstResponder];
    GITransition *transitionManager = [[GITransition alloc] init];
    self.transitioningDelegate = transitionManager;
    SHelpViewController *vc  = [[SHelpViewController alloc]init];
    vc.transitioningDelegate = transitionManager;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    vc.transitionManager = transitionManager;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)saveGender:(NSString *)gender{
    _gender = gender;
}

- (void)saveInfo{
    [self.userInfoView.nameTF resignFirstResponder];
    [self.userInfoView.birthdayTF resignFirstResponder];
    self.userInfoView.completeBtn.enabled = NO;
    self.userInfoView.completeBtn.backgroundColor = [UIColor grayColor];
    if (self.userInfoView.nameTF.text.length > 10 || self.userInfoView.nameTF.text.length == 0 || self.userInfoView.birthdayTF.text == 0) {
        [UIAlertController showAlertWithTitle:@"温馨提示" message:@"昵称长度不能大于10或者生日和昵称为空" target:self];
        self.userInfoView.completeBtn.enabled = YES;
        self.userInfoView.completeBtn.backgroundColor = MainColor;
        return;
    }
    //获得当前显示的时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"YYYY-MM-dd";
    NSDate *nowDate = [NSDate date];
    NSString *nowDateStr = [formatter stringFromDate:nowDate];
    if ([nowDateStr integerValue] - [self.userInfoView.birthdayTF.text integerValue] <= 16) {
        //温馨提示
        [UIAlertController showAlertWithTitle:@"温馨提示" message:@"未满16周岁,禁止逗留！" target:self];
        self.userInfoView.completeBtn.enabled = YES;
        self.userInfoView.completeBtn.backgroundColor = MainColor;
        return;
    }
    if (self.headImagePath.length == 0) {
        [UIAlertController showAlertWithTitle:@"温馨提示" message:@"头像不能为空" target:self];
        self.userInfoView.completeBtn.enabled = YES;
        self.userInfoView.completeBtn.backgroundColor = MainColor;
        return;
    }
    [self showProgressHUD:self.view hint:nil hide:nil];
    
    AVUser *user = [AVUser currentUser];
    weakSelf();
    BOOL isAutoLogin = [[EaseMob sharedInstance].chatManager isAutoLoginEnabled];
    if (!isAutoLogin) {
        [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:user[@"userInfoId"] password:@"huanxinUser" completion:^(NSDictionary *loginInfo, EMError *error) {
            if (!error) {
                [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
                [weakSelf upData];
            }else{
                [weakSelf removePorgressHud];
                weakSelf.userInfoView.completeBtn.enabled = YES;
                weakSelf.userInfoView.completeBtn.backgroundColor = MainColor;
                [UIAlertController showAlertWithTitle:@"温馨提示" message:@"请重新提交" target:weakSelf];
                
            }
            
        } onQueue:nil];
        
        
    }else{
        [weakSelf upData];
    
    }

    
    
}
/**< leancloud上传数据自定义方法*/
- (void)upData{
    weakSelf();
    [MUserRegister upUserRegisterInfoWithImagePath:_headImagePath NickName:self.userInfoView.nameTF.text Birthday:self.userInfoView.birthdayTF.text Gender:_gender Age:nil UpDataCompletion:^(BOOL success, NSError *error, UserInfo *userInfo) {
        if (success) {
            
            NSDictionary *dict =  @{@"nickName":self.userInfoView.nameTF.text,@"birthday":self.userInfoView.birthdayTF.text,@"gender":_gender};
            [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"currentUserInfo"];
            
            [[NSUserDefaults standardUserDefaults]setObject:_headImagePath forKey:@"sheadImageData"];
            SRootViewController *nextVC = [[SRootViewController alloc]init];
            [weakSelf presentViewController:nextVC animated:YES completion:nil];
        }else{
            [weakSelf removePorgressHud];
            weakSelf.userInfoView.completeBtn.enabled = YES;
            weakSelf.userInfoView.completeBtn.backgroundColor = MainColor;
            [UIAlertController showAlertWithTitle:@"温馨提示" message:@"请重新提交资料" target:weakSelf];
        }
    }];

}
/**< 照片选择方法*/
- (void)addHeadImage{
    UIAlertController *alertControler = [UIAlertController alertControllerWithTitle:@"选择方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //防止循环引用
    __weak typeof(self) weakSelf = self;
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [weakSelf selectAlbum];
    }];
    UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
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
    //NSData* imageData = UIImagePNGRepresentation(tempImage);
    NSData *imageData = UIImageJPEGRepresentation(tempImage, 0.5);
    NSString* documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* imagePath = [documentPath stringByAppendingPathComponent:imageName];
    
    //保存到 document
    [imageData writeToFile:imagePath atomically:NO];
    
    /**< 将照片的data数据赋值给属性，以便传值*/
    _headImagePath = imageData;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.userInfoView.nameTF resignFirstResponder];
    [self.userInfoView.birthdayTF resignFirstResponder];
    
}

#pragma mark - ******* Delegate *******
/**< 照片选择器代理方法*/

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    /**< info[@"UIImagePickerControllerEditedImage"] 选择的image*/
    [self.userInfoView.headImageBtn setImage:info[@"UIImagePickerControllerEditedImage"] forState:UIControlStateNormal];
    [self saveImage:info[@"UIImagePickerControllerEditedImage"] WithName:@"userImage"];
    //处理完毕，回到信息页面
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - ******* Getters *******

- (MUserInfoView *)userInfoView{
    
    if (!_userInfoView) {
        _userInfoView = ({
            MUserInfoView *view = [[MUserInfoView alloc]init];
            view.userInteractionEnabled = YES;
            weakSelf();
            view.genderInfoComplete = ^(NSString *gender){
                
                [weakSelf saveGender:gender];
                
            
            };
            view.userInfoComplete = ^{
                
                [weakSelf saveInfo];
            };
            view.addImageResponed = ^{
                [weakSelf addHeadImage];
            };
            view.protocolResponed = ^{
                
                [weakSelf clickedPrptocolBtn];
            
            };
            view.frame = self.view.bounds;
            view;
        });
    }
    return _userInfoView;
}


@end
