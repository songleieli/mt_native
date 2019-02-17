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
@property (nonatomic, assign) NSInteger                        pageIndex;
@property (nonatomic, assign) NSInteger                        pageSize;

@property (nonatomic, strong) NSMutableArray          *favoriteAwemes;

@end

@implementation MusicInfoController

#pragma -mark ---------- 懒加载页面元素 -------------

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
    _pageIndex = 1;
    _pageSize = 20;
    _tabIndex = 0;
    
    _scalePresentAnimation = [ScalePresentAnimation new];
    _scaleDismissAnimation = [ScaleDismissAnimation new];
    _swipeLeftInteractiveTransition = [SwipeLeftInteractiveTransition new];
    
    [super viewDidLoad];
    [self setUpUI];
}

-(void)initNavTitle{
    self.isNavBackGroundHiden  = NO;
    self.lableNavTitle.textColor = [UIColor whiteColor];
    self.lableNavTitle.font = [UIFont defaultBoldFontWithSize:16];
    
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
        [wself loadData:wself.pageIndex pageSize:wself.pageSize];
    }];
    [_collectionView addSubview:_loadMore];
}

#pragma -mark ----------HTTP data request----------

- (void)loadData:(NSInteger)pageIndex pageSize:(NSInteger)pageSize {
    
//    //过滤topic携带的 “#” 号，接口不需要
//    NSString *topicNameTemp = self.musicId;
//    NSUInteger location = [topicNameTemp rangeOfString:@"#"].location;
//    if (location == NSNotFound) {
//    } else {
//        topicNameTemp = [topicNameTemp substringFromIndex:1];
//    }

    NetWork_mt_getHotVideosByMusic *request = [[NetWork_mt_getHotVideosByMusic alloc] init];
    request.currentNoodleId = [GlobalData sharedInstance].loginDataModel.noodleId;
    request.musicId = self.musicId;
    request.pageNo = [NSString stringWithFormat:@"%ld",pageIndex];
    request.pageSize = [NSString stringWithFormat:@"%ld",pageSize];
    [request startGetWithBlock:^(GetHotVideosByMusicResponse *result, NSString *msg, BOOL finished) {
        
        if(finished){
            self.pageIndex++;
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
            if(self.favoriteAwemes.count < pageSize || result.obj.videoList.count == 0) {
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
    
        self.selectIndex = indexPath.row;
        UserInfoPlayerListViewController *controller;
        controller = [[UserInfoPlayerListViewController alloc] initWithVideoData:self.favoriteAwemes currentIndex:self.selectIndex pageIndex:self.pageIndex pageSize:self.pageSize videoType:VideoTypeFavourites];
        controller.transitioningDelegate = self;
    
        controller.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        self.modalPresentationStyle = UIModalPresentationCurrentContext;
        [_swipeLeftInteractiveTransition wireToViewController:controller];
        [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark --------------- UIViewControllerTransitioningDelegate Delegate  Controller 之间的转场动画 -----------------

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return _scalePresentAnimation;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return _scaleDismissAnimation;
}

-(id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    return _swipeLeftInteractiveTransition.interacting ? _swipeLeftInteractiveTransition : nil;
}

#pragma -mark ------------ TopicHeadDelegate ---------

-(void)btnCollectionClick:(GetHotVideosByMusicModel*)model{
    NSLog(@"--------点击收藏按钮-------");
//    CollectionTopicContentModel *contentModel = [[CollectionTopicContentModel alloc] init];
//    contentModel.topicName = model.topic;
//    contentModel.topicId = [NSString stringWithFormat:@"%@",model.id];
//    contentModel.noodleId = [GlobalData sharedInstance].loginDataModel.noodleId;
//
//    NetWork_mt_collectionTopic *request = [[NetWork_mt_collectionTopic alloc] init];
//    request.currentNoodleId = [GlobalData sharedInstance].loginDataModel.noodleId;
//    request.content = [contentModel generateJsonStringForProperties];
//    [request startPostWithBlock:^(id result, NSString *msg, BOOL finished) {
//
//        [UIWindow showTips:msg];
////        if(finished){
////
//////            self.topicModel.isCollect = [];
////
//////            [self.topicHeader initData:self.topicModel];
////            //[header initData:_topicModel];
////
////
////        }
//    }];
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
