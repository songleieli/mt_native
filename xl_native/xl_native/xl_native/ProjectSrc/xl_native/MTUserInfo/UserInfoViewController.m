//
//  ZJMessageViewController.m
//  CMPLjhMobile
//
//  Created by lei song on 2016/11/8.
//  Copyright © 2016年 CMP_Ljh. All rights reserved.
//

#import "UserInfoViewController.h"
#import "HoverViewFlowLayout.h"

#import "UserResponse.h"
#import "AwemesResponse.h"

NSString * const kUserInfoCell         = @"UserInfoCell";
NSString * const kAwemeCollectionCell  = @"AwemeCollectionCell";

@interface UserInfoViewController ()


@property (nonatomic, assign) CGFloat                          itemWidth;
@property (nonatomic, assign) CGFloat                          itemHeight;

@property (nonatomic, assign) NSInteger                        tabIndex;
@property (nonatomic, assign) NSInteger                        pageIndex;
@property (nonatomic, assign) NSInteger                        pageSize;

@property (nonatomic, strong) NSMutableArray          *workAwemes;
@property (nonatomic, strong) NSMutableArray          *dynamicAwemes;
@property (nonatomic, strong) NSMutableArray          *favoriteAwemes;


@end

@implementation UserInfoViewController

#pragma -mark ---------- 懒加载页面元素 -------------

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



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    /*
     以下两行顺序不能乱，statusBarHidden的状态，会影响对刘海的判断，所以 self.tabBar.top = [self getTabbarTop]; 应该放在
     */
    [UIApplication sharedApplication].statusBarHidden = NO;
    self.tabBar.top = [self getTabbarTop];    //  重新设置tabbar的高度
    
    if(self.fromType == FromTypeHome){ //从首页过来，需要隐藏tabBar , 显示返回按钮
        self.tabBar.hidden = YES;
        self.btnLeft.hidden = NO;
    }
    else if (self.fromType == FromTypeMy){ //如果是我的页面，需要显示tabBar，隐藏返回按钮
        self.userNoodleId = [GlobalData sharedInstance].loginDataModel.noodleId;
        self.tabBar.hidden = NO;
        self.btnLeft.hidden = YES;
        self.btnLeft.backgroundColor = [UIColor redColor];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    

    
    //test
    [self onNetworkStatusChange:nil];// 模仿抖音Demo中，的网络变化，加载数据
}

- (void)viewDidLoad {
    _pageIndex = 1;
    _pageSize = 20;
    _tabIndex = 0;
    
    [super viewDidLoad];
//    [self loadUserData];
    [self setUpUI];
}

-(void)initNavTitle{
    self.isNavBackGroundHiden  = NO;
    self.lableNavTitle.textColor = [UIColor clearColor];
    self.lableNavTitle.font = [UIFont defaultBoldFontWithSize:20];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.size = [UIView getSize_width:20 height:20];
    leftButton.origin = [UIView getPoint_x:15.0f y:self.navBackGround.height -leftButton.height-11];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"icon_titlebar_whiteback"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.btnLeft = leftButton;
    self.navBackGround.backgroundColor = [UIColor clearColor]; //标注颜色，方便调试
}


