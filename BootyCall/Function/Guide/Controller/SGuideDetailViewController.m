//
//  SGuideDetailViewController.m
//  BootyCall
//
//  Created by mac on 16/8/12.
//  Copyright © 2016年 dazhongdiy. All rights reserved.
//

#import "SGuideDetailViewController.h"
#import "sGuideDetailTabViewCell.h"
#import "S3DscrollView.h"
#import <objc/runtime.h>


static NSString *stableViewCellId = @"SGuideDetailViewController";
@interface SGuideDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
/**列表*/
@property(nonatomic,strong)UITableView                      *stableView;
/**列表数据源*/
@property(nonatomic,strong)NSArray                          *sdataSource;
/**头部视图*/
@property(nonatomic,strong)S3DscrollView                     *sc;




-(void)initializeDataSource;/**< 初始化数据源 */
-(void)initializeUserInterface;/**< 初始化用户界面 */

@end

@implementation SGuideDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeDataSource];
    [self initializeUserInterface];
    
}

#pragma mark - ******* Initialize *******

-(void)initializeDataSource{
    switch (_index) {
        case 0:
            _sdataSource = @[@[_stitleStr,@"",@"无爱向左<-",@"往左边滑动表示对他（她）暂时不感兴趣，",@"左下方的按钮，功能一样"],@[@"",@"",@"心动向右->",@"向右边滑动，表示你对他（她）感兴趣，在这种情况下，如果对方也做了相应操作，那么相互之间可以获取到对方的信息，取得聊天资格。而且亲密度上升，照骗模糊效果变淡",@"右下方按钮，功能一样"],@[@"",@"",@"配对💗",@"双方聊天后亲密度会慢慢提升，当亲密度达到90%以上，表示配对成功，此时可以看到对方更多信息",@"配对后......"]];
            break;
        case 1:
            _sdataSource = @[@[_stitleStr,@"",@"1⃣️开启定位服务",@"在手机的设置->隐私->定位服务确保应用定位服务处于开启状态",@""],@[@"",@"",@"2⃣️设置期待对象",@"在设置应用的设置->心目中的他(她)中选择你期待的对象是什么样，给予一定的条件。否则无法更好的为你提供服务",@""],@[@"",@"",@"3⃣️在主页中寻找自己的缘分吧",@"尽量仔细看对方的信息，每个对象多停留一会儿，或许就有眼缘了哦。",@""]];
            break;
        case 2:
            _sdataSource = @[@[_stitleStr,@"",@"我是谁？",@"想要认识别人，先得认识自己，发现自己的兴趣爱好，看清自己的性格，正视自己的优缺点",@""],@[@"",@"",@"你在哪里？",@"新奇都在身边，相信你会在某个时间发现自己要找的人，多搜索，对认识",@""],@[@"",@"",@"我怎么才能认识你",@"尽量上传自己最近的看清脸部的真实照片，尽量详细的填写自己的所涉及的真实信息，把最真诚的一面展示给对方，增大其他对你的好感。",@""]];
            break;
        case 3:
            _sdataSource = @[@[_stitleStr,@"",@"在哪里修改？",@"在侧边栏的查看/编辑中可以进行某个信息的更新和修改",@""],@[@"",@"",@"哪些不能修改？",@"为了更好的为用户服务，个人信息性别不能修改，登录账号不能修改......",@""],@[@"",@"",@"多久修改一次？",@"在你换了新发型，或者买了新衣服，可以更新个人相册(小编个人经常就是这么干的, 哈哈.....)，或者职位上升之后，更新一下，让大家都知道你是一个上进的人哦",@""]];
            break;
        case 4:
            _sdataSource = @[@[_stitleStr,@"",@"头像很重要",@"头像是你给别人的第一个视觉印象，积极、乐观、随性更有亲近感哦。(小编建议卖萌，扮酷的头像更有青睐哦)",@""],@[@"",@"",@"真实信息",@"年龄，职业，行业，自我评价的内容才是最真实的自己哦。",@""],@[@"",@"",@"做个有魅力的人",@"有趣独特的昵称和个性签名，爱好广泛，话题广泛，不骄不躁的等待缘分才是上策。",@""]];
            break;
        case 5:
            _sdataSource = @[@[_stitleStr,@"",@"好的开场白",@"关于对方的照片和资料，提一个有意思的问题或从最近一件有趣的事开始。如果不知道说什么，试试发一个聊天表情过去",@""],@[@"",@"",@"好的话题",@"对方的资料中找到一些聊天的话题，比如，某一部电影，某个小吃，某一个街景。",@""],@[@"",@"",@"万能话题",@"如果实在不知道如何发起话题，发送一个“你好”或许也是可以的。",@""]];
            break;
        case 6:
            _sdataSource = @[@[_stitleStr,@"",@"功能切换按钮(assistive touch)",@"你可以点击应用主屏幕上的LOGO进行更多的功能切换哦，如果你发现它挡住视线了，也是可以拉开的。",@""],@[@"",@"",@"侧边栏",@"侧边栏主要是用户的设置，指导，个人修改等基本内容",@""],@[@"",@"",@"主功能",@"附近搜索，查看相互心仪的人，话题聊天，心情日记.....都可以通过功能切换按钮(assistive touch)进入慢慢体会",@""]];
            break;
        case 7:
            _sdataSource = @[@[_stitleStr,@"",@"功能切换按钮(assistive touch)",@"你可以点击应用主屏幕上的LOGO进行更多的功能切换哦，如果你发现它挡住视线了，也是可以拉开的。",@""],@[@"",@"",@"侧边栏",@"侧边栏主要是用户的设置，指导，个人修改等基本内容",@""],@[@"",@"",@"主功能",@"附近搜索，查看相互心仪的人，话题聊天，心情日记.....都可以通过功能切换按钮(assistive touch)进入慢慢体会",@""]];
            break;
        default:
            break;
    }
}

