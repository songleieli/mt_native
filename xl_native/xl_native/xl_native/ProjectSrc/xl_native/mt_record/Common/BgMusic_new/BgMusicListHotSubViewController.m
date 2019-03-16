//
//  GKDouyinHomeSearchViewController.m
//  GKNavigationBarViewControllerDemo
//
//  Created by songlei on 2018/9/11.
//  Copyright © 2018年 gaokun. All rights reserved.
//

#import "BgMusicListHotSubViewController.h"

#import "NetWork_mt_getMusicList.h"

@interface BgMusicListHotSubViewController ()

@end

@implementation BgMusicListHotSubViewController

-(void)dealloc{
    NSLog(@"---------------%@ dealloc ",NSStringFromClass([self class]));
}

-(void)initNavTitle{
    self.isNavBackGroundHiden  = YES;
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    if(self.player){ //页面消失的时候释放播放器
        [self.player pause];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
        self.player = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.bgmHelper = [MusicDownloadHelper sharedInstance];
    self.bgmPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/bgm"];

    
    [self setUpUI];
}

-(void)setUpUI{
    self.view.backgroundColor = ColorThemeBackground;
    
    [self.view addSubview:self.mainTableView];
    CGFloat hyPageHeight = 44.0f;
    
    NSInteger tableViewHeight = ScreenHeight - kNavBarHeight_New - hyPageHeight;
    self.mainTableView.size = [UIView getSize_width:ScreenWidth height:tableViewHeight];
    self.mainTableView.origin = [UIView getPoint_x:0 y:0];
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.backgroundColor = [UIColor clearColor]; //RGBFromColor(0xecedf1);
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.mainTableView registerClass:MusicHotSubMusicCell.class forCellReuseIdentifier:[MusicHotSubMusicCell cellId]];
    [self.mainTableView.mj_header beginRefreshing];
}

#pragma mark - --------- 数据加载代理 ------------
-(void)loadNewData{
    self.currentPageIndex = 0;
    [self initRequest];
}

-(void)loadMoreData{
    [self initRequest];
}

#pragma mark ------- 加载网络请求 -------

-(void)initRequest{
    
    NetWork_mt_getMusicList *request = [[NetWork_mt_getMusicList alloc] init];
    request.currentNoodleId = [GlobalData sharedInstance].loginDataModel.noodleId;
    request.pageNo = [NSString stringWithFormat:@"%d",self.currentPageIndex=self.currentPageIndex+1];
    request.pageSize = [NSString stringWithFormat:@"%d",self.currentPageSize];
    [request startGetWithBlock:^(id result, NSString *msg) {
        /*暂时不考虑缓存问题*/
    } finishBlock:^(GetMusicListResponse *result, NSString *msg, BOOL finished) {
        
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

-(void)loadData:(GetMusicListResponse *)result{
    if (self.currentPageIndex == 1 ) {
        [self.mainDataArr removeAllObjects];
    }
    
    
    for(MusicModel *musicModel in result.obj){ //给请求结果，添加本地文件路径
        
        NSString *fileName = [musicModel.playUrl pathExtension];
        if(fileName.trim.length == 0){
            fileName = @"mp3";
        }
        NSString *filePath = [self.bgmPath stringByAppendingPathComponent:musicModel.name];
        musicModel.localUrl = [NSString stringWithFormat:@"%@.%@",filePath,fileName];
//        NSLog(@"------- musicModel.localUrl=%@",musicModel.localUrl);
    }
    
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
        MusicHotSubMusicCell *cell = [tableView dequeueReusableCellWithIdentifier:[MusicHotSubMusicCell cellId] forIndexPath:indexPath];
        cell.subCellDelegate = self;
        MusicModel *model = [self.mainDataArr objectAtIndex:[indexPath row]];
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
    return  MusicHotSubMusicCellHeight;
}

#pragma mark --------------- MusicHotSubDelegate -----------------

-(void)useMusicClick:(MusicModel*)model;{
    
    if ([self.delegate respondsToSelector:@selector(subMusicClick:)]) {
        [self.delegate subMusicClick:model];
    } else {
        NSLog(@"代理没响应，快开看看吧");
    }
}


-(void)playMusic:(MusicModel*)model{
    
    
    if(self.player){
        [self.player pause];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];

        self.player = nil;
    }
    NSURL *musicUrl = [NSURL URLWithString:model.playUrl];
    AVPlayerItem * musicItem = [[AVPlayerItem alloc]initWithURL:musicUrl];
    self.player = [[AVPlayer alloc]initWithPlayerItem:musicItem];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:musicItem];
    [self.player play];
    
}

-(void)pauseMusic{
    
    [self.player pause];
    
}

#pragma mark --------------- 当播放结束后调用： -----------------

/*
 <AVAudioPlayerDelegate>
 当播放结束后调用：
 */
- (void)playbackFinished:(NSNotification *)notice {
    
    NSLog(@"----playbackFinished--");
}

#pragma mark --------------- MusicDownloadListener -----------------

/**
 每首BGM的进度回调
 */
-(void) onBGMDownloading:(MusicModel*)current percent:(float)percent{
    
}

/**
 下载结束回调，失败current返回nil
 */
-(void) onBGMDownloadDone:(MusicModel*)element{
    
}

@end
