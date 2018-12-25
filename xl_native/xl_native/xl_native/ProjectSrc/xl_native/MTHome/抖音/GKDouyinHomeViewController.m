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


@interface GKDouyinHomeViewController ()<GKViewControllerPushDelegate>

@property (nonatomic, strong) GKDouyinScrollView  *scrollView;

@property (nonatomic, strong) UIViewController  *searchVC; //左侧Controller
@property (nonatomic, strong) XLPlayerListViewController  *playerVC; //右侧Controller
@property (nonatomic, strong) NSArray  *childVCs;

@end

@implementation GKDouyinHomeViewController

#pragma mark ----------- 懒加载 ----------
- (GKDouyinScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [GKDouyinScrollView new];
        _scrollView.frame = self.view.bounds;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
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

- (UIViewController *)searchVC {
    if (!_searchVC) {
        _searchVC = [GKDouyinHomeSearchViewController new];
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
    }
    return _playerVC;
}


- (void)dealloc {
    NSLog(@"%@ dealloc", NSStringFromClass([self class]));
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    NSLog(@"----------viewDidAppear-------");
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
    // 设置左滑push代理
    self.gk_pushDelegate = self;

}



#pragma mark - GKViewControllerPushDelegate

- (void)pushToNextViewController {
    
    UserInfoViewController *personalVC = [UserInfoViewController new];
    personalVC.fromType = FromTypeHome;
    personalVC.userNoodleId = self.playerVC.currentCell.listModel.noodleId;
    [self pushNewVC:personalVC animated:YES];
}

@end
