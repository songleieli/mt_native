//
//  FirstFunctionViewController.m
//  unify_platform
//
//  Created by mac on 2018/7/7.
//  Copyright © 2018年 CMP_Ljh. All rights reserved.
//

#import "MTFollowViewController.h"

@interface MTFollowViewController ()<GetFollowsDelegate>

@property (copy, nonatomic) NSString *myCallBack;

@end

@implementation MTFollowViewController

#pragma mark =========== 懒加载 ===========

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [UIApplication sharedApplication].statusBarHidden = NO;
    self.tabBar.top = [self getTabbarTop];    //  重新设置tabbar的高度
    
    [self.mainDataArr removeAllObjects]; //加载页面内容时，先清除老数据
    [self initRequest];
}

-(void)initNavTitle{
    self.isNavBackGroundHiden = NO;
    
    self.navBackGround.height = KStatusBarHeight_New; //状态栏的高度
    
//    self.lableNavTitle.textColor = [UIColor whiteColor];
//    self.lableNavTitle.font = [UIFont defaultBoldFontWithSize:16];
//
//    self.title = @"关注";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

#pragma mark ------ CustomMethod  ------

-(void)setupUI{
    self.view.backgroundColor = ColorThemeBackground;
    [self.view addSubview:self.mainTableView];
    
    NSInteger tableViewHeight = ScreenHeight -kTabBarHeight_New - KStatusBarHeight_New;
    
    self.mainTableView.size = [UIView getSize_width:ScreenWidth height:tableViewHeight];
    self.mainTableView.origin = [UIView getPoint_x:0 y:KStatusBarHeight_New];
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.backgroundColor = [UIColor clearColor]; //RGBFromColor(0xecedf1);
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTableView.mj_header = nil;
    self.mainTableView.mj_footer = nil;
    [self.mainTableView registerClass:FollowsVideoListCell.class forCellReuseIdentifier:[FollowsVideoListCell cellId]];
}

#pragma mark ------ initRequest  ------

-(void)initRequest{
    
    NetWork_mt_getFollowsVideoList *request = [[NetWork_mt_getFollowsVideoList alloc] init];
    request.currentNoodleId = [GlobalData sharedInstance].loginDataModel.noodleId;
    request.pageNo = @"1";
    request.pageSize = @"20";
    [request startGetWithBlock:^(id result, NSString *msg) {
        /*
         *暂不考虑缓存问题
         */
    } finishBlock:^(GetFollowsVideoListResponse *result, NSString *msg, BOOL finished) {
        NSLog(@"----------------");
        
        [self.mainDataArr addObjectsFromArray:result.obj];
        [self.mainTableView reloadData];
    }];
    
}

#pragma mark --------------- tabbleView代理 -----------------
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.mainDataArr.count;
}
//设置cell的样式
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(self.mainDataArr.count > 0){
        FollowsVideoListCell *cell = [tableView dequeueReusableCellWithIdentifier:[FollowsVideoListCell cellId] forIndexPath:indexPath];
        HomeListModel *model = [self.mainDataArr objectAtIndex:[indexPath row]];
//        cell.getFollowsDelegate = self;
        [cell fillDataWithModel:model];
        return cell;
    }
    else{
        /*
         有时会出现，self.mainDataArr count为0 cellForRowAtIndexPath，却响应的bug。
         */
        UITableViewCell * celltemp =  [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellid"];
        return celltemp;
    }
}

//设置每一组的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return FollowsVideoListCellHeight;
}

-(void)btnDeleteClick:(GetFollowsModel*)model{
    
    UserInfoViewController *userInfoViewController = [[UserInfoViewController alloc] init];
    userInfoViewController.userNoodleId = model.noodleId;
    userInfoViewController.fromType = FromTypeHome; //我的页面，需要显示返回按钮，隐藏TabBar
    [self pushNewVC:userInfoViewController animated:YES];
    
}


@end
