//
//  FirstFunctionViewController.m
//  unify_platform
//
//  Created by mac on 2018/7/7.
//  Copyright © 2018年 CMP_Ljh. All rights reserved.
//

#import "XLPlayerListViewController.h"

@interface XLPlayerListViewController ()<HomeDelegate,VideoSahreDelegate>

@end

@implementation XLPlayerListViewController


#pragma -mark -----懒加载----下拉刷新切换头部View-------

- (MtHomeTopView *)topView{
    if (!_topView) {
        CGRect frame = CGRectMake(0, 0, ScreenWidth, kNavBarHeight_New);
        _topView = [[MtHomeTopView alloc] initWithFrame:frame];
    }
    return _topView;
}

-(MTHomeRefreshNavigitionView *)refreshNavigitionView{
    
    if (!_refreshNavigitionView) {
        _refreshNavigitionView = [[MTHomeRefreshNavigitionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, kNavBarHeight_New)];
        _refreshNavigitionView.backgroundColor = [UIColor clearColor];
        _refreshNavigitionView.alpha = 0;
        
        //test
        //        _refreshNavigitionView.backgroundColor = [UIColor blueColor];
    }
    return _refreshNavigitionView;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    if(self.currentCell){
        [self.currentCell.playerView play];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarHidden = YES;
    //    self.tabBar.top = [self getTabbarTop];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if(self.currentCell){
        [self.currentCell.playerView pause];
    }
}

-(void)initNavTitle{
    self.isNavBackGroundHiden = YES;
}

-(void)dealloc{    
    /*dealloc*/
    
    [self.mainTableView removeObserver:self forKeyPath:@"contentOffset"];
    
    
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
    self.mainTableView.backgroundColor = XLColorBackgroundColor; //XLColorBackgroundColor;
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTableView.mj_header = nil;
    self.mainTableView.mj_footer = nil;
    
    [self.mainTableView registerClass:HomeVideoCell.class forCellReuseIdentifier:[HomeVideoCell cellId]];
    
    __weak typeof(self) weakSelf = self;
    [self addJXRefreshWithTableView:self.mainTableView andRefreshBlock:^{
        [weakSelf loadNewListData];
    }];
    [self loadNewListData];
}

-(void)loadNewListData{
    self.currentIndex = 0; //默认第一条视频
    self.isFirstLoad = YES;
    self.currentPage = 0;
    [self.mainDataArr removeAllObjects];
    [self initRequest];
}

-(void)playCurCellVideo{
    
    //    BOOL temp = firstLoad
    
    [_currentCell startDownloadHighPriorityTask];
    __weak typeof (HomeVideoCell) *wcell = self.currentCell;
    __weak typeof (self) wself = self;
    //判断当前cell的视频源是否已经准备播放
    if(self.currentCell.isPlayerReady) {
        //播放视频
        [_currentCell replay];
        
        NSLog(@"---------[_currentCell replay];-------");
        
    }
    else {
        [[AVPlayerManager shareManager] pauseAll];
        //当前cell的视频源还未准备好播放，则实现cell的OnPlayerReady Block 用于等待视频准备好后通知播放
        self.currentCell.onPlayerReady = ^{
            NSIndexPath *indexPath = [wself.mainTableView indexPathForCell:wcell];
            if(!wself.isCurPlayerPause && indexPath && indexPath.row == wself.currentIndex) {
                [wcell play];
            }
        };
    }
}

#pragma mark --------- 仿抖音下拉刷新 ------------

