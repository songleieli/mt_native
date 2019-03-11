//
//  GKDouyinHomeSearchViewController.m
//  GKNavigationBarViewControllerDemo
//
//  Created by gaokun on 2018/9/11.
//  Copyright © 2018年 songleilei. All rights reserved.
//

#import "UserCollectionSubVideoViewController.h"

NSString * const userCollectionSubVideoCollectionCell_Temp  = @"userCollectionSubVideoCollectionCell_Temp";


@interface UserCollectionSubVideoViewController ()

@property (nonatomic, assign) CGFloat                          itemWidth;
@property (nonatomic, assign) CGFloat                          itemHeight;

@property (nonatomic, assign) NSInteger                        tabIndex;
@property (nonatomic, assign) NSInteger                        pageIndex;
@property (nonatomic, assign) NSInteger                        pageSize;

@property (nonatomic, strong) NSMutableArray          *workAwemes;

@property (nonatomic, strong) UICollectionView        *collectionView;


@end

@implementation UserCollectionSubVideoViewController


-(NSMutableArray*)favoriteAwemes{
    if(!_favoriteAwemes){
        _favoriteAwemes = [[NSMutableArray alloc] init];
    }
    return _favoriteAwemes;
}

-(void)dealloc{
    
    NSLog(@"---------------%@ dealloc ",NSStringFromClass([self class]));
}

-(void)initNavTitle{
    self.isNavBackGroundHiden  = YES;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //test
    [self onNetworkStatusChange:nil];// 模仿抖音Demo中，的网络变化，加载数据
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _pageIndex = 1;
    _pageSize = 20;
    _tabIndex = 0;
    
    [self setUpUI];
}

-(void)setUpUI{
    self.view.backgroundColor = ColorThemeBackground;
    //根据当前屏幕宽度j计算，item 宽度
    _itemWidth = (ScreenWidth - 2) / 2.0f;
    _itemHeight = _itemWidth * 1.35f; //高度为宽度的1.35倍
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 1.5;     //行间距
    layout.minimumInteritemSpacing = 0;  //列间距
    
    //行间距与列间距配合 _itemWidth _itemHeight 达到布局的效果
    CGFloat hyPageHeight = 44.0f;
    NSInteger tableViewHeight = ScreenHeight - kNavBarHeight_New - hyPageHeight;

    
    CGRect frame = CGRectMake(0, 0, ScreenWidth, tableViewHeight);
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
    [_collectionView registerClass:[SearchResultSubVideoCollectionCell class] forCellWithReuseIdentifier:userCollectionSubVideoCollectionCell_Temp];
    [self.view addSubview:_collectionView];
    
    
    _loadMore = [[LoadMoreControl alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50) surplusCount:15];
    [_loadMore startLoading];
    __weak __typeof(self) wself = self;
    [_loadMore setOnLoad:^{
        [wself loadData:wself.pageIndex pageSize:wself.pageSize];
    }];
    [_collectionView addSubview:_loadMore];
}

#pragma -mark ------------   request netWork

- (void)loadData:(NSInteger)pageIndex pageSize:(NSInteger)pageSize {
    
    //test, 查看测试收藏的视频列表
    NetWork_mt_getVideoCollections *request = [[NetWork_mt_getVideoCollections alloc] init];
    request.currentNoodleId = [GlobalData sharedInstance].loginDataModel.noodleId;
    request.noodleId = [GlobalData sharedInstance].loginDataModel.noodleId;
    request.pageNo = [NSString stringWithFormat:@"%ld",pageIndex];
    request.pageSize = [NSString stringWithFormat:@"%ld",pageSize];
    
    [request startGetWithBlock:^(id result, NSString *msg) {
        /*暂不考虑缓存的问题*/
    } finishBlock:^(GetVideoCollectionsResponse *result, NSString *msg, BOOL finished) {
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
            if(result.obj.count < pageSize || self.favoriteAwemes.count == 0) {
                [self.loadMore loadingAll];
            }
        }
        else{
            [UIWindow showTips:@"获取列表失败，请检查网络"];
        }
    }];
}

#pragma -mark ------------   UICollectionViewDataSource Delegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.favoriteAwemes.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SearchResultSubVideoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:userCollectionSubVideoCollectionCell_Temp forIndexPath:indexPath];
    HomeListModel *aweme= [self.favoriteAwemes objectAtIndex:indexPath.row];
    [cell initData:aweme withKeyWord:@""];
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
    
    if ([self.delegate respondsToSelector:@selector(subCellVideoClick:selectIndex:)]) {
        [self.delegate subCellVideoClick:self.favoriteAwemes selectIndex:indexPath.row];
    } else {
        NSLog(@"代理没响应，快开看看吧");
    }
}

//网络状态发送变化
-(void)onNetworkStatusChange:(NSNotification *)notification {
    
    [self loadData:_pageIndex pageSize:_pageSize];
}


@end
