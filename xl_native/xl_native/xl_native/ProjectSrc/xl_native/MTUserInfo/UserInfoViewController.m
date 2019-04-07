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

#import "MTMyFansViewController.h"
#import "MTMyFollowViewController.h"

NSString * const kUserInfoCell         = @"UserInfoCell";
NSString * const kAwemeCollectionCell  = @"AwemeCollectionCell";

@interface UserInfoViewController ()


@property (nonatomic, assign) CGFloat                          itemWidth;
@property (nonatomic, assign) CGFloat                          itemHeight;

@property (nonatomic, assign) NSInteger                        tabIndex;

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


#pragma -mark ---------- Controller 生命周期 -------------


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
    [self onLoadUserData];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
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
}

-(void)dealloc{
    /*
     *移除页面中的观察者
     */
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    _tabIndex = 0;

    [self registerForRemoteNotification];
    
    [super viewDidLoad];
    [self setUpUI];
    [self registerForRemoteNotification];
}

#pragma -mark ----------Custom Method----------

-(void)setUpUI{
    
    self.view.backgroundColor = ColorThemeBackground;
    
    //根据当前屏幕宽度j计算，item 宽度
    _itemWidth = (ScreenWidth - 3) / 3.0f;
    _itemHeight = _itemWidth * 1.35f; //高度为宽度的1.35倍
    
    //SafeAreaTopHeight + kSlideTabBarHeight 为固定的高度
    HoverViewFlowLayout *layout = [[HoverViewFlowLayout alloc] initWithTopHeight:SafeAreaTopHeight + kSlideTabBarHeight];
    layout.minimumLineSpacing = 1.5;     //行间距
    layout.minimumInteritemSpacing = 0;  //列间距
    
    CGRect frame = CGRectZero;
    if(self.fromType == FromTypeMy){
        frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight  - kTabBarHeight_New);
    }
    else{
        frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    }
    
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
    
    [self.view bringSubviewToFront:self.navBackGround]; //将导航栏，放到最上层。
    
    
    _loadMore = [[LoadMoreControl alloc] initWithFrame:CGRectMake(0, kUserInfoHeaderHeight, ScreenWidth, 50) surplusCount:15];
    [_loadMore startLoading];
    __weak __typeof(self) wself = self;
    [_loadMore setOnLoad:^{
        [wself loadData];
    }];
    [_collectionView addSubview:_loadMore];
}

-(void)registerForRemoteNotification{
    
    //增加监听，用户登录成功
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userLoginSuccess:)
                                                 name:NSNotificationUserLoginSuccess
                                               object:nil];
}

- (void)userLoginSuccess:(NSNotification *)notification{
    
    [self startUserRequest];
    [self loadData];
}

//网络状态发送变化
-(void)onLoadUserData{
    
    if(_user == nil) {
        [self startUserRequest];
    }
    if(self.workAwemes.count == 0 && self.dynamicAwemes.count == 0 && self.favoriteAwemes.count == 0){
        [self loadData];
    }
}


#pragma -mark ----------HTTP data request----------


-(void)startUserRequest {
    
    NetWork_mt_personal_homePage *request = [[NetWork_mt_personal_homePage alloc] init];
    request.noodleId = self.userNoodleId;
    request.currentNoodleId = [GlobalData sharedInstance].loginDataModel.noodleId;
    [request startGetWithBlock:^(id result, NSString *msg) {
        
    } finishBlock:^(PersonalHomePageResponse *result, NSString *msg, BOOL finished) {
        
        if(finished){
            //            [self setTitle:self.user.nickname];
            self.user = result.obj;
            self.lableNavTitle.text = self.user.nickname;
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
        }
        else{
            [UIWindow showTips:@"用户信息获取失败，请检查网络。"];
        }
    }];
}


