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
    
//    [self.tableView.layer removeAllAnimations];
//    NSArray<AwemeListCell *> *cells = [_tableView visibleCells];
//    for(AwemeListCell *cell in cells) {
//        [cell.playerView cancelLoading];
//    }
//    [[AVPlayerManager shareManager] removeAllPlayers];

//    //移除 currentIndex 值变化的监听
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    [self removeObserver:self forKeyPath:@"currentIndex"];
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
//    self.isFirstLoad = YES;
    
    [super viewDidLoad];
    
    [self setupUI];
}

#pragma -mark ------ CustomMethod ----------

-(void)setupUI{
    
//    [self setBackgroundImage:@"img_video_loading"];
    
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
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
////        [self.view addSubview:self.tableView];
////        self.data = self.awemes;
////        [self.tableView reloadData];
//
////        NSIndexPath *curIndexPath = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
////        [self.tableView scrollToRowAtIndexPath:curIndexPath atScrollPosition:UITableViewScrollPositionMiddle
////                                      animated:NO];
//        [self addObserver:self forKeyPath:@"currentIndex" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew context:nil];
//    });
    
    [self.mainTableView.mj_header beginRefreshing];
    
    
    //添加 currentIndex 的监听
//    [self addObserver:self forKeyPath:@"currentIndex" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew context:nil];
}

- (void) setBackgroundImage:(NSString *)imageName {
    UIImageView *background = [[UIImageView alloc] initWithFrame:self.view.bounds];
    background.clipsToBounds = YES;
    background.contentMode = UIViewContentModeScaleAspectFill;
    background.image = [UIImage imageNamed:imageName];
    [self.view addSubview:background];
}

#pragma mark --------- 数据加载代理 ------------

-(void)loadNewData{
    _currentIndex = 0; //默认第一条视频
    self.isFirstLoad = YES;
    self.currentPage = 0;
    [self.mainDataArr removeAllObjects];
    [self initRequest];
}

-(void)loadMoreData{
    self.currentPage += 1;
    [self initRequest];
}

#pragma mark --------- 网络请求 ------------
-(void)initRequest {
    
    NetWork_mt_home_list *request = [[NetWork_mt_home_list alloc] init];
    request.pageNo = [NSString stringWithFormat:@"%ld",self.currentPage+1];
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
                
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_currentIndex inSection:0];
                _currentCell = [self.mainTableView cellForRowAtIndexPath:indexPath];
                //                [_currentCell.playerView playVideo];

                [self playCurCellVideo];
               
                
            }
        }
        else{
            [self showFaliureHUD:msg];
        }
        [self.mainTableView.mj_header endRefreshing];
        [self.mainTableView.mj_footer endRefreshing];

        if(_dragDirection == DragDirection_Down){//上拉加载完成后，mj_footer没有滚动一整屏幕，辅助滚动一整屏
            [self.mainTableView setContentOffset:CGPointMake(0, _currentIndex*HomeVideoCellHeight)];
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
    [cell startDownloadBackgroundTask];
    
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
    if (_beginDragging && _currentIndex != index) {
        if (index > _currentIndex) {
            _dragDirection = DragDirection_Down;
        }else{
            _dragDirection = DragDirection_Up;
        }
        _currentIndex = index;
        
        
//        [_currentCell pause]; //暂停上一个视频
        _currentCell = [self.mainTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0]];
        [self playCurCellVideo];
        
//        [_currentCell.playerView playVideo]; //播放视频
        
        _beginDragging = NO;
    }
    
    NSLog(@"-------------_liveInfoIndex = %ld",_currentIndex);
    NSLog(@"-------------self.mainDataArr.count = %ld",self.mainDataArr.count);
    NSLog(@"----------");
    
    NSInteger offset = self.mainDataArr.count - _currentIndex;
    if(offset == 2){ //开始加载下一页
        self.currentPage += 1;
        [self initRequest];
    }
}

-(void)playCurCellVideo{
    
    
    [_currentCell startDownloadHighPriorityTask];

    
    __weak typeof (HomeVideoCell) *wcell = _currentCell;
    __weak typeof (self) wself = self;
    //判断当前cell的视频源是否已经准备播放
    if(_currentCell.isPlayerReady) {
        //播放视频
        [_currentCell replay];
    }else {
        [[AVPlayerManager shareManager] pauseAll];
        //当前cell的视频源还未准备好播放，则实现cell的OnPlayerReady Block 用于等待视频准备好后通知播放
        _currentCell.onPlayerReady = ^{
            NSIndexPath *indexPath = [wself.mainTableView indexPathForCell:wcell];
            if(!wself.isCurPlayerPause && indexPath && indexPath.row == wself.currentIndex) {
                [wcell play];
            }
        };
    }
}

//#pragma -----------KVO-------
//-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
//    //观察currentIndex变化
//    if ([keyPath isEqualToString:@"currentIndex"]) {
//        //设置用于标记当前视频是否播放的BOOL值为NO
//        _isCurPlayerPause = NO;
//        //获取当前显示的cell
//        HomeVideoCell *cell = [self.mainTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0]];
//        [cell startDownloadHighPriorityTask];
//        __weak typeof (cell) wcell = cell;
//        __weak typeof (self) wself = self;
//        //判断当前cell的视频源是否已经准备播放
//        if(cell.isPlayerReady) {
//            //播放视频
//            [cell replay];
//        }else {
//            [[AVPlayerManager shareManager] pauseAll];
//            //当前cell的视频源还未准备好播放，则实现cell的OnPlayerReady Block 用于等待视频准备好后通知播放
//            cell.onPlayerReady = ^{
//                NSIndexPath *indexPath = [wself.mainTableView indexPathForCell:wcell];
//                if(!wself.isCurPlayerPause && indexPath && indexPath.row == wself.currentIndex) {
//                    [wcell play];
//                }
//            };
//        }
//    } else {
//        return [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
//    }
//}

#pragma mark --------------- HomeDelegate代理 -----------------

- (void)userInfoClicked:(HomeListModel *)listModel{
    
    NSLog(@"----------点击查看用户信息----------");
    
    UserInfoViewController *userInfoViewController = [[UserInfoViewController alloc] init];
    userInfoViewController.userNoodleId = listModel.noodleId;
    userInfoViewController.fromType = FromTypeHome; //我的页面，需要显示返回按钮，隐藏TabBar
    [self pushNewVC:userInfoViewController animated:YES];
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
        request.noodleId = [GlobalData sharedInstance].loginDataModel.noodleId;
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
    
    
    CommentsPopView *popView = [[CommentsPopView alloc] initWithAwemeId:listModel];
    [popView show];
}

- (void)shareClicked:(HomeListModel *)listModel{
    
        NSLog(@"----------分享----------");
    
}

- (void)musicCDClicked:(HomeListModel *)listModel{
    
    NSLog(@"----------CD----------");
    
}

@end