-(void)addJXRefreshWithTableView:(UIScrollView *)scrollView andRefreshBlock:(void (^)(void))block{
    if (![scrollView isKindOfClass:[UIScrollView class]]) {
        return;
    }
    self.refreshBlock = block;
    
    //用来响应touch的view
    self.clearView = [[UIView alloc] init];
    self.clearView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    self.clearView.backgroundColor = RGBA(255, 0, 0, 0.0);
    [self.view addSubview:self.clearView];
    [self.view addSubview:self.refreshNavigitionView];
    
    //添加观察者
    [self.mainTableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
}

-(void)endRefresh{
    
    [self resumeNormal];
    [self.refreshNavigitionView.circleImage.layer removeAnimationForKey:@"rotationAnimation"];
    _clearView.hidden = NO;
}

#pragma mark --------- Kvo ------------

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    //观察contentOffset变化
    if ([keyPath isEqualToString:@"contentOffset"]) {
        if (self.mainTableView.contentOffset.y <= 0) {
            self.clearView.hidden = NO;
        }
    }
    else {
        return [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark -------------- touch -------------


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (self.mainTableView.contentOffset.y <=0 && self.refreshStatus == REFRESH_Normal) {
        //当tableview停在第一个cell并且是正常状态才记录起始触摸点，防止页面在刷新时用户再次向下拖拽页面造成多次下拉刷新
        self.startPoint = [touches.anyObject locationInView:self.view];
    }else{
        //否则就隐藏透明视图，让页面能响应tableview的拖拽手势
        _clearView.hidden = YES;
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if (CGPointEqualToPoint(self.startPoint,CGPointZero)) {
        //没记录到起始触摸点就返回
        return;
    }
    
    CGPoint currentPoint = [touches.anyObject locationInView:self.view];
    float moveDistance = currentPoint.y - self.startPoint.y;
    if (self.mainTableView.contentOffset.y <=0){ //下拉
        //根据触摸点移动方向判断用户是下拉还是上拉
        if( moveDistance > 0 && moveDistance < MaxDistance) {
            
            self.refreshStatus = REFRESH_MoveDown;
            //只判断当前触摸点与起始触摸点y轴方向的移动距离，只要y比起始触摸点的y大就证明是下拉，这中间可能存在先下拉一段距离没松手又上滑了一点的情况
            float alpha = moveDistance/MaxDistance;
            self.refreshNavigitionView.alpha = alpha;
            self.refreshNavigitionView.top = moveDistance;
            self.topView.alpha = 1 - alpha;
            
            //在整体判断为下拉刷新的情况下，还需要对上一个触摸点和当前触摸点进行比对，判断圆圈旋转方向，下移逆时针，上移顺时针
            CGPoint previousPoint = [touches.anyObject previousLocationInView:self.view];//上一个坐标
            if (currentPoint.y>previousPoint.y) {
                _refreshNavigitionView.circleImage.transform= CGAffineTransformRotate(_refreshNavigitionView.circleImage.transform,-0.08);
            }
            else{
                _refreshNavigitionView.circleImage.transform= CGAffineTransformRotate(_refreshNavigitionView.circleImage.transform,0.08);
            }
        }
        else if(moveDistance >= MaxDistance){
            //_refreshNavigitionView和topView就保持透明度和位置，不再移动
            self.refreshStatus = REFRESH_MoveDown;
            self.refreshNavigitionView.alpha = 1;
            self.topView.alpha = 0;
        }
        else if(moveDistance < 0){
            self.refreshStatus = REFRESH_MoveUp;
            //moveDistance<0则是上拉 根据移动距离修改tableview.contentOffset，模仿tableview的拖拽效果，一旦执行了这行代码，下个触摸点就会走外层else代码
            self.mainTableView.contentOffset = CGPointMake(0, -moveDistance);
        }
    }
    else{//上拉
        self.refreshStatus = REFRESH_MoveUp;
        //tableview被上拉了
        moveDistance = self.startPoint.y - currentPoint.y;//转换为正数
        if (moveDistance > MaxScroll) {
            //上拉距离超过MaxScroll，就让tableview滚动到第二个cell，模仿tableview翻页效果
            _clearView.hidden = YES;
        }
        else if(moveDistance >0&& moveDistance < MaxScroll){
            self.mainTableView.contentOffset = CGPointMake(0, moveDistance);
        }
        self.mainTableView.contentOffset = CGPointMake(0, moveDistance);
    }
}


- (void)touchesEnded:(NSSet *)touches
           withEvent:(UIEvent *)event{
    
    CGPoint currentPoint = [touches.anyObject locationInView:self.view];
    float moveDistance = currentPoint.y-self.startPoint.y;
    if (moveDistance==0) {
        
        //通过point所在位置 判断应该响应那个蒙版下面的按钮
        BOOL isExitFlollow = CGRectContainsPoint(_currentCell.maskView.focus.frame,currentPoint);
        if(isExitFlollow){
            NSLog(@"点击关注");
            if(!self.currentCell.listModel.isFlour){ //如果没有关注，才可点击关注按钮
                [self.currentCell.maskView followHomeClick];
                return;
            }
        }
        
        BOOL isExitUserInfo = CGRectContainsPoint(_currentCell.maskView.avatar.frame,currentPoint);
        if(isExitUserInfo){
            NSLog(@"点击用户头像");
            [self userInfoClicked:_currentCell.listModel];
            return;
        }
        
        BOOL isExitFav = CGRectContainsPoint(_currentCell.maskView.favorite.frame,currentPoint);
        if(isExitFav){
            NSLog(@"点击喜欢");
            [self.currentCell.maskView.favorite favoriteViewLikeClick:[_currentCell.listModel.isLike boolValue]];
            self.currentCell.listModel.isLike = [NSNumber numberWithBool:![_currentCell.listModel.isLike boolValue]];
            
            return;
        }
        
        BOOL isExitComment = CGRectContainsPoint(_currentCell.maskView.comment.frame,currentPoint);
        if(isExitComment){
            NSLog(@"点击评论");
            [self commentClicked:_currentCell.listModel];
            return;
        }
        
        BOOL isExitShare = CGRectContainsPoint(_currentCell.maskView.share.frame,currentPoint);
        if(isExitShare){
            NSLog(@"点击分享");
            [self shareClicked:_currentCell.listModel];
            return;
        }
        
        BOOL isExitMusicAlum = CGRectContainsPoint(_currentCell.maskView.musicAlum.frame,currentPoint);
        if(isExitMusicAlum){
            NSLog(@"点击旋转CD");
            [self musicCDClicked:_currentCell.listModel];
            return;
        }
        
        BOOL isExitPlayBtn = CGRectContainsPoint(_currentCell.maskView.frame,currentPoint);
        if(isExitPlayBtn){
            NSLog(@"暂停或播放");
            [self.currentCell.maskView singleTapAction];
            return;
        }
        return;
    }
    
    //清除起始触摸点
    self.startPoint = CGPointZero;
    
    //1.在第一页，松开手后，判断向下滚动还是向上滚动
    if(self.mainTableView.contentOffset.y > ScreenHeight/2){
        [UIView animateWithDuration:0.3 animations:^{
            self.mainTableView.contentOffset = CGPointMake(0, ScreenHeight);
        }];
        
        self.currentIndex = 1;
        self.currentCell = [self.mainTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0]];
        [self playCurCellVideo];
    }
    else{
        [UIView animateWithDuration:0.3 animations:^{
            self.mainTableView.contentOffset = CGPointMake(0, 0);
        }];
    }
    
    //触摸结束恢复原位-松手回弹
    [UIView animateWithDuration:0.3 animations:^{
        
        self.refreshNavigitionView.top = 0;
        self.topView.top = 0;
        
        if (self.mainTableView.contentOffset.y < MaxScroll) {
            //没滚动到最大点，就复原tableview的位置
            self.mainTableView.contentOffset = CGPointMake(0, 0);
        }
        if(self.refreshNavigitionView.alpha == 1){
            self.refreshStatus = XDREFRESH_BeginRefresh;
            [self startAnimation]; //旋转d加载动画
            if (self.refreshBlock) { //响应刷新block
                self.refreshBlock();
            }
        }
        else{
            //没下拉到最大点，alpha复原
            [self resumeNormal];
        }
    }];
}


//恢复正常状态
-(void)resumeNormal{
    self.refreshStatus = REFRESH_Normal;
    [UIView animateWithDuration:0.3 animations:^{
        self.refreshNavigitionView.alpha = 0;
        self.topView.alpha = 1;
    }];
}

-(void)startAnimation{
    
    //要先将transform复位-因为CABasicAnimation动画执行完毕后会自动复位，就是没有执行transform之前的位置，跟transform之后的位置有角度差，会造成视觉上旋转不流畅
    self.refreshNavigitionView.circleImage.transform = CGAffineTransformIdentity;
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0];
    rotationAnimation.duration = 0.5;
    rotationAnimation.cumulative = YES;
    //重复旋转的次数，如果你想要无数次，那么设置成MAXFLOAT
    rotationAnimation.repeatCount = MAXFLOAT;
    [self.refreshNavigitionView.circleImage.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
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
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
                self.currentCell = [self.mainTableView cellForRowAtIndexPath:indexPath];
                [self playCurCellVideo];
            }
        }
        else{
            [UIWindow showTips:@"网络不给力"];
        }
        [self endRefresh];
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


//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//    _beginDragging = YES;
//}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    CGPoint rect = scrollView.contentOffset;
    NSInteger index = rect.y / self.view.height;
    if (self.currentIndex != index) {
        self.currentIndex = index;
        
        self.currentCell = [self.mainTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0]];
        [self playCurCellVideo];
    }
    
    NSInteger offset = self.mainDataArr.count - self.currentIndex;
    if(offset == 2){ //开始加载下一页
        self.currentPage += 1;
        [self initRequest];
    }
}