- (void)loadData{
    
    if(_tabIndex == 0){
        
        NetWork_mt_getMyVideos *request = [[NetWork_mt_getMyVideos alloc] init];
        request.currentNoodleId = [GlobalData sharedInstance].loginDataModel.noodleId;
        request.noodleId = self.userNoodleId;
        request.pageNo = [NSString stringWithFormat:@"%d",self.currentPageIndex=self.currentPageIndex+1];
        request.pageSize = [NSString stringWithFormat:@"%d",self.currentPageSize];
        [request startGetWithBlock:^(id result, NSString *msg) {
            /*暂不考虑缓存*/
        } finishBlock:^(GetLikeVideoListResponse *result, NSString *msg, BOOL finished) {
            
            NSLog(@"--------");
            if(finished){
                
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
                if(self.workAwemes.count < self.currentPageSize || result.obj.count == 0) {
                    [self.loadMore loadingAll];
                }
            }
            else{
                [UIWindow showTips:@"获取作品列表失败，请检查网络"];
            }
        }];
        
    }
    else if(_tabIndex == 1){
        
        NetWork_mt_getDynamics *request = [[NetWork_mt_getDynamics alloc] init];
        request.currentNoodleId = [GlobalData sharedInstance].loginDataModel.noodleId;
        request.noodleId = self.userNoodleId;
        request.pageNo = [NSString stringWithFormat:@"%d",self.currentPageIndex=self.currentPageIndex+1];
        request.pageSize = [NSString stringWithFormat:@"%d",self.currentPageSize];
        [request startGetWithBlock:^(id result, NSString *msg) {
            /*暂不考虑缓存*/
        } finishBlock:^(GetLikeVideoListResponse *result, NSString *msg, BOOL finished) {
            
            NSLog(@"--------");
            if(finished){
                
//                [UIView setAnimationsEnabled:NO];
//                [self.collectionView performBatchUpdates:^{
//                    [self.dynamicAwemes addObjectsFromArray:result.obj];
//                    NSMutableArray<NSIndexPath *> *indexPaths = [NSMutableArray array];
//                    for(NSInteger row = self.dynamicAwemes.count - result.obj.count; row<self.dynamicAwemes.count; row++) {
//                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:1];
//                        [indexPaths addObject:indexPath];
//                    }
//                    [self.collectionView insertItemsAtIndexPaths:indexPaths];
//
//                } completion:^(BOOL finished) {
//                    [UIView setAnimationsEnabled:YES];
//                }];
                
                [self.dynamicAwemes addObjectsFromArray:result.obj];
                NSMutableArray<NSIndexPath *> *indexPaths = [NSMutableArray array];
                for(NSInteger row = self.dynamicAwemes.count - result.obj.count; row<self.dynamicAwemes.count; row++) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:1];
                    [indexPaths addObject:indexPath];
                }
                [self.collectionView insertItemsAtIndexPaths:indexPaths];
                
                [self.loadMore endLoading];
                if(self.dynamicAwemes.count < self.currentPageSize || result.obj.count == 0) {
                    [self.loadMore loadingAll];
                }
            }
            else{
                [UIWindow showTips:@"获取动态列表失败，请检查网络"];
            }
        }];
        
    }
    else if(_tabIndex == 2){
        
        
        NetWork_mt_getLikeVideoList *request = [[NetWork_mt_getLikeVideoList alloc] init];
        request.currentNoodleId = [GlobalData sharedInstance].loginDataModel.noodleId;
        request.noodleId = self.userNoodleId;
        request.pageNo = [NSString stringWithFormat:@"%d",self.currentPageIndex=self.currentPageIndex+1];
        request.pageSize = [NSString stringWithFormat:@"%d",self.currentPageSize];
        [request startGetWithBlock:^(id result, NSString *msg) {
            /*暂不考虑缓存*/
        } finishBlock:^(GetLikeVideoListResponse *result, NSString *msg, BOOL finished) {
            
            if(finished){
                
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
                if(self.favoriteAwemes.count < self.currentPageSize || result.obj.count == 0) {
                    [self.loadMore loadingAll];
                }
            }
            else{
                [UIWindow showTips:@"获取喜欢列表失败，请检查网络"];
            }
        }];
    }
    
}


- (void)updateNavigationTitle:(CGFloat)offsetY {
    
    if (kUserInfoHeaderHeight - self.navBackGround.height*2 > offsetY) {
        self.lableNavTitle.textColor = [UIColor clearColor];
    }
    if (kUserInfoHeaderHeight - self.navBackGround.height*2 < offsetY && offsetY < kUserInfoHeaderHeight - self.navBackGround.height) {
        CGFloat alphaRatio =  1.0f - (kUserInfoHeaderHeight - self.navBackGround.height - offsetY)/self.navBackGround.height;
        self.lableNavTitle.textColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:alphaRatio];
    }
    if (offsetY > kUserInfoHeaderHeight - self.navBackGround.height) {
        self.lableNavTitle.textColor = [UIColor whiteColor];
    }
}

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

//UICollectionViewDelegate Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectIndex = indexPath.row;
    
    ScrollPlayerListViewController *playerListViewController;
    if(_tabIndex == 0){ //我的作品
        playerListViewController = [[ScrollPlayerListViewController alloc] initWithVideoData:self.workAwemes currentIndex:self.selectIndex];
    }
    else if (_tabIndex == 1){ //动态
        playerListViewController = [[ScrollPlayerListViewController alloc] initWithVideoData:self.dynamicAwemes currentIndex:self.selectIndex];
        
    }
    else{//喜欢
        playerListViewController = [[ScrollPlayerListViewController alloc] initWithVideoData:self.favoriteAwemes currentIndex:self.selectIndex];
        
    }
    [self pushNewVC:playerListViewController animated:YES];
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


//UserActionTap