-(void)setUpUI{

    //根据当前屏幕宽度j计算，item 宽度
    _itemWidth = (ScreenWidth - 3) / 3.0f;
    _itemHeight = _itemWidth * 1.35f; //高度为宽度的1.35倍
    
    //SafeAreaTopHeight + kSlideTabBarHeight 为固定的高度
    HoverViewFlowLayout *layout = [[HoverViewFlowLayout alloc] initWithTopHeight:SafeAreaTopHeight + kSlideTabBarHeight];
    layout.minimumLineSpacing = 1.5;     //行间距
    layout.minimumInteritemSpacing = 0;  //列间距
    
    //行间距与列间距配合 _itemWidth _itemHeight 达到布局的效果
    
    CGRect frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
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
    [_collectionView registerClass:[UserInfoHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kUserInfoCell];
    
    // 注册cell
    [_collectionView registerClass:[AwemeCollectionCell class] forCellWithReuseIdentifier:kAwemeCollectionCell];
    [self.view addSubview:_collectionView];
    
    [self.view bringSubviewToFront:self.navBackGround]; //将d导航栏，放到最上层。

    
    _loadMore = [[LoadMoreControl alloc] initWithFrame:CGRectMake(0, kUserInfoHeaderHeight, ScreenWidth, 50) surplusCount:15];
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
    
    if(_tabIndex == 0){
        
        NetWork_mt_getMyVideos *request = [[NetWork_mt_getMyVideos alloc] init];
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
                    [self.workAwemes addObjectsFromArray:result.obj];
                    NSMutableArray<NSIndexPath *> *indexPaths = [NSMutableArray array];
                    for(NSInteger row = self.workAwemes.count - result.obj.count; row<self.workAwemes.count; row++) {
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:1];
                        [indexPaths addObject:indexPath];
                    }
                    [self.collectionView insertItemsAtIndexPaths:indexPaths];
                } completion:^(BOOL finished) {
                    [UIView setAnimationsEnabled:YES];
                }];
                
                [self.loadMore endLoading];
                if(self.workAwemes.count < pageSize || self.workAwemes.count == 0) {
                    [self.loadMore loadingAll];
                }
            }
            else{
                [UIWindow showTips:msg];
            }
        }];

    }
    else if(_tabIndex == 1){
        
        NetWork_mt_getDynamics *request = [[NetWork_mt_getDynamics alloc] init];
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
                    [self.dynamicAwemes addObjectsFromArray:result.obj];
                    NSMutableArray<NSIndexPath *> *indexPaths = [NSMutableArray array];
                    for(NSInteger row = self.dynamicAwemes.count - result.obj.count; row<self.dynamicAwemes.count; row++) {
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:1];
                        [indexPaths addObject:indexPath];
                    }
                    [self.collectionView insertItemsAtIndexPaths:indexPaths];
                } completion:^(BOOL finished) {
                    [UIView setAnimationsEnabled:YES];
                }];
                
                [self.loadMore endLoading];
                if(self.dynamicAwemes.count < pageSize || self.dynamicAwemes.count == 0) {
                    [self.loadMore loadingAll];
                }
            }
            else{
                [UIWindow showTips:msg];
            }
        }];
        
    }
    else if(_tabIndex == 2){
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
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:1];
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
                [UIWindow showTips:msg];
            }
        }];
    }
    
}


- (void)updateNavigationTitle:(CGFloat)offsetY {
    if (kUserInfoHeaderHeight - self.navBackGround.height*2 > offsetY) {
        //[self setNavigationBarTitleColor:ColorClear];
        
        self.lableNavTitle.textColor = [UIColor clearColor];
        
    }
    if (kUserInfoHeaderHeight - self.navBackGround.height*2 < offsetY && offsetY < kUserInfoHeaderHeight - self.navBackGround.height) {
        CGFloat alphaRatio =  1.0f - (kUserInfoHeaderHeight - self.navBackGround.height - offsetY)/self.navBackGround.height;
        //[self setNavigationBarTitleColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:alphaRatio]];
        
         self.lableNavTitle.textColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:alphaRatio];
    }
    if (offsetY > kUserInfoHeaderHeight - self.navBackGround.height) {
        //[self setNavigationBarTitleColor:ColorWhite];
        self.lableNavTitle.textColor = [UIColor whiteColor];
    }
}

//