#pragma mark --------------- HomeDelegate代理 -----------------

-(void)currVideoProgressUpdate:(HomeListModel *)listModel current:(CGFloat)current total:(CGFloat)total{
    //当前视频播放进度
    
    if(current == 0.0f){
        NSLog(@"-------调用，视频播放接口-----");
        
        NetWork_mt_addVideoPlay *request = [[NetWork_mt_addVideoPlay alloc] init];
        request.currentNoodleId = [GlobalData sharedInstance].loginDataModel.noodleId;
        request.noodleVideoId = listModel.noodleVideoId;
        [request startPostWithBlock:^(id result, NSString *msg, BOOL finished) {
            if(finished){
                NSLog(@"-----------播放量增加-----------");
            }
        }];
        
    }
}

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
            if(finished){}
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
            request.noodleVideoId = listModel.noodleVideoId;
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
            request.noodleVideoId = listModel.noodleVideoId;
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
    
    CommentsPopView *popView = [[CommentsPopView alloc] initWithAwemeId:listModel];
    [popView setCommitResult:^(BOOL finish, NSInteger totalCount) {
        
        listModel.commentSum = [NSString stringWithFormat:@"%ld",totalCount];
        [self.currentCell fillDataWithModel:listModel];
    }];
    [popView show];
}

