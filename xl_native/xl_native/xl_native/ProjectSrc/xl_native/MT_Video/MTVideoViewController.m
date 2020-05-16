//
//  FirstFunctionViewController.m
//  unify_platform
//
//  Created by mac on 2018/7/7.
//  Copyright © 2018年 CMP_Ljh. All rights reserved.
//

#import "MTVideoViewController.h"
#import <MAMapKit/MAMapKit.h>
#import "CustomAnnotationView.h"
#import  "MTChangeViewAreaViewController.h"
#import "VideoViewFlowLayout.h"
#import "VideoCollectionViewCell.h"
#import "ScrollPlayerListViewController.h"

@interface MTVideoViewController ()<UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout>


@end

@implementation MTVideoViewController

#pragma mark =========== 懒加载 ===========

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [UIApplication sharedApplication].statusBarHidden = NO;
    self.tabBar.top = [self getTabbarTop];    //  重新设置tabbar的高度
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)initNavTitle{
    self.isNavBackGroundHiden = NO;
    self.navBackGround.height = kNavBarHeight_New; //状态栏的高度
    
    self.navBackGround.backgroundColor = [UIColor whiteColor];
    
    self.title = @"六六行";
    
    self.lableNavTitle.font = [UIFont defaultBoldFontWithSize:20];
    self.lableNavTitle.textColor = [UIColor blackColor];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    leftButton.size = [UIView getSize_width:100 height:30];
    leftButton.origin = [UIView getPoint_x:15.0f y:self.navBackGround.height -leftButton.height-11];
    [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftButton setTitle:@"切换景区" forState:UIControlStateNormal];
    leftButton.backgroundColor = [UIColor blueColor];
//    [leftButton setBackgroundImage:[UIImage imageNamed:@"icon_titlebar_whiteback"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(changeViewAreaClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.btnLeft = leftButton;
    
    UILabel *line = [[UILabel alloc]init];
    line.tag = 999;
    line.size = [UIView getSize_width:self.navBackGround.width height:1];
    line.origin = [UIView getPoint_x:0 y:self.navBackGround.height-1];
    line.backgroundColor = RGBAlphaColor(238, 238, 238, 1);
    
    [self.navBackGround addSubview:line];
}

-(void)dealloc{
    /*
     *移除页面中的观察者
     */
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerForRemoteNotification];
    [self setupUI];
}

#pragma mark ------ CustomMethod  ------

/*
 *注册通知
 */
-(void)registerForRemoteNotification{
    
    
    //增加监听，用户成功切换景区
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeScenic:)
                                                 name:NSNotificationUserChangeScenic
                                               object:nil];
}

-(void)setupUI{
    
    self.view.backgroundColor = ColorThemeBackground;
    
    NSInteger count = 2; //每一行显示的个数
    //根据当前屏幕宽度j计算，item 宽度
    _itemWidth = (ScreenWidth - 3) / count;
    _itemHeight = _itemWidth * 1.35f; //高度为宽度的1.35倍
    
    VideoViewFlowLayout *layout = [[VideoViewFlowLayout alloc] initWithTopHeight:SafeAreaTopHeight + kSlideTabBarHeight];
    
    layout.minimumLineSpacing = 1.5;     //行间距
    layout.minimumInteritemSpacing = 0;  //列间距
    CGRect frame = CGRectMake(0, kNavBarHeight_New, ScreenWidth, ScreenHeight - kNavBarHeight_New - kTabBarHeight_New);;
    self.collectionView = [[UICollectionView  alloc]initWithFrame:frame collectionViewLayout:layout];
    self.collectionView.backgroundColor = ColorClear;
    
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.collectionView.alwaysBounceVertical = YES; //UIScrollView 的回弹效果
    self.collectionView.showsVerticalScrollIndicator = NO; //不显示滚动条
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[VideoCollectionViewCell class] forCellWithReuseIdentifier:[VideoCollectionViewCell registerCellID]];
    [self setRefresh]; //设置上拉加载更多和下拉刷新。ßß
    [self.view addSubview:self.collectionView];
    
    [self.collectionView.mj_header beginRefreshing];
}

-(void)changeViewAreaClick{
    
    MTChangeViewAreaViewController *changeViewAreaViewController = [[MTChangeViewAreaViewController alloc] init];
    [self pushNewVC:changeViewAreaViewController animated:YES];
}

-(void)changeScenic:(NSNotification *)notification{
    
    NSDictionary *infoDic = (NSDictionary*)notification.object;
    
    NSString *scenicId = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"scenicId"]];

    NSLog(@"");
    
    [self.collectionView.mj_header beginRefreshing];
}

#pragma mark - --------- 数据加载代理 ------------

-(void)loadNewData{
    self.currentPageIndex = 0; //刷新是显示第一页美容
    [self.mainDataArr removeAllObjects];
    
    [self initRequest];
}

-(void)loadMoreData{
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
        

        
        if(finished){
            if (self.currentPageIndex == 1 ) {
                [self.mainDataArr removeAllObjects];
                [self refreshNoDataViewWithListCount:result.obj.count];
            }
            [self.mainDataArr addObjectsFromArray:result.obj];
            
            //去掉 collectionView 加载 闪动的动画
            [UIView setAnimationsEnabled:NO];
            [self.collectionView reloadData];
            [GlobalFunc afterTime:1.0f todo:^{
                 [UIView setAnimationsEnabled:YES];
                [self.collectionView.mj_header endRefreshing];
            }];
        }
        else{
            [self.collectionView.mj_header endRefreshing];
            self.currentPageIndex=self.currentPageIndex-1;
            [UIWindow showTips:msg];
        }
    }];
}


#pragma mark --------- UICollectionView DataSource ------------


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.mainDataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HomeListModel * listModel = [self.mainDataArr objectAtIndex:[indexPath row]];
    VideoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[VideoCollectionViewCell registerCellID] forIndexPath:indexPath];
    [cell fillDataWithModel:listModel];
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
    
    HomeListModel * listModel = [self.mainDataArr objectAtIndex:[indexPath row]];

    
    ScrollPlayerListViewController *playerListViewController = [[ScrollPlayerListViewController alloc] initWithVideoData:self.mainDataArr currentIndex:indexPath.row];
    [self pushNewVC:playerListViewController animated:YES];
}


@end
