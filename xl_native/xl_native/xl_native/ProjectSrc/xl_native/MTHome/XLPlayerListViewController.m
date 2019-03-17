//
//  FirstFunctionViewController.m
//  unify_platform
//
//  Created by mac on 2018/7/7.
//  Copyright © 2018年 CMP_Ljh. All rights reserved.
//

#import "XLPlayerListViewController.h"

@interface XLPlayerListViewController ()<HomeDelegate,VideoSahreDelegate,MtHomeTopDelegate>

@end

@implementation XLPlayerListViewController


#pragma -mark -----懒加载----下拉刷新切换头部View-------

- (MtHomeTopView *)topView{
    if (!_topView) {
        CGRect frame = CGRectMake(0, 0, ScreenWidth, kNavBarHeight_New);
        _topView = [[MtHomeTopView alloc] initWithFrame:frame];
        _topView.mtHomeTopDelegate = self;
//        _topView.backgroundColor = [UIColor redColor];
    }
    return _topView;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    [self playListCurrPlayDidAppear];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self playListCurrPlayDisAppear];
}

-(void)initNavTitle{
    self.isNavBackGroundHiden = YES;
}

-(void)dealloc{    
    /*dealloc*/
    [self.mainTableView.layer removeAllAnimations];
    NSArray<UserInfoPlayerCell *> *cells = [self.mainTableView visibleCells];
    for(UserInfoPlayerCell *cell in cells) {
        [cell.playerView cancelLoading];
    }
    [[AVPlayerManager shareManager] removeAllPlayers];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

#pragma -mark ------ CustomMethod ----------

-(void)setupUI{
    
    [self.view addSubview:self.mainTableView];
    
    self.mainTableView.size = [UIView getSize_width:ScreenWidth height:ScreenHeight];
    self.mainTableView.origin = [UIView getPoint_x:0 y:0];
    self.mainTableView.pagingEnabled = YES;
    self.mainTableView.showsVerticalScrollIndicator = NO;
    self.mainTableView.showsHorizontalScrollIndicator = NO;
    self.mainTableView.backgroundColor = XLColorBackgroundColor; //XLColorBackgroundColor;
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTableView.mj_footer = nil; //不需要上拉加载更多，在UIscrollerview 中处理加载更多
    
    [self.mainTableView registerClass:HomeVideoCell.class forCellReuseIdentifier:[HomeVideoCell cellId]];
    [self.view addSubview:self.topView];
    [self.mainTableView.mj_header beginRefreshing];
}

-(void)playCurCellVideo{
    
    //设置当前播放状态为播放，为跳转其他页面后再跳转回来后做准备。
    self.isDisAppearPlay = YES;
    
    [_currentCell startDownloadHighPriorityTask];
    __weak typeof (HomeVideoCell) *wcell = self.currentCell;
    __weak typeof (self) wself = self;
    //判断当前cell的视频源是否已经准备播放
    if(self.currentCell.isPlayerReady) {
        //播放视频
        [_currentCell replay];
    }
    else {
        [[AVPlayerManager shareManager] pauseAll];
        //当前cell的视频源还未准备好播放，则实现cell的OnPlayerReady Block 用于等待视频准备好后通知播放
        self.currentCell.onPlayerReady = ^{
            NSIndexPath *indexPath = [wself.mainTableView indexPathForCell:wcell];
            if(!wself.isCurPlayerPause && indexPath && indexPath.row == wself.currentPlayVideoIndex) {
                [wcell play];
            }
        };
    }
}

/*
 页面显示或从其他页面返回来已经显示调用方法
 */
- (void)playListCurrPlayDidAppear{
    
    if(self.currentCell && self.isDisAppearPlay){
        [self.currentCell.playerView play];
    }
}
/*
 页面消失调用方法
 */
- (void)playListCurrPlayDisAppear{
        if(self.currentCell && self.isDisAppearPlay){
            [self.currentCell.playerView pause];
        }
}

#pragma mark ----------- 数据加载代理  ----------
-(void)loadNewData{
    
    self.currentPlayVideoIndex = 0; //默认第一条视频
    self.currentPageIndex = 0; //刷新是显示第一页美容
    [self.mainDataArr removeAllObjects];
    [self initRequest];
}

#pragma mark --------- 网络请求 ------------

-(void)initRequest {
    
    NetWork_mt_home_list *request = [[NetWork_mt_home_list alloc] init];
    request.pageNo = [NSString stringWithFormat:@"%ld",self.currentPageIndex=self.currentPageIndex+1];
    request.pageSize = [NSString stringWithFormat:@"%ld",(long)self.currentPageSize];
    request.currentNoodleId = [GlobalData sharedInstance].loginDataModel.noodleId;
    [request startGetWithBlock:^(HomeListResponse *result, NSString *msg) {
        /*
         缓存暂时先不用考虑
         */
    } finishBlock:^(HomeListResponse *result, NSString *msg, BOOL finished) {
        
        [self.mainTableView.mj_header endRefreshing];
        if(finished){
            if (self.currentPageIndex == 1 ) {
                [self.mainDataArr removeAllObjects];
                [self refreshNoDataViewWithListCount:result.obj.count];
            }
            [self.mainDataArr addObjectsFromArray:result.obj];
            [self.mainTableView reloadData];
            
//            if(self.isFirstLoad){//第一次加载
////                NSLog(@"--------------------self.isFirstLoad------------------");
//                self.isFirstLoad = NO;
            
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.currentPlayVideoIndex inSection:0];
                [self.mainTableView scrollToRowAtIndexPath:indexPath
                                          atScrollPosition:UITableViewScrollPositionTop
                                                  animated:NO];
                self.currentCell = [self.mainTableView cellForRowAtIndexPath:indexPath];
                [self playCurCellVideo];
//            }
        }
        else{
            [UIWindow showTips:@"网络不给力"];
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
    
    if(self.mainDataArr.count > 0){
        HomeVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:[HomeVideoCell cellId] forIndexPath:indexPath];
        HomeListModel *model = [self.mainDataArr objectAtIndex:[indexPath row]];
        cell.homeDelegate = self;
        [cell fillDataWithModel:model];
        [cell startDownloadBackgroundTask];
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if(self.scrollBlock){
        self.scrollBlock(YES);
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if(self.scrollBlock){
        self.scrollBlock(NO);
    }
    
    CGPoint rect = scrollView.contentOffset;
    NSInteger index = rect.y / self.view.height;
    if (self.currentPlayVideoIndex != index) {
        self.currentPlayVideoIndex = index;
        
        NSInteger offset = self.mainDataArr.count - self.currentPlayVideoIndex;
        if(offset != 1){
        self.currentCell = [self.mainTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentPlayVideoIndex inSection:0]];
        [self playCurCellVideo];
        }
    }
    
    NSInteger offset = self.mainDataArr.count - self.currentPlayVideoIndex;
    if(offset == 1){ //开始加载下一页
        [self initRequest];
    }
}

#pragma mark --------------- MtHomeTopDelegate代理 -----------------

-(void)searchBtnClick{
    
    if(self.seachClickBlock){
        self.seachClickBlock();
    }
}

-(void)recommendBtnClick{
    NSLog(@"------recommendBtnClick----------");
}

-(void)cityBtnClick{
    NSLog(@"------cityBtnClick----------");
}

-(void)scanBtnClick{
    NSLog(@"------scanBtnClick----------");
}
-(void)refreshBtnClick{
    [self.mainTableView.mj_header beginRefreshing];
}

#pragma mark --------------- HomeDelegate代理 -----------------

-(void)currVideoProgressUpdate:(HomeListModel *)listModel current:(CGFloat)current total:(CGFloat)total{
    //当前视频播放进度
    
    if(current == 0.0f){
        
        NetWork_mt_addVideoPlay *request = [[NetWork_mt_addVideoPlay alloc] init];
        request.currentNoodleId = [GlobalData sharedInstance].loginDataModel.noodleId;
        request.noodleVideoId = [NSString stringWithFormat:@"%@",listModel.noodleVideoId];
        [request startPostWithBlock:^(id result, NSString *msg, BOOL finished) {
            if(finished){
                NSLog(@"-----------播放量增加-----------");
            }
        }];
        
    }
}

- (void)userInfoClicked:(HomeListModel *)listModel{
    
    UserInfoViewController *userInfoViewController = [[UserInfoViewController alloc] init];
    userInfoViewController.userNoodleId = listModel.noodleId;
    userInfoViewController.fromType = FromTypeHome; //我的页面，需要显示返回按钮，隐藏TabBar
    [self pushNewVC:userInfoViewController animated:YES];
}

- (void)followClicked:(HomeListModel *)listModel{
    
    [[ZJLoginService sharedInstance] authenticateWithCompletion:^(BOOL success) {
        
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
            if(finished){
                self.currentCell.listModel.isFlour = [NSNumber numberWithInteger:1];
            }
            else{
                [UIWindow showTips:msg];
            }
        }];
        contentModel = nil;
        
    } cancelBlock:^{
        NSLog(@"--------取消登录---------");
    } isAnimat:YES];
}

- (void)zanClicked:(HomeListModel *)listModel{
    NSLog(@"-------");
    
    [[ZJLoginService sharedInstance] authenticateWithCompletion:^(BOOL success) {
        
        if([listModel.isLike intValue] == 0){ //点赞
            
            NetWork_mt_likeVideo *request = [[NetWork_mt_likeVideo alloc] init];
            request.currentNoodleId = [GlobalData sharedInstance].loginDataModel.noodleId;
            request.noodleVideoId = [NSString stringWithFormat:@"%@",listModel.noodleVideoId];
            request.noodleVideoCover = listModel.noodleVideoCover;
            request.noodleId = [GlobalData sharedInstance].loginDataModel.noodleId;
            [request startPostWithBlock:^(id result, NSString *msg, BOOL finished) {
                if(finished){
                    //赞成功，修改数值重新加载cell
                    listModel.isLike = [NSNumber numberWithInt:1];
                    listModel.likeSum = [NSNumber numberWithInt:[listModel.likeSum intValue]+1];
                    
                    [self.currentCell fillDataWithModel:listModel];
                }
                else{
                    [self showFaliureHUD:msg];
                }
            }];
        }
        else{ //已赞，取消赞
            NetWork_mt_delLikeVideo *request = [[NetWork_mt_delLikeVideo alloc] init];
            request.currentNoodleId = [GlobalData sharedInstance].loginDataModel.noodleId;
            request.noodleVideoId = [NSString stringWithFormat:@"%@",listModel.noodleVideoId];
            request.noodleId = [GlobalData sharedInstance].loginDataModel.noodleId;
            [request startPostWithBlock:^(id result, NSString *msg, BOOL finished) {
                if(finished){
                    
                    //取消赞成功，修改数值后重新加载cell
                    listModel.isLike = [NSNumber numberWithInt:0];
                    listModel.likeSum = [NSNumber numberWithInt:[listModel.likeSum intValue]-1];
                    [self.currentCell fillDataWithModel:listModel];
                }
                else{
                    [self showFaliureHUD:msg];
                }
            }];
        }
        
    } cancelBlock:^{
        
    } isAnimat:YES];
}

- (void)commentClicked:(HomeListModel *)listModel{
    
    [[ZJLoginService sharedInstance] authenticateWithCompletion:^(BOOL success) {
        CommentsPopView *popView = [[CommentsPopView alloc] initWithAwemeId:listModel];
        [popView setCommitResult:^(BOOL finish, NSInteger totalCount) {
            listModel.commentSum = [NSString stringWithFormat:@"%ld",totalCount];
            [self.currentCell fillDataWithModel:listModel];
        }];
        [popView show];
    } cancelBlock:nil isAnimat:YES];
}

- (void)shareClicked:(HomeListModel *)listModel{
    
//    SharePopView *popView = [[SharePopView alloc] init];
//    popView.homeListModel = listModel;
//    popView.delegate = self;
//    [popView show];
    
    
//    NSDictionary *sinaDBDictionary = [sinaDBArray objectAtIndex:0];
    NSString *currentNoodleId = @"49271173787291648";
    NSString *content = @"{\"noodleId\":\"49271173787291648\",\"musicName\":\"@KillerD创作的原声\",\"musicId\":\"6584922963072518919\",\"fileId\":\"5285890786874115491\",\"musicUrl\":\"http://p3-dy.bytecdn.cn/obj/a10b0002a3b2c4ea81f8\",\"addr\":\"北京市朝阳区北苑路180号\",\"size\":\"720p\",\"title\":\"songlei 发布内容测试\",\"topic\":\"#万圣节\",\"noodleVideoName\":\"SFgkEQwEe8YA.mp4\",\"coverUrl\":\"https://p22-dy.bytecdn.cn/aweme/1080x1080/1c9af00026150f891676d.jpeg\",\"nickname\":\"sll\",\"noodleVideoCover\":\"http://1258810953.vod2.myqcloud.com/26f8b0acvodcq1258810953/a36324f75285890786874115491/5285890786874115492.png\",\"storagePath\":\"http://1258810953.vod2.myqcloud.com/26f8b0acvodcq1258810953/a36324f75285890786874115491/SFgkEQwEe8YA.mp4\"}";
    
    NSString *boundary = @"14745591349540787582088777204";
    
    
    //设置请求体中内容
    NSMutableString *bodyString = [NSMutableString string];
    [bodyString appendFormat:@"-----------------------------%@\r\n", boundary];
    [bodyString appendString:@"Content-Disposition: form-data; name=\"currentNoodleId\"\r\n"];
    [bodyString appendString:@"\r\n"];
    [bodyString appendString:currentNoodleId];
    [bodyString appendString:@"\r\n"];
    [bodyString appendFormat:@"-----------------------------%@\r\n", boundary];
    [bodyString appendString:@"Content-Disposition: form-data; name=\"content\"\r\n"];
    [bodyString appendString:@"\r\n"];
    [bodyString appendString:content];
    [bodyString appendString:@"\r\n"];
    [bodyString appendFormat:@"-----------------------------%@--\r\n",boundary];
    
    
    
    NSString *strTest = @"-----------------------------14745591349540787582088777204Content-Disposition:form-data;name=\"currentNoodleId\"49271173787291648-----------------------------14745591349540787582088777204Content-Disposition:form-data;name=\"content\"{\"noodleId\":\"49271173787291648\",\"musicName\":\"@KillerD创作的原声\",\"musicId\":\"6584922963072518919\",\"fileId\":\"5285890786874115491\",\"musicUrl\":\"http://p3-dy.bytecdn.cn/obj/a10b0002a3b2c4ea81f8\",\"addr\":\"北京市朝阳区北苑路180号\",\"size\":\"720p\",\"title\":\"songlei 发布内容测试\",\"topic\":\"#万圣节\",\"noodleVideoName\":\"SFgkEQwEe8YA.mp4\",\"coverUrl\":\"https://p22-dy.bytecdn.cn/aweme/1080x1080/1c9af00026150f891676d.jpeg\",\"nickname\":\"sll\",\"noodleVideoCover\":\"http://1258810953.vod2.myqcloud.com/26f8b0acvodcq1258810953/a36324f75285890786874115491/5285890786874115492.png\",\"storagePath\":\"http://1258810953.vod2.myqcloud.com/26f8b0acvodcq1258810953/a36324f75285890786874115491/SFgkEQwEe8YA.mp4\"}-----------------------------14745591349540787582088777204--";
    
    NSMutableData *bodyData = [[NSMutableData alloc]initWithLength:0];
    NSData *bodyStringData = [strTest dataUsingEncoding:NSUTF8StringEncoding];
    [bodyData appendData:bodyStringData];
    
    NSString *len = [NSString stringWithFormat:@"%lu",(unsigned long)[bodyData length]];
    
    NSString *s = [NSString stringWithFormat:@"multipart/form-data; boundary=---------------------------%@", boundary];
    
    
    NSString *url = @"http://106.13.57.126:8080/miantiao/video/saveVideo";
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL: [NSURL URLWithString: url]];
    request.defaultResponseEncoding = NSUTF8StringEncoding;
    request.useCookiePersistence = YES;
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:s];
    [request addRequestHeader:@"Content-Length" value:len];
    [request setPostBody:bodyData];
    
    
    [request startSynchronous];
    
    NSError *error = request.error;
    if (!error) {
         NSLog(@"%@",[request responseString]);
    }else{
         NSLog(@"%@",[[request error]localizedDescription]);
    }
}

