//
//  FirstFunctionViewController.m
//  unify_platform
//
//  Created by mac on 2018/7/7.
//  Copyright © 2018年 CMP_Ljh. All rights reserved.
//

#import "MTMyFansViewController.h"

@interface MTMyFansViewController ()<GetFloursDelegate>

@property (copy, nonatomic) NSString *myCallBack;

@end

@implementation MTMyFansViewController

#pragma mark =========== 懒加载 ===========

#pragma mark --- header ---

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [UIApplication sharedApplication].statusBarHidden = NO;
}

-(void)initNavTitle{
    self.isNavBackGroundHiden = NO;
    self.lableNavTitle.textColor = [UIColor whiteColor];
    self.lableNavTitle.font = [UIFont defaultBoldFontWithSize:16];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.size = [UIView getSize_width:20 height:20];
    leftButton.origin = [UIView getPoint_x:15.0f y:self.navBackGround.height -leftButton.height-11];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"icon_titlebar_whiteback"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.btnLeft = leftButton;
    
    self.title = @"面粉";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

#pragma mark - 数据加载代理
-(void)loadNewData{
    self.mainTableView.mj_footer.hidden = YES;
    self.currentPageIndex = 0;
    [self initRequest];
}

-(void)loadMoreData{
    //    self.tableView.mj_header.hidden = YES;
    //    [self initRequest];
    //    if (self.totalCount == self.listDataArray.count) {
    //        [self showFaliureHUD:@"暂无更多数据"];
    //        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    //        self.tableView.mj_footer.hidden = YES;
    //    }
}

#pragma mark ------ CustomMethod  ------

-(void)setupUI{
    self.view.backgroundColor = ColorThemeBackground;
    [self.view addSubview:self.mainTableView];
    
    
    NSInteger tableViewHeight = ScreenHeight - kNavBarHeight_New;
    
    self.mainTableView.size = [UIView getSize_width:ScreenWidth height:tableViewHeight];
    self.mainTableView.origin = [UIView getPoint_x:0 y:kNavBarHeight_New];
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.backgroundColor = [UIColor clearColor]; //RGBFromColor(0xecedf1);
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.mainTableView registerClass:FlourCell.class forCellReuseIdentifier:[FlourCell cellId]];
    [self.mainTableView.mj_header beginRefreshing];
    
}

-(void)backBtnClick:(UIButton*)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ------ initRequest  ------

-(void)initRequest{
    
    NetWork_mt_getFlours *request = [[NetWork_mt_getFlours alloc] init];
    request.currentNoodleId = [GlobalData sharedInstance].loginDataModel.noodleId;
    request.noodleId =  self.userNoodleId; //[GlobalData sharedInstance].loginDataModel.noodleId;
    request.pageNo = [NSString stringWithFormat:@"%ld",self.currentPageIndex=self.currentPageIndex+1];
    request.pageSize = [NSString stringWithFormat:@"%ld",self.currentPageSize];
    [request startGetWithBlock:^(id result, NSString *msg) {
        /*
         *暂不考虑缓存问题
         */
    } finishBlock:^(GetFloursResponse *result, NSString *msg, BOOL finished) {
        
        [self.mainTableView.mj_header endRefreshing];
        if(finished){
            [self loadData:result];
        }
    }];
    
}

-(void)loadData:(GetFloursResponse *)result{
    if (self.currentPageIndex == 0 ) {
        [self.mainDataArr removeAllObjects];
        [self refreshNoDataViewWithListCount:result.obj.count];
    }
    [self.mainDataArr addObjectsFromArray:result.obj];
    [self.mainTableView reloadData];
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
        FlourCell *cell = [tableView dequeueReusableCellWithIdentifier:[FlourCell cellId] forIndexPath:indexPath];
        GetFloursModel *model = [self.mainDataArr objectAtIndex:[indexPath row]];
        cell.followsDelegate = self;
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
    
    return FlourCellHeight;
}

-(void)btnCellClick:(GetFloursModel*)model{
    
    UserInfoViewController *userInfoViewController = [[UserInfoViewController alloc] init];
    userInfoViewController.userNoodleId = model.flourId;
    userInfoViewController.fromType = FromTypeHome; //我的页面，需要显示返回按钮，隐藏TabBar
    [self pushNewVC:userInfoViewController animated:YES];

}


@end
