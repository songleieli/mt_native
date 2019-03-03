//
//  ZJMessageViewController.m
//  CMPLjhMobile
//
//  Created by lei song on 2016/11/8.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "UserCollectionController.h"
#import "HoverViewFlowLayout.h"
#import "ScrollPlayerListViewController.h"

#import "UserResponse.h"
#import "AwemesResponse.h"

NSString * const kUserInfoCell_temp         = @"UserInfoCell";
NSString * const kAwemeCollectionCell_temp  = @"AwemeCollectionCell";

@interface UserCollectionController ()


@property (nonatomic, assign) CGFloat                          itemWidth;
@property (nonatomic, assign) CGFloat                          itemHeight;

@property (nonatomic, assign) NSInteger                        tabIndex;
@property (nonatomic, assign) NSInteger                        pageIndex;
@property (nonatomic, assign) NSInteger                        pageSize;

@property (nonatomic, strong) NSMutableArray          *workAwemes;
@property (nonatomic, strong) NSMutableArray          *dynamicAwemes;
@property (nonatomic, strong) NSMutableArray          *favoriteAwemes;


@end

@implementation UserCollectionController

#pragma -mark ---------- 懒加载页面元素 -------------

- (SlideTabBar *)slideTabBar{
    if (_slideTabBar == nil){
        
        _slideTabBar = [[SlideTabBar alloc] init];
        _slideTabBar.delegate = self;
        _slideTabBar.size = [UIView getSize_width:ScreenWidth height:kSlideTabBarHeight];
        _slideTabBar.top = self.navBackGround.height;
        _slideTabBar.left = 0;
        [_slideTabBar setLabels:@[@"视频",@"话题",@"音乐"] tabIndex:0];
    }
    return _slideTabBar;
}

-(NSMutableArray*)workAwemes{
    if(!_workAwemes){
        _workAwemes = [[NSMutableArray alloc] init];
    }
    return _workAwemes;
}

-(NSMutableArray*)dynamicAwemes{
    if(!_dynamicAwemes){
        _dynamicAwemes = [[NSMutableArray alloc] init];
    }
    return _dynamicAwemes;
}

-(NSMutableArray*)favoriteAwemes{
    if(!_favoriteAwemes){
        _favoriteAwemes = [[NSMutableArray alloc] init];
    }
    return _favoriteAwemes;
}


#pragma -mark ---------- Controller 生命周期 -------------


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    

    
    //test
    [self onNetworkStatusChange:nil];// 模仿抖音Demo中，的网络变化，加载数据
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
    self.lableNavTitle.textColor = [UIColor whiteColor];
    self.lableNavTitle.font = [UIFont defaultBoldFontWithSize:16];
    
    self.title = @"我的收藏";
    
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
    [self.view addSubview:self.slideTabBar];

    //根据当前屏幕宽度j计算，item 宽度
    _itemWidth = (ScreenWidth - 3) / 3.0f;
    _itemHeight = _itemWidth * 1.35f; //高度为宽度的1.35倍
    
    //SafeAreaTopHeight + kSlideTabBarHeight 为固定的高度
//    HoverViewFlowLayout *layout = [[HoverViewFlowLayout alloc] initWithTopHeight:SafeAreaTopHeight + kSlideTabBarHeight];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 1.5;     //行间距
    layout.minimumInteritemSpacing = 0;  //列间距
    
    //行间距与列间距配合 _itemWidth _itemHeight 达到布局的效果
    
    CGRect frame = CGRectMake(0, self.slideTabBar.bottom, ScreenWidth, ScreenHeight);
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
    
    // 注册cell
    [_collectionView registerClass:[AwemeCollectionCell class] forCellWithReuseIdentifier:kAwemeCollectionCell_temp];
    [self.view addSubview:_collectionView];
    
    _loadMore = [[LoadMoreControl alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50) surplusCount:15];
    [_loadMore startLoading];
    __weak __typeof(self) wself = self;
    [_loadMore setOnLoad:^{
        [wself loadData:wself.pageIndex pageSize:wself.pageSize];
    }];
    [_collectionView addSubview:_loadMore];
}

#pragma -mark ----------HTTP data request----------

