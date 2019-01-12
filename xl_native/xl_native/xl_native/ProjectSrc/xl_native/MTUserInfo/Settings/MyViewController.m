//
//  ZJMessageViewController.m
//  CMPLjhMobile
//
//  Created by lei song on 2016/11/8.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "MyViewController.h"
#import "UserInfoHeader.h"

@implementation MyViewTableViewSelectionModel


@end


@interface MyViewController ()

@property (strong, nonatomic) UserInfoHeader *userInfoHeader;

@end

@implementation MyViewController

- (NSMutableArray *)dataList{
    
    if (!_dataList) {
        
        _dataList = [[NSMutableArray alloc] init];
        
        int selectionCount = 5;
        for (int i =0 ; i<selectionCount; i ++) {
            MyViewTableViewSelectionModel *model = [[MyViewTableViewSelectionModel alloc] init];
            switch (i) {
                case 0:{
                    model.selectTitle = @"账号";
                    NSMutableArray *cellList = [[NSMutableArray alloc] init];
                    for (int j =0 ; j<3; j ++) {
                        MyViewTableViewCellModel *model = [[MyViewTableViewCellModel alloc] init];
                        switch (j) {
                            case 0:
                                model.titleStr = @"编辑个人资料";
                                model.imageStr = @"icon_m_s_lock";
                                break;
                            case 1:
                                model.titleStr = @"账号与安全";
                                model.imageStr = @"icon_m_s_order";
                                break;
                            default:
                                model.titleStr = @"隐私设置";
                                model.imageStr = @"icon_m_s_lock";
                                model.isShowLine = YES;
                                break;
                        }
                        [cellList addObject:model];
                    }
                    model.cellList = cellList;
                }
                    break;
                case 1:{
                    model.selectTitle = @"通用";
                    NSMutableArray *cellList = [[NSMutableArray alloc] init];
                    for (int j =0 ; j<2; j ++) {
                        MyViewTableViewCellModel *model = [[MyViewTableViewCellModel alloc] init];
                        switch (j) {
                            case 0:
                                model.titleStr = @"通知设置";
                                model.imageStr = @"icon_m_s_lock";
                                break;
                            case 1:
                                model.titleStr = @"通用设置";
                                model.imageStr = @"icon_m_s_lock";
                                model.isShowLine = YES;
                                break;
                            default:
                                break;
                        }
                        [cellList addObject:model];
                    }
                    model.cellList = cellList;
                }
                    break;
                case 2:{
                    model.selectTitle = @"钱包";
                    NSMutableArray *cellList = [[NSMutableArray alloc] init];
                    for (int j =0 ; j<4; j ++) {
                        MyViewTableViewCellModel *model = [[MyViewTableViewCellModel alloc] init];
                        switch (j) {
                            case 0:
                                model.titleStr = @"免流量看面条";
                                model.imageStr = @"icon_m_s_order";
                                break;
                            case 1:
                                model.titleStr = @"面条订单管理";
                                model.imageStr = @"icon_m_s_order";
                                break;
                            case 2:
                                model.titleStr = @"购物助手";
                                model.imageStr = @"icon_m_s_order";
                                break;
                            default:
                                model.titleStr = @"商品分享功能";
                                model.imageStr = @"icon_m_s_order";
                                model.isShowLine = YES;
                                break;
                        }
                        [cellList addObject:model];
                    }
                    model.cellList = cellList;
                }
                    break;
                case 3:{
                    model.selectTitle = @"未成年保护";
                    NSMutableArray *cellList = [[NSMutableArray alloc] init];
                    for (int j =0 ; j<2; j ++) {
                        MyViewTableViewCellModel *model = [[MyViewTableViewCellModel alloc] init];
                        switch (j) {
                            case 0:
                                model.titleStr = @"时间锁";
                                model.imageStr = @"icon_m_s_model";
                                break;
                            case 1:
                                model.titleStr = @"青少年模式";
                                model.imageStr = @"icon_m_s_model";
                                model.isShowLine = YES;
                                break;
                            default:
                                break;
                        }
                        [cellList addObject:model];
                    }
                    model.cellList = cellList;
                }
                    break;
                case 4:{
                    model.selectTitle = @"关于";
                    NSMutableArray *cellList = [[NSMutableArray alloc] init];
                    for (int j =0 ; j<8; j ++) {
                        MyViewTableViewCellModel *model = [[MyViewTableViewCellModel alloc] init];
                        switch (j) {
                            case 0:
                                model.titleStr = @"反馈与帮助";
                                model.imageStr = @"icon_m_s_order";
                                break;
                            case 1:
                                model.titleStr = @"社区自律公约";
                                model.imageStr = @"icon_m_s_order";
                                break;
                            case 2:
                                model.titleStr = @"用户协议";
                                model.imageStr = @"icon_m_s_order";
                                break;
                            case 3:
                                model.titleStr = @"隐私政策";
                                model.imageStr = @"icon_m_s_order";
                                break;
                            case 4:
                                model.titleStr = @"关于面条";
                                model.imageStr = @"icon_m_s_order";
                                break;
                            case 5:
                                model.titleStr = @"网络监测";
                                model.imageStr = @"icon_m_s_order";
                                break;
                            case 6:
                                model.titleStr = @"清理缓存";
                                model.imageStr = @"icon_m_s_order";
                                model.isShowLine = YES;
                                break;
                            case 7:
                                model.titleStr = @"退出登录";
                                model.imageStr = @"icon_m_s_order";
                                break;
                            default:
                                break;
                        }
                        [cellList addObject:model];
                    }
                    model.cellList = cellList;
                }
                    break;
                default:
                    break;
            }
            [_dataList addObject:model];
        }
    }
    return _dataList;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
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
    
    
    self.title = @"设置";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
}


