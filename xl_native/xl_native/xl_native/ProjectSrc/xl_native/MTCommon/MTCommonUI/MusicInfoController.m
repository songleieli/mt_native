//
//  ZJMessageViewController.m
//  CMPLjhMobile
//
//  Created by lei song on 2016/11/8.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "MusicInfoController.h"

NSString * const kAwemeCollectionMusicCell  = @"AwemeCollectionCell";
NSString * const kMyMusicHeaderView         = @"kMyTopicHeaderView";

@interface MusicInfoController ()

@property (nonatomic, assign) CGFloat                          itemWidth;
@property (nonatomic, assign) CGFloat                          itemHeight;
@property (nonatomic, assign) NSInteger                        tabIndex;
@property (nonatomic, strong) NSMutableArray          *favoriteAwemes;

@property (nonatomic, strong) UIButton          *btnPTK;


@end

@implementation MusicInfoController

#pragma -mark ---------- 懒加载页面元素 -------------

-(UIButton*)btnPTK{
    if(!_btnPTK){
        _btnPTK = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnPTK.size = [UIView getSize_width:70 height:70];
        _btnPTK.bottom = ScreenHeight - 50;
        _btnPTK.centerX = ScreenWidth/2;
        [_btnPTK setBackgroundImage:[UIImage imageNamed:@"videoex"] forState:UIControlStateNormal];
        [_btnPTK setBackgroundImage:[UIImage imageNamed:@"videoex_press"] forState:UIControlStateHighlighted];
        [_btnPTK addTarget:self action:@selector(btnPTKClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnPTK;
}

-(NSMutableArray*)favoriteAwemes{
    if(!_favoriteAwemes){
        _favoriteAwemes = [[NSMutableArray alloc] init];
    }
    return _favoriteAwemes;
}


#pragma -mark ---------- Controller 生命周期 -------------

-(void)dealloc{
    NSLog(@"-------MusicInfoController--dealloc-----");
    if(self.topicHeader){
        [self.topicHeader destroyPlayer];
        self.topicHeader = nil;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //test
    [self onNetworkStatusChange:nil];// 模仿抖音Demo中，的网络变化，加载数据
    
    [UIApplication sharedApplication].statusBarHidden = NO;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    _tabIndex = 0;
    
    [super viewDidLoad];
    [self setUpUI];
}

-(void)initNavTitle{
    self.isNavBackGroundHiden  = NO;
    self.lableNavTitle.textColor = ColorWhite;
    self.lableNavTitle.font = BigBoldFont; //[UIFont defaultBoldFontWithSize:16];
    
    self.title = @"音乐详情";
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.size = [UIView getSize_width:20 height:20];
    leftButton.origin = [UIView getPoint_x:15.0f y:self.navBackGround.height -leftButton.height-11];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"icon_titlebar_whiteback"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.btnLeft = leftButton;
    self.navBackGround.backgroundColor = [UIColor clearColor]; //标注颜色，方便调试
}


-(void)setUpUI{
    
    self.view.backgroundColor = ColorThemeBackground;
    
    //根据当前屏幕宽度j计算，item 宽度
    _itemWidth = (ScreenWidth - 3) / 3.0f;
    _itemHeight = _itemWidth * 1.35f; //高度为宽度的1.35倍
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 1.5;     //行间距
    layout.minimumInteritemSpacing = 0;  //列间距
    
    //行间距与列间距配合 _itemWidth _itemHeight 达到布局的效果
    CGRect frame = CGRectMake(0, kNavBarHeight_New, ScreenWidth, ScreenHeight - kNavBarHeight_New);
    _collectionView = [[UICollectionView  alloc]initWithFrame:frame collectionViewLayout:layout];
    _collectionView.backgroundColor = ColorClear;
    
    if (@available(iOS 11.0, *)) {
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    _collectionView.alwaysBounceVertical = YES; //UIScrollView 的回弹效果
    _collectionView.showsVerticalScrollIndicator = NO; //不显示滚动条
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    // 注册区头
    [_collectionView registerClass:[MyMusicHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kMyMusicHeaderView];
    // 注册cell
    [_collectionView registerClass:[AwemeCollectionCell class] forCellWithReuseIdentifier:kAwemeCollectionMusicCell];
    
    [self.view addSubview:_collectionView];
    
    _loadMore = [[LoadMoreControl alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50) surplusCount:15];
    [_loadMore startLoading];
    __weak __typeof(self) wself = self;
    [_loadMore setOnLoad:^{
        [wself loadData];
    }];
    [_collectionView addSubview:_loadMore];
    
    [self.view addSubview:self.btnPTK];
}

#pragma -mark ----------HTTP data request----------

- (void)loadData{
    
    NetWork_mt_getHotVideosByMusic *request = [[NetWork_mt_getHotVideosByMusic alloc] init];
    request.currentNoodleId = [GlobalData sharedInstance].loginDataModel.noodleId;
    request.musicId = [NSString stringWithFormat:@"%@",self.musicId];
    request.pageNo = [NSString stringWithFormat:@"%d",self.currentPageIndex=self.currentPageIndex+1];
    request.pageSize = [NSString stringWithFormat:@"%d",self.currentPageSize];
    [request startGetWithBlock:^(GetHotVideosByMusicResponse *result, NSString *msg, BOOL finished) {
        
        if(finished){
            self.musicModel = result.obj.music;
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]]; //加载 head Data
            
            [UIView setAnimationsEnabled:NO];
            [self.collectionView performBatchUpdates:^{
                [self.favoriteAwemes addObjectsFromArray:result.obj.videoList];
                NSMutableArray<NSIndexPath *> *indexPaths = [NSMutableArray array];
                for(NSInteger row = self.favoriteAwemes.count - result.obj.videoList.count; row<self.favoriteAwemes.count; row++) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
                    [indexPaths addObject:indexPath];
                }
                [self.collectionView insertItemsAtIndexPaths:indexPaths];
            } completion:^(BOOL finished) {
                [UIView setAnimationsEnabled:YES];
            }];
            
            [self.loadMore endLoading];
            if(self.favoriteAwemes.count < self.currentPageSize || result.obj.videoList.count == 0) {
                [self.loadMore loadingAll];
            }
        }
        else{
            [UIWindow showTips:@"获取喜欢列表失败，请检查网络"];
        }
    }];
}

#pragma -mark ------------   UICollectionViewDataSource Delegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0 && kind == UICollectionElementKindSectionHeader) {
        MyMusicHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kMyMusicHeaderView forIndexPath:indexPath];
        _topicHeader = header;
        if(_musicModel) {
            [header initData:_musicModel];
            header.delegate = self;
        }
        return header;
    }
    return [UICollectionReusableView new];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.favoriteAwemes.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AwemeCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kAwemeCollectionMusicCell forIndexPath:indexPath];
    HomeListModel *aweme= [self.favoriteAwemes objectAtIndex:indexPath.row];
    [cell initData:aweme];
    return cell;
}

