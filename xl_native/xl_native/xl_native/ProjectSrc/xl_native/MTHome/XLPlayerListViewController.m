//
//  FirstFunctionViewController.m
//  unify_platform
//
//  Created by mac on 2018/7/7.
//  Copyright © 2018年 CMP_Ljh. All rights reserved.
//

#import "XLPlayerListViewController.h"

@interface XLPlayerListViewController ()<HomeDelegate,VideoSahreDelegate,MtHomeTopDelegate,VideoSahreDelegate,TXVideoGenerateListener>

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
    
//    [self playListCurrPlayDidAppear];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [self playListCurrPlayDisAppear];
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

-(void)viewDidLoad {
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
            if(indexPath && indexPath.row == wself.currentPlayVideoIndex) {
                [wcell play];
            }
        };
    }
}

/*
  GKDouyinHomeViewController 调用播放方法
 */
- (void)playListCurrPlay{
    
    if(self.currentCell){
        [self.currentCell.playerView play];
    }
}
/*
 GKDouyinHomeViewController 调用暂停方法
 */
- (void)playListCurrPause{
        if(self.currentCell){
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
    request.pageNo = [NSString stringWithFormat:@"%d",self.currentPageIndex=self.currentPageIndex+1];
    request.pageSize = [NSString stringWithFormat:@"%d",self.currentPageSize];
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
            
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.currentPlayVideoIndex inSection:0];
                [self.mainTableView scrollToRowAtIndexPath:indexPath
                                          atScrollPosition:UITableViewScrollPositionTop
                                                  animated:NO];
                self.currentCell = [self.mainTableView cellForRowAtIndexPath:indexPath];
                [self playCurCellVideo];
        }
        else{
            self.currentPageIndex=self.currentPageIndex-1;
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
    if(offset == 2){ //开始加载下一页
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
    
    SharePopView *popView = [[SharePopView alloc] init];
    popView.homeListModel = listModel;
    popView.delegate = self;
    [popView show];
}

- (void)musicCDClicked:(HomeListModel *)listModel{
    
    MusicInfoController *musicInfoController = [[MusicInfoController alloc] init];
    musicInfoController.musicId = [NSString stringWithFormat:@"%@",listModel.musicId];
    [self pushNewVC:musicInfoController animated:YES];
}

- (void)playButtonAction:(BOOL)isPlay{
    self.isDisAppearPlay = isPlay;
}

/*点击话题*/
- (void)topicAction:(NSString *)topicName{
    
    TopicInfoController *topicInfoController = [[TopicInfoController alloc] init];
    topicInfoController.topicName = topicName;
    [self pushNewVC:topicInfoController animated:YES];
}



#pragma mark --------------- VideoSahreDelegate 代理 -----------------

- (void)onShareItemClicked:(SharePopView *)sharePopView index:(MTShareType)index{
    
    self.shareType = index;
    
    if(index == MTShareTypeWechatVideo || index == MTShareTypeRegQQVideo ){
        //生成带水印的视频，并分享到微信或者qq
        //获取本地磁盘缓存文件夹路径，同视频缓存同一个目录，缓存一天后删除
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString *path = [paths lastObject];
        NSString *diskCachePath = [NSString stringWithFormat:@"%@%@",path,@"/webCache"];
        //当前视频播放Model
        NSString *name = [NSString stringWithFormat:@"/share_download_%@.mp4",self.currentCell.listModel.noodleVideoId];
        NSString *chorusFileName = [NSString stringWithFormat:@"%@%@",diskCachePath,name];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:chorusFileName]){ //本地存在视频，开始使用SDK生成带水印的的视频
            [self onloadVideoComplete:chorusFileName];
        }
        else{//
            NSString *videoUrl = self.currentCell.listModel.storagePath;
            
            [FileHelper downloadFile:chorusFileName playUrl:videoUrl processBlock:^(float percent) {
                [self onloadVideoProcess:percent];
            } completionBlock:^(BOOL result, NSString *msg) {
                if(result){
                    [self onloadVideoComplete:chorusFileName];
                }
                else{
                    [UIWindow showTips:msg];
                }
            }];
            
        }
    }
}

