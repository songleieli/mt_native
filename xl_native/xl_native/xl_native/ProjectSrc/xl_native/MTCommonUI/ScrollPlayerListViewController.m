//
//  FirstFunctionViewController.m
//  unify_platform
//
//  Created by mac on 2018/7/7.
//  Copyright © 2018年 CMP_Ljh. All rights reserved.
//

#import "ScrollPlayerListViewController.h"

@interface ScrollPlayerListViewController ()<UserInfoPlayerDelegate>

@property (nonatomic, strong) NSMutableArray          *listData;

@end

@implementation ScrollPlayerListViewController


#pragma -mark ---------- 懒加载页面元素 -------------

-(NSMutableArray*)listData{
    if(!_listData){
        _listData = [[NSMutableArray alloc] init];
    }
    return _listData;
}

-(void)dealloc{
    
    [self.mainTableView.layer removeAllAnimations];
    NSArray<UserInfoPlayerCell *> *cells = [self.mainTableView visibleCells];
    for(UserInfoPlayerCell *cell in cells) {
        [cell.playerView cancelLoading];
    }
    [[AVPlayerManager shareManager] removeAllPlayers];
}


-(instancetype)initWithVideoData:(NSMutableArray<HomeListModel *> *)data
                    currentIndex:(NSInteger)currentIndex{
    
    self = [super init];
    if(self){
        self.mainDataArr = data;
        self.currentIndex = currentIndex;
    }
    return self;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

#pragma -mark ------ CustomMethod ----------


- (void) setBackgroundImage:(NSString *)imageName {
    UIImageView *background = [[UIImageView alloc] initWithFrame:self.view.bounds];
    background.clipsToBounds = YES;
    background.contentMode = UIViewContentModeScaleAspectFill;
    background.image = [UIImage imageNamed:imageName];
    [self.view addSubview:background];
}

-(void)setupUI{
    
    [self setBackgroundImage:@"img_video_loading"]; //cell 设置背景图
    [self.view addSubview:self.mainTableView];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.size = [UIView getSize_width:20 height:20];
    leftButton.origin = [UIView getPoint_x:15.0f y:self.navBackGround.height -leftButton.height-11];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"icon_titlebar_whiteback"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
    
    self.mainTableView.size = [UIView getSize_width:ScreenWidth height:ScreenHeight];
    self.mainTableView.origin = [UIView getPoint_x:0 y:0];
    self.mainTableView.pagingEnabled = YES;
    self.mainTableView.showsVerticalScrollIndicator = NO;
    self.mainTableView.showsHorizontalScrollIndicator = NO;
    self.mainTableView.backgroundColor = [UIColor clearColor]; //XLColorBackgroundColor;
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTableView.mj_header = nil;
    self.mainTableView.mj_footer = nil;
    
    [self.mainTableView registerClass:UserInfoPlayerCell.class forCellReuseIdentifier:[UserInfoPlayerCell cellId]];
    [self.mainTableView reloadData];
    
    /*
     滚动到指定的行，此时并没有响应 scrollViewDidEndDecelerating
     */
    NSIndexPath *curIndexPath = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
    [self.mainTableView scrollToRowAtIndexPath:curIndexPath atScrollPosition:UITableViewScrollPositionMiddle
                                  animated:NO];
    
    self.currentCell = [self.mainTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0]];
    [self playCurCellVideo];
}

-(void)playCurCellVideo{
    
    //    BOOL temp = firstLoad
    
    [_currentCell startDownloadHighPriorityTask];
    __weak typeof (UserInfoPlayerCell) *wcell = self.currentCell;
    __weak typeof (self) wself = self;
    //判断当前cell的视频源是否已经准备播放
    if(self.currentCell.isPlayerReady) {
        //播放视频
        [_currentCell replay];
        
        NSLog(@"---------[_currentCell replay];-------");
        
    }else {
        [[AVPlayerManager shareManager] pauseAll];
        //当前cell的视频源还未准备好播放，则实现cell的OnPlayerReady Block 用于等待视频准备好后通知播放
        self.currentCell.onPlayerReady = ^{
            NSIndexPath *indexPath = [wself.mainTableView indexPathForCell:wcell];
            if(indexPath && indexPath.row == wself.currentIndex) {
                [wcell play];
            }
        };
    }
}

- (void) dismiss {
//    [self dismissViewControllerAnimated:YES completion:^{
//        //播放列表消失后，显示状态栏
//        [UIApplication sharedApplication].statusBarHidden = NO;
//    }];
    
    [self.navigationController popViewControllerAnimated:YES];

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
        UserInfoPlayerCell *cell = [tableView dequeueReusableCellWithIdentifier:[UserInfoPlayerCell cellId] forIndexPath:indexPath];
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
    
//    NSInteger offset = self.mainDataArr.count - self.currentIndex;
//    if(offset == 2){ //开始加载下一页
//        self.currentPage += 1;
//        [self initRequest];
//    }
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
}

- (void)musicCDClicked:(HomeListModel *)listModel{
    NSLog(@"----------CD----------");
    
    MusicInfoController *musicInfoController = [[MusicInfoController alloc] init];
    musicInfoController.musicId = [NSString stringWithFormat:@"%@",listModel.musicId];
    [self pushNewVC:musicInfoController animated:YES];
}

@end