-(void)initializeUserInterface{
    self.navigationItem.title = @"新手指导";
    //加载子视图
    [self addSubViews];

}



#pragma mark - ******* Methods *******

-(void)addSubViews{
    self.stableView.estimatedRowHeight = 200;
    self.stableView.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview:self.stableView];
    UIView *scBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 60, SCREEN_HEIGHT * 0.5 + 20)];
    _sc = [[S3DscrollView alloc] initWithFrame:CGRectMake(30, 10, SCREEN_WIDTH - 60, SCREEN_HEIGHT * 0.5)];
    for (int i = 0; i < 9; i++) {
        
        UIView *view =[[UIView alloc] initWithFrame:CGRectMake(i *(SCREEN_WIDTH - 60), 0, SCREEN_WIDTH - 60, SCREEN_HEIGHT * 0.5)];
        view.backgroundColor = [UIColor colorWithRed:arc4random()%256/255. green:arc4random()%256/255. blue:arc4random()%256/255. alpha:1];
        [_sc addSubview:view];
        
    }
    _sc.contentSize = CGSizeMake((SCREEN_WIDTH - 60) * 9, 0);
    _sc.pagingEnabled = YES;
    /**
     *  添加 3d 效果
     */
    [_sc make3Dscrollview];
    [scBgView addSubview:_sc];
    
    if (_index == 0) {
        self.stableView.tableHeaderView = scBgView;
    }else{
        self.stableView.tableHeaderView = [UIView new];
    }
    
    

    
}


#pragma mark - ******* <#Events#> *******


#pragma mark - ******* UITableViewDelegate,UITableViewDataSource *******

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _sdataSource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    sGuideDetailTabViewCell *cell = [tableView dequeueReusableCellWithIdentifier:stableViewCellId forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.models = _sdataSource[indexPath.section];
    return cell;
}


#pragma mark - ******* Getters *******

-(UITableView *)stableView{
    if (!_stableView) {
        _stableView = ({
            UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
            tableView.backgroundColor = [UIColor clearColor];
            tableView.delegate = self;
            tableView.dataSource = self;
            tableView.separatorColor = [UIColor clearColor];
            [tableView registerClass:[sGuideDetailTabViewCell class] forCellReuseIdentifier:stableViewCellId];
            tableView;
        });
    }
    return _stableView;
}




@end