- (void)onActionItemClicked:(SharePopView *)sharePopView index:(MTShareActionType)index{
    
    if(index == MTShareActionTypeCollention){
        
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

#pragma -mark  ----------- 视频合成相关 ---------
-(void)onloadVideoProcess:(CGFloat)process {
    [GlobalFunc showHud:[NSString stringWithFormat:@"正在下载视频%d %%",(int)(process * 100)]];
}

-(void)onloadVideoComplete:(NSString *)videoPath {
    [GlobalFunc hideHUD:1.0f];
    
    //开始合成视频
    NSURL *avUrl = [NSURL fileURLWithPath:videoPath];
    self.videoAsset = [AVAsset assetWithURL:avUrl];
    
    
    TXPreviewParam *param = [[TXPreviewParam alloc] init];
    //    param.videoView = _videoPreview.renderView;
    param.renderMode = PREVIEW_RENDER_MODE_FILL_EDGE;
    
    self.ugcEdit = [[TXVideoEditer alloc] initWithPreview:param];
    ///生成视频回调的委托对象, 可以获取生成进度与完成时间等
    self.ugcEdit.generateDelegate = self;
    //设置视频 AVAsset
    [self.ugcEdit setVideoAsset:self.videoAsset];
    
    TXVideoInfo *videoMsg = [TXVideoInfoReader getVideoInfoWithAsset:self.videoAsset];
    UIImage *tailWaterimage = [UIImage imageNamed:@"watermark"];
    [self.ugcEdit setWaterMark:tailWaterimage normalizationFrame:CGRectMake(0.01, 0.01, 0.3 , 0)]; //全局水印
    
    float w = 0.35;
    float x = (1.0 - w) / 2.0;
    float width = w * videoMsg.width;
    float height = width * tailWaterimage.size.height / tailWaterimage.size.width;
    float y = (videoMsg.height - height) / 2 / videoMsg.height;
    [self.ugcEdit setTailWaterMark:tailWaterimage normalizationFrame:CGRectMake(x,y,w,0) duration:1];//片尾水印
    
    NSString *videoOutputPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"outputCut_temp.mp4"];
    //[self.ugcEdit generateVideo:VIDEO_COMPRESSED_720P videoOutputPath:videoOutputPath];
    [self.ugcEdit generateVideo:VIDEO_COMPRESSED_720P videoOutputPath:videoOutputPath];
}

#pragma -mark  ----------- TXVideoGenerateListener ---------

/**
 * 短视频生成完成
 * @param progress 生成视频进度百分比
 */
-(void) onGenerateProgress:(float)progress{
    [GlobalFunc showHud:[NSString stringWithFormat:@"正在加载视频%d %%",(int)(progress * 100)]];
}

/**
 * 短视频生成完成
 * @param result 生成结果
 * @see TXGenerateResult
 */
-(void) onGenerateComplete:(TXGenerateResult *)result{
    
    [GlobalFunc hideHUD];
    
    NSString *videoOutputPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"outputCut_temp.mp4"];
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library writeVideoAtPathToSavedPhotosAlbum:[NSURL fileURLWithPath:videoOutputPath] completionBlock:^(NSURL *assetURL, NSError *error) {
        if (error != nil) {
            [GlobalFunc showAlertWithMessage:@"视频保存失败！"];
        }else{
//            [GlobalFunc showAlertWithMessage:@"视频保存成功！"];
            
            if(self.shareType == MTShareTypeWechatVideo){
                
                NSURL * url = [NSURL URLWithString:@"weixin://"];
                BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:url];
                //先判断是否能打开该url
                if (canOpen)
                {   //打开微信
                    [[UIApplication sharedApplication] openURL:url];
                }else {
                    [GlobalFunc showAlertWithMessage:@"没有安装微信"];
                }
            }
            else if (self.shareType == MTShareTypeRegQQVideo){
                NSURL * url = [NSURL URLWithString:@"mqq://"];
                BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:url];
                //先判断是否能打开该url
                if (canOpen)
                {   //打开微信
                    [[UIApplication sharedApplication] openURL:url];
                }else {
                    [GlobalFunc showAlertWithMessage:@"没有安装qq"];
                }
            }
            
        }
    }];
}


@end
