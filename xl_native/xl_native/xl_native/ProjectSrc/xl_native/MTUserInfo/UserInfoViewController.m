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
@property (nonatomic, strong) NSMutableArray<Aweme *>          *workAwemes;
@property (nonatomic, strong) NSMutableArray<Aweme *>          *favoriteAwemes;


@end

@implementation UserInfoViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    /*
     以下两行顺序不能乱，statusBarHidden的状态，会影响对刘海的判断，所以 self.tabBar.top = [self getTabbarTop]; 应该放在
     */
    [UIApplication sharedApplication].statusBarHidden = NO;
    self.tabBar.top = [self getTabbarTop];    //  重新设置tabbar的高度
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    //test
    [self onNetworkStatusChange:nil];// 模仿抖音Demo中，的网络变化，加载数据
}

- (void)viewDidLoad {
    
    _workAwemes = [[NSMutableArray alloc]init];
    _favoriteAwemes = [[NSMutableArray alloc]init];
    _pageIndex = 0;
    _pageSize = 10;
    
    _tabIndex = 0;
    
    
    [super viewDidLoad];
    [self loadUserData];
    [self setUpUI];
    
}

-(void)initNavTitle{
    self.isNavBackGroundHiden  = YES;
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
    
    NSDictionary *dic =  [NSString readJson2DicWithFileName:@"user"];
    
    UserResponse *response = [[UserResponse alloc] initWithDictionary:dic];
    self.user = response.data;
    [self setTitle:self.user.nickname];
    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
    NSLog(@"------");

    
    
//    __weak typeof (self) wself = self;
//    UserRequest *request = [UserRequest new];
//    request.uid = _uid;
//    [NetworkHelper getWithUrlPath:FindUserByUidPath request:request success:^(id data) {
//        UserResponse *response = [[UserResponse alloc] initWithDictionary:data error:nil];
//        wself.user = response.data;
//        [wself setTitle:self.user.nickname];
//        [wself.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
//    } failure:^(NSError *error) {
//        [UIWindow showTips:error.description];
//    }];
}


