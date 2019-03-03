//
//  FirstFunctionViewController.m
//  unify_platform
//
//  Created by mac on 2018/7/7.
//  Copyright © 2018年 CMP_Ljh. All rights reserved.
//

#import "MTFollowViewController.h"

@interface MTFollowViewController ()

@property (copy, nonatomic) NSString *myCallBack;

@end

@implementation MTFollowViewController

#pragma mark =========== 懒加载 ===========

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [UIApplication sharedApplication].statusBarHidden = NO;
    self.tabBar.top = [self getTabbarTop];    //  重新设置tabbar的高度
    
//    [self.mainDataArr removeAllObjects]; //加载页面内容时，先清除老数据
//    [self initRequest];
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
    
    self.isFirstLoad = YES;
    
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
    [self.mainTableView registerClass:FollowsVideoListCell.class forCellReuseIdentifier:[FollowsVideoListCell cellId]];
    
    [self.mainTableView.mj_header beginRefreshing];
}

//预先计算cell的g高度
-(void)countCellHeight:(NSArray *)modelList{
    
    for(HomeListModel *homeListModel in modelList){
        
        CGRect contentLabelSize = [homeListModel.title boundingRectWithSize:CGSizeMake(FollowsVideoListCellTitleWidth, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:FollowsVideoListCellTitleFont,NSFontAttributeName, nil] context:nil];
        
        CGFloat cellHeight = FollowsVideoListCellIconHeight + contentLabelSize.size.height + FollowsVideoListCellVideoHeight+FollowsVideoListCellBottomHeight+FollowsVideoListCellSpace*2;

        
        homeListModel.fpllowVideoListTitleHeight = contentLabelSize.size.height;
        homeListModel.fpllowVideoListCellHeight = cellHeight;
    }
}

-(void)playCurCellVideo{
    
    //    BOOL temp = firstLoad
    
    [_currentCell startDownloadHighPriorityTask];
    __weak typeof (FollowsVideoListCell) *wcell = self.currentCell;
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

-(void)loadVideoData:(GetFollowsVideoListResponse *)result{
    if (self.currentPageIndex == 0 ) {
        [self.mainDataArr removeAllObjects];
        [self refreshNoDataViewWithListCount:result.obj.count];
    }
    [self countCellHeight:result.obj]; //计算cell的高度
    [self.mainDataArr addObjectsFromArray:result.obj];
    [self.mainTableView reloadData];
    
    if(self.isFirstLoad){//第一次加载
        self.isFirstLoad = NO;
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
        self.currentCell = [self.mainTableView cellForRowAtIndexPath:indexPath];
        [self playCurCellVideo];
    }
}


#pragma mark ------ initRequest  ------

-(void)initRequest{
    
    NetWork_mt_getFollowsVideoList *request = [[NetWork_mt_getFollowsVideoList alloc] init];
    request.currentNoodleId = [GlobalData sharedInstance].loginDataModel.noodleId;
    request.pageNo = [NSString stringWithFormat:@"%ld",self.currentPageIndex=self.currentPageIndex+1];
    request.pageSize = [NSString stringWithFormat:@"%ld",self.currentPageSize];
    [request startGetWithBlock:^(id result, NSString *msg) {
        /*
         *暂不考虑缓存问题
         */
    } finishBlock:^(GetFollowsVideoListResponse *result, NSString *msg, BOOL finished) {
        NSLog(@"----------------");
        
        [self.mainTableView.mj_header endRefreshing];
        if(finished){
            [self loadVideoData:result];
        }
    }];
    
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

#pragma mark --------------- GetFollowsDelegate -----------------

- (void)zanClicked:(HomeListModel *)listModel{
    
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
    SharePopView *popView = [[SharePopView alloc] init];
    popView.delegate = self;
    [popView show];
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
        cell.followDelegate = self;
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
    
    HomeListModel *model = [self.mainDataArr objectAtIndex:[indexPath row]];

    return  model.fpllowVideoListCellHeight;
}

#pragma mark --------------- UIScrollView 代理 -----------------
//scrollViewDidEndDecelerating方法不执行解决方案
//https://blog.csdn.net/abc649395594/article/details/46780065/

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(!decelerate){
        //这里复制scrollViewDidEndDecelerating里的代码
        //NSLog(@"------------------停止滚动-1---强制滚动停止--------------");
        [self dealStopScroll:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //NSLog(@"------------------停止滚动----2---慢慢滑动停止-----------");
    [self dealStopScroll:scrollView];
}

/*
 *处理滚动停止后的方法
 */
-(void)dealStopScroll:(UIScrollView*)scrollView{
    
    /*
     *1.暂时采用一下方式
     *2.循环数组使y值减去cell每一行的高度，对应的i值即为index的值
     *3.后续持续对该算法进行优化。
     */
    CGPoint rect = scrollView.contentOffset;
    CGFloat y = rect.y;
    //    NSLog(@"-------y = %f------------",rect.y);
    NSInteger index = 0;
    for(int i=0;i<self.mainDataArr.count;i++){
        
        HomeListModel *model = [self.mainDataArr objectAtIndex:i];
        //        NSLog(@"-------fpllowVideoListCellHeight = %f------------",model.fpllowVideoListCellHeight);
        y = y-model.fpllowVideoListCellHeight;
        //        NSLog(@"-------y = %f------------",y);
        if(y <= 0.0f){
            index = i;
            NSLog(@"--------------------------index---- = %ld------------",index);
            break;
        }
    }
    
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



@end