#pragma -mark ------------UserInfoDelegate---------
- (void)onUserActionTap:(NSInteger)tag {
    
    if(tag == UserInfoHeaderAvatarTag){ //点击头像
        
        PhotoView *photoView = [[PhotoView alloc] initWithUrl:_user.head];
        [photoView show];
    }
    else if (tag == UserInfoHeaderSendTag){//点击发送消息
        
        if([self.user.noodleId isEqualToString:[GlobalData sharedInstance].loginDataModel.noodleId]){
            NSLog(@"------查看收藏列表-----");
            UserCollectionController *collectionController = [[UserCollectionController alloc] init];
            [self pushNewVC:collectionController animated:YES];
        }
        else{
            NSLog(@"------发送消息-----");
        }
        
    }
    else if (tag == UserInfoHeaderFocusCancelTag){//取消关注
        
        
        if([self.user.noodleId isEqualToString:[GlobalData sharedInstance].loginDataModel.noodleId]){
            //如果是自己就查看我的联系人
            NSLog(@"------查看联系人-----");
            
        }
        else{//如果是别人，取消关注
            
            //调用取消关注接口，关注成功后，startFocusAnimation
            DelFlourContentModel *contentModel = [[DelFlourContentModel alloc] init];
            contentModel.flourId = [GlobalData sharedInstance].loginDataModel.noodleId;
            contentModel.noodleId = self.user.noodleId;
            
            NetWork_mt_delflour *request = [[NetWork_mt_delflour alloc] init];
            request.currentNoodleId = [GlobalData sharedInstance].loginDataModel.noodleId;
            request.content = [contentModel generateJsonStringForProperties];
            [request startPostWithBlock:^(id result, NSString *msg, BOOL finished) {
                
                if(finished){
                    if(_userInfoHeader) {
                        [_userInfoHeader startFocusAnimation];
                    }
                }
                else{
                    [UIWindow showTips:@"取消关注失败，请检查网络"];
                }
            }];
            contentModel = nil;
            
        }
        
        
    }
    else if (tag == UserInfoHeaderFocusTag){//点击关注
        
        //调用关注接口，关注成功后，startFocusAnimation
        SaveflourContentModel *contentModel = [[SaveflourContentModel alloc] init];
        contentModel.flourId = [GlobalData sharedInstance].loginDataModel.noodleId;
        contentModel.noodleId = self.user.noodleId;
        contentModel.flourHead = [GlobalData sharedInstance].loginDataModel.head;
        contentModel.flourNickname = [GlobalData sharedInstance].loginDataModel.nickname;
        contentModel.flourSignature = [GlobalData sharedInstance].loginDataModel.signature;
        contentModel.noodleHead = self.user.head;
        contentModel.noodleNickname = self.user.nickname;
        contentModel.noodleSignature = self.user.signature;
        
        NetWork_mt_saveflour *request = [[NetWork_mt_saveflour alloc] init];
        request.currentNoodleId = [GlobalData sharedInstance].loginDataModel.noodleId;
        request.content = [contentModel generateJsonStringForProperties];
        [request startPostWithBlock:^(id result, NSString *msg, BOOL finished) {
            
            if(finished){
                if(_userInfoHeader) {
                    [_userInfoHeader startFocusAnimation];
                }
            }
            else{
                [UIWindow showTips:@"关注失败，请检查网络"];
            }
        }];
        contentModel = nil;
    }
    else if (tag == UserInfoHeaderSettingTag){//点击设置
        
        //如果是当前用户，进入个人设置
        if([self.userNoodleId isEqualToString:[GlobalData sharedInstance].loginDataModel.noodleId]){
            
            MySettingViewController *mySettingViewController = [[MySettingViewController alloc] init];
            [self pushNewVC:mySettingViewController animated:YES];
        }
        else{ //进入用户设置页面
            UserSettingViewController *userSettingViewController = [[UserSettingViewController alloc] init];
            userSettingViewController.user = self.user;
            [self pushNewVC:userSettingViewController animated:YES];
        }
    }
    
    
    return;
}

- (void)onZanActionTap:(PersonalModel*)user{    //点击赞
    
    NSString *msg = [NSString stringWithFormat:@"\"%@\" 共获得%@个赞",user.nickname,user.likeTotal];
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)onFollowActionTap:(PersonalModel*)user{//点击关注
    
    if([user.followSum integerValue] <=0){
        
        NSString *msg = [NSString stringWithFormat:@"\"%@\" 没有关注用户",user.nickname];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        [alert show];
    }
    else{//跳转到关注用户页面
        MTMyFollowViewController *myFollowViewController = [[MTMyFollowViewController alloc] init];
        myFollowViewController.userNoodleId = user.noodleId;
        [self pushNewVC:myFollowViewController animated:YES];
    }
    
}

- (void)onFlourActionTap:(PersonalModel*)user{  //点击关注
    if([user.flourSum integerValue] <=0){
        
        NSString *msg = [NSString stringWithFormat:@"\"%@\" 没有面粉",user.nickname];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        [alert show];
    }
    else{//跳转到面粉页面
        
        MTMyFansViewController *myFansViewController = [[MTMyFansViewController alloc] init];
        myFansViewController.userNoodleId = user.noodleId;
        [self pushNewVC:myFansViewController animated:YES];
        
    }
}

#pragma -mark ------------OnTabTapDelegate---------

- (void)onTabTapAction:(NSInteger)index {
    if(_tabIndex == index){
        return;
    }
    _tabIndex = index;
    self.currentPageIndex = 0;
    
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
        
        [self loadData];
    }];
    
}

@end
