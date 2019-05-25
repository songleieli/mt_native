//
//  FirstFunctionViewController.m
//  unify_platform
//
//  Created by mac on 2018/7/7.
//  Copyright © 2018年 CMP_Ljh. All rights reserved.
//

#import "BoiledRecordViewController.h"

@interface BoiledRecordViewController ()

@property (copy, nonatomic) NSString *myCallBack;

@end

@implementation BoiledRecordViewController

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
    
    self.title = @"煮面记录";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

#pragma mark - 数据加载代理
-(void)loadNewData{
    self.currentPageIndex = 0;
    [self initRequest];
}

-(void)loadMoreData{
    [self initRequest];
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
    [self.mainTableView registerClass:BoiledRecordCell.class forCellReuseIdentifier:[BoiledRecordCell cellId]];
    [self.mainTableView.mj_header beginRefreshing];
    
}

#pragma mark ------ initRequest  ------

-(void)initRequest{
    
    NetWork_mt_getBoiledRecords *request = [[NetWork_mt_getBoiledRecords alloc] init];
    request.currentNoodleId = [GlobalData sharedInstance].loginDataModel.noodleId;
    [request startGetWithBlock:^(id result, NSString *msg) {
        /*
         *暂不考虑缓存问题
         */
    } finishBlock:^(GetBoiledRecordsResponse *result, NSString *msg, BOOL finished) {
        
        [self.mainTableView.mj_header endRefreshing];
        [self.mainTableView.mj_footer endRefreshing];
        
        if(finished){
            [self loadData:result];
        }
        else{
            [UIWindow showTips:@"数据获取失败，请检查网络"];
            [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
    
}

-(void)loadData:(GetBoiledRecordsResponse *)result{

    [self.mainDataArr removeAllObjects];

    [self.mainDataArr addObjectsFromArray:result.obj];
    [self.mainTableView reloadData];
    
    if(self.mainDataArr.count < self.currentPageSize || result.obj.count == 0) {//最后一页数据
        [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
    }
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
        BoiledRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:[BoiledRecordCell cellId] forIndexPath:indexPath];
        BoiledRecordModel *model = [self.mainDataArr objectAtIndex:[indexPath row]];
//        cell.followsDelegate = self;
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
    
    return BoiledRecordCellHeight;
}


-(void)backBtnClick:(UIButton*)btn{
    [self.navigationController popViewControllerAnimated:YES];
}



@end
