//
//  SSelfInfoViewConroller.m
//  BootyCall
//
//  Created by mac on 16/8/13.
//  Copyright © 2016年 dazhongdiy. All rights reserved.
//
#import "SSelfInfoViewConroller.h"
#import "SSelfInfoTabViewCell.h"
#import "MForgetPasswordViewController.h"
#import "MJRefresh.h"

static NSString *stableViewCellId = @"SSelfInfoViewConroller-1";

@interface SSelfInfoViewConroller ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

/**列表*/
@property(nonatomic,strong)UITableView                      *stableView;
/**列表数据源*/
@property(nonatomic,strong)NSArray                          *sdataSource;
/**右边处信息是可以修改的，这里用stempTextF来获取到点击行所对应textF*/
@property(nonatomic,strong)UITextField                      *stempTextF;
/**用来记录点击到的是哪一行cell*/
@property(nonatomic,assign)NSInteger                        sindex;
/**是否为第一次点击cell*/
@property(nonatomic,assign)BOOL                             isFirst;
/**提示消息*/
@property(nonatomic,strong)NSString                         *smessage;
/**生日时间选择*/
@property(nonatomic,strong)UIDatePicker                     *sdataPicker;
@property(nonatomic,strong)UIToolbar                        *stoolBar;
/**时间选择器选中后的生日*/
@property(nonatomic,strong)NSString                         *birthdayStr;


/**昵称*/
@property(nonatomic,strong)NSString                         *snickName;
/**生日*/
@property(nonatomic,strong)NSString                         *sbirthday;
/**性别*/
@property(nonatomic,assign)int                              sgender;
@property(nonatomic,strong)NSString                         *gender;

-(void)initializeDataSource;/**< 初始化数据源 */
-(void)initializeUserInterface;/**< 初始化用户界面 */

@end

@implementation SSelfInfoViewConroller


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeDataSource];
    [self initializeUserInterface];
    
    
    
}

#pragma mark - ******* Initialize *******

-(void)initializeDataSource{
    //[self loadDataSource];
    _sindex = 0;
    _smessage = @"";
    
    NSDictionary *myInfo =[[NSUserDefaults standardUserDefaults]objectForKey:@"currentUserInfo"];
    
    if (myInfo) {
        if ([(NSString*)myInfo[@"gender"] isEqualToString:@"1"]) {
            _gender = @"女";
        }else{
            _gender = @"男";
        }
        _snickName = myInfo[@"nickName"];
        _sbirthday = myInfo[@"birthday"];
    }
    //异常处理
    else{
        _gender = _snickName = _sbirthday = @"保密";
    }
    
    _sdataSource = @[@[@"性别",_gender],@[@"昵称",_snickName],@[@"出身日期",_sbirthday],@[@"修改密码",@""]];
}

-(void)initializeUserInterface{
    [self.navigationItem setTitle:@"修改个人信息"];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:nil];
    //加载子视图
    [self addSubViews];
    
}


#pragma mark - ******* Methods *******

-(void)loadDataSource{
    [MResponseUserInfo responseCurrentUserInfo:^(BOOL success, NSError *error, NSDictionary *currentUserInfo) {
        weakSelf();
        if(success){
            NSDictionary *myInfo = currentUserInfo[@"myInfo"];
            if ([(NSString*)myInfo[@"gender"] isEqualToString:@"1"]) {
                _gender = @"女";
            }else{
                _gender = @"男";
            }
            _snickName = myInfo[@"nickName"];
            _sbirthday = myInfo[@"birthday"];
            _sdataSource = @[@[@"性别",_gender],@[@"昵称",_snickName],@[@"出身日期",_sbirthday],@[@"修改密码",@""]];
            [weakSelf.stableView reloadData];
        }else{
            [weakSelf showsHint:@"网络获取数据失败"];
        }
        [weakSelf.stableView.mj_header endRefreshing];
    }];
}

-(void)addSubViews{
    //加载stableView
    [self.view addSubview:self.stableView];
    
    UIBarButtonItem *rightButtonItem = ({
        rightButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(respondsNavRightButtonItem:)];
        rightButtonItem.imageInsets = UIEdgeInsetsMake(12, 0, 12, 24);
        rightButtonItem;
    });
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}


#pragma mark - ******* Events *******

-(void)makeRefresh{
    [self loadDataSource];
}
/**
 *  自定义键盘的确定按钮
 *
 *  @param sender
 */
-(void)respondsToSureItem:(UIBarButtonItem*)sender{
    [self.view endEditing:YES];
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"YYYY-MM-dd";
    NSString *nowDateStr = [formatter stringFromDate:nowDate];
    if ([nowDateStr integerValue] - [_birthdayStr integerValue] <= 16) {
        //温馨提示
        _smessage = @"未满16周岁者,禁止玩耍！";
        [UIAlertController showAlertWithTitle:@"温馨提示" message:_smessage target:self];
    }else{
        self.stempTextF.text = _birthdayStr;
        _sbirthday = _birthdayStr;
    }

}
/**
 *  时间选择器的监听事件
 */