//UICollectionFlowLayout Delegate
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if(section == 0) { //设置header的size
        return CGSizeMake(ScreenWidth, 150);
    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath { //
    return  CGSizeMake(_itemWidth, _itemHeight);
}

//UICollectionViewDelegate Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if(self.topicHeader){//如果topicHeader正在播放音乐，暂停
        [self.topicHeader pauseMusic];
    }
    
    self.selectIndex = indexPath.row;
    
    ScrollPlayerListViewController *controller;
    controller = [[ScrollPlayerListViewController alloc] initWithVideoData:self.favoriteAwemes currentIndex:self.selectIndex];
    [self pushNewVC:controller animated:YES];
}


#pragma -mark ------------ TopicHeadDelegate ---------

-(void)btnCollectionClick:(GetHotVideosByMusicModel*)model{
    
    /*
     "noodleId": "136728830",
     "musicId":"343243",
     "musicName":"324232342",
     "coverUrl": "/miantiao/musiccover/20181201/16341217658933248.jpg",
     "playUrl": "/miantiao/music/20181201/16341217658933248.mp3",
     "musicNoodleId":"54353",
     "nickname":"张三"
     */
    
    
    [[ZJLoginService sharedInstance] authenticateWithCompletion:^(BOOL success) {
        
        if([model.isCollect integerValue] == 0){ //没有收藏，收藏
            
            CollectionMusicContentModel *contentModel = [[CollectionMusicContentModel alloc] init];
            contentModel.noodleId = [GlobalData sharedInstance].loginDataModel.noodleId;
            contentModel.musicId = [NSString stringWithFormat:@"%@",model.musicId];
            contentModel.musicName = model.musicName;
            contentModel.coverUrl = model.coverUrl;
            contentModel.playUrl = model.playUrl;
            contentModel.musicNoodleId = model.noodleId;
            contentModel.nickname = model.nickname;
            
            NetWork_mt_collectionMusic *request = [[NetWork_mt_collectionMusic alloc] init];
            request.currentNoodleId = [GlobalData sharedInstance].loginDataModel.noodleId;
            request.content = [contentModel generateJsonStringForProperties];
            [request startPostWithBlock:^(CollectionMusicResponse *result, NSString *msg, BOOL finished) {
                [UIWindow showTips:msg];
                if(finished){
                    model.isCollect = result.obj;
                    [self.topicHeader initData:model];
                }
            }];
        }
        else{ //已收藏，取消收藏
            NetWork_mt_deleteCollection *request = [[NetWork_mt_deleteCollection alloc] init];
            request.currentNoodleId = [GlobalData sharedInstance].loginDataModel.noodleId;
            request.id = [NSString stringWithFormat:@"%@",model.isCollect];
            [request startPostWithBlock:^(id result, NSString *msg, BOOL finished) {
                
                [UIWindow showTips:msg];
                if(finished){
                    model.isCollect = [NSNumber numberWithInt:0];
                    [self.topicHeader initData:model];
                }
            }];
        }
        
        
    } cancelBlock:^{
        NSLog(@"--------取消登录---------");
    } isAnimat:YES];
}