- (void)loadData:(NSInteger)pageIndex pageSize:(NSInteger)pageSize {
    
    if(_tabIndex == 0){
        
        NSDictionary *dic =  [NSString readJson2DicWithFileName:@"awemes"];  //作品
        AwemesResponse *awemesResponse = [[AwemesResponse alloc] initWithDictionary:dic];
        self.pageIndex++;
        
        NSArray<Aweme *> *array = awemesResponse.data;
        self.pageIndex++;
        
        [UIView setAnimationsEnabled:NO];
        [self.collectionView performBatchUpdates:^{
            [self.workAwemes addObjectsFromArray:array];
            NSMutableArray<NSIndexPath *> *indexPaths = [NSMutableArray array];
            for(NSInteger row = self.workAwemes.count - array.count; row<self.workAwemes.count; row++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:1];
                [indexPaths addObject:indexPath];
            }
            [self.collectionView insertItemsAtIndexPaths:indexPaths];
        } completion:^(BOOL finished) {
            [UIView setAnimationsEnabled:YES];
        }];
        
        [self.loadMore endLoading];
    }
    else{
        
    }

    NSLog(@"----------");
    /*
    
    AwemeListRequest *request = [AwemeListRequest new];
    request.page = pageIndex;
    request.size = pageSize;
    request.uid = _uid;
    __weak typeof (self) wself = self;
    if(_tabIndex == 0) {
        [NetworkHelper getWithUrlPath:FindAwemePostByPagePath request:request success:^(id data) {
            if(wself.tabIndex != 0) {
                return;
            }
            AwemeListResponse *response = [[AwemeListResponse alloc] initWithDictionary:data error:nil];
            NSArray<Aweme *> *array = response.data;
            wself.pageIndex++;
            
            [UIView setAnimationsEnabled:NO];
            [wself.collectionView performBatchUpdates:^{
                [wself.workAwemes addObjectsFromArray:array];
                NSMutableArray<NSIndexPath *> *indexPaths = [NSMutableArray array];
                for(NSInteger row = wself.workAwemes.count - array.count; row<wself.workAwemes.count; row++) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:1];
                    [indexPaths addObject:indexPath];
                }
                [wself.collectionView insertItemsAtIndexPaths:indexPaths];
            } completion:^(BOOL finished) {
                [UIView setAnimationsEnabled:YES];
            }];
            
            [wself.loadMore endLoading];
            if(!response.has_more) {
                [wself.loadMore loadingAll];
            }
        } failure:^(NSError *error) {
            [wself.loadMore loadingFailed];
        }];
    }else {
        [NetworkHelper getWithUrlPath:FindAwemeFavoriteByPagePath request:request success:^(id data) {
            if(wself.tabIndex != 1) {
                return;
            }
            AwemeListResponse *response = [[AwemeListResponse alloc] initWithDictionary:data error:nil];
            NSArray<Aweme *> *array = response.data;
            wself.pageIndex++;
            
            [UIView setAnimationsEnabled:NO];
            [wself.collectionView performBatchUpdates:^{
                [wself.favoriteAwemes addObjectsFromArray:array];
                NSMutableArray<NSIndexPath *> *indexPaths = [NSMutableArray array];
                for(NSInteger row = wself.favoriteAwemes.count - array.count; row<wself.favoriteAwemes.count; row++) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:1];
                    [indexPaths addObject:indexPath];
                }
                [wself.collectionView insertItemsAtIndexPaths:indexPaths];
            } completion:^(BOOL finished) {
                [UIView setAnimationsEnabled:YES];
            }];
            
            [wself.loadMore endLoading];
            if(!response.has_more) {
                [wself.loadMore loadingAll];
            }
        } failure:^(NSError *error) {
            [wself.loadMore loadingFailed];
        }];
    }
    */
    
}


//- (void)updateNavigationTitle:(CGFloat)offsetY {
//    if (kUserInfoHeaderHeight - [self navagationBarHeight]*2 > offsetY) {
//        [self setNavigationBarTitleColor:ColorClear];
//    }
//    if (kUserInfoHeaderHeight - [self navagationBarHeight]*2 < offsetY && offsetY < kUserInfoHeaderHeight - [self navagationBarHeight]) {
//        CGFloat alphaRatio =  1.0f - (kUserInfoHeaderHeight - [self navagationBarHeight] - offsetY)/[self navagationBarHeight];
//        [self setNavigationBarTitleColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:alphaRatio]];
//    }
//    if (offsetY > kUserInfoHeaderHeight - [self navagationBarHeight]) {
//        [self setNavigationBarTitleColor:ColorWhite];
//    }
//}

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
        return _tabIndex == 0 ? _workAwemes.count : _favoriteAwemes.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AwemeCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kAwemeCollectionCell forIndexPath:indexPath];
    Aweme *aweme;
    if(_tabIndex == 0) {
        aweme = [_workAwemes objectAtIndex:indexPath.row];
    }else {
        aweme = [_favoriteAwemes objectAtIndex:indexPath.row];
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

//UIScrollViewDelegate Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY < 0) {
        [_userInfoHeader overScrollAction:offsetY];
    }else {
        [_userInfoHeader scrollToTopAction:offsetY];
//        [self updateNavigationTitle:offsetY];
    }
}


//网络状态发送变化
-(void)onNetworkStatusChange:(NSNotification *)notification {
//    if(![NetworkHelper isNotReachableStatus:[NetworkHelper networkStatus]]) {
        if(_user == nil) {
            [self loadUserData];
        }
        if(_favoriteAwemes.count == 0 && _workAwemes.count == 0) {
            [self loadData:_pageIndex pageSize:_pageSize];
        }
//    }
}


@end
