//
//  FirstFunctionViewController.m
//  unify_platform
//
//  Created by mac on 2018/7/7.
//  Copyright © 2018年 CMP_Ljh. All rights reserved.
//

#import "XlHomeViewController_Temp.h"

@interface XlHomeViewController_Temp ()<HomeDelegate>

@end

@implementation XlHomeViewController_Temp


- (MtHomeTopView *)topView{
    if (!_topView) {
        CGRect frame = CGRectMake(0, 0, ScreenWidth, kNavBarHeight_New);
        _topView = [[MtHomeTopView alloc] initWithFrame:frame];
        
        //test
        //        _topView.backgroundColor = [UIColor redColor];
    }
    return _topView;
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    if(_currentCell){
        [_currentCell.playerView playVideo];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    /*
     以下两行顺序不能乱，statusBarHidden = YES 的状态，会影响对刘海的判断，
     所以 self.tabBar.top = [self getTabbarTop]; 应该放在前
     */
    self.tabBar.top = [self getTabbarTop];
    [UIApplication sharedApplication].statusBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if(_currentCell){
        [_currentCell.playerView pausePlay];
    }
}

-(void)initNavTitle{
    self.isNavBackGroundHiden = YES;
    
    
}

-(void)dealloc{    
    /*dealloc*/
}

- (void)viewDidLoad {
//    self.isFirstLoad = YES;
    
    [super viewDidLoad];
    
    [self setupUI];
}

#pragma -mark ------ CustomMethod ----------

-(void)setupUI{
    
    [self.view addSubview:self.mainTableView];
     [self.view addSubview:self.topView];

    self.mainTableView.size = [UIView getSize_width:ScreenWidth height:ScreenHeight];
    self.mainTableView.origin = [UIView getPoint_x:0 y:0];
    
    self.mainTableView.pagingEnabled = YES;
    self.mainTableView.showsVerticalScrollIndicator = NO;
    self.mainTableView.showsHorizontalScrollIndicator = NO;
    /*
     iOS 11中如果不实现-tableView: viewForFooterInSection: 和 -tableView: viewForHeaderInSection:，那么-tableView: heightForHeaderInSection:和- tableView: heightForFooterInSection:不会被调用。
     
     这是因为estimatedRowHeight estimatedSectionHeaderHeight estimatedSectionFooterHeight三个高度估算属性由默认的0变成了UITableViewAutomaticDimension，导致高度计算不对，解决方法是实现对应方法或吧这三个属性设为0。
     */
    self.mainTableView.estimatedRowHeight = 0; //估算高度，如果我们要回到iOS11之前的效果，我们可以让estimatedRowHeight=0，关闭这个预估高度的效果。
    self.mainTableView.estimatedSectionFooterHeight = 0;
    self.mainTableView.estimatedSectionHeaderHeight = 0;
    
    self.mainTableView.backgroundColor = XLColorBackgroundColor; //XLColorBackgroundColor;
    self.mainTableView.mj_header.backgroundColor = XLColorBackgroundColor;
    self.mainTableView.mj_footer.backgroundColor = XLColorBackgroundColor;
    self.mainTableView.mj_header.mj_h = 50;
    self.mainTableView.mj_footer.mj_h = 50;
    self.mainTableView.mj_footer = nil;
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.mainTableView.mj_header beginRefreshing];
    
}


#pragma mark --------- 数据加载代理 ------------

-(void)loadNewData{
    _liveInfoIndex = 0; //默认第一条视频
    self.isFirstLoad = YES;
    self.currentPage = 0;
    [self.mainDataArr removeAllObjects];
    [self initRequest];
}

-(void)loadMoreData{
//    self.mainTableView.mj_header.hidden = YES;

    self.currentPage += 1;
//    self.mainTableView.mj_header.hidden = YES;
    [self initRequest];
//    if (self.totalCount == self.listDataArray.count) {
//        [self showFaliureHUD:@"暂无更多数据"];
//        [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
//        self.mainTableView.mj_footer.hidden = YES;
//    }
}