-(void)btnAuthorClick:(GetHotVideosByMusicModel*)model{
    
    UserInfoViewController *userInfoViewController = [[UserInfoViewController alloc] init];
    userInfoViewController.userNoodleId = model.noodleId;
    userInfoViewController.fromType = FromTypeHome; //我的页面，需要显示返回按钮，隐藏TabBar
    [self pushNewVC:userInfoViewController animated:YES];
}

#pragma -mark ------------Custom Method---------

-(void)btnPTKClick:(UIButton*)btn{//点击拍同款按钮
    [[ZJLoginService sharedInstance] authenticateWithCompletion:^(BOOL success) {
        
        NSString *fileName = [self.musicModel.playUrl pathExtension];
        if(fileName.trim.length == 0){
            fileName = @"mp3";
        }
        NSString *bgmPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/bgm"];

        NSString *filePath = [bgmPath stringByAppendingPathComponent:self.musicModel.musicName];
        NSString *localUrl = [NSString stringWithFormat:@"%@.%@",filePath,fileName];
        
        if([GlobalFunc isFileExist:localUrl]){
            
            [self gotoRecourd:localUrl];
        }
        else{
            
            [FileHelper downloadFile:localUrl playUrl:self.musicModel.playUrl processBlock:^(float percent) {
                [GlobalFunc showHud:[NSString stringWithFormat:@"正在加载音乐%d %%",(int)(percent * 100)]];
            } completionBlock:^(BOOL result, NSString *msg) {
                [GlobalFunc hideHUD:1.0f];
                if(result){
                    [self gotoRecourd:localUrl];
                }
                else{
                    [UIWindow showTips:msg];
                }
            }];
        }
    } cancelBlock:nil isAnimat:YES];
}

-(void)gotoRecourd:(NSString*)localUrl{
    
    TCVideoRecordViewController *videoRecord = [[TCVideoRecordViewController alloc] initWithNibName:nil bundle:nil];
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:videoRecord];
    
    __weak typeof(self) weakSelf = self;
    
    [self presentViewController:nav animated:YES completion:^{
        //页面加载完成，调用选择背景音乐，
//        videoRecord
        MusicSearchModel *musicSearchModel = [[MusicSearchModel alloc] init];
        musicSearchModel.musicId = weakSelf.musicModel.musicId;
        musicSearchModel.musicName = weakSelf.musicModel.musicName;
        musicSearchModel.coverUrl = weakSelf.musicModel.coverUrl;
        musicSearchModel.playUrl = weakSelf.musicModel.playUrl;
        musicSearchModel.localUrl = localUrl;
        
        [videoRecord useHotMusicClick:musicSearchModel];
        
    }];
}

-(void)backBtnClick:(UIButton*)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

//网络状态发送变化
-(void)onNetworkStatusChange:(NSNotification *)notification {
    [self loadData];
}

@end