- (void)shareClicked:(HomeListModel *)listModel{
    NSLog(@"----------分享----------");
    
    SharePopView *popView = [[SharePopView alloc] init];
    popView.delegate = self;
    [popView show];
}

- (void)musicCDClicked:(HomeListModel *)listModel{
    NSLog(@"----------CD----------");
    
    //test, 查看测试收藏的视频列表
    NetWork_mt_getVideoCollections *request = [[NetWork_mt_getVideoCollections alloc] init];
    request.currentNoodleId = [GlobalData sharedInstance].loginDataModel.noodleId;
    request.noodleId = [GlobalData sharedInstance].loginDataModel.noodleId;
    request.pageNo = @"1";
    request.pageSize = @"20";
    
    [request startGetWithBlock:^(id result, NSString *msg) {
        /*暂不考虑缓存的问题*/
    } finishBlock:^(id result, NSString *msg, BOOL finished) {
        NSLog(@"----------CD----------");

    }];
    
    
}

#pragma mark --------------- VideoSahreDelegate 代理 -----------------

- (void)onShareItemClicked:(SharePopView *)sharePopView index:(NSInteger)index{
    
}

- (void)onActionItemClicked:(SharePopView *)sharePopView index:(NSInteger)index{
    
    if(index == 0){
        NSLog(@"---------点击f收藏-------");
        CollectionContentModel *contentModel = [[CollectionContentModel alloc] init];
        contentModel.noodleId = [GlobalData sharedInstance].loginDataModel.noodleId;//当前登录者面条号
        contentModel.noodleVideoId = self.currentCell.listModel.noodleVideoId; //视频Id
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
