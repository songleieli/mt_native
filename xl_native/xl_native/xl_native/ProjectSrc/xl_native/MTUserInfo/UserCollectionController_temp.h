//
//  GKDouyinHomeSearchViewController.h
//  GKNavigationBarViewControllerDemo
//
//  Created by gaokun on 2018/9/11.
//  Copyright © 2018年 gaokun. All rights reserved.
//

#import "HomeSearchResultSubViewController.h"
#import "NetWork_mt_getHotSearchSix.h"
#import "HYPageView.h"

//转场动画
#import "ScalePresentAnimation.h"
#import "SwipeLeftInteractiveTransition.h"
#import "ScaleDismissAnimation.h"

@interface UserCollectionController_temp : ZJBaseViewController<HYPageViewDelegate,
UIViewControllerTransitioningDelegate>

//Controller 转场动画
@property (nonatomic, strong) ScalePresentAnimation            *scalePresentAnimation;
@property (nonatomic, strong) ScaleDismissAnimation            *scaleDismissAnimation;
@property (nonatomic, strong) SwipeLeftInteractiveTransition   *swipeLeftInteractiveTransition;

//head
@property(nonatomic,strong) HYPageView *pageView;

@end