-(void)loadUserData {
    
    NetWork_mt_personal_homePage *request = [[NetWork_mt_personal_homePage alloc] init];
    request.noodleId = self.userNoodleId;
    request.currentNoodleId = [GlobalData sharedInstance].loginDataModel.noodleId;
    [request startGetWithBlock:^(id result, NSString *msg) {
        
    } finishBlock:^(PersonalHomePageResponse *result, NSString *msg, BOOL finished) {
        
        if(finished){
            [self setTitle:self.user.nickname];
            self.user = result.obj;
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
        }
        else{
            [UIWindow showTips:msg];
        }
    }];
}


- (void)loadData:(NSInteger)pageIndex pageSize:(NSInteger)pageSize {
    
    
        NetWork_mt_getLikeVideoList *request = [[NetWork_mt_getLikeVideoList alloc] init];
        request.currentNoodleId = [GlobalData sharedInstance].loginDataModel.noodleId;
        request.noodleId = self.userNoodleId;
        request.pageNo = [NSString stringWithFormat:@"%ld",pageIndex];
        request.pageSize = [NSString stringWithFormat:@"%ld",pageSize];
        [request startGetWithBlock:^(id result, NSString *msg) {
            /*暂不考虑缓存*/
        } finishBlock:^(GetLikeVideoListResponse *result, NSString *msg, BOOL finished) {
            
            NSLog(@"--------");
            if(finished){
                self.pageIndex++;
                
                [UIView setAnimationsEnabled:NO];
                [self.collectionView performBatchUpdates:^{
                    [self.favoriteAwemes addObjectsFromArray:result.obj];
                    NSMutableArray<NSIndexPath *> *indexPaths = [NSMutableArray array];
                    for(NSInteger row = self.favoriteAwemes.count - result.obj.count; row<self.favoriteAwemes.count; row++) {
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
                        [indexPaths addObject:indexPath];
                    }
                    [self.collectionView insertItemsAtIndexPaths:indexPaths];
                } completion:^(BOOL finished) {
                    [UIView setAnimationsEnabled:YES];
                }];
                
                [self.loadMore endLoading];
                if(self.favoriteAwemes.count < pageSize || self.favoriteAwemes.count == 0) {
                    [self.loadMore loadingAll];
                }
            }
            else{
                [UIWindow showTips:@"获取喜欢列表失败，请检查网络"];
            }
        }];
}

#pragma -mark ------------   OnTabTapActionDelegate ---------


- (void)onTabTapAction:(NSInteger)index{
    
    NSLog(@"-------");
    
    if(index){
        
        NetWork_mt_getTopicCollections *request = [[NetWork_mt_getTopicCollections alloc] init];
        request.currentNoodleId = [GlobalData sharedInstance].loginDataModel.noodleId;
        request.pageNo = @"1";//[NSString stringWithFormat:@"%ld",self.pageIndex];
        request.pageSize = [NSString stringWithFormat:@"%ld",self.pageSize];
        [request startGetWithBlock:^(id result, NSString *msg) {
            /*暂时先不考虑缓存*/
        } finishBlock:^(GetTopicCollectionsResponse *result, NSString *msg, BOOL finished) {
            
            NSLog(@"-------");
            
        }];
        
    }
}

#pragma -mark ------------   UICollectionViewDataSource Delegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.favoriteAwemes.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AwemeCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kAwemeCollectionCell_temp forIndexPath:indexPath];
    HomeListModel *aweme= [self.favoriteAwemes objectAtIndex:indexPath.row];
    [cell initData:aweme];
    return cell;
}

//UICollectionFlowLayout Delegate
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {

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
    self.selectIndex = indexPath.row;
    
    ScrollPlayerListViewController *controller;
    controller = [[ScrollPlayerListViewController alloc] initWithVideoData:self.favoriteAwemes currentIndex:self.selectIndex];
    [self pushNewVC:controller animated:YES];
}


#pragma -mark ------------Custom Method---------

-(void)backBtnClick:(UIButton*)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

//网络状态发送变化
-(void)onNetworkStatusChange:(NSNotification *)notification {

    [self loadData:_pageIndex pageSize:_pageSize];
}




@end