#pragma -mark ------------   UICollectionViewDataSource Delegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0 && kind == UICollectionElementKindSectionHeader) {
        UserInfoHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kUserInfoCell forIndexPath:indexPath];
        _userInfoHeader = header;
        if(_user) {
            [header initData:_user];
            header.delegate = self;
            header.slideTabBar.delegate = self;
        }
        return header;
    }
    return [UICollectionReusableView new];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(section == 1) {
        
        if(_tabIndex == 0){
            return self.workAwemes.count;
        }
        else if (_tabIndex == 1){
            return self.dynamicAwemes.count;
        }
        else{
            return self.favoriteAwemes.count;
        }
        
        //return _tabIndex == 0 ? _workAwemes.count : _favoriteAwemes.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AwemeCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kAwemeCollectionCell forIndexPath:indexPath];
    HomeListModel *aweme;
    if(_tabIndex == 0) {
        aweme = [self.workAwemes objectAtIndex:indexPath.row];
    }
    else if(_tabIndex == 1){
        aweme = [self.dynamicAwemes objectAtIndex:indexPath.row];
    }
    else {
        aweme = [self.favoriteAwemes objectAtIndex:indexPath.row];
    }
    [cell initData:aweme];
    return cell;
}

//UICollectionFlowLayout Delegate
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if(section == 0) { //设置header的size
        return CGSizeMake(ScreenWidth, kUserInfoHeaderHeight);
    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath { //
    return  CGSizeMake(_itemWidth, _itemHeight);
}

#pragma -mark ------------UIScrollViewDelegate---------

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY < 0) {
        [_userInfoHeader overScrollAction:offsetY];
    }else {
        [_userInfoHeader scrollToTopAction:offsetY];
        [self updateNavigationTitle:offsetY];
    }
}

#pragma -mark ------------Custom Method---------

-(void)backBtnClick:(UIButton*)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

//网络状态发送变化
-(void)onNetworkStatusChange:(NSNotification *)notification {
//    if(![NetworkHelper isNotReachableStatus:[NetworkHelper networkStatus]]) {
        if(_user == nil) {
            [self loadUserData];
        }
        if(self.favoriteAwemes.count == 0 && self.workAwemes.count == 0 && self.dynamicAwemes.count == 0) {
            [self loadData:_pageIndex pageSize:_pageSize];
        }
//    }
}


//UserActionTap

#pragma -mark ------------UserInfoDelegate---------
- (void)onUserActionTap:(NSInteger)tag {
    switch (tag) {
        case UserInfoHeaderAvatarTag: {
            PhotoView *photoView = [[PhotoView alloc] initWithUrl:_user.head];
            [photoView show];
            break;
        }
        case UserInfoHeaderSendTag:
            //[self.navigationController pushViewController:[[ChatListController alloc] init] animated:YES];
            break;
        case UserInfoHeaderFocusCancelTag:
        case UserInfoHeaderFocusTag:{
            if(_userInfoHeader) {
                [_userInfoHeader startFocusAnimation];
            }
            break;
        }
        case UserInfoHeaderSettingTag:{
            MenuPopView *menu = [[MenuPopView alloc] initWithTitles:@[@"清除缓存"]];
            [menu setOnAction:^(NSInteger index) {
//                [[WebCacheHelpler sharedWebCache] clearCache:^(NSString *cacheSize) {
//                    [UIWindow showTips:[NSString stringWithFormat:@"已经清除%@M缓存",cacheSize]];
//                }];
            }];
            [menu show];
            break;
        }
            break;
        case UserInfoHeaderGithubTag:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/sshiqiao/douyin-ios-objectc"]];
            break;
        default:
            break;
    }
}

#pragma -mark ------------OnTabTapDelegate---------

- (void)onTabTapAction:(NSInteger)index {
    if(_tabIndex == index){
        return;
    }
    _tabIndex = index;
    _pageIndex = 1;
    
    [UIView setAnimationsEnabled:NO];
    [self.collectionView performBatchUpdates:^{
        [self.workAwemes removeAllObjects];
        [self.dynamicAwemes removeAllObjects];
        [self.favoriteAwemes removeAllObjects];
        
        if([self.collectionView numberOfItemsInSection:1]) {
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
        }
    } completion:^(BOOL finished) {
        [UIView setAnimationsEnabled:YES];
        
        [self.loadMore reset];
        [self.loadMore startLoading];
        
        [self loadData:self.pageIndex pageSize:self.pageSize];
    }];
    
}


@end