- (void)musicCDClicked:(HomeListModel *)listModel{
    
    MusicInfoController *musicInfoController = [[MusicInfoController alloc] init];
    musicInfoController.musicId = [NSString stringWithFormat:@"%@",listModel.musicId];
    [self pushNewVC:musicInfoController animated:YES];
}

- (void)playButtonAction:(BOOL)isPlay{
    self.isDisAppearPlay = isPlay;
}

#pragma mark --------------- VideoSahreDelegate 代理 -----------------

- (void)onShareItemClicked:(SharePopView *)sharePopView index:(NSInteger)index{
    
}

- (void)onActionItemClicked:(SharePopView *)sharePopView index:(NSInteger)index{
    
    if(index == 0){
        
        CollectionContentModel *contentModel = [[CollectionContentModel alloc] init];
        contentModel.noodleId = [GlobalData sharedInstance].loginDataModel.noodleId;//当前登录者面条号
        contentModel.noodleVideoId = [NSString stringWithFormat:@"%@",self.currentCell.listModel.noodleVideoId]; //视频Id
        contentModel.videoNoodleId = self.currentCell.listModel.noodleId;      //视频所属者面条好
        contentModel.noodleVideoCover = self.currentCell.listModel.coverUrl;    //
        
        NetWork_mt_collectionVideo *request = [[NetWork_mt_collectionVideo alloc] init];
        request.currentNoodleId = [GlobalData sharedInstance].loginDataModel.noodleId;
        request.content = [contentModel generateJsonStringForProperties];
        [request startPostWithBlock:^(id result, NSString *msg, BOOL finished) {
            if(finished){
                [UIWindow showTips:@"收藏成功"];
            }
            else{
                [UIWindow showTips:@"收藏失败"];
            }
        }];
    }
}

@end