#pragma mark --------- 网络请求 ------------
-(void)initRequest {
    
    NetWork_mt_home_list *request = [[NetWork_mt_home_list alloc] init];
    request.pageNo = [NSString stringWithFormat:@"%ld",self.currentPage+1]; //[NSNumber numberWithInteger:self.currentPage+1];
    request.pageSize = @"20";
    request.currentNoodleId = [GlobalData sharedInstance].loginDataModel.noodleId;
    
    [request startGetWithBlock:^(HomeListResponse *result, NSString *msg) {
        /*
         缓存暂时先不用考虑
         */
    } finishBlock:^(HomeListResponse *result, NSString *msg, BOOL finished) {
        NSLog(@"----");
        
        if(finished){
            self.mainTableView.mj_footer.hidden = NO;
            [self.mainDataArr addObjectsFromArray:result.obj];
            [self.mainTableView reloadData];
            
            if(self.isFirstLoad){//第一次加载
                self.isFirstLoad = NO;
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_liveInfoIndex inSection:0];
                _currentCell = [self.mainTableView cellForRowAtIndexPath:indexPath];
                [_currentCell.playerView playVideo];
            }
        }
        else{
            [self showFaliureHUD:msg];
        }
        [self.mainTableView.mj_header endRefreshing];
        [self.mainTableView.mj_footer endRefreshing];

        if(_dragDirection == DragDirection_Down){//上拉加载完成后，mj_footer没有滚动一整屏幕，辅助滚动一整屏
            [self.mainTableView setContentOffset:CGPointMake(0, _liveInfoIndex*HomeVideoCellHeight)];
        }
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
    
    HomeListModel *model = [self.mainDataArr objectAtIndex:[indexPath row]];
    HomeVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:[HomeVideoCell cellId]];
    if(!cell){
        cell = [[HomeVideoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[HomeVideoCell cellId]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.homeDelegate = self;
    }
    [cell fillDataWithModel:model];
    
    return cell;
}

//设置每一组的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return HomeVideoCellHeight;
}

//设置组头部视图的高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001;
}
//设置组底部高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _beginDragging = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    CGPoint rect = scrollView.contentOffset;
    NSInteger index = rect.y / self.view.height;
    if (_beginDragging && _liveInfoIndex != index) {
        if (index > _liveInfoIndex) {
            _dragDirection = DragDirection_Down;
        }else{
            _dragDirection = DragDirection_Up;
        }
        _liveInfoIndex = index;
        
        [_currentCell.playerView pausePlay]; //暂停上一个视频
        
        _currentCell = [self.mainTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_liveInfoIndex inSection:0]];
        [_currentCell.playerView playVideo];
        
        _beginDragging = NO;
    }
    
    NSLog(@"-------------_liveInfoIndex = %ld",_liveInfoIndex);
    NSLog(@"-------------self.mainDataArr.count = %ld",self.mainDataArr.count);
    
    NSLog(@"----------");
    
    NSInteger offset = self.mainDataArr.count - _liveInfoIndex;
    if(offset == 2){ //开始加载下一页
        self.currentPage += 1;
        [self initRequest];
    }
}

#pragma mark --------------- HomeDelegate代理 -----------------

- (void)userInfoClicked:(HomeListModel *)listModel{
    
    NSLog(@"----------点击查看用户信息----------");
    
}


- (void)followClicked:(HomeListModel *)listModel{
    
    [[ZJLoginService sharedInstance] authenticateWithCompletion:^(BOOL success) {
        
        NSLog(@"-------");
        
        SaveflourContentModel *contentModel = [[SaveflourContentModel alloc] init];
        contentModel.flourId = [GlobalData sharedInstance].loginDataModel.noodleId;
        contentModel.noodleId = listModel.noodleId;
        contentModel.flourHead = [GlobalData sharedInstance].loginDataModel.head;
        contentModel.flourNickname = [GlobalData sharedInstance].loginDataModel.nickname;
        contentModel.flourSignature = [GlobalData sharedInstance].loginDataModel.signature;
        contentModel.noodleHead = listModel.head;
        contentModel.noodleNickname = listModel.nickname;
        contentModel.noodleSignature = listModel.signature;
        
        NetWork_mt_saveflour *request = [[NetWork_mt_saveflour alloc] init];
        request.currentNoodleId = [GlobalData sharedInstance].loginDataModel.noodleId;
        request.content = [contentModel generateJsonStringForProperties];
        [request startPostWithBlock:^(id result, NSString *msg, BOOL finished) {
            NSLog(@"----------");
        }];
        contentModel = nil;
        
    } cancelBlock:^{
        NSLog(@"--------取消登录---------");
    } isAnimat:YES];
    
    


}

- (void)zanClicked:(HomeListModel *)listModel{
    NSLog(@"-------");
    
    [[ZJLoginService sharedInstance] authenticateWithCompletion:^(BOOL success) {
        
        NetWork_mt_likeVideo *request = [[NetWork_mt_likeVideo alloc] init];
        request.currentNoodleId = [GlobalData sharedInstance].loginDataModel.noodleId;
        request.noodleVideoId = listModel.noodleVideoId;
        request.noodleVideoCover = listModel.noodleVideoCover;
        request.noodleId = listModel.noodleId;
        [request startPostWithBlock:^(id result, NSString *msg, BOOL finished) {
            NSLog(@"---------");
            if(finished){
                NSLog(@"-------");
                
                //发送点赞通知
                
                // _currentCell.playerView.maskView.btnZan.selected = YES;
                
            }
            else{
                [self showFaliureHUD:msg];
            }
        }];
        
    } cancelBlock:^{
        
    } isAnimat:YES];
    
    

    
    
}

- (void)commentClicked:(HomeListModel *)listModel{
    
    NSLog(@"----------点击查看评论----------");
}

- (void)shareClicked:(HomeListModel *)listModel{
    
        NSLog(@"----------分享----------");
    
}

- (void)musicCDClicked:(HomeListModel *)listModel{
    
    NSLog(@"----------CD----------");
    
}

@end