-(void)respondsToDataPicker{
    //获得当前显示的时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"YYYY-MM-dd";
    _birthdayStr = [formatter stringFromDate:self.sdataPicker.date];
}

-(void)respondsNavRightButtonItem:(UIBarButtonItem *)sender{
    [_stempTextF resignFirstResponder];
    [self showProgressHUD:self.view hint:@"正在保存" hide:@"保存成功"];
    if([_gender isEqualToString:@"男"]){
        _sgender = 0;
    }else{
        _sgender = 1;
    }
    //上传数据
    [MUserRegister upUserInfoWithGenter:[NSString stringWithFormat:@"%d",_sgender] NickName:_snickName Birthday:_sbirthday UpDataCompletion:^(BOOL success, NSError *error, UserInfo *userInfo) {
        if (success) {
            NSDictionary *myInfo = @{@"nickName":_snickName,@"birthday":_sbirthday,@"gender":[NSString stringWithFormat:@"%d",_sgender]};
            //发送给侧边栏，设置页立马修改昵称
            [[NSNotificationCenter defaultCenter]postNotificationName:@"changNickName" object:_snickName];
            //修改成功后覆盖登录或注册时的信息
            [[NSUserDefaults standardUserDefaults]setObject:myInfo forKey:@"currentUserInfo"];
            [self removePorgressHud];
        }else{
            [self removePorgressHud];
            [self showsHint:@"保存失败"];
        }
    }];
    
}

/**
 *  响应对应的行和列
 *
 *  @param sindexPath 下标
 */
-(void)respondingToTheCorrespondingRowsAndSecitons:(NSIndexPath *)sIndexPath cell:(SSelfInfoTabViewCell*)cell textF:(UITextField *)textField{
    //修改密码
    if (sIndexPath.row == _sdataSource.count - 1) {
        _stempTextF.userInteractionEnabled = NO;
        [self presentViewController:[MForgetPasswordViewController new] animated:YES completion:nil];
    }else{
        textField.userInteractionEnabled = YES;
    }
    if (sIndexPath.row == 2) {
        textField.inputView = self.sdataPicker;
        textField.inputAccessoryView = self.stoolBar;
    }
    
}



#pragma mark - ******* UITableViewDelegate,UITextFieldDelegate *******


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _sdataSource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SSelfInfoTabViewCell *cell = [tableView dequeueReusableCellWithIdentifier:stableViewCellId forIndexPath:indexPath];
    cell.models = _sdataSource[indexPath.row];
    
    if (indexPath.row == _sdataSource.count - 1) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SSelfInfoTabViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    _stempTextF = cell.sinfoTextF;
    //响应对应的行和列
    [self respondingToTheCorrespondingRowsAndSecitons:indexPath cell:cell textF:_stempTextF];
    _stempTextF.delegate = self;
    [_stempTextF becomeFirstResponder];
    _sindex = indexPath.row;
    
    if (indexPath.row == 0) {
        if (!([_stempTextF.text isEqualToString:@"男"] || [_stempTextF.text isEqualToString:@"女"])) {
            //温馨提示
            _smessage = @"你输入的性别不正确";
            [UIAlertController showAlertWithTitle:@"温馨提示" message:_smessage target:self];
        }else{
            //上传数据
            _gender = _stempTextF.text;
        }
    }else if(indexPath.row == 1){
        if (_stempTextF.text.length > 10) {
            //温馨提示
            _smessage = @"你输入的10位以内的字符";
            [UIAlertController showAlertWithTitle:@"温馨提示" message:_smessage target:self];
        }else{
            //上传数据
            _snickName = _stempTextF.text;
        }
    }
    cell.selected = NO;
    
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    SSelfInfoTabViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    _stempTextF = cell.sinfoTextF;
    [_stempTextF resignFirstResponder];
    _stempTextF.userInteractionEnabled = NO;
    if (indexPath.row == 0) {
        if (!([_stempTextF.text isEqualToString:@"男"] || [_stempTextF.text isEqualToString:@"女"])) {
            //温馨提示
            _smessage = @"你输入的性别不正确";
            [UIAlertController showAlertWithTitle:@"温馨提示" message:_smessage target:self];
        }else{
            //上传数据
            _gender = _stempTextF.text;
        }
    }else if(indexPath.row == 1){
        if (_stempTextF.text.length > 10) {
            //温馨提示
            _smessage = @"你输入的10位以内的字符";
            [UIAlertController showAlertWithTitle:@"温馨提示" message:_smessage target:self];
        }else{
            //上传数据
            _snickName = _stempTextF.text;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

//构建HeaderInSection视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"Header"];
    if (!view) {
        view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        view.backgroundColor = RGB_COLOR(235, 240, 242, 1.0);
    }
    UILabel *sclassL = [[UILabel alloc]initWithFrame:CGRectMake(20, 15, SCREEN_WIDTH - 20, 30)];
    sclassL.backgroundColor = [UIColor clearColor];
    sclassL.textColor = [UIColor grayColor];
    sclassL.font = [UIFont systemFontOfSize:13.f];
    sclassL.text = @"个人信息详情:";
    [view addSubview:sclassL];
    return view;
}

#pragma mark - ******* UITextFieldDelegate *******

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == _stempTextF) {
        //作一些判断
        if (_sindex == 0) {
            if (!([textField.text isEqualToString:@"男"] || [textField.text isEqualToString:@"女"])) {
                //温馨提示
                _smessage = @"你输入的性别不正确";
                [UIAlertController showAlertWithTitle:@"温馨提示" message:_smessage target:self];
            }else{
                //上传数据
                _gender = _stempTextF.text;
            }
        }
        if (_sindex == 1) {
            if (textField.text.length > 10 ||(textField.text.length == 0)) {
                //温馨提示
                _smessage = @"你输入的1-10位以内的字符";
                [UIAlertController showAlertWithTitle:@"温馨提示" message:_smessage target:self];
            }else{
                //上传数据
                _snickName = _stempTextF.text;
            }
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == _stempTextF) {
        [textField resignFirstResponder];
        //作一些判断
        if (_sindex == 0) {
            if (!([textField.text isEqualToString:@"男"] || [textField.text isEqualToString:@"女"])) {
                //温馨提示
                _smessage = @"你输入的性别不正确";
                [UIAlertController showAlertWithTitle:@"温馨提示" message:_smessage target:self];
            }else{
                //上传数据
                _gender = _stempTextF.text;
            }
        }
        if (_sindex == 1) {
            if (textField.text.length > 10 ||(textField.text.length == 0)) {
                //温馨提示
                _smessage = @"你输入的1-10位以内的字符";
                [UIAlertController showAlertWithTitle:@"温馨提示" message:_smessage target:self];
            }else{
                //上传数据
                _snickName = _stempTextF.text;
            }
        }
        return YES;
    }else{
        return NO;
    }
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == _stempTextF) {
        if (!_isFirst) {
            //温馨提示
            _smessage = @"是否确认要修改信息？";
            [UIAlertController showAlertWithTitle:@"温馨提示" message:_smessage target:self];
            _isFirst = YES;
        }
        return YES;
    }else{
        return NO;
    }
}


