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
}

-(void)dealloc{
    /*
     *移除页面中的观察者
     */
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

#pragma mark ------ CustomMethod  ------

-(void)setupUI{
    
//    self.view.backgroundColor = ColorThemeBackground;
    
    //根据当前屏幕宽度j计算，item 宽度
    _itemWidth = (ScreenWidth - 3) / 3.0f;
    _itemHeight = _itemWidth * 1.35f; //高度为宽度的1.35倍
    
    //SafeAreaTopHeight + kSlideTabBarHeight 为固定的高度
    VideoViewFlowLayout *layout = [[VideoViewFlowLayout alloc] initWithTopHeight:SafeAreaTopHeight + kSlideTabBarHeight];
    layout.minimumLineSpacing = 1.5;     //行间距
    layout.minimumInteritemSpacing = 0;  //列间距
    
//    CGRect frame = CGRectZero;
//    if(self.fromType == FromTypeMy){
//        frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight  - kTabBarHeight_New);
//    }
//    else{
//        frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
//    }
    
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
    
    [self.view addSubview:self.collectionView];

}

-(void)changeViewAreaClick{
    
    MTChangeViewAreaViewController *changeViewAreaViewController = [[MTChangeViewAreaViewController alloc] init];
    [self pushNewVC:changeViewAreaViewController animated:YES];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 100;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    VideoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[VideoCollectionViewCell registerCellID] forIndexPath:indexPath];
    
    cell.contentView.backgroundColor = [UIColor yellowColor];
    
    
    if (![cell.contentView viewWithTag:100]) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        label.tag = 100;
        label.textColor = [UIColor redColor];
        label.font = [UIFont boldSystemFontOfSize:17];
        [cell.contentView addSubview:label];
    }
    
    UILabel *label = [cell.contentView viewWithTag:100];
    
    label.text = [NSString stringWithFormat:@"%zd", indexPath.item];
    
    
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
//    self.selectIndex = indexPath.row;
//
//    ScrollPlayerListViewController *playerListViewController;
//    if(_tabIndex == 0){ //我的作品
//        playerListViewController = [[ScrollPlayerListViewController alloc] initWithVideoData:self.workAwemes currentIndex:self.selectIndex];
//    }
//    else if (_tabIndex == 1){ //动态
//        playerListViewController = [[ScrollPlayerListViewController alloc] initWithVideoData:self.dynamicAwemes currentIndex:self.selectIndex];
//
//    }
//    else{//喜欢
//        playerListViewController = [[ScrollPlayerListViewController alloc] initWithVideoData:self.favoriteAwemes currentIndex:self.selectIndex];
//
//    }
//    [self pushNewVC:playerListViewController animated:YES];
}


@end