#pragma -mark ------- CustomMethod -------------

-(void)setUpUI{
    
    self.view.backgroundColor = ColorThemeBackground;
    self.isGroup = YES;
    [self.view addSubview:self.mainTableView];
    
    
    NSInteger tableViewHeight = ScreenHeight - kNavBarHeight_New;
    self.mainTableView.size = [UIView getSize_width:ScreenWidth height:tableViewHeight];
    self.mainTableView.origin = [UIView getPoint_x:0 y:kNavBarHeight_New];
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.backgroundColor = ColorThemeBackground;
    
    //    self.tableView.mj_header.mj_h = 30;
    self.mainTableView.mj_header.backgroundColor = ColorThemeBackground;
    self.mainTableView.mj_footer.hidden = YES;
    //    self.mainTableView.tableHeaderView = [self getHeadView];
    self.mainTableView.tableFooterView = [self getFooterView];
}


-(UIView*)getFooterView{
    UIView *viewFooter = [[UIView alloc] init];
    viewFooter.size = [UIView getSize_width:ScreenWidth height:70];
    viewFooter.backgroundColor = ColorThemeBackground;
    
    
    UILabel *lableSelection = [[UILabel alloc] init];
    lableSelection.size = [UIView getSize_width:ScreenWidth height:40];
    lableSelection.origin = [UIView getPoint_x:(viewFooter.width - lableSelection.width)/2
                                             y:(viewFooter.height - lableSelection.height)/2];
    lableSelection.font = [UIFont defaultFontWithSize:13];
    lableSelection.textAlignment = NSTextAlignmentCenter;
    lableSelection.textColor = RGBA(132, 135, 144, 1);
    [viewFooter addSubview:lableSelection];
    
    lableSelection.text = @"面条 version 1.0";
    
    return viewFooter;
}

-(void)backBtnClick:(UIButton*)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 数据加载代理
-(void)loadNewData{
    [self.mainTableView.mj_header endRefreshing];
}


#pragma mark - 设置tabbleView的代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataList.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    MyViewTableViewSelectionModel *selectionModel = [self.dataList objectAtIndex:section];

    UIView* view = [[UIView alloc] init];
    UILabel *lableSelection = [[UILabel alloc] init];
    lableSelection.size = [UIView getSize_width:ScreenWidth height:40];
    lableSelection.origin = [UIView getPoint_x:15 y:0];
    lableSelection.font = [UIFont defaultBoldFontWithSize:13];
    lableSelection.textColor = RGBA(132, 135, 144, 1);
    [view addSubview:lableSelection];
    
    lableSelection.text = selectionModel.selectTitle;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40 ;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView* view = [[UIView alloc] init];
//    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
   MyViewTableViewSelectionModel *selectionModel = [self.dataList objectAtIndex:section];
    return selectionModel.cellList.count;
}

//设置cell的样式
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MyViewTableViewSelectionModel *selectionModel = [self.dataList objectAtIndex:indexPath.section];
    MyViewTableViewCellModel* cellModel = [selectionModel.cellList objectAtIndex:indexPath.row];
    MyViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[MyViewTableViewCell cellId]];
    if(!cell){
        cell = [[MyViewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[MyViewTableViewCell cellId] ];
    }
    [cell dataBind:cellModel];
    return cell;
}
//设置每一组的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return MyViewTableViewCellHeight;
}


//点击cell的触发事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self cellClick:indexPath];
}

#pragma - mark cell 点击事件

-(void)cellClick:(NSIndexPath *)indexPath{
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    if(indexPath.section ==0){
        if(indexPath.row == 0){//我的积分
            //            MyIntegralViewController *myIntegralViewController = [[MyIntegralViewController alloc] init];
            //            [self pushNewVC:myIntegralViewController animated:YES];
        }
        else if(indexPath.row == 1){//我的卡券
            //            XLMyWelfareTicketVC *vc = [[XLMyWelfareTicketVC alloc] init];
            //            [self pushNewVC:vc animated:YES];
        }
        else if(indexPath.row == 2){//我的信用
            //            MyCreditViewController *myCreditViewController = [[MyCreditViewController alloc] init];
            //            [self pushNewVC:myCreditViewController animated:YES];
        }
        else if(indexPath.row == 3){//我的订单
            
            //            NSString *url = [NSString stringWithFormat:@"%@/H5/manageOrder.html",[WCBaseContext sharedInstance].h5Server];
            //            XLProjectWkWebViewController *webViewController = [[XLProjectWkWebViewController alloc] init];
            //            webViewController.topNav.hidden = NO;
            //            webViewController.webDefault.size = [UIView getSize_width:ScreenWidth height:ScreenHeight];
            //            webViewController.webDefault.origin = [UIView getPoint_x:0 y:KStatusBarHeight_New];
            //            [webViewController reloadWebWithUrl:url msg:@""];
            //            [self pushNewVC:webViewController animated:YES];
        }
        else if(indexPath.row == 4){//我的实名认证
            //            ReadNameAuthViewController *readNameAuthViewController = [[ReadNameAuthViewController alloc] init];
            //            [self pushNewVC:readNameAuthViewController animated:YES];
        }
    }
    else if(indexPath.section ==1){
        if(indexPath.row == 0){//个人设置
            SettingViewController *settingViewController = [[SettingViewController alloc] init];
            [self pushNewVC:settingViewController animated:YES];
        }
    }
}

@end
