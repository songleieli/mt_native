//
//  GKDouyinHomeViewController.m
//  GKNavigationBarViewControllerDemo
//
//  Created by gaokun on 2018/9/11.
//  Copyright © 2018年 gaokun. All rights reserved.
//

#import "GKDouyinHomeViewController.h"
#import "GKDouyinHomeSearchViewController.h"
#import "XLPlayerListViewController.h"
#import "UserInfoViewController.h"
#import "GKDouyinScrollView.h"


@interface GKDouyinHomeViewController ()<GKViewControllerPushDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) GKDouyinScrollView  *scrollView;

@property (nonatomic, strong) GKDouyinHomeSearchViewController  *searchVC; //左侧Controller
@property (nonatomic, strong) XLPlayerListViewController  *playerVC; //右侧Controller
@property (nonatomic, strong) NSArray  *childVCs;

@end

@implementation GKDouyinHomeViewController

#pragma mark ----------- 懒加载 ----------
- (GKDouyinScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[GKDouyinScrollView alloc] init];
        _scrollView.frame = self.view.bounds;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.bounces = NO; // 禁止弹簧效果
        _scrollView.isPanUse = YES; //默认可以向右滑动
        if (@available(iOS 11.0, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
    }
    return _scrollView;
}

- (GKDouyinHomeSearchViewController *)searchVC {
    
    if (!_searchVC) {
        __weak __typeof(self) weakSelf = self;
        _searchVC = [[GKDouyinHomeSearchViewController alloc] init];
        _searchVC.backClickBlock = ^{
            CGFloat w = weakSelf.view.frame.size.width;
            [weakSelf.scrollView setContentOffset:CGPointMake(w, 0) animated:YES];
            //视频播放列表显示
            [weakSelf playListViewControllerDidAppear];
        };
    }
    return _searchVC;
}

- (XLPlayerListViewController *)playerVC {
    if (!_playerVC) {
        
        __weak __typeof(self) weakSelf = self;
        _playerVC = [XLPlayerListViewController new];
        _playerVC.scrollBlock = ^(BOOL isScroll) {
            //视频列表在滚动的过程中，不能左右滑动显示，搜索页面
            weakSelf.scrollView.isPanUse = !isScroll;
        };
        _playerVC.seachClickBlock = ^{
            
            [weakSelf.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            //搜索页面显示
            [weakSelf searchViewControllerDidAppear];
        };
    }
    return _playerVC;
}


- (void)dealloc {
    NSLog(@"%@ dealloc", NSStringFromClass([self class]));
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    /*
        1.根据当前页面显示的是，视频播放列表，还是搜索页面
        2.如果是视频播放列表，隐藏状态栏
        3.如果是搜索页面，显示状态栏
     */
    if(self.isTableHiden){ //搜索页面
        [UIApplication sharedApplication].statusBarHidden = NO;
    }
    else{//视频播放列表页面
        [UIApplication sharedApplication].statusBarHidden = YES;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSLog(@"%@ -----viewWillAppear-----------", NSStringFromClass([self class]));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*左右侧滑代码*/
    [self.view addSubview:self.scrollView];
    self.childVCs = @[self.searchVC, self.playerVC];
    
    CGFloat w = self.view.frame.size.width;
    CGFloat h = self.view.frame.size.height;
    [self.childVCs enumerateObjectsUsingBlock:^(UIViewController *vc, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [self addChildViewController:vc];
        [self.scrollView addSubview:vc.view];
        vc.view.frame = CGRectMake(idx * w, 0, w, h);
    }];
    
    self.scrollView.contentSize = CGSizeMake(self.childVCs.count * w, 0);
    // 默认显示播放器页
    self.scrollView.contentOffset = CGPointMake(w, 0);
    //显示播放器的时候隐藏状态栏
    [UIApplication sharedApplication].statusBarHidden = YES;
    // 设置左滑push代理
    self.gk_pushDelegate = self;
    
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(move:)];
//   [self.scrollView addGestureRecognizer:pan];
}

//- (void)move:(UIPanGestureRecognizer *)pan {
//
//   CGPoint point = [pan locationInView:self.scrollView];//self.view是手势作用在哪个view上。以父 view左上角为原点；
//    CGPoint transPoint = [pan translationInView:self.scrollView];//以自身的左上角为原点；每次移动后，原点都置0；计算的是相对于上一个位置的偏移；
//   NSLog(@"locationInView:%f--%f\n -- translationInView:%f--%f",point.x,point.y,transPoint.x,transPoint.y);
//}

#pragma mark ----------- CustomMethod ----------


-(void)searchViewControllerDidAppear{
    
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [UIApplication sharedApplication].statusBarHidden = NO;
    [self hiddenTabBar:YES isAnimat:YES]; //隐藏tablebar
    [self.playerVC playListCurrPlayDisAppear];
}

-(void)playListViewControllerDidAppear{
    [UIApplication sharedApplication].statusBarHidden = YES;
    [self hiddenTabBar:NO isAnimat:YES]; //显示tablebar
    [self.playerVC playListCurrPlayDidAppear];
}


#pragma mark - GKViewControllerPushDelegate

- (void)pushToNextViewController {
    
    UserInfoViewController *personalVC = [UserInfoViewController new];
    personalVC.fromType = FromTypeHome;
    personalVC.userNoodleId = self.playerVC.currentCell.listModel.noodleId;
    [self pushNewVC:personalVC animated:YES];
}

#pragma mark --------------- UIScrollView 代理 -----------------


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"----scrollViewDidScroll-----");
    CGFloat w = self.view.frame.size.width;

    self.scrollView.contentOffset = CGPointMake(w, 0);

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    CGPoint rect = scrollView.contentOffset;
    CGFloat w = self.view.frame.size.width;
    if(rect.x == 0.0f){ //搜索页面，显示完成
        [self searchViewControllerDidAppear];
    }
    else if(rect.x == w){//视频播放列表显示完成
        [self playListViewControllerDidAppear];
    }
}

@end