#pragma mark - ******* Getters *******

-(UITableView *)stableView{
    if (!_stableView) {
        _stableView = ({
            UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
            tableView.backgroundColor = [UIColor clearColor];
            tableView.delegate = self;
            tableView.dataSource = self;
            tableView.separatorColor = [UIColor grayColor];
            //MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(makeRefresh)];
            //header.automaticallyChangeAlpha = YES;
            //[header beginRefreshing];
            //tableView.mj_header = header;
            tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 15);
            [tableView registerClass:[SSelfInfoTabViewCell class] forCellReuseIdentifier:stableViewCellId];
            
            UIView *footerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 500)];
            footerview.backgroundColor = RGB_COLOR(235, 240, 242, 1.0);
            tableView.tableFooterView = footerview;
            //分割线
            UIView *dividerView = [[UIView alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, 0.5)];
            dividerView.backgroundColor = [UIColor grayColor];
            [footerview addSubview:dividerView];
            tableView;
        });
    }
    return _stableView;
}

-(UIDatePicker *)sdataPicker{
    if (!_sdataPicker) {
        _sdataPicker = [[UIDatePicker alloc]init];
        _sdataPicker.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
        _sdataPicker.datePickerMode = UIDatePickerModeDate;
        NSTimeInterval maginTime = 50 * 365 * 24 * 60 * 60;
        _sdataPicker.maximumDate = [NSDate date];
        _sdataPicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:-maginTime];
        _sdataPicker.minuteInterval = 1.f;
        //添加监听方法
        [_sdataPicker addTarget:self action:@selector(respondsToDataPicker) forControlEvents:UIControlEventValueChanged];
    }
    return _sdataPicker;
}

-(UIToolbar*)stoolBar{
    if (!_stoolBar) {
        _stoolBar = [[UIToolbar alloc]init];
        _stoolBar.bounds = CGRectMake(0, 0, 0, 40);
        UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        sureButton.frame = CGRectMake(SCREEN_WIDTH - 72, 4, 60, 28);
        [sureButton setTitle:@"确 定" forState:UIControlStateNormal];
        sureButton.layer.borderWidth = 1.f;
        sureButton.layer.borderColor = MainColor.CGColor;
        sureButton.layer.cornerRadius = 3.f;
        sureButton.layer.masksToBounds = YES;
        [sureButton setTitleColor:MainColor forState:UIControlStateNormal];
        [sureButton addTarget:self action:@selector(respondsToSureItem:) forControlEvents:UIControlEventTouchUpInside];
        // 确定按钮
        UIBarButtonItem *suerItem = [[UIBarButtonItem alloc] initWithCustomView:sureButton];
        // 弹簧按钮
        UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        // 添加到工具条上
        _stoolBar.items = @[flexibleItem,suerItem];
    }
    return _stoolBar;
}

@end
